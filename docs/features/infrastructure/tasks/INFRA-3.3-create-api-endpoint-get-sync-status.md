
# INFRA-3.3: Create API Endpoint to Get Sync Status (GET /api/infrastructure/status)

**Ticket ID:** INFRA-3.3  
**Milestone:** Milestone 3 - Internal API for Infrastructure Visibility  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/infrastructure/status/route.ts` which reads the `infra_sync_status` record from `system_config` and returns it.

## Acceptance Criteria

1. [ ] Endpoint is protected.
2. [ ] Returns `200 OK` with the JSON object containing `last_successful_sync` and current `status`.
3. [ ] Frontend can use this data to surface a notice if the sync has been failing.

## Notes

- Keep the response strictly scoped to the data necessary for the UI.
- Consider caching this value or limiting heavy queries.

## Dependencies

- [INFRA-2.4](/docs/features/infrastructure/tasks/INFRA-2.4-implement-sync-status-tracking) - Sync status tracking must be implemented
- [CORE-3.2](/docs/features/authentication/tasks/CORE-3.2-implement-middleware) - Nile middleware must be implemented (for protection)
- [CORE-2.2](/docs/features/core/tasks/CORE-2.2-define-initial-schemas) - System config table must exist
- [CORE-1.1](/docs/features/core/tasks/CORE-1.1-initialize-nextjs-project) - Next.js API routes must be available

## Related documentation

- [Operations: Infrastructure Operations Management](/docs/operations-analytics/operations-management/infrastructure-operations-management)
- [Development Standards (API design & caching)](/docs/implementation-technical/development-guidelines/development-standards)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
