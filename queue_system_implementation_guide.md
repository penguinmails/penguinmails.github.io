# Queue System Implementation Guide

## Document Summary
This comprehensive guide provides detailed implementation instructions for PenguinMails' hybrid PostgreSQL + Redis queue system. It covers architecture patterns, code examples, deployment procedures, and best practices for building a reliable, scalable job processing system.

---

## Overview

### Hybrid Architecture Benefits
- **PostgreSQL**: Durable record of truth with comprehensive audit trail
- **Redis**: High-performance job processing with millisecond latency
- **Queuer Process**: Automated migration from PostgreSQL to Redis
- **Worker Servers**: Horizontal scaling with multiple concurrent workers
- **Priority Queues**: Separate queues for high/normal/low priority jobs

### System Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Next.js API   │    │   Queuer Proc   │    │  Worker Server  │
│   (Producer)    │    │   (Migrator)    │    │   (Consumer)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │ Insert Job            │                       │
         ↓                       │                       │
┌─────────────────┐              │                       │
│  PostgreSQL     │              │                       │
│  Jobs Table     │              │                       │
│  (Durable)      │              │                       │
└─────────────────┘              │                       │
         │                       │ Query Ready Jobs     │
         │                       ↓                       │
         │              ┌─────────────────┐              │
         │              │   Migrate to    │              │
         │              │     Redis       │              │
         │              └─────────────────┘              │
         │                       │                       │
         │                       │ LPUSH to Queue       │
         └───────────────────────┼───────────────────────┘
                                 ↓
                        ┌─────────────────┐
                        │   Redis List    │
                        │   (Fast Queue)  │
                        └─────────────────┘
                                 │
                                 │ BRPOP
                                 ↓
                        ┌─────────────────┐
                        │   Worker Proc   │
                        │   (Consumer)    │
                        └─────────────────┘
