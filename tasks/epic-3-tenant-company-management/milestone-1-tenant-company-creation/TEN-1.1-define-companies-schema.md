# TEN-1.1: Define Drizzle Schema for companies

**Ticket ID:** TEN-1.1  
**Milestone:** 1 - Tenant and Company Creation  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create a new file for the `companies` table. Define the schema according to the ERD, including fields like name, workspace_name (for URL slug), and logo_url. Establish a foreign key relationship to the tenants table.

## Context

Companies (Workspaces) are the primary organizational unit within a tenant. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), PenguinMails uses:
- **Multi-tenant architecture** with complete data isolation
- **Workspace management** for organizing resources

The [Features & Capabilities](../../docs/features-capabilities/index.md) document outlines agency-focused features where companies represent client workspaces that agencies manage.

## Acceptance Criteria

1. ✅ A `companies.ts` schema file is created in `/lib/db/schema`
2. ✅ The schema correctly defines all columns, types, and constraints:
   - `id` (UUID, primary key)
   - `tenant_id` (UUID, foreign key to tenants.id)
   - `name` (varchar, not null)
   - `workspace_name` (varchar, unique, for URL slug)
   - `logo_url` (varchar, optional)
   - `created_at` (timestamp)
   - `updated_at` (timestamp)
3. ✅ A `tenant_id` foreign key correctly references `tenants.id`
4. ✅ A unique constraint ensures `workspace_name` is unique across all companies
5. ✅ The schema is exported and can be imported in other files

## Technical Details

### Schema Structure

```typescript
// lib/db/schema/companies.ts
import { pgTable, uuid, varchar, timestamp } from 'drizzle-orm/pg-core';
import { tenants } from './tenants';

export const companies = pgTable('companies', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: uuid('tenant_id')
    .notNull()
    .references(() => tenants.id, { onDelete: 'cascade' }),
  name: varchar('name', { length: 255 }).notNull(),
  workspaceName: varchar('workspace_name', { length: 100 })
    .notNull()
    .unique(), // URL-friendly slug, unique across all companies
  logoUrl: varchar('logo_url', { length: 500 }), // Optional logo URL
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

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

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Multi-tenant architecture
- [Features & Capabilities](../../docs/features-capabilities/index.md) - Workspace management

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


