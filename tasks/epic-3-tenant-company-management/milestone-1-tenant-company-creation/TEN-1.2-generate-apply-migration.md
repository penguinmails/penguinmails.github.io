# TEN-1.2: Generate and Apply companies Migration

**Ticket ID:** TEN-1.2  
**Milestone:** 1 - Tenant and Company Creation  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Use the Drizzle Kit CLI to generate a new migration file that adds the `companies` table to the database. Apply this migration.

## Context

Database migrations ensure schema changes are version-controlled and can be applied consistently across environments. This migration will add the companies table that was defined in TEN-1.1, establishing the foundation for workspace management.

## Acceptance Criteria

1. ✅ Running `npm run db:generate` creates a new SQL migration file for the `companies` table
2. ✅ The migration file includes:
   - CREATE TABLE statement for `companies`
   - Foreign key constraint to `tenants` table
   - Unique constraint on `workspace_name`
   - All columns with correct types and defaults
3. ✅ After running `npm run db:migrate`, the table exists in the PostgreSQL database
4. ✅ The migration can be applied without errors
5. ✅ The table structure matches the schema definition from TEN-1.1

## Technical Details

### Migration Generation

```bash
npm run db:generate
```

This should create a new migration file in the `/migrations` folder, e.g.:

```txt
/migrations
  └── 0002_add_companies.sql
```

### Migration Application

```bash
npm run db:migrate
```

### Expected Migration Content

The migration should include:

- CREATE TABLE statement
- PRIMARY KEY constraint on `id`
- FOREIGN KEY constraint to `tenants.id` with CASCADE delete
- UNIQUE constraint on `workspace_name`
- DEFAULT values for timestamp columns
- NOT NULL constraints on required fields

## Implementation Notes

- Verify the generated SQL matches the schema definition
- Test the migration on a clean database first
- Ensure the migration is idempotent (can be run multiple times safely)
- Document any manual steps required (if any)
- Consider adding rollback migration (future enhancement)
- Verify indexes are created if specified in schema

## Related Documentation

- [Database Operations Guide](../../operations_runbooks/database_operations_guide) - Migration procedures
- [Migration & Deployment Guide](../../operations_runbooks/migration_deployment_guide) - Deployment workflows

## Dependencies

- **TEN-1.1** - Companies schema must be defined
- **CORE-2.3** - Migration generation script must be working (from Epic 1)
- **CORE-2.4** - Migration application script must be working (from Epic 1)

## Testing

- [ ] Run `npm run db:generate` and verify migration file is created
- [ ] Review the generated SQL for correctness
- [ ] Run `npm run db:migrate` and verify it executes without errors
- [ ] Verify the table exists in the database
- [ ] Check that all columns, constraints, and defaults are correct
- [ ] Test that the migration can be applied to a fresh database
- [ ] Verify foreign key relationship works correctly
- [ ] Verify unique constraint on workspace_name works