```

---

## Implementation Components

### 1. PostgreSQL Job Management (Durable State)

#### Job Tables Schema
```sql
-- Job queues configuration
CREATE TABLE job_queues (
    name VARCHAR(100) PRIMARY KEY,
    default_priority INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Jobs table (Permanent State)
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    queue_name VARCHAR(100) REFERENCES job_queues(name) ON DELETE CASCADE,
    status VARCHAR(50) DEFAULT 'queued',
    priority INTEGER DEFAULT 100,
    payload JSONB NOT NULL,
    attempt_count INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    run_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    failed_at TIMESTAMP WITH TIME ZONE,
    last_error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Job execution logs (Audit Trail)
CREATE TABLE job_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    status VARCHAR(50) NOT NULL,
    log_message TEXT,
    attempt_number INTEGER NOT NULL,
    started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    finished_at TIMESTAMP WITH TIME ZONE,
    duration INTERVAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Analytics jobs tracking (for OLAP pipeline)
CREATE TABLE analytics_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_type VARCHAR(100) NOT NULL,
    status VARCHAR(50) DEFAULT 'queued',
    payload JSONB NOT NULL,
    priority INTEGER DEFAULT 100,
    queued_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    processed_at TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Performance Indexes
```sql
-- Queuer process optimization
CREATE INDEX idx_jobs_queuer ON jobs(status, run_at, priority, created_at) 
WHERE status = 'queued';

-- Queue-specific migration
CREATE INDEX idx_jobs_queue_migration ON jobs(queue_name, status, run_at, priority)
WHERE status = 'queued';

-- Audit and analytics
CREATE INDEX idx_jobs_status_timestamps ON jobs(status, updated_at, queue_name);
CREATE INDEX idx_job_logs_worker ON job_logs(job_id, attempt_number, finished_at);
CREATE INDEX idx_analytics_jobs_type_status ON analytics_jobs(job_type, status, queued_at);
```

### 2. Redis Queue Structure (Fast Processing)

#### Queue Naming Convention
```typescript
const QueueNames = {
  EMAIL_SENDING: 'queue:email-sending',
  EMAIL_SENDING_HIGH: 'queue:email-sending:high',
  EMAIL_SENDING_NORMAL: 'queue:email-sending',
  EMAIL_SENDING_LOW: 'queue:email-sending:low',
  
  ANALYTICS_DAILY: 'queue:analytics:daily-aggregate',
  ANALYTICS_CAMPAIGN: 'queue:analytics:campaign-aggregate',
  ANALYTICS_BILLING: 'queue:analytics:billing-calculate',
  
  WARMUP_PROCESSING: 'queue:warmup:process',
  BOUNCE_PROCESSING: 'queue:bounce:process',
  WEBHOOK_PROCESSING: 'queue:webhook:process'
} as const;
```

#### Redis Data Structures

**A. Lists (Primary Job Queues)**
```typescript
// Job payload structure in Redis lists
interface RedisJobPayload {
  id: string;                    // PostgreSQL job ID
  queue_name: string;
  priority: number;
  payload: any;                  // Job-specific data
  created_at: string;            // ISO timestamp
  attempt_count: number;         // Current attempt
  max_attempts: number;          // Maximum retries
}

// Example job in queue
const exampleJob = {
  id: "uuid-job-123",
  queue_name: "email-sending",
  priority: 75,
  payload: {
    campaign_id: "uuid-campaign",
    lead_id: "uuid-lead", 
    email_data: { /* email content */ }
  },
  created_at: "2025-10-30T09:00:00Z",
  attempt_count: 0,
  max_attempts: 3
};
```

**B. Hashes (Job Metadata)**
```typescript
// Redis hash for real-time job tracking
interface JobMetadata {
  status: 'queued' | 'processing' | 'completed' | 'failed';
  worker_id: string;             // Worker processing this job
  started_at: string;            // ISO timestamp
  completed_at?: string;         // ISO timestamp
  last_error?: string;           // Error message if failed
  attempt_count: number;         // Current attempt number
}

// Example Redis hash
// Key: job:uuid-job-123
// Fields:
// status: "processing"
// worker_id: "worker-1"
// started_at: "2025-10-30T09:01:00Z"
// attempt_count: "1"
```

### 3. Queuer Process Implementation

#### Core Queuer Service
```typescript
// services/JobMigrator.ts
import Redis from 'ioredis';
import { Database } from './Database';

export class JobMigrator {
  private redis: Redis;
  private db: Database;
  private isRunning = false;
  private batchSize = 100;
  private migrationInterval = 5000; // 5 seconds

  constructor(redis: Redis, db: Database) {
    this.redis = redis;
    this.db = db;
  }

  async start() {
    this.isRunning = true;
    console.log('Job migrator started');
    
    while (this.isRunning) {
      try {
        await this.migrateReadyJobs();
        await this.delay(this.migrationInterval);
      } catch (error) {
        console.error('Job migration error:', error);
        await this.delay(10000); // Wait 10 seconds on error
      }
    }
  }

  stop() {
    this.isRunning = false;
    console.log('Job migrator stopped');
  }

  private async migrateReadyJobs() {
    const jobs = await this.db.jobs.findMany({
      where: {
        status: 'queued',
        run_at: { lte: new Date() }
      },
      orderBy: [
        { priority: 'asc' },
        { created_at: 'asc' }
      ],
      take: this.batchSize
    });

    if (jobs.length === 0) {
      return;
    }

    console.log(`Migrating ${jobs.length} jobs to Redis`);

    for (const job of jobs) {
      try {
        await this.migrateJob(job);
      } catch (error) {
        console.error(`Failed to migrate job ${job.id}:`, error);
      }
    }
  }

  private async migrateJob(job: any) {
    const queueName = this.getQueueName(job);
    const redisPayload = {
      id: job.id,
      queue_name: job.queue_name,
      priority: job.priority,
      payload: job.payload,
      created_at: job.created_at,
      attempt_count: job.attempt_count,
      max_attempts: job.max_attempts
    };

    // Push to Redis queue
    await this.redis.lpush(queueName, JSON.stringify(redisPayload));

    // Initialize Redis hash for tracking
    await this.redis.hset(`job:${job.id}`, {
      status: 'migrated',
      queued_at: new Date().toISOString(),
      attempt_count: job.attempt_count.toString()
    });

    // Update PostgreSQL status
    await this.db.jobs.update({
      where: { id: job.id },
      data: { 
        status: 'migrated_to_redis',
        updated_at: new Date()
      }
    });

    // Prevent duplicates with Redis Set
    await this.redis.sadd(`recent_jobs:${job.queue_name}`, job.id);
    await this.redis.expire(`recent_jobs:${job.queue_name}`, 3600); // 1 hour TTL
  }

  private getQueueName(job: any): string {
    const { priority, queue_name } = job;
    
    // Priority-based routing
    if (priority <= 50) return `${queue_name}:high`;
    if (priority <= 150) return queue_name;
    return `${queue_name}:low`;
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

### 4. Worker Server Implementation

#### Worker Process
```typescript
// workers/EmailWorker.ts
import Redis from 'ioredis';
import { Database } from './Database';
import { EmailService } from './EmailService';

export class EmailWorker {
  private redis: Redis;
  private db: Database;
  private emailService: EmailService;
  private workerId: string;
  private isRunning = false;

  constructor(redis: Redis, db: Database, emailService: EmailService) {
    this.redis = redis;
    this.db = db;
    this.emailService = emailService;
    this.workerId = `worker-${process.env.WORKER_ID || Math.random().toString(36).substr(2, 9)}`;
  }

  async start() {
    this.isRunning = true;
    console.log(`Worker ${this.workerId} started`);

    // Listen to all priority queues
    const queues = [
      'queue:email-sending:high',
      'queue:email-sending',
      'queue:email-sending:low',
      'queue:warmup:process',
      'queue:bounce:process'
    ];

    while (this.isRunning) {
      try {
        // Blocking pop with priority ordering
        const result = await this.redis.brpop(queues, 0);
        
        if (!result) {
          continue;
        }

        const [queueName, jobData] = result;
        const job = JSON.parse(jobData);

        await this.processJob(job, queueName);
      } catch (error) {
        console.error(`Worker ${this.workerId} error:`, error);
        await this.delay(1000);
      }
    }
  }

  stop() {
    this.isRunning = false;
    console.log(`Worker ${this.workerId} stopped`);
  }

  private async processJob(job: any, queueName: string) {
    const { id, payload } = job;
    
    try {
      console.log(`Processing job ${id} from ${queueName}`);

      // Update PostgreSQL status
      await this.db.jobs.update({
        where: { id },
        data: { 
          status: 'running',
          started_at: new Date(),
          updated_at: new Date()
        }
      });

      // Update Redis hash for real-time tracking
      await this.redis.hset(`job:${id}`, {
        status: 'processing',
        worker_id: this.workerId,
        started_at: new Date().toISOString()
      });

      // Execute the job based on queue type
      if (queueName.includes('email-sending')) {
        await this.emailService.sendEmail(payload);
      } else if (queueName.includes('warmup')) {
        await this.processWarmupJob(payload);
      } else if (queueName.includes('bounce')) {
        await this.processBounceJob(payload);
      } else {
        throw new Error(`Unknown queue type: ${queueName}`);
      }

      // Update completion status
      await this.db.jobs.update({
        where: { id },
        data: { 
          status: 'completed',
          completed_at: new Date(),
          updated_at: new Date()
        }
      });

      await this.redis.hset(`job:${id}`, {
        status: 'completed',
        completed_at: new Date().toISOString()
      });

      // Log successful execution
      await this.logJobExecution(id, 'success', null);

      console.log(`Job ${id} completed successfully`);

    } catch (error) {
      await this.handleJobFailure(id, error);
    }
  }

  private async handleJobFailure(job: any, error: Error) {
    const { id, max_attempts, attempt_count = 0 } = job;
    
    try {
      const attempts = attempt_count + 1;
      
      if (attempts < max_attempts) {
        // Schedule retry with exponential backoff
        const delay = Math.pow(2, attempts) * 1000; // 2s, 4s, 8s, etc.
        
        await this.delay(delay);
        
        // Re-queue the job
        await this.redis.lpush('queue:email-sending', JSON.stringify({
          ...job,
          attempt_count: attempts
        }));

        // Update PostgreSQL
        await this.db.jobs.update({
          where: { id },
          data: { 
            attempt_count: attempts,
            updated_at: new Date()
          }
        });

        await this.redis.hset(`job:${id}`, {
          status: 'retry_scheduled',
          attempt_count: attempts.toString(),
          retry_delay: delay.toString()
        });

      } else {
        // Max attempts reached - mark as failed
        await this.db.jobs.update({
          where: { id },
          data: { 
            status: 'failed',
            failed_at: new Date(),
            last_error_message: error.message,
            updated_at: new Date()
          }
        });

        await this.redis.hset(`job:${id}`, {
          status: 'failed',
          error: error.message,
          failed_at: new Date().toISOString()
        });
      }

      await this.logJobExecution(id, 'failed', error.message);
      console.error(`Job ${id} failed:`, error.message);

    } catch (logError) {
      console.error(`Failed to log job failure for ${id}:`, logError);
    }
  }

  private async logJobExecution(jobId: string, status: string, errorMessage: string | null) {
    try {
      await this.db.jobLogs.create({
        data: {
          job_id: jobId,
          status,
          log_message: errorMessage,
          attempt_number: 1, // This would be dynamic in real implementation
          finished_at: new Date()
        }
      });
    } catch (error) {
      console.error('Failed to log job execution:', error);
    }
  }

  private async processWarmupJob(payload: any) {
    // Implementation for warmup processing
    console.log('Processing warmup job:', payload);
  }

  private async processBounceJob(payload: any) {
    // Implementation for bounce processing  
    console.log('Processing bounce job:', payload);
  }

  private delay(ms: number): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}
```

### 5. Job Creation and Management

#### API Job Creation
```typescript
// api/jobs/create.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { Database } from '../../lib/Database';
import Redis from 'ioredis';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  const { queue_name, payload, priority = 100, run_at, max_attempts = 3 } = req.body;

  try {
    const db = new Database();
    const redis = new Redis(process.env.REDIS_URL!);

    // Create job in PostgreSQL (source of truth)
    const job = await db.jobs.create({
      data: {
        queue_name,
        payload,
        priority,
        run_at: run_at ? new Date(run_at) : new Date(),
        max_attempts,
        status: 'queued'
      }
    });

    // For high-priority jobs, push directly to Redis
    if (priority <= 50) {
      const redisPayload = {
        id: job.id,
        queue_name: job.queue_name,
        priority: job.priority,
        payload: job.payload,
        created_at: job.created_at,
        attempt_count: job.attempt_count,
        max_attempts: job.max_attempts
      };

      await redis.lpush(`${queue_name}:high`, JSON.stringify(redisPayload));
      
      // Update status to migrated
      await db.jobs.update({
        where: { id: job.id },
        data: { status: 'migrated_to_redis' }
      });
    }

    await redis.disconnect();

    res.status(201).json({
      job_id: job.id,
      status: 'created',
      queue_name,
      priority
    });

  } catch (error) {
    console.error('Job creation error:', error);
    res.status(500).json({ error: 'Failed to create job' });
  }
}
```

#### Job Status Tracking
```typescript
// api/jobs/status.ts
import { NextApiRequest, NextApiResponse } from 'next';
import { Database } from '../../lib/Database';
import Redis from 'ioredis';

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  const { job_id } = req.query;

  if (!job_id || typeof job_id !== 'string') {
    return res.status(400).json({ error: 'Job ID required' });
  }

  try {
    const db = new Database();
    const redis = new Redis(process.env.REDIS_URL!);

    // Get job from PostgreSQL
    const job = await db.jobs.findUnique({
      where: { id: job_id }
    });

    if (!job) {
      return res.status(404).json({ error: 'Job not found' });
    }

    // Get real-time status from Redis
    const redisStatus = await redis.hgetall(`job:${job_id}`);

    const response = {
      job_id: job.id,
      queue_name: job.queue_name,
      status: job.status,
      priority: job.priority,
      attempt_count: job.attempt_count,
      max_attempts: job.max_attempts,
      created_at: job.created_at,
      started_at: job.started_at,
      completed_at: job.completed_at,
      failed_at: job.failed_at,
      last_error_message: job.last_error_message,
      redis_status: redisStatus.status || 'not_in_redis',
      worker_id: redisStatus.worker_id || null
    };

    await redis.disconnect();
    res.status(200).json(response);

  } catch (error) {
    console.error('Job status error:', error);
    res.status(500).json({ error: 'Failed to get job status' });
  }
}
```

---

## Deployment and Operations

### Docker Compose Configuration

```yaml
# docker-compose.queue.yml
version: '3.8'
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes --maxmemory 512mb --maxmemory-policy allkeys-lru
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5

  queuer:
    build: 
      context: .
      dockerfile: Dockerfile.queuer
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=redis://redis:6379
      - NODE_ENV=production
    depends_on:
      - redis
      - postgres
    restart: unless-stopped
    volumes:
      - ./logs:/app/logs

  worker:
    build:
      context: .
      dockerfile: Dockerfile.worker
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - REDIS_URL=redis://redis:6379
      - NODE_ENV=production
      - WORKER_ID=${WORKER_ID}
    depends_on:
      - redis
      - postgres
    restart: unless-stopped
    volumes:
      - ./logs:/app/logs
    deploy:
      replicas: 3

