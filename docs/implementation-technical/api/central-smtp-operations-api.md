---
title: "Central SMTP Operations REST API Contract"
description: "Internal REST API contract for managing shared SMTP infrastructure: IPs, pools, routing, and reputation for PenguinMails operations."
last_modified_date: "2025-11-10"
level: "2"
persona: "Documentation Users"
---

# Central SMTP Operations REST API Contract

Level: Implementation-Ready
Audience: Platform team, SRE, internal tools (NOT tenant-facing)

This contract defines REST-only endpoints for PenguinMails internal operations to manage shared SMTP infrastructure. It is the authoritative interface for:

- Managing IP inventory and pools
- Managing routing configuration and capacity planning
- Viewing and acting on reputation / health signals

Strictly aligned with:

- Multi-tenant isolation and infra docs:
  - `../database-infrastructure/queue-system-implementation-guide.md`
  - `../database-infrastructure/business-leaders-database-migration-guide.md`
  - `../database-infrastructure/oltp-mermaid-er.md`
  - `../database-infrastructure/notifications-mermaid-er.md`
- Executive security & audit requirements (BF-004)
- Executive via read-only consumption of these resources by the Executive API

All endpoints are:

- Internal-only: never exposed directly to tenants.
- Namespaced under `/api/v1/admin/smtp/...`
- REST-only, JSON
- Enforced via strong RBAC + `admin_audit_log` logging

## 1. Authentication, RBAC, and Audit

- Authentication: `Authorization: Bearer <internal-service-or-admin-token>`
- Required roles (examples):
  - `ROLE_SMTP_ADMIN`
  - `ROLE_DELIVERABILITY_ENGINEER`
  - `ROLE_PLATFORM_ENGINEER`
- All write operations MUST:
  - Be logged into `admin_audit_log` with: actor, action, target, before/after, timestamp, IP, user-agent, correlation_id.
  - Follow maker-checker flows for high-risk changes (e.g., IP reassignment, pool policy changes).

Reference:

- `business-leaders-database-migration-guide.md#step-5-security--access-control`
- BF-004 executive security and audit story.

## 2. IP Inventory Management

### 2.1 List SMTP IPs

GET `/api/v1/admin/smtp/ips`

Query params (optional):

- `status`: `active|warming|blocked|retired`
- `pool`: pool identifier
- `reputation_band`: `excellent|good|watch|bad`

Response:

```json
{
  "success": true,
  "data": [
    {
      "ip_id": "ip_123",
      "ip_address": "198.51.100.10",
      "status": "active",
      "pool": "shared_default",
      "reputation_band": "good",
      "warmup": {
        "in_progress": false
      },
      "capacity_score": 0.8,
      "approximate_cost": 12.50
    }
  ]
}
```

### 2.2 Get Single IP

GET `/api/v1/admin/smtp/ips/{ipId}`

Response includes detailed reputation and assignment information suitable for ops tools.
RLS: internal only; never exposed to tenants.

### 2.3 Update IP Metadata (Restricted)

PATCH `/api/v1/admin/smtp/ips/{ipId}`

Allowed fields (examples):

- `status`: `active|warming|blocked|retired`
- `pool`
- Operational flags (`blocked_reason`, `notes`)

All updates:

- Require `ROLE_SMTP_ADMIN`.
- Must be recorded in `admin_audit_log`.
- Must validate that routing changes do not break tenant isolation.

## 3. Pool Management

### 3.1 List Pools

GET `/api/v1/admin/smtp/pools`

Response:

```json
{
  "success": true,
  "data": [
    {
      "pool_id": "pool_shared_default",
      "name": "Shared Default",
      "description": "Default shared pool",
      "ip_count": 12,
      "status": "active",
      "max_senders": 500,
      "current_load_factor": 0.72
    }
  ]
}
```

### 3.2 Get Pool Details

GET `/api/v1/admin/smtp/pools/{poolId}`

Includes pool configuration, attached IPs, and key utilization metrics.

### 3.3 Update Pool Configuration (Restricted)

PATCH `/api/v1/admin/smtp/pools/{poolId}`

Examples:

- Update max senders / capacity thresholds
- Toggle active/inactive
- Adjust reputation/routing policies

Rules:

- High-risk; `ROLE_SMTP_ADMIN` + maker-checker.
- Must audit before/after.

## 4. Routing & Assignment

Assignments connect tenants (or internal sending units) to pools/IPs.

### 4.1 List Tenant → Pool Assignments

GET `/api/v1/admin/smtp/assignments?tenantId=tn_123`

Response shows internal view of how a tenant is mapped to pools).

### 4.2 Set / Update Assignment

PUT `/api/v1/admin/smtp/assignments/{assignmentId}`

Body (example):

```json
{
  "tenant_id": "tn_123",
  "pool_id": "pool_shared_default",
  "mode": "primary",
  "notes": "Manual override due to dedicated pool saturation"
}
```

Constraints:

- Changes must:
  - Enforce tenant isolation.
  - Respect capacity and reputation constraints.
- All mutations audited.

## 5. Reputation & Health

Read-only endpoints used by ops tools and indirectly by Executive API.

### 5.1 IP Health Summary

GET `/api/v1/admin/smtp/ips/health-summary?window=24h`

Returns aggregate health across all IPs/pools for internal dashboards.

### 5.2 Pool Reputation Overview

GET `/api/v1/admin/smtp/pools/reputation?window=7d`

Used by:

- Internal deliverability dashboards
- Executive cost

## 6. Error Handling

Uses the common error envelope from `../development-guidelines/api-reference.md`:

- 401 `AUTHENTICATION_REQUIRED`
- 403 `INSUFFICIENT_PERMISSIONS`
- 404 `RESOURCE_NOT_FOUND`
- 409 `RESOURCE_CONFLICT`
- 422 `VALIDATION_ERROR`
- 500+ for internal errors

Additional constraints:

- Never leak underlying provider secrets or raw error output.
- All sensitive failures log to internal monitoring + audit pipelines.

## 7. Security & Compliance

- TLS required.
- Strong RBAC and scoped tokens for machine-to-machine access.
- All write operations:
  - Logged in `admin_audit_log`
  - Eligible for periodic access review.
- No tenant-facing UIs or tokens may call these endpoints directly.

## 8. Relationship to Other APIs

- Tenant SMTP API:
  - Exposes safe tenant-scoped views only.
- Executive API:
  - Consumes aggregated data derived from central ops + BI views.
  - Never exposes raw IP assignment details.
- Queue & Events API:

  - Emits events (e.g., `smtp.ip.reputation_changed`, `smtp.pool.updated`) for downstream analytics and alerts.
