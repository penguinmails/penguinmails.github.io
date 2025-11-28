---
title: "Worker Processes"
description: "Worker Processes - Background Job Processing"
last_modified_date: "2025-11-19"
level: "2"
persona: "Backend Engineers"
related_docs:


  - "[Main Guide](main) - Complete overview"


  - "[Architecture](architecture) - System design principles"


  - "[Management](management) - Redis and migrator details"
---


# Worker Processes

## Overview

Worker processes consume jobs from Redis queues and execute the actual business logic. These stateless services provide horizontal scalability, fault tolerance, and comprehensive error handling for reliable job processing.

## Worker Architecture

### Core Design Principles

**Stateless Design**:

- Workers maintain no persistent state between jobs

- All job data retrieved from Redis and PostgreSQL

- Can be scaled up/down without data loss

- Multiple workers can process same queue type

**Fault Tolerance**:

- Automatic job reassignment on worker failure

- Timeout-based job recovery

- Graceful shutdown with job completion

- Dead letter queue for permanent failures

### Worker Lifecycle Management

```pseudo
class QueueWorker {
  private workerId: string
  private isRunning = false
  private redis: Redis
  private database: Database
  private emailService: EmailService

  constructor(redis: Redis, database: Database, emailService: EmailService) {
    this.workerId = generateWorkerId()
    this.redis = redis
    this.database = database
    this.emailService = emailService
  }

  async start() {
    this.isRunning = true
    log(`Worker ${this.workerId} starting`)

    try {
      await this.initialize()
      await this.mainLoop()
    } catch (error) {
      logError(`Worker ${this.workerId} startup failed`, error)
      throw error
    }
  }

  async stop() {
    this.isRunning = false
    log(`Worker ${this.workerId} stopping`)

    // Wait for current job to complete
    await this.waitForCurrentJob()

    // Cleanup resources
    await this.cleanup()
  }

  private async mainLoop() {
    const queues = this.getQueueList()

    while (this.isRunning) {
      try {
        // Blocking pop with priority ordering
        result = await this.redis.brpop(queues, 0)

        if (!result) continue

        [queueName, jobData] = result
        job = JSON.parse(jobData)

        await this.processJob(job, queueName)

      } catch (error) {
        logError(`Worker ${this.workerId} main loop error`, error)
        await this.delay(1000)
      }
    }
  }
}


```

## Job Processing Workflow

### Core Processing Logic

```pseudo
async function processJob(job: Job, queueName: string) {
  const startTime = Date.now()

  try {
    log(`Processing job ${job.id} from ${queueName}`)

    // Update job status in PostgreSQL
    await this.updateJobStatus(job.id, 'running', {
      started_at: new Date(),
      worker_id: this.workerId
    })

    // Update Redis tracking for real-time monitoring
    await this.redis.hset(`job:${job.id}`, {
      status: 'processing',
      worker_id: this.workerId,
      started_at: new Date().toISOString()
    })

    // Execute job based on queue type
    const result = await this.executeJobLogic(job.payload, queueName)

    // Mark as completed
    await this.markJobCompleted(job.id, result)

    // Log successful execution
    await this.logJobExecution(job.id, 'success', null, startTime)

    log(`Job ${job.id} completed successfully in ${Date.now() - startTime}ms`)

  } catch (error) {
    await this.handleJobFailure(job, error)
  }
}


```

### Job Execution by Queue Type

```pseudo
async function executeJobLogic(payload: JobPayload, queueName: string) {
  switch (true) {
    case queueName.includes('email:processing'):
      return await this.processIncomingEmail(payload)

    case queueName.includes('email-sending'):
      return await this.processEmailSending(payload)

    case queueName.includes('warmup'):
      return await this.processWarmupJob(payload)

    case queueName.includes('bounce'):
      return await this.processBounceJob(payload)

    case queueName.includes('analytics'):
      return await this.processAnalyticsJob(payload)

    case queueName.includes('webhook'):
      return await this.processWebhookJob(payload)

    default:
      throw new Error(`Unknown queue type: ${queueName}`)
  }
}


```

## Specialized Job Handlers

### Email Processing

```pseudo
async function processIncomingEmail(payload) {
  const { tenant_id, email_account_id, direction, type, from, to, subject, body, headers, messageId } = payload

  try {
    // Generate unique storage key
    const storageKey = `email_${messageId}_${Date.now()}`

    // Store email content
    const contentObject = await this.database.emailContent.create({
      data: {
        storage_key: storageKey,
        tenant_id: tenant_id,
        content_text: body.plain || body.html,
        content_html: body.html || convertToHtml(body.plain),
        headers: headers,
        raw_size_bytes: calculateSize(body),
        created: new Date(),
        retention_days: 2555 // 7 years
      }
    })

    // Create message reference
    const messageRef = await this.database.emailMessages.create({
      data: {
        storage_key: storageKey,
        tenant_id: tenant_id,
        email_account_id: email_account_id,
        direction: direction,
        message_type: type || 'email',
        from_email: from,
        to_email: Array.isArray(to) ? to.join(',') : to,
        subject: subject,
        status: 'received',
        processed: new Date()
      }
    })

    // Process attachments if present
    if (payload.attachments && payload.attachments.length > 0) {
      await this.processAttachments(payload.attachments, storageKey)
    }

    return {
      success: true,
      storageKey,
      contentObjectId: contentObject.storageKey,
      messageRefId: messageRef.storageKey
    }

  } catch (error) {
    throw new Error(`Email processing failed: ${error.message}`)
  }
}


```