volumes:
  redis_data:
```

### Monitoring and Health Checks

#### Queue Health Monitoring
```typescript
// monitoring/QueueHealth.ts
import Redis from 'ioredis';
import { Database } from '../Database';

export class QueueHealthMonitor {
  private redis: Redis;
  private db: Database;

  constructor(redis: Redis, db: Database) {
    this.redis = redis;
    this.db = db;
  }

  async getQueueHealth() {
    const health = {
      timestamp: new Date().toISOString(),
      redis: await this.checkRedisHealth(),
      queues: await this.checkQueueDepths(),
      workers: await this.checkWorkerStatus(),
      jobs: await this.checkJobStats()
    };

    return health;
  }

  private async checkRedisHealth() {
    try {
      const pong = await this.redis.ping();
      const info = await this.redis.info();
      
      return {
        status: 'healthy',
        ping: pong,
        memory_used: this.parseRedisMemory(info),
        connected_clients: this.parseConnectedClients(info)
      };
    } catch (error) {
      return {
        status: 'unhealthy',
        error: error.message
      };
    }
  }

  private async checkQueueDepths() {
    const queues = [
      'queue:email-sending:high',
      'queue:email-sending',
      'queue:email-sending:low',
      'queue:analytics:daily-aggregate',
      'queue:warmup:process'
    ];

    const depths = {};
    
    for (const queue of queues) {
      try {
        const length = await this.redis.llen(queue);
        depths[queue] = length;
      } catch (error) {
        depths[queue] = { error: error.message };
      }
    }

    return depths;
  }

