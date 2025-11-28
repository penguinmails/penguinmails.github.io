---
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---


# External Analytics and Logging Integration

This document defines how high-volume events, observability data, and exploratory analytics are handled outside the OLAP warehouse. It generalizes the approach so the backend can use PostHog or any equivalent product analytics / logging / observability stack.

The goal is to:

- Keep the OLAP warehouse focused on durable, contractual, and compliance-relevant aggregates.

- Route noisy, granular, or purely operational data to specialized external systems.

- Avoid coupling OLAP schema to infra configuration or runtime telemetry.

---

## 1. Separation of Concerns

1. OLAP Warehouse

   - Stores:

     - Aggregated business metrics (per period, per entity).

     - Discrete, important state transitions.

     - Compliance- and contract-relevant records.

   - Characteristics:

     - Low-to-moderate volume.

     - Long-term retention with governance.

     - Directly supports:

       - Billing, tenant usage.

       - Customer-facing analytics dashboards.

       - Regulatory and enterprise audits.

2. External Analytics )

   - Primary sink for:

     - High-volume clickstream events.

     - Feature usage and funnels.

     - Admin UI interactions and navigation behavior.

     - Experimentation, retention, and UX telemetry.

   - Characteristics:

     - Event-centric.

     - Flexible schema.

     - Tunable retention and sampling.

   - Feeds:

     - Aggregated, stable metrics back into OLAP when).

3. Observability / Logging / Security Tooling

   - Includes APM, metrics, logs, SIEM, etc.

   - Primary sink for:

     - Infrastructure metrics (CPU, memory, connection pools).

     - Application performance metrics.

     - Error logs, stack traces, retries, timeouts.

     - Detailed security logs for forensic use.

   - Characteristics:

     - High-volume, operational.

     - Tight integration with alerting and SRE workflows.

   - OLAP:

     - May receive highly aggregated summaries (e.g. daily uptime, incident counts).

     - Does not mirror full logs.

---

## 2. What Must Go to External Analytics / Logging

The following categories must NOT be stored as first-class fact tables in the OLAP schema. They should be captured by PostHog/product-analytics and/or observability/logging systems.

### 2.1 Admin UI and Low-Risk Behavioral Events

- Examples:

  - Page views in the admin panel.

  - Non-sensitive filter changes in dashboards.

  - Clicks on navigation, toggles, and forms that do not change critical configuration.

  - Session keep-alives, idle timers, etc.

- Handling:

  - Track as product analytics events (e.g. `admin_ui_viewed`, `admin_button_clicked`).

  - Use for funnel, adoption, UX improvement.

  - Do not persist these in `admin_audit_log` or other OLAP tables.

### 2.2 Performance Metrics and Query Telemetry

- Examples:

  - `query_duration_ms`, `query_complexity_score`, rows scanned.

  - Per-query timings for dashboards and reports.

  - Detailed connection pool behavior.

- Handling:

  - Send to observability/monitoring stack.

  - Optionally mirror as:

    - Aggregated daily or monthly performance summaries in OLAP, if needed for capacity planning.

  - Do not embed these fields into compliance audit tables in OLAP.

### 2.3 Infrastructure and System Events

- Examples:

  - CPU/memory/disk usage.

  - Connection pool utilization & queue depth.

  - Autoscaling events.

  - Per-node or per-service health checks.

  - Raw alert streams (threshold breaches, transient errors).

- Handling:

  - Send to logging/metrics stack.

  - Use alerting/incident tooling.

  - OLAP may contain:

    - Coarse `system_incident` or `admin_system_events` summaries (one row per notable event), but not every alert.

---

## 3. OLAP-Aware Models vs External-Only Models

This section maps specific existing concepts out of the OLAP schema into external systems.

### 3.1 `admin_audit_log`

- OLAP:

  - Keep only compliance-centric, high-risk actions:

    - Role/permission changes.

    - Tenant-wide configuration changes.

    - Billing and subscription modifications.

    - Data export requests/approvals affecting PII or contractual scope.

    - Security-sensitive operations (impersonation, account lockdown, deletion).

