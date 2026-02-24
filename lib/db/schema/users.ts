import { index, pgTable, text, timestamp, uniqueIndex, uuid } from 'drizzle-orm/pg-core';

export const users = pgTable(
  'users',
  {
    id: uuid('id').primaryKey().defaultRandom(),
    email: text('email').notNull(),
    name: text('name'),
    familyName: text('family_name'),
    givenName: text('given_name'),
    picture: text('picture'),
    emailVerified: timestamp('email_verified', { withTimezone: true }),
    created: timestamp('created', { withTimezone: true }).defaultNow().notNull(),
    updated: timestamp('updated', { withTimezone: true }).defaultNow().notNull(),
    deleted: timestamp('deleted', { withTimezone: true }),
  },
  table => [
    uniqueIndex('users_email_unique_idx').on(table.email),
    index('users_email_idx').on(table.email),
  ]
);
