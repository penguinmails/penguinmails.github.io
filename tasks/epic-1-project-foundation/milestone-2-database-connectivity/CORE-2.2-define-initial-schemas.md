# CORE-2.2: Define Initial Drizzle Schemas

**Ticket ID:** CORE-2.2  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create the schema definition files in a `/lib/db/schema` directory. Define the `users`, `tenants`, and `tenant_users` tables in TypeScript, meticulously matching the ERD.

## Context

According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), PenguinMails uses a **multi-tenant architecture** with:
- **Data Isolation:** Each tenant has dedicated database schemas with row-level security
- **Tenant Management:** Core tables include users, tenants, and tenant_users for multi-tenancy

The [Team Workflow](../../docs/quick-access/team-workflow.md) document outlines the staff hierarchy system that these schemas will support.

## Acceptance Criteria

1. ✅ Schema files (`users.ts`, `tenants.ts`, `tenant_users.ts`) exist in `/lib/db/schema` directory
2. ✅ The TypeScript code correctly defines all columns, types (varchar, uuid, timestamps, etc.), and relations for the initial tables
3. ✅ All tables include proper indexes for performance
4. ✅ Foreign key relationships are properly defined
5. ✅ Schema definitions match the ERD specifications
6. ✅ An `index.ts` file exports all schemas for easy importing

## Technical Details

### Core Tables Structure

#### Users Table
- `id` (UUID, primary key)
- `email` (varchar, unique, not null)
- `name` (varchar)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### Tenants Table
- `id` (UUID, primary key)
- `name` (varchar, not null)
- `slug` (varchar, unique)
- `created_at` (timestamp)
- `updated_at` (timestamp)

#### Tenant Users Table (Join Table)
- `id` (UUID, primary key)
- `tenant_id` (UUID, foreign key to tenants)
- `user_id` (UUID, foreign key to users)
- `role` (varchar) - supports: owner, admin, member, viewer
- `created_at` (timestamp)
- `updated_at` (timestamp)
- Unique constraint on (tenant_id, user_id)

### Schema File Structure

```typescript
// lib/db/schema/users.ts
import { pgTable, uuid, varchar, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  name: varchar('name', { length: 255 }),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

## Implementation Notes

- Use Drizzle's type-safe column definitions
- Include proper indexes on foreign keys and frequently queried columns
- Use UUIDs for primary keys (better for multi-tenant systems)
- Include `created_at` and `updated_at` timestamps on all tables
- Define relationships using Drizzle's relations API
- Consider adding soft delete support (for GDPR compliance - future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Multi-tenant architecture
- [Team Workflow](../../docs/quick-access/team-workflow.md) - Role-based access control
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards.md) - Data protection requirements

## Dependencies

- **CORE-2.1** - Drizzle ORM must be installed and configured

## Testing

- [ ] Verify all schema files are created in the correct directory
- [ ] Test that schemas can be imported without TypeScript errors
- [ ] Verify column types match ERD specifications
- [ ] Check that foreign key relationships are properly defined
- [ ] Validate that indexes are created for performance-critical columns


