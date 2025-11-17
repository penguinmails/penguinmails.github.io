# Queue System Implementation Guide

**Architecture Foundation**: Hybrid PostgreSQL + Redis for job processing excellence  
**Complexity Level**: Expert - Advanced Queue Architecture & Operations  
**Target Audience**: Senior Engineers, DevOps, System Architects  
**Last Updated**: 2025-11-01

## Executive Overview

### Strategic Alignment

This queue system implementation supports our **market leadership positioning** by providing enterprise-grade job processing that scales to handle **millions of operations daily**. Our hybrid PostgreSQL + Redis architecture ensures we can deliver the **99.9% uptime guarantee** that enterprise customers demand while maintaining the **technical authority** needed to compete with established email platforms.

### Technical Authority

Our **comprehensive queue processing infrastructure** integrates seamlessly with our **enterprise database architecture** featuring **advanced job routing**, **automatic retry logic**, and **dead letter handling** that provides the **scalability** and **reliability** required for **mission-critical email operations**.

### User Journey Integration

This implementation is part of your **complete email management experience** - connects to **campaign execution**, **analytics processing**, and **system monitoring** to provide a unified operations platform that supports every aspect of your business automation strategy.

---

## Queue System Architecture Foundation

### Core Design Principle: Hybrid Performance & Durability

Our queue system implements a **dual-layer architecture** that combines the **durability** of PostgreSQL with the **high-performance** of Redis, creating an enterprise-grade job processing platform that handles **mission-critical email operations** with **reliable failover** and **comprehensive monitoring**.

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Next.js API   │    │   Queuer Proc   │    │  Worker Server  │
│   (Producer/))    │    │   (Migrator/))    │    │   (Consumer/))    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │ Insert Job            │                       │
         ↓                       │                       │
┌─────────────────┐              │                       │
│  PostgreSQL     │              │                       │
│  Jobs Table     │              │                       │
│  (Durable/))      │              │                       │
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
                        │   (Fast Queue/))  │
                        └─────────────────┘
                                 │
                                 │ BRPOP
                                 ↓
                        ┌─────────────────┐
                        │   Worker Proc   │
                        │   (Consumer/))    │
                        └─────────────────┘
```

### Database Tier Integration

**Strategic Foundation**: This hybrid approach positions us to handle **enterprise-scale job processing** while maintaining the **reliability** and **monitoring capabilities** needed for our **operational excellence** framework.

```
PostgreSQL Layer (Durable State Management/)):
├── jobs (job state and audit trail/)) ⭐
├── job_queues (queue configuration/))
├── job_logs (execution audit trail/))
└── analytics_jobs (OLAP pipeline integration/))

Redis Layer (High-Performance Processing/)):
├── queue:email-sending:high (priority processing/))
├── queue:email-sending (normal processing/))
├── queue:email-sending:low (batch processing/))
├── queue:analytics:daily-aggregate (business intelligence/))
└── queue:warmup:process (inbox warming automation/))

Worker Layer (Horizontal Scaling/)):
├── EmailWorker (campaign and processing/))
├── AnalyticsWorker (business intelligence/))
├── WarmupWorker (inbox warming/))
└── MonitoringWorker (system health/))

Monitoring Layer (Operational Excellence/)):
├── QueueHealthMonitor (real-time system health/))
├── DeadLetterHandler (failed job recovery/))
└── PerformanceMetrics (SLA tracking/))
```

**Operational Excellence**: This architecture supports our **99.9% uptime commitment** through **dual-layer processing**, **automatic failover**, and **comprehensive monitoring** systems that detect and resolve issues before they impact customers.

---

## Implementation Components

### 1. PostgreSQL Job Management (Durable State/))

**Strategic Value**: This durable foundation ensures **zero job loss** during system maintenance, upgrades, or failures, supporting our **operational reliability** commitments to enterprise customers.

#### Job Tables Schema

```sql
-- Job queues configuration
CREATE TABLE job_queues (/)
    name VARCHAR(100/)) PRIMARY KEY,
    default_priority INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(/))
);

