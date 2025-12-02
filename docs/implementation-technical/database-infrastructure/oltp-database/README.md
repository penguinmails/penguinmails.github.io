---
title: "OLTP Database Documentation"
description: "OLTP Database Documentation - Overview and Navigation"
last_modified_date: "2025-11-20"
level: "2"
persona: "Documentation Users"
---

# OLTP Database Documentation

This directory contains comprehensive documentation for the PenguinMails OLTP (Operational Transaction Processing) Database, the core operational tier for real-time business logic, multi-tenant data management, and transactional operations.

## Documentation Structure

### Core Components

- **[Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)** - Complete OLTP database schema and design principles

- **[Entity Relationship Diagram](/docs/implementation-technical/database-infrastructure/oltp-database/mermaid-er)** - Database schema visualization

- **[SQL Implementation Challenge](/docs/implementation-technical/database-infrastructure/oltp-database/sql-implementation-guide)** - Hands-on exercises for building and testing OLTP architecture

### Design Principles

- **Operational Tier**: Fast transactional operations for real-time business logic

- **Multi-Tenant**: Row Level Security (RLS) with complete tenant isolation

- **Normalized Design**: Optimized for data integrity and query performance

- **NileDB Integration**: Managed authentication and user identity

## Quick Navigation

| Document | Purpose | Target Audience |
|----------|---------|----------------|
| [Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) | Complete OLTP schema and implementation | Database engineers |
| [Mermaid ER](/docs/implementation-technical/database-infrastructure/oltp-database/mermaid-er) | Visual database schema representation | All technical stakeholders |
| [SQL Implementation Challenge](/docs/implementation-technical/database-infrastructure/oltp-database/sql-implementation-guide) | Hands-on SQL exercises for developers | Backend developers |

## Key Concepts

### Core Responsibilities

- **User Management**: Identity, authentication, and multi-tenant associations

- **Business Entities**: Campaigns, leads, templates, and company workspaces

- **Domain Management**: Email sending domains with DNS verification

- **Billing Operations**: Subscriptions, plans, and payment processing

- **Infrastructure**: VPS instances, SMTP IPs, and IP assignment management

### System Integration

- **Content Database**: References via storage_key without cross-DB foreign keys

- **Queue System**: Job creation for asynchronous processing

- **OLAP Analytics**: Aggregated data ingestion for business intelligence

- **Notifications DB**: User and tenant references without physical constraints

## Architecture Overview

The OLTP Database follows an operational tier approach:

- **Core Tables**: users, tenants, companies, campaigns, leads, templates

- **Infrastructure**: domains, email_accounts, vps_instances, smtp_ip_addresses

- **Billing**: plans, subscriptions, payments, subscription_addons

- **Configuration**: tenant_config, tenant_policies, user_preferences

This design ensures:

- Sub-500ms query performance for operational queries

- Complete tenant isolation through RLS policies

- Optimized indexing for high-frequency operations

- Clear separation from content, analytics, and logging concerns

## Getting Started

1. Review [Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) for implementation details

2. Reference [Mermaid ER](/docs/implementation-technical/database-infrastructure/oltp-database/mermaid-er) for visual schema understanding

3. Complete [SQL Implementation Challenge](/docs/implementation-technical/database-infrastructure/oltp-database/sql-implementation-guide) for hands-on learning

4. Follow design principles for new development

## Integration

This OLTP database integrates with:

- Content Database for email bodies and attachments

- Queue system for background job processing

- OLAP for aggregated analytics and reporting

- Notifications system for user notifications

For questions or support, contact the Engineering team.

## Hands-On Learning

The [SQL Implementation Challenge](/docs/implementation-technical/database-infrastructure/oltp-database/sql-implementation-guide) provides interactive exercises to:

- Build and test OLTP schemas with realistic sample data

- Implement multi-tenant isolation patterns

- Create cross-tier integration queries

- Performance test OLTP operations under load

- Discover architectural strengths and weaknesses through practice

**Keywords**: OLTP, operational database, transactional processing, multi-tenant, row level security, performance optimization, database schema, real-time operations, unified security


