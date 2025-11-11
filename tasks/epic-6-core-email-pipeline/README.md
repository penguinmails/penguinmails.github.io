# Epic 6: Core Email Sending & Processing Pipeline

**Last Updated:** November 11, 2025  
**Status:** Not Started  
**Epic ID:** MAIL-EPIC-6

## Overview

### Objective
To develop the end-to-end, asynchronous pipeline for scheduling, sending, and tracking every email dispatched by the PenguinMails platform. This includes the scheduler that creates sending jobs, the worker that processes jobs via SMTP, and the tracking system to ingest engagement events.

### Description
This epic implements the core engine of PenguinMails: a decoupled, high-throughput sending pipeline built on Redis queues and a standalone worker process. Deliverables include a Campaign Scheduler (producer), a standalone Email Processor worker (consumer), job payload schemas, and a high-performance public tracking API for opens and clicks that pushes analytics events into an asynchronous processing queue.

### Prerequisites
- Epics 1–5 substantially complete (Redis configured, relevant DB schemas migrated, tenant management available).
- Ability to run a separate Node.js process for the worker (distinct from Next.js server).

## Milestones

1. **[Milestone 1: Job Enqueueing and Campaign Scheduling](./milestone-1-job-enqueueing-and-campaign-scheduling/)**
2. **[Milestone 2: The Email Sending Worker](./milestone-2-email-sending-worker/)**
3. **[Milestone 3: Engagement Tracking](./milestone-3-engagement-tracking/)**

## Success Criteria

- Job payload schemas and validation exist.
- Scheduler reliably enqueues due jobs into Redis.
- A standalone worker can consume jobs, assemble and send emails, and log results.
- Tracking endpoints quickly accept events and enqueue analytics jobs.

---

*For detailed ticket information, open the milestone folders.*

## Related documentation

These docs contain project-level guidance and constraints relevant to implementation and operations for the email pipeline:

- [Technical Architecture — Overview](../docs/technical/architecture/overview.md)
- [Development Standards (coding, linting, CI)](../docs/implementation-technical/development-guidelines/development-standards.md)
- [Operations: Infrastructure & Management](../docs/operations-analytics/operations-management/infrastructure-operations-management.md)
- [Quick Setup / Getting Started](../docs/quick-setup.md)
- [Compliance & Security Framework](../docs/compliance-security/enterprise/security-framework.md)