-- Jobs table (Permanent State/))
CREATE TABLE jobs (/)
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(/)),
    queue_name VARCHAR(100/)) REFERENCES job_queues(name/)) ON DELETE CASCADE,
    status VARCHAR(50/)) DEFAULT 'queued',
    priority INTEGER DEFAULT 100,
    payload JSONB NOT NULL,
    attempt_count INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    run_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(/)),
    started TIMESTAMP WITH TIME ZONE,
    completed TIMESTAMP WITH TIME ZONE,
    failed TIMESTAMP WITH TIME ZONE,
    last_error_message TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(/)),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(/))
);

-- Job execution logs (Audit Trail/))
CREATE TABLE job_logs (/)
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(/)),
    job_id UUID REFERENCES jobs(id/)) ON DELETE CASCADE,
    status VARCHAR(50/)) NOT NULL,
    log_message TEXT,
    attempt_number INTEGER NOT NULL,
    started TIMESTAMP WITH TIME ZONE DEFAULT NOW(/)),
    finished TIMESTAMP WITH TIME ZONE,
    duration INTERVAL,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(/))
);

-- Analytics jobs tracking (for OLAP pipeline/))
CREATE TABLE analytics_jobs (/)
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(/)),
    job_type VARCHAR(100/)) NOT NULL,
    status VARCHAR(50/)) DEFAULT 'queued',
    payload JSONB NOT NULL,
    priority INTEGER DEFAULT 100,
    queued TIMESTAMP WITH TIME ZONE DEFAULT NOW(/)),
    processed TIMESTAMP WITH TIME ZONE,
    error_message TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(/))
);
```

#### Performance Indexes

**Technical Authority**: These indexes provide **optimal query performance** for **high-volume job processing** while maintaining **storage efficiency** for **enterprise-scale operations**.

```sql
-- Queuer process optimization
CREATE INDEX idx_jobs_queuer ON jobs(status, run_at, priority, created_at/)) 
WHERE status = 'queued';

-- Queue-specific migration
CREATE INDEX idx_jobs_queue_migration ON jobs(queue_name, status, run_at, priority/))
WHERE status = 'queued';

-- Audit and analytics
CREATE INDEX idx_jobs_status_timestamps ON jobs(status, updated_at, queue_name/));
CREATE INDEX idx_job_logs_worker ON job_logs(job_id, attempt_number, finished_at/));
CREATE INDEX idx_analytics_jobs_type_status ON analytics_jobs(job_type, status, queued_at/));
```

### 2. Redis Queue Structure (Fast Processing/))

**User Journey Integration**: This high-performance layer ensures **seamless real-time processing** from **job creation** to **completion**, providing **instant feedback** for all email operations and **campaign execution**.

#### Queue Naming Convention

**Strategic Foundation**: Our queue structure supports **priority-based processing** that ensures **critical operations** are handled first, while **batch operations** are processed efficiently.

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

**A. Lists (Primary Job Queues/))**
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

**B. Hashes (Job Metadata/))**
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
```

---

## Core Implementation Services

### 3. Queuer Process Implementation

