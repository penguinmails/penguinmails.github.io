---
title: "Integrations Roadmap"
description: "Future roadmap for REST APIs, webhooks, and third-party vendor integrations."
last_modified_date: "2025-12-09"
level: "2"
persona: "Developers, Product, Partners"
---

## Feature Roadmap: Integrations

### MVP Implementation (Q1 2026)

* **[P0] API Key Management System** (1-2 weeks)
  * API key generation and Vault storage
  * Rate limiting and usage tracking
  * **Business Impact:** Enables all programmatic integrations.
* **[P0] Core REST API Endpoints** (2-3 weeks)
  * Contacts, Campaigns, Emails, and Analytics APIs
  * Standard REST conventions
  * **Business Impact:** Core integration functionality.
* **[P1] Webhook System Backend** (1-2 weeks)
  * Event delivery engine with queue-based processing
  * HMAC-SHA256 signature verification
  * **Business Impact:** Real-time integrations.

### Post-MVP Roadmap (Q1-Q4 2026)

* **[P2] CRM Integrations (Salesforce & HubSpot)** (Q1 2026)
  * OAuth 2.0 authentication flow
  * Bi-directional contact/lead sync
  * Activity logging (emails, opens, clicks)
  * **Business Impact:** Unlocks enterprise and mid-market customers.
* **[P2] Zapier Integration** (Q2 2026)
  * Zapier app setup with triggers and actions
  * **Business Impact:** Expands ecosystem to 5,000+ apps.
* **[P3] Integration Marketplace** (Q4 2026+)
  * Developer portal for third-party integrations
  * **Business Impact:** Community-driven ecosystem.

---

### Vault Integration Timeline

* **[P0] Vault Integration Architecture** - Foundation (Q1 2026)
* **[P1] VPS SSH Key Management** - Secret storage (Q1 2026)
* **[P1] SMTP Credentials Vault Storage** - Email security (Q1 2026)

---

### Success Metrics

* API response time < 200ms (p95)
* Webhook delivery success rate > 95%
* 50+ developers using API within first month
* 50+ customers using Zapier integration
