# Notifications & System Events Database Schema Guide

This guide defines the canonical schema and responsibilities for the dedicated Notifications & System Events database.

It consolidates and replaces:

- [`notifications-architecture`](docs/implementation-technical/database-infrastructure)
- [`transactional-emails-and-notifications`](docs/implementation-technical/database-infrastructure)

Refer to:

- [`database-schema-guide`](docs/implementation-technical/database-infrastructure) for the 5-tier overview.
- [`external-analytics-logging`](docs/implementation-technical/database-infrastructure) for logging/observability responsibilities.

---

## 1. Role in the 5-Tier Architecture

This Notifications DB is an operational tier, distinct from:

- OLTP:
  - Core product entities and business workflows.
- Content DB:
  - Heavy bodies and attachments.
- OLAP:
  - Aggregated analytics and compliance summaries.
- Queue / Jobs:
  - Asynchronous execution mechanics.
- External Logging:
  - High-volume telemetry and traces.

The Notifications DB provides:

- Durable, query-optimized state for:
  - User/admin in-app notifications.
  - Curated system).
- Fast reads and simple status updates on login/admin dashboards.
- Bounded retention (short).
- A clean separation from OLAP and raw logs.

---

## 2. Core Design Principles

1) UX-first, OLAP-independent:

- Notifications and admin events must be available even if OLAP is slow/down.
- Reads and updates must be low-latency.

1) Operational, not a log sink:

- Store only what is needed for:
  - Displaying notifications.
  - Tracking relevant system events for admins.
- Raw telemetry stays in external logging.

1) Redis is not the source of truth:

- Use Redis only for:
  - Rate limiting (e.g., over-sending protection).
  - Caching unread counts / hot items.
- Postgres (or equivalent) in this tier is canonical.

1) Retention by design:

- User notifications: short/mid-term.
- System events: mid-term, with offloading to logging if needed.
- No unbounded growth.

---

## 3. Notifications Schema

Represents user/admin visible notifications (in-app, optionally backing email).

### 3.1 Table: notifications

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    -- Scope
    user_id UUID,                         -- Recipient user (nullable for tenant)
    tenant_id UUID NOT NULL,

    -- Semantics
    type VARCHAR(100) NOT NULL,           -- e.g. CAMPAIGN_COMPLETED, QUOTA_WARNING
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    channel VARCHAR(20) CHECK (channel IN ('in_app', 'email', 'push')),

    -- State
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    read_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_notifications_user_tenant_created
    ON notifications(user_id, tenant_id, created_at DESC);

CREATE INDEX idx_notifications_unread
    ON notifications(user_id, tenant_id, is_read, created_at DESC)
    WHERE is_read = false;
```markdown

Semantics:

- Source of truth for:
  - “What notifications should this user/admin see?”
- Operations:
  - On login:
    - Fetch recent notifications (filter by unread, tenant_id, user_id).
  - On read:
    - Set is_read = true, read_at = now().
  - On delete/hide:
    - Set deleted_at; client filters those out.

Retention:

- Recommended:
  - Hard-delete or archive:
    - After expires_at, or
    - After N days (configurable).
- Ensures:
  - The table stays size-bounded.
  - OLAP is not required for history.

Integration:

- Creation:
  - Triggered by domain events (e.g., campaign completed, quota nearing).
- Delivery:
  - A notification can enqueue jobs:
    - SEND_NOTIFICATION (email).
- Logging:
  - Notification send/interaction events:
    - Go to external logging) if needed.

---

## 4. Admin/System Events Schema

Curated system events that admins and operators should see.

These are NOT raw logs; they are high-signal, mid-term records.

### 4.1 Table: admin_system_events

```sql
CREATE TABLE admin_system_events (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    event_type TEXT NOT NULL,         -- e.g. incident_opened, quota_reached, job_failure
    severity TEXT NOT NULL,           -- low, medium, high, critical
    description TEXT NOT NULL,        -- human-readable summary
    details JSONB,                    -- structured context (bounded)

    tenant_id UUID,                   -- optional: affected tenant
    user_id UUID,                     -- optional: related actor

    is_resolved BOOLEAN DEFAULT FALSE,
    resolved_at TIMESTAMPTZ,
    resolved_by UUID
);

CREATE INDEX idx_admin_system_events_created
    ON admin_system_events(created_at DESC);

CREATE INDEX idx_admin_system_events_tenant
    ON admin_system_events(tenant_id, created_at DESC);

CREATE INDEX idx_admin_system_events_severity
    ON admin_system_events(severity, created_at DESC);
```markdown

Semantics:

- Use for:
  - Major incidents (e.g., sending paused, quota exceeded).
  - System changes admins should see (e.g., API key rotations, integration failures).
- NOT for:
  - Every log line or minor warning.
  - Raw infra metrics or debug noise.

Lifecycle:

- Created by:
  - Application services when a high-signal condition occurs.
- Updated:
  - Mark is_resolved, resolved_at, resolved_by when handled.
- Retention:
  - Keep for 90–365 days (configurable) to support:
    - Incident reviews.
    - Reliability reporting.
  - Older events:
    - Rely on external logging as historical source.

Integration:

- External logging:
  - All system events should originate from or mirror into:
    - Central logging/metrics.
  - Only a curated subset becomes admin_system_events rows.
- OLAP:
  - If needed, may ingest:
    - Aggregated views of admin_system_events.
  - OLAP remains a consumer, not the primary store.

---

## 5. Interaction with Jobs / Queue

Notifications DB works alongside the Queue tier.

Patterns:

- For notifications:
  - Create notifications row.
  - Enqueue SEND_NOTIFICATION job if external delivery is required.
  - Jobs:
    - Attempt email/push.
    - Update notification delivery-related metadata if we add such fields later.

- For system events:
  - Jobs or services detect critical issues and:
    - Emit logs to external logging.
    - Insert admin_system_events row for curated visibility.

Key principles:

- Jobs store:
  - Operational mechanics and retry state.
- Notifications DB:
  - UX-facing and admin-facing durable state.
- Logging:
  - Full-fidelity traces and debug info.
- OLAP:
  - Optional aggregates derived from notifications/admin_system_events.

---

## 6. Redis & Rate Limiting

Redis is used for:

- Over-sending ):
  - Keys like:
    - `auth:password-reset:{email}:tries`
    - `auth:verification-email:{email}:tries`
  - Enforced in app logic.

NOT used for:

- Canonical notifications.
- Canonical system events.

This keeps:

- Protection logic fast and cheap.
- Durable state in Postgres (Notifications DB).

---

## 7. What is NOT in this DB

To avoid scope creep:

- No heavy content:
  - No email bodies or large payloads.
  - Use Content DB or external providers (e.g. Loop) for that.

- No OLAP-style aggregates:
  - Those belong to OLAP warehouse.

- No raw logs or infra metrics:
  - Those belong in external logging/observability platforms.

- No auth token storage for NileDB/Auth flows:
  - Tokens are validated by the auth provider; we do not duplicate them here.

---

## 8. Mermaid ER Diagram

See:
- [`notifications-mermaid-er`](docs/implementation-technical/database-infrastructure)
for the visual ER representation of this schema.

---
