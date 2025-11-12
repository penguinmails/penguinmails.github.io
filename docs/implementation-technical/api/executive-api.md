---
title: "Executive REST API Contract"
description: "REST API contract for C-suite and internal executive dashboards, aggregating BI views, events, and audit logs across the 5-tier data architecture."
last_modified_date: "2025-11-10"
---

# Executive REST API Contract

Level: Implementation-Ready  
Audience: Backend engineers, analytics engineers, dashboard developers, security/compliance

This contract defines the REST-only API layer consumed by executive-facing dashboards and internal leadership tools.

It:

- Aggregates from:
  - OLAP/BI views (cost, revenue, risk, performance)
  - PostHog / business events (per `../analytics-integration/posthog-business-events-specification.md`)
  - Queue/notifications (per `./queue-events-api.md`)
  - Security/audit logs (per BF-004, `admin_audit_log`)
- Aligns with:
  - Story BF-006 (API Layer for Executive Dashboards)
  - BF-003, BF-004, BF-005, BF-007, BF-012 and related epics (Revenue Protection, Cost Optimization, Strategic Decision Support)
  - 5-tier architecture: OLTP → OLAP → events/queue → cache → archive
- Is:
  - Read-only for executive data surfaces
  - Strictly REST (no GraphQL)
  - Versioned under `/api/v1/exec/...`
  - Protected by strong RBAC + audit logging

This API NEVER:

- Exposes raw infra primitives (low-level IP mapping, provider secrets).
- Leaks cross-tenant data to unauthorized roles.
- Bypasses the documented data tier boundaries.

---

## 1. Authentication, RBAC & Audit

Headers:

```http
Authorization: Bearer <token>
Content-Type: application/json
```

Requirements:

- Exec roles (examples):
  - `ROLE_EXEC_CEO`, `ROLE_EXEC_CFO`, `ROLE_EXEC_COO`, `ROLE_EXEC_CTO`, `ROLE_EXEC_VP`
- Support/ops roles (limited):
  - `ROLE_SUPPORT_EXEC_READ`, `ROLE_ANALYTICS_READ`
- Enforcement:
  - Every endpoint declares required roles/scopes.
  - All access to sensitive aggregates (multi-tenant, audit, security) is:
    - Logged in `admin_audit_log` with actor, scope, filters, timestamp, request_id.
    - Subject to periodic access review.

Reference:

- [`business-leaders-database-migration-guide.md#step-5-security--access-control`](../database-infrastructure/business-leaders-database-migration-guide.md#step-5-security--access-control)
- Stories [`BF-004`](../../tasks/user-stories-framework/business-leaders-comprehensive-product-backlog.md:375) and [`BF-012`](../../tasks/user-stories-framework/business-leaders-comprehensive-product-backlog.md:909)

---

## 2. Response & Error Conventions

All responses use the shared envelope defined in [`api-reference.md`](../development-guidelines/api-reference.md):

Success:

```json
{
  "success": true,
  "data": { },
  "meta": { }
}
```

Error:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable",
    "details": [],
    "request_id": "req_...",
    "documentation_url": "https://docs.penguinmails.com/api/errors#..."
  },
  "timestamp": "ISO8601"
}
```

Key error codes:

- `AUTHENTICATION_REQUIRED`, `INSUFFICIENT_PERMISSIONS`
- `TENANT_SCOPE_MISMATCH`, `INVALID_FILTER`
- `RESOURCE_NOT_FOUND`
- `PARTIAL_DATA_UNAVAILABLE` (when some upstreams are degraded)
- `INTERNAL_SERVER_ERROR`

---

## 3. Endpoints

Note: These are contract-level examples selected to match BF-006 and related stories. Implementation MAY add more endpoints following the same patterns.

### 3.1 Executive Overview

GET `/api/v1/exec/overview`

Purpose:

- Single entrypoint for top-level executive dashboards.

Data (example):

```json
{
  "success": true,
  "data": {
    "timeframe": "last_24h",
    "revenue_protection": {
      "estimated_protected_revenue": 120000.0,
      "active_alerts": 3
    },
    "cost_optimization": {
      "approx_infra_cost": 18500.0,
      "savings_opportunities": 4
    },
    "deliverability": {
      "global_delivery_rate": 0.986,
      "critical_issues": 1
    },
    "operations": {
      "uptime_rolling_30d": 0.9992,
      "incidents_open": 1
    },
    "risk_compliance": {
      "open_risks": 0,
      "last_audit_passed_at": "2025-11-01T00:00:00Z"
    }
  }
}
```

Sources:

- Pre-aggregated OLAP views (per migration guide).
- Event-derived metrics via BI service.

Roles:

- Exec + certain ops roles.

---

### 3.2 Tenant Summary (Exec/Internal)

GET `/api/v1/exec/tenants/{tenantId}/summary`

Purpose:

- Deep-dive view for a single strategic tenant.

Example response:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "profile": {
      "name": "Acme Corp",
      "plan": "enterprise",
      "lifecycle_stage": "customer"
    },
    "volume": {
      "sent_30d": 125000,
      "delivered_30d": 123000
    },
    "deliverability": {
      "delivery_rate_30d": 0.984,
      "bounce_rate_30d": 0.012,
      "complaint_rate_30d": 0.0008,
      "reputation_band": "good"
    },
    "approximate_infra_cost_signals": {
      "vps_cost_band": "medium",
      "smtp_ip_cost_band": "low"
    },
    "alerts": {
      "open": 1,
      "recent": [
        {
          "id": "ntf_abc",
          "type": "revenue_risk",
          "severity": "high",
          "title": "Bounce spike on key campaign"
        }
      ]
    }
  }
}
```

