---
title: "Integrations Overview"
description: "Comprehensive overview of PenguinMails integration capabilities including API access, webhooks, CRM integrations, and Vault-based secrets management"
last_modified_date: "2025-11-26"
level: "2"
persona: "Technical Teams, Developers"
---


# Integrations Overview

PenguinMails provides comprehensive integration capabilities enabling connection with external systems through REST APIs, webhooks, CRM integrations, and secure secrets management.


## Integration Strategy: API-First Approach

PenguinMails follows an API-first integration strategy, prioritizing a robust general-purpose REST API that works with ANY external system over vendor-specific integrations.


### Why API-First?

**Benefits:**


- **Flexibility**: Customers can integrate with ANY system, not just pre-built integrations


- **Faster Time-to-Market**: General API is simpler than vendor-specific integrations


- **Lower Maintenance**: One API to maintain vs. multiple vendor integrations


- **Customer Empowerment**: Technical customers can build custom integrations immediately


- **Foundation for Future**: Vendor integrations built on top of stable API


- **Reduced Risk**: Prove API works before investing in vendor partnerships


### Integration Capabilities

**MVP (Available Now):**


- ✅ REST API with API key authentication


- ✅ Webhook system for event notifications


- ✅ API documentation (OpenAPI/Swagger)


- ✅ Vault-based secrets management

**Post-MVP (Q1-Q2 2026):**


- 🔜 Salesforce CRM integration


- 🔜 HubSpot CRM integration


- 🔜 Zapier integration (5,000+ apps)


- 🔜 ESP integration UI (Postmark, Mailgun)


## Core Integration Features


### 1. API Access

RESTful API for programmatic access to all PenguinMails functionality.

**Key Features:**


- Bearer token authentication with API keys


- Rate limiting by subscription tier (60-1000 req/min)


- Core endpoints: emails, contacts, campaigns, analytics


- Standard REST conventions (GET, POST, PUT, DELETE)


- JSON request/response format


- Comprehensive error handling


- API versioning (/api/v1/)

**Documentation:** [API Access](/docs/features/integrations/api-access)


### 2. Webhook System

Real-time HTTP POST notifications for email and campaign events.

**Key Features:**


- Event filtering by workspace, campaign, or custom criteria


- Automatic retry logic (5 attempts with exponential backoff)


- HMAC-SHA256 signature verification


- Event replay for historical data


- Webhook debugger and request inspector


- Comprehensive event types: email events, campaign events, contact events

**Status:** Planned (Q1 2026)

**Documentation:** [Webhook System](/docs/features/integrations/webhook-system)


### 3. CRM Integration

Bi-directional sync with major CRMs including Salesforce and HubSpot.

**Key Features:**


- OAuth 2.0 authentication


- Field mapping (standard and custom fields)


- Activity logging (tasks/timeline events)


- Conflict resolution strategies


- Real-time and batch sync options


- Workflow triggers (HubSpot)

**Status:** Planned (Q1 2026)

**Documentation:** [CRM Integration](/docs/features/integrations/crm-integration/overview)


### 4. ESP Integration

External Email Service Provider integration for specialized email delivery.

**Key Features:**


- Supported ESPs: Postmark (transactional), Mailgun (bulk marketing)


- API key authentication


- Smart routing rules (transactional vs marketing vs cold outreach)


- Webhook integration for delivery events


- Deliverability monitoring and comparison


- Failover configuration

**Status:** Active

**Documentation:** [ESP Integration](/docs/features/integrations/esp-integration)


## Vault Integration & Secrets Management


### Overview

HashiCorp Vault integration is a foundational security architecture that centralizes secrets management for the PenguinMails platform. Instead of storing sensitive credentials (SSH keys, SMTP passwords, API keys) in environment files on VPS instances, all secrets are stored in Vault with centralized access control, audit logging, and automated rotation.

**Status:** ✅ FULLY DOCUMENTED - Architecture and implementation workflows defined

**Key Benefits:**


