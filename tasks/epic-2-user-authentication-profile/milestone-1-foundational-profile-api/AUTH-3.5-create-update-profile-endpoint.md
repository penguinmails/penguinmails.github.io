# AUTH-3.5: Create API Endpoint to Update User Profile (PATCH /api/users/me)

**Ticket ID:** AUTH-3.5  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected PATCH API route at `/api/users/me/route.ts`. This endpoint will validate the request body using `updateProfileSchema`. It will then update the corresponding fields in the `users` and/or `user_preferences` tables for the authenticated user.

## Context

Profile updates are essential for user self-service. According to the [Features & Capabilities](../../docs/features-capabilities/index.md), users need to:
- **Customize their experience:** Update theme, language, and preferences
- **Manage their account:** Update name and personal information
- **Control notifications:** Configure notification preferences

This endpoint enables users to update their profile information securely, with all changes scoped to the authenticated user.

## Acceptance Criteria

1. ✅ The endpoint is protected by the Nile middleware
2. ✅ It validates the request body with Zod (`updateProfileSchema`) and returns a `400 Bad Request` for invalid data
3. ✅ On success, it updates the correct records in the database and returns a `200 OK` with the updated user profile object
4. ✅ It correctly handles creating a `user_preferences` row if one doesn't already exist for the user (upsert logic)
5. ✅ Only the authenticated user's data can be updated (security check)
6. ✅ An unauthenticated request returns a `401 Unauthorized` error
7. ✅ The response includes the complete updated profile (user data + preferences)

## Technical Details

### API Route Structure

```typescript
// app/api/users/me/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { users, userPreferences } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';
import { updateProfileSchema } from '@/lib/schemas/user.schemas';
import { z } from 'zod';

export async function PATCH(request: NextRequest) {
  try {
    // Get session from NileDB
    const session = await nile.auth.getSession();

    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Validate request body
    const body = await request.json();
    const validatedData = updateProfileSchema.parse(body);

    // Separate user fields from preference fields
    const userFields: Partial<typeof users.$inferInsert> = {};
    const preferenceFields: Partial<typeof userPreferences.$inferInsert> = {};

    if (validatedData.name !== undefined) userFields.name = validatedData.name;
    if (validatedData.givenName !== undefined) userFields.givenName = validatedData.givenName;
    if (validatedData.familyName !== undefined) userFields.familyName = validatedData.familyName;

    if (validatedData.theme !== undefined) preferenceFields.theme = validatedData.theme;
    if (validatedData.language !== undefined) preferenceFields.language = validatedData.language;
    if (validatedData.timezone !== undefined) preferenceFields.timezone = validatedData.timezone;
    if (validatedData.emailNotifications !== undefined) preferenceFields.emailNotifications = validatedData.emailNotifications;
    if (validatedData.pushNotifications !== undefined) preferenceFields.pushNotifications = validatedData.pushNotifications;

    // Update user table if needed
    if (Object.keys(userFields).length > 0) {
      userFields.updatedAt = new Date();
      await db
        .update(users)
        .set(userFields)
        .where(eq(users.id, session.userId));
    }

    // Upsert user preferences
    if (Object.keys(preferenceFields).length > 0) {
      preferenceFields.updatedAt = new Date();
      
      // Check if preferences exist
      const [existing] = await db
        .select()
        .from(userPreferences)
        .where(eq(userPreferences.userId, session.userId))
        .limit(1);

      if (existing) {
        // Update existing preferences
        await db
          .update(userPreferences)
          .set(preferenceFields)
          .where(eq(userPreferences.userId, session.userId));
      } else {
        // Create new preferences row
        await db.insert(userPreferences).values({
          userId: session.userId,
          ...preferenceFields,
        });
      }
    }

    // Fetch and return updated profile (similar to GET endpoint)
    const [user] = await db
      .select()
      .from(users)
      .where(eq(users.id, session.userId))
      .limit(1);

    const [preferences] = await db
      .select()
      .from(userPreferences)
      .where(eq(userPreferences.userId, session.userId))
      .limit(1);

    return NextResponse.json(
      {
        ...user,
        preferences: preferences || {
          theme: 'system',
          language: 'en',
          timezone: 'UTC',
          emailNotifications: true,
          pushNotifications: false,
        },
      },
      { status: 200 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', errors: error.errors },
        { status: 400 }
      );
    }

    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

### Expected Response Format

**Success Response (200):**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "name": "Updated Name",
  "preferences": {
    "theme": "dark",
    "language": "en",
    "timezone": "America/New_York",
    "emailNotifications": true,
    "pushNotifications": false
  }
}
```

**Error Response (400):**
```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["theme"],
      "message": "Theme must be light, dark, or system"
    }
  ]
}
```

## Implementation Notes

- Use PATCH method for partial updates
- Separate user fields from preference fields for proper table updates
- Implement upsert logic for user preferences (create if doesn't exist, update if exists)
- Update `updatedAt` timestamp on both tables
- Return complete updated profile in response
- Never allow updating email or user ID (security)
- Consider adding audit logging for profile changes (future enhancement)
- Add rate limiting to prevent abuse (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - API patterns
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards.md) - Data protection

## Dependencies

- **AUTH-3.3** - GET /api/users/me endpoint exists (for reference)
- **AUTH-3.4** - Update profile schema must be defined
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with valid data - verify 200 response with updated profile
- [ ] Test updating single field - verify only that field is updated
- [ ] Test updating multiple fields - verify all fields are updated
- [ ] Test with invalid data - verify 400 error with validation details
- [ ] Test creating preferences for user without preferences - verify upsert works
- [ ] Test updating preferences for user with existing preferences - verify update works
- [ ] Verify only authenticated user's data can be updated
- [ ] Test error handling for database failures
- [ ] Verify updatedAt timestamp is updated correctly

