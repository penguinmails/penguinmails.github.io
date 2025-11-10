# Database Schema Guide – 5-Tier Architecture

This guide defines the canonical database tiering for PenguinMails.

We operate a 5-tier model:

1. OLTP Database (Operational Core)
2. Content Database (Heavy Content Storage)
3. OLAP Analytics Warehouse
4. Queue / Jobs Store
5. Notifications & System Events Database

External logging/observability is an out-of-band component that complements these tiers.

For detailed per-tier guides, see:
- [`oltp-schema-guide.md`](docs/implementation-technical/database-infrastructure/oltp-schema-guide.md:1)
- [`content-database-schema-guide.md`](docs/implementation-technical/database-infrastructure/content-database-schema-guide.md:1)
- [`olap-analytics-schema-guide.md`](docs/implementation-technical/database-infrastructure/olap-analytics-schema-guide.md:1)
- [`notifications-database-schema-guide.md`](docs/implementation-technical/database-infrastructure/notifications-database-schema-guide.md:1)
- [`external-analytics-logging.md`](docs/implementation-technical/database-infrastructure/external-analytics-logging.md:1)

---

## 1. OLTP – Operational Core

Purpose:
- Primary system of record for:
  - Tenants, users, organizations.
  - Campaigns, leads, mailboxes, domains.
  - Billing entities and subscriptions.
  - Operational configurations.
  - Optionally, queue/job metadata if co-located.

Characteristics:
- Strong consistency, transactional semantics.
- Multi-tenant isolation via RLS and clear ownership.
- Optimized for OLTP access patterns.

Key principles:
- Store only what is required for correctness and core workflows.
- No heavy content blobs.
- No high-volume logs or analytics aggregates.

Reference:
- [`oltp-schema-guide.md`](docs/implementation-technical/database-infrastructure/oltp-schema-guide.md:1)
- [`oltp-mermaid-er.md`](docs/implementation-technical/database-infrastructure/oltp-mermaid-er.md:1)

---

## 2. Content Database – Heavy Content Storage

Purpose:
- Dedicated tier for:
  - Email/message bodies (text + HTML).
  - Attachments and large binary objects.
  - Archival content.

Characteristics:
- Opaque `storage_key` references from OLTP.
- Optimized for storage efficiency, retention, compression/dedup.

Key principles:
- No core business entities.
- No generalized logging, metrics, or infra configuration tables.
- No analytics aggregates as primary concern.

Core schema:
- `content_objects`
- `attachments`

Reference:
- [`content-database-schema-guide.md`](docs/implementation-technical/database-infrastructure/content-database-schema-guide.md:1)
- [`content-mermaid-er.md`](docs/implementation-technical/database-infrastructure/content-mermaid-er.md:1)
- [`content-database-analysis.md`](docs/implementation-technical/database-infrastructure/content-database-analysis.md:1)

---

## 3. OLAP Analytics Warehouse

Purpose:
- Durable, query-optimized analytics for:
  - Billing/usage.
  - Campaign and sequence performance.
  - Mailbox/warmup health.
  - Lead engagement.
  - Compliance-relevant admin actions.

Characteristics:
- Aggregation-focused.
- Partitioned and indexed for reporting.
- Feeds BI tools and customer-facing analytics.

Key principles:
- Only business-critical aggregates and compliance summaries.
- No live notifications.
- No operational system events.
- No infra metrics, rate-limits, or raw logs.
- No heavy blobs.

Canonical tables:
- `billing_analytics`
- `campaign_analytics`
- `mailbox_analytics`
- `lead_analytics`
- `warmup_analytics`
- `sequence_step_analytics`
- `admin_audit_log` (compliance-focused only)

Reference:
- [`olap-analytics-schema-guide.md`](docs/implementation-technical/database-infrastructure/olap-analytics-schema-guide.md:1)
- [`olap-mermaid-er.md`](docs/implementation-technical/database-infrastructure/olap-mermaid-er.md:1)

---

## 4. Queue / Jobs Store

Purpose:
- Asynchronous workflow orchestration for:
  - Email sending.
  - Analytics aggregation.
  - Imports/exports.
  - Background maintenance.

Characteristics:
- Backed by:
  - Redis + Postgres, or
  - Dedicated Postgres tables.
- Stores:
  - Job metadata (type, payload refs, status, attempts, errors, timestamps).

Key principles:
- Operational; not a long-term analytics or logging store.
- References:
  - Payloads and entities via IDs/storage_keys rather than duplicating data.
- Retention:
  - Aggressively pruned; long-lived traces belong in external logging.

Reference:
- [`queue-system-implementation-guide.md`](docs/implementation-technical/database-infrastructure/queue-system-implementation-guide.md:1)

---

## 5. Notifications & System Events Database

Purpose:
- Operational store for:
  - In-app user/admin notifications.
  - Curated admin/system events (incidents, important alerts).

Characteristics:
- Independent from OLAP.
- Optimized for:
  - Fast reads on login.
  - Status updates (read/resolved/deleted).
  - Bounded retention (short/mid-term).

