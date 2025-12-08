---
title: "Platform API - Overview"
description: "Hub for Platform-level API endpoints: Analytics, Subscriptions, and System Administration"
last_modified_date: "2025-12-07"
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

## Quick Endpoint Reference

### User Management

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/platform/admin/users` | List all users | [Admin API](./platform-api/admin#list-users) |
| `GET` | `/api/v1/platform/admin/users/{id}` | Get user details | [Admin API](./platform-api/admin#get-user-details) |
| `GET` | `/api/v1/platform/admin/users/{id}/audit-trail` | User activity log | [Admin API](./platform-api/admin#user-audit-trail) |
| `POST` | `/api/v1/platform/admin/users/{id}/suspend` | Suspend account | [Admin API](./platform-api/admin#suspend-user-account) |
| `POST` | `/api/v1/platform/admin/users/{id}/revoke-sessions` | Revoke all sessions | [Admin API](./platform-api/admin#revoke-user-sessions) |
| `POST` | `/api/v1/platform/admin/users/{id}/reset-password` | Send password reset | [Admin API](./platform-api/admin#reset-user-password) |
| `PATCH` | `/api/v1/platform/admin/users/{id}` | Update user role | [Admin API](./platform-api/admin#update-user-role) |
| `DELETE` | `/api/v1/platform/admin/users/{id}` | Delete account (GDPR) | [Admin API](./platform-api/admin#delete-user-account) |

### Tenant Management

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/platform/admin/tenants` | List all tenants | [Admin API](./platform-api/admin#list-all-tenants) |
| `GET` | `/api/v1/platform/admin/tenants/{id}` | Get tenant details | [Admin API](./platform-api/admin#get-tenant-details) |
| `PATCH` | `/api/v1/platform/admin/tenants/{id}` | Plan overrides | [Admin API](./platform-api/admin#update-tenant-plan-overrides) |
| `POST` | `/api/v1/platform/admin/tenants/test` | Create test tenant | [Admin API](./platform-api/admin#create-test-tenant) |
| `GET` | `/api/v1/platform/admin/tenants/{id}/feature-flags` | Get feature flags | [Admin API](./platform-api/admin#get-tenant-feature-flags) |
| `PATCH` | `/api/v1/platform/admin/tenants/{id}/feature-flags` | Update feature flags | [Admin API](./platform-api/admin#update-tenant-feature-flags) |

### Plan Management

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/platform/admin/plans` | List all plans | [Plans API](./platform-api/plans#list-all-plans) |
| `GET` | `/api/v1/platform/admin/plans/{id}` | Get plan details | [Plans API](./platform-api/plans#get-plan-details) |
| `POST` | `/api/v1/platform/admin/plans` | Create plan | [Plans API](./platform-api/plans#create-plan) |
| `PUT` | `/api/v1/platform/admin/plans/{id}` | Update plan | [Plans API](./platform-api/plans#update-plan) |

### Finance

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/platform/finance/subscription-summary` | Subscription counts | [Finance API](./platform-api/finance#get-subscription-summary) |
| `GET` | `/api/v1/platform/finance/stripe-sync-status` | Webhook health | [Finance API](./platform-api/finance#get-stripe-sync-status) |
| `POST` | `/api/v1/platform/finance/sync-transaction` | Force sync | [Finance API](./platform-api/finance#force-sync-transaction) |

### System Monitoring

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/platform/system/queues` | List queues | [System API](./platform-api/system-monitoring#list-queues) |
| `GET` | `/api/v1/platform/system/queues/{name}/jobs` | List queue jobs | [System API](./platform-api/system-monitoring#get-queue-jobs) |
| `POST` | `/api/v1/platform/system/queues/{name}/pause` | Pause queue | [System API](./platform-api/system-monitoring#pause-queue) |
| `POST` | `/api/v1/platform/system/queues/{name}/resume` | Resume queue | [System API](./platform-api/system-monitoring#resume-queue) |
| `POST` | `/api/v1/platform/system/jobs/{id}/retry` | Retry job | [System API](./platform-api/system-monitoring#retry-failed-job) |
| `DELETE` | `/api/v1/platform/system/jobs/{id}` | Delete job | [System API](./platform-api/system-monitoring#delete-job) |
| `GET` | `/api/v1/platform/system/infrastructure/health` | Service health | [System API](./platform-api/system-monitoring#get-infrastructure-health) |
| `GET` | `/api/v1/platform/system/infrastructure/ip-reputation` | IP reputation | [System API](./platform-api/system-monitoring#get-ip-reputation) |
| `GET` | `/api/v1/platform/system/infrastructure/alerts` | Infra alerts | [System API](./platform-api/system-monitoring#get-infrastructure-alerts) |
| `GET` | `/api/v1/platform/system/logs` | Search logs | [System API](./platform-api/system-monitoring#search-logs) |
| `GET` | `/api/v1/platform/system/logs/export` | Export logs | [System API](./platform-api/system-monitoring#export-logs) |

### Vault Secrets Management

| Method | Endpoint | Purpose | Docs |
|--------|----------|---------|------|
| `GET` | `/api/v1/admin/vault/health` | Vault health | [Vault API](./platform-api/vault#get-vault-health) |
| `GET` | `/api/v1/admin/vault/backup-status` | Backup status | [Vault API](./platform-api/vault#get-backup-status) |
| `POST` | `/api/v1/admin/vault/backup` | Force backup | [Vault API](./platform-api/vault#force-backup) |
| `GET` | `/api/v1/admin/secrets/tenants` | List tenant secrets | [Vault API](./platform-api/vault#list-tenant-secrets) |
| `GET` | `/api/v1/admin/secrets/tenant/{id}` | Tenant secret details | [Vault API](./platform-api/vault#get-tenant-secret-details) |
| `GET` | `/api/v1/admin/secrets/tenant/{id}/smtp-credentials` | View SMTP credentials | [Vault API](./platform-api/vault#view-smtp-credentials) |
| `POST` | `/api/v1/admin/secrets/tenant/{id}/rotate` | Rotate secret | [Vault API](./platform-api/vault#rotate-secret) |
| `POST` | `/api/v1/admin/secrets/rotate-all` | Bulk rotation | [Vault API](./platform-api/vault#bulk-rotate-secrets) |
| `GET` | `/api/v1/admin/vault/audit-logs` | Vault audit logs | [Vault API](./platform-api/vault#get-audit-logs) |

---

## Endpoint Categories (Detailed)

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

### 4. Plan Management

**Documentation**: [Plans API](/docs/implementation-technical/api/platform-api/plans)

Subscription plan configuration, limits, and Stripe mappings.

### 5. Finance

**Documentation**: [Finance API](/docs/implementation-technical/api/platform-api/finance)

Subscription monitoring and Stripe webhook status.

### 6. System Monitoring

**Documentation**: [System Monitoring API](/docs/implementation-technical/api/platform-api/system-monitoring)

Infrastructure health, queue monitoring, and log access.

### 7. Vault Management

**Documentation**: [Vault API](/docs/implementation-technical/api/platform-api/vault)

HashiCorp Vault secrets management, rotation, and audit.

---

## Authentication

All endpoints require a valid session authenticated via **NileDB** with appropriate RBAC roles.

**Required Roles**:

| Role | Access Level |
|------|--------------|
| `super_admin` | Full access to all platform admin endpoints |
| `admin` | Tenant and user management (view-only for some) |
| `support` | Read-only access, no PII |
| `finance` | Finance dashboard and Stripe sync endpoints |
| `ops` | System monitoring and queue management |
| `qa` | Sandbox-only access |

---

## Pagination Strategy

All list endpoints support **offset-based pagination** to enable "Jump to page X" navigation:

| Parameter | Description | Default | Max |
|-----------|-------------|---------|-----|
| `limit` | Max results per page | 50 | 100 |
| `offset` | Number of records to skip | 0 | — |

**Response Pagination Envelope**:

```json
{
  "pagination": {
    "total": 1234,
    "limit": 50,
    "offset": 0
  }
}
```

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

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "User does not have required permissions"
  }
}
```

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes](/docs/design/routes/platform-admin) - Complete admin panel UI specifications

### Feature Documentation

- [Plan Management](/docs/features/admin/plan-management/) - Plan configuration features
- [User Management](/docs/features/admin/user-management/) - User lookup and audit trails
- [Tenant Management](/docs/features/admin/tenant-management/) - Organization management
- [Finance](/docs/features/admin/finance/) - Subscription monitoring
- [System Monitoring](/docs/features/admin/system-monitoring/) - Infrastructure and queues
- [Vault Management](/docs/features/admin/vault-management/) - Secrets management
