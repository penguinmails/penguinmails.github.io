---
title: "Webhook Routes - Delivery Logs"
description: "Comprehensive history of all webhook delivery attempts, filtering tools, and failed delivery management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Routes - Delivery Logs

### `/dashboard/settings/webhooks/[webhook_id]/logs` - Full History

#### Delivery Log Filters

**Filter Bar**:

- **Status**: All, Success, Failed, Pending Retry.
- **Event Type**: Multi-select dropdown.
- **Date Range**: Date picker (default: Last 7 days).
- **Search**: Search by event ID or contact email.

**Export**:

- **"Export CSV" Button**: Download filtered logs.

#### Delivery Log Table

| Timestamp | Event ID | Event Type | Status | Response Time | Attempt | Actions |
|-----------|----------|------------|--------|---------------|---------|---------|
| 2:34:12 PM | evt_123 | email.opened | ✓ 200 | 142ms | 1/5 | Details |
| 2:33:45 PM | evt_124 | email.clicked | ✓ 200 | 156ms | 1/5 | Details |
| 2:30:10 PM | evt_125 | email.bounced | ✘ 500 | 5000ms | 3/5 | Details |

---

### Delivery Detail Sidebar (Drawer)

Triggered by clicking "Details" on any log row.

- **Status Details**: Full HTTP response code and description.
- **Request Metadata**:
  - `X-PenguinMails-Signature`: The signature sent.
  - `X-PenguinMails-Event-ID`: Unique event ID.
- **Request Body**: Syntax-highlighted JSON payload.
- **Response Headers**: Headers returned by user server.
- **Response Body**: Body returned by user server (first 10KB).

**Actions**:

- **"Copy Request" Button**: Copy payload.
- **"Copy Response" Button**: Copy response body.
- **"Retry Now" Button**: Manually retry failed delivery.
- **"View Event" Link**: Navigate to global event details.

---

#### Failed Deliveries Summary

- **Total Failed**: "11 in last 24 hours"
- **Most Common Error**: "500 Internal Server Error (7 occurrences)"
- **Retry Status**: "3 pending retry, 8 exhausted retries"
