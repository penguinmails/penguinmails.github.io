---
title: "Integrations Roadmap"
description: "Detailed timeline and implementation plan for PenguinMails integration features including API-first strategy, Vault secrets management, and vendor-specific integrations"
last_modified_date: "2025-11-26"
level: "2"
persona: "Product Teams, Developers"
---


# Integrations Roadmap


## Overview

This document outlines the detailed implementation roadmap for PenguinMails integration features, following an **API-first approach** where we build a robust general-purpose REST API + webhooks first (MVP), then add vendor-specific integrations later (Post-MVP).

**Strategy**: Enable customers to build custom integrations immediately with excellent API design, then add pre-built vendor integrations (Salesforce, HubSpot, Zapier) on top of stable API foundation.

**Timeline**: Q1 2026 (MVP) → Q1-Q2 2026 (Vendor Integrations) → Q3-Q4 2026 (Advanced Features)

---


## MVP - Critical Features (Q1 2026)


### 1. API Key Management System

**Priority**: P0 - Critical  
**Complexity**: Medium (1-2 weeks)  
**Status**: Documented, Implementation Pending  
**Blocking**: Yes - Blocks all programmatic integrations

**Description**: Complete API key management system with Vault storage, including backend key generation, authentication middleware, and rate limiting.

**Acceptance Criteria**:


- [ ] API key generation with format `pm_live_{32_random_chars}`


- [ ] bcrypt hashing (salt rounds: 12) before Vault storage


- [ ] Vault integration for secure key storage at path `/api_keys/{tenant_id}/{key_id}`


- [ ] API authentication middleware validates keys on all API endpoints


- [ ] Permission scope enforcement (8 scopes: send_email, read_analytics, manage_contacts, manage_campaigns, manage_templates, manage_domains, read_inbox, manage_webhooks)


- [ ] Rate limiting per API key using token bucket algorithm (Starter: 60/min, Pro: 300/min, Enterprise: 1000/min)


- [ ] Usage tracking in PostgreSQL (request count, last used timestamp, error count)


- [ ] API endpoints: POST /api/v1/platform/api-keys (create), GET /api/v1/platform/api-keys (list), DELETE /api/v1/platform/api-keys/:id (revoke)

**Dependencies**:


- Vault Integration Architecture


- PostgreSQL database


- Redis for rate limiting

**References**:


- [Feature Documentation](./vault-api-keys.md)


- [Route Specification](../../design/routes/api-key-management.md)


- [Vault Architecture](../../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)

---


### 2. API Key Management UI

**Priority**: P0 - Critical  
**Complexity**: Medium (5-7 days)  
**Status**: Documented, Implementation Pending  
**Blocking**: Yes - Blocks self-service API access

**Description**: Frontend UI for API key management at `/dashboard/settings/developers/api-keys` with create, view, regenerate, and revoke capabilities.

**Acceptance Criteria**:


- [ ] API key list page with table showing masked keys, permissions, last used, and actions


- [ ] Create API key modal with name input and permission scope selector (checkboxes for 8 scopes)


- [ ] API key created success modal displaying full key once with copy button and code examples (cURL, Node.js, Python)


- [ ] API key details modal with usage charts (requests over time, error rate)


- [ ] Regenerate API key confirmation modal with security warning


- [ ] Revoke API key confirmation modal


- [ ] Copy to clipboard functionality for API keys


- [ ] Download as .env file functionality


- [ ] Empty state with "Create your first API key" CTA


- [ ] Responsive design (mobile, tablet, desktop)

**Dependencies**:


- API Key Management System (backend)


- React/TypeScript frontend framework


- Chart library for usage visualization

**References**:


- [Route Specification](../../design/routes/api-key-management.md)


- [Feature Documentation](./vault-api-keys.md)

---


### 3. Core REST API Endpoints

**Priority**: P0 - Critical  
**Complexity**: Large (2-3 weeks)  
**Status**: Partially Documented, Implementation Pending  
**Blocking**: Yes - Blocks programmatic integrations

**Description**: Implement core REST API endpoints for contacts, campaigns, emails, and analytics with standard REST conventions.

**Acceptance Criteria**:


- [ ] **Contacts API**: GET /api/v1/contacts (list with pagination), POST /api/v1/contacts (create), GET /api/v1/contacts/:id (get), PUT /api/v1/contacts/:id (update), DELETE /api/v1/contacts/:id (delete)