- External:

  - Log:

    - Low-risk admin actions, navigation, and routine reads.

    - Detailed timing and performance metrics.

    - UI-level interactions not required for compliance.

### 3.2 `admin_system_events`

- OLAP:

  - Keep as a summarized table of notable events that:

    - Need to appear in admin or tenant analytics dashboards, or

    - Represent meaningful system-wide milestones (e.g. "maintenance window completed").

- External:

  - All granular alerts, heartbeats, retries, and infra logs.

  - Any signal used only for SRE/debugging.

### 3.3 Analytics Infra Tables (Connection Pools, Metrics, Rate Limits)

- `analytics_connection_pools`

- `analytics_pool_metrics`

- `analytics_rate_limits`

These are infra/operational concerns.

- Handling:

  - Manage configuration via:

    - Application config, environment variables, config service, or infra-as-code.

  - Collect metrics via:

    - Observability stack (Prometheus, OpenTelemetry, etc.).

  - OLAP:

    - At most, define:

      - Aggregated capacity/uptime summaries if needed for business reporting.

    - Do not treat these as standard OLAP analytics tables.

### 3.4 `analytics_access_audit` and Export Controls

- Detailed per-query/per-dashboard access logs:

  - External system (SIEM).

- OLAP:

  - Maintain a narrow, long-retention record of:

    - Sensitive-data access events.

    - Data export actions with PII or contractual significance.

  - Export control policies:

    - Authoritative in OLTP/config.

    - OLAP may mirror effective policy states only if required for enterprise reporting.

---

## 4. Integration Pattern

1. Capture granular events:

   - Product and admin UX events → product analytics (e.g. PostHog).

   - System and infra metrics/logs → observability/logging.

   - Security events → SIEM / security logging.

2. Periodically aggregate:

   - From OLTP and external systems into:

     - `billing_analytics`, `campaign_analytics`, `mailbox_analytics`,
       `lead_analytics`, `warmup_analytics`, `sequence_step_analytics`.

   - For compliance:

     - Consolidate only necessary events into `admin_audit_log` and related OLAP tables.

3. Enforce boundaries:

   - Do not mirror full external event streams into OLAP.

   - OLAP schemas should remain:

     - Stable

     - Bounded in volume

     - Focused on durable business and compliance semantics.

---

## 5. Design Rules (Checklist)

When designing new tracking:

- Ask:

  - Is this required for:

    - Billing/invoicing?

    - SLAs or contractual proof?

    - Regulatory or enterprise audits?

    - Promised customer-facing analytics?

  - If yes → model an aggregate) and/or store narrowly scoped records in `admin_audit_log` where explicitly compliance-relevant.

- Else:

  - If it is behavioral, experimental, UX, or exploratory → send to product analytics (e.g. PostHog).

  - If it is infra/ops/telemetry → send to observability/logging.

  - If it is runtime configuration → keep in config/OLTP, not OLAP.

  - If it is user/admin facing notifications or curated incidents → store in the Notifications & System Events DB.

This document is the canonical reference for avoiding concern-mixing in the OLAP schema. Any OLAP table proposal that resembles logs, traces, or raw events should be validated against this file and typically redirected to the external analytics/logging stack.

---

## 6. Recommended Integration Patterns (from legacy plans, normalized)

This section consolidates the durable patterns from legacy docs
(such as [Analytics Architecture](/docs/technical/architecture/detailed-technical/analytics-architecture)
and [Integration Overview](/docs/technical/integration/overview))
into a concise, canonical form.

### 6.1 PostHog )

Use a thin abstraction to send high-volume behavioral and UX events to PostHog (or equivalent),
keeping OLAP free of clickstream:

```typescript
// analytics/posthogClient.ts
import { PostHog } from 'posthog-node';

export const posthog = new PostHog(process.env.POSTHOG_API_KEY!, {
  host: process.env.POSTHOG_HOST || 'https://app.posthog.com',
});

/)
export async function trackEmailOpened(props: {
  userId: string;
  tenantId: string;
  campaignId?: string;
  mailboxId?: string;
  emailId: string;
}) {
  await posthog.capture({
    distinctId: props.userId,
    event: 'email_opened',
    properties: {
      tenant_id: props.tenantId,
      campaign_id: props.campaignId,
      mailbox_id: props.mailboxId,
      email_id: props.emailId,
    },
  });
}


```

