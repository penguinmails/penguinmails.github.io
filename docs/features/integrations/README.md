---
title: "Integrations"
description: "Third-party system connections including CRM, webhooks, and external platforms"
last_modified_date: "2025-12-02"
level: "2"
persona: "Documentation Users"
---

# 🔌 Integrations

Third-party system connections including CRM, webhooks, and external platforms.

**[📖 Read Full Integrations Overview](./overview.md)** - Comprehensive guide to PenguinMails integration capabilities including API-first strategy, Vault secrets management, and implementation roadmap.

## MVP Status: API-First Approach

**Strategy**: Build general-purpose REST API + webhooks first (MVP), add vendor-specific integrations later (Post-MVP)

**Current State**: Foundation features documented, implementation in progress

**MVP Focus (Q1 2026)**:

- ✅ API Key Management System with Vault storage

- ✅ Core REST API endpoints (contacts, campaigns, emails, analytics)

- ✅ Webhook system for real-time event notifications

- ✅ API documentation (OpenAPI/Swagger)

**Post-MVP (Q1-Q2 2026)**:

- Salesforce/HubSpot CRM integrations (Q1 2026)

- Zapier integration for 5,000+ apps (Q2 2026)

- ESP integration UI (Q3 2026)

**Rationale**: API-first approach enables customers to build custom integrations immediately while we develop pre-built vendor integrations on top of stable API foundation.

## Features in This Category

### ⏳ In Development (MVP - Q1 2026)

- **[API Key Management](./vault-api-keys.md)** - Secure API key generation, Vault storage, permission scopes, rate limiting (P0 - Critical)

- **[REST API Endpoints](./api-access.md)** - Core API for contacts, campaigns, emails, analytics with OpenAPI documentation (P0 - Critical)

- **[Webhook System](./webhook-system.md)** - Real-time event notifications with retry logic and signature verification (P1 - High)

### ✅ Available Now

- **[API Access Documentation](./api-access.md)** - RESTful API specification for custom integrations

- **[Vault API Keys Documentation](./vault-api-keys.md)** - Secure API key management architecture with Vault storage and bcrypt hashing

- **[ESP Integration](./esp-integration.md)** - External email service providers (Postmark, Mailgun) - Active integrations

- **[Webhook System Documentation](./webhook-system.md)** - Real-time event notification architecture

### 🔜 Coming Soon (Post-MVP)

- **[CRM Integration](./crm-integration/overview.md)** - Salesforce and HubSpot bi-directional sync (Q1 2026)

- **Zapier Integration** - Connect with 5,000+ apps via no-code automation (Q2 2026)

- **ESP Integration UI** - User interface for Postmark/Mailgun configuration (Q3 2026)

- **Custom Webhook Builder** - Advanced filtering and conditional logic (Q3 2026)

- **Additional CRM Integrations** - Pipedrive, Zoho, Close.io (Q2-Q3 2026)

## Missing Features & Roadmap

### MVP Gaps (Q1 2026)

## Critical (P0) - Blocks programmatic integrations

1. **API Key Management UI** (5-7 days) - Self-service API key creation, viewing, regeneration, revocation

2. **Core REST API Implementation** (2-3 weeks) - Contacts, campaigns, emails, analytics endpoints

3. **API Documentation** (1 week) - OpenAPI/Swagger with interactive explorer and code examples

## High Priority (P1) - Enables real-time integrations

1. **Webhook System Backend** (1-2 weeks) - Event delivery engine with retry logic and signature verification

2. **Webhook Configuration UI** (1-2 weeks) - Self-service webhook setup with event selection and testing

**Total MVP Effort**: 6-9 weeks

### Post-MVP Roadmap

### Q1 2026: Advanced CRM Integrat

- Salesforce integration with OAuth and bi-directional sync (20-30 days)

- HubSpot integration with field mapping and workflow triggers (20-30 days)

### Q2 2026: No-Code Integrations

- Zapier integration for 5,000+ apps (2-3 weeks)

- Pre-built Zaps for common workflows

### Q3 2026: Enhanced Features

- ESP Integration UI for Postmark/Mailgun configuration (10-14 days)

- Custom Webhook Builder with advanced filtering (3-4 weeks)

- Additional CRM integrations (Pipedrive, Zoho, Close.io)

## Q4 2026+: Ecosystem Expansion

- Integration Marketplace for third-party developers (8-12 weeks)

- Real-Time Sync with sub-1-minute latency (6-8 weeks)

**Detailed Roadmap**: [Integrations Roadmap](./roadmap.md)

## Vault Integration & Secrets Management

**Status**: ✅ Fully Documented - Architecture and implementation workflows defined

PenguinMails uses HashiCorp Vault for centralized secrets management, providing enhanced security, automated rotation, and disaster recovery capabilities.

**Key Features**:

- **VPS SSH Key Management**: Admin and tenant SSH keys stored in Vault with 90-day rotation

- **SMTP Credentials Storage**: MailU admin credentials encrypted and stored in Vault with 180-day rotation

- **Tenant API Key System**: API keys hashed with bcrypt and stored in Vault with on-demand rotation

- **Disaster Recovery**: Automated daily backups enable rapid recovery from VPS compromise or Vault failure

**Documentation**:

- [Vault Integration Architecture](../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)

- [VPS SSH Key Management](../infrastructure/vault-ssh-management.md)

- [SMTP Credentials Storage](../infrastructure/vault-smtp-credentials.md)

- [Tenant API Keys](./vault-api-keys.md)

- [Disaster Recovery Procedures](../infrastructure/vault-disaster-recovery.md)

## Third-Party Dependencies

**Critical Services (P0)**:

- **HashiCorp Vault** - Secrets management (HCP Vault: $22/month MVP, self-hosted Post-MVP)

- **Stripe** - Payment processing (2.9% + $0.30 per transaction, no migration planned)

- **Hostwind API** - VPS provisioning ($5-50/month per VPS, add alternatives Q2 2026)

**Active Integrations**:

- **Postmark** - Transactional email delivery ($1.25 per 1,000 emails)

- **Mailgun** - Bulk marketing email delivery ($35/month + $1/1,000 emails)

- **Loop.so** - Transactional email service ($29/month, migrate to MailU Q3 2026)

**Planned Integrations (Post-MVP)**:

- **Salesforce** - CRM integration (Q1 2026)

- **HubSpot** - CRM integration (Q1 2026)

- **Zapier** - 5,000+ app connections (Q2 2026)

**Detailed Analysis**: [Third-Party Dependencies Report](../../.kiro/specs/feature-completeness-review/findings/integrations-third-party-dependencies.md)

## Cross-References

**Related Features**:

- [Authentication & Security](../enterprise/user-management.md) - API key authentication, OAuth flows

- [Infrastructure Management](../infrastructure/README.md) - VPS provisioning, SSH key management, SMTP setup

- [Domain Management](../domains/README.md) - DKIM key storage in Vault

- [Email Operations](../campaigns/README.md) - Campaign API endpoints, webhook events

**Implementation**:

- [API Documentation](../../implementation-technical/api/README.md) - Technical API specifications

- [Vault Architecture](../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md) - Secrets management architecture

**Business Strategy**:

- [Integration Strategy](../../.kiro/specs/feature-completeness-review/findings/integration-strategy.md) - API-first approach rationale

- [Product Roadmap](../../roadmap/product-roadmap.md) - Integration timeline and priorities

- [Executive Roadmap](../../business/roadmap/executive-roadmap.md) - Strategic integration investments

---

[← Back to All Features](../README.md)
