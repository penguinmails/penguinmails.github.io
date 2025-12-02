
# AUTH-3.2: Generate and Apply user_preferences Migration

**Ticket ID:** AUTH-3.2  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Use the Drizzle Kit CLI to generate a new migration file that adds the `user_preferences` table to the database. Apply this migration.

## Context

Database migrations ensure schema changes are version-controlled and can be applied consistently across environments (development, staging, production). This migration will add the user preferences table that was defined in AUTH-3.1.

## Acceptance Criteria

1. ✅ Running `npm run db:generate` creates a new SQL migration file for the `user_preferences` table
2. ✅ The migration file includes:
   - CREATE TABLE statement for `user_preferences`
   - Foreign key constraint to `users` table
   - Unique constraint on `user_id`
   - All columns with correct types and defaults
3. ✅ After running `npm run db:migrate`, the table exists in the PostgreSQL database
4. ✅ The migration can be applied without errors
5. ✅ The table structure matches the schema definition from AUTH-3.1

## Technical Details

### Migration Generation

```bash
npm run db:generate
```

This should create a new migration file in the `/migrations` folder, e.g.:

```txt
/migrations
  └── 0001_add_user_preferences.sql
```

### Migration Application

```bash
npm run db:migrate
```

### Expected Migration Content

The migration should include:

- CREATE TABLE statement
- PRIMARY KEY constraint
- FOREIGN KEY constraint to users.id
- UNIQUE constraint on user_id
- DEFAULT values for all preference fields
- Timestamp columns with default NOW()

## Implementation Notes

- Verify the generated SQL matches the schema definition
- Test the migration on a clean database first
- Ensure the migration is idempotent (can be run multiple times safely)
- Document any manual steps required (if any)
- Consider adding rollback migration (future enhancement)

## Related Documentation

- [Database Operations Guide](../../operations_runbooks/database_operations_guide) - Migration procedures
- [Migration & Deployment Guide](../../operations_runbooks/migration_deployment_guide) - Deployment workflows

## Dependencies

- **AUTH-3.1** - User preferences schema must be defined
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