**Operational Excellence**: Our queuer service provides **reliable job migration** from PostgreSQL to Redis with **comprehensive error handling** and **automatic recovery** that ensures **no jobs are lost** during processing.

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

  constructor(redis: Redis, db: Database/)) {
    this.redis = redis;
    this.db = db;
  }

  async start(/)) {
    this.isRunning = true;
    console.log('Job migrator started'/));
    
    while (this.isRunning/)) {
      try {
        await this.migrateReadyJobs(/));
        await this.delay(this.migrationInterval/));
      } catch (error/)) {
        console.error('Job migration error:', error/));
        await this.delay(10000/)); // Wait 10 seconds on error
      }
    }
  }

  stop(/)) {
    this.isRunning = false;
    console.log('Job migrator stopped'/));
  }

  private async migrateReadyJobs(/)) {
    const jobs = await this.db.jobs.findMany({/)
      where: {
        status: 'queued',
        run_at: { lte: new Date(/)) }
      },
      orderBy: [
        { priority: 'asc' },
        { created_at: 'asc' }
      ],
      take: this.batchSize
    });

    if (jobs.length === 0/)) {
      return;
    }

    console.log(`Migrating ${jobs.length} jobs to Redis`/));

    for (const job of jobs/)) {
      try {
        await this.migrateJob(job/));
      } catch (error/)) {
        console.error(`Failed to migrate job ${job.id}:`, error/));
      }
    }
  }

  private async migrateJob(job: any/)) {
    const queueName = this.getQueueName(job/));
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
    await this.redis.lpush(queueName, JSON.stringify(redisPayload/)));

    // Initialize Redis hash for tracking
    await this.redis.hset(`job:${job.id}`, {/)
      status: 'migrated',
      queued_at: new Date(/)).toISOString(/)),
      attempt_count: job.attempt_count.toString(/))
    });

    // Update PostgreSQL status
    await this.db.jobs.update({/)
      where: { id: job.id },
      data: { 
        status: 'migrated_to_redis',
        updated_at: new Date(/))
      }
    });

    // Prevent duplicates with Redis Set
    await this.redis.sadd(`recent_jobs:${job.queue_name}`, job.id/));
    await this.redis.expire(`recent_jobs:${job.queue_name}`, 3600/)); // 1 hour TTL
  }

  private getQueueName(job: any/)): string {
    const { priority, queue_name } = job;
    
    // Priority-based routing
    if (priority <= 50/)) return `${queue_name}:high`;
    if (priority <= 150/)) return queue_name;
    return `${queue_name}:low`;
  }

  private delay(ms: number/)): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms/)));
  }
}
```

### 4. Worker Server Implementation

**Technical Authority**: Our worker architecture provides **horizontal scaling** with **priority-based processing** and **comprehensive error handling** that ensures **reliable job execution** for all email operations.

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

  constructor(redis: Redis, db: Database, emailService: EmailService/)) {
    this.redis = redis;
    this.db = db;
    this.emailService = emailService;
    this.workerId = `worker-${process.env.WORKER_ID || Math.random(/)).toString(36/)).substr(2, 9/))}`;
  }

  async start(/)) {
    this.isRunning = true;
    console.log(`Worker ${this.workerId} started`/));

    // Listen to all priority queues
    const queues = [
      'queue:email:processing:high',
      'queue:email:processing',
      'queue:email:processing:low',
      'queue:email-sending:high',
      'queue:email-sending',
      'queue:email-sending:low',
      'queue:warmup:process',
      'queue:bounce:process'
    ];

    while (this.isRunning/)) {
      try {
        // Blocking pop with priority ordering
        const result = await this.redis.brpop(queues, 0/));
        
        if (!result/)) {
          continue;
        }

        const [queueName, jobData] = result;
        const job = JSON.parse(jobData/));

        await this.processJob(job, queueName/));
      } catch (error/)) {
        console.error(`Worker ${this.workerId} error:`, error/));
        await this.delay(1000/));
      }
    }
  }

  stop(/)) {
    this.isRunning = false;
    console.log(`Worker ${this.workerId} stopped`/));
  }

  private async processJob(job: any, queueName: string/)) {
    const { id, payload } = job;
    
    try {
      console.log(`Processing job ${id} from ${queueName}`/));

      // Update PostgreSQL status
      await this.db.jobs.update({/)
        where: { id },
        data: { 
          status: 'running',
          started_at: new Date(/)),
          updated_at: new Date(/))
        }
      });

      // Update Redis hash for real-time tracking
      await this.redis.hset(`job:${id}`, {/)
        status: 'processing',
        worker_id: this.workerId,
        started_at: new Date(/)).toISOString(/))
      });

      // Execute the job based on queue type
      if (queueName.includes('email:processing'/))) {
        await this.processIncomingEmail(payload/));
      } else if (queueName.includes('email-sending'/))) {
        await this.emailService.sendEmail(payload/));
      } else if (queueName.includes('warmup'/))) {
        await this.processWarmupJob(payload/));
      } else if (queueName.includes('bounce'/))) {
        await this.processBounceJob(payload/));
      } else {
        throw new Error(`Unknown queue type: ${queueName}`/));
      }

      // Update completion status
      await this.db.jobs.update({/)
        where: { id },
        data: { 
          status: 'completed',
          completed_at: new Date(/)),
          updated_at: new Date(/))
        }
      });

      await this.redis.hset(`job:${id}`, {/)
        status: 'completed',
        completed_at: new Date(/)).toISOString(/))
      });

      // Log successful execution
      await this.logJobExecution(id, 'success', null/));

      console.log(`Job ${id} completed successfully`/));

    } catch (error/)) {
      await this.handleJobFailure(id, error/));
    }
  }

  private async handleJobFailure(job: any, error: Error/)) {
    const { id, max_attempts, attempt_count = 0 } = job;
    
    try {
      const attempts = attempt_count + 1;
      
      if (attempts < max_attempts/)) {
        // Schedule retry with exponential backoff
        const delay = Math.pow(2, attempts/)) * 1000; // 2s, 4s, 8s, etc.
        
        await this.delay(delay/));
        
        // Re-queue the job
        await this.redis.lpush('queue:email-sending', JSON.stringify({/)
          ...job,
          attempt_count: attempts
        }));

        // Update PostgreSQL
        await this.db.jobs.update({/)
          where: { id },
          data: { 
            attempt_count: attempts,
            updated_at: new Date(/))
          }
        });

        await this.redis.hset(`job:${id}`, {/)
          status: 'retry_scheduled',
          attempt_count: attempts.toString(/)),
          retry_delay: delay.toString(/))
        });

      } else {
        // Max attempts reached - mark as failed
        await this.db.jobs.update({/)
          where: { id },
          data: { 
            status: 'failed',
            failed_at: new Date(/)),
            last_error_message: error.message,
            updated_at: new Date(/))
          }
        });

        await this.redis.hset(`job:${id}`, {/)
          status: 'failed',
          error: error.message,
          failed_at: new Date(/)).toISOString(/))
        });
      }

      await this.logJobExecution(id, 'failed', error.message/));
      console.error(`Job ${id} failed:`, error.message/));

    } catch (logError/)) {
      console.error(`Failed to log job failure for ${id}:`, logError/));
    }
  }

  private async processIncomingEmail(payload: any/)) {
    // Implementation for incoming email processing using new email system architecture
    // Creates email_messages (analytics/)) and email_content (body/)) entries
    const { tenant_id, email_account_id, direction, type, from, to, subject, body, headers, raw, messageId } = payload;
    
    try {
      const storage_key = `email_${messageId}_${Date.now(/))}`;
      
      // 1. Create email_content (email body and metadata/))
      const contentObject = await this.db.email_content.create({/)
        data: {
          storage_key,
          tenant_id: tenant_id,
          content_text: body.plain || body.html,
          content_html: body.html || convertToHtml(body.plain/)),
          headers: headers,
          raw_size_bytes: Buffer.byteLength(raw/)),
          created: new Date(/)),
          retention_days: 2555 // 7 years default
        }
      });

      // 2. Create email_messages (analytics and metadata/))
      const messageRef = await this.db.email_messages.create({/)
        data: {
          storage_key,
          tenant_id: tenant_id,
          email_account_id: email_account_id,
          direction: direction,
          message_type: type || 'email',
          from_email: from,
          to_email: Array.isArray(to/)) ? to.join(','/)) : to,
          subject: subject,
          status: 'received',
          processed: new Date(/))
        }
      });

      // 3. Create attachments if present
      if (payload.attachments && payload.attachments.length > 0/)) {
        for (const attachment of payload.attachments/)) {
          await this.db.attachments.create({/)
            data: {
              parent_storage_key: storage_key,
              filename: attachment.filename,
              mime_type: attachment.mime_type,
              size_bytes: attachment.size,
              content: attachment.content,
              storage_disposition: attachment.disposition || 'attachment'
            }
          });
        }
      }

      console.log('Successfully processed incoming email:', { storage_key, messageId: messageRef.storage_key }/));
      
      return {
        success: true,
        storage_key,
        content_object_id: contentObject.storage_key,
        message_ref_id: messageRef.storage_key
      };
      
    } catch (error/)) {
      console.error('Failed to process incoming email:', error/));
      throw new Error(`Email processing failed: ${error.message}`/));
    }
  }

  private async logJobExecution(jobId: string, status: string, errorMessage: string | null/)) {
    try {
      await this.db.jobLogs.create({/)
        data: {
          job_id: jobId,
          status,
          log_message: errorMessage,
          attempt_number: 1, // This would be dynamic in real implementation
          finished_at: new Date(/))
        }
      });
    } catch (error/)) {
      console.error('Failed to log job execution:', error/));
    }
  }

  private async processWarmupJob(payload: any/)) {
    // Implementation for warmup processing
    console.log('Processing warmup job:', payload/));
  }

  private async processBounceJob(payload: any/)) {
    // Implementation for bounce processing  
    console.log('Processing bounce job:', payload/));
  }

  private delay(ms: number/)): Promise<void> {
    return new Promise(resolve => setTimeout(resolve, ms/)));
  }
}
```

