# AUTH-3.1: Define Drizzle Schema for user_preferences

**Ticket ID:** AUTH-3.1  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/db/schema` directory, create a new file for the `user_preferences` table. Define the schema according to the ERD, including fields like theme, language, timezone, and notification settings. Establish a one-to-one foreign key relationship with the users table.

## Context

User preferences allow users to customize their experience within PenguinMails. According to the [Features & Capabilities](../../docs/features-capabilities/index.md), the platform supports:
- **Dark/Light Mode:** User preference-based theme switching
- **Customizable Layout:** Drag-and-drop dashboard customization
- **Localization:** Multi-language support (future enhancement)

This schema will store these preferences and more, enabling personalized user experiences.

## Acceptance Criteria

1. ✅ A `user_preferences.ts` schema file is created in `/lib/db/schema`
2. ✅ The schema correctly defines all columns and types:
   - `id` (UUID, primary key)
   - `user_id` (UUID, foreign key to users.id, unique)
   - `theme` (varchar, e.g., 'light', 'dark', 'system')
   - `language` (varchar, e.g., 'en', 'es', 'fr')
   - `timezone` (varchar, e.g., 'America/New_York')
   - `notification_settings` (JSON or separate boolean columns)
   - `created_at` (timestamp)
   - `updated_at` (timestamp)
3. ✅ A foreign key constraint `user_id` correctly references `users.id`
4. ✅ A unique constraint ensures one-to-one relationship (one preference per user)
5. ✅ The schema is exported and can be imported in other files

## Technical Details

### Schema Structure

```typescript
// lib/db/schema/user_preferences.ts
import { pgTable, uuid, varchar, timestamp, jsonb, boolean } from 'drizzle-orm/pg-core';
import { users } from './users';

export const userPreferences = pgTable('user_preferences', {
  id: uuid('id').primaryKey().defaultRandom(),
  userId: uuid('user_id')
    .notNull()
    .unique()
    .references(() => users.id, { onDelete: 'cascade' }),
  theme: varchar('theme', { length: 20 }).default('system'), // 'light', 'dark', 'system'
  language: varchar('language', { length: 10 }).default('en'), // ISO 639-1 codes
  timezone: varchar('timezone', { length: 50 }).default('UTC'),
  emailNotifications: boolean('email_notifications').default(true),
  pushNotifications: boolean('push_notifications').default(false),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});
```

### Alternative: JSON Column for Flexible Settings

```typescript
// If you prefer a more flexible approach:
notificationSettings: jsonb('notification_settings').default({}),
```

## Implementation Notes

- Use UUID for primary key to match users table
- Set appropriate defaults for all preference fields
- Use `onDelete: 'cascade'` to automatically delete preferences when user is deleted
- Consider using an enum type for theme values (future enhancement)
- Add indexes if needed for query performance
- Document the allowed values for each field

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Database schema patterns
- [Features & Capabilities](../../docs/features-capabilities/index.md) - User preferences features

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

