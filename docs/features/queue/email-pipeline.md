---
title: "Core Email Pipeline"
description: "High-throughput email sending and processing pipeline architecture"
last_modified_date: "2025-11-24"
level: "3"
persona: "Backend Developers, Architects"
status: "ACTIVE"
category: "Queue"
---

# Core Email Pipeline

## High-performance, reliable email processing pipeline powered by Redis and postgres queue system

---

## Overview

The Core Email Pipeline is the engine of PenguinMails, responsible for processing, queuing, and delivering millions of emails reliably. It handles campaign scheduling, throttling, personalization, and delivery via internal SMTP nodes or external ESPs.

### Key Capabilities

- **High Throughput** - Process 10,000+ emails/minute

- **Reliable Queuing** - At-least-once delivery guarantee

- **Smart Throttling** - Respect provider and warmup limits

- **Personalization** - Dynamic content injection

- **Failure Handling** - Automatic retries and dead-letter queues

---

## Level 1: Pipeline Architecture

### Data Flow

```mermaid

graph TD
    A[Campaign Trigger] -->|Batch Jobs| B[Job Creator]
    B -->|Individual Email Jobs| C[Redis Queue]
    C -->|Pop Job| D[Worker Nodes]
    D -->|Render Template| E[Content Engine]
    E -->|Select Gateway| F[Routing Logic]
    F -->|SMTP| G[Internal Node]
    F -->|API| H[External ESP]
    G --> I[Recipient]
    H --> I
    I -->|Webhook| J[Analytics Processor]

```sql

1. **Campaign Trigger**: User schedules a campaign or API triggers a send.

2. **Job Creator**: Breaks campaign into individual email jobs.

3. **Redis Queue**: Buffers jobs, managing priority and scheduling.

4. **Worker Nodes**: Scalable fleet of workers processing jobs.

5. **Content Engine**: Replaces variables (`{{name}}`) with actual data.

6. **Routing Logic**: Decides delivery path (Internal vs. ESP).

7. **Delivery**: Sends email.

8. **Analytics**: Tracks delivery, opens, clicks via webhooks.

---

## Level 2: Queue Management

### Technology Stack

- **Queue Engine**: PostgreSQL + Redis (Native queue implementation)

- **Storage**: Redis (Persistent) + PostgreSQL (Job metadata)

- **Workers**: Node.js microservices

### Queue Structure

The pipeline uses multiple queues to manage priority and isolation:

1. **`priority-high`**: Transactional emails (password resets, alerts). Processed immediately.

2. **`campaign-standard`**: Bulk marketing emails. Standard priority.

3. **`warmup`**: Automated warmup traffic. Lower priority.

4. **`retry`**: Failed jobs waiting for retry.

### Throttling & Rate Limiting

## Global Rate Limiting:
Prevents overwhelming the database or external APIs.

## Per-Tenant Rate Limiting:
Ensures fair usage among tenants.

- *Starter Plan*: 10 emails/sec

- *Business Plan*: 100 emails/sec

## Per-Node Throttling:
Respects warmup limits for internal IPs.

- *Day 1*: 50 emails/day

- *Day 2*: 100 emails/day

- ...

---

## Level 3: Technical Implementation

### Job Lifecycle

A single email job (`EmailJob`) goes through these states:

1. **Waiting**: In Redis, waiting for a worker.

2. **Active**: Being processed by a worker.

3. **Completed**: Successfully sent to upstream provider.

4. **Failed**: Error occurred (e.g., timeout, API error).

5. **Delayed**: Scheduled for future (e.g., "Send at 9 AM").

### Worker Logic

```

// Queue worker implementation using PostgreSQL + Redis

const emailWorker = new Worker('email-queue', async (job: Job) => {
  const { recipient, templateId, data, tenantId } = job.data;

  // 1. Fetch Tenant Settings & Routing Rules
  const settings = await getTenantSettings(tenantId);

  // 2. Render Content
  const html = await renderTemplate(templateId, data);

  // 3. Determine Route (Failover Logic)
  const provider = determineProvider(settings);

  // 4. Send
  try {
    const result = await sendEmail(provider, recipient, html);
    await logAnalytics('sent', job.id);
    return result;
  } catch (error) {
    // 5. Handle Soft Failures (Retry)
    if (isRetryable(error)) {
      throw error; // Queue system will retry based on backoff config
    }
    // Hard Failure
    await logAnalytics('failed', job.id, error);
    return UnrecoverableError(error);
  }
}, {
  concurrency: 50,
  limiter: {
    max: 1000,
    duration: 1000
  }
});

### Failure Handling

## Retry Strategy

- **Exponential Backoff**: Wait 1s, then 2s, 4s, 8s...

- **Max Retries**: 3 attempts standard, 5 for high priority.

## Dead Letter Queue (DLQ)

Jobs that fail all retries are moved to DLQ for manual inspection. This prevents data loss.

### Scalability

- **Stateless Workers**: Workers can be scaled horizontally (Kubernetes/Docker).

- **Redis Cluster**: Supports high throughput and data persistence.

- **Batch Processing**: Campaign jobs are batched to reduce database load.

---

## Related Documentation

### Features

- **[Campaign Management](/docs/features/campaigns/campaign-management/hub)** - The source of most pipeline jobs

- **[ESP Integration](/docs/features/integrations/esp-integration)** - External delivery gateways

### Tasks

- **Epic 6: Core Email Pipeline** - Internal task reference for development work

---

**Last Updated:** November 24, 2025
**Engine:** PostgreSQL + Redis Queue System
**Throughput:** Scalable to millions/hour

*The Core Email Pipeline ensures that every email is delivered, tracked, and accounted for, regardless of volume.*
