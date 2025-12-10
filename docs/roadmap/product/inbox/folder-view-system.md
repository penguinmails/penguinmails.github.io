---
title: "Folder/View System"
description: "Implement standard inbox folder/view system (All, Starred, Sent, Archived, Trash)"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Folder/View System

## Overview

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 3-5 days (depends on Stalwart spike)

**Description**:
Implement standard inbox folder/view system (All, Starred, Sent, Archived, Trash) to organize threads like Gmail and Outlook.

## Acceptance Criteria

- Add `folder` field to thread storage
- Implement folder navigation in inbox sidebar
- Create API endpoints for moving threads between folders
- Add "Archive" and "Delete" actions with bulk support
- Implement soft delete (trash folder, permanent delete after 30 days)
- Add keyboard shortcuts (e: archive, #: delete)
- Add "Undo" functionality

## Dependencies

- Stalwart Investigation
- Email Threading
