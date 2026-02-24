---
title: "OLTP Schema Guide - Operational Database"
description: "Comprehensive guide to the Online Transaction Processing database schema, multi-tenant design, and performance optimizations."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema Guide - Operational Database

The **OLTP (Online Transaction Processing) Database** is PenguinMails' primary operational database designed for fast transactional operations, real-time data access, and primary business logic execution.

## Schema Documentation

This guide is organized into the following sections:

### 1. [Overview & Standards](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/overview)

Core purpose, performance strategies, and table naming conventions.

### 2. [Core Infrastructure](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/core-infrastructure)

Authentication, multi-tenant organization, and workspace management.

### 3. [Domain Management](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/domain-management)

Sending domains, DNS record structures, and email account configurations.

### 4. [Lead Management](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/lead-management)

Contact database and lead lifecycle tracking.

### 5. [Template Management](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/template-management)

Email templates, organization, tagging, and rendering.

### 6. [Campaign Management](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/campaign-management)

Campaign orchestration, sequences, and execution metadata.

### 7. [Payment Architecture](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/payment-architecture)

Stripe-first philosophy and the three-tier payment data model.

### 8. [Billing & Subscriptions](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/billing-subscription)

Plans, subscriptions, addons, and payment references.

### 9. [Infrastructure Management](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/infrastructure-management)

VPS instances, SMTP IP allocation, and assignment tracking.

### 10. [Staff & Permissions](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/staff-permissions)

Granular role-based access control for platform staff.

### 11. [System Configuration](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/system-configuration)

Feature flags, system-wide settings, and tenant security policies.

### 12. [Performance & Security](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/performance-security)

Critical indexes and Row Level Security (RLS) implementation.

### 13. [Integration & Impact](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide/integration-impact)

Analytics platform integration, business impact, and success metrics.

---

## Related Documents

### Supporting Documentation

- [Database Infrastructure](/docs/implementation-technical/database-infrastructure)
- [Architecture System](/docs/implementation-technical/architecture-system/architecture-overview)
- [Development Guidelines](/docs/implementation-technical/development-guidelines)
- [Quality Assurance](/docs/business/quality-assurance)

### Business Integration

- [Business Strategy Overview](/docs/business/strategy/overview)
- [Operations Management](/docs/operations/analytics/operations-management)
- [Security Framework](/docs/compliance-security/enterprise/security-framework)
- [Analytics Performance](/docs/operations/analytics/analytics-performance)
