---
title: "Routing API"
description: "Detailed endpoint specifications for SMTP Routing and Assignments"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---

# Routing API

**Parent API**: [Central SMTP API](/docs/implementation-technical/api/central-smtp)
**URL Prefix**: `/api/v1/smtp/admin/assignments`

---

## Endpoints

### List Tenant Assignments

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/assignments`  
**Purpose**: View how tenants are mapped to IP pools.

**Query Parameters**:

- `tenantId`: Filter by tenant

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "assignment_id": "asn_123",
      "tenant_id": "tn_123",
      "pool_id": "pool_shared_default",
      "mode": "primary"
    }
  ]
}
```

### Set / Update Assignment

**Method**: `PUT`  
**URL**: `/api/v1/smtp/admin/assignments/{assignmentId}`  
**Purpose**: Create or update a tenant's pool assignment.

**Request**:

```json
{
  "tenant_id": "tn_123",
  "pool_id": "pool_dedicated_1",
  "mode": "primary",
  "notes": "Upgraded to dedicated IP"
}
```
