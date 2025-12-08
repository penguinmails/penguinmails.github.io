
# INFRA-2.2: Implement "Upsert" Logic for smtp_ip_addresses

**Ticket ID:** INFRA-2.2  
**Milestone:** Milestone 2 - Infrastructure State Synchronization  
**Priority:** Medium  
**Status:** Not Started

## Description

Create `syncSmtpIps(ipArray)` in `/lib/services/infra.service.ts` that accepts IP objects (optionally fetched per VPS) and performs upserts into `smtp_ip_addresses`. Ensure `vps_instance_id` foreign key is correctly linked.

## Acceptance Criteria

1. [ ] Inserts new IP address records when they don't exist.
2. [ ] Updates existing IP address records when they do.
3. [ ] Ensures `vps_instance_id` is correctly linked and indexed.

## Notes

- You may need an additional Hostwind API call to fetch IPs per VPS.
- Ensure IP uniqueness constraints (e.g., unique on provider IP ID or address + vps id).

## Dependencies

- [INFRA-1.1](/docs/features/infrastructure/tasks/INFRA-1.1-define-drizzle-schemas-for-infrastructure) - SMTP IP addresses schema must be defined
- [INFRA-1.2](/docs/features/infrastructure/tasks/INFRA-1.2-generate-and-apply-infrastructure-migrations) - Infrastructure tables must exist in database
- [INFRA-2.1](/docs/features/infrastructure/tasks/INFRA-2.1-implement-upsert-logic-for-vps_instances) - VPS upsert logic must be implemented (for reference pattern)
- [INFRA-1.4](/docs/features/infrastructure/tasks/INFRA-1.4-create-a-secure-hostwind-api-client-service) - Hostwind API client must be available
- [CORE-2.1](/docs/features/core/tasks/CORE-2.1-install-configure-drizzle) - Drizzle ORM must be configured

## Related documentation

- [Technical Architecture — Overview](/docs/technical/architecture/overview)
- [Development Standards (DB operations & indexing)](/docs/implementation-technical/development-guidelines/development-standards)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
