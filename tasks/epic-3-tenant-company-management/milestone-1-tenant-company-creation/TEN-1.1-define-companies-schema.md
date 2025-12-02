
# TEN-1.1: Define Drizzle Schema for companies

**Ticket ID:** TEN-1.1  
**Milestone:** 1 - Tenant and Company Creation  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create a new file for the `companies` table. Define the schema according to the ERD, including fields like name, workspace_name (for URL slug), and logo_url. Establish a foreign key relationship to the tenants table.

## Context

Companies (Workspaces) are the primary organizational unit within a tenant. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), PenguinMails uses:

- **Multi-tenant architecture** with complete data isolation
- **Workspace management** for organizing resources

The [Features & Capabilities](../../docs/features-capabilities/index) document outlines agency-focused features where companies represent client workspaces that agencies manage.

## Acceptance Criteria

1. ✅ A `companies.ts` schema file is created in `/lib/db/schema`
2. ✅ The schema correctly defines all columns, types, and constraints:
   - `id` (UUID, primary key)
   - `tenant_id` (UUID, foreign key to tenants.id, ON DELETE CASCADE)
   - `name` (VARCHAR(100), not null)
   - `workspace_name` (VARCHAR(255), unique, for URL slug)
   - `logo_url` (TEXT, optional)
   - `status` (VARCHAR(20), default 'active')
   - `created` (TIMESTAMP WITH TIME ZONE, default NOW())
   - `updated` (TIMESTAMP WITH TIME ZONE, default NOW())
3. ✅ A `tenant_id` foreign key correctly references `tenants.id`
4. ✅ A unique constraint ensures `workspace_name` is unique across all companies
5. ✅ The schema is exported and can be imported in other files

## Technical Details

### Schema Structure

```typescript
// lib/db/schema/companies.ts
import { pgTable, uuid, varchar, text, timestamp } from 'drizzle-orm/pg-core';
import { tenants } from './tenants';

export const companies = pgTable('companies', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => tenants.id, { onDelete: 'cascade' }),
  name: varchar('name', { length: 100 }).notNull(),
  workspaceName: varchar('workspace_name', { length: 255 })
    .unique(), // URL-friendly slug, unique across all companies
  logoUrl: text('logo_url'), // Optional logo URL (TEXT for flexibility)
  status: varchar('status', { length: 20 }).default('active').notNull(),
  created: timestamp('created', { withTimezone: true }).defaultNow().notNull(),
  updated: timestamp('updated', { withTimezone: true }).defaultNow().notNull(),
});
```

**Note:** Match the exact schema from the [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide.md#companies---tenant-workspaces). The schema uses:

- `created` and `updated` (not `created_at`/`updated_at`)
- `status` field with default 'active'
- TEXT type for `logo_url` (not VARCHAR)

### Constraints

- **Primary Key:** `id` (UUID)
- **Foreign Key:** `tenant_id` → `tenants.id` (with cascade delete)
- **Unique:** `workspace_name` (must be unique across all companies)
- **Required:** `name`, `tenant_id`, `workspace_name`
- **Optional:** `logo_url`

## Implementation Notes

- Use UUID for primary key to match tenants table
- Use `onDelete: 'cascade'` to automatically delete companies when tenant is deleted
- Ensure `workspace_name` is URL-friendly (lowercase, no spaces, alphanumeric + hyphens)
- Consider adding an index on `tenant_id` for query performance
- Consider adding an index on `workspace_name` for lookup performance
- Document the workspace_name format requirements

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Multi-tenant architecture
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide) - **Primary reference** for companies table structure and OLTP design patterns
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture overview
- [Features & Capabilities](../../docs/features-capabilities/index) - Workspace management

## Dependencies

- **CORE-2.2** - Tenants table schema must be defined (from Epic 1)
- **CORE-2.1** - Drizzle ORM must be configured

## Testing

- [ ] Verify schema file is created in correct location
- [ ] Test that schema can be imported without TypeScript errors
- [ ] Verify foreign key relationship is correctly defined
- [ ] Verify unique constraint on workspace_name
- [ ] Check that required fields are marked as not null
- [ ] Verify cascade delete behavior (when tenant is deleted)
- [ ] Test that optional fields (logo_url) can be null
