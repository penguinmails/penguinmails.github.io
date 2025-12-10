---
title: "Multi-Language Support & Translation"
description: "Integrate translation API to automatically detect and translate non-English emails"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Multi-Language Support & Translation

## Overview

**Priority**: P2 (Global Expansion)
**Timeline**: Q3 2026
**Effort**: 1-2 weeks

**Description**:
Integrate translation API (Google Translate or DeepL) to automatically detect and translate non-English emails.

## Use Case

A German prospect replies in German. The system detects language and shows English translation below the original message.

## Acceptance Criteria

- Integrate translation API (Google Translate or DeepL)
- Add `detected_language` field to message storage
- Display original + translated text in UI
- Support 10+ major languages
- Add language filter to inbox views

## Dependencies

- Unified Inbox MVP completion
