---
title: "Queue Management"
description: "Queue Management - Redis Queues and Migrator Process"
last_modified_date: "2025-11-19"
level: "2"
persona: "System Engineers"
related_docs:

  - "[Main Guide](/docs/implementation-technical/database-infrastructure/queue/main) - Complete overview"

  - "[Architecture](/docs/implementation-technical/database-infrastructure/queue/architecture) - System design principles"

  - "[Database Schema](/docs/implementation-technical/database-infrastructure/queue/database-schema) - Job tables and indexes"
---

# Queue Management

## Overview

Queue management handles the Redis-based high-performance job processing layer and the migrator process that bridges PostgreSQL durability with Redis speed. This component ensures efficient job routing, priority handling, and optimal worker consumption.

## Redis Queue Structure

### Queue Naming Convention

Queues follow a consistent naming pattern for easy identification and priority routing:

```pseudo
queue naming = {
  email_processing: {
    high: "queue:email:processing:high",     // Priority â‰¤ 50
    normal: "queue:email:processing",        // Priority 51-150
    low: "queue:email:processing:low"        // Priority > 150
  },

  email_sending: {
    high: "queue:email-sending:high",
    normal: "queue:email-sending",
    low: "queue:email-sending:low"
  },

  analytics: {
    daily: "queue:analytics:daily-aggregate",
    campaign: "queue:analytics:campaign-aggregate",
    billing: "queue:analytics:billing-calculate"
  },

  processing: {
    warmup: "queue:warmup:process",
    bounce: "queue:bounce:process",
    webhook: "queue:webhook:process"
  }
}

```

### Priority Routing Logic

Jobs are automatically routed based on priority levels:

```pseudo
function determineQueueName(priority, baseQueueName) {
  if (priority <= HIGH_PRIORITY_THRESHOLD) {
    return `${baseQueueName}:high`    // Urgent jobs (â‰¤ 50)
  } else if (priority <= NORMAL_PRIORITY_THRESHOLD) {
    return baseQueueName             // Standard jobs (51-150)
  } else {
    return `${baseQueueName}:low`    // Background jobs (> 150)
  }
}

HIGH_PRIORITY_THRESHOLD = 50
NORMAL_PRIORITY_THRESHOLD = 150

```

## Redis Data Structures

### Job Queue Structure (Redis Lists)

Each Redis queue uses list data structures for FIFO job processing:

```pseudo
// Job payload structure in Redis lists
interface RedisJobPayload {
  id: string              // PostgreSQL job ID for tracking
  queue_name: string      // Original queue name
  priority: number        // Job priority level
  payload: object         // Job-specific data (minimal)
  created_at: string      // ISO timestamp
  attempt_count: number   // Current attempt number
  max_attempts: number    // Maximum retry attempts
}

// Example job structure
emailJob = {
  id: "uuid-job-123",
  queue_name: "email-sending",
  priority: 75,
  payload: {
    campaign_id: "uuid-campaign",
    recipient_id: "uuid-recipient",
    template_id: "welcome-email",
    // No large content or sensitive data
  },
  created_at: "2025-10-30T09:00:00Z",
  attempt_count: 0,
  max_attempts: 3
}

```

### Job Metadata Tracking (Redis Hashes)

Real-time job status tracking using Redis hashes:

```pseudo
// Redis hash for real-time status
interface JobMetadata {
  status: 'queued' | 'migrated' | 'processing' | 'completed' | 'failed' | 'retry_scheduled'
  worker_id: string       // Worker processing this job
  started_at: string      // Processing start time
  completed_at: string    // Processing completion time
  last_error: string      // Error message if failed
  attempt_count: number   // Current attempt number
  retry_delay: number     // Delay before next retry (ms)
}

// Hash key format: job:{jobId}
redis.hgetall("job:uuid-job-123") = {
  status: "processing",
  worker_id: "worker-1",
  started_at: "2025-10-30T09:01:00Z",
  attempt_count: "1"
}

```

### Recent Jobs Tracking (Redis Sets)

Prevents duplicate job processing:

```pseudo
// Set-based duplicate prevention
redis.sadd(`recent_jobs:${queueName}`, jobId)
redis.expire(`recent_jobs:${queueName}`, 3600) // 1 hour TTL

// Check for recent processing
if redis.sismember(`recent_jobs:${queueName}`, jobId) {
  // Skip duplicate job
  return DUPLICATE
}

```

## Queuer Process (Migrator)

### Core Migration Logic

The migrator service continuously moves jobs from PostgreSQL to Redis:

