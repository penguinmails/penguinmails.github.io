
# INFRA-1.1: Define Drizzle Schemas for Infrastructure

**Ticket ID:** INFRA-1.1  
**Milestone:** Milestone 1 - Database Schema and Hostwind API Client  
**Priority:** Medium  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create schema files for `vps_instances` and `smtp_ip_addresses`. Include status, region, provider-specific ID fields, and foreign key relationships according to the ERD.

## Acceptance Criteria

1. [ ] `vps_instances.ts` and `smtp_ip_addresses.ts` schema files are created.
2. [ ] The schemas correctly define all columns and types.
3. [ ] The foreign key relationship between `smtp_ip_addresses.vps_instance_id` and `vps_instances.id` is defined.

## Implementation Notes

- Use Drizzle's schema helpers and types already used in the project.
- Add provider ID fields such as `hostwinds_instance_id` and `hostwinds_ip_id`.
- Add status fields (e.g., `status`, `ip_status`) and region/location fields.

## Dependencies

- [CORE-2.1](/docs/features/core/tasks/CORE-2.1-install-configure-drizzle) - Drizzle ORM must be configured
- [CORE-2.2](/docs/features/core/tasks/CORE-2.2-define-initial-schemas) - Initial schemas must be defined (for reference patterns)

## Related documentation

- [Technical Architecture — Overview](/docs/technical/architecture/overview)
- [Development Standards (coding, linting, CI)](/docs/implementation-technical/development-guidelines/development-standards)
- [Quick Setup / Getting Started](/docs/quick-setup)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
