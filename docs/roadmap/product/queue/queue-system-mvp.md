---
title: "Queue System MVP"
description: "Basic Redis-backed queue for email delivery"
level: "2"
last_modified_date: "2026-02-24"
---

# Queue System MVP

## Overview

**Priority**: P0 (MVP blocker)
**Effort**: Medium (2-3 weeks)
**Timeline**: Q1 2026

**Description**:
Basic Redis-backed queue for reliable email delivery with retry logic.

**Acceptance Criteria**:

- Redis-based job queue (Redis worker queue implementation)
- Job persistence (ensure no data loss on restart)
- Basic retry logic (3 attempts with backoff)
- Concurrency control (limit workers per queue)
- Separate queues for transactional vs. marketing
- Dead letter queue for failed jobs

**Dependencies**:

- Redis infrastructure
- Worker service