- [ ] **Campaigns API**: GET /api/v1/campaigns (list), POST /api/v1/campaigns (create), GET /api/v1/campaigns/:id (get), PUT /api/v1/campaigns/:id (update), DELETE /api/v1/campaigns/:id (delete), POST /api/v1/campaigns/:id/start (start), POST /api/v1/campaigns/:id/pause (pause)


- [ ] **Emails API**: POST /api/v1/emails/send (send single email), GET /api/v1/emails (list sent emails), GET /api/v1/emails/:id (get email details)


- [ ] **Analytics API**: GET /api/v1/analytics/emails (email metrics), GET /api/v1/analytics/campaigns/:id (campaign metrics), GET /api/v1/analytics/contacts/:id (contact engagement)


- [ ] Standard REST conventions (GET, POST, PUT, DELETE verbs)


- [ ] JSON request/response format


- [ ] Standard HTTP status codes (200, 201, 400, 401, 403, 404, 500)


- [ ] Pagination support (limit, offset, cursor-based)


- [ ] Filtering support (query parameters)


- [ ] Sorting support (sort_by, order parameters)


- [ ] API versioning (/api/v1/)


- [ ] Comprehensive error responses with error codes and messages

**Dependencies**:


- API Key Management System (authentication)


- PostgreSQL database


- Campaign management system


- Email sending infrastructure

**References**:


- [Feature Documentation](./api-access.md)


- [Integration Strategy](../../../.kiro/specs/feature-completeness-review/findings/integration-strategy.md)

---


### 4. API Documentation (OpenAPI/Swagger)

**Priority**: P0 - Critical  
**Complexity**: Medium (1 week)  
**Status**: Not Started  
**Blocking**: Yes - Blocks developer adoption

**Description**: Create comprehensive API documentation using OpenAPI/Swagger with interactive API explorer and code examples.

**Acceptance Criteria**:


- [ ] OpenAPI 3.0 specification file (openapi.yaml)


- [ ] Swagger UI hosted at /api/docs for interactive API exploration


- [ ] Complete endpoint documentation (all endpoints, parameters, responses)


- [ ] Authentication documentation (API key usage, Bearer token format)


- [ ] Rate limiting documentation (tier-based limits, headers)


- [ ] Error code reference (all error codes with descriptions)


- [ ] Code examples in multiple languages (cURL, Node.js, Python, PHP)


- [ ] Webhook documentation (event types, payload formats, signature verification)


- [ ] Getting started guide (authentication, first API call)


- [ ] Best practices guide (error handling, rate limiting, pagination)


- [ ] Postman collection export


- [ ] API changelog (version history)

**Dependencies**:


- Core REST API Endpoints (to document)


- Swagger UI library

**References**:


- [Feature Documentation](./api-access.md)

---


### 5. Webhook System (Backend)

**Priority**: P1 - High  
**Complexity**: Large (1-2 weeks)  
**Status**: Documented, Implementation Pending  
**Blocking**: Partial - Critical for real-time integrations

**Description**: Implement webhook delivery system with event filtering, retry logic, and signature verification.

**Acceptance Criteria**:


- [ ] Webhook delivery engine with queue-based processing (PostgreSQL queue or Redis)


- [ ] Event type support (email.sent, email.opened, email.clicked, email.replied, email.bounced, email.unsubscribed, campaign.started, campaign.completed, contact.created, contact.updated)


- [ ] Event filtering by workspace, campaign, or contact tags


- [ ] HMAC-SHA256 signature generation for webhook payloads


- [ ] Retry logic with exponential backoff (5 attempts: 1s, 2s, 4s, 8s, 16s)


- [ ] Webhook delivery logging (success/failure, response time, status code)


- [ ] Webhook timeout handling (30 second timeout)


- [ ] Webhook health monitoring (success rate, average response time)


- [ ] API endpoints: POST /api/v1/webhooks (create), GET /api/v1/webhooks (list), PUT /api/v1/webhooks/:id (update), DELETE /api/v1/webhooks/:id (delete), GET /api/v1/webhooks/:id/deliveries (delivery log)

**Dependencies**:


- PostgreSQL or Redis for queue


- Core REST API infrastructure


- Event system for triggering webhooks

**References**:


- [Feature Documentation](./webhook-system.md)


- [Route Specification](../../design/routes/webhook-system.md)

---


### 6. Webhook Configuration UI

**Priority**: P1 - High  
**Complexity**: Large (1-2 weeks)  
**Status**: Documented, Implementation Pending  
**Blocking**: Partial - Enables self-service webhook setup

**Description**: Frontend UI for webhook configuration at `/dashboard/settings/webhooks` with event selection, testing, and delivery logs.