---

## Deployment and Operations

### Docker Compose Configuration

**Operational Excellence**: Our containerized deployment ensures **reliable scaling**, **automatic recovery**, and **comprehensive monitoring** for **enterprise-grade queue processing**.

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

**Technical Authority**: Our monitoring system provides **real-time visibility** into **queue performance**, **worker health**, and **job processing metrics** to maintain our **99.9% uptime commitment**.

#### Queue Health Monitoring

```typescript
// monitoring/QueueHealth.ts
import Redis from 'ioredis';
import { Database } from '../Database';

export class QueueHealthMonitor {
  private redis: Redis;
  private db: Database;

  constructor(redis: Redis, db: Database/)) {
    this.redis = redis;
    this.db = db;
  }

  async getQueueHealth(/)) {
    const health = {
      timestamp: new Date(/)).toISOString(/)),
      redis: await this.checkRedisHealth(/)),
      queues: await this.checkQueueDepths(/)),
      workers: await this.checkWorkerStatus(/)),
      jobs: await this.checkJobStats(/))
    };

    return health;
  }

  private async checkRedisHealth(/)) {
    try {
      const pong = await this.redis.ping(/));
      const info = await this.redis.info(/));
      
      return {
        status: 'healthy',
        ping: pong,
        memory_used: this.parseRedisMemory(info/)),
        connected_clients: this.parseConnectedClients(info/))
      };
    } catch (error/)) {
      return {
        status: 'unhealthy',
        error: error.message
      };
    }
  }

  private async checkQueueDepths(/)) {
    const queues = [
      'queue:email:processing:high',
      'queue:email:processing',
      'queue:email:processing:low',
      'queue:email-sending:high',
      'queue:email-sending',
      'queue:email-sending:low',
      'queue:analytics:daily-aggregate',
      'queue:warmup:process'
    ];

    const depths = {};
    
    for (const queue of queues/)) {
      try {
        const length = await this.redis.llen(queue/));
        depths[queue] = length;
      } catch (error/)) {
        depths[queue] = { error: error.message };
      }
    }

    return depths;
  }

  private async checkWorkerStatus(/)) {
    // Get all job hashes to see which workers are active
    const jobKeys = await this.redis.keys('job:*'/));
    const workers = new Set(/));
    
    for (const key of jobKeys.slice(0, 100/))) { // Check first 100 jobs
      const workerId = await this.redis.hget(key, 'worker_id'/));
      if (workerId/)) {
        workers.add(workerId/));
      }
    }

    return {
      active_workers: workers.size,
      worker_ids: Array.from(workers/))
    };
  }

  private async checkJobStats(/)) {
    const stats = await this.db.jobs.groupBy({/)
      by: ['status'],
      _count: { status: true }
    });

    return stats.reduce((acc, stat/)) => {
      acc[stat.status] = stat._count.status;
      return acc;
    }, {});
  }

  private parseRedisMemory(info: string/)): string {
    const match = info.match(/used_memory_human:([^\r\n]+/))/);
    return match ? match[1] : 'unknown';
  }

  private parseConnectedClients(info: string/)): number {
    const match = info.match(/connected_clients:(\d+/))/);
    return match ? parseInt(match[1]/)) : 0;
  }
}
```

