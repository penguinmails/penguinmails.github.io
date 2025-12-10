---
title: "Integrations Roadmap"
description: "Roadmap for API, webhooks, and third-party integrations"
last_modified_date: "2025-12-09"
level: "2"
persona: "Product Teams, Developers"
parent: "/docs/roadmap/product/README.md"
---

# Integrations Roadmap

## Overview

This roadmap outlines the development timeline for integration features, following an API-first approach.

**MVP Completion:** Q1 2026
**Post-MVP Timeline:** Q1 2026 - Q4 2026

## MVP Roadmap Items (Q1 2026)

### Critical Blockers (P0)

* **[API Key Management System](api-key-management.md)** (P0): Backend for API key generation and validation.
* **[API Key Management UI](api-key-ui.md)** (P0): Frontend for managing API keys.
* **[Core REST API Endpoints](core-api-endpoints.md)** (P0): Endpoints for contacts, campaigns, and analytics.
* **[API Documentation](api-documentation.md)** (P0): OpenAPI/Swagger documentation.
* **[Vault Integration Architecture](vault-architecture.md)** (P0): Secrets management foundation.

### High Priority (P1)

* **[Webhook System (Backend)](webhook-system.md)** (P1): Delivery engine with retry logic.
* **[Webhook Configuration UI](webhook-ui.md)** (P1): Frontend for webhook setup.
* **[VPS SSH Key Management](vps-ssh-keys.md)** (P1): Secure storage and rotation of SSH keys.
* **[SMTP Credentials Vault Storage](smtp-credentials-vault.md)** (P1): Secure storage for SMTP credentials.
* **[Vault Disaster Recovery](vault-disaster-recovery.md)** (P1): Backup and recovery for secrets.

## Post-MVP Roadmap (Q1 2026 - Q4 2026)

### Q1 2026: CRM Integrations

* **[Salesforce Integration](salesforce-integration.md)** (P2): Bi-directional sync with Salesforce.
* **[HubSpot Integration](hubspot-integration.md)** (P2): Bi-directional sync with HubSpot.

### Q2 2026: No-Code

* **[Zapier Integration](zapier-integration.md)** (P2): Zapier app for no-code workflows.

### Q3 2026: Advanced Features

* **[ESP Integration Settings UI](esp-integration-ui.md)** (P1): UI for configuring external ESPs.
* **[Advanced Webhook Configuration](advanced-webhooks.md)** (P3): Custom filtering and transformation.

### Q4 2026: Ecosystem

* **[Developer Portal & Marketplace](developer-marketplace.md)** (P3): Public marketplace for integrations.
* **[Real-Time Sync](real-time-sync.md)** (P3): Sub-1-minute sync latency.
