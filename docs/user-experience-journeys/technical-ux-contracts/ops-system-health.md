# Operations System Health Journey (BF-008, OE-001, OE-002)

Document Level: Implementation-Technical (UX Contract)  
Primary Personas: COO, CTO, SRE / DevOps Lead, NOC / Operations Analyst  
Related Stories: BF-005, BF-008, BF-010, OE-001, OE-002, OE-003  

## 1. Overview

This journey defines how operational leaders and engineers:

- Monitor core platform health for executive-facing capabilities.
- Detect and understand incidents affecting executive dashboards, alerts, and data quality.
- Use clear, honest signals derived from documented health endpoints and monitoring jobs.

This is a UX contract for any “System Health / Operations” surface.

## 2. Persona & Preconditions

- Personas:
  - COO overseeing operational excellence.
  - CTO responsible for technical reliability.
  - SRE / DevOps leads and NOC analysts.
- Preconditions:
  - Health endpoints implemented per BF-008/OE-002:
    - `/health/live`, `/health/ready`, `/health/deps` for key services.
  - Queue-backed monitoring jobs emitting health events per BF-008/OE-001.
  - Queue & Events API and related alerting surfaces available (BF-005).
  - Access controlled:
    - Ops personas only; not exposed as customer marketing or hard SLA guarantees.

## 3. Step-by-step Flow

1. Ops persona navigates to “System Health” / “Operations Dashboard”.
2. System verifies:
   - Authenticated session.
   - Ops/engineering role with appropriate scopes.
3. System Health dashboard displays at a glance:
   - Status of core services:
     - Executive API, Queue & Events API, Tenant SMTP API, Central SMTP Ops API.
   - High-level indicators:
     - Uptime/SLA adherence for exec-facing surfaces.
     - Queue health (depth, latency, DLQ presence).
     - Provider status summaries where available (e.g. NileDB/Hostwinds indicators).
4. User can:
   - Drill into a specific service:
     - See recent health check results.
     - View key performance metrics vs target thresholds.
   - Drill into a specific dimension:
     - Alert history relevant to exec dashboards.
     - Capacity/throughput trends (for planning).
5. When an issue is detected:
   - Dashboard links to:
     - Related alerts (Executive Alerts & Notifications journey).
     - Runbooks and remediation steps (where documented externally).
   - Show clear indication if exec-facing KPIs may be degraded.

## 4. Expected UX & Data Behavior

- Status representation:
  - Use simple, interpretable states (Healthy / Degraded / Unavailable) derived from:
    - Health endpoints and monitoring jobs.
  - Include:
    - Last check timestamp,
    - Scope of impact (e.g. “exec dashboards latency”, “alerts processing”).
- Context:
  - For degraded states:
    - Provide concise explanation (e.g. “High queue latency for notifications; alerts delivery may be delayed”).
    - Avoid exposing sensitive internals (keys, IPs, etc.).
- Relationship to Executive Experience:
  - Explicitly call out:
    - “This may affect executive dashboards/alerts” when relevant.
  - Ensure:
    - Messaging is honest about impact and not over/understated.

## 5. Constraints & Guardrails

- Must:
  - Be internal-facing:
    - Not used as public SLA or marketing artifact.
  - Align with:
    - BF-008 queue-based monitoring,
    - OE-001/OE-002 performance targets,
    - BF-005 alert architecture.
- Must not:
  - Fabricate fine-grained provider guarantees not supported by APIs.
  - Show per-tenant sensitive operational detail to unauthorized users.
  - Overclaim “real-time” visibility beyond the polling/queue cadence.

## 6. Story & Documentation Mapping

- Backlog:
  - BF-008: Infrastructure Performance Monitoring.
  - OE-001: Operational Performance Dashboard.
  - OE-002: System Performance Optimization.
  - OE-003: QA and testing automation alignment for reliability.
  - BF-005: Alert and Notification System (upstream of incident alerts).
- Docs:
  - [`queue-events-api.md`](docs/implementation-technical/api/queue-events-api.md:1)
  - [`business-leaders-database-migration-guide.md#performance-optimization`](docs/implementation-technical/database-infrastructure/business-leaders-database-migration-guide.md:1)
  - [`posthog-business-events-specification.md#resource-usage-events`](docs/implementation-technical/analytics-integration/posthog-business-events-specification.md:1)
  - [`infrastructure-overview.md`](docs/business/implementation/infrastructure-overview.md:1)