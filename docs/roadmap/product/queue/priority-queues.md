---
title: "Priority Queues"
description: "VIP lane for transactional and high-priority emails"
---

# Priority Queues

## Overview

**Priority**: P2 (Post-MVP)
**Effort**: Medium (2 weeks)
**Timeline**: Q3 2026

**Description**:
Implementation of priority lanes to ensure transactional emails are not blocked by bulk marketing campaigns.

**Acceptance Criteria**:

- Priority levels (Critical, High, Normal, Low)
- Dedicated workers for Critical/High queues
- Preemption logic (pause low priority if high priority backlog grows)
- Priority assignment rules (by campaign type, customer tier)

**Dependencies**:

- Queue System MVP
