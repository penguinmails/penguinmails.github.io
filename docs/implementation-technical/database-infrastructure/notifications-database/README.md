---
title: "Notifications Database Documentation"
description: "Notifications Database Documentation - Overview and Navigation"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---
# Notifications Database Documentation

This directory contains comprehensive documentation for the PenguinMails Notifications & System Events database, an operational tier for user/admin notifications and curated system events.

## Documentation Structure

### Core Components

- **[Schema Guide](schema-guide)** - Complete database schema and design principles
- **[Entity Relationship Diagram](mermaid-er)** - Database schema visualization

### Design Principles

- **Operational Tier**: Distinct from OLTP, Content DB, OLAP, and Queue systems
- **UX-First**: Fast reads and simple status updates for dashboards
- **Bounded Retention**: Short to mid-term retention with cleanup policies
- **Clean Separation**: Avoids being a log sink or OLAP warehouse

## Quick Navigation

| Document | Purpose | Target Audience |
|----------|---------|----------------|
| [Schema Guide](schema-guide) | Complete database schema and implementation | Database engineers |
| [Mermaid ER](mermaid-er) | Visual database schema representation | All technical stakeholders |

## Key Concepts

### Core Responsibilities

- **User Notifications**: In-app, email, and push notifications
- **Admin System Events**: Curated system events for operator visibility
- **Fast Dashboard Reads**: Optimized for login/admin dashboard queries
- **Redis Integration**: Rate limiting and caching (not source of truth)

### System Integration

- **OLTP Integration**: User and tenant references without cross-DB FKs
- **Queue Processing**: Background job creation for external delivery
- **External Logging**: High-volume telemetry stays separate
- **OLAP Consumption**: Optional aggregates for reporting

## Architecture Overview

The Notifications Database follows an operational tier approach:

- **notifications**: User/admin visible notifications table
- **admin_system_events**: Curated system events for admins
- **Redis**: Rate limiting and caching layer only

This design ensures:

- Fast dashboard performance
- Clean separation from logging/analytics
- Bounded table growth
- Redis as auxiliary, not source of truth

## Getting Started

1. Review [Schema Guide](schema-guide) for implementation details
2. Reference [Mermaid ER](mermaid-er) for visual schema understanding
3. Follow design principles for new development

## Integration

This notifications database integrates with:

- OLTP system for user and tenant references
- Queue system for background job creation
- External logging for high-volume telemetry
- OLAP for optional aggregate reporting

For questions or support, contact the Engineering team.
