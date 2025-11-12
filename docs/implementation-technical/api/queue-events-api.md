---
title: "Queue & Events REST API Contract"
description: "REST API contract for enqueueing business events and accessing notifications, aligned with PostHog and queue architecture."
last_modified_date: "2025-11-10"
---

# Queue & Events REST API Contract

Level: Implementation-Ready  
Audience: Backend services, internal tools, (optionally) trusted frontend clients via gateway

This contract defines REST-only endpoints for:

- Emitting business/operational events into the queue/event pipeline.
- Exposing a safe, RBAC-enforced notifications feed for executives/admins.

It aligns with:

- `../analytics-integration/posthog-business-events-specification.md`
- `../database-infrastructure/queue-system-implementation-guide.md`
- `../database-infrastructure/notifications-mermaid-er.md`
- Backlog stories:
  - BF-003 (PostHog integration)
  - BF-005 (queue-backed alerts)
  - BF-006 (executive API layer)
  - Revenue/Cost/Operations epics consuming alerts

All endpoints are:

- REST-only, JSON
- Versioned: `/api/v1/...`
- Authenticated & authorized
- Transport-agnostic for underlying queue (no direct broker exposure)

---

## 1. Authentication & Authorization

- `Authorization: Bearer <token>`
- Event producers:
  - Internal services or trusted backends with scopes like:
    - `events:publish`
    - `alerts:publish`
- Notification consumers:
  - Authenticated users with roles:
    - Executive (C-level)
    - Ops / Deliverability
    - Support / Finance
- All writes and sensitive reads are auditable.

Error model: use shared envelope from `../development-guidelines/api-reference.md`.

---

## 2. Event Ingestion API

These endpoints accept normalized events and enqueue them for processing and fan-out to PostHog, OLAP, alerts, etc.

### 2.1 Publish Generic Business Event

POST `/api/v1/internal/events`

Body (schema aligned with PostHog business events spec, simplified example):

```json
{
  "type": "revenue_impact", 
  "source": "delivery_service",
  "tenant_id": "tn_123",
  "timestamp": "2025-11-10T12:00:00Z",
  "payload": {
    "impact_amount": -350.0,
    "impact_type": "deliverability_drop",
    "context": {
      "bounce_rate": 0.08,
      "previous_bounce_rate": 0.01
    },
    "severity": "high"
  }
}
```

Behavior:

- Validates `type` and `payload` against approved schemas:
  - `revenue_impact`, `cost_optimization`, `operational_efficiency`,
  - `strategic_decision`, `email_deliverability`, `resource_usage`, etc.
- On success:
  - Enqueues into internal queue (e.g. `business_events`).
  - Optionally forwards to PostHog asynchronously.

Response:

```json
{
  "success": true,
  "data": {
    "event_id": "evt_abc123",
    "queued": true
  }
}
```

Constraints:

- Internal-only by default; not a public endpoint.
- Rejects unknown `type` or malformed payloads with `VALIDATION_ERROR`.

### 2.2 Domain-Specific Event Endpoints (Optional Facades)

To simplify for producers, you MAY expose thin facades that map directly to canonical event schemas:

- POST `/api/v1/internal/events/revenue-impact`
- POST `/api/v1/internal/events/cost-optimization`
- POST `/api/v1/internal/events/deliverability`
- POST `/api/v1/internal/events/resource-usage`

Each:

- Accepts a typed payload (see PostHog spec).
- Validates & enqueues with correct internal routing keys.
- Uses same success/error envelope.

---

## 3. Notification Feed API (Executive/Admin)

Backed by notifications queue + OLTP/OLAP notifications tables.

### 3.1 List Notifications for Current User

GET `/api/v1/notifications?scope=exec&severity=critical,high&limit=50`

Query parameters:

- `scope` (optional):
  - `exec` (default for executives)
  - `ops`, `security`, etc. based on RBAC and product design.
- `severity` (optional): comma-separated `critical|high|medium|low`
- `status` (optional): `unread|read`
- `limit` / `cursor` for pagination.

Response:

```json
{
  "success": true,
  "data": [
    {
      "id": "ntf_123",
      "type": "revenue_risk",
      "severity": "critical",
      "title": "Bounce rate spike for key accounts",
      "summary": "Bounce rate exceeded 7% for 3 strategic tenants.",
      "created_at": "2025-11-10T12:05:00Z",
      "read": false,
      "actions": [
        {
          "label": "View details",
          "url": "/exec/revenue-protection?alert=ntf_123"
        }
      ]
    }
  ],
  "meta": {
    "next_cursor": null
  }
}
```

Rules:

- Results filtered by user’s roles and data access:
  - Executives see tenant-aggregated and platform-level alerts.
  - Ops may see more detailed, infra-focused alerts.
- Implementation reads from notifications store hydrated by queue workers.

### 3.2 Mark Notification as Read

POST `/api/v1/notifications/{id}/read`

Body (optional):

```json
{
  "read": true
}
```

Behavior:

- Marks notification as read for current user.
- Idempotent.

### 3.3 Bulk Acknowledge

POST `/api/v1/notifications/ack`

Body:

```json
{
  "ids": ["ntf_123", "ntf_456"]
}
```

Behavior:

- Marks multiple notifications as read.
- Enforces that user can only ack notifications they can see.

---

## 4. Alert/Event Semantics

This API does NOT define the full event semantics; instead it binds to canonical specs:

- All `type` values and payload shapes must align with:
  - `../analytics-integration/posthog-business-events-specification.md`
- Queue topology, DLQ behavior, retries:
  - See `../database-infrastructure/queue-system-implementation-guide.md`

This contract only guarantees:

- Stable REST endpoints for producers and consumers.
- Validation and enqueue semantics.
- Mapping to internal processing/alerting pipelines.

---

## 5. Error Handling

Standard envelope, with key codes:

- `AUTHENTICATION_REQUIRED` (401)
- `INSUFFICIENT_PERMISSIONS` (403)
- `VALIDATION_ERROR` (400/422) for bad event schemas
- `RESOURCE_NOT_FOUND` (404) for missing notification IDs
- `INTERNAL_SERVER_ERROR` (500) for unexpected failures

No raw broker/PostHog errors are exposed; they are normalized.

---

## 6. Security, Rate Limiting & Audit

- All endpoints require HTTPS.
- Event ingestion:
  - Rate limited per service/key to prevent abuse.
  - Auth scopes restrict who can publish system-level events.
- Notifications:
  - RBAC ensures users only see data within permitted scopes.
- Audit:
  - Critical actions (e.g., publishing high-severity alerts, changing notification routing configs if added later) must be logged with request_id, actor, payload fingerprint.

---

## 7. Relationship to Other APIs

- Tenant SMTP API:
  - Emits deliverability-related events → consumed here.
- Central SMTP Operations API:
  - Emits IP/pool/reputation events → routed via this API to alerts and analytics.
- Executive API:
  - Reads aggregated notifications and alert counts (not raw queue).
- Core Product APIs:
  - May emit events (e.g., campaign failures, high churn-risk signals) via this API for downstream processing.

This separation ensures:
- Producers and consumers use stable REST contracts.
- Queue and analytics internals remain encapsulated.