- **Enhanced Security:** Secrets never stored on VPS (VPS compromise doesn't expose secrets)


- **Centralized Management:** Single source of truth for all secrets across infrastructure


- **Audit Trail:** Complete logging of all secret access and modifications


- **Automated Rotation:** Policy-based secret rotation (SSH: 90 days, SMTP: 180 days, API keys: on-demand)


- **Disaster Recovery:** Rapid recovery from VPS compromise (abandon VPS, restore secrets from Vault)


- **Compliance:** Meets SOC2, ISO 27001, and GDPR requirements for secrets management


### Vault Secret Types

PenguinMails uses Vault to store four types of secrets:


1. **VPS SSH Keys** - Admin and tenant SSH keys for VPS access


2. **SMTP Credentials** - MailU admin credentials for email infrastructure


3. **Tenant API Keys** - API keys for programmatic access (bcrypt hashed)


4. **DKIM Keys** - Domain authentication keys for email sending


### Vault Secret Structure

All secrets are organized hierarchically in Vault:


```

vault/
├── vps/{tenant_id}/
│   ├── admin_ssh/          # PenguinMails admin access
│   └── tenant_ssh/         # Tenant programmatic access
├── smtp/{tenant_id}/
│   └── admin/              # MailU admin credentials (AES-256-GCM encrypted)
├── api_keys/{tenant_id}/
│   └── {key_id}/           # API keys (bcrypt hashed, salt rounds: 12)
└── dkim/{domain}/
    └── {selector}/         # DKIM keys for email authentication


```


### Key Workflows


#### VPS SSH Key Management

Store admin and tenant SSH keys in Vault during VPS provisioning, enabling secure access and rapid disaster recovery.

**Features:**


- Dual SSH key system (admin + tenant) for separation of concerns


- Frontend UI at `/dashboard/settings/infrastructure/ssh-access`


- One-time private key download with security warnings


- Automated 90-day rotation policy


- Manual rotation and revocation capabilities

**Documentation:** [Vault SSH Management](/docs/features/infrastructure/vault-ssh-management)


#### SMTP Credentials Storage

Store SMTP admin credentials in Vault during MailU setup, enabling secure credential retrieval for troubleshooting.

**Features:**


- AES-256-GCM encryption before Vault storage


- Admin credential retrieval requires re-authentication (password + 2FA)


- Time-limited credential access (expires after 15 minutes)


- Automated 180-day rotation policy


- Emergency credential reset workflow

**Documentation:** [Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp-credentials)


#### Tenant API Key System

Generate unique API keys per tenant for programmatic email sending, stored securely in Vault with bcrypt hashing.

**Features:**


- Unique API key format: `pm_live_{32_random_chars}`


- bcrypt hashing (salt rounds: 12) before Vault storage


- Permission scopes: send_email, read_analytics, manage_contacts, manage_campaigns, etc.


- Rate limiting per API key (tier-based: 60-1000 req/min)


- Frontend UI at `/dashboard/settings/developers/api-keys`


- On-demand rotation (tenant-controlled)

**Documentation:** [Vault API Keys](/docs/features/integrations/vault-api-keys)


#### Vault Disaster Recovery

Enable rapid recovery from VPS compromise or Vault failure through automated backups and documented restoration procedures.

**Features:**


- Automated daily Vault backups to S3 (encrypted)


- VPS migration workflow (abandon compromised VPS, restore secrets)


- Vault restoration from backup (step-by-step runbook)


- Quarterly disaster recovery drills


- Vault high availability setup (3-node cluster for production)

**Documentation:** [Vault Disaster Recovery](/docs/features/infrastructure/vault-disaster-recovery)


### Rotation Policies

Automated secret rotation policies ensure secrets are regularly updated:

| Secret Type | Rotation Policy | Automation | Trigger |
|-------------|----------------|------------|---------|
| **VPS SSH Keys** | 90 days | Automated + Manual | Scheduled cron job + Admin trigger |
| **SMTP Credentials** | 180 days | Automated + Manual | Scheduled cron job + Admin trigger |
| **Tenant API Keys** | On-demand | Manual only | Tenant regeneration request |
| **DKIM Keys** | 365 days | Automated | Scheduled cron job |


### Access Control

Vault access control policies define who can read/write which secrets:

**Admin Access:**


- Read/Write: All secrets across all tenants


- Use Case: Troubleshooting, disaster recovery, secret rotation


- Authentication: Admin credentials + 2FA

**Tenant Access:**


- Read: Own tenant secrets only


- Write: API key creation/revocation only


- Use Case: Self-service SSH access, API key management


- Authentication: Tenant session token

**System Access:**


- Read: Secrets needed for automated operations


- Write: Secret creation during provisioning, rotation updates


- Use Case: Automated provisioning, secret rotation, email sending


- Authentication: Service account with limited scope


### Compliance

Vault integration supports compliance with industry standards:

**SOC 2 Type II:**


- CC6.1: Logical and physical access controls


- CC6.6: Encryption of data at rest and in transit


- CC6.7: Restriction of access to system configurations


- CC7.2: Detection of security events

**ISO 27001:**


- A.9.4.1: Information access restriction


- A.10.1.1: Cryptographic controls


- A.12.4.1: Event logging


- A.12.4.2: Protection of log information

**GDPR:**


- Article 32: Security of processing


- Article 33: Breach notification


- Article 5(1)(f): Integrity and confidentiality


## Third-Party Services


### Current Integrations

**Postmark** - Transactional email delivery


- Purpose: Password resets, account notifications, critical emails


- Cost: $1.25 per 1,000 emails (first 100 free)


- Status: Active integration

**Mailgun** - Bulk marketing email delivery


- Purpose: Newsletters, promotional campaigns, high-volume sends


- Cost: $35/month base + $1/1,000 emails


- Status: Active integration

**Stripe** - Payment processing and subscription management


- Purpose: Billing, subscriptions, payment methods


- Status: Active integration

**Loop.so** - Transactional email service


- Purpose: Email verification, password resets, team invitations


- Cost: $29/month (up to 50K emails)


- Status: Active (migration to in-house SMTP planned for Q3 2026)

**HashiCorp Vault** - Secrets management


- Purpose: Centralized secrets storage and management


- Cost: HCP Vault $22/month (MVP), self-hosted Post-MVP


- Status: Architecture documented, implementation planned


### Planned Integrations

**Salesforce** - CRM integration (Q1 2026)
**HubSpot** - CRM integration (Q1 2026)
**Pipedrive** - CRM integration (Q2 2026)
**Zapier** - 5,000+ app connections (Q2 2026)


## Implementation Roadmap


### MVP (Now)

**P0 - Critical:**


1. API Key Management System (1-2 weeks)


2. API Key Management UI (5-7 days)


3. Core REST API Endpoints (2-3 weeks)


4. API Documentation (1 week)

**P1 - High:**


5. Webhook System Backend (1-2 weeks)


6. Webhook Configuration UI (1-2 weeks)


7. API Usage Analytics (1 week)

**Total MVP Effort:** 8-11 weeks


### Post-MVP Roadmap

**Q1 2026:** Vendor-Specific CRM Integrations


- Salesforce Integration (3-4 weeks)


- HubSpot Integration (3-4 weeks)

**Q2 2026:** Ecosystem Expansion


- Zapier Integration (2-3 weeks)


- Additional CRM Integrations (2-3 weeks each, based on demand)

**Q3 2026:** Advanced Features


- ESP Integration Settings UI (1-2 weeks)


- Custom Webhook Builder (3-4 weeks)

**Q4 2026+:** Long-Term Strategic Features


- Integration Marketplace (8-12 weeks)


- Real-Time Sync (6-8 weeks, enterprise feature)


## Related Documentation


### Route Specifications


- [API Key Management Routes](/docs/design/routes/api-key-management) - API key management interface


- [Webhook System Routes](/docs/design/routes/webhook-system) - Webhook configuration routes


- [ESP Integration Routes](/docs/design/routes/esp-integration) - ESP configuration routes


- [Infrastructure SSH Access Routes](/docs/design/routes/infrastructure-ssh-access) - SSH credential management


### API Documentation


- [Platform API Overview](/docs/implementation-technical/api/platform-api) - Platform-level API endpoints


- [Tenant API Overview](/docs/implementation-technical/api/tenant-api) - Tenant-level API endpoints


- [Hostwinds API Overview](/docs/implementation-technical/api/hostwinds/overview) - VPS provisioning integration


### Feature Documentation


- [API Access](/docs/features/integrations/api-access) - API access overview


- [Vault API Keys](/docs/features/integrations/vault-api-keys) - Tenant API key system


- [Webhook System](/docs/features/integrations/webhook-system) - Webhook configuration


- [ESP Integration](/docs/features/integrations/esp-integration) - External ESP integration


- [CRM Integration](/docs/features/integrations/crm-integration/overview) - CRM integration overview


### Infrastructure Features


- [Vault SSH Management](/docs/features/infrastructure/vault-ssh-management) - VPS SSH key management


- [Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp-credentials) - SMTP credentials storage


- [Vault Disaster Recovery](/docs/features/infrastructure/vault-disaster-recovery) - Vault backup and recovery


- [Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup) - Infrastructure provisioning


### Security & Compliance


- [Enterprise Security Overview](/docs/compliance-security/enterprise/overview) - Enterprise security features


- [Compliance Overview](/docs/compliance-security/overview) - Compliance requirements


- [GDPR Compliance](/docs/compliance-security/detailed-compliance/gdpr) - GDPR compliance details


- [SOC2 Compliance](/docs/compliance-security/detailed-compliance/soc2) - SOC2 compliance requirements


### Implementation Tasks


- [Epic 5: Infrastructure Management](/tasks/epic-5-infrastructure-management/) - Infrastructure tasks


- [Epic 6: Core Email Pipeline](/tasks/epic-6-core-email-pipeline/) - Email pipeline tasks


### Business Documentation


- [Product Roadmap](/docs/roadmap/product-roadmap) - Product strategy and timeline


- [Technical Roadmap](/docs/roadmap/technical-roadmap) - Technical implementation roadmap


- [Feature Taxonomy](/docs/business/feature-taxonomy-and-roadmap) - Feature categorization

---

**Last Updated:** November 26, 2025
**Status:** Architecture documented, MVP implementation in progress
**Next Review:** December 2025
