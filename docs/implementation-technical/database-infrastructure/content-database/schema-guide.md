---
title: "Content Database Schema Guide"
description: "Documentation for Content Database Schema Guide - Content Database Schema Guide"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---


# Content Database Schema Guide

This guide defines the canonical Content Database schema for PenguinMails.

The Content DB is a dedicated tier for heavy content storage:

- Email and message bodies (text)

- Attachments and large binaries

- Long-lived archives needed for legal/compliance

It is NOT:

- An analytics warehouse (OLAP covers that)

- An operational store for campaigns

- A general logging/telemetry sink (see external analytics)

For analytics and logging responsibilities, refer to:

- [OLAP Analytics Schema Guide](README) - Analytics and aggregation responsibilities

- [External Analytics Logging](README) - Logging and telemetry responsibilities

---

## 1. Design Principles

**⚠️ IMPORTANT: Stalwart Mail Server Integration**

Before implementing the Content DB schema for email storage, we must investigate **Stalwart Mail Server's PostgreSQL schema** to determine the correct architecture:

- **Stalwart Documentation:** <https://stalw.art/docs/storage/backends/postgresql>

- **Key Questions:**

  - Does Stalwart store emails in PostgreSQL? If so, what's the schema?

  - Can we extend Stalwart's schema with custom fields (is_starred, category, tenant_id)?

  - Should inbox metadata live in OLTP, Content DB, or Stalwart's schema?

  - How do we link Stalwart messages to our campaigns, contacts, and tenants?

**Architecture Options:**

1. **Extend Stalwart Schema:** Add custom fields to Stalwart's PostgreSQL tables

2. **OLTP Metadata:** Store inbox metadata in OLTP, reference Stalwart by message_id

3. **Content DB Metadata:** Store inbox metadata in Content DB, reference Stalwart by storage_key

4. **Hybrid:** Some fields in Stalwart, some in OLTP/Content DB

**Status:** Architecture spike required (Q4 2025, 3-5 days) before finalizing Content DB schema for email storage.

**See:** `docs/features/inbox/unified-inbox/overview.md` for proposed schema (pending Stalwart investigation)

---

1) Clear 4-tier separation

- OLTP:

  - Owns message metadata, campaign relationships, lead references, statuses.

  - Stores a content_storage_key (or similar) pointing into Content DB.

  - **Note:** May also store inbox metadata if Stalwart schema cannot be extended.

- Content DB:

  - Owns only the heavy content itself (bodies, headers, attachments).

  - Keys are opaque storage_key values referenced from OLTP.

  - **Note:** May also store inbox metadata if separate from Stalwart.

- OLAP:

  - Owns aggregated analytics (campaign_analytics, billing_analytics, etc.).

  - Never stores full bodies or large binaries.

- Queue:

  - Owns jobs and pipelines that move/transform data between tiers.

- **Stalwart Mail Server:**

  - Owns email storage and SMTP/IMAP operations.

  - PostgreSQL backend (schema TBD - requires investigation).

1) No cross-database foreign keys

- No physical FK constraints from Content DB to OLTP/OLAP.

- Linking contract:

  - OLTP row contains content_storage_key.

  - Content DB row uses storage_key as primary key.

- Validation:

  - Enforced by application and workers, not by cross-DB constraints.

1) Keep Content DB free of noisy logs and infra metrics

- No generic log tables, connection pool metrics, or system alerts in Content DB.

- High-volume logs, access tracking, and infra monitoring:

  - Go to external logging/product analytics/SIEM per the external analytics logging documentation.

1) Focus on retention, compliance, and efficient storage

- Built-in support for:

  - Tenant isolation via tenant_id.

  - Expiration, archival, and lifecycle hints on content.

- Heavy processing (compression/dedup) is orchestrated by:

  - Workers and services (JS).

  - Minimal, focused SQL helpers where appropriate.

---

## 2. Core Schema

### 2.1 content_objects

Canonical table for storing message bodies and related structured content.

```sql
CREATE TABLE content_objects (
    storage_key VARCHAR(500) PRIMARY KEY,
    tenant_id UUID NOT NULL,

    -- Message/body content
    content_text TEXT,
    content_html TEXT,
    headers JSONB,

    -- Basic size tracking
    raw_size_bytes INTEGER,

    -- Lifecycle and access
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE,                 -- optional retention hint
    last_accessed_at TIMESTAMP WITH TIME ZONE,

    -- Optional optimization metadata
    content_hash VARCHAR(64),                            -- for dedup if implemented
    compression_algorithm VARCHAR(20),                   -- e.g. 'lz4', 'zstd'; optional
    compressed_size_bytes INTEGER
);

CREATE INDEX idx_content_objects_tenant
    ON content_objects(tenant_id);

CREATE INDEX idx_content_objects_expires
    ON content_objects(expires_at)
    WHERE expires_at IS NOT NULL;

CREATE INDEX idx_content_objects_hash
    ON content_objects(content_hash)
    WHERE content_hash IS NOT NULL;


```

Notes:

- storage_key:

  - Opaque identifier; referenced by OLTP records (e.g., emails, messages).

