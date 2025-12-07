---
title: "Observability Stack Roadmap"
description: "Planned evaluation and implementation of monitoring, logging, and error tracking tools"
last_modified_date: "2025-12-07"
level: "2"
persona: "Operations, DevOps"
status: "PLANNED"
---

# Observability Stack Roadmap

## Overview

This roadmap outlines the **2026 spike** to evaluate and implement observability tools beyond PostHog. For MVP/launch, **PostHog is the primary external analytics tool**.

> [!IMPORTANT]
> All tools listed here are **planned for evaluation**, not committed. The spike will determine which tools are actually implemented based on cost, complexity, and team capacity.

---

## Current State (Launch)

| Tool | Purpose | Status |
|------|---------|--------|
| **PostHog** | User analytics, engagement, login events, basic alerts | ✅ MVP |
| **OLAP/OLTP** | Business metrics (campaigns, billing, usage) | ✅ MVP |

---

## 2026 Spike: Observability Stack Evaluation

### Goal

Evaluate infrastructure monitoring, centralized logging, and error tracking solutions to determine if/when to implement beyond PostHog.

### Candidate Tools

#### Metrics & Monitoring (Prometheus/Grafana)

**Potential Use Cases:**

- Server health metrics (CPU, memory, disk, network)
- Database performance (connection pools, query latency)
- Queue depth and job processing rates
- Custom application metrics (email send rates, API latency)
- Alerting on thresholds (high CPU, low disk, queue backlog)

**Questions to Answer:**

- Can PostHog handle basic infrastructure alerts for launch?
- What monitoring features does Hostwinds/cloud provider offer?
- Self-hosted vs managed Grafana Cloud cost comparison?
- What's the operational overhead of running Prometheus?

---

#### Log Aggregation (Elasticsearch/ELK)

**Potential Use Cases:**

- Centralized log search across all services
- Fast full-text search for debugging
- Log retention and compliance (7+ years for audit logs)
- Error pattern detection and alerting
- Request tracing across microservices

**Questions to Answer:**

- Can we start with simpler log aggregation (CloudWatch, Loki)?
- What's the storage cost for 90 days operational logs?
- Self-hosted vs Elastic Cloud cost comparison?
- Do we need full-text search, or is structured logging sufficient?

---

#### Error Tracking (Sentry)

**Potential Use Cases:**

- Real-time error alerts with stack traces
- Grouping similar errors to reduce noise
- Release tracking (errors per deployment)
- User impact analysis (which users hit which errors)
- Integration with issue tracking (Jira/GitHub)

**Questions to Answer:**

- Is PostHog's error tracking sufficient for launch?
- Sentry.io vs self-hosted cost comparison?
- What's the integration effort for existing codebase?

---

#### Historical Metrics (ClickHouse)

**Potential Use Cases:**

- Long-term metrics storage (1+ year retention)
- Fast analytical queries on time-series data
- Cost-effective storage for high-cardinality metrics
- Custom dashboards for executive reporting

**Questions to Answer:**

- Can PostgreSQL handle our analytics queries at scale?
- When does ClickHouse become cost-effective vs managed DB?
- What's the migration path from OLAP PostgreSQL?

---

## Spike Deliverables

1. **Cost Analysis**: TCO for each tool (self-hosted vs managed)
2. **Proof of Concept**: Basic setup for top 2 candidates
3. **Integration Estimate**: Effort to integrate with existing codebase
4. **Recommendation**: Prioritized implementation plan for 2026-2027

---

## Timeline

| Phase | Target | Focus |
|-------|--------|-------|
| **MVP Launch** | Q1 2026 | PostHog only |
| **Spike Planning** | Q2 2026 | Define evaluation criteria |
| **Spike Execution** | Q3 2026 | PoCs and cost analysis |
| **Decision** | Q4 2026 | Select tools for 2027 |
| **Implementation** | 2027 | Phased rollout |

---

## Related Documentation

- [Metrics Glossary](/docs/features/admin/system-monitoring/metrics-glossary) - Available metrics reference
- [System Monitoring](/docs/features/admin/system-monitoring/overview) - Monitoring feature overview
- [Infrastructure Monitoring](/docs/features/admin/system-monitoring/infrastructure-monitoring) - Planned capabilities

---

**Keywords**: observability, monitoring, prometheus, grafana, elasticsearch, sentry, clickhouse, logging
