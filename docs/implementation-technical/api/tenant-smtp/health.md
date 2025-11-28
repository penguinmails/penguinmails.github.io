---
title: "Health & Metrics API"
description: "Detailed endpoint specifications for Tenant SMTP Health and Metrics"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Health & Metrics API

**Parent API**: [Tenant SMTP API](/docs/implementation-technical/api/tenant-smtp)
**URL Prefix**: `/api/v1/tenant/smtp`

---

## Endpoints

### Get SMTP Status

**Method**: `GET`  
**URL**: `/api/v1/tenant/smtp/status`  
**Purpose**: Summarized operational health for the tenant's sending.

**Response**:

```json
{
  "success": true,
  "data": {
    "sending_enabled": true,
    "reputation_band": "healthy",
    "recent_bounce_rate": 0.012
  }
}


```

### Get SMTP Metrics

**Method**: `GET`  
**URL**: `/api/v1/tenant/smtp/metrics`  
**Purpose**: Aggregate deliverability metrics for dashboards.

**Query Parameters**:

- `window`: e.g., `7d`

**Response**:

```json
{
  "success": true,
  "data": {
    "window": "7d",
    "sent": 250000,
    "delivered": 245000,
    "bounced": 2500,
    "opens": 80000
  }
}


```
