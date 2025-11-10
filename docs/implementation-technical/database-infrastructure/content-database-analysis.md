# Content Database Architecture: Analysis, Gotchas, and Proposals

This document analyzes the current Content DB design (as described in `docs/implementation-technical/database-infrastructure/content-database-schema-guide`) and provides a pragmatic, implementation-ready refinement that aligns with:

- 4-tier architecture:
  - OLTP: operational entities and message metadata.
  - Content DB: heavy content (bodies, attachments, archives).
  - OLAP: aggregates and analytics (no heavy bodies).
  - Queue: pipelines and async processing.
- Separation of concerns:
  - Content DB is NOT a logging, monitoring, or analytics sink.
  - External analytics/logging handles telemetry (per [`external-analytics-logging`](docs/implementation-technical/database-infrastructure/external-analytics-logging:1)).

This is the canonical interpretation to use when reconciling legacy content DB docs.

---

## 1. Current Model (from legacy guide)

Key constructs from `docs/implementation-technical/database-infrastructure/content-database-schema-guide`:

- email_messages
  - Message-level metadata and traces, keyed by storage_key, referencing email_content.
- email_content
  - Email bodies (text/html), headers, compression, retention metadata.
- content_objects
  - Alternative/generalized full-content store (similar to email_content).
- attachments
  - Binary blob storage keyed to content storage_key.
- transactional_emails, notifications, system_notifications
  - System messaging and alerts.
- content_access_log, content_retention_stats, content_search_index
  - Access logging, retention metrics, search support.
- retention_policies, content_encryption_policies, content_security_alerts, content_access_audit
- Aggressive lifecycle, deduplication, compression, and metrics functions.

The snippet you shared:

```mermaid
%% Content Database Schema
content_objects {
    varchar(500) storage_key PK "Matches content_storage_key from Primary DB's 'inbox_message_refs' table"
    uuid tenant_id FK "Denormalized for data isolation and filtering"
    text content_text "Plain text version of the email body"
    text content_html "HTML version of the email body"
    jsonb headers "Full email headers"
    integer raw_size_bytes "Total size of the object including text and HTML"
    timestamp created_at
    timestamp expires_at "For implementing data retention policies"
}

attachments {
    uuid id PK
    varchar(500) parent_storage_key FK "Links to the email content object"
    varchar(255) filename "Original filename of the attachment"
    varchar(100) mime_type "Content type of the file (e.g., 'application/pdf')"
    integer size_bytes "Size of the attachment file"
    bytea content "The raw binary data of the attachment file"
    varchar(50) storage_disposition "inline or attachment"
    timestamp created_at
}

%% Relationships
content_objects ||--o{ attachments : "can have"
```

captures the core idea correctly: content_objects as body store; attachments referencing via parent_storage_key.

---

## 2. Gotchas in the Existing Content DB Design

Summarized issues and risks based on `content_database_schema_guide`:

1) Overlap and confusion: email_content vs content_objects vs email_messages

- Problem:
  - email_content and content_objects both model stored bodies + headers + retention.
  - email_messages in Content DB overlaps with analytics/metadata that belongs either:
    - In OLTP (operational messages), or
    - In OLAP (aggregated analytics), but not as a heavy-content table.
- Risk:
  - Duplicate responsibilities.
  - Confusing cross-tier references (OLTP ↔ Content DB ↔ OLAP).
- Principle:
  - Content DB should be a pure blob/document store keyed by storage_key, with minimal metadata for retrieval and retention.

2) Cross-database foreign keys and tight coupling

- Problem:
  - Legacy doc suggests direct FKs or implied strong coupling to:
    - OLTP campaigns, leads, email_accounts.
    - inbox_message_refs or similar bridging tables.
- Risk:
  - Cross-DB FK is not feasible in practice; leads to migration and deploy headaches.
  - Violates tier independence.
- Principle:
  - Use:
    - Storage keys and denormalized tenant_id/company_id.
    - Application-level validation.
    - No hard cross-DB FKs.

3) Overloading Content DB with logging, analytics, and monitoring

- Problem:
  - Tables like:
    - content_access_log
    - content_retention_stats
    - content_security_alerts
    - content_connection_pools, content_pool_metrics
    - Extensive lifecycle/system_notifications usage
  - Represent:
    - High-volume logs.
    - Monitoring and security analytics.
- Risk:
  - Recreates the “logs in the primary DB” anti-pattern we just removed from OLAP.
  - Bloats Content DB; mixes infra concerns with storage.
- Principle:
  - Detailed logging / monitoring → external analytics/logging stack.
  - Content DB: minimal, targeted audit/retention metadata only where legally required.

4) Functions with heavy in-DB logic and embedded infra semantics

- Problem:
  - Lifecycle management functions:
    - run_daily_content_lifecycle, run_weekly_content_optimization,
      deduplicate_content, optimize_content_compression, monitor_content_lifecycle_health, etc.
  - Encode:
    - Specific compression choices.
    - Dedup algorithms.
    - Rich alerting flows.
- Risk:
  - Tight coupling to implementation details.
  - Hard to maintain/iterate; too prescriptive for a schema guide.
- Principle:
  - Keep:
    - Conceptual guidance and minimal reference functions.
  - Move:
    - Complex monitoring and tuning to application and infra orchestration.

5) Confused separation between Content DB, Notifications, and System Alerts

- Problem:
  - system_notifications and similar tables live in the content doc, but:
    - Are really operational/infra constructs.
    - Overlap with admin_system_events and external logging responsibilities.
- Risk:
  - Multi-place definitions for “alerts.”