### Email Sending

```pseudo
async function processEmailSending(payload) {
  const { campaign_id, recipient_id, email_template, personalizations } = payload

  try {
    // Get campaign and template data
    const campaign = await this.database.campaigns.findUnique({
      where: { id: campaign_id }
    })

    const template = await this.database.emailTemplates.findUnique({
      where: { id: email_template }
    })

    // Personalize email content
    const personalizedContent = await this.personalizeEmail(
      template.content,
      personalizations
    )

    // Send email via email service
    const sendResult = await this.emailService.sendEmail({
      to: personalizations.email,
      subject: this.interpolate(template.subject, personalizations),
      html: personalizedContent.html,
      text: personalizedContent.text,
      campaign_id: campaign_id,
      tenant_id: campaign.tenant_id
    })

    // Update delivery status
    await this.database.emailDeliveries.create({
      data: {
        campaign_id: campaign_id,
        recipient_id: recipient_id,
        message_id: sendResult.messageId,
        status: 'sent',
        sent_at: new Date(),
        provider_response: sendResult.response
      }
    })

    return {
      success: true,
      messageId: sendResult.messageId,
      deliveryId: sendResult.deliveryId
    }

  } catch (error) {
    throw new Error(`Email sending failed: ${error.message}`)
  }
}


```

### Warmup Processing

```pseudo
async function processWarmupJob(payload) {
  const { email_account_id, warmup_type, sequence_step } = payload

  try {
    // Get warmup configuration
    const warmupConfig = await this.database.warmupConfigs.findUnique({
      where: { email_account_id }
    })

    // Execute warmup action based on type and step
    switch (warmup_type) {
      case 'inbound':
        return await this.executeInboundWarmup(email_account_id, sequence_step)

      case 'outbound':
        return await this.executeOutboundWarmup(email_account_id, sequence_step)

      case 'engagement':
        return await this.executeEngagementWarmup(email_account_id, sequence_step)

      default:
        throw new Error(`Unknown warmup type: ${warmup_type}`)
    }

  } catch (error) {
    throw new Error(`Warmup processing failed: ${error.message}`)
  }
}


```

### Bounce Processing

```pseudo
async function processBounceJob(payload) {
  const { message_id, bounce_type, bounce_reason, recipient_email } = payload

  try {
    // Get original delivery record
    const delivery = await this.database.emailDeliveries.findUnique({
      where: { message_id },
      include: { campaign: true }
    })

    if (!delivery) {
      throw new Error(`Delivery record not found for message: ${message_id}`)
    }

    // Update delivery status
    await this.database.emailDeliveries.update({
      where: { id: delivery.id },
      data: {
        status: 'bounced',
        bounced_at: new Date(),
        bounce_type: bounce_type,
        bounce_reason: bounce_reason
      }
    })

    // Update campaign metrics
    await this.updateCampaignBounceMetrics(delivery.campaign_id, bounce_type)

    // Handle bounce based on type
    if (bounce_type === 'hard') {
      await this.handleHardBounce(delivery, recipient_email, bounce_reason)
    } else {
      await this.handleSoftBounce(delivery, recipient_email, bounce_reason)
    }

    return {
      success: true,
      deliveryId: delivery.id,
      bounceType: bounce_type
    }

  } catch (error) {
    throw new Error(`Bounce processing failed: ${error.message}`)
  }
}


```

## Error Handling and Retry Logic

### Job Failure Handling

```pseudo
async function handleJobFailure(job: Job, error: Error) {
  const { id, max_attempts, attempt_count = 0 } = job
  const attempts = attempt_count + 1

  try {
    if (attempts < max_attempts) {
      // Schedule retry with exponential backoff
      const delay = this.calculateBackoffDelay(attempts)

      log(`Scheduling retry ${attempts}/${max_attempts} for job ${id} in ${delay}ms`)

      await this.delay(delay)

      // Re-queue the job with updated attempt count
      await this.requeueJob(job, attempts)

      // Update tracking
      await this.redis.hset(`job:${id}`, {
        status: 'retry_scheduled',
        attempt_count: attempts.toString(),
        retry_delay: delay.toString()
      })

    } else {
      // Max attempts reached - mark as failed permanently
      await this.markJobFailed(job, error)
      await this.moveToDeadLetterQueue(job, error)
    }

    // Log failure
    await this.logJobExecution(id, 'failed', error.message)

  } catch (logError) {
    logError(`Failed to log job failure for ${id}`, logError)
  }
}


```

### Exponential Backoff Calculation

