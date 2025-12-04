---
title: "Finance API"
description: "Revenue operations, MRR tracking, and financial reporting endpoints"
last_modified_date: "2025-12-04"
level: "3"
persona: "Backend Developers"
---

# Finance API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)  
**URL Prefix**: `/api/v1/platform/finance`

---

## Overview

The Finance API provides endpoints for revenue operations, MRR (Monthly Recurring Revenue) tracking, Stripe sync monitoring, and financial reporting. These endpoints power the finance dashboard and support automated financial reconciliation.

---

## Endpoints

### Get MRR Metrics

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/mrr`  
**Purpose**: Retrieve current MRR and growth metrics

**Response**:

```json
{
  "success": true,
  "data": {
    "current_mrr": 45230.00,
    "mrr_growth_percent": 12.3,
    "active_subscriptions": 234,
    "churn_rate_percent": 3.2,
    "as_of": "2025-12-04T12:00:00Z"
  }
}
```

---

### Get MRR Trend

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/mrr-trend`  
**Purpose**: Historical MRR data for trend analysis

**Query Parameters**:

- `months` (optional): Number of months to retrieve (default: 12, max: 24)
- `plan_id` (optional): Filter by specific plan UUID

**Response**:

```json
{
  "success": true,
  "data": {
    "months": [
      {
        "month": "2025-01",
        "mrr": 38450.00,
        "subscriptions": 198,
        "growth_percent": 8.5
      },
      {
        "month": "2025-02",
        "mrr": 40120.00,
        "subscriptions": 210,
        "growth_percent": 4.3
      }
    ]
  }
}
```

---

### Get Stripe Sync Status

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/stripe-sync-status`  
**Purpose**: Monitor Stripe webhook sync health

**Response**:

```json
{
  "success": true,
  "data": {
    "last_sync": "2025-12-04T12:05:00Z",
    "sync_health": "healthy",
    "invoices_synced": 1234,
    "failed_payments": 3,
    "pending_webhooks": 0,
    "last_webhook_event": {
      "id": "evt_abc123",
      "type": "invoice.paid",
      "timestamp": "2025-12-04T12:05:00Z"
    }
  }
}
```

**Sync Health Values**:

- `healthy`: All synced, no issues
- `delayed`: Sync behind by 5+ minutes
- `error`: Sync failures detected

---

### Force Stripe Sync

**Method**: `POST`  
**URL**: `/api/v1/platform/finance/stripe-sync`  
**Purpose**: Manually trigger Stripe webhook replay

**Request**:

```json
{
  "reason": "Manual reconciliation for month-end close"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "job_id": "sync_job_xyz",
    "status": "processing",
    "estimated_duration_seconds": 120
  }
}
```

---

### Export Financial Report

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/reports/export`  
**Purpose**: Generate financial reports for accounting

**Query Parameters**:

- `report_type`: `mrr_breakdown` | `invoice_summary` | `revenue_trend` | `failed_payments`
- `format`: `csv` | `pdf`
- `date_start` (optional): Start date (ISO 8601)
- `date_end` (optional): End date (ISO 8601)
- `plan_id` (optional): Filter by plan

**Response** (Async job):

```json
{
  "success": true,
  "data": {
    "export_id": "export_abc123",
    "status": "processing",
    "download_url": null,
    "expires_at": null
  }
}
```

**Check Export Status**:

`GET /api/v1/platform/finance/reports/export/{export_id}`

```json
{
  "success": true,
  "data": {
    "export_id": "export_abc123",
    "status": "completed",
    "download_url": "https://api.penguinmails.com/exports/mrr_2025-12.csv",
    "expires_at": "2025-12-05T12:00:00Z"
  }
}
```

---

## Error Handling

- `400 Bad Request`: Invalid parameters (e.g., invalid date range)
- `401 Unauthorized`: Missing or invalid token
- `403 Forbidden`: User does not have Finance role
- `404 Not Found`: Export ID not found
- `429 Too Many Requests`: Rate limit exceeded (max 100 requests/minute)

---

## Related Documentation

- [Finance Feature](/docs/features/admin/finance/) - Feature overview
- [Platform Admin Routes - Finance](/docs/design/routes/platform-admin#dashboard-finance) - UI specification
- [Subscriptions API](/docs/implementation-technical/api/platform-api/subscriptions) - Subscription data