### Error Handling and Recovery

**Operational Excellence**: Our dead letter queue system ensures **failed jobs are captured** and can be **replayed** for **operational debugging** and **system recovery**.

#### Dead Letter Queue

```typescript
// workers/DeadLetterHandler.ts
import Redis from 'ioredis';
import { Database } from '../Database';

export class DeadLetterHandler {
  private redis: Redis;
  private db: Database;

  constructor(redis: Redis, db: Database/)) {
    this.redis = redis;
    this.db = db;
  }

  async moveFailedJobsToDeadLetter(/)) {
    const failedJobs = await this.db.jobs.findMany({/)
      where: {
        status: 'failed',
        updated_at: {
          gte: new Date(Date.now(/)) - 24 * 60 * 60 * 1000) // Last 24 hours
        }
      }
    });

    for (const job of failedJobs/)) {
      // Check if already in dead letter queue
      const exists = await this.redis.exists(`deadletter:${job.id}`/));
      if (exists/)) continue;

      // Move to dead letter queue
      await this.redis.lpush('deadletter:queue', JSON.stringify({/)
        id: job.id,
        queue_name: job.queue_name,
        payload: job.payload,
        error: job.last_error_message,
        failed_at: job.failed_at,
        attempt_count: job.attempt_count
      }));

      // Mark as moved to dead letter
      await this.redis.set(`deadletter:${job.id}`, 'moved', 'EX', 604800/)); // 7 days
    }
  }

  async replayDeadLetterJob(jobId: string/)) {
    const jobData = await this.redis.lpop('deadletter:queue'/));
    if (!jobData/)) {
      throw new Error('No jobs in dead letter queue'/));
    }

    const job = JSON.parse(jobData/));
    
    // Reset job in PostgreSQL
    await this.db.jobs.update({/)
      where: { id: jobId },
      data: {
        status: 'queued',
        attempt_count: 0,
        last_error_message: null,
        failed_at: null,
        updated_at: new Date(/))
      }
    });

    // Add back to appropriate queue
    await this.redis.lpush(job.queue_name, JSON.stringify(job/)));
    
    return { success: true, job_id: jobId };
  }
}
```

