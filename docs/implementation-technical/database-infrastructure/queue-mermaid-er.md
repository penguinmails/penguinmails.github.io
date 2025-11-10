# Queue / Jobs ER Diagram (Mermaid)

This diagram models the dedicated Queue / Jobs tier, aligned with the 5-tier architecture:

- OLTP: core entities.
- Content DB: heavy content.
- OLAP: aggregates only.
- Queue / Jobs: async orchestration (this file).
- Notifications DB: notifications + curated system events.
- External logging: raw traces/telemetry.

The Queue tier:
- Coordinates work.
- Stores minimal operational state.
- Is NOT:
  - An analytics warehouse.
  - A permanent log store.
  - A place for heavy payloads or PII-rich blobs.

```mermaid
---
config:
  layout: dagre
---
erDiagram
  direction TB

  %% ==========================
  %% Job Queues
  %% ==========================

  job_queues {
    varchar(100) name PK
    int default_priority           "Default priority (e.g., 100, lower = higher priority)"
    boolean is_active              "Pause/resume all jobs in this queue"
    timestamptz created_at
  }

  %% ==========================
  %% Jobs
  %% ==========================

  jobs {
    uuid id PK
    varchar(100) queue_name FK     "References job_queues.name"
    varchar(50) status             "queued, running, completed, failed, cancelled"
    int priority                   "Lower runs sooner; override default_priority"
    jsonb payload                  "Minimal data/IDs; no large blobs or secrets"
    int attempt_count
    int max_attempts
    timestamptz run_at             "Scheduled execution time"
    timestamptz started_at
    timestamptz completed_at
    timestamptz failed_at
    varchar(255) last_error_message
    timestamptz created_at
    timestamptz updated_at
  }

  %% ==========================
  %% Job Logs (Optional, Bounded)
  %% ==========================

  job_logs {
    uuid id PK
    uuid job_id FK                 "References jobs.id"
    varchar(50) status             "attempting, success, retry, failed"
    text log_message               "Short context; detailed traces go to external logging"
    int attempt_number
    timestamptz started_at
    timestamptz finished_at
    interval duration
  }

  %% ==========================
  %% Relationships
  %% ==========================

  job_queues ||--o{ jobs : "queue contains jobs"
  jobs       ||--o{ job_logs : "job has logs"

  %% ==========================
  %% Notes & Tier Boundaries
  %% ==========================

  %% - payload stores only what workers need:
  %%   - IDs, small config, references to OLTP/Content/Notifications records.
  %%   - Do NOT store full email bodies, attachments, or high-PII blobs here.
  %%
  %% - job_logs is optional and should be:
  %%   - Bounded via retention.
  %%   - Used for local debugging.
  %%   - NOT a full observability sink.
  %%
  %% - Raw traces, stack traces, provider responses, and metrics:
  %%   - Belong in the external logging/observability stack
  %%     (see external-analytics-logging).
  %%
  %% - OLAP must NOT query this tier directly as a primary analytics source.
  %%   - If analytics needed, create dedicated aggregates fed from jobs or events.
  %%
  %% - This model fits the 5-tier architecture:
  %%   - Jobs orchestrate work between OLTP, Content DB, Notifications DB,
  %%     external services, and OLAP loaders, without overloading any tier.