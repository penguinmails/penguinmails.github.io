---
title: "Stalwart Mail Server Database Schema Investigation"
description: "Investigate Stalwart schema integration for inbox features"
last_modified_date: "2025-12-09"
level: "3"
persona: "Engineering Teams"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Stalwart Mail Server Database Schema Investigation

## Overview

**Priority**: P0 (Critical Blocker)
**Timeline**: Q4 2025
**Effort**: 3-5 days (spike)

**Description**:
The current inbox documentation proposes custom tables without investigating how they integrate with Stalwart Mail Server's existing PostgreSQL schema.

**Problem**:
We need to determine if we can extend Stalwart's schema or if we need a separate metadata layer.

## Spike Goals

- Review Stalwart documentation and analyze email storage tables
- Determine if we can extend Stalwart's schema with custom fields
- Evaluate 4 architecture options (extend Stalwart, OLTP metadata, Content DB metadata, hybrid)
- Create proof-of-concept to validate chosen approach
- Update documentation with correct schema design

## Business Impact

- **Blocks**: All inbox development (threading, star/favorite, folders)
- Ensures scalable and maintainable architecture

## Dependencies

- None (This is the blocker)
