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

## Related documentation

- [Development Standards (migrations & DB conventions)](../../docs/implementation-technical/development-guidelines/development-standards.md)
- [Technical Architecture — Overview](../../docs/technical/architecture/overview.md)