```pseudo
class JobMigrator {
  private isRunning = false
  private batchSize = 100
  private migrationInterval = 5000 // 5 seconds

  async start() {
    this.isRunning = true
    log("Job migrator started")

    while (this.isRunning) {
      try {
        await this.migrateReadyJobs()
        await this.delay(this.migrationInterval)
      } catch (error) {
        logError("Migration error", error)
        await this.delay(10000) // Wait 10 seconds on error
      }
    }
  }

  private async migrateReadyJobs() {
    // Query PostgreSQL for ready jobs
    readyJobs = await database.jobs.findMany({
      where: {
        status: 'queued',
        run_at: { lte: new Date() }
      },
      orderBy: [
        { priority: 'asc' },      // Higher priority first
        { created_at: 'asc' }     // FIFO within same priority
      ],
      take: this.batchSize
    })

    if (readyJobs.length === 0) return

    log(`Migrating ${readyJobs.length} jobs to Redis`)

    for (job in readyJobs) {
      try {
        await this.migrateJob(job)
      } catch (error) {
        logError(`Failed to migrate job ${job.id}`, error)
      }
    }
  }

  private async migrateJob(job) {
    // Determine target Redis queue
    queueName = this.getQueueName(job.priority, job.queue_name)

    // Prepare Redis payload
    redisPayload = {
      id: job.id,
      queue_name: job.queue_name,
      priority: job.priority,
      payload: job.payload,
      created_at: job.created_at,
      attempt_count: job.attempt_count,
      max_attempts: job.max_attempts
    }

    // Add to Redis queue (left push for FIFO)
    await redis.lpush(queueName, JSON.stringify(redisPayload))

    // Track in Redis hash for status monitoring
    await redis.hset(`job:${job.id}`, {
      status: 'migrated',
      queued_at: new Date().toISOString(),
      attempt_count: job.attempt_count.toString()
    })

    // Prevent duplicates
    await redis.sadd(`recent_jobs:${job.queue_name}`, job.id)
    await redis.expire(`recent_jobs:${job.queue_name}`, 3600)

    // Update PostgreSQL status
    await database.jobs.update({
      where: { id: job.id },
      data: {
        status: 'migrated_to_redis',
        updated_at: new Date()
      }
    })
  }
}

```

### Queue Depth Monitoring

Track queue sizes for monitoring and scaling:

```pseudo
async function monitorQueueDepths() {
  queueNames = [
    'queue:email:processing:high',
    'queue:email:processing',
    'queue:email:processing:low',
    'queue:email-sending:high',
    'queue:email-sending',
    'queue:email-sending:low',
    'queue:analytics:daily-aggregate',
    'queue:warmup:process'
  ]

  depths = {}

  for (queueName in queueNames) {
    depths[queueName] = await redis.llen(queueName)
  }

  // Alert if any queue exceeds threshold
  for (queueName, depth in depths) {
    if (depth > MAX_QUEUE_DEPTH_THRESHOLD) {
      await alertSystem.queueDepthAlert(queueName, depth)
    }
  }

  return depths
}

```

## Job Retrieval for Workers

### Blocking Pop with Priority

Workers use blocking pop (BRPOP) to efficiently retrieve jobs:

```pseudo
async function workerJobRetrieval(workerId) {
  queues = [
    'queue:email:processing:high',     // Highest priority first
    'queue:email:processing',
    'queue:email:processing:low',
    'queue:email-sending:high',
    'queue:email-sending',
    'queue:email-sending:low',
    'queue:warmup:process',
    'queue:bounce:process'
  ]

  while (isRunning) {
    try {
      // Blocking pop with timeout
      result = await redis.brpop(queues, 0)

      if (!result) continue

      [queueName, jobData] = result
      job = JSON.parse(jobData)

      await processJob(job, queueName, workerId)

    } catch (error) {
      logError(`Worker ${workerId} retrieval error`, error)
      await this.delay(1000)
    }
  }
}

```

### Job Processing Workflow

Complete job processing flow:

```pseudo
async function processJob(job, queueName, workerId) {
  try {
    // Update PostgreSQL status
    await database.jobs.update({
      where: { id: job.id },
      data: {
        status: 'running',
        started_at: new Date(),
        worker_id: workerId,
        updated_at: new Date()
      }
    })

    // Update Redis tracking
    await redis.hset(`job:${job.id}`, {
      status: 'processing',
      worker_id: workerId,
      started_at: new Date().toISOString()
    })

    // Execute job based on queue type
    if (queueName.includes('email:processing')) {
      await executeEmailProcessing(job.payload)
    } else if (queueName.includes('email-sending')) {
      await executeEmailSending(job.payload)
    } else if (queueName.includes('warmup')) {
      await executeWarmup(job.payload)
    } else if (queueName.includes('bounce')) {
      await executeBounceProcessing(job.payload)
    }

    // Mark as completed
    await database.jobs.update({
      where: { id: job.id },
      data: {
        status: 'completed',
        completed_at: new Date(),
        updated_at: new Date()
      }
    })

    await redis.hset(`job:${job.id}`, {
      status: 'completed',
      completed_at: new Date().toISOString()
    })

    log(`Job ${job.id} completed successfully`)

  } catch (error) {
    await handleJobFailure(job, error)
  }
}

```

## Retry Logic and Error Handling

### Exponential Backoff Strategy