---

## Performance & Monitoring Excellence

### Success Metrics & Performance Targets

**Strategic Alignment**: These metrics directly support our **market leadership goals** by demonstrating **technical superiority** and **operational excellence** that distinguishes us from competitors.

- **Queue Throughput**: 10,000+ jobs/second processing capacity
- **Job Latency**: <100ms from creation to processing start
- **System Reliability**: 99.5% job success rate with automatic retry
- **Worker Scalability**: Horizontal scaling to 50+ concurrent workers
- **Redis Performance**: <10ms queue operations (BRPOP/LPUSH/))
- **PostgreSQL Integration**: 99.9% durable job state preservation
- **Recovery Time**: <30 seconds for automatic worker failover
- **Dead Letter Rate**: <0.1% of total jobs with full recovery capability

### Technical Excellence Indicators

**Operational Excellence**: These indicators ensure our **queue infrastructure** meets **enterprise standards** while supporting our **scalability** and **reliability** commitments.

- **Queue Health**: Real-time monitoring of all queue depths and processing rates
- **Worker Status**: Automatic detection of worker failures and automatic scaling
- **Job State**: Complete audit trail of all job processing with timing metrics
- **Error Recovery**: Comprehensive dead letter handling with replay capabilities
- **Performance Optimization**: Automatic connection pooling and resource management

