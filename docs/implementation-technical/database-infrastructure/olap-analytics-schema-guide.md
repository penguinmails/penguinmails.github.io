---
title: "OLAP Analytics Schema Guide"
description: "Documentation for OLAP Analytics Schema Guide - Olap Analytics Schema Guide"
last_modified_date: "2025-11-17"
level: 2
persona: "Documentation Users"
---

# OLAP Analytics Schema Guide

## Strategic Alignment

**Strategic Alignment**: The OLAP analytics schema exists exclusively to power durable, business-critical analytics for PenguinMails. It is not used for live product state, notifications, or infrastructure logging.

**Scope**:

- Aggregated metrics for campaigns, mailboxes, leads, warmups.
- Billing and usage analytics.
- Compliance-relevant audit summaries.
- Long-term trend and BI queries.

**Out of Scope**:

- User-facing notifications.
- Live system events/incidents.
- Raw logs, infra metrics, rate limits, or queue/job internals.
- Heavy content (email bodies, attachments).

For those concerns:

- Notifications & system events: see [`notifications-database-schema-guide`](docs/implementation-technical/database-infrastructure)
- External logging / observability: see [`external-analytics-logging`](docs/implementation-technical/database-infrastructure)

---

## 1. Core Analytics Tables

The OLAP warehouse contains the following canonical tables:

1. `billing_analytics`
2. `campaign_analytics`
3. `mailbox_analytics`
4. `lead_analytics`
5. `warmup_analytics`
6. `sequence_step_analytics`
7. `admin_audit_log` (compliance-focused only)

All other entities (notifications, system events, infra telemetry, etc.) are deliberately excluded or handled in other tiers.

### 1.1 Billing Analytics

```sql
CREATE TABLE billing_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tenant_id TEXT NOT NULL,
    subscription_id TEXT,
    emails_sent INTEGER DEFAULT 0,
    mailboxes_used INTEGER DEFAULT 0,
    domains_used INTEGER DEFAULT 0,
    campaigns_used INTEGER DEFAULT 0,
    leads_used INTEGER DEFAULT 0,
    warmups_active INTEGER DEFAULT 0,
    period_start TIMESTAMPTZ NOT NULL,
    period_end TIMESTAMPTZ NOT NULL,
    updated TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_billing_analytics_tenant_period
    ON billing_analytics(tenant_id, period_start, period_end);
```markdown

Purpose:
- Aggregated usage per tenant per period.
- Drives billing, quotas, and revenue analytics.

### 1.2 Campaign Analytics

```sql
CREATE TABLE campaign_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    campaign_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    status TEXT,
    completed_leads INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMPTZ DEFAULT NOW()
);
```markdown

Purpose:
- Aggregated per-campaign performance for reporting and optimization.

### 1.3 Mailbox Analytics

```sql
CREATE TABLE mailbox_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mailbox_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    warmup_status TEXT,
    health_score INTEGER DEFAULT 0,
    current_volume INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    campaign_status TEXT,
    updated TIMESTAMPTZ DEFAULT NOW()
);
```markdown

Purpose:
- Mailbox-level deliverability, health, and warmup analytics.

### 1.4 Lead Analytics

```sql
CREATE TABLE lead_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lead_id TEXT NOT NULL,
    campaign_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    status TEXT,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMPTZ DEFAULT NOW()
);
```markdown

Purpose:
- Per-lead engagement summaries to support scoring and segmentation.

### 1.5 Warmup Analytics

```sql
CREATE TABLE warmup_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mailbox_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    health_score INTEGER DEFAULT 0,
    progress_percentage INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMPTZ DEFAULT NOW()
);
```markdown

Purpose:
- Warmup performance and reputation metrics.

### 1.6 Sequence Step Analytics

```sql
CREATE TABLE sequence_step_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    step_id TEXT NOT NULL,
    campaign_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMPTZ DEFAULT NOW()
);
```markdown

Purpose:
- Step-level performance to support optimization and A/B testing.

