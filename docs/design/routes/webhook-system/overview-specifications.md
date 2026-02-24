---
title: "Webhook System - Overview & Specifications"
description: "Route specifications for custom webhook configuration and event management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook System - Overview & Specifications

## 1. Overview

The Webhook System provides a self-service management interface for developers to register endpoints, subscribe to real-time events, and monitor delivery status.

### Objectives

- **Self-Service Configuration**: Allow users to create and manage webhooks without support tickets.
- **Event Granularity**: Subscription to specific events (email.sent, email.opened, etc.).
- **Security Visibility**: Management of secret keys and signature verification settings.
- **Delivery Monitoring**: Real-time log of deliveries with request/response visibility.
- **Testing Tools**: Sandbox environment for testing endpoints with sample or real data.

## 2. Design Foundations

- **Analytics Patterns**: Delivery success rate, response times, error analysis.
- **Layout**: Settings Layout with sidebar navigation.

## 3. Route Specifications

| Route | Access | Purpose | State/Data Requirements |
|---|---|---|---|
| `/dashboard/settings/webhooks` | Admin, Developer | Webhook Overview | List of webhooks, quick stats, create button. |
| `/dashboard/settings/webhooks/create` | Admin, Developer | Create Webhook | Form: Name, URL, Events, Filters. |
| `/dashboard/settings/webhooks/[webhook_id]` | Admin, Developer | Webhook Details | Stats, config, recent logs, controls. |
| `/dashboard/settings/webhooks/[webhook_id]/edit` | Admin, Developer | Edit Webhook | Prefilled form with current config. |
| `/dashboard/settings/webhooks/[webhook_id]/test` | Admin, Developer | Test Webhook | Payload preview and manual trigger. |
| `/dashboard/settings/webhooks/[webhook_id]/logs` | Admin, Developer | Delivery Logs | Filterable history of all deliveries. |

## 4. Related Documentation

- [Webhook System Overview](/docs/features/integrations/webhook-system)
- [Event Reference](/docs/features/integrations/webhook-system#event-reference)