Core tables:

- `notifications`:
  - User/admin visible notifications (in_app/email/push).
  - Fields:
    - id, user_id, tenant_id, type, title, message, channel
    - is_read, created_at, read_at, expires_at, deleted_at
  - Semantics:
    - Source of truth for notification center UI.
    - Retention via scheduled cleanup.

- `admin_system_events`:
  - Curated high-signal system/admin events.
  - Fields:
    - id, created_at, event_type, severity, description,
      details, tenant_id, user_id, is_resolved, resolved_at, resolved_by
  - Semantics:
    - Backing store for system/incident dashboards.
    - Not raw logs; mid-term history only.

Key principles:
- Do not place these in OLAP.
- Use Redis only as:
  - Cache and rate-limiter (never as primary store).
- External logging:
  - Holds raw/full-fidelity events and metrics.

Reference:
- [`notifications-database-schema-guide.md`](docs/implementation-technical/database-infrastructure/notifications-database-schema-guide.md:1)
- [`notifications-mermaid-er.md`](docs/implementation-technical/database-infrastructure/notifications-mermaid-er.md:1)

---

## 6. External Logging, Analytics, and Observability (Out-of-Band)

Purpose:
- Handle high-volume, detailed telemetry:
  - Clickstream and product analytics.
  - Job/queue traces.
  - Infra logs and metrics.
  - Detailed send/delivery events.
  - Security/forensic logs.

Characteristics:
- Implemented via:
  - PostHog or equivalent.
  - Centralized logging (ELK/Loki/etc).
  - Metrics/tracing (Prometheus/OpenTelemetry/etc).

Key principles:
- Primary sink for:
  - Raw, high-volume event data.
- Feeds:
  - Aggregations into OLAP when explicitly required.
- Not:
  - Used as the primary UX state store.
  - A replacement for OLTP/Notifications DB correctness.

Reference:
- [`external-analytics-logging.md`](docs/implementation-technical/database-infrastructure/external-analytics-logging.md:1)

---

## 7. Summary: 5-Tier Responsibilities

- OLTP:
  - Core entities and real-time workflows.
- Content DB:
  - Heavy bodies and attachments.
- OLAP:
  - Aggregated analytics and compliance summaries.
- Queue / Jobs:
  - Asynchronous execution orchestration.
- Notifications DB:
  - User/admin notifications and curated system events (operational view).
- External Logging/Analytics:
  - Telemetry, raw events, and observability; feeds OLAP when needed.

When designing new features:
- Use this guide plus per-tier docs to decide:
  - Which tier owns the data.
  - How it should be retained.
  - How it flows into analytics/logging without polluting OLTP/OLAP.

---

## 8. Outage & Incident Handling with the 5 Tiers

How the tiers behave under failures, and how we avoid abusing OLAP or logs for live state.

1) OLTP outage

- Impact:
  - Core workflows degraded (auth, campaigns, writes).
- Still available:
  - Notifications DB (if separate) for previously written notifications/events.
  - External logging for error/infra signals.
  - OLAP (read-only) for historical analytics (not live truth).
- Behavior:
  - Jobs depending on OLTP back off and retry.
  - On recovery, queues drain and derived data (OLAP, notifications) reconverge with OLTP.

2) Content DB outage

- Impact:
  - Access to bodies/attachments limited.
- Still available:
  - OLTP metadata.
  - Notifications DB for surfaced incidents.
  - External logging shows related errors.
- Behavior:
  - Core metadata flows continue.
  - Admin_system_events/notifications can highlight content issues without involving OLAP.

3) OLAP outage

- Impact:
  - Analytics dashboards unavailable or stale.
- Not impacted:
  - OLTP operations.
  - Notifications/incident visibility.
  - Queue / Jobs execution.
- Behavior:
  - System continues to operate.
  - This is why we keep OLAP out of live notification/system-event storage.

4) Queue / Jobs outage

- Impact:
  - Delayed async processing (emails, aggregates, some notifications).
- Still available:
  - OLTP, Notifications DB, external logging.
- Behavior:
  - Jobs resume when restored.
  - No OLAP write-dependence for correctness.

5) Notifications DB outage

- Impact:
  - In-app notifications and curated admin events temporarily unavailable.
- Still available:
  - OLTP for core functions.
  - External logging for raw signals.
- Behavior:
  - Critical events are still logged externally.
  - On recovery:
    - If needed, we can repopulate curated events from logs or compensations.
- Isolation:
  - Notifications DB issues do not impact OLTP/OLAP schema correctness.

6) External logging outage

- Impact:
  - Reduced observability.
- Still available:
  - OLTP, Content, OLAP, Notifications, Jobs.
- Behavior:
  - Core correctness unaffected.
  - Admin_system_events/notifications still record curated incidents.

Overall:

- Each tier has a clear blast radius.
- Notifications DB + external logging:
  - Provide runtime visibility and UX without abusing OLAP.
- OLAP:
  - Remains a lean analytical layer, safe to be non-critical in outages.

Use this behavior model when designing failure handling and incident response flows across the stack.