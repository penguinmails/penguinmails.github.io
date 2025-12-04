---
title: "API Access"
description: "RESTful API access, authentication, and rate limiting"
last_modified_date: "2025-11-24"
level: "3"
persona: "Developers"
status: "ACTIVE"
category: "Integrations"
---

# API Access

## Programmatic access to PenguinMails features via a RESTful API

---

## Overview

The PenguinMails API allows developers to integrate email capabilities directly into their applications. Everything you can do in the dashboard, you can do via the API.

**Base URL:** `https://api.penguinmails.com/v1`

### Key Capabilities

- **Send Emails** - Transactional and bulk sending

- **Manage Contacts** - Sync leads from your CRM

- **Retrieve Analytics** - Pull reports into your dashboard

- **Webhooks** - Real-time event notifications

---

## Authentication

We use **Bearer Token** authentication.

1. Generate an API Key in **Settings â†’ API Keys**.

2. Include it in the `Authorization` header.

```bash
curl -X GET https://api.penguinmails.com/v1/campaigns \
  -H "Authorization: Bearer pm_live_12345..."
```

---

## Rate Limiting

Limits are applied per tenant based on your subscription plan.

| Plan | Rate Limit | Burst |
|------|------------|-------|
| **Starter** | 60 req/min | 100 |
| **Professional** | 300 req/min | 500 |
| **Business** | 1000 req/min | 2000 |

## Headers

- `X-RateLimit-Limit`: Total requests allowed

- `X-RateLimit-Remaining`: Requests left in window

- `X-RateLimit-Reset`: Time until reset

---

## Core Endpoints

### Emails

## Send a single email

```json
POST /emails/send
{
  "to": "user@example.com",
  "template_id": "welcome-v1",
  "variables": { "name": "Alice" }
}
```

### Contacts

## Add or update a contact

```json
POST /contacts
{
  "email": "lead@example.com",
  "attributes": { "source": "signup_form" }
}
```

### Campaigns

## List campaigns

```http
GET /campaigns?status=sent&limit=10
```

---

## SDKs & Libraries

Official client libraries are coming soon:

- Node.js (Q1 2026)

- Python (Q1 2026)

- PHP (Q2 2026)

---

## Related Documentation

### Route Specifications

- **[API Access Routes](/docs/design/routes/api-access)** - API key management UI routes

- **[API Key Management Routes](/docs/design/routes/api-key-management)** - Detailed API key interface

- **[Webhook System Routes](/docs/design/routes/webhook-system)** - Webhook configuration routes

### Feature Documentation

- **[Vault API Keys](/docs/features/integrations/vault-api-keys/overview)** - Secure API key system with Vault

- **[Webhook System](/docs/features/integrations/webhook-system)** - Real-time event notifications

- **[ESP Integration](/docs/features/integrations/esp-integration)** - External ESP configuration

### API Documentation

- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Platform-level endpoints

- **[Tenant API](/docs/implementation-technical/api/tenant-api)** - Tenant-level endpoints

### Architecture & Security

- **[Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture)** - Secrets management architecture

- **[Enterprise Security](/docs/compliance-security/enterprise/overview)** - Security features

### Implementation

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations)** - Integration completeness review

- **[Task 11.6 - Tenant API Key System](/.kiro/specs/feature-completeness-review/tasks#116-implement-tenant-api-key-system-with-vault)** - Implementation task

---

**Last Updated:** November 24, 2025
**Version:** v1

*Build powerful email integrations with the PenguinMails API.*