```pseudo
function calculateBackoffDelay(attemptNumber: number): number {
  // Exponential backoff: 2^attempt * base_delay
  const baseDelay = 1000    // 1 second base
  const maxDelay = 300000   // 5 minutes max

  const delay = Math.pow(2, attemptNumber) * baseDelay
  return Math.min(delay, maxDelay)
}

// Example delays:
// Attempt 1: 2s
// Attempt 2: 4s
// Attempt 3: 8s
// Attempt 4: 16s
// Attempt 5: 32s
// Attempt 6: 64s
// Attempt 7: 128s
// Attempt 8: 256s
// Attempt 9: 300s (max)


```

## Job Status Management

### Status Updates

```pseudo
async function updateJobStatus(jobId: string, status: JobStatus, additionalData: any = {}) {
  const updateData = {
    status,
    updated_at: new Date(),
    ...additionalData
  }

  // Update PostgreSQL
  await this.database.jobs.update({
    where: { id: jobId },
    data: updateData
  })

  // Update Redis for real-time monitoring
  await this.redis.hset(`job:${jobId}`, {
    status: status,
    updated_at: new Date().toISOString(),
    ...additionalData
  })
}

async function markJobCompleted(jobId: string, result: any) {
  await this.updateJobStatus(jobId, 'completed', {
    completed_at: new Date(),
    result: JSON.stringify(result)
  })

  await this.redis.hset(`job:${jobId}`, {
    status: 'completed',
    completed_at: new Date().toISOString(),
    result: JSON.stringify(result)
  })
}


```

## Performance Optimization

### Batch Processing

```pseudo
// Process multiple jobs in batch for efficiency
async function processBatch(jobs: Job[]) {
  const results = []

  // Process jobs concurrently with limits
  const batchSize = 5  // Max concurrent jobs
  const batches = chunk(jobs, batchSize)

  for (const batch of batches) {
    const batchPromises = batch.map(async (job) => {
      try {
        return await this.processJob(job, job.queue_name)
      } catch (error) {
        logError(`Batch job ${job.id} failed`, error)
        return { success: false, error: error.message }
      }
    })

    const batchResults = await Promise.all(batchPromises)
    results.push(...batchResults)

    // Small delay between batches to prevent overwhelming
    await this.delay(100)
  }

  return results
}


```

## Worker Scaling and Load Distribution

### Horizontal Scaling Strategy

```pseudo
// Auto-scaling based on queue depth
async function monitorScaling() {
  const queueDepths = await this.getQueueDepths()
  const activeWorkers = await this.getActiveWorkerCount()

  for (const [queueName, depth] of Object.entries(queueDepths)) {
    // Scale up if queue is backing up
    if (depth > HIGH_WATER_MARK && activeWorkers < MAX_WORKERS) {
      await this.scaleUpWorkers(queueName)
    }

    // Scale down if queue is empty
    if (depth < LOW_WATER_MARK && activeWorkers > MIN_WORKERS) {
      await this.scaleDownWorkers(queueName)
    }
  }
}

function getQueueList(): string[] {
  return [
    'queue:email:processing:high',    // Highest priority
    'queue:email:processing',
    'queue:email:processing:low',
    'queue:email-sending:high',
    'queue:email-sending',
    'queue:email-sending:low',
    'queue:warmup:process',
    'queue:bounce:process',
    'queue:analytics:daily-aggregate',
    'queue:webhook:process'
  ]
}


```

### Graceful Shutdown

```pseudo
async function gracefulShutdown() {
  log('Initiating graceful shutdown')

  // Stop accepting new jobs
  this.isRunning = false

  // Wait for current jobs to complete
  const maxWaitTime = 30000 // 30 seconds
  const startTime = Date.now()

  while (this.hasActiveJobs() && (Date.now() - startTime) < maxWaitTime) {
    log('Waiting for active jobs to complete...')
    await this.delay(1000)
  }

  // Force shutdown if jobs are taking too long
  if (this.hasActiveJobs()) {
    log('Force shutdown - jobs exceeded time limit')
  }

  await this.cleanup()
  process.exit(0)
}


```

## Monitoring and Health Checks

### Worker Health Monitoring

```pseudo
async function getWorkerHealth() {
  return {
    worker_id: this.workerId,
    status: this.isRunning ? 'healthy' : 'stopped',
    uptime: process.uptime(),
    memory_usage: process.memoryUsage(),
    jobs_processed: this.getJobsProcessedCount(),
    jobs_failed: this.getJobsFailedCount(),
    average_processing_time: this.getAverageProcessingTime(),
    last_heartbeat: new Date().toISOString()
  }
}

function generateWorkerId(): string {
  const hostname = require('os').hostname()
  const pid = process.pid
  const random = Math.random().toString(36).substr(2, 9)
  return `worker-${hostname}-${pid}-${random}`
}


```

## Conclusion

Worker processes provide:

- **Reliable Job Processing**: Comprehensive error handling and retry logic

- **Horizontal Scalability**: Stateless design supports unlimited worker instances

- **Priority Handling**: Multi-queue consumption with proper priority ordering

- **Fault Tolerance**: Graceful shutdown and failure recovery mechanisms

- **Performance Optimization**: Batch processing and memory management

- **Monitoring Integration**: Real-time health and performance metrics

This architecture ensures robust, scalable job processing that can handle varying workloads while maintaining system reliability and performance.
