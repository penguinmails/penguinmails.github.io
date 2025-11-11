# MAIL-1.1: Define Drizzle Schemas for Email Pipeline

**Ticket ID:** MAIL-1.1  
**Milestone:** Milestone 1 - Job Enqueueing and Campaign Scheduling  
**Priority:** High  
**Status:** Not Started

## Description

Create/finalize the Drizzle schemas for `campaigns`, `leads`, `templates`, `email_accounts`, `campaign_sequence_steps`, `inbox_message_refs`, and `inbox_message_content`. Generate and apply the migrations.

## Acceptance Criteria

1. [ ] All required schema files exist in `/lib/db/schema`.
2. [ ] The schemas correctly define all columns, types, and relationships.
3. [ ] Running `npm run db:migrate` successfully creates all tables in the database.

## Notes

- Ensure foreign keys and indexes are added for efficient lookups by `tenant_id`, `campaign_id`, and `lead_id`.
- Reuse existing naming conventions used across the project.

## Related documentation

- [Technical Architecture — Overview](../../docs/technical/architecture/overview.md)
- [Development Standards (DB design & migrations)](../../docs/implementation-technical/development-guidelines/development-standards.md)