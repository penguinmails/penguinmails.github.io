---
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---
# OLAP Analytics ER Diagram (Mermaid)

This diagram reflects the OLAP/analytics schema defined in
[`schema-guide.md`](schema-guide.md),
modeled as the analytics tier separate from OLTP, Content DB, Notifications DB, and external logging.

```mermaid
---
config:
  layout: dagre
---
erDiagram
  direction TB

  %% ==========================
  %% Core Analytics Fact Tables
  %% ==========================

  billing_analytics {
    bigint id PK
    text tenant_id
    text subscription_id
    int emails_sent
    int mailboxes_used
    int domains_used
    int campaigns_used
    int leads_used
    int warmups_active
    timestamptz period_start
    timestamptz period_end
    timestamptz updated
  }

  campaign_analytics {
    bigint id PK
    text campaign_id
    text company_id
    int sent
    int delivered
    int opened_tracked
    int clicked_tracked
    int replied
    int bounced
    int unsubscribed
    int spam_complaints
    text status
    int completed_leads
    bigint billing_id FK
    timestamptz updated
  }

  mailbox_analytics {
    bigint id PK
    text mailbox_id
    text company_id
    int sent
    int delivered
    int opened_tracked
    int clicked_tracked
    int replied
    int bounced
    int unsubscribed
    int spam_complaints
    text warmup_status
    int health_score
    int current_volume
    bigint billing_id FK
    text campaign_status
    timestamptz updated
  }

  lead_analytics {
    bigint id PK
    text lead_id
    text campaign_id
    int sent
    int delivered
    int opened_tracked
    int clicked_tracked
    int replied
    int bounced
    int unsubscribed
    int spam_complaints
    text status
    bigint billing_id FK
    timestamptz updated
  }

  warmup_analytics {
    bigint id PK
    text mailbox_id
    text company_id
    int sent
    int delivered
    int opened_tracked
    int clicked_tracked
    int replied
    int bounced
    int unsubscribed
    int spam_complaints
    int health_score
    int progress_percentage
    bigint billing_id FK
    timestamptz updated
  }

  sequence_step_analytics {
    bigint id PK
    text step_id
    text campaign_id
    text company_id
    int sent
    int delivered
    int opened_tracked
    int clicked_tracked
    int replied
    int bounced
    int unsubscribed
    int spam_complaints
    bigint billing_id FK
    timestamptz updated
  }

  %% ==========================
  %% Administrative / Audit OLAP
  %% ==========================

  admin_audit_log {
    bigint id PK
    timestamptz creation_time
    text admin_user_id
    text action
    text resource_type
    text resource_id
    text tenant_id
    jsonb old_values
    jsonb new_values
    text ip_address
    text user_agent
    text notes
    jsonb metadata
    varchar(20) data_classification
    varchar(20) retention_category
  }

  %% ==========================
  %% Relationships
  %% ==========================

  %% Billing hub to analytics facts
  billing_analytics ||--o{ campaign_analytics : "billing_id (optional)"
  billing_analytics ||--o{ mailbox_analytics : "billing_id (optional)"
  billing_analytics ||--o{ lead_analytics : "billing_id (optional)"
  billing_analytics ||--o{ warmup_analytics : "billing_id (optional)"
  billing_analytics ||--o{ sequence_step_analytics : "billing_id (optional)"

  %% Derived analytics relationships
  campaign_analytics ||--o{ sequence_step_analytics : "per campaign steps"
  mailbox_analytics ||--o{ warmup_analytics : "warmup by mailbox"

  %% ==========================
  %% Notes
  %% ==========================

  %% - IDs like tenant_id, campaign_id, company_id, mailbox_id, lead_id are logical references
  %%   to OLTP entities, denormalized for warehouse flexibility (no cross-DB FKs).
  %% - Only core analytics fact tables and the compliance-scope admin_audit_log are modeled here.
  %% - Notifications and live admin/system events are stored in the dedicated Notifications DB
  %%   (see notifications-database-schema-guide), not in OLAP.
  %% - Raw logs, infra metrics, rate limits, and detailed telemetry belong to the external
  %%   logging).
