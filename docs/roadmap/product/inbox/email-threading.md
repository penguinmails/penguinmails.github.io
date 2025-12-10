---
title: "Email Threading Algorithm Implementation"
description: "Implement email threading to correctly associate replies with original messages"
last_modified_date: "2025-12-09"
level: "3"
persona: "Engineering Teams"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Email Threading Algorithm Implementation

## Overview

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 1-2 weeks (depends on Stalwart spike)

**Description**:
Implement email threading to correctly associate replies with original outbound messages and campaigns using RFC 5322 headers (References, In-Reply-To) with fallback logic.

## Acceptance Criteria

- Match replies using standard email headers
- Fallback to Subject + Contact matching
- Handle edge cases (forwarded emails, subject changes)
- Create database schema based on spike architecture decision
- Test threading accuracy with 100+ real-world samples

## Dependencies

- Stalwart Database Schema Investigation