---

## 2. Administrative Audit (Compliance-Focused)

### 2.1 admin_audit_log

```sql
CREATE TABLE admin_audit_log (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    creation_time TIMESTAMPTZ DEFAULT NOW(),
    admin_user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id TEXT NOT NULL,
    tenant_id TEXT NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address TEXT,
    user_agent TEXT,
    notes TEXT,
    metadata JSONB,
    data_classification VARCHAR(20),
    retention_category VARCHAR(20)
);
```markdown

Purpose:
- OLAP-resident, compliance-scope audit log for high-risk actions:
  - Permission/role changes.
  - Billing/subscription changes.
  - Tenant-wide configuration changes.
  - Sensitive export approvals.
- Not a full technical log stream.

Key constraints:
- Do NOT store:
  - Raw performance metrics.
  - Low-risk UI events.
  - Full request/response payloads.
- Those go to external logging (see external-analytics-logging).

---

## 3. Removed / Out-of-Scope for OLAP

The following are intentionally NOT present in OLAP (and must not be reintroduced):

- admin_system_events:
  - Live/operational system events are owned by the Notifications DB:
    - See [`notifications-database-schema-guide`](docs/implementation-technical/database-infrastructure)
  - OLAP may later define aggregates, but no admin_system_events base table exists here.

- notifications:
  - Owned by Notifications DB, not OLAP.

- analytics_connection_pools / analytics_pool_metrics /
  analytics_rate_limits / analytics_access_audit / analytics_export_controls:
  - Infra, config, or security telemetry concerns; moved to:
    - External logging/monitoring.
    - Appropriate operational stores.

- Transactional email histories:
  - No generic transactional_emails fact table.
  - Operational behavior is via jobs + external logging; analytics only if/when explicitly required.

This keeps the OLAP schema lean, focused, and maintainable.

---

## 4. Relationships (High-Level)

See ER diagram:
- [`olap-mermaid-er`](docs/implementation-technical/database-infrastructure)

Key relationships:

- billing_analytics:
  - Hub for per-tenant period metrics.
  - Linked to:
    - campaign_analytics
    - mailbox_analytics
    - lead_analytics
    - warmup_analytics
    - sequence_step_analytics

- campaign_analytics ↔ sequence_step_analytics:
  - Per-campaign breakdown.

- mailbox_analytics ↔ warmup_analytics:
  - Per-mailbox warmup tracking.

Logical notes:
- IDs like tenant_id, campaign_id, company_id, mailbox_id, lead_id are logical references to OLTP, denormalized for warehouse flexibility.
- No foreign keys to operational schemas.

---

## 5. Security, RLS, and Access

Apply RLS and access controls to all OLAP tables:

- Enforce tenant isolation where OLAP is exposed to tenants.
- Restrict admin_audit_log to authorized roles and necessary scopes.

Detailed security and logging strategy:
- [`external-analytics-logging`](docs/implementation-technical/database-infrastructure)

---

## 6. Roadmap (Admin)

We explicitly defer any OLAP-specific modeling of admin/system events.

If future needs arise (not implemented now), consider:

- Aggregated views, such as:
  - incidents_by_tenant_by_month
  - mean_time_to_resolve_by_severity
  - quota_breach_counts_over_time

These would be:
- Derived from the Notifications DB (`admin_system_events`) and/or external logs.
- Implemented as clearly named aggregate tables/views.
- Still respecting OLAP’s “aggregated and lean” constraints.

Currently:
- No such OLAP tables are defined.
- All admin/system event analytics are future/roadmap only.

---

## 7. Summary

OLAP is now clearly constrained to:

- Business-critical aggregates.
- Compliance-focused summaries (admin_audit_log).
- No live notifications or system events.
- No infra/config/telemetry storage.

Notifications/system events, logs, and jobs:
- Live in their respective tiers and feed OLAP only via intentional, aggregate pipelines when justified.

Use this guide as the authoritative reference for what belongs in the OLAP warehouse.
