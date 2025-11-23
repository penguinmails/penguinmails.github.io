---
title: "Admin Operations API"
description: "Detailed endpoint specifications for System Administration and User Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---

# Admin Operations API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)
**URL Prefix**: `/api/v1/platform/admin`

---

## Endpoints

### List Users

**Method**: `GET`  
**URL**: `/api/v1/platform/admin/users`  
**Purpose**: List all users across the platform (Super Admin only).

**Query Parameters**:

- `search`: Email or name
- `role`: Filter by role
- `tenant_id`: Filter by tenant

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "usr_123",
      "email": "admin@acme.com",
      "name": "Admin User",
      "role": "admin",
      "tenant_id": "tn_123",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ]
}
```

### Get User Details

**Method**: `GET`  
**URL**: `/api/v1/platform/admin/users/{id}`  
**Purpose**: Get detailed user profile.

### User Audit Trail

**Method**: `GET`  
**URL**: `/api/v1/platform/admin/users/{id}/audit-trail`  
**Purpose**: View activity log for a specific user.

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "log_123",
      "action": "login",
      "ip_address": "192.168.1.1",
      "timestamp": "2025-11-21T10:00:00Z"
    },
    {
      "id": "log_124",
      "action": "campaign_created",
      "resource_id": "cmp_abc",
      "timestamp": "2025-11-21T10:05:00Z"
    }
  ]
}
```

### Campaign Analytics (Cross-Tenant)

**Method**: `GET`  
**URL**: `/api/v1/platform/analytics/campaigns`  
**Purpose**: Aggregate campaign performance across the platform.
