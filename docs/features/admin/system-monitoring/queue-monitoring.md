---
title: "Queue Monitoring"
description: "Background job monitoring and management for hybrid PostgreSQL + Redis queue system"
last_modified_date: "2025-12-04"
level: "3"
persona: "Operations Engineers"
status: "ACTIVE"
category: "Admin"
---

# Queue Monitoring

**Real-time monitoring and management of background jobs across the hybrid queue system.**

---

## Overview

The Queue Monitoring feature provides operations engineers with comprehensive visibility into PenguinMails' hybrid PostgreSQL + Redis background job processing system. Monitor queue health, identify bottlenecks, and take corrective actions to ensure reliable email delivery and analytics processing.

### Key Capabilities

- **Queue Health Dashboard**: Monitor active, waiting, and failed jobs per queue
- **Job Details**: Inspect job payloads and error traces
- **Queue Controls**: Pause, resume, and prioritize queues
- **Job Actions**: Retry failed jobs, delete stuck jobs
- **Real-Time Updates**: Auto-refresh every 5 seconds

---

## Queue Architecture

### Hybrid System Design

- **PostgreSQL**: Durable job storage and state management
- **Redis**: Fast in-memory processing queue
- **Write Path**: Jobs written to PostgreSQL → Published to Redis
- **Read Path**: Workers consume from Redis → Update PostgreSQL state

### Queue Types

| Queue Name | Priority | Use Case | Target Processing Time |
|------------|----------|----------|----------------------|
| `queue:email-sending:high` | High | Transactional emails | <1 minute |
| `queue:email-sending` | Normal | Campaign emails | <5 minutes |
| `queue:email-sending:low` | Low | Bulk exports | <30 minutes |
| `queue:analytics:daily-aggregate` | Normal | Daily metrics | <1 hour |
| `queue:warmup:process` | Normal | Email warmup tasks | <15 minutes |

---

## Feature Components

### Queue Dashboard

**Queue List Table**:

- Columns: Queue Name, Active Jobs, Waiting, Completed (last hour), Failed, Actions
- Color Coding:
  - Green: Healthy (waiting < 100)
  - Yellow: Warning (waiting 100-1000)
  - Red: Critical (waiting > 1000 or failures > 10)

**Per-Queue Actions**:

- **View Details**: Drill into job list
- **Pause Queue**: Emergency stop for troubleshooting
- **Resume Queue**: Re-enable processing
- **Clear Failed**: Bulk delete failed jobs

### Job Details Modal

**Triggered by**: Clicking on a job in the queue

**Components**:

- **Job Metadata**: ID, Queue, Status, Created, Attempts
- **Payload Viewer**: JSON viewer showing job data (e.g., campaign ID, recipient list)
- **Error Details**: Stack trace and error message for failed jobs
- **Actions**:
  - **Retry Job**: Re-queue with reset attempt counter
  - **Delete Job**: Permanent removal

---

## User Stories

### Ops Engineer (High Email Volume)

> *"During a Black Friday campaign, the email queue is backing up. I need to prioritize transactional emails over marketing."*
>
> **Workflow**:
>
> 1. Navigate to queue dashboard
> 2. Check `queue:email-sending:high` - processing normally
> 3. Check `queue:email-sending` - 5,000 jobs waiting (backlog)
> 4. Pause `queue:email-sending:low` to free workers
> 5. Scale up workers for normal queue
> 6. Monitor until backlog clears
> 7. Resume low-priority queue

### DevOps Engineer (Failed Jobs)

> *"Analytics aggregation job is failing repeatedly. I need to inspect the error and retry after deploying a fix."*
>
> **Workflow**:
>
> 1. Navigate to queue dashboard
> 2. Click on `queue:analytics:daily-aggregate`
> 3. View failed jobs (12 failures)
> 4. Click on first failed job
> 5. Inspect error: "Division by zero in MRR calculation"
> 6. Deploy code fix
> 7. Retry all failed jobs
> 8. Verify successful completion

---

## Technical Integration

### Database Schema

- **jobs Table** (PostgreSQL): Job definitions and state
  - Columns: id, queue, payload, status, attempts, created_at, updated_at
- **job_queues Table**: Queue metadata and statistics
- **job_logs Table**: Execution history andretry attempts

### Redis Integration

- **Queue Keys**: `queue:{name}` (list)
- **Job Data**: Stored as JSON in Redis
- **TTL**: 24 hours (jobs expire if not processed)

### Monitoring

- **Prometheus Metrics**: Queue depth, job duration, failure rate *(2026 Spike)*
- **Alerting**: PagerDuty alert if queue depth > 10,000 or failure rate > 5%

---

## Related Documentation

- [Platform Admin Routes - Queue Monitoring](/docs/design/routes/platform-admin#dashboard-system-queues)
- [System Monitoring API](/docs/implementation-technical/api/platform-api/system-monitoring)
- [Queue System Implementation](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation)
