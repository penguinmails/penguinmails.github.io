
# INFRA-1.2: Generate and Apply Infrastructure Migrations

**Ticket ID:** INFRA-1.2  
**Milestone:** Milestone 1 - Database Schema and Hostwind API Client  
**Priority:** Medium  
**Status:** Not Started

## Description

Use the Drizzle Kit CLI to generate a new migration that adds `vps_instances` and `smtp_ip_addresses` tables to the database. Apply the migration to the development database.

## Acceptance Criteria

1. [ ] Running `npm run db:generate` creates a new SQL migration for the two infrastructure tables.
2. [ ] After running `npm run db:migrate`, the tables exist in the PostgreSQL database.

## Notes

- Ensure migration filenames follow the project's conventions.
- Add a brief migration README comment if project policy requires it.

## Dependencies

- [INFRA-1.1](/docs/features/infrastructure/tasks/INFRA-1.1-define-drizzle-schemas-for-infrastructure) - Infrastructure schemas must be defined
- [CORE-2.3](/docs/features/core/tasks/CORE-2.3-generate-first-migration) - Migration process must be established
- [CORE-2.4](/docs/features/core/tasks/CORE-2.4-implement-migration-script) - Migration scripts must be implemented

## Related documentation

- [Development Standards (migrations & DB conventions)](/docs/implementation-technical/development-guidelines/development-standards)
- [Technical Architecture — Overview](/docs/technical/architecture/overview)

---

## Cross-References

- **Routes**: [infrastructure-ssh-access.md]()
- **API**: [hostwinds/](/docs/implementation-technical/api/hostwinds/)
