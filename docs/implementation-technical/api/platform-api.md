---
title: "Platform API - Overview"
description: "Hub for Platform-level API endpoints: Analytics, Subscriptions, and System Administration"
last_modified_date: "2025-11-21"
level: "2"
persona: "Backend Developers, Frontend Developers"
---


# Platform API

**Server**: Central Monolithic Server
**URL Prefix**: `/api/v1/platform/*`
**Purpose**: Analytics, subscriptions, and system administration for executive and operational oversight.

---

## Overview

The Platform API provides internal operations, analytics aggregation, and business intelligence. It is primarily consumed by the Admin Dashboard and executive views.

---

## Endpoint Categories

### 1. Subscriptions & Billing

**Documentation**: [Subscriptions API](/docs/implementation-technical/api/platform-api/subscriptions)

Manage tenant subscriptions, billing, and payment records.

**Key Endpoints**:

- `GET /api/v1/platform/subscriptions` - List subscriptions

- `GET /api/v1/platform/tenants/{id}/subscription` - Get tenant subscription

- `GET /api/v1/platform/subscriptions/analytics` - Revenue metrics

### 2. System Analytics

**Documentation**: [Analytics API](/docs/implementation-technical/api/platform-api/analytics)

System-wide metrics, revenue protection, and cost optimization.

**Key Endpoints**:

- `GET /api/v1/platform/system/overview` - System health

- `GET /api/v1/platform/system/revenue-protection` - Business metrics

- `GET /api/v1/platform/system/cost-optimization` - Cost analysis

### 3. Admin Operations

**Documentation**: [Admin API](/docs/implementation-technical/api/platform-api/admin)

User management, tenant management, and feature flags.

---

## Authentication

All endpoints require a valid session authenticated via **NileDB** with appropriate RBAC roles.

**Required Roles**:

- `ROLE_SYSTEM_ADMIN`

- `ROLE_EXECUTIVE_*`

- `ROLE_OPERATIONS_MANAGER`

---

## Common Patterns

### Response Envelope

```json
{
  "success": true,
  "data": { ... },
  "meta": {
    "data_source": "backbone_api",
    "last_updated": "ISO8601"
  }
}


```
