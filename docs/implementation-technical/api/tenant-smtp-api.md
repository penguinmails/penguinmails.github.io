---
title: "Tenant SMTP REST API Contract"
description: "REST API contract for tenant-scoped SMTP configuration, verification, and deliverability metrics."
last_modified_date: "2025-11-10"
---

# Tenant SMTP REST API Contract

Level: Implementation-Ready
Audience: Backend engineers, integrators, internal tools

This contract defines REST-only endpoints that expose each tenant's SMTP configuration and high-level email performance signals, aligned with:

- Multi-tenant isolation and RLS
- Business Leaders backlog (BF-006, revenue)
- Database and infra docs:
  - `../database-infrastructure/oltp-schema-guide.md`
  - `../database-infrastructure/business-leaders-database-migration-guide.md`
- Executive and BI consumption via the Executive API (no direct DB exposure)

All endpoints are:

- Namespaced under `/api/v1/tenants/{tenantId}/smtp/...`
- Strictly tenant-scoped for authenticated principals
- REST-only, JSON only, no GraphQL

## 1. Authentication and Authorization

- Authentication: `Authorization: Bearer <token>`
- Token must map to:
  - The tenant context in path (`{tenantId}`), or
  - A privileged internal/admin role with cross-tenant permissions.
- Authorization:
  - Tenant users: can access only their own tenant’s SMTP resources.
  - Internal roles (support): require explicit scopes (e.g. `smtp:read`, `tenant:read`) and are fully audited.

## 2. Endpoints

### 2.1 Get Tenant SMTP Configuration

GET `/api/v1/tenants/{tenantId}/smtp/config`

Returns the effective SMTP configuration visible to this tenant.

Response (example):

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "from_domains": [
      {
        "domain": "example.com",
        "dkim_status": "verified",
        "spf_status": "verified",
        "dmarc_status": "configured",
        "tracking_domain": "trk.example.com"
      }
    ],
    "default_from": {
      "name": "Example Inc.",
      "email": "no-reply@example.com"
    },
    "rate_limits": {
      "max_per_minute": 600,
      "max_per_hour": 20000
    }
  }
}
```markdown

Rules:

- Enforce RLS: users cannot fetch another tenant’s config.
- Implementation reads from OLTP + config tables.

### 2.2 Get Tenant SMTP Status & Health

GET `/api/v1/tenants/{tenantId}/smtp/status`

Summarized operational health for the tenant’s sending.

```json
{
  "success": true,
  "data": {
    "sending_enabled": true,
    "recent_bounce_rate": 0.012,
    "recent_complaint_rate": 0.001,
    "reputation_band": "healthy",
    "enforcement": {
      "throttled": false,
      "notes": null
    }
  }
}
```markdown

Source:

- Aggregations built from logs/events (OLAP).
- No raw provider internals exposed.

### 2.3 Get Tenant SMTP Metrics (Aggregated)

GET `/api/v1/tenants/{tenantId}/smtp/metrics?window=7d`

Returns aggregate deliverability metrics for dashboards.

Parameters:

- `window`: e.g. `24h`, `7d`, `30d`

Response (example):

```json
{
  "success": true,
  "data": {
    "window": "7d",
    "sent": 250000,
    "delivered": 245000,
    "bounced": 2500,
    "complaints": 150,
    "opens": 80000,
    "clicks": 22000,
    "reputation_band": "watch",
    "recommendations": [
      {
        "code": "HIGH_BOUNCE_RATE",
        "message": "Bounce rate exceeds recommended threshold; review list hygiene.",
        "severity": "medium"
      }
    ]
  }
}
```markdown

Constraints:

- Computed via BI/OLAP; suitable for tenant and exec dashboards.
- Does not expose internal IP inventory or other tenants’ data.

---

## 3. Error Handling

Uses the shared standard from `../development-guidelines/api-reference.md`:

- `AUTHENTICATION_REQUIRED`, `INSUFFICIENT_PERMISSIONS`
- `RESOURCE_NOT_FOUND` when tenant does not exist or no SMTP config
- No raw provider error messages leaked directly.

---

## 4. Security & Compliance

- All tenant SMTP endpoints:
  - Enforce HTTPS.
  - Enforce strict tenant scoping.
  - Log access to sensitive configuration views when required by compliance.
- No direct mutation endpoints for IP/infra here; those live in Central SMTP Operations API.
---
