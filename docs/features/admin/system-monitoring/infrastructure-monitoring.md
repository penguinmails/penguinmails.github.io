---
title: "Infrastructure Monitoring"
description: "Real-time service health, IP reputation tracking, and infrastructure alerting"
last_modified_date: "2025-12-04"
level: "3"
persona: "Operations Engineers, DevOps"
status: "ACTIVE"
category: "Admin"
---

# Infrastructure Monitoring

**Proactive monitoring of service health, email deliverability, and infrastructure alerts.**

---

## Overview

Infrastructure Monitoring provides operations teams with real-time visibility into platform health, service availability, and email reputation. Monitor critical services, track IP blacklists, and respond to infrastructure alerts before they impact users.

### Key Capabilities

- **Service Health Dashboard**: Real-time status for all critical services
- **IP Reputation Tracking**: Monitor email deliverability and blacklist status
- **Infrastructure Alerts**: Real-time alert feed with severity levels
- **Performance Metrics**: Response times and uptime statistics

---

## Feature Components

### Service Health Grid

See [Analytics UI Patterns](/docs/design/analytics-ui-patterns) for visual design.

**Status Cards** (Traffic light system):

- **API Server**: Healthy / Degraded / Down
  - Response time (avg, p95, p99)
  - Request rate
  - Error rate
- **SMTP Service**: Status and queue backlog
- **OLTP Database**: Connection pool, query latency
- **OLAP Database**: Query performance, storage usage
- **Redis Cache**: Hit rate, memory usage
- **Elasticsearch**: Cluster health, indexing lag

**Indicators**:

- 🟢 Green: Operational (all metrics normal)
- 🟡 Yellow: Degraded (performance impact)
- 🔴 Red: Down (service unavailable)

### IP Reputation Monitor

**Purpose**: Track email sending reputation to prevent deliverability issues

**Table Columns**:

- IP Address
- Provider (AWS, SendGrid, etc.)
- Reputation Score (0-100)
- Blacklists (comma-separated list)
- Daily Volume (emails sent)
- Status (Good / Warning / Critical)

**Alerts**:

- 🔴 Critical: IP listed on major blacklist (Spamhaus, Barracuda)
- 🟡 Warning: Reputation score below 70
- Detection lag: ~2 hours for blacklist updates

**Actions**:

- View blacklist details and delisting instructions
- Export IP reputation history
- Rotate to backup IP pool

### Infrastructure Alerts Feed

**Real-Time Stream** (Last 24 hours):

- **Columns**: Timestamp, Severity, Service, Message
- **Severities**:
  - 🔴 ERROR: Requires immediate action
  - 🟡 WARNING: Performance degradation
  - 🔵 INFO: Informational events

**Example Alerts**:

- "ERROR | SMTP | Queue size exceeded 10k threshold"
- "WARNING | API | Response time p95 > 1s for 5 minutes"
- "INFO | Database | Connection pool 80% utilized"

**Alert Actions**:

- Acknowledge alert
- Link to runbook for resolution
- Create incident ticket

---

## User Stories

### DevOps Engineer (Service Health)

> *"I need to verify all services are healthy before deploying a major update to production."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/system/infrastructure`
> 2. Check all service health cards (all green)
> 3. Verify no recent critical alerts
> 4. Proceed with deployment
> 5. Monitor dashboard during deployment
> 6. Confirm services remain healthy post-deployment

### Email Deliverability Specialist

> *"Our email open rates dropped 20% yesterday. I need to check if an IP got blacklisted."*
>
> **Workflow**:
>
> 1. Navigate to infrastructure dashboard
> 2. Check IP Reputation Monitor
> 3. Identify IP listed on Spamhaus (detected 2 hours ago)
> 4. Click blacklist details for delisting process
> 5. Rotate traffic to clean IPs
> 6. Submit delisting request
> 7. Monitor reputation recovery

---

## Technical Integration

> [!NOTE]
> For launch, **PostHog handles basic alerting**. The monitoring stack below is planned for the [2026 observability spike](/docs/operations/roadmap/observability-roadmap).

### Monitoring Stack (2026 Spike)

- **Prometheus**: Collects metrics from all services (15s interval) *(2026 Spike)*
- **Grafana**: Visualizations and dashboards *(2026 Spike)*
- **ClickHouse**: Historical metric storage (1 year retention) *(2026 Spike)*
- **PagerDuty**: Alert routing and escalation

### IP Reputation Monitoring

- **Data Sources**:
  - Spamhaus API
  - Barracuda blacklist
  - Internal reputation scoring
- **Update Frequency**: Every 2 hours
- **Historical Tracking**: 90 days of reputation scores

### Alerting (2026 Spike)

- **Alert Rules**: Defined in Prometheus *(2026 Spike)*
- **Notification Channels**: PostHog for launch; PagerDuty, Slack planned
- **Escalation**: Auto-escalate if not acknowledged in 10 minutes (planned)

---

## Related Documentation

- [Platform Admin Routes - Infrastructure](/docs/design/routes/platform-admin#dashboard-system-infrastructure)
- [System Monitoring API](/docs/implementation-technical/api/platform-api/system-monitoring)
- [Observability Roadmap](/docs/operations/roadmap/observability-roadmap) - 2026 spike planning
- [Incident Response](/docs/operations/incident-management/runbooks)
