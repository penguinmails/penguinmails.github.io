---
title: "MAIL-2.2: Implement the Worker's Main Loop"
description: "Documentation for MAIL-2.2: Implement the Worker's Main Loop - MAIL 2.2 Implement The Workers Main Loop"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# MAIL-2.2: Implement the Worker's Main Loop

**Ticket ID:** MAIL-2.2  
**Milestone:** Milestone 2 - The Email Sending Worker  
**Priority:** High  
**Status:** Not Started

## Description

In the worker's entry point, implement an infinite loop that uses the Redis `BRPOP` command to wait for and pull a single job from the `queue:email-sending` list. The loop should block until a job is available and then hand the job payload to the assembling/sending pipeline.

## Acceptance Criteria

1. [ ] The worker starts and logs `Waiting for jobs...`.
2. [ ] When a job is pushed to the Redis list, the worker immediately receives it and logs the payload.

## Notes

- Ensure graceful shutdown handling (SIGINT/SIGTERM) to avoid losing in-flight work.
- Consider concurrency models (single threaded event loop vs. worker pool) depending on throughput needs.

## Related documentation

- [Operations: Infrastructure Operations Management (queues & workers)](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Development Standards (background job patterns)](../../docs/implementation-technical/development-guidelines/development-standards)
