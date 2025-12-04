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

**Query Parameters**:

- `start_time` (optional): ISO 8601 timestamp
- `end_time` (optional): ISO 8601 timestamp
- `action_type` (optional): Filter by action (login, campaign_created, settings_changed, etc.)
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

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
  ],
  "pagination": {
    "total": 456,
    "limit": 50,
    "offset": 0
  }
}


```

### Suspend User Account

**Method**: `POST`
**URL**: `/api/v1/platform/admin/users/{id}/suspend`
**Purpose**: Temporarily disable user account access

**Request**:

```json
{
  "reason": "Policy violation - spam complaints"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "user_id": "usr_123",
    "status": "suspended",
    "suspended_at": "2025-12-04T12:00:00Z"
  }
}
```

---

### Reset User Password

**Method**: `POST`
**URL**: `/api/v1/platform/admin/users/{id}/reset-password`
**Purpose**: Send password reset email to user

**Response**:

```json
{
  "success": true,
  "data": {
    "user_id": "usr_123",
    "reset_email_sent": true,
    "expires_at": "2025-12-05T12:00:00Z"
  }
}
```

---

### Delete User Account

**Method**: `DELETE`
**URL**: `/api/v1/platform/admin/users/{id}`
**Purpose**: GDPR-compliant hard delete (irreversible)

**Query Parameters**:

- `confirmation`: Must be set to user's email address for confirmation

**Response**:

```json
{
  "success": true,
  "data": {
    "user_id": "usr_123",
    "deleted_at": "2025-12-04T12:00:00Z",
    "data_removed": true
  }
}
```

---

## Tenant Management Endpoints

### List All Tenants

**Method**: `GET`
**URL**: `/api/v1/platform/admin/tenants`
**Purpose**: List all tenant organizations

**Query Parameters**:

- `search`: Company name or owner email
- `plan`: Filter by plan slug (free, pro, enterprise)
- `status`: Filter by status (active, trial, churned)
- `mrr_min` (optional): Minimum MRR filter
- `mrr_max` (optional): Maximum MRR filter
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

**Response**:

```json
{
  "success": true,
  "data": {
    "tenants": [
      {
        "id": "tn_123",
        "company_name": "Acme Corp",
        "owner_email": "owner@acme.com",
        "plan": {
          "name": "Enterprise",
          "slug": "enterprise"
        },
        "mrr": 299.00,
        "workspaces": 3,
        "users": 15,
        "status": "active",
        "created_at": "2025-01-15T10:00:00Z"
      }
    ],
    "pagination": {
      "total": 234,
      "limit": 50,
      "offset": 0
    }
  }
}
```

---

### Get Tenant Details

**Method**: `GET`
**URL**: `/api/v1/platform/admin/tenants/{id}`
**Purpose**: Retrieve detailed tenant information

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant": {
      "id": "tn_123",
      "company_name": "Acme Corp",
      "owner_email": "owner@acme.com",
      "plan": "enterprise",
      "status": "active",
      "subscription": {
        "id": "sub_abc",
        "status": "active",
        "current_period_end": "2025-12-31T23:59:59Z"
      },
      "usage": {
        "users": 15,
        "domains": 5,
        "emails_this_month": 45000
      },
      "created_at": "2025-01-15T10:00:00Z"
    }
  }
}
```

---

### Update Tenant (Plan Overrides)

**Method**: `PATCH`
**URL**: `/api/v1/platform/admin/tenants/{id}`
**Purpose**: Apply plan overrides and billing customization

**Request**:

```json
{
  "plan_override": {
    "plan_id": "plan_enterprise",
    "custom_pricing": true,
    "price_monthly": 249.00,
    "limits": {
      "max_users": 25,
      "max_domains": 10,
      "max_emails_per_month": 100000
    }
  },
  "billing_override": {
    "type": "extended_trial",
    "trial_end_date": "2025-12-31T23:59:59Z",
    "reason": "Enterprise evaluation extension"
  }
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "overrides_applied": true,
    "effective_date": "2025-12-04T12:00:00Z"
  }
}
```

---

### Create Test Tenant

**Method**: `POST`
**URL**: `/api/v1/platform/admin/tenants/test`
**Purpose**: Provision sandbox account for demos

**Request**:

```json
{
  "company_name": "Demo Account",
  "owner_email": "demo@example.com",
  "plan": "pro",
  "auto_cleanup_days": 30
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_test_xyz",
    "login_url": "https://app.penguinmails.com/login?tenant=tn_test_xyz",
    "expires_at": "2026-01-04T12:00:00Z"
  }
}
```

---

## Feature Flags Endpoints

### Get Tenant Feature Flags

**Method**: `GET`
**URL**: `/api/v1/platform/admin/tenants/{id}/feature-flags`
**Purpose**: List all feature flags for a tenant

**Response**:

```json
{
  "success": true,
  "data": {
    "flags": [
      {
        "flag_name": "advanced_analytics",
        "enabled": true,
        "updated_at": "2025-11-20T10:00:00Z"
      },
      {
        "flag_name": "api_access",
        "enabled": true,
        "updated_at": "2025-01-15T10:00:00Z"
      },
      {
        "flag_name": "white_label",
        "enabled": false,
        "updated_at": null
      }
    ]
  }
}
```

---

### Update Tenant Feature Flags

**Method**: `PATCH`
**URL**: `/api/v1/platform/admin/tenants/{id}/feature-flags`
**Purpose**: Enable or disable beta features

**Request**:

```json
{
  "flags": [
    {
      "flag_name": "advanced_analytics",
      "enabled": true
    },
    {
      "flag_name": "white_label",
      "enabled": false
    }
  ],
  "reason": "Beta program enrollment"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "flags_updated": 2,
    "updated_at": "2025-12-04T12:00:00Z"
  }
}
```

---

## Related Documentation

- [User Management Feature](/docs/features/admin/user-management/) - Feature overview
- [Tenant Management Feature](/docs/features/admin/tenant-management/) - Feature overview
- [Platform Admin Routes - Users](/docs/design/routes/platform-admin#dashboard-users) - User management UI
- [Platform Admin Routes - Tenants](/docs/design/routes/platform-admin#dashboard-tenants) - Tenant management UI

---

## Campaign Analytics (Cross-Tenant)

**Method**: `GET`
**URL**: `/api/v1/platform/analytics/campaigns`
**Purpose**: Aggregate campaign performance across the platform.
