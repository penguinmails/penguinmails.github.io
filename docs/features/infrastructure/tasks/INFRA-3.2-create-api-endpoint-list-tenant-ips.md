
# INFRA-3.2: Create API Endpoint to List Tenant's Assigned IPs (GET /api/infrastructure/ips)

**Ticket ID:** INFRA-3.2  
**Milestone:** Milestone 3 - Internal API for Infrastructure Visibility  
**Priority:** Medium  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/infrastructure/ips/route.ts`. The endpoint should query the local database (not Hostwind) to find IPs assigned to the domains of the currently authenticated tenant.

## Acceptance Criteria

1. [ ] Endpoint is protected by Nile middleware.
2. [ ] Performs a Drizzle JOIN across `domains`, `domain_ip_assignments`, and `smtp_ip_addresses`.
3. [ ] Filters results by `tenantId` from Nile session context.
4. [ ] Returns `200 OK` with an array of assigned IP addresses and their statuses.

## Notes

- Make sure tenant scoping is enforced at the DB query layer.
- Return only non-sensitive fields the frontend needs (e.g., ip address, status, assigned_domain).

## Dependencies

- [INFRA-3.1](/docs/features/infrastructure/tasks/INFRA-3.1-define-drizzle-schema-for-domain_ip_assignments) - Domain IP assignments schema must be defined
- [INFRA-1.2](/docs/features/infrastructure/tasks/INFRA-1.2-generate-and-apply-infrastructure-migrations) - Infrastructure tables must exist
- [CORE-3.2](/docs/features/authentication/tasks/CORE-3.2-implement-middleware) - Nile middleware must be implemented
- [CORE-2.1](/docs/features/core/tasks/CORE-2.1-install-configure-drizzle) - Drizzle ORM must be configured

## Related documentation

- [Technical Architecture — Overview](/docs/technical/architecture/overview)
- [Development Standards (API design & multi-tenant scoping)](/docs/implementation-technical/development-guidelines/development-standards)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