```pseudo
async function handleJobFailure(job, error) {
  attempts = job.attempt_count + 1

  if (attempts < job.max_attempts) {
    // Calculate exponential backoff delay
    delay = Math.pow(2, attempts) * 1000  // 2s, 4s, 8s, etc.

    await delay(delay)

    // Re-queue job with updated attempt count
    updatedJob = {
      ...job,
      attempt_count: attempts
    }

    queueName = determineQueueName(job.priority, job.queue_name)
    await redis.lpush(queueName, JSON.stringify(updatedJob))

    // Update database
    await database.jobs.update({
      where: { id: job.id },
      data: {
        attempt_count: attempts,
        updated_at: new Date()
      }
    })

    await redis.hset(`job:${job.id}`, {
      status: 'retry_scheduled',
      attempt_count: attempts.toString(),
      retry_delay: delay.toString()
    })

  } else {
    // Max attempts reached - mark as failed
    await database.jobs.update({
      where: { id: job.id },
      data: {
        status: 'failed',
        failed_at: new Date(),
        last_error_message: error.message,
        updated_at: new Date()
      }
    })

    await redis.hset(`job:${job.id}`, {
      status: 'failed',
      error: error.message,
      failed_at: new Date().toISOString()
    })

    // Move to dead letter queue
    await moveToDeadLetterQueue(job, error)
  }
}

```

### Dead Letter Queue Management

```pseudo
async function moveToDeadLetterQueue(job, error) {
  deadLetterJob = {
    id: job.id,
    queue_name: job.queue_name,
    payload: job.payload,
    error: error.message,
    failed_at: new Date().toISOString(),
    attempt_count: job.attempt_count,
    original_priority: job.priority
  }

  // Add to dead letter queue
  await redis.lpush('deadletter:queue', JSON.stringify(deadLetterJob))

  // Mark as processed in dead letter tracking
  await redis.set(`deadletter:${job.id}`, 'moved', 'EX', 604800) // 7 days
}

async function replayDeadLetterJob(jobId) {
  // Get job from dead letter queue
  jobData = await redis.lpop('deadletter:queue')
  if (!jobData) {
    throw new Error('No jobs in dead letter queue')
  }

  deadLetterJob = JSON.parse(jobData)

  // Reset job in PostgreSQL
  await database.jobs.update({
    where: { id: jobId },
    data: {
      status: 'queued',
      attempt_count: 0,
      last_error_message: null,
      failed_at: null,
      updated_at: new Date()
    }
  })

  // Re-queue for processing
  queueName = determineQueueName(deadLetterJob.original_priority, deadLetterJob.queue_name)
  await redis.lpush(queueName, JSON.stringify({
    ...deadLetterJob.payload,
    id: jobId,
    attempt_count: 0
  }))

  return { success: true, job_id: jobId }
}

```

## Performance Optimization

### Batch Operations

```pseudo
// Batch migration for efficiency
async function batchMigrateJobs(jobs) {
  pipeline = redis.pipeline()

  for (job in jobs) {
    queueName = determineQueueName(job.priority, job.queue_name)
    redisPayload = createRedisPayload(job)

    pipeline.lpush(queueName, JSON.stringify(redisPayload))
    pipeline.hset(`job:${job.id}`, {
      status: 'migrated',
      queued_at: new Date().toISOString()
    })
  }

  // Execute all operations in single round trip
  await pipeline.exec()
}

```

### Memory Management

```pseudo
// Redis memory optimization
async function optimizeRedisMemory() {
  // Get Redis memory info
  memoryInfo = await redis.info('memory')

  // Clean up expired job tracking
  await redis.eval(`
    local keys = redis.call('KEYS', 'job:*')
    local expired = 0
    for i=1,#keys do
      if redis.call('TTL', keys[i]) <= 0 then
        redis.call('DEL', keys[i])
        expired = expired + 1
      end
    end
    return expired
  `)

  // Monitor memory usage
  if (memoryInfo.used_memory_percentage > 80) {
    await triggerMemoryCleanup()
  }
}

```

## Monitoring and Health Checks

### Queue Health Metrics

```pseudo
async function getQueueHealth() {
  return {
    timestamp: new Date().toISOString(),
    redis: await checkRedisHealth(),
    queues: await checkQueueDepths(),
    recent_jobs: await checkRecentJobCounts(),
    dead_letter_queue: await checkDeadLetterDepth()
  }
}

async function checkRedisHealth() {
  try {
    ping = await redis.ping()
    info = await redis.info()

    return {
      status: 'healthy',
      ping: ping,
      memory_used: parseMemoryUsage(info),
      connected_clients: parseClientCount(info)
    }
  } catch (error) {
    return {
      status: 'unhealthy',
      error: error.message
    }
  }
}

```

## Conclusion

The queue management system provides:

- **High Performance**: Redis-based queues with millisecond latency

- **Priority Routing**: Automatic job routing based on priority levels

- **Reliability**: Comprehensive error handling and retry mechanisms

- **Monitoring**: Real-time queue health and performance tracking

- **Scalability**: Horizontal scaling through multiple workers and Redis clustering

This architecture ensures efficient job processing while maintaining data durability and system reliability.