**Acceptance Criteria**:


- [ ] Webhook list page with table showing endpoint URL, events, status, and actions


- [ ] Create webhook modal with URL input, event type selector (checkboxes), and filter options


- [ ] Webhook test interface with sample payload preview and "Send Test" button


- [ ] Webhook delivery log viewer with filterable table (timestamp, event type, status, response time, retry count)


- [ ] Webhook detail page with delivery statistics (success rate, average response time, error rate)


- [ ] Signature verification code examples (Node.js, Python, PHP)


- [ ] Webhook health status indicator (healthy, degraded, failing)


- [ ] Enable/disable webhook toggle


- [ ] Edit webhook modal (update URL, events, filters)


- [ ] Delete webhook confirmation modal

**Dependencies**:


- Webhook System (backend)


- React/TypeScript frontend framework


- Chart library for delivery statistics

**References**:


- [Route Specification](../../design/routes/webhook-system.md)


- [Feature Documentation](./webhook-system.md)

---


## MVP Summary

**Total Effort**: 6-9 weeks  
**Team Size**: 2-3 engineers  
**Priority Distribution**: 4 P0 features, 2 P1 features

**Critical Path**:


1. API Key Management System (1-2 weeks) - Foundation


2. API Key Management UI (5-7 days) - User-facing


3. Core REST API Endpoints (2-3 weeks) - Core functionality


4. API Documentation (1 week) - Developer enablement


5. Webhook System (1-2 weeks) - Real-time integrations


6. Webhook Configuration UI (1-2 weeks) - User-facing

**Success Criteria**:


- Customers can generate API keys and make authenticated API calls


- Core API endpoints functional for contacts, campaigns, emails, analytics


- Comprehensive API documentation available at /api/docs


- Webhook system delivers events reliably with retry logic


- Self-service webhook configuration available in UI

---


## Post-MVP - Vendor Integrations (Q1-Q2 2026)


### Q1 2026: Advanced CRM Integrations


#### 1. Salesforce Integration

**Priority**: P2 - Medium  
**Complexity**: Very Large (20-30 days)  
**Target**: Q1 2026  
**Status**: Planned

**Description**: Bi-directional sync between PenguinMails and Salesforce with OAuth authentication, field mapping, and activity logging.

**Key Features**:


- OAuth 2.0 authentication flow


- Bi-directional contact/lead sync


- Field mapping (standard and custom fields)


- Activity logging (emails, opens, clicks as Salesforce tasks)


- Conflict resolution strategies


- Real-time and batch sync options

**Effort**: 20-30 days  
**Dependencies**: Stable API + webhooks

---


#### 2. HubSpot Integration

**Priority**: P2 - Medium  
**Complexity**: Very Large (20-30 days)  
**Target**: Q1 2026  
**Status**: Planned

**Description**: Bi-directional sync between PenguinMails and HubSpot with OAuth authentication, field mapping, and workflow triggers.

**Key Features**:


- OAuth 2.0 authentication flow


- Bi-directional contact sync


- Field mapping (standard and custom properties)


- Activity logging (emails, opens, clicks as HubSpot timeline events)


- Workflow triggers based on email engagement


- Real-time and batch sync options

**Effort**: 20-30 days  
**Dependencies**: Stable API + webhooks

---


### Q2 2026: No-Code Integrations


#### 3. Zapier Integration

**Priority**: P2 - Medium  
**Complexity**: Medium (2-3 weeks)  
**Target**: Q2 2026  
**Status**: Planned

**Description**: Zapier app integration enabling connections to 5,000+ apps with pre-built Zaps for common workflows.

**Key Features**:


- Zapier app setup and configuration


- Triggers: email.sent, email.opened, email.clicked, email.replied, contact.created


- Actions: create_contact, send_email, add_to_campaign, update_contact


- Searches: find_contact, find_campaign


- Pre-built Zap templates (20+ common workflows)


- Zapier webhook endpoints


- Authentication via API key

**Effort**: 2-3 weeks  
**Dependencies**: Stable API + webhooks

**Example Zaps**:


- Google Sheets → PenguinMails (new row creates contact)


- PenguinMails → Slack (email replied sends Slack message)


- Typeform → PenguinMails (new submission creates contact and adds to segment)

---


## Post-MVP - Enhanced Features (Q3-Q4 2026)


### Q3 2026: ESP Integration UI


#### 4. ESP Integration Settings UI

**Priority**: P1 - High  
**Complexity**: Large (10-14 days)  
**Target**: Q3 2026  
**Status**: Planned

