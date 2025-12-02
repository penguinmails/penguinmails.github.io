
# CORE-2.1: Install and Configure Drizzle ORM

**Ticket ID:** CORE-2.1  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install the necessary Drizzle packages (`drizzle-orm`, `drizzle-kit`, `pg`). Create the Drizzle config file and a reusable database client instance for the application to use.

## Context

According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), PenguinMails uses:

- **PostgreSQL** as the primary database
- **Drizzle ORM** for type-safe database interactions
- **Multi-tenant architecture** with row-level security (RLS)

Drizzle ORM provides type-safe database queries and migrations, which is essential for maintaining data integrity in a multi-tenant system.

## Acceptance Criteria

1. ✅ All Drizzle packages are listed in `package.json`:
   - `drizzle-orm`
   - `drizzle-kit`
   - `pg` (PostgreSQL client)
   - `@types/pg` (TypeScript types)
2. ✅ A `drizzle.config.ts` file is created and configured to read the `DATABASE_URL` from environment variables
3. ✅ A file exists at `/lib/db/index.ts` that exports a single, reusable Drizzle client instance
4. ✅ The database client can be imported and used in other parts of the application
5. ✅ Connection pooling is configured appropriately

## Technical Details

### Required Packages

```json
{
  "dependencies": {
    "drizzle-orm": "^latest",
    "pg": "^latest"
  },
  "devDependencies": {
    "drizzle-kit": "^latest",
    "@types/pg": "^latest"
  }
}
```

### Configuration Structure

```typescript
// drizzle.config.ts
import type { Config } from 'drizzle-kit';

export default {
  schema: './lib/db/schema',
  out: './migrations',
  driver: 'pg',
  dbCredentials: {
    connectionString: process.env.DATABASE_URL!,
  },
} satisfies Config;
```

### Database Client

```typescript
// lib/db/index.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

export const db = drizzle(pool);
```

## Implementation Notes

- Use connection pooling for better performance
- Ensure the database client is a singleton to avoid multiple connections
- Configure appropriate connection pool settings (max connections, idle timeout)
- Set up proper error handling for database connection failures
- Consider adding connection health checks

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Database architecture
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture overview
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide) - OLTP database tier specifications
- [Connection Pooling Strategy](../../docs/implementation-technical/database-infrastructure/connection-pooling-strategy) - Database connection management
- [Database Operations Guide](../../operations_runbooks/database_operations_guide) - Database management

## Dependencies

- **CORE-1.5** - Environment variables must be set up (DATABASE_URL)
- **CORE-1.1** - Next.js project must be initialized

## Testing

- [ ] Verify Drizzle packages are installed correctly
- [ ] Test that the database client can be imported without errors
- [ ] Verify the connection string is read from environment variables
- [ ] Test database connection (if database is available)
- [ ] Verify connection pooling is configured