- No direct FKs to OLTP:

  - Application ensures consistency.

### 2.2 attachments

Stores binary attachments associated with a content object.

```sql
CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_storage_key VARCHAR(500) NOT NULL
        REFERENCES content_objects(storage_key) ON DELETE CASCADE,

    filename VARCHAR(255) NOT NULL,
    mime_type VARCHAR(100) NOT NULL,
    size_bytes INTEGER NOT NULL,
    content BYTEA NOT NULL,

    storage_disposition VARCHAR(50)
        CHECK (storage_disposition IN ('inline', 'attachment')),

    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_attachments_parent
    ON attachments(parent_storage_key);


```

Notes:

- attachments are strictly scoped to content_objects.

- No analytics or logging behavior here.

---

## 3. Integration with OLTP and OLAP

### 3.1 How OLTP references Content DB

- OLTP tables (e.g., emails, messages) include:

  - content_storage_key (VARCHAR(500) or similar).

- The application:

  - Writes OLTP row.

  - Writes Content DB row keyed by the same storage_key.

- Validation:

  - Implement background jobs to:

    - Detect orphaned content (no corresponding OLTP reference).

    - Detect broken references (OLTP row referencing missing content).

No cross-database FK:

- This avoids migration coupling and cross-tier failures.

### 3.2 How OLAP interacts with Content DB

- OLAP:

  - Reads from OLTP and/or event streams.

  - Does not join directly to content_objects or store message bodies.

- If needed for compliance:

  - OLAP may store:

    - Reference counts or high-level stats (never full content).

- All heavy content remains in Content DB.

---

## 4. Logging and Analytics for Content Operations

Content DB is not a log sink. The following apply:

- Detailed access logs (who viewed):

  - Prefer:

    - External logging / SIEM / PostHog.

  - If a minimal subset is required for legal/audit:

    - Model a narrow, low-volume audit table either:

      - In OLAP (aggregated summaries), or

      - In a dedicated security DB.

- Performance metrics (read):

  - Send to observability stack.

- Search indexes:

  - Use a dedicated search system (e.g., OpenSearch) or an OLAP projection.

  - Do not treat content_search_index as a primary Content DB responsibility.

For patterns and responsibilities:

- See [External Analytics Logging](README).

---

## 5. Function Logic: What Stays in SQL vs JS/TS

Several lifecycle and optimization flows were previously encoded entirely in SQL functions in legacy docs. Use this split instead:

1) JS/TS application

Implement in services/workers:

- Content ingestion:

  - Generate storage_key.

  - Write to content_objects and attachments.

- Compression and re-compression:

  - Choose algorithms dynamically.

  - Stream content through compression libraries.

- Deduplication:

  - Compute hashes.

  - Decide when/how to deduplicate.

- Virus and security scanning:

  - Integrate with scanning services.

- Scheduling:

  - Trigger lifecycle jobs (archive) based on policies.

- Reason:

  - Easier to test, deploy, and iterate.

  - Keeps DB schema guide stable and provider-agnostic.

1) SQL

Implement in SQL:

- Small, deterministic helpers with clear interfaces, e.g.:

  - Mark content as archived by storage_key.

  - Select candidates for expiration based on expires_at.

  - Summarize per-tenant storage usage for billing/OLAP ingestion.

- Guidelines:

  - No hard-coded third-party logic.

  - No complex alert routing or provider-specific functionality.

  - Use as primitives called by JS/TS workers.

Example pattern:

```sql
CREATE OR REPLACE FUNCTION mark_expired_content_archived(p_limit INTEGER)
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER;
BEGIN
    UPDATE content_objects
    SET
        expires_at = expires_at,
        -- Example: set archived flag if you add such a column later
        -- is_archived = TRUE,
        last_accessed_at = last_accessed_at
    WHERE expires_at IS NOT NULL
      AND expires_at <= NOW()
    ORDER BY expires_at
    LIMIT p_limit;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$ LANGUAGE plpgsql;


```

JS/TS worker would:

- Call this helper in batches.

- Emit metrics/logs to external systems.

- Avoid embedding monitoring logic back into DB.

---

## 6. Migration and Future Implementation Plan

Use this guide as the forward-looking contract:

- Treat:

- Detailed lifecycle SQL, pool metrics, content_access_log, etc. as historical prototypes.

- Extract:

- Good ideas (tiered storage, retention policies, dedup).

- Re-implement them as:

  - JS/TS workers orchestrating:

  - Reads/writes to content_objects/attachments.

  - Logging to external analytics/observability.

  - Optional helper functions in SQL for batch operations.

- For new work:

  - Add or adjust only:

    - content_objects

    - attachments

    - Minimal, focused helper functions.

  - Keep:

    - Analytics → OLAP docs.

    - Product/behavioral/infrastructure logging → external analytics/logging doc.

This schema guide, alongside:

- [OLTP Schema Guide](README),

- [OLAP Analytics Schema Guide](README),

- [External Analytics Logging](README),
provides the coherent context and blueprint for future implementation of the Content DB tier.

---