**Description**: User interface for configuring external Email Service Providers (Postmark, Mailgun) with routing rules and analytics.

**Key Features**:


- ESP provider selection and configuration forms


- API key/token input with validation


- Domain verification status display


- Tracking options (opens, clicks, delivery)


- Routing rules builder (transactional → Postmark, marketing → Mailgun)


- Webhook endpoint configuration for ESP events


- ESP performance analytics and comparison


- Connection testing interface

**Effort**: 10-14 days  
**Dependencies**: Postmark and Mailgun integrations (already active)

---


### Q3 2026: Custom Webhook Builder


#### 5. Advanced Webhook Configuration

**Priority**: P3 - Low  
**Complexity**: Large (3-4 weeks)  
**Target**: Q3 2026  
**Status**: Planned

**Description**: Advanced webhook configuration with custom event filtering, conditional logic, and payload transformation.

**Key Features**:


- Advanced event filtering (contact tags, lead score, email domain, campaign type)


- Conditional logic (if/then rules, threshold-based triggers)


- Payload transformation (custom templates, field mapping, data enrichment)


- Webhook templates (Salesforce, HubSpot, Slack, Google Sheets formats)


- Visual webhook builder (drag-and-drop interface)


- Payload preview with sample data


- Test webhook with live data

**Effort**: 3-4 weeks  
**Dependencies**: Basic webhook system (MVP)

---


### Q2-Q3 2026: Additional CRM Integrations


#### 6. Pipedrive Integration

**Priority**: P3 - Low  
**Complexity**: Medium (2-3 weeks)  
**Target**: Q2 2026  
**Status**: Planned

**Description**: Bi-directional sync with Pipedrive CRM for SMB customers.

**Effort**: 2-3 weeks  
**Dependencies**: CRM integration framework (Salesforce/HubSpot)

---


#### 7. Zoho CRM Integration

**Priority**: P3 - Low  
**Complexity**: Medium (2-3 weeks)  
**Target**: Q3 2026  
**Status**: Planned

**Description**: Bi-directional sync with Zoho CRM for SMB customers.

**Effort**: 2-3 weeks  
**Dependencies**: CRM integration framework

---


#### 8. Close.io Integration

**Priority**: P3 - Low  
**Complexity**: Medium (2-3 weeks)  
**Target**: Q3 2026  
**Status**: Planned

**Description**: Bi-directional sync with Close.io CRM for SMB customers.

**Effort**: 2-3 weeks  
**Dependencies**: CRM integration framework

---


## Future Vision (Q4 2026+)


### Q4 2026: Integration Marketplace


#### 9. Developer Portal & Marketplace

**Priority**: P3 - Low  
**Complexity**: Very Large (8-12 weeks)  
**Target**: Q4 2026+  
**Status**: Planned

**Description**: Public marketplace where third-party developers can publish integrations, and users can discover and install them.

**Key Features**:


- Developer portal (registration, submission, testing)


- Integration marketplace (browse, search, install)


- Integration management (installed integrations dashboard)


- Integration review process (security, functionality, documentation)


- OAuth app registration for developers


- Integration analytics (installs, usage)

**Effort**: 8-12 weeks  
**Dependencies**: Mature API and webhook infrastructure

---


### Q4 2026: Real-Time Sync


#### 10. Sub-1-Minute Sync Latency

**Priority**: P3 - Low (Enterprise feature)  
**Complexity**: Very Large (6-8 weeks)  
**Target**: Q4 2026  
**Status**: Planned

**Description**: Ultra-low latency bi-directional sync with WebSocket/SSE infrastructure for enterprise customers.

**Key Features**:


- WebSocket or Server-Sent Events (SSE) for push notifications


- Change Data Capture (CDC) from PostgreSQL


- Real-time event streaming (Kafka or Redis Streams)


- Sub-1-minute sync latency guarantee


- Real-time conflict detection and resolution

**Effort**: 6-8 weeks  
**Dependencies**: CRM integrations, event streaming infrastructure

---


## Vault Integration Roadmap


### Foundation (Q1 2026)


#### 1. Vault Integration Architecture

**Priority**: P0 - Critical  
**Complexity**: Medium (1 week)  
**Status**: ✅ Documented  
**Blocking**: Yes - Foundational architecture

**Description**: Comprehensive Vault integration architecture documentation including secret structure, access policies, rotation procedures, and disaster recovery.

**Deliverables**:


- ✅ Vault secret structure definition


- ✅ Access control policies (admin, tenant, system)


