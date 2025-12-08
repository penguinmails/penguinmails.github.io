
# [LEADS-1.1] Define Contact Database Schema

## Description

Design and implement the Drizzle ORM schema for storing contacts, including support for custom attributes (JSONB) and tenant isolation.

## Acceptance Criteria

- [ ] `Contact` table created using Drizzle ORM schema definitions
- [ ] `List` table created for static segments
- [ ] `ContactList` join table created
- [ ] Tenant isolation enforced (all tables have `tenantId`)
- [ ] Migration file generated and applied

## Technical Details

```typescript
// db/schema/leads.ts
import { pgTable, uuid, varchar, jsonb, integer, timestamp } from 'drizzle-orm/pg-core';

export const contacts = pgTable('contacts', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: varchar('tenant_id').notNull(),
  email: varchar('email').notNull(),
  firstName: varchar('first_name'),
  lastName: varchar('last_name'),
  attributes: jsonb('attributes').$type<Record<string, any>>().default({}),
  status: varchar('status').notNull().default('active'), // active, unsubscribed, bounced
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const lists = pgTable('lists', {
  id: uuid('id').primaryKey().defaultRandom(),
  tenantId: varchar('tenant_id').notNull(),
  name: varchar('name').notNull(),
  type: varchar('type').notNull().default('static'), // static, dynamic
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

export const contactLists = pgTable('contact_lists', {
  contactId: uuid('contact_id').notNull().references(() => contacts.id),
  listId: uuid('list_id').notNull().references(() => lists.id),
  assignedAt: timestamp('assigned_at').defaultNow(),
});

// Composite primary key and indexes
export const contactListsPk = primaryKey({ columns: [contactLists.contactId, contactLists.listId] });
export const contactListsTenantIdx = index('contact_lists_tenant_idx').on(contactLists.contactId, contactLists.listId);
```

---

## Cross-References

- **Routes**: [tenant-leads.md]()
- **API**: [tenant-api/](/docs/implementation-technical/api/tenant-api/)
