---
title: "Scheduled Sending"
description: "Enable users to schedule replies to send at a specific date/time"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Scheduled Sending

## Overview

**Priority**: P2 (Nice-to-Have)
**Timeline**: Q2 2026
**Effort**: 3-5 days

**Description**:
Enable users to schedule replies to send at a specific date/time, allowing sales reps to draft messages outside business hours.

## Use Case

Draft a reply at 11 PM but schedule it to send at 9 AM the next day during business hours.

## Acceptance Criteria

- Add `scheduled_send_at` field to message storage
- Create background job to process scheduled sends
- Add UI for scheduling (date/time picker, timezone selector)
- Allow editing/canceling scheduled messages
- Handle account unavailability gracefully
- Send confirmation notification when message is sent

## Dependencies

- Unified Inbox MVP completion
