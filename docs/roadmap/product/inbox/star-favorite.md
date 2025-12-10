---
title: "Star/Favorite Feature"
description: "Enable users to star/favorite important threads for quick access"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Star/Favorite Feature

## Overview

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 2-3 days (depends on Stalwart spike)

**Description**:
Enable users to star/favorite important threads for quick access, helping sales reps prioritize hot leads and urgent follow-ups.

## Acceptance Criteria

- Add `is_starred` field to thread storage
- Implement star/unstar API endpoint
- Add star icon to thread list UI with toggle
- Create "Starred" inbox view
- Add keyboard shortcut (e.g., "s" key)
- Persist star state across sessions

## Dependencies

- Stalwart Investigation
- Email Threading
