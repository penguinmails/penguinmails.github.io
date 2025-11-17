---
title: "API Reference - Complete Integration Guide"
description: "Lean, strategic API entrypoint plus links to dedicated REST API contracts (SMTP, Executive, Queue/Events, Core Platform) for the PenguinMails platform."
last_modified_date: "2025-11-10"
---

# API Reference - Complete Integration Guide

This document is the top-level navigation and standards guide for all PenguinMails APIs.

Use this file to understand:
- Strategic alignment and API surface ownership.
- Global authentication, REST/payload conventions, rate limiting, errors, and versioning.
- Where to find concrete REST contracts for each domain.

All endpoint-level details, SDK examples, language-specific integrations, and schema dumps are intentionally delegated to focused specifications.

---

## Strategic Alignment

PenguinMails APIs are designed as a coherent, infrastructure-aware platform:

- REST-only, HTTP/JSON contracts (no GraphQL) for official public and internal APIs.
- JS/TS-first orientation for SDKs and examples; other languages are supported via separate, focused docs.
- Clear separation of:
  - Tenant-facing APIs (product, marketing, analytics consumption).
  - Operational/administrative APIs (SMTP control, queue operations, observability).
  - Executive/BI APIs (C-suite dashboards, multi-tenant rollups, financial and performance views).
- Internally aligned with the five-tier data model (OLTP, OLAP, events, cache, archive) without leaking implementation details into public contracts.
- Consistent security, RBAC, auditability, and compliance posture across all domains.

This file is the canonical reference for cross-cutting rules that every PenguinMails API MUST follow.

---

## Document Hierarchy & Navigation

The API documentation follows a progressive disclosure model:

- Level 1 (this file):
  - Global standards, patterns, and navigation.
- Level 2 (domain REST contracts):
  - One focused spec per domain under `docs/implementation-technical/api/`.
- Level 3 (implementation details):
  - Service-specific guides, SDK docs, integration playbooks, testing strategies.

Authoritative domain contracts:

- Tenant SMTP API:
  - [`tenant-smtp-api`](../api/tenant-smtp-api)
- Central SMTP Operations API:
  - [`central-smtp-operations-api`](../api/central-smtp-operations-api)
- Queue & Events API:
  - [`queue-events-api`](../api/queue-events-api)
- Executive REST API (C-Suite Dashboards):
  - [`executive-api`](../api/executive-api)
- Core Product / Marketing / Webhooks / SDKs:
  - Defined and maintained in their own dedicated specs (e.g. `core-product-api.md`, `webhooks-api.md`, `sdk-guides.md`) separate from this entrypoint.

This hierarchy keeps `api-reference.md` lean and future-proof.

---

## Global Authentication

All PenguinMails REST APIs MUST:

- Require `Authorization: Bearer <token>` in headers (no API keys in query parameters).
- Be served exclusively over HTTPS.
- Define required scopes/roles per endpoint in their respective domain contracts.

Supported patterns (per product area):

- Service/API keys for machine-to-machine and backend integrations.
- JWT/OIDC-based tokens for authenticated users.
- Internal tokens for platform, observability, and administrative services.

This document defines expectations; concrete auth flows (issuance, rotation, SSO, etc.) live in:
- Security and identity implementation docs.
- Each domain's focused API contract where relevant.

---

## Global REST & Payload Conventions

All official PenguinMails API contracts MUST adhere to these conventions:

- RESTful resource design, typically under `/api/v1/...`.
- JSON request and response bodies.
- Consistent response envelopes.

Successful responses:

```json
{
  "success": true,
  "data": {},
  "meta": {}
}
```