- ✅ Secret rotation policies (SSH: 90 days, API keys: on-demand, SMTP: 180 days)


- ✅ Backup and recovery procedures


- ✅ Vault initialization and unsealing procedures


- ✅ High availability setup (3-node cluster)


- ✅ Monitoring and alerting configuration

**Reference**: [Vault Integration Architecture](../../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)

---


#### 2. VPS SSH Key Management

**Priority**: P1 - High  
**Complexity**: Medium (1-2 weeks)  
**Status**: ✅ Documented, Implementation Pending  
**Blocking**: Partial - Enables tenant self-service

**Description**: Store admin and tenant SSH keys in Vault during VPS provisioning with frontend UI for credential viewing.

**Key Features**:


- Store admin SSH keys in Vault during VPS provisioning


- Generate tenant SSH keys (secondary access)


- Frontend UI at `/dashboard/settings/infrastructure/ssh-access`


- SSH key rotation workflow (manual + automated 90-day)


- SSH key download capability (one-time with warning)


- Audit logging for all SSH key access

**Effort**: 1-2 weeks  
**Reference**: [VPS SSH Key Management](../infrastructure/vault-ssh-management.md)

---


#### 3. SMTP Credentials Vault Storage

**Priority**: P1 - High  
**Complexity**: Medium (1 week)  
**Status**: ✅ Documented, Implementation Pending  
**Blocking**: Partial - Security best practice

**Description**: Store SMTP admin credentials in Vault during MailU setup with secure retrieval for troubleshooting.

**Key Features**:


- Store SMTP credentials in Vault during MailU setup


- AES-256-GCM encryption before Vault storage


- Secure credential viewing UI (requires re-authentication)


- Time-limited access (15 minutes)


- Automated 180-day rotation


- Emergency credential reset workflow

**Effort**: 1 week  
**Reference**: [SMTP Credentials Storage](../infrastructure/vault-smtp-credentials.md)

---


#### 4. Vault Disaster Recovery

**Priority**: P1 - High  
**Complexity**: Medium (1-2 weeks)  
**Status**: ✅ Documented, Implementation Pending  
**Blocking**: No - Can start with manual procedures

**Description**: Automated Vault backup, disaster recovery procedures, and VPS migration workflow.

**Key Features**:


- Automated daily Vault backups to S3


- VPS migration workflow (abandon VPS, restore secrets)


- Vault restoration from backup (step-by-step runbook)


- Quarterly disaster recovery drills


- Vault high availability setup (3-node cluster)


- Monitoring and alerting for Vault health

**Effort**: 1-2 weeks  
**Reference**: [Disaster Recovery Procedures](../infrastructure/vault-disaster-recovery.md)

---


## Success Metrics


### MVP Success Criteria (Q1 2026)

**Technical Metrics**:


- API key generation success rate > 99%


- API response time < 200ms (p95)


- Webhook delivery success rate > 95%


- API documentation completeness > 90%

**Business Metrics**:


- 50+ developers using API within first month


- 100+ API keys generated


- 200+ webhooks configured


- 10+ custom integrations built by customers


### Post-MVP Success Criteria (Q2-Q4 2026)

**Technical Metrics**:


- CRM sync success rate > 95%


- Zapier Zap success rate > 98%


- Real-time sync latency < 1 minute (enterprise)

**Business Metrics**:


- 20+ customers using Salesforce integration


- 15+ customers using HubSpot integration


- 50+ customers using Zapier integration


- 100+ Zaps created by customers

---


## Cross-References

**Related Features**:


- [Authentication & Security](../enterprise/user-management.md) - API key authentication, OAuth flows


- [Infrastructure Management](../infrastructure/README.md) - VPS provisioning, SSH key management, SMTP setup


- [Domain Management](../domains/README.md) - DKIM key storage in Vault


- [Email Operations](../campaigns/README.md) - Campaign API endpoints, webhook events

**Implementation**:


- [API Documentation](../../implementation-technical/api/README.md) - Technical API specifications


- [Vault Architecture](../../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md) - Secrets management architecture

**Business Strategy**:


- [Integration Strategy](../../../.kiro/specs/feature-completeness-review/findings/integration-strategy.md) - API-first approach rationale


- [Product Roadmap](../../roadmap/product-roadmap.md) - Integration timeline and priorities


- [Executive Roadmap](../../business/roadmap/executive-roadmap.md) - Strategic integration investments

---

**Last Updated**: 2025-11-26  
**Review Cycle**: Monthly roadmap updates, quarterly strategic review  
**Status**: Active planning and implementation
