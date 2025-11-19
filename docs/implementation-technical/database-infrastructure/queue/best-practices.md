---
title: "Queue System Best Practices"
description: "Queue System Best Practices - Performance and Reliability Guidelines"
last_modified_date: "2025-11-19"
level: "2"
persona: "Engineering Teams"
related_docs:
  - "[Main Guide](main.md) - Complete overview"
  - "[Architecture](architecture.md) - System design principles"
  - "[Operations](operations.md) - Deployment and monitoring"
---

# Queue System Best Practices

## Overview

These best practices ensure optimal performance, reliability, and maintainability of the queue system. Following these guidelines will help prevent common issues and maximize system efficiency.

## Performance Optimization

### Job Design Principles

**Minimize Job Payload Size**
```pseudo
// GOOD: Minimal, essential data only
good_job_payload = {
  email_id: "uuid-123",           // Reference ID
  template_id: "welcome-001",     // Template reference
  recipient_email: "user@domain.com",
  personalization_data: {         // Small config only
    name: "John",
    company: "Acme Corp"
  }
}

// AVOID: Large data payloads
bad_job_payload = {
  // Don't include full email content
  email_html: "<html>100KB of HTML content...</html>",
  email_text: "100KB of plain text content...",
  // Don't include attachments
  attachments: ["large-file.pdf", "huge-image.jpg"],
  // Don't include sensitive data
  api_keys: "secret-key-value",
  user_data: full_user_profile_object
}
```

### Database Optimization

**Index Strategy**
```pseudo
-- Essential indexes for queue operations

-- Job migration optimization (most important)
CREATE INDEX idx_jobs_queuer_migration 
ON jobs(status, run_at, priority, created_at) 
WHERE status = 'queued';

-- Queue-specific queries
CREATE INDEX idx_jobs_by_queue 
ON jobs(queue_name, status, priority) 
WHERE status IN ('queued', 'migrated_to_redis');

-- Status reporting and analytics
CREATE INDEX idx_jobs_status_time 
ON jobs(status, updated_at DESC);
```

## Reliability Patterns

### Idempotent Job Processing

**Design for Idempotency**
```pseudo
// GOOD: Idempotent job design
async function sendWelcomeEmail(job) {
  const { recipient_email, template_id, campaign_id } = job.payload
  
  // Check if email was already sent
  const existingDelivery = await database.emailDeliveries.findFirst({
    where: {
      recipient_email,
      campaign_id,
      template_id,
      status: 'sent'
    }
  })
  
  if (existingDelivery) {
    log(`Email already sent to ${recipient_email}, skipping`)
    return { skipped: true, reason: 'already_sent' }
  }
  
  // Send email
  const result = await emailService.send({
    to: recipient_email,
    template: template_id
  })
  
  // Record delivery
  await database.emailDeliveries.create({
    data: {
      recipient_email,
      campaign_id,
      template_id,
      message_id: result.messageId,
      status: 'sent'
    }
  })
  
  return { success: true, messageId: result.messageId }
}
```

### Timeout Management

**Job Timeouts**
```pseudo
// Set appropriate timeouts for different job types
JOB_TIMEOUTS = {
  email_sending: 30,           // 30 seconds
  email_processing: 60,        // 1 minute
  analytics: 300,              // 5 minutes
  warmup: 120,                 // 2 minutes
  webhook: 15                  // 15 seconds
}

async function processJobWithTimeout(job) {
  const timeout = JOB_TIMEOUTS[job.queue_name] || 60
  
  const timeoutPromise = new Promise((_, reject) => {
    setTimeout(() => reject(new Error('Job timeout')), timeout * 1000)
  })
  
  try {
    const result = await Promise.race([
      executeJobLogic(job),
      timeoutPromise
    ])
    
    return result
    
  } catch (error) {
    if (error.message === 'Job timeout') {
      await handleJobTimeout(job)
    }
    throw error
  }
}
```

## Security Considerations

### Job Validation

**Input Validation**
```pseudo
function validateJobPayload(payload) {
  const schema = {
    recipient_email: Joi.string().email().required(),
    template_id: Joi.string().pattern(/^[a-zA-Z0-9-_]+$/).required(),
    campaign_id: Joi.string().uuid().required(),
    priority: Joi.number().integer().min(1).max(1000).default(100)
  }
  
  const { error, value } = Joi.validate(payload, schema)
  
  if (error) {
    throw new ValidationError(`Invalid job payload: ${error.message}`)
  }
  
  return value
}
```

## Monitoring and Observability

### Key Metrics

**Essential Metrics to Track**
```pseudo
class QueueMetrics {
  async collectMetrics() {
    return {
      // Throughput metrics
      jobs_processed_per_minute: await this.getJobsPerMinute(),
      jobs_created_per_minute: await this.getJobCreationRate(),
      
      // Latency metrics
      average_processing_time: await this.getAverageProcessingTime(),
      p95_processing_time: await this.getPercentileProcessingTime(95),
      
      // Error metrics
      error_rate: await this.getErrorRate(),
      failed_jobs_count: await this.getFailedJobsCount(),
      
      // Queue health
      queue_depths: await this.getQueueDepths(),
      oldest_job_age: await this.getOldestJobAge(),
      
      // Worker metrics
      active_workers: await this.getActiveWorkerCount(),
      worker_utilization: await this.getWorkerUtilization()
    }
  }
}
```

## Error Handling

### Comprehensive Error Strategy

**Error Classification**
```pseudo
class JobErrorHandler {
  static isRetryable(error) {
    // Retry on transient errors
    const retryableErrors = [
      'ECONNRESET',
      'ETIMEDOUT', 
      'ENOTFOUND',
      'ECONNREFUSED',
      'temporary_failure'
    ]
    
    return retryableErrors.some(errorType => 
      error.message.includes(errorType)
    )
  }
  
  static getRetryDelay(attemptCount, errorType) {
    // Exponential backoff with jitter
    const baseDelay = 1000
    const maxDelay = 300000 // 5 minutes
    
    const exponentialDelay = Math.min(
      baseDelay * Math.pow(2, attemptCount),
      maxDelay
    )
    
    // Add random jitter (±25%)
    const jitter = exponentialDelay * 0.25
    const delay = exponentialDelay + (Math.random() - 0.5) * jitter * 2
    
    return Math.floor(delay)
  }
}
```

## Operational Excellence

### Deployment Best Practices

**Rolling Updates**
```pseudo
# Kubernetes rolling update strategy
apiVersion: apps/v1
kind: Deployment
metadata:
  name: queue-worker
spec:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1                    # Allow 1 extra worker during update
      maxUnavailable: 1              # Ensure at least N-1 workers available
```

## Conclusion

These best practices provide a foundation for building and operating a robust, scalable queue system:

**Performance**: Optimized job design, efficient database queries, and proper Redis configuration
**Reliability**: Idempotent operations, timeout management, and graceful shutdown procedures  
**Security**: Input validation, access control, and data encryption where necessary
**Observability**: Comprehensive monitoring, structured logging, and health checks
**Operations**: Proper deployment strategies, capacity planning, and error handling

Following these guidelines will help ensure your queue system can handle production workloads reliably while remaining maintainable and observable.