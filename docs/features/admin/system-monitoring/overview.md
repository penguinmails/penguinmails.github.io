---
title: "System Monitoring"
description: "Infrastructure health, queue monitoring, and system logs for PenguinMails operations team"
last_modified_date: "2025-12-04"
level: "2"
persona: "Operations Engineers, DevOps"
status: "ACTIVE"
category: "Admin"
---

# System Monitoring

**Real-time infrastructure health, background job monitoring, and centralized log access for platform operations.**

---

## Overview

The System Monitoring feature provides PenguinMails operations team with comprehensive visibility into platform health, background job processing, and application logs. It serves as the primary dashboard for proactive monitoring, incident response, and performance troubleshooting.

### Key Capabilities

- **Infrastructure Health**: Real-time service status and performance metrics
- **Queue Monitoring**: Hybrid PostgreSQL + Redis job queue management
- **Log Viewer**: Centralized application log search and analysis
- **IP Reputation**: Email deliverability monitoring
- **Alerting Integration**: PagerDuty and Slack notifications

---

## Sub-Features

### [Queue Monitoring](/docs/features/admin/system-monitoring/queue-monitoring)

Monitor and manage background jobs across the hybrid PostgreSQL + Redis queue system.

### [Infrastructure Monitoring](/docs/features/admin/system-monitoring/infrastructure-monitoring)

Track server health, IP reputation, and service availability.

### [Log Viewer](/docs/features/admin/system-monitoring/log-viewer)

Search and analyze application logs for debugging and troubleshooting.

### [Metrics Glossary](/docs/features/admin/system-monitoring/metrics-glossary)

Reference guide for all available metrics, their sources, and update frequencies.

---

## User Stories

### Operations Engineer (Queue Management)

> *"As an ops engineer, I need to check if the email sending queue is backing up during a high-volume campaign launch."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/system/queues`
> 2. Check `queue:email-sending` active jobs
> 3. Review queue depth and processing rate
> 4. If backed up, scale workers or pause low-priority queues
> 5. Monitor until queue drains

### DevOps Engineer (Incident Response)

> *"As a DevOps engineer, I need to investigate SMTP service degradation reported by monitoring alerts."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/system/infrastructure`
> 2. Check SMTP service status card (shows "Degraded")
> 3. View infrastructure alerts for root cause
> 4. Navigate to log viewer to search SMTP errors
> 5. Identify and resolve issue

### Developer (Debugging)

> *"As a developer, I need to trace a production error to its source using request ID from customer support ticket."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/system/logs`
> 2. Search by request ID
> 3. Filter to Error level logs
> 4. Expand error entry for stack trace
> 5. Identify code path and deploy fix

---

## Integration Architecture

### Queue System Integration

- **Hybrid Architecture**: PostgreSQL for durability + Redis for speed
- **Queue Types**: High, Normal, Low priority
- **Job Categories**: Email sending, analytics aggregation, warmup processing
- **Monitoring**: Real-time job counts and failure tracking

See [Queue System Implementation](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation) for technical details.

### Monitoring Stack

> [!NOTE]
> For launch, **PostHog handles basic monitoring and alerting**. The tools below are planned for evaluation in a [2026 spike](/docs/operations/roadmap/observability-roadmap).

- **Metrics Collection**: Prometheus for time-series data *(2026 Spike)*
- **Visualization**: Grafana dashboards *(2026 Spike)*
- **Historical Storage**: ClickHouse for long-term metrics *(2026 Spike)*
- **Alerting**: PostHog for launch, PagerDuty integration planned

### Logging Infrastructure

> [!NOTE]
> For launch, use structured JSON logging to standard output. Centralized log aggregation is planned for the [2026 observability spike](/docs/operations/roadmap/observability-roadmap).

- **Centralized Logs**: Elasticsearch for aggregation *(2026 Spike)*
- **Application Logs**: Structured JSON logging ✅
- **Error Tracking**: Sentry integration *(2026 Spike)*
- **Retention**: 90 days for operational logs, 7 years for audit logs

---

## Technical Considerations

### Performance

- **Real-Time Polling**: Queue dashboard updates every 5 seconds
- **Log Search**: Elasticsearch indexes ~1TB logs with <1s query time
- **Dashboard Load**: <500ms with cached infrastructure metrics

### Scalability

- **Queue Depth**: Handles millions of jobs per day
- **Log Volume**: Processes ~100GB logs daily
- **Metric Cardinality**: 10,000+ time-series tracked

### Reliability

- **Monitoring Uptime**: 99.9% availability target
- **Alert Latency**: <1 minute for critical issues
- **Data Retention**: 90 days operational, 1 year compliance

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes - Queue Monitoring](/docs/design/routes/platform-admin#dashboard-system-queues) - Queue UI spec
- [Platform Admin Routes - Infrastructure](/docs/design/routes/platform-admin#dashboard-system-infrastructure) - Infrastructure UI spec
- [Platform Admin Routes - Logs](/docs/design/routes/platform-admin#dashboard-system-logs) - Log viewer UI spec

### API Documentation

- [System Monitoring API](/docs/implementation-technical/api/platform-api/system-monitoring) - Health and queue endpoints
- [Queue API](/docs/implementation-technical/api/queue/jobs) - Job management

### Implementation

- [Queue System Architecture](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation) - Queue design
- [Logging Standards](/docs/implementation-technical/observability/logging) - Log format and best practices

### Operations

- [Incident Response](/docs/operations/incident-management/runbooks) - Troubleshooting procedures
- [Monitoring Setup](/docs/operations/monitoring/prometheus-grafana) - Alerting configuration

---

## Future Enhancements

### Q2 2026

- **Automated Remediation**: Auto-retry failed jobs based on error type
- **Predictive Alerting**: ML-based anomaly detection
- **Custom Dashboards**: Per-team monitoring views

### Monitoring & Compliance Spike

- **Websocket Investigation**: Evaluate websocket architecture for real-time compliance alerts and monitoring updates.
- **Stakeholder Requirements**: Gather detailed needs for automated compliance reporting and real-time dashboards.

### Q3 2026

- **Cost Monitoring**: Infrastructure cost tracking per tenant
- **Performance Profiling**: APM integration for slow requests
- **Capacity Planning**: Automated resource scaling recommendations
