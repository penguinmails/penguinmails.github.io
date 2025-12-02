---
title: "Content Database ER Diagram"
description: "Content Database ER Diagram (Mermaid)"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---


# Content Database ER Diagram (Mermaid)

This diagram represents the canonical Content DB schema corresponding to:

- [Content Database Schema Guide](/docs/implementation-technical/database-infrastructure/content-database/schema-guide)

It is scoped strictly to heavy content storage (bodies, attachments) and intentionally excludes:

- Analytics/OLAP tables

- OLTP business entities

- Generic logging/telemetry/infra metrics (see [External Analytics Logging](/docs/implementation-technical/database-infrastructure/content-database/README))

```mermaid
---
config:
  layout: dagre
---
erDiagram
  direction TB

  %% ==========================
  %% Core Content Storage
  %% ==========================

  content_objects {
    varchar(500) storage_key PK
    uuid tenant_id
    text content_text
    text content_html
    jsonb headers
    int raw_size_bytes
    timestamptz created_at
    timestamptz expires_at
    timestamptz last_accessed_at
    varchar(64) content_hash
    varchar(20) compression_algorithm
    int compressed_size_bytes
  }

  attachments {
    uuid id PK
    varchar(500) parent_storage_key FK
    varchar(255) filename
    varchar(100) mime_type
    int size_bytes
    bytea content
    varchar(50) storage_disposition
    timestamptz created_at
  }

  %% ==========================
  %% Relationships
  %% ==========================

  %% One content object can have many attachments
  content_objects ||--o{ attachments : "attachments for content"

  %% ==========================
  %% Cross-Tier Contracts (Conceptual)
  %% ==========================

  %% Note (conceptual only, not physical FKs):
  %% - OLTP email/message tables store content_storage_key referencing content_objects.storage_key.
  %% - No cross-database foreign keys; linking is enforced by application logic.
  %% - OLAP uses only metadata/aggregates; never joins directly on content_objects for bodies.

  %% ==========================
  %% Logging & Analytics Guidance
  %% ==========================

  %% The Content DB does NOT store:
  %% - High-volume access logs
  %% - Connection pool metrics
  %% - Infra or system alerts
  %% - Detailed security or behavioral analytics
  %%
  %% These belong in external analytics/logging/observability systems
  %% as defined in ../operations/external-analytics-logging.md.


```

---

