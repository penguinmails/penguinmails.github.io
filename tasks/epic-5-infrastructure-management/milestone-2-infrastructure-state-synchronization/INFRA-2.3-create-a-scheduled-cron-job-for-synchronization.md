---
title: "INFRA-2.3: Create a Scheduled Cron Job for Synchronization"
description: "Documentation for INFRA-2.3: Create a Scheduled Cron Job for Synchronization - INFRA 2.3 Create A Scheduled Cron Job For Synchronization"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# INFRA-2.3: Create a Scheduled Cron Job for Synchronization

**Ticket ID:** INFRA-2.3  
**Milestone:** Milestone 2 - Infrastructure State Synchronization  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a protected API route (e.g., `/api/cron/sync-infra/route.ts`) that external schedulers (Vercel Cron, GitHub Actions) can trigger. The route should call `syncVpsInstances` and `syncSmtpIps` and return a summary of the sync.

## Acceptance Criteria

1. [ ] API route is created and protected (requires a secret Authorization header).
2. [ ] When triggered, it calls `syncVpsInstances` and `syncSmtpIps`.
3. [ ] Responds with `200 OK` and a JSON summary, e.g., `{ "syncedVps": 5, "syncedIps": 20 }`.

## Notes

- Keep the route idempotent and safe to run frequently.
- Consider runtime limits of the hosting provider and split tasks if necessary.

## Related documentation

- [Operations: Infrastructure Operations Management](../../docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Development Standards (API routes & secrets)](../../docs/implementation-technical/development-guidelines/development-standards)
