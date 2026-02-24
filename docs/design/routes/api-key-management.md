---
title: "API Key Management Routes"
description: "Frontend route specifications for tenant API key creation, viewing, regeneration, and revocation with Vault integration"
last_modified_date: "2026-02-24"
level: "2"
persona: "Frontend Developers, Technical Teams"
keywords: ["routes", "API keys", "Vault", "authentication", "UI", "frontend"]
status: "PLANNED"
priority: "P0 - Critical"
---

# API Key Management Routes

API Key Management enables tenants to create and manage programmatic access to PenguinMails services securely. This interface integrates with Vault for secure key storage and provides self-service management tools.

## Implementation Modules

Explore the following modules for detailed route specifications and technical requirements:

### 1. [API Key Listing & Details](/docs/design/routes/api-key-management/listing-and-details)

Specifications for the API key table, masked key views, and detailed usage analytics per key.

### 2. [API Key Management Actions](/docs/design/routes/api-key-management/creation-and-actions)

Workflows and UI specifications for creating new keys, secret revelation patterns, and regeneration/revocation flows.

### 3. [API Key Technical Specifications](/docs/design/routes/api-key-management/technical-specification)

State management logic, API error handling, security considerations for clipboard/display, and accessibility standards.

---

## Routes Summary

| Route | Purpose | Authentication |
|-------|---------|----------------|
| `/dashboard/settings/developers/api-keys` | API key list and management | Required |
| `/dashboard/settings/developers/api-keys/create` | Create new API key modal | Required |
| `/dashboard/settings/developers/api-keys/{key_id}` | View API key details modal | Required |

---

## Strategic Design Principles

- **Security First**: Plaintext keys are shown exactly once during creation.
- **Auditability**: Every key includes usage tracking and last-used timestamps.
- **Self-Service**: Users can independently manage, rotate, or revoke keys as needed.

---

## Related Documentation

- [Feature Documentation - Tenant API Key System](/docs/features/integrations/vault-api-keys/overview)
- [Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture)
- [Frontend Routing Map](/docs/design/frontend-routing-map) - Master route registry

---
**Last Updated**: 2026-02-24
**Status**: PLANNED
**Priority**: P0 - Critical
