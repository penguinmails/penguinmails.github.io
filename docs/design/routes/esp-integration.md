---
title: "ESP Integration Routes"
description: "Route specifications for External Email Service Provider (ESP) configuration and management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers, Operations Teams"
---

# ESP Integration Routes

## 1. Purpose & Context (The "Why")

- **Goal**: Configure and manage external Email Service Provider (ESP) integrations for enhanced deliverability.
- **Feature References**:
  - [ESP Integration](/docs/features/integrations/esp-integration)
  - [Email Infrastructure](/docs/features/infrastructure/email-infrastructure-setup)
- **User Journey**: Occasional access during initial setup and when adding new ESPs.

## 2. UI Patterns & Components (The "How")

- **Core Components**:
  - `Form`: Configuration forms with validation.
  - `ConnectionTest`: Test ESP connection with real-time feedback.
  - `ProviderCard`: Visual card for each ESP with status indicators.
  - `RoutingRulesBuilder`: Drag-and-drop interface for email routing logic.
  - `WebhookEndpoint`: Display webhook URLs with copy button.
  - `DeliverabilityChart`: Comparative analytics across providers.
- **Analytics Patterns**: Provider performance comparison, delivery metrics.
- **Layout**: Settings Layout with sidebar navigation.

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/settings/integrations/esp` | Admin | ESP Overview | List of configured ESPs with status, quick actions. |
| `/dashboard/settings/integrations/esp/postmark` | Admin | Postmark Config | Form: API Token, Default Sender, Tracking Options. |
| `/dashboard/settings/integrations/esp/mailgun` | Admin | Mailgun Config | Form: API Key, Domain, Region, Tracking Options. |
| `/dashboard/settings/integrations/esp/routing` | Admin | Routing Rules | Visual builder for email type → ESP mapping. |
| `/dashboard/settings/integrations/esp/webhooks` | Admin | Webhook Config | Webhook URLs, event subscriptions, delivery logs. |
| `/dashboard/settings/integrations/esp/analytics` | Admin | ESP Analytics | Comparative deliverability metrics across providers. |

## 4. Detailed View Descriptions

Explore the detailed specifications for each ESP integration route:

- **[ESP Provider Configuration](/docs/design/routes/esp-integration/provider-config)**: Postmark and Mailgun configuration details.
- **[ESP Routing & Failover Strategies](/docs/design/routes/esp-integration/routing-failover)**: Visual routing rules, failover, and cost optimization.
- **[ESP Webhooks & Analytics](/docs/design/routes/esp-integration/webhooks-analytics)**: Real-time event webhooks and performance analytics.
- **[ESP Route Infrastructure](/docs/design/routes/esp-integration/technical-architecture)**: API endpoints, data strategy, and component architecture.

---

## Strategic Impact

By providing a comprehensive set of routes for ESP management, PenguinMails enables administrators to optimize their email delivery infrastructure, ensuring high deliverability while managing costs effectively through intelligent routing and failover strategies.

---

## Related Documentation

- [ESP Integration Overview](/docs/features/integrations/esp-integration)
- [Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)
- [Webhook System](/docs/features/integrations/webhook-system)
- [Analytics Strategy](/docs/features/analytics/core-analytics/overview)