  private async checkWorkerStatus() {
    // Get all job hashes to see which workers are active
    const jobKeys = await this.redis.keys('job:*');
    const workers = new Set();
    
    for (const key of jobKeys.slice(0, 100)) { // Check first 100 jobs
      const workerId = await this.redis.hget(key, 'worker_id');
      if (workerId) {
        workers.add(workerId);
      }
    }

    return {
      active_workers: workers.size,
      worker_ids: Array.from(workers)
    };
  }

  private async checkJobStats() {
    const stats = await this.db.jobs.groupBy({
      by: ['status'],
      _count: { status: true }
    });

    return stats.reduce((acc, stat) => {
      acc[stat.status] = stat._count.status;
      return acc;
    }, {});
  }

  private parseRedisMemory(info: string): string {
    const match = info.match(/used_memory_human:([^\r\n]+)/);
    return match ? match[1] : 'unknown';
  }

  private parseConnectedClients(info: string): number {
    const match = info.match(/connected_clients:(\d+)/);
    return match ? parseInt(match[1]) : 0;
  }
}
```

### Error Handling and Recovery

#### Dead Letter Queue
```typescript
// workers/DeadLetterHandler.ts
import Redis from 'ioredis';
import { Database } from '../Database';

export class DeadLetterHandler {
  private redis: Redis;
  private db: Database;

