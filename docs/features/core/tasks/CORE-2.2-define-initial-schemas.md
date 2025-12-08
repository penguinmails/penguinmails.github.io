
# CORE-2.2: Define Initial Drizzle Schemas

**Ticket ID:** CORE-2.2  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create the schema definition files in a `/lib/db/schema` directory. Define the `users`, `tenants`, and `tenant_users` tables in TypeScript, meticulously matching the ERD.

## Context

According to the [High-Level Architecture](/docs/quick-access/high-level-architecture), PenguinMails uses a **multi-tenant architecture** with:

- **Data Isolation:** Each tenant has dedicated database schemas with row-level security
- **Tenant Management:** Core tables include users, tenants, and tenant_users for multi-tenancy

The [Team Workflow](/docs/quick-access/team-workflow) document outlines the staff hierarchy system that these schemas will support.

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

**Reference:** [OLTP Schema Guide - users table](/docs/implementation-technical/database-infrastructure/oltp-schema-guide#users---user-identity--profile)

- `id` (UUID, primary key)
- `email` (TEXT, unique, not null)
- `name` (TEXT)
- `family_name` (TEXT, optional)
- `given_name` (TEXT, optional)
- `picture` (TEXT, optional)
- `email_verified` (TIMESTAMP WITH TIME ZONE, optional)
- `created` (TIMESTAMP WITH TIME ZONE, default NOW())
- `updated` (TIMESTAMP WITH TIME ZONE, default NOW())
- `deleted` (TIMESTAMP WITH TIME ZONE, soft delete support)

**Note:** This table is NileDB-managed. Match the exact schema from the OLTP guide.

#### Tenants Table

**Reference:** [OLTP Schema Guide - tenants table](/docs/implementation-technical/database-infrastructure/oltp-schema-guide#tenants---tenant-organization)

- `id` (UUID, primary key)
- `name` (TEXT, not null)
- `created` (TIMESTAMP WITH TIME ZONE, default NOW())
- `updated` (TIMESTAMP WITH TIME ZONE, default NOW())
- `deleted` (TIMESTAMP WITH TIME ZONE, soft delete support)
- `compute_id` (UUID, optional, for infrastructure association)

**Note:** This table is NileDB-managed. Match the exact schema from the OLTP guide.

#### Tenant Users Table (Join Table)

**Reference:** [OLTP Schema Guide - tenant_users table](/docs/implementation-technical/database-infrastructure/oltp-schema-guide#tenant_users---multi-tenant-user-associations)

- `tenant_id` (UUID, foreign key to tenants, part of primary key)
- `user_id` (UUID, foreign key to users, part of primary key)
- `roles` (TEXT[], array of roles) - **NileDB-managed ARRAY, mandatory for authentication**
- `email` (TEXT, optional)
- `created` (TIMESTAMP WITH TIME ZONE, default NOW())
- `updated` (TIMESTAMP WITH TIME ZONE, default NOW())
- `deleted` (TIMESTAMP WITH TIME ZONE, soft delete support)
- Composite PRIMARY KEY (tenant_id, user_id)

**Note:** This table is NileDB-managed. The `roles` field is a TEXT array managed by NileDB for authentication.

### Schema File Structure

```typescript
// lib/db/schema/users.ts
import { pgTable, uuid, text, timestamp } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').primaryKey().defaultRandom(),
  email: text('email').notNull().unique(),
  name: text('name'),
  familyName: text('family_name'),
  givenName: text('given_name'),
  picture: text('picture'),
  emailVerified: timestamp('email_verified', { withTimezone: true }),
  created: timestamp('created', { withTimezone: true }).defaultNow().notNull(),
  updated: timestamp('updated', { withTimezone: true }).defaultNow().notNull(),
  deleted: timestamp('deleted', { withTimezone: true }), // Soft delete support
});
```

**Note:** This table is NileDB-managed. Use TEXT type (not VARCHAR) and match field names exactly (`created`/`updated`, not `created_at`/`updated_at`). See the [OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-schema-guide#users---user-identity--profile) for the complete schema.

## Implementation Notes

- Use Drizzle's type-safe column definitions
- Include proper indexes on foreign keys and frequently queried columns
- Use UUIDs for primary keys (better for multi-tenant systems)
- Use TEXT type (not VARCHAR) for string fields to match OLTP schema guide
- Use `created` and `updated` (not `created_at`/`updated_at`) to match OLTP naming conventions
- Use `TIMESTAMP WITH TIME ZONE` for all timestamp fields
- Include soft delete support via `deleted` timestamp field (for GDPR compliance)
- Define relationships using Drizzle's relations API
- Match the exact schema from the OLTP Schema Guide - these tables are NileDB-managed

## Related Documentation

- [High-Level Architecture](/docs/quick-access/high-level-architecture) - Multi-tenant architecture
- [OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-schema-guide) - **Primary reference** for users, tenants, and tenant_users table structures
- [Database Schema Guide](/docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture overview
- [Team Workflow](/docs/quick-access/team-workflow) - Role-based access control
- [Compliance & Regulatory Standards](/docs/quick-access/compliance-regulatory-standards) - Data protection requirements

## Dependencies

- [CORE-2.1](/docs/features/core/tasks/CORE-2.1-install-configure-drizzle) - Drizzle ORM must be installed and configured

## Testing

- [ ] Verify all schema files are created in the correct directory
- [ ] Test that schemas can be imported without TypeScript errors
- [ ] Verify column types match ERD specifications
- [ ] Check that foreign key relationships are properly defined
- [ ] Validate that indexes are created for performance-critical columns

---

## Related Documentation

- **Routes**: [core-app-structure](/docs/design/routes/core-app-structure)
- **API**: [API Reference](/docs/implementation-technical/api/README)
