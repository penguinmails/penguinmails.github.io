---
title: "Import/Export Schema & Events"
description: "Database schema and event tracking for batch contact operations."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Import/Export Schema & Events

**Persistence layer design for tracking batch processing jobs.**

---

## 1. Import Jobs Table

Tracks the state and results of ingestion tasks.

```sql
CREATE TABLE import_jobs (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  file_name VARCHAR(255),
  file_url TEXT,
  status VARCHAR(50), -- pending, processing, completed, failed, rolled_back
  total_rows INTEGER,
  imported_count INTEGER DEFAULT 0,
  updated_count INTEGER DEFAULT 0,
  error_count INTEGER DEFAULT 0,
  errors JSONB,
  processed_rows INTEGER DEFAULT 0,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  created_by UUID REFERENCES users(id),
  can_rollback BOOLEAN DEFAULT TRUE
);
```

---

## 2. Export Jobs Table

Tracks the generation and availability of data exports.

```sql
CREATE TABLE export_jobs (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  export_type VARCHAR(50), -- full, filtered, segment
  filters JSONB,
  file_format VARCHAR(50),
  file_url TEXT,
  status VARCHAR(50),
  processed_contacts INTEGER DEFAULT 0,
  expires_at TIMESTAMP,
  created_by UUID REFERENCES users(id)
);
```

---

## 3. Event History (Rollback Log)

Logs every modification made during an import to enable reversible operations.

```sql
CREATE TABLE import_events (
  id UUID PRIMARY KEY,
  import_job_id UUID NOT NULL REFERENCES import_jobs(id),
  contact_id UUID NOT NULL REFERENCES contacts(id),
  event_type VARCHAR(50), -- created, updated, skipped
  previous_data JSONB, -- Captured before update
  new_data JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Purpose

This history allows the `ImportService` to:

1. Identify all contacts created in a specific job and delete them.
2. Identify all contacts updated in a specific job and restore their `previous_data`.