Rules:

- Uses only internal approximation fields for cost; clearly non-authoritative.
- Exec roles only; support roles as configured.
- No raw IP mappings or other tenants’ data.

---

### 3.3 Revenue Protection View

GET `/api/v1/exec/revenue-protection?window=7d`

Returns:

- Aggregated revenue impact/risk metrics across tenants.
- Top incidents, trends, and risk scores.

Example:

```json
{
  "success": true,
  "data": {
    "window": "7d",
    "estimated_at_risk": 85000.0,
    "protected_amount": 42000.0,
    "top_risks": [
      {
        "tenant_id": "tn_123",
        "name": "Acme Corp",
        "issue": "High bounce on onboarding campaigns",
        "estimated_impact": 15000.0
      }
    ]
  }
}
```

Source:

- `revenue_impact_event` and related aggregates (PostHog/BI).

---

### 3.4 Cost Optimization View

GET `/api/v1/exec/cost-optimization?window=30d`

Purpose:

- Support CO-001+ stories with infra and vendor cost signals.

Example:

```json
{
  "success": true,
  "data": {
    "window": "30d",
    "infra_cost_estimate": 30000.0,
    "savings_opportunities": [
      {
        "id": "opt_1",
        "type": "smtp_pool_consolidation",
        "estimated_savings": 4000.0,
        "confidence": 0.8
      }
    ]
  }
}
```

Rules:

- Uses approximation fields; not financial source of truth.
- Exec finance/ops roles only.

---

### 3.5 Notifications Summary

GET `/api/v1/exec/notifications/summary`

Purpose:

- Lightweight counts for dashboard badges.

Response:

```json
{
  "success": true,
  "data": {
    "unread_critical": 2,
    "unread_high": 5,
    "unread_total": 12
  }
}
```

Source:

- Notification store per `./queue-events-api.md`.

---

### 3.6 Executive Audit Log (Read-Only, Filtered)

GET `/api/v1/exec/audit-log?scope=exec&limit=100&cursor=...`

Purpose:

- Provide compliance-grade visibility into exec-scope events.

Behavior:

- Returns only:
  - Events relevant to executive-level actions/views.
  - Filtered by the caller’s roles and organization scope.

Example:

```json
{
  "success": true,
  "data": [
    {
      "id": "aud_123",
      "timestamp": "2025-11-10T12:00:00Z",
      "actor_user_id": "usr_admin",
      "actor_role": "ROLE_EXEC_CFO",
      "action_type": "VIEW_EXEC_DASHBOARD",
      "target_scope": "global",
      "metadata": {
        "ip": "203.0.113.5",
        "user_agent": "Chrome/120"
      }
    }
  ],
  "meta": {
    "next_cursor": null
  }
}
```

Constraints:

- High-sensitivity endpoint:
  - Strong RBAC.
  - Full audit of access to audit data (meta-audit).

---

## 4. Performance & Degradation

Targets:

- p95 < 200ms for main GET endpoints under normal load.
- Achieved via:
  - OLAP/BI pre-aggregations
  - Caching layers
  - No heavy joins across hot OLTP paths.

Degradation rules:

- If a dependent upstream is slow/unavailable:
  - Prefer returning partial data with:
    - `meta.partial: true`
    - `meta.degraded_sources: ["posthog", "olap"]`
  - Never fabricate values.
  - Maintain consistent schema to keep dashboards resilient.

Example degraded response:

```json
{
  "success": true,
  "data": { "/* subset of fields */": true },
  "meta": {
    "partial": true,
    "degraded_sources": ["posthog"]
  }
}
```

---

## 5. Security & Compliance

This API is part of the executive security surface (BF-004, BF-012):

- All endpoints:
  - Require HTTPS.
  - Use secure tokens; no public API keys.
  - Enforce strict role checks; deny-by-default.
- Sensitive operations:
  - Access to multi-tenant aggregates, audit-log views, or risk dashboards:
    - Must be logged in `admin_audit_log`.
- No PII leakage:
  - Aggregate or masked where possible.
  - Tenant or user-level pivots only where role-scoped.

---

## 6. Relationship to Other API Contracts

- Tenant SMTP API (`tenant-smtp-api.md`):
  - Source of tenant-scoped SMTP status used indirectly for exec visuals.
- Central SMTP Operations API (`central-smtp-operations-api.md`):
  - Internal infra management; exec API consumes only summarized outputs.
- Queue & Events API (`queue-events-api.md`):
  - Feeds notifications and event streams that underpin exec alerts.
- Core Product APIs:
  - Campaign/engagement metrics flow into BI/OLAP; exec API consumes pre-aggregates, not raw transactional endpoints.

This separation ensures:

- Executive dashboards use a single, hardened REST layer.
- Infrastructure and queue internals remain encapsulated.
- Behavior stays consistent with the Business Leaders backlog and 5-tier architecture.