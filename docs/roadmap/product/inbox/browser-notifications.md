---
title: "Browser Notifications Integration"
description: "Integrate inbox messages with browser notifications"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Browser Notifications Integration

## Overview

**Priority**: P2 (MVP Nice-to-Have)
**Timeline**: Q1 2026
**Effort**: 1-2 days (integration only)

**Description**:
Integrate inbox messages with the existing Notifications Database to enable browser notifications for new replies.

## Acceptance Criteria

- Request browser notification permission on first inbox visit
- Create notification when new reply arrives (sender, subject, preview)
- Link notification click to specific thread
- Allow users to configure notification preferences
- Respect "Do Not Disturb" hours (user-configurable)
- Reuse existing `notifications` table

## Dependencies

- None (Notifications DB schema already exists)
