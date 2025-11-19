---
title: "Content Database Documentation"
description: "Content Database Documentation - Overview and Navigation"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Content Database Documentation

This directory contains comprehensive documentation for the PenguinMails Content Database, a dedicated tier for heavy content storage including email bodies, attachments, and long-lived archives.

## Documentation Structure

### Core Components

- **[Analysis](analysis.md)** - Current model analysis, gotchas, and refinement proposals
- **[Schema Guide](schema-guide.md)** - Complete database schema and design principles
- **[Entity Relationship Diagram](mermaid-er.md)** - Database schema visualization

### Design Principles

- **Tier Separation**: Content DB is separate from OLTP, OLAP, and Queue systems
- **Heavy Content Focus**: Email bodies, attachments, and long-term archives only
- **No Cross-DB FKs**: Uses storage_key references without physical foreign key constraints
- **External Analytics**: Logging and monitoring handled by external systems

## Quick Navigation

| Document | Purpose | Target Audience |
|----------|---------|----------------|
| [Analysis](analysis.md) | Design analysis and improvement proposals | Technical architects |
| [Schema Guide](schema-guide.md) | Complete database schema and implementation | Database engineers |
| [Mermaid ER](mermaid-er.md) | Visual database schema representation | All technical stakeholders |

## Key Concepts

### Core Responsibilities

- **Content Storage**: Email bodies, HTML content, headers, and attachments
- **Tenant Isolation**: Complete data separation via tenant_id and RLS
- **Retention Policies**: Configurable lifecycle management and compliance
- **Storage Optimization**: Compression, deduplication, and archival strategies

### System Integration

- **OLTP Integration**: References via storage_key without cross-DB foreign keys
- **Queue Processing**: Content lifecycle managed through background workers
- **External Analytics**: Access logging and metrics handled by external systems
- **Backup & Recovery**: Content storage with robust backup procedures

## Architecture Overview

The Content Database follows a lean, focused approach:

- **content_objects**: Primary table for email/message bodies and metadata
- **attachments**: Binary attachments linked to content objects
- **Retention Systems**: Optional lifecycle policies and archival processes

This design avoids:
- Analytics and logging tables (handled by external systems)
- Cross-database foreign key constraints
- General-purpose monitoring or infrastructure metrics

## Getting Started

1. Review [Analysis](analysis.md) for current state understanding and proposals
2. Consult [Schema Guide](schema-guide.md) for implementation details
3. Reference [Mermaid ER](mermaid-er.md) for visual schema understanding
4. Follow design principles for new development

## Integration

This content database integrates with:
- OLTP system for message metadata and content references
- Queue system for lifecycle management and processing
- External analytics for access logging and performance monitoring
- Backup systems for data durability and compliance

For questions or support, contact the Engineering team.