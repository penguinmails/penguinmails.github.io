
# CORE-2.3: Generate First Database Migration

**Ticket ID:** CORE-2.3  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Use the Drizzle Kit CLI command to compare the defined schemas against the (empty) database and generate the initial SQL migration file.

## Context

Database migrations are essential for version control of database schema changes. This migration will create the foundational tables for the multi-tenant architecture.

## Acceptance Criteria

1. ✅ An `npm run db:generate` script is added to `package.json`
2. ✅ Running this script creates a new `.sql` file in a `/migrations` folder
3. ✅ The migration file contains `CREATE TABLE` statements for:
   - `users` table
   - `tenants` table
   - `tenant_users` table
4. ✅ The migration file includes proper indexes and constraints
5. ✅ The migration file is properly formatted and readable

## Technical Details

### Package.json Script

```json
{
  "scripts": {
    "db:generate": "drizzle-kit generate:pg"
  }
}
```

### Migration File Location

```txt
/migrations
  └── 0000_initial_schema.sql
```

### Expected Migration Content

The migration should include:

- CREATE TABLE statements with all columns
- PRIMARY KEY constraints
- FOREIGN KEY constraints
- UNIQUE constraints
- INDEX definitions
- Proper data types and defaults

## Implementation Notes

- Use Drizzle Kit's migration generation command
- Ensure the migration folder is created if it doesn't exist
- Verify the generated SQL is correct and matches the schema definitions
- Consider adding a migration naming convention (e.g., timestamp-based or sequential)
- Document any manual steps required for the migration

## Related Documentation

- [Database Operations Guide](../../operations_runbooks/database_operations_guide) - Migration procedures
- [Migration & Deployment Guide](../../operations_runbooks/migration_deployment_guide) - Deployment workflows
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide) - OLTP tier specifications

## Dependencies

- **CORE-2.1** - Drizzle ORM must be configured
- **CORE-2.2** - Schemas must be defined

## Testing

- [ ] Run `npm run db:generate` and verify it executes without errors
- [ ] Verify the migration file is created in the correct location
- [ ] Check that the SQL syntax is correct
- [ ] Verify all tables, columns, and constraints are included
- [ ] Test that running the script multiple times doesn't create duplicate migrations
