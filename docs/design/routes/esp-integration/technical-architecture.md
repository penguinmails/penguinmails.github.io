---
title: "ESP Route Infrastructure"
description: "Technical specifications for ESP configuration routes, including related APIs, data strategy, and component architecture."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# ESP Route Infrastructure

## 5. Related API Endpoints

| Route | Related API | Description |
|---|---|---|
| `/settings/integrations/esp` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `GET /api/v1/tenant/esp/providers` (List configured ESPs). |
| `/settings/integrations/esp/postmark` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `POST /api/v1/tenant/esp/postmark` (Configure Postmark). |
| `/settings/integrations/esp/mailgun` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `POST /api/v1/tenant/esp/mailgun` (Configure Mailgun). |
| `/settings/integrations/esp/routing` | [ESP API](/docs/implementation-technical/api/tenant-api/esp-config) | `PUT /api/v1/tenant/esp/routing` (Update routing rules). |
| `/settings/integrations/esp/webhooks` | [Webhook API](/docs/implementation-technical/api/platform-api/webhooks) | `POST /webhooks/postmark`, `POST /webhooks/mailgun` (Receive events). |
| `/settings/integrations/esp/analytics` | [Analytics API](/docs/implementation-technical/api/tenant-api/analytics) | `GET /api/v1/tenant/analytics/esp` (ESP performance metrics). |

## 6. Data Strategy

- **Fetching Method**:
  - **ESP List**: Server Component (cached for 5 minutes).
  - **Configuration**: Server Component with real-time validation.
  - **Analytics**: Client Component with SWR for real-time updates.
- **Caching**:
  - **Provider Status**: Cached for 5 minutes.
  - **Analytics**: Cached for 15 minutes.
  - **Webhook Logs**: No caching (real-time).
- **Security**:
  - **API Keys**: Encrypted at rest, never exposed to client.
  - **Webhook Signatures**: Verified on every request.
  - **Admin Only**: All ESP routes require admin role.

## 7. Edge Cases & Error Handling

- **Invalid API Key**: Show "Invalid API key. Please check your credentials and try again."
- **Domain Not Verified**: Block sending until domain verified. Show "Domain verification required. [View DNS records →]"
- **ESP Service Down**: Show "Unable to connect to [Provider]. Using fallback provider."
- **Webhook Signature Mismatch**: Log security warning, reject webhook, alert admin.
- **Rate Limit Exceeded**: Show "ESP rate limit reached. Emails queued for retry."
- **Routing Conflict**: Warn if multiple rules match same email type. "Rule priority determines which ESP is used."

## 8. Component Architecture

### Page Components

- **`ESPOverview`** (Server)
  - Features: Provider cards, quick stats, routing summary.
- **`PostmarkConfig`** (Client)
  - Features: API token input, domain verification, test email.
- **`MailgunConfig`** (Client)
  - Features: API key input, region selection, email validation.
- **`RoutingBuilder`** (Client)
  - Features: Drag-and-drop rules, visual routing diagram.
- **`WebhookLogs`** (Client)
  - Features: Real-time event stream, filtering, export.
- **`ESPAnalytics`** (Client)
  - Features: Interactive charts, provider comparison, cost analysis.

### Shared Components

- **`ProviderCard`**: Reused across ESP overview and analytics.
- **`ConnectionTest`**: Reused in Postmark and Mailgun config.
- **`DeliverabilityChart`**: Reused in analytics and campaign views.

## 9. Related Documentation

### Feature Documentation

- **[ESP Integration](/docs/features/integrations/esp-integration)** - Complete ESP integration guide
- **[Webhook System](/docs/features/integrations/webhook-system)** - Webhook configuration and events
- **[Email Infrastructure](/docs/features/infrastructure/email-infrastructure-setup)** - SMTP and infrastructure setup

### Technical Documentation

- **[ESP API Reference](/docs/implementation-technical/api/tenant-api/esp-config)** - API endpoints for ESP configuration
- **[Webhook API Reference](/docs/implementation-technical/api/platform-api/webhooks)** - Webhook endpoint specifications
- **[Analytics API Reference](/docs/implementation-technical/api/tenant-api/analytics)** - ESP analytics endpoints

### User Journeys

- **Operations Team Journey** - ESP setup and monitoring workflows (internal journey reference)
- **Developer Journey** - API integration and webhook setup (internal journey reference)