Key rules:

- Do not mirror these raw events into OLAP.

- Only derive aggregates into canonical OLAP tables if they are:

  - Contractual (billing),

  - Compliance-relevant,

  - Explicitly needed for durable analytics.

### 6.2 Queue-Driven ETL into Lean OLAP

Use jobs/queues to periodically aggregate from OLTP + external analytics into the canonical OLAP tables
(without introducing new “log-style” OLAP tables):

```typescript
// analytics/etlPipeline.ts
import { sql } from 'drizzle-orm';
import { db } from '../db';

export async function aggregateDailyCampaignAnalytics(tenantId: string, date: string) {
  // Example: derive aggregates from operational email events
  const metrics = await db.execute(sql`
    SELECT
      campaign_id,
      COUNT(*) AS sent,
      COUNT(*) FILTER (WHERE status = 'delivered') AS delivered,
      COUNT(*) FILTER (WHERE opened IS NOT NULL) AS opened_tracked,
      COUNT(*) FILTER (WHERE clicked IS NOT NULL) AS clicked_tracked,
      COUNT(*) FILTER (WHERE replied IS NOT NULL) AS replied,
      COUNT(*) FILTER (WHERE bounce_type IS NOT NULL) AS bounced,
      COUNT(*) FILTER (WHERE unsubscribed IS NOT NULL) AS unsubscribed,
      COUNT(*) FILTER (WHERE complaint IS NOT NULL) AS spam_complaints
    FROM emails
    WHERE tenant_id = ${tenantId}
      AND DATE(sent_at) = ${date}
    GROUP BY campaign_id
  `);

  for (const row of metrics) {
    await db.execute(sql`
      INSERT INTO campaign_analytics (
        campaign_id,
        company_id,
        sent,
        delivered,
        opened_tracked,
        clicked_tracked,
        replied,
        bounced,
        unsubscribed,
        spam_complaints,
        updated
      )
      VALUES (
        ${row.campaign_id},
        ${row.company_id},
        ${row.sent},
        ${row.delivered},
        ${row.opened_tracked},
        ${row.clicked_tracked},
        ${row.replied},
        ${row.bounced},
        ${row.unsubscribed},
        ${row.spam_complaints},
        NOW()
      )
      ON CONFLICT (campaign_id) DO UPDATE
      SET
        sent = EXCLUDED.sent,
        delivered = EXCLUDED.delivered,
        opened_tracked = EXCLUDED.opened_tracked,
        clicked_tracked = EXCLUDED.clicked_tracked,
        replied = EXCLUDED.replied,
        bounced = EXCLUDED.bounced,
        unsubscribed = EXCLUDED.unsubscribed,
        spam_complaints = EXCLUDED.spam_complaints,
        updated = NOW();
    `);
  }
}


```

Key rules:

- Jobs and ETL workers:

  - Live in the Queue / Jobs tier.

  - Emit traces/metrics to external logging.

- OLAP receives only stable aggregates into:

  - `billing_analytics`,

  - `campaign_analytics`,

  - `mailbox_analytics`,

  - `lead_analytics`,

  - `warmup_analytics`,

  - `sequence_step_analytics`,

  - `admin_audit_log` (compliance-focused).

### 6.3 Event Taxonomy (Summarized)

Standardize event categories (from the legacy integration plan) as external-only:

- Email/campaign events:

  - `email_sent`, `email_delivered`, `email_opened`, `email_clicked`, `email_bounced`, `email_replied`

- Security events:

  - `security_login_*`, `security_suspicious_activity`, `security_data_access`

- Infra/ops:

  - `infra_connection_pool_metrics`, `infra_error_rate`, `infra_latency`

- Business:

  - `business_signup`, `business_upgrade`, `business_churn`

These:

- Are tracked in external analytics/logging platforms.

- Only surface in OLAP as coarse aggregates if they meet the design rules above.

---
