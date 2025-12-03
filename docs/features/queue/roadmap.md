---
title: "Queue & Background Jobs Roadmap"
description: "Timeline for queue system enhancements and future capabilities"
last_modified_date: "2025-11-26"
level: "2"
persona: "Product Teams, Technical Teams"
---


# Queue & Background Jobs Roadmap

Timeline for queue system enhancements from current active state through future advanced capabilities.

## Executive Summary

**Current State**: Core email pipeline and background jobs active
**Future Enhancements**: Queue monitoring dashboard, advanced scheduling, notification system
**Status**: Production-ready, future enhancements as needed

**Strategic Focus**:

- **Now**: High-throughput email processing (ACTIVE)

- **Future**: Enhanced monitoring, advanced scheduling, notification system

---

## Current State (ACTIVE)

### Email Pipeline (PostgreSQL + Redis)

**Status**: ACTIVE (Production-Ready)
**Throughput**: 10,000+ emails/minute

**Capabilities**:

- **High Throughput**: Process 10,000+ emails/minute

- **Reliable Delivery**: At-least-once delivery guarantee with retry logic

- **Smart Throttling**: Respect provider limits and warmup constraints

- **Dynamic Content**: Personalization injection during sending

- **Automatic Retries**: Exponential backoff for failed jobs (max 3 attempts)

- **Dead-Letter Queue**: Failed jobs moved to DLQ for investigation

- **Multiple Priorities**: priority-high, campaign-standard, warmup, retry queues

- **Per-Tenant Rate Limiting**: Enforce tenant-specific sending limits

- **Per-Node Throttling**: Warmup-aware throttling per sending node

- **Stateless Workers**: Horizontal scaling support (50-100 workers per node)

**Technical Architecture**:

- **PostgreSQL**: Job metadata and state storage

- **Redis**: Active queue for high-performance processing

- **Worker Pools**: Separate pools for email, import, export jobs

- **Concurrency**: 50-100 email workers per node, 2-5 import workers per node

**Success Metrics**:

- Throughput: 10,000+ emails/minute

- Delivery guarantee: 99.9%+ (at-least-once)

- Job latency: < 5 seconds from enqueue to processing

- Retry success rate: 80%+ of failed jobs succeed on retry

---

### Background Jobs

**Status**: ACTIVE (Production-Ready)

**Job Types**:

1. **email.send**: Send individual emails (high concurrency: 50-100 per node)

2. **campaign.process**: Process active campaigns, execute next steps (every 5 minutes)

3. **import.contacts**: Import contact lists (low concurrency: 2-5 per node)

4. **export.data**: Export analytics data (low concurrency: 2-5 per node)

5. **webhook.dispatch**: Send webhook notifications (medium concurrency: 10-20 per node)

6. **maintenance.cleanup**: Clean up old data (daily)

**Campaign Processing Jobs**:

- **campaign-processor** (every 5 minutes): Process active campaigns, execute next steps

- **campaign-analytics-aggregator** (daily at 2 AM): Aggregate campaign metrics

- **campaign-auto-complete** (hourly): Mark completed campaigns

**Warmup Processing Jobs**:

- **warmup-scheduler** (daily at 9 AM): Schedule daily warmup emails

- **warmup-health-check** (hourly): Check warmup health and auto-pause if needed

- **warmup-engagement-simulator**: Simulate opens, clicks, replies for warmup pool

- **blacklist-checker** (hourly): Check domains and IPs against blacklists

- **reputation-calculator** (daily at 2 AM): Calculate domain health scores

**Queue Processing Jobs**:

- **email-worker**: Process email send jobs (high concurrency: 50-100 per node)

- **import-worker**: Process contact imports (low concurrency: 2-5 per node)

- **stalled-job-detector**: Re-queue stalled jobs

**Capabilities**:

- **Priority-Based Processing**: High-priority jobs processed first

- **Graceful Shutdown**: Complete jobs before shutdown

- **Stalled Job Detection**: Re-queue stalled jobs automatically (after 30 minutes)

- **Idempotent Design**: Safe to retry jobs without side effects

- **Queue Monitoring**: Real-time dashboard (admin-only)

- **Prometheus Metrics**: Integration for monitoring (`jobs_completed_total`, throughput, queue backlogs)

**Success Metrics**:

- Job completion rate: 99%+

- Stalled job rate: < 1%

- Graceful shutdown success: 100%

- Idempotency: 100% (no duplicate side effects)

---

## Future Enhancements

### Queue Monitoring Dashboard

**Priority**: Medium
**Timeline**: As needed based on operational requirements

**Planned Capabilities**:

- Real-time queue depth visualization

- Job throughput metrics (jobs/minute, jobs/hour)

- Worker health monitoring (active workers, idle workers, failed workers)

- Alert configuration (queue depth thresholds, job failure rates)

- Historical trend analysis (last 7 days, last 30 days)

- Job failure investigation (view failed job details, retry manually)

**Value Proposition**: Enhanced operational visibility for troubleshooting and capacity planning.

**Technical Requirements**:

- Real-time metrics dashboard (React + WebSocket)

- Historical data storage (PostgreSQL time-series)

- Alert configuration UI

- Job failure investigation UI

---

### Advanced Job Scheduling

**Priority**: Low
**Timeline**: Future (as needed for complex workflows)

**Planned Capabilities**:

- Job dependencies (wait for other jobs to complete)

- Workflow orchestration (multi-step workflows with conditional logic)

- Scheduled recurring jobs (cron-like scheduling)

- Job chaining (automatically enqueue next job on completion)

- Conditional execution (execute job only if condition met)

**Value Proposition**: Support for complex multi-step workflows and dependencies.

**Technical Requirements**:

- Workflow engine (state machine)

- Job dependency graph

- Cron scheduler

- Conditional execution logic

---

### Notification System

**Priority**: Medium
**Timeline**: Future (as needed for user notifications)

**Planned Capabilities**:

- In-app notifications (real-time via WebSocket)

- Email notifications (via transactional email service)

- Push notifications (mobile apps)

- Notification preferences (per-user settings)

- Alert management (system alerts, user alerts)

- Notification history (view past notifications)

**Value Proposition**: Keep users informed of important events (campaign completion, reputation issues, etc.).

**Technical Requirements**:

- Notification service (background jobs)

- WebSocket server (real-time in-app notifications)

- Email template system (notification emails)

- Push notification service (Firebase, APNs)

- Notification preferences storage

---

## Related Documentation

### Feature Documentation

- [Queue & Background Jobs Overview](/docs/features/queue) - Queue features catalog

- [Campaign Management](/docs/features/campaigns) - Email campaigns using queue system

- [Warmup & Reputation](/docs/features/warmup) - Warmup jobs and scheduling

### Technical Implementation

- [Queue API](/docs/implementation-technical/api/queue) - Background job management

- [Email Pipeline](/docs/features/queue/email-pipeline) - Email sending infrastructure

- Epic 6: Core Email Pipeline - Internal task reference for implementation work

### Business Strategy

- [Product Roadmap](/docs/operations/roadmap/product-roadmap) - Overall product timeline

- [Technical Roadmap](/docs/operations/roadmap/technical-roadmap) - Technical dependencies

---

**Last Updated**: November 26, 2025
**Roadmap Owner**: Engineering Team
**Next Review**: As operational needs evolve
