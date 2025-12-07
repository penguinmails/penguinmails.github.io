---
title: "Log Viewer"
description: "Centralized application log search and analysis for debugging production issues"
last_modified_date: "2025-12-04"
level: "3"
persona: "Developers, Operations Engineers"
status: "ACTIVE"
category: "Admin"
---

# Log Viewer

**Powerful log search and analysis for debugging production issues and tracing errors.**

---

## Overview

The Log Viewer provides developers and operations engineers with centralized access to application logs across all services. Search, filter, and export logs for debugging production issues, investigating errors, and analyzing system behavior.

### Key Capabilities

- **Full-Text Search**: Fast search across millions of log entries
- **Advanced Filtering**: Filter by level, service, time range, and metadata
- **Regex Support**: Pattern matching for complex searches
- **Export**: Download filtered logs for offline analysis
- **Real-Time Tail**: Stream live logs as they arrive

---

## Feature Components

### Log Search Interface

**Search Bar**:

- Placeholder: "Search logs (e.g., errors, user email, request ID)"
- Full-text search across message, stack traces, metadata
- **Regex Support**: Enable for pattern matching
- Autocomplete for common searches

**Search Examples**:

- `error payment failed` - Find payment errors
- `request_id:req_abc123` - Trace specific request
- `user@example.com` - Find all logs for a user
- `/timeout.*database/` - Regex for DB timeouts

### Filters Sidebar

**Log Level**:

- ERROR (only errors and critical)
- WARNING (warnings and above)
- INFO (informational and above)
- DEBUG (all logs, including verbose)

**Service**:

- API Server
- SMTP Service
- Queue Workers
- Web Frontend
- Database

**Time Range**:

- Last hour
- Last 24 hours
- Last 7 days
- Custom (date picker)

**Advanced Filters**:

- Request ID
- User ID
- Tenant ID
- IP Address

### Log Results View

**Table Columns**:

- Timestamp (ISO 8601)
- Level (color-coded)
- Service
- Message (truncated)
- User/Request ID

**Color Coding**:

- 🔴 ERROR: Red background
- 🟡 WARNING: Yellow background
- 🔵 INFO: Blue text
- ⚪ DEBUG: Grey text

**Expandable Rows**:

- Click to view full log entry
- JSON viewer for structured metadata
- Stack trace with syntax highlighting
- Related logs (same request ID)

### Export Options

**Formats**:

- CSV: Tabular data for spreadsheet analysis
- JSON: Structured data for programmatic processing
- TXT: Plain text for grep/awk analysis

**Export Limits**:

- Max 10,000 rows per export
- Async job for exports > 1,000 rows
- Email notification when export ready

---

## User Stories

### Developer (Tracing Production Error)

> *"A customer reported a 500 error at 10:15am. I need to find the error and stack trace to debug the issue."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/system/logs`
> 2. Set time range: "Custom" → 10:10-10:20am
> 3. Filter level: ERROR
> 4. Search: customer email or request ID from support ticket
> 5. Find error log entry
> 6. Expand row to view full stack trace
> 7. Identify code path and root cause
> 8. Deploy fix and verify resolution

### Operations Engineer (Live Debugging)

> *"I'm deploying a new feature and want to monitor logs in real-time to catch any issues immediately."*
>
> **Workflow**:
>
> 1. Navigate to log viewer
> 2. Filter service: "API Server"
> 3. Filter level: "WARNING" (warnings and errors)
> 4. Enable "Follow Tail" mode
> 5. Deploy feature
> 6. Watch logs stream live
> 7. If errors appear, pause tail and investigate
> 8. Otherwise, confirm clean deployment

---

## Technical Integration

### Elasticsearch Backend (2026 Spike)

- **Cluster**: 3-node cluster for high availability
- **Index Strategy**: Daily indices (e.g., `logs-2025-12-04`)
- **Retention**: 90 days (auto-deleted on rotation)
- **Query Performance**: <1s for most searches

### Structured Logging

**Log Format** (JSON):

```json
{
  "timestamp": "2025-12-04T12:30:00Z",
  "level": "ERROR",
  "service": "api",
  "message": "Payment processing failed",
  "request_id": "req_abc123",
  "user_id": "usr_xyz",
  "tenant_id": "tn_456",
  "error": {
    "type": "PaymentError",
    "message": "Insufficient funds",
    "stack_trace": "..."
  }
}
```

### Sentry Integration (2026 Spike)

- **Error Tracking**: Errors automatically sent to Sentry
- **Linked**: Log viewer shows Sentry issue link for errors
- **Context**: Sentry captures breadcrumbs and user context

---

## Performance Considerations

### Search Optimization

- **Indexed Fields**: timestamp, level, service, request_id, user_id
- **Full-Text Index**: message, error.message, error.stack_trace
- **Query Caching**: 5-minute cache for common searches

### Data Volume

- **Ingest Rate**: ~100GB logs per day
- **Total Storage**: ~10TB (90 days retention)
- **Query Concurrency**: Support 50+ concurrent searches

---

## Related Documentation

- [Platform Admin Routes - Logs](/docs/design/routes/platform-admin#dashboard-system-logs)
- [System Monitoring API](/docs/implementation-technical/api/platform-api/system-monitoring)
- [Logging Standards](/docs/implementation-technical/observability/logging)
- [Error Tracking](/docs/operations/monitoring/sentry-integration)