- Principle:
  - If you need durable alert summaries:
    - Use admin_system_events (OLAP) or a dedicated ops DB, not Content DB.
  - For internal runtime alerts:
    - Use logging/observability stack.

---

## 3. Proposed Content DB Model (Lean, Tiered, Practical)

Target: Small, coherent schema focused on heavy content storage.

A. Core tables

1) content_objects

- Purpose:
  - Store email/message bodies and related structured content.
- Model (normalized from the snippet):

```sql
CREATE TABLE content_objects (
    storage_key VARCHAR(500) PRIMARY KEY,
    tenant_id UUID NOT NULL,
    content_text TEXT,
    content_html TEXT,
    headers JSONB,
    raw_size_bytes INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE, -- optional retention hint
    -- Optional fields (if truly needed):
    content_hash VARCHAR(64),
    compression_algorithm VARCHAR(20),
    compressed_size_bytes INTEGER,
    last_accessed_at TIMESTAMP WITH TIME ZONE
);

CREATE INDEX idx_content_objects_tenant ON content_objects(tenant_id);
CREATE INDEX idx_content_objects_expires ON content_objects(expires_at) WHERE expires_at IS NOT NULL;
```

Key points:
- Single canonical body store.
- No direct FK to OLTP; tie via storage_key from OLTP tables (e.g., inbox_message_refs/email_messages).
- Optional compression/hash fields allowed, but keep semantics minimal.

2) attachments

- Purpose:
  - Store binary attachments linked to content_objects.
- Model:

```sql
CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_storage_key VARCHAR(500) NOT NULL REFERENCES content_objects(storage_key) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size_bytes INTEGER NOT NULL,
    content BYTEA NOT NULL,
    storage_disposition VARCHAR(50) CHECK (storage_disposition IN ('inline', 'attachment')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_attachments_parent ON attachments(parent_storage_key);
```

Key points:
- No analytics/metrics here.
- Only what’s needed to fetch and render files.

B. Relationship to OLTP

- OLTP holds:
  - Message metadata, campaign linkage, lead linkage, status, etc.
  - A column like content_storage_key or body_storage_key.
- Content DB holds:
  - The heavy blob keyed by that storage_key.
- No cross-DB FK:
  - All linking done by application and jobs.
- If you still have inbox_message_refs or email_messages in Content DB:
  - Treat as transitional; canonical pattern is:
    - OLTP: email_messages metadata.
    - Content DB: content_objects + attachments.

C. What to drop or externalize (relative to legacy guide)

- Remove from Content DB responsibilities:
  - content_connection_pools, content_pool_metrics, deep pool tuning functions.
  - Rich system_notifications used as monitoring bus.
  - Detailed content_access_log (use external analytics/logging or minimal sampled logs).
  - content_security_alerts as a heavy event store.
- Keep only:
  - Lightweight, targeted retention_policies if you want DB-driven retention.
  - Optional:
    - content_access_audit with strict scope and sane volume, only if legally required.
  - Otherwise:
    - Push security/audit streaming to external stack as per external-analytics-logging.

---

## 4. Concrete Gotchas and How to Handle Them

1) “Matches content_storage_key from Primary DB”

- Gotcha:
  - Implies FK from content_objects.storage_key to an OLTP table.
- Guidance:
  - Keep this as a documented contract, not a DB constraint.
  - Implement:
    - One-way reference: OLTP row has content_storage_key; Content DB trusts it.
    - Background validation job (in app/queue) to detect orphaned content.

2) “Email message analytics” inside Content DB

- Gotcha:
  - email_messages described as analytics/traces in Content DB.
- Guidance:
  - Move message analytics concerns:
    - To OLTP for operational message state.
    - To OLAP for aggregates (campaign_analytics, mailbox_analytics, etc.).
  - Content DB:
    - Only bodies and attachments.

3) Lifecycle / compression / dedup in SQL

- Gotcha:
  - Hard-coded algorithms and thresholds in DB functions.
- Guidance:
  - Treat those blocks as examples, not required schema.
  - Implement lifecycle in:
    - A worker service with:
      - Configurable policies.
      - Metrics shipped to observability, not content DB.

4) Access logs and search index in Content DB

- Gotcha:
  - content_access_log and content_search_index can grow very large.
- Guidance:
  - Prefer:
    - Search: external search engine (OpenSearch/Meilisearch/etc.) or OLAP partial indexing.
    - Access logs: security/event pipeline or external logging.
  - If you keep content_search_index:
    - Keep it lean, rolling, and clearly non-canonical; treat as projection.

---

## 5. Recommended Final Shape (for main docs)

When you codify this into the canonical docs:

- Content DB:
  - Tables:
    - content_objects
    - attachments
    - (optional) transactional_emails, notifications (if you explicitly choose to host them here; or move to OLTP)
    - (optional, lean) retention_policies
- Responsibilities:
  - Heavy content storage.
  - Retention and lifecycle metadata.
  - Multi-tenant isolation via tenant_id + RLS (if DB supports).
- Non-responsibilities:
  - No general-purpose logging store.
  - No infra metrics (pools, CPU, etc.).
  - No rich security/event analytics (those are external or OLAP summaries).
  - No campaign/lead analytics (those are OLAP).

This analysis should be used to:

- Clean up any Mermaid diagrams or schema guides that still show:
  - content_objects + attachments + cross-DB constraints as tightly coupled.
  - Logging/metrics tables inside the Content DB.
- Align content DB docs with the same principles applied to OLAP:
  - Keep it lean.
  - Model durable state, not noisy telemetry.