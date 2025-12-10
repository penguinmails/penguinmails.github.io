---
title: "Advanced Queue Management"
description: "Tools for managing active queues"
---

# Advanced Queue Management

## Overview

**Priority**: P2 (Post-MVP)
**Effort**: Medium (2 weeks)
**Timeline**: Q2 2026

**Description**:
Tools for managing active queues including pause/resume, purge, and job promotion.

**Acceptance Criteria**:

- Pause/Resume specific queues (e.g., pause marketing, keep transactional)
- Purge queue (remove all waiting jobs)
- Promote delayed jobs to active
- Retry all failed jobs in bulk
- Move jobs between queues
- Rate limit adjustment at runtime

**Dependencies**:

- Queue System MVP
- Queue Monitoring UI