  constructor(redis: Redis, db: Database) {
    this.redis = redis;
    this.db = db;
  }

  async moveFailedJobsToDeadLetter() {
    const failedJobs = await this.db.jobs.findMany({
      where: {
        status: 'failed',
        updated_at: {
          gte: new Date(Date.now() - 24 * 60 * 60 * 1000) // Last 24 hours
        }
      }
    });

    for (const job of failedJobs) {
      // Check if already in dead letter queue
      const exists = await this.redis.exists(`deadletter:${job.id}`);
      if (exists) continue;

      // Move to dead letter queue
      await this.redis.lpush('deadletter:queue', JSON.stringify({
        id: job.id,
        queue_name: job.queue_name,
        payload: job.payload,
        error: job.last_error_message,
        failed_at: job.failed_at,
        attempt_count: job.attempt_count
      }));

      // Mark as moved to dead letter
      await this.redis.set(`deadletter:${job.id}`, 'moved', 'EX', 604800); // 7 days
    }
  }

  async replayDeadLetterJob(jobId: string) {
    const jobData = await this.redis.lpop('deadletter:queue');
    if (!jobData) {
      throw new Error('No jobs in dead letter queue');
    }

    const job = JSON.parse(jobData);
    
    // Reset job in PostgreSQL
    await this.db.jobs.update({
      where: { id: jobId },
      data: {
        status: 'queued',
        attempt_count: 0,
        last_error_message: null,
        failed_at: null,
        updated_at: new Date()
      }
    });

    // Add back to appropriate queue
    await this.redis.lpush(job.queue_name, JSON.stringify(job));
    
    return { success: true, job_id: jobId };
  }
}
```

---

## Best Practices

### Performance Optimization
1. **Batch Processing**: Process jobs in batches to reduce database round trips
2. **Connection Pooling**: Use connection pools for both PostgreSQL and Redis
3. **Monitoring**: Monitor queue depths and processing times
4. **Resource Limits**: Set memory limits and eviction policies for Redis

### Reliability Patterns
1. **Idempotency**: Ensure job processing is idempotent
2. **Timeout Handling**: Set appropriate timeouts for job processing
3. **Circuit Breakers**: Implement circuit breakers for external service calls
4. **Graceful Shutdown**: Ensure workers can complete current jobs before shutdown

### Security Considerations
1. **Job Validation**: Validate job payloads before processing
2. **Access Control**: Restrict job creation to authorized users
3. **Data Encryption**: Encrypt sensitive data in job payloads
4. **Audit Logging**: Log all job state changes for compliance

---

## Conclusion

This hybrid PostgreSQL + Redis queue system provides the perfect balance of reliability and performance for PenguinMails' job processing needs. The system ensures no job is lost while maintaining high throughput and low latency for job execution.

For questions or support regarding the queue system implementation, contact the Engineering team.

---

**Related Documents:**
- [Database Schema Guide](database_schema_guide.md) - Complete database schema with queue tables
- [Infrastructure Documentation](infrastructure_documentation.md) - Infrastructure setup and deployment
- [Analytics Architecture](analytics_architecture.md) - Analytics pipeline integration

**Keywords**: queue system, redis, postgresql, job processing, worker, migrator, dead letter queue, monitoring