---
title: "OLTP Schema - Overview & Standards"
description: "Table naming standards, performance strategy, and overview of the Online Transaction Processing database."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Overview & Standards

## Strategic Alignment

**Strategic Alignment**: This OLTP schema guide supports our enterprise infrastructure framework by providing comprehensive database schemas, multi-tenant design principles, and performance optimization strategies for the PenguinMails operational database.

**Technical Authority**: Our OLTP database architecture integrates with enterprise database systems, authentication platforms, and monitoring tools featuring NileDB-managed authentication, multi-tenant security, and optimized query performance for high-frequency operations.

**Operational Excellence**: Backed by enterprise database systems with 99.9% uptime guarantees, automated backup procedures, and comprehensive monitoring across all OLTP components with real-time performance tracking.

**User Journey Integration**: This database foundation is part of your complete user experience - connects to business logic operations, security frameworks, and operational excellence for reliable data management.

---

## Table Naming Standards

**OLTP Tier Naming Conventions:**

- **Core Entities**: No prefix, plural nouns (`users`, `companies`, `campaigns`)
- **Junction Tables**: Singular compound names (`tenant_users`, `campaign_sequence_steps`)
- **Configuration Tables**: Descriptive names (`user_preferences`, `tenant_config`)
- **System Tables**: Prefixed with table type (`system_config`, `feature_flags`)

**Table Name Examples:**

- `users` - User identity and profiles
- `tenants` - Tenant organizations
- `companies` - Tenant workspaces
- `domains` - Email sending domains
- `campaigns` - Campaign definitions
- `leads` - Contact database
- `templates` - Email templates
- `plans` - Subscription plans
- `subscriptions` - Active tenant subscriptions

---

## Overview

The **OLTP (Online Transaction Processing) Database** is PenguinMails' primary operational database designed for fast transactional operations, real-time data access, and primary business logic execution.

### Purpose & Characteristics

- **Primary Focus**: Fast queries, quick inserts, operational metadata
- **Performance**: Optimized for high-frequency operations and small record sizes
- **Architecture**: Normalized for data integrity, indexed for speed
- **Multi-Tenant**: Row Level Security (RLS) for complete tenant isolation

### Performance Strategy

- **Denormalized Fields**: `tenant_id` on operational tables for fast filtering
- **Index Coverage**: Covering indexes for common query patterns
- **Connection Pooling**: Aggressive pooling for high-throughput operations
- **Partitioning**: Consider date-based partitioning for large operational tables
