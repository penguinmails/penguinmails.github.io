# Milestone 1: Foundational User Profile API

**Goal:** To establish the basic API functionality for a user to retrieve and update their core profile information. This milestone creates the Drizzle schema for user preferences and the primary endpoints for profile management.

## Tickets

- [AUTH-3.1](./AUTH-3.1-define-user-preferences-schema.md) - Define Drizzle Schema for user_preferences
- [AUTH-3.2](./AUTH-3.2-generate-apply-migration.md) - Generate and Apply user_preferences Migration
- [AUTH-3.3](./AUTH-3.3-create-fetch-profile-endpoint.md) - Create API Endpoint to Fetch User Profile (GET /api/users/me)
- [AUTH-3.4](./AUTH-3.4-define-profile-update-schema.md) - Define Zod Schema for Profile Updates
- [AUTH-3.5](./AUTH-3.5-create-update-profile-endpoint.md) - Create API Endpoint to Update User Profile (PATCH /api/users/me)

## Dependencies

- **Epic 1** must be fully completed
- Requires database connection and Drizzle ORM configured
- Requires NileDB authentication working

## Success Criteria

- ✅ User preferences table schema defined
- ✅ Migration applied successfully
- ✅ Users can fetch their complete profile
- ✅ Users can update their profile information
- ✅ Default preferences created when missing


