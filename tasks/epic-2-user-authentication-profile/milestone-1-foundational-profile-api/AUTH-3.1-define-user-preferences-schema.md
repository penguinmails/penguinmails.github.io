---
title: "AUTH-3.1: Define Drizzle Schema for user_preferences"
description: "Documentation for AUTH-3.1: Define Drizzle Schema for user_preferences - AUTH 3.1 Define User Preferences Schema"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# AUTH-3.1: Define Drizzle Schema for user_preferences

**Ticket ID:** AUTH-3.1  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create a new file for the `user_preferences` table. Define the schema according to the ERD, including fields like theme, language, timezone, and notification settings. Establish a one-to-one foreign key relationship with the users table.

## Context

User preferences allow users to customize their experience within PenguinMails. According to the [Features & Capabilities](../../docs/features-capabilities/index), the platform supports:

- **Dark/Light Mode:** User preference-based theme switching
- **Customizable Layout:** Drag-and-drop dashboard customization
- **Localization:** Multi-language support (future enhancement)

This schema will store these preferences and more, enabling personalized user experiences.

## Acceptance Criteria

1. ✅ A `user_preferences.ts` schema file is created in `/lib/db/schema`
2. ✅ The schema correctly defines all columns and types:
   - `id` (UUID, primary key)
   - `user_id` (UUID, foreign key to users.id)
   - `theme` (VARCHAR(50), default 'light')
   - `language` (VARCHAR(10), default 'en')
   - `timezone` (VARCHAR(100), default 'UTC')
   - `email_notifications` (BOOLEAN, default TRUE)
   - `push_notifications` (BOOLEAN, default TRUE)
   - `weekly_reports` (BOOLEAN, default FALSE)
   - `marketing_emails` (BOOLEAN, default FALSE)
   - `created` (TIMESTAMP WITH TIME ZONE, default NOW())
   - `updated` (TIMESTAMP WITH TIME ZONE, default NOW())
3. ✅ A foreign key constraint `user_id` correctly references `users.id` with `ON DELETE CASCADE`
4. ✅ The schema matches the exact structure from the OLTP Schema Guide
5. ✅ The schema is exported and can be imported in other files
6. ✅ All field names and types match the OLTP guide (e.g., `created`/`updated`, not `created_at`/`updated_at`)

## Technical Details

### Schema Structure

```typescript
// lib/db/schema/user_preferences.ts
import { pgTable, uuid, varchar, timestamp, boolean } from 'drizzle-orm/pg-core';
import { users } from './users';

export const userPreferences = pgTable('user_preferences', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .references(() => users.id, { onDelete: 'cascade' }),
  theme: varchar('theme', { length: 50 }).default('light'),
  language: varchar('language', { length: 10 }).default('en'),
  timezone: varchar('timezone', { length: 100 }).default('UTC'),
  emailNotifications: boolean('email_notifications').default(true),
  pushNotifications: boolean('push_notifications').default(true),
  weeklyReports: boolean('weekly_reports').default(false),
  marketingEmails: boolean('marketing_emails').default(false),
  created: timestamp('created', { withTimezone: true }).defaultNow().notNull(),
  updated: timestamp('updated', { withTimezone: true }).defaultNow().notNull(),
});
```

**Note:** Match the exact schema from the [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide.md#user_preferences---user-preferences). The schema uses:

- `created` and `updated` (not `created_at`/`updated_at`)
- Separate boolean columns for notification preferences (not JSON)
- VARCHAR types with specific lengths
- No unique constraint on `user_id` (one-to-one relationship enforced at application level)

## Implementation Notes

- Use UUID for primary key to match users table
- Set appropriate defaults for all preference fields
- Use `onDelete: 'cascade'` to automatically delete preferences when user is deleted
- Consider using an enum type for theme values (future enhancement)
- Add indexes if needed for query performance
- Document the allowed values for each field

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Database schema patterns
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide) - **Primary reference** for user_preferences table structure and OLTP design patterns
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - 5-tier database architecture overview
- [Features & Capabilities](../../docs/features-capabilities/index) - User preferences features

## Dependencies

- **CORE-2.2** - Users table schema must be defined (from Epic 1)
- **CORE-2.1** - Drizzle ORM must be configured

## Testing

- [ ] Verify schema file is created in correct location
- [ ] Test that schema can be imported without TypeScript errors
- [ ] Verify foreign key relationship is correctly defined
- [ ] Verify unique constraint prevents duplicate user preferences
- [ ] Check that default values are set appropriately
- [ ] Verify cascade delete behavior (when user is deleted)
