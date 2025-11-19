---
title: "CORE-2.4: Implement Migration Application Script"
description: "Documentation for CORE-2.4: Implement Migration Application Script - CORE 2.4 Implement Migration Script"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# CORE-2.4: Implement Migration Application Script

**Ticket ID:** CORE-2.4  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a simple Node.js script that uses Drizzle's migrator function to apply any pending migrations from the `/migrations` folder to the database.

## Context

Automated migration application is essential for consistent database deployments across environments (development, staging, production). This script will be used in CI/CD pipelines and local development.

## Acceptance Criteria

1. ✅ An `npm run db:migrate` script is added to `package.json` that executes the migration script
2. ✅ After running the script, the `users`, `tenants`, and `tenant_users` tables physically exist in the PostgreSQL database
3. ✅ The script tracks which migrations have been applied (migration history)
4. ✅ The script can be run multiple times safely (idempotent)
5. ✅ The script provides clear output about which migrations were applied
6. ✅ The script handles errors gracefully with informative error messages

## Technical Details

### Migration Script Structure

```typescript
// scripts/migrate.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { migrate } from 'drizzle-orm/node-postgres/migrator';
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL!,
});

const db = drizzle(pool);

async function main() {
  console.log('Running migrations...');
  await migrate(db, { migrationsFolder: './migrations' });
  console.log('Migrations completed!');
  await pool.end();
}

main().catch((error) => {
  console.error('Migration failed:', error);
  process.exit(1);
});
```

### Package.json Script

```json
{
  "scripts": {
    "db:migrate": "tsx scripts/migrate.ts"
  }
}
```

## Implementation Notes

- Use Drizzle's built-in migrator function
- Ensure the script connects to the correct database (from DATABASE_URL)
- Add proper error handling and logging
- Consider adding a dry-run option for testing
- Implement migration rollback capability (future enhancement)
- Add migration status checking (which migrations are applied)

## Related Documentation

- [Database Operations Guide](../../operations_runbooks/database_operations_guide) - Migration procedures
- [Migration & Deployment Guide](../../operations_runbooks/migration_deployment_guide) - Deployment workflows
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide) - OLTP tier specifications

## Dependencies

- **CORE-2.1** - Drizzle ORM must be configured
- **CORE-2.3** - Migration file must be generated
- Database connection must be available

## Testing

- [ ] Run `npm run db:migrate` and verify it executes without errors
- [ ] Verify tables are created in the database
- [ ] Check that running the script multiple times doesn't cause errors
- [ ] Verify migration history is tracked correctly
- [ ] Test error handling (e.g., invalid connection string, missing migrations folder)
- [ ] Verify the script works with an empty database
- [ ] Test that the script can apply multiple migrations in order
