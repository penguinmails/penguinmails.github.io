
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

## Dependencies

- [INFRA-2.1](/docs/features/infrastructure/tasks/INFRA-2.1-implement-upsert-logic-for-vps_instances) - VPS sync function must be implemented
- [INFRA-2.2](/docs/features/infrastructure/tasks/INFRA-2.2-implement-upsert-logic-for-smtp_ip_addresses) - SMTP IP sync function must be implemented
- [CORE-1.5](/docs/features/core/tasks/CORE-1.5-setup-environment-variables) - Environment variables must be configured (for cron secret)
- [CORE-1.1](/docs/features/core/tasks/CORE-1.1-initialize-nextjs-project) - Next.js API routes must be available

## Related documentation

- [Operations: Infrastructure Operations Management](/docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Development Standards (API routes & secrets)](/docs/implementation-technical/development-guidelines/development-standards)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
