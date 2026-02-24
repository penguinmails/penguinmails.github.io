import { relations } from 'drizzle-orm';
import { index, pgTable, primaryKey, text, timestamp, uuid } from 'drizzle-orm/pg-core';
import { tenants } from '@/lib/db/schema/tenants';
import { users } from '@/lib/db/schema/users';

export const tenantUsers = pgTable(
  'tenant_users',
  {
    tenantId: uuid('tenant_id')
      .notNull()
      .references(() => tenants.id, { onDelete: 'cascade' }),
    userId: uuid('user_id')
      .notNull()
      .references(() => users.id, { onDelete: 'cascade' }),
    roles: text('roles').array().notNull().default(['member']),
    email: text('email'),
    created: timestamp('created', { withTimezone: true }).defaultNow().notNull(),
    updated: timestamp('updated', { withTimezone: true }).defaultNow().notNull(),
    deleted: timestamp('deleted', { withTimezone: true }),
  },
  table => [
    primaryKey({ columns: [table.tenantId, table.userId] }),
    index('tenant_users_tenant_id_idx').on(table.tenantId),
    index('tenant_users_user_id_idx').on(table.userId),
  ]
);

export const tenantUsersRelations = relations(tenantUsers, ({ one }) => ({
  tenant: one(tenants, {
    fields: [tenantUsers.tenantId],
    references: [tenants.id],
  }),
  user: one(users, {
    fields: [tenantUsers.userId],
    references: [users.id],
  }),
}));
