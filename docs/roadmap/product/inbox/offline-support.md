---
title: "Offline Support (IndexedDB)"
description: "Enable offline inbox access by caching recent threads and messages in IndexedDB"
last_modified_date: "2025-12-09"
level: "3"
persona: "Engineering Teams"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Offline Support (IndexedDB)

## Overview

**Priority**: P3 (Low Priority)
**Timeline**: Q3 2026
**Effort**: 3-5 days

**Description**:
Enable offline inbox access by caching recent threads and messages in IndexedDB.

## Use Case

Sales rep on a flight can read messages and draft replies offline, which sync automatically when reconnected.

## Acceptance Criteria

- Cache recent threads (last 100) in IndexedDB
- Cache messages for open threads
- Allow drafting replies offline
- Sync drafts to server when reconnected
- Show "Offline Mode" indicator in UI
- Handle conflicts (e.g., thread archived while offline)

## Dependencies

- Unified Inbox MVP completion
