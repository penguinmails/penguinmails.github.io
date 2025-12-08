---
title: "System Analytics API"
description: "Detailed endpoint specifications for System Analytics and Business Intelligence"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# System Analytics API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)
**URL Prefix**: `/api/v1/platform/system`

---

## Endpoints

### System Overview

**Method**: `GET`
**URL**: `/api/v1/platform/system/overview`
**Purpose**: Return current server health status with database connectivity checks.

> [!NOTE]
> This endpoint returns the health of the **current API server instance**. It performs lightweight connection checks to OLTP and OLAP databases. For aggregate platform health and historical trends, see PostHog dashboards (2026+ integrated monitoring).

**Response**:

```json
{
  "success": true,
  "data": {
    "timeframe": "last_30d",
    "system_health": {
      "overall_status": "operational",
      "uptime": "99.9%"
    },
    "tenant_metrics": {
      "total_tenants": 150,
      "active_tenants": 145
    },
    "business_metrics": {
      "monthly_revenue": "stable"
    }
  }
}


```

### Tenant System Summary

**Method**: `GET`
**URL**: `/api/v1/platform/system/tenants/{tenantId}/summary`
**Purpose**: System overview for a single tenant.

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "system_metrics": {
      "sent_30d": "100K-150K",
      "delivery_rate": "98-99_percent"
    },
    "cost_analysis": {
      "monthly_cost": "1000-1500",
      "cost_trend": "stable"
    }
  }
}


```

### Revenue & Business Metrics

**Method**: `GET`
**URL**: `/api/v1/platform/system/revenue-protection`
**Purpose**: Business metrics overview for revenue protection.

**Query Parameters**:

- `window`: 'quarterly' (default)

### Cost & Optimization View

**Method**: `GET`
**URL**: `/api/v1/platform/system/cost-optimization`
**Purpose**: Cost analysis and optimization opportunities.

### System Intelligence Summary

**Method**: `GET`
**URL**: `/api/v1/platform/system/intelligence/summary`
**Purpose**: Lightweight system intelligence for dashboard overview.

### Business Planning View

**Method**: `GET`
**URL**: `/api/v1/platform/system/planning`
**Purpose**: Business planning support and roadmap overview.
