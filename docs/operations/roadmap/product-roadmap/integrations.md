---
title: "Integrations Roadmap"
description: "API access, webhooks, and third-party integrations"
last_modified_date: "2025-12-04"
level: "2"
persona: "Developer Integration"
keywords: "integrations, API, webhooks, CRM, third-party"
---

# Integrations Roadmap

## Feature Deep Dive: Integrations

### Overview

**Status:** Foundation Documented, Implementation Pending
**Timeline:** Q1 2026 (MVP) → Q1-Q2 2026 (Vendor Integrations) → Q3-Q4 2026 (Advanced Features)
**Priority:** Critical (Foundation feature - API-first strategy)
**Strategy:** Build general-purpose REST API + webhooks first (MVP), add vendor-specific integrations later (Post-MVP)

### Current State: Foundation Documented

## What's Documented

- ✅ API-first integration strategy defined

- ✅ API key management architecture with Vault storage

- ✅ Core REST API endpoint specifications

- ✅ Webhook system architecture with retry logic

- ✅ Vault integration for secrets management (SSH keys, SMTP credentials, API keys)

- ✅ Third-party dependency analysis (Vault, Stripe, Hostwind, Loop.so)

- ✅ CRM integration specifications (Salesforce, HubSpot)

- ✅ Zapier integration plan

**Assessment:** Comprehensive integration architecture documented. Implementation ready to begin. API-first approach enables customers to build custom integrations immediately while we develop pre-built vendor integrations.

### MVP Implementation (Q1 2026)

## Critical Features (P0) - Blocks programmatic integrations

- **[P0] API Key Management System** (1-2 weeks)

  - API key generation with format `pm_live_{32_random_chars}`

  - bcrypt hashing (salt rounds: 12) before Vault storage

  - Permission scope enforcement (8 scopes)

  - Rate limiting per API key (tier-based: Starter 60/min, Pro 300/min, Enterprise 1000/min)

  - Usage tracking in PostgreSQL

  - **Business Impact:** Enables all programmatic integrations, blocks customer success for technical users

- **[P0] API Key Management UI** (5-7 days)

  - Self-service API key creation, viewing, regeneration, revocation

  - Permission scope selector with 8 scopes

  - Usage charts and analytics

  - Code examples (cURL, Node.js, Python)

  - **Business Impact:** Self-service API access, reduces support burden

- **[P0] Core REST API Endpoints** (2-3 weeks)

  - Contacts API (CRUD operations)

  - Campaigns API (CRUD, start, pause)

  - Emails API (send, list, get details)

  - Analytics API (email metrics, campaign metrics, contact engagement)

  - Standard REST conventions with pagination, filtering, sorting

  - **Business Impact:** Core integration functionality, enables custom integrations

- **[P0] API Documentation (OpenAPI/Swagger)** (1 week)

  - OpenAPI 3.0 specification

  - Swagger UI at /api/docs

  - Code examples in multiple languages

  - Getting started guide and best practices

  - **Business Impact:** Developer enablement, reduces integration friction

## High Priority (P1) - Enables real-time integrations

- **[P1] Webhook System Backend** (1-2 weeks)

  - Event delivery engine with queue-based processing

  - 10 event types (email.sent, email.opened, email.clicked, etc.)

  - HMAC-SHA256 signature verification

  - Retry logic with exponential backoff (5 attempts)

  - Webhook delivery logging and health monitoring

  - **Business Impact:** Real-time integrations, competitive standard feature

- **[P1] Webhook Configuration UI** (1-2 weeks)

  - Self-service webhook setup with event selection

  - Webhook testing interface with sample payloads

  - Delivery log viewer with statistics

  - Signature verification code examples

  - **Business Impact:** Self-service webhook setup, enables real-time workflows

**Total MVP Effort:** 6-9 weeks (2-3 engineers)

### Post-MVP Roadmap (Q1-Q4 2026)

### Q1 2026: Advanced CRM Integrat

- **[P2] Salesforce Integration** (20-30 days)

  - OAuth 2.0 authentication flow

  - Bi-directional contact/lead sync

  - Field mapping (standard and custom fields)

  - Activity logging (emails, opens, clicks as Salesforce tasks)

  - Conflict resolution strategies

  - **Business Impact:** Unlocks enterprise customers, competitive requirement

- **[P2] HubSpot Integration** (20-30 days)

  - OAuth 2.0 authentication flow

  - Bi-directional contact sync

  - Field mapping (standard and custom properties)

  - Activity logging (timeline events)

  - Workflow triggers based on email engagement

  - **Business Impact:** Unlocks SMB/mid-market customers, competitive requirement

### Q2 2026: No-Code Integrations

- **[P2] Zapier Integration** (2-3 weeks)

  - Zapier app setup with 5+ triggers and 5+ actions

  - Pre-built Zap templates (20+ common workflows)

  - Authentication via API key

  - **Business Impact:** Expands ecosystem to 5,000+ apps, enables non-technical users

### Q3 2026: Enhanced Features

