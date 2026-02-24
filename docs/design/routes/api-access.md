---
title: "API Access Hub"
description: "Route specifications for API key management, developer tools, and usage monitoring."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# API Access Routes

**Programmatic control center for managing keys, exploring documentation, and monitoring integration health.**

This hub centralizes the developer experience within the PenguinMails dashboard.

---

## Dashboard Modules

Explore the following routes and UI components:

### 1. [Key Management UI](/docs/design/routes/api-access/key-management-ui)

Creating and revoking API keys, managing permission matrices, and configuring IP allowlists.

### 2. [Interactive Documentation](/docs/design/routes/api-access/interactive-docs-ui)

Integrated API browser, live tester interface, and dynamic code generators.

### 3. [Usage Analytics & Monitoring](/docs/design/routes/api-access/usage-analytics-ui)

Real-time volume tracking, error distribution analysis, and rate limit status monitoring.

---

## Route Map

| Route | Purpose |
|-------|---------|
| `/dashboard/settings/developers` | Overview & Rate Limit Status |
| `/dashboard/settings/developers/keys` | Full API Key Lifecycle Management |
| `/dashboard/settings/developers/docs` | Interactive API Reference |
| `/dashboard/settings/developers/usage` | Detailed Integration Analytics |

---

## Related Documentation

- **[API Platform Overview](/docs/features/integrations/api-access)** - Feature summary and business context.
- **[Webhook Configuration](/dashboard/settings/integrations/esp/webhooks)** - Event delivery settings.
- **[Technical API Reference](/docs/implementation-technical/api/README)** - Backend documentation and OpenAPI specs.

---

**Last Updated:** February 24, 2026
**API Version:** v1
**Owner:** Developers Team
