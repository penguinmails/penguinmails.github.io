---
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---


# Notifications & System Events ER Diagram (Mermaid)

This diagram visualizes the dedicated Notifications & System Events database as defined in:


- [`schema-guide`](schema-guide)

It is an operational tier:


- Not OLAP.


- Not Content DB.


- Not external logging.


- Optimized for fast reads/updates and bounded retention.


```mermaid
---
config:
  layout: dagre
---
erDiagram
  direction TB

  %% ==========================
  %% Notifications
  %% ==========================

  notifications {
    uuid id PK
    uuid user_id
    uuid tenant_id
    varchar(100) type
    text title
    text message
    varchar(20) channel
    boolean is_read
    timestamptz created_at
    timestamptz read_at
    timestamptz expires_at
    timestamptz deleted_at
  }

  %% ==========================
  %% Admin / System Events
  %% ==========================

  admin_system_events {
    bigint id PK
    timestamptz created_at
    text event_type        "e.g. incident_opened, quota_reached, job_failure"
    text severity          "low, medium, high, critical"
    text description       "human-readable summary"
    jsonb details          "bounded structured context"
    uuid tenant_id         "optional affected tenant"
    uuid user_id           "optional related actor"
    boolean is_resolved
    timestamptz resolved_at
    uuid resolved_by
  }

  %% ==========================
  %% Relationships (Conceptual)
  %% ==========================

  %% Note: These are logical, not strict FKs across tiers.

  %% - notifications.user_id / tenant_id correspond to OLTP users/tenants.
  %% - admin_system_events.tenant_id / user_id reference affected contexts.
  %% - Jobs) create notifications and events,
  %%   but job tables are modeled in the Queue tier docs, not here.

  %% ==========================
  %% Tier Boundaries
  %% ==========================

  %% - This DB is the source of truth for:
  %%     - In-app notifications shown to users/admins.
  %%     - Curated system/admin events for dashboards.
  %%
  %% - OLAP may ingest aggregates from these tables when needed,
  %%   but does NOT act as the primary store for notifications/events.
  %%
  %% - External logging / observability holds raw, high-volume telemetry.
---