- **[P1] ESP Integration UI** (10-14 days)

  - Postmark/Mailgun configuration interface

  - Routing rules builder (transactional → Postmark, marketing → Mailgun)

  - ESP performance analytics and comparison

  - **Business Impact:** Optimizes deliverability and costs, competitive differentiator

- **[P3] Custom Webhook Builder** (3-4 weeks)

  - Advanced event filtering (contact tags, lead score, email domain)

  - Conditional logic (if/then rules, threshold-based triggers)

  - Payload transformation (custom templates, field mapping)

  - Visual webhook builder (drag-and-drop interface)

  - **Business Impact:** Advanced automation for power users, competitive differentiator

- **[P3] Additional CRM Integrations** (2-3 weeks each)

  - Pipedrive integration (Q2 2026)

  - Zoho CRM integration (Q3 2026)

  - Close.io integration (Q3 2026)

  - **Business Impact:** Expands addressable market, supports SMB customers

### Q4 2026+: Ecosystem Expansion

- **[P3] Integration Marketplace** (8-12 weeks)

  - Developer portal for third-party integrations

  - Integration marketplace (browse, search, install)

  - OAuth app registration for developers

  - Integration review process

  - **Business Impact:** Community-driven ecosystem, long-term strategic value

- **[P3] Real-Time Sync** (6-8 weeks)

  - WebSocket/SSE infrastructure for push notifications

  - Sub-1-minute sync latency for enterprise customers

  - Change Data Capture (CDC) from PostgreSQL

  - **Business Impact:** Enterprise feature, competitive advantage

### Vault Integration Timeline

### Q1 2026: Foundation

- **[P0] Vault Integration Architecture** (1 week) - ✅ Documented

  - Secret structure, access policies, rotation procedures

  - Backup and recovery procedures

  - High availability setup (3-node cluster)

- **[P1] VPS SSH Key Management** (1-2 weeks) - ✅ Documented

  - Store admin and tenant SSH keys in Vault

  - Frontend UI for credential viewing

  - 90-day automated rotation

- **[P1] SMTP Credentials Vault Storage** (1 week) - ✅ Documented

  - Store MailU admin credentials in Vault

  - AES-256-GCM encryption before storage

  - 180-day automated rotation

- **[P1] Vault Disaster Recovery** (1-2 weeks) - ✅ Documented

  - Automated daily backups to S3

  - VPS migration workflow

  - Quarterly disaster recovery drills

**Total Vault Integration Effort:** 4-6 weeks

### Key Dependencies

## Vault Integration

- HashiCorp Vault (HCP Vault: $22/month MVP, self-hosted Post-MVP)

- VPS SSH key storage (enables tenant self-service)

- SMTP credentials storage (enables support troubleshooting)

- API key management (enables programmatic integrations)

- Disaster recovery procedures (enables rapid recovery)

## Third-Party Services

- **Stripe** - Payment processing (fully integrated, no migration planned)

- **Hostwind API** - VPS provisioning (add alternatives Q2 2026)

- **Loop.so** - Transactional emails ($29/month, migrate to MailU Q3 2026)

- **Postmark** - Transactional email delivery (active integration)

- **Mailgun** - Bulk marketing email delivery (active integration)

## Infrastructure

- PostgreSQL database (API data storage)

- Redis (rate limiting, webhook queue)

- Event system (webhook triggers)

### Success Metrics

## Technical

- API key generation success rate > 99%

- API response time < 200ms (p95)

- Webhook delivery success rate > 95%

- CRM sync success rate > 95% (Post-MVP)

## Business

- 50+ developers using API within first month (MVP)

- 100+ API keys generated (MVP)

- 200+ webhooks configured (MVP)

- 10+ custom integrations built by customers (MVP)

- 20+ customers using Salesforce integration (Q1 2026)

- 15+ customers using HubSpot integration (Q1 2026)

- 50+ customers using Zapier integration (Q2 2026)

### API-First Strategy Rationale

## Why API-First Approach?

## Benefits

- **Flexibility**: Customers can integrate with ANY system, not just pre-built integrations

- **Faster Time-to-Market**: General API is simpler than vendor-specific integrations (6-9 weeks vs 20-30 days per vendor)

- **Lower Maintenance**: One API to maintain vs. multiple vendor integrations

- **Customer Empowerment**: Technical customers can build custom integrations immediately

- **Foundation for Future**: Vendor integrations built on top of stable API

- **Reduced Risk**: Prove API works before investing in vendor partnerships

## Customer Use Cases Enabled by General API

- Custom CRM integrations (any CRM, not just Salesforce/HubSpot)

- Internal tool integrations (dashboards, analytics, reporting)

- Workflow automation (trigger actions based on email events)

- Data export/import (bulk operations, migrations)

- Third-party app integrations (marketing tools, analytics platforms)

## Customer Communication

"PenguinMails provides a powerful REST API and webhook system that enables integration with any external system. Build custom integrations with your CRM, analytics tools, or internal systems. Pre-built integrations with Salesforce, HubSpot, and Zapier coming in Q1-Q2 2026."

**Detailed Roadmap:** [Integrations Roadmap](/docs/features/integrations/roadmap)

---