---

## Best Practices & Implementation Guidelines

### Performance Optimization

**Technical Authority**: These practices ensure **optimal performance** for **high-volume operations** while maintaining **system reliability**.

1. **Batch Processing**: Process jobs in batches to reduce database round trips
2. **Connection Pooling**: Use connection pools for both PostgreSQL and Redis
3. **Monitoring**: Monitor queue depths and processing times continuously
4. **Resource Limits**: Set memory limits and eviction policies for Redis
5. **Priority Routing**: Use priority queues for critical vs. batch operations

### Reliability Patterns

**User Journey Integration**: These patterns ensure **seamless user experience** with **automatic recovery** and **reliable job processing**.

1. **Idempotency**: Ensure job processing is idempotent for safe retries
2. **Timeout Handling**: Set appropriate timeouts for job processing
3. **Circuit Breakers**: Implement circuit breakers for external service calls
4. **Graceful Shutdown**: Ensure workers can complete current jobs before shutdown
5. **Dead Letter Handling**: Capture and replay failed jobs for debugging

### Security Considerations

**Strategic Value**: These security measures protect our **enterprise customers** and support our **compliance requirements** while maintaining **operational efficiency**.

1. **Job Validation**: Validate job payloads before processing
2. **Access Control**: Restrict job creation to authorized users
3. **Data Encryption**: Encrypt sensitive data in job payloads
4. **Audit Logging**: Log all job state changes for compliance
5. **Multi-tenant Isolation**: Ensure complete isolation between customer data

---

## Conclusion

### Strategic Impact

**Market Leadership**: This queue system implementation positions PenguinMails as the **technical leader** in email infrastructure, providing the **scalability**, **reliability**, and **intelligence** needed to **compete with and surpass** established email platforms.

**User Journey Excellence**: The system integrates seamlessly with our **progressive complexity framework**, providing **real-time processing** backed by **enterprise-grade infrastructure** that scales with your business operations.

### Technical Authority

**Infrastructure Excellence**: Our **hybrid PostgreSQL + Redis architecture** with **comprehensive monitoring** provides the **technical foundation** for **mission-critical job processing** while maintaining the **flexibility** needed for **continuous innovation**.

**Operational Excellence**: The system supports our **99.9% uptime commitment** through **redundant processing**, **automatic failover**, and **comprehensive monitoring** that ensures **reliable job operations** for all customers.

This implementation represents a **significant architectural advancement** that establishes PenguinMails as the **premium choice** for **enterprise email infrastructure** requiring **superior performance**, **reliability**, and **operational intelligence capabilities**.

---

## Related Documentation

- [Architecture Overview](((../overview/))) - Strategic foundation and market positioning
- [Email System Implementation](((./email-system-implementation/))) - Email processing and queue integration
- [Analytics Architecture](((./analytics-architecture/))) - Business intelligence and job processing
- [Campaign Management](((../../campaigns/overview/))) - User experience and business operations
- [Business Analytics](((../../business/analytics/overview/))) - Revenue intelligence and optimization

**Keywords**: queue system, redis, postgresql, job processing, worker, migrator, dead letter queue, monitoring, enterprise infrastructure, operational excellence, hybrid architecture