Error responses:

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable description",
    "details": [],
    "request_id": "req_...",
    "documentation_url": "https://docs.penguinmails.com/api/errors#..."
  },
  "timestamp": "ISO8601"
}
```

Additional requirements:

- Explicitly document:
  - Idempotency expectations for write operations.
  - Pagination, filtering, and sorting conventions where applicable.
- Clearly distinguish:
  - Public tenant APIs vs. internal/ops-only endpoints.
  - Stable, externally supported contracts vs. internal implementation details.

Language- or framework-specific serialization rules belong in SDK and integration docs, not here.

---

## Rate Limiting (Global Policy)

All APIs SHOULD:

- Expose standardized rate limit headers when rate limiting is enforced:
  - `X-RateLimit-Limit`
  - `X-RateLimit-Remaining`
  - `X-RateLimit-Reset`
  - `X-RateLimit-Window`
- Define concrete plan- or endpoint-specific policies in their focused contract.

Clients MUST:

- Treat HTTP 429 as a first-class signal.
- Implement basic, configurable retry/backoff for transient failures.

Implementation code samples (e.g. retry handlers in JS/TS/Python) belong in:
- SDK documentation.
- Integration playbooks.
- Not in this high-level reference.

---

## Error Handling (Global Policy)

Common, reusable error codes:

- Authentication / Authorization:
  - `AUTHENTICATION_REQUIRED` (401)
  - `INSUFFICIENT_PERMISSIONS` (403)
- Validation:
  - `VALIDATION_ERROR` (400/422)
  - `MISSING_REQUIRED_FIELD`
- Rate Limits:
  - `RATE_LIMIT_EXCEEDED` (429)
- Resources:
  - `RESOURCE_NOT_FOUND` (404)
  - `RESOURCE_CONFLICT` (409)
- Server:
  - `INTERNAL_SERVER_ERROR` (500)
  - `SERVICE_UNAVAILABLE` (503)

Requirements:

- Each domain contract maps these codes to concrete scenarios.
- Error payloads MUST follow the global envelope defined above.
- Language-specific helpers/wrappers are documented in SDK guides, not here.

---

## Versioning

Versioning is URL-based and explicit:

- Current stable base: `/api/v1/`
- Future versions: `/api/v2/`, `/api/v3/`, etc.

Guidelines:

- Backwards-compatible changes (additive fields, new optional parameters) are preferred within a major version.
- Breaking changes:
  - Only introduced in new major versions.
  - Accompanied by:
    - Deprecation notices.
    - Clear migration guidance in each affected domain contract.
    - Sunset timelines communicated via documentation and, where appropriate, headers or webhooks.

---

## Where to Find Detailed Schemas & Examples

This file does NOT contain:

- Full campaign/contact/analytics schemas.
- Large SDK code samples.
- E-commerce, CRM, or Zapier integration blueprints.
- Test framework setups and sandbox scripts.

Instead, detailed artifacts are defined in:

- Domain API contracts:
  - `docs/implementation-technical/api/*.md`
- Analytics and events:
  - E.g. `posthog-business-events-specification.md` and related analytics docs.
- SDK and integration guides:
  - JS/TS SDK usage.
  - Shopify, Salesforce, Zapier, and other integrations.
  - Testing and sandbox environment guides.

Authors MUST add new details to the appropriate domain/SDK docs, not to this entrypoint.

---

## Best Practices (Global)

Recommended cross-cutting practices:

- Design to the official REST contracts:
  - Avoid coupling to internal schemas or inferred behavior.
- Prefer efficient usage patterns:
  - Use batch/bulk endpoints and async workflows where available.
  - Avoid chatty polling when webhooks or events exist.
- Optimize reliability:
  - Implement robust input validation at your boundary.
  - Use idempotency keys where provided for safely retrying writes.
  - Log and trace using `request_id` and correlation IDs.
- Protect security and trust:
  - Never expose API keys, secrets, or internal IDs in client-side code.
  - Do not leak raw third-party provider responses to tenants.
  - Align with RBAC and data minimization principles.

For domain-specific best practices:
- See each focused API contract and its associated implementation notes.

---

## Support & Resources

- Global API standards and navigation:
  - This `api-reference.md`.
- Domain REST contracts:
  - See `docs/implementation-technical/api/` for authoritative specifications.
- Deep-dive implementation (infra, BI, security, analytics, observability):
  - See relevant subfolders under `docs/implementation-technical/`.
- SDKs, integrations, and testing:
  - Use dedicated SDK guides, integration docs, and testing/sandbox references.
  - Keep this entrypoint free of large code samples to maintain clarity and durability.

This structure ensures `api-reference.md` remains a concise, maintainable entrypoint aligned with the REST-only, JS/TS-first, progressive documentation strategy.
---
