# AUTH-3.3: Create API Endpoint to Fetch User Profile (GET /api/users/me)

**Ticket ID:** AUTH-3.3  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/users/me/route.ts`. This endpoint will use the `userId` from the Nile session context to fetch the user's data from the `users` table and their settings from the `user_preferences` table.

## Context

This endpoint extends the basic user context endpoint from Epic 1 (CORE-3.5) to include user preferences. According to the [Features & Capabilities](../../docs/features-capabilities/index.md), users need to access their profile information to:
- View their account details
- See their current preferences
- Understand their account settings

This endpoint will be used by the frontend to display the user's complete profile information.

## Acceptance Criteria

1. ✅ The endpoint is protected by the Nile middleware (from Epic 1)
2. ✅ On success, it performs a JOIN to fetch data from both `users` and `user_preferences` tables
3. ✅ Returns a `200 OK` with a combined JSON object of the user's profile and preferences
4. ✅ If a user has no preferences row yet, it should return default values for those fields
5. ✅ An unauthenticated request returns a `401 Unauthorized` error
6. ✅ The response includes:
   - User information (id, email, name, etc.)
   - User preferences (theme, language, timezone, notification settings)
7. ✅ Sensitive data (passwords) is never returned

## Technical Details

### API Route Structure

```typescript
// app/api/users/me/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { users, userPreferences } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

export async function GET(request: NextRequest) {
  try {
    // Get session from NileDB (middleware should have verified this)
    const session = await nile.auth.getSession();

    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Fetch user data
    const [user] = await db
      .select({
        id: users.id,
        email: users.email,
        name: users.name,
        createdAt: users.createdAt,
        updatedAt: users.updatedAt,
      })
      .from(users)
      .where(eq(users.id, session.userId))
      .limit(1);

    if (!user) {
      return NextResponse.json(
        { error: 'User not found' },
        { status: 404 }
      );
    }

    // Fetch user preferences (or use defaults)
    const [preferences] = await db
      .select()
      .from(userPreferences)
      .where(eq(userPreferences.userId, session.userId))
      .limit(1);

    // Combine user data with preferences (or defaults)
    const profile = {
      ...user,
      preferences: preferences || {
        theme: 'system',
        language: 'en',
        timezone: 'UTC',
        emailNotifications: true,
        pushNotifications: false,
      },
    };

    return NextResponse.json(profile, { status: 200 });
  } catch (error) {
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
  "name": "John Doe",
  "createdAt": "2025-10-27T12:00:00.000Z",
  "updatedAt": "2025-10-27T12:00:00.000Z",
  "preferences": {
    "theme": "dark",
    "language": "en",
    "timezone": "America/New_York",
    "emailNotifications": true,
    "pushNotifications": false
  }
}
```

**With Default Preferences (if no preferences row exists):**
```json
{
  "id": "user-uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "preferences": {
    "theme": "system",
    "language": "en",
    "timezone": "UTC",
    "emailNotifications": true,
    "pushNotifications": false
  }
}
```

## Implementation Notes

- Use the existing middleware for authentication (from Epic 1)
- Perform efficient database queries (consider using a single JOIN query if possible)
- Return default preferences if user has no preferences row
- Never return sensitive information (passwords, internal IDs, etc.)
- Consider caching user profile data in Redis (future enhancement)
- Add proper error handling for database failures

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - API patterns
- [Implementation & Getting Started](../../docs/implementation-getting-started/index.md) - API development

## Dependencies

- **CORE-3.2** - Middleware must be implemented (from Epic 1)
- **CORE-3.5** - Basic user context endpoint exists (from Epic 1)
- **AUTH-3.1** - User preferences schema must be defined
- **AUTH-3.2** - User preferences table must exist in database

## Testing

- [ ] Test unauthenticated request - verify 401 error
- [ ] Test authenticated request - verify 200 response with user data
- [ ] Test with user who has preferences - verify preferences are returned
- [ ] Test with user who has no preferences - verify default values are returned
- [ ] Verify sensitive data (passwords) is not returned
- [ ] Test error handling for database failures
- [ ] Verify response format matches expected structure
- [ ] Test with different user accounts to verify data isolation


