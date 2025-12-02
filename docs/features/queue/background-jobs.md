---
title: "Queue & Background Jobs"
description: "Detailed breakdown of background job processing and worker types"
last_modified_date: "2025-11-24"
level: "3"
persona: "Developers, DevOps"
status: "ACTIVE"
category: "Queue"
---


# Queue & Background Jobs

## Deep dive into the background processing system that powers PenguinMails

---

## Overview

PenguinMails relies heavily on asynchronous background processing to ensure the web interface remains fast and responsive. We use **PostgreSQL + Redis queue system** to manage these jobs.

### Job Types

| Job Name | Priority | Description |
|----------|----------|-------------|
| `email.send` | High/Normal | Delivers a single email |
| `campaign.process` | Normal | Breaks a campaign into email jobs |
| `import.contacts` | Low | Processes CSV uploads |
| `export.data` | Low | Generates CSV exports |
| `webhook.dispatch` | High | Sends events to external URLs |
| `maintenance.cleanup` | Low | Daily database cleanup |

---

## Job Definitions

### 1. Email Send Job (`email.send`)

## Payload

```json

{
  "recipient": "user@example.com",
  "template_id": "tpl_123",
  "variables": { "name": "Alice" },
  "tenant_id": "tenant_abc",
  "campaign_id": "camp_xyz"
}


```sql

## Processing Logic:


1. Render HTML template.


2. Check suppression list.


3. Select sending provider (Internal/ESP).


4. Send email.


5. Update analytics.


### 2. Campaign Process Job (`campaign.process`)

## Payload:


```

{
  "campaign_id": "camp_xyz",
  "tenant_id": "tenant_abc"
}

```sql

## Processing Logic:


1. Fetch target list/segment.


2. Iterate through contacts.


3. Create `email.send` jobs (batched).


4. Update campaign status to "Sending".


### 3. Contact Import Job (`import.contacts`)

## Payload:


```

{
  "file_url": "s3://uploads/list.csv",
  "tenant_id": "tenant_abc",
  "mapping": { "col_0": "email", "col_1": "name" }
}

```text

## Processing Logic:


1. Stream CSV file.


2. Validate email format.


3. Upsert contacts to database.


4. Update list counts.


5. Notify user of completion.

---


## Worker Configuration


### Concurrency & Scaling

Workers are stateless Node.js processes.


- **Email Workers**: High concurrency (50-100 per node). I/O bound.


- **Import Workers**: Low concurrency (2-5 per node). CPU/Memory bound.

## Scaling Policy:


- Scale up Email Workers when `queue_depth > 1000`.


- Scale up Import Workers when `memory_usage > 80%`.


### Reliability


- **Graceful Shutdown**: Workers finish current job before stopping.


- **Stalled Job Detection**: Redis automatically re-queues jobs if worker crashes.


- **Idempotency**: Jobs are designed to be safe to run multiple times (e.g., checking status before sending).

---


## Monitoring

## Queue Dashboard:
Internal admin tool to view:


- Active jobs


- Waiting jobs


- Failed jobs


- Job throughput

## Metrics (Prometheus):


- `jobs_completed_total`


- `jobs_failed_total`


- `job_duration_seconds`

---


## Related Documentation


### Architecture


- **[Core Email Pipeline](/docs/features/queue/email-pipeline)** - High-level pipeline architecture


### Tasks


- **[Epic 6: Core Email Pipeline](/tasks/epic-6-core-email-pipeline/README)** - Implementation tasks

---

**Last Updated:** November 24, 2025
**Queue Engine:** PostgreSQL + Redis

*Background jobs allow PenguinMails to handle heavy workloads without blocking the user experience.*
