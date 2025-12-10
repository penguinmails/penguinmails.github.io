---
title: "Workspace Domain Transfer (Metadata)"
description: "Transfer domain metadata between workspaces with full history preservation"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams, Technical Leaders"
parent: "/docs/roadmap/product/domains/README.md"
---

# Workspace Domain Transfer (Metadata)

## Overview

**Priority**: P2 (Medium - Agency Focus)
**Effort**: 5-7 days
**Timeline**: Q2 2026

**Description**:
Transfer domain metadata between workspaces within PenguinMails with full history preservation.
**Note:** This is metadata transfer within PenguinMails only. DNS records remain at the user's registrar.

## Use Cases

- Agency transfers `client.com` metadata to client's own workspace
- Workspace consolidation during business restructuring
- Client takes ownership of domain after contract ends
- Bulk migration of 10+ domains between workspaces

## Acceptance Criteria

- Domain transfer workflow (request → approve → transfer)
- Metadata preservation (reputation, warmup history, analytics, DKIM keys)
- Email account migration
- Transfer audit trail for compliance
- Rollback capability (24-hour window)
- Bulk transfer support (10+ domains)

## Business Impact

- Supports agency client offboarding
- Enables workspace consolidation
- Maintains historical data during transitions
- Provides flexibility for changing business relationships

## Dependencies

- Multi-tenant architecture (✅ implemented)
- Domain reputation system (✅ implemented)
- Audit logging system
