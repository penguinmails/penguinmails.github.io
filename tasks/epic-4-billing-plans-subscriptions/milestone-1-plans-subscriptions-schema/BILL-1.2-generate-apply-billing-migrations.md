# BILL-1.2: Generate and Apply Billing Migrations

**Ticket ID:** BILL-1.2  
**Milestone:** 1 - Plans and Subscriptions Schema Setup  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Use the Drizzle Kit CLI to generate a new migration file that adds the `plans`, `subscriptions`, and `tenant_config` tables to the database. Apply this migration.

## Context

Database migrations ensure schema changes are version-controlled and can be applied consistently across environments. This migration will add the three billing tables that were defined in BILL-1.1, establishing the foundation for subscription management.

## Acceptance Criteria

1. ✅ Running `npm run db:generate` creates a new SQL migration file for the three billing tables
2. ✅ The migration file includes:
   - CREATE TABLE statements for `plans`, `subscriptions`, and `tenant_config`
   - Foreign key constraints to `tenants` table
   - Unique constraints on appropriate columns
   - All columns with correct types and defaults
3. ✅ After running `npm run db:migrate`, all three tables exist in the PostgreSQL database
4. ✅ The migration can be applied without errors
5. ✅ The table structures match the schema definitions from BILL-1.1

## Technical Details

### Migration Generation

```bash
npm run db:generate
```

This should create a new migration file in the `/migrations` folder, e.g.:
```
/migrations
  └── 0003_add_billing_tables.sql
```

### Migration Application

```bash
npm run db:migrate
```

### Expected Migration Content

The migration should include:
- CREATE TABLE statements for all three tables
- PRIMARY KEY constraints
- FOREIGN KEY constraints to `tenants.id` with CASCADE delete
- UNIQUE constraints on:
  - `plans.name`
  - `subscriptions.stripe_subscription_id`
  - `tenant_config.tenant_id`
  - `tenant_config.stripe_customer_id`
- DEFAULT values for timestamp and boolean columns
- NOT NULL constraints on required fields

## Implementation Notes

- Verify the generated SQL matches all three schema definitions
- Test the migration on a clean database first
- Ensure the migration is idempotent (can be run multiple times safely)
- Document any manual steps required (if any)
- Consider adding rollback migration (future enhancement)
- Verify indexes are created if specified in schema

## Related Documentation

- [Database Operations Guide](../../operations_runbooks/database_operations_guide.md) - Migration procedures
- [Migration & Deployment Guide](../../operations_runbooks/migration_deployment_guide.md) - Deployment workflows

## Dependencies

- **BILL-1.1** - Billing schemas must be defined
- **CORE-2.3** - Migration generation script must be working (from Epic 1)
- **CORE-2.4** - Migration application script must be working (from Epic 1)

## Testing

- [ ] Run `npm run db:generate` and verify migration file is created
- [ ] Review the generated SQL for correctness (all three tables)
- [ ] Run `npm run db:migrate` and verify it executes without errors
- [ ] Verify all three tables exist in the database
- [ ] Check that all columns, constraints, and defaults are correct
- [ ] Test that the migration can be applied to a fresh database
- [ ] Verify foreign key relationships work correctly
- [ ] Verify unique constraints work correctly

