---
title: "CORE-3.5: Create a Protected Endpoint to Verify User Context"
description: "Documentation for CORE-3.5: Create a Protected Endpoint to Verify User Context - CORE 3.5 Create Protected Endpoint"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# CORE-3.5: Create a Protected Endpoint to Verify User Context

**Ticket ID:** CORE-3.5  
**Milestone:** 3 - The Secure, Multi-Tenant Core  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected GET API route at `GET /api/users/me/route.ts`. This route will use the Nile SDK to extract the authenticated user's ID and tenant context from the session and return it.

## Context

This endpoint serves as a test to verify that authentication and multi-tenant context extraction are working correctly. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), protected endpoints must:

- **Verify authentication** - Ensure user is logged in
- **Extract user context** - Get user ID from session
- **Extract tenant context** - Get tenant ID from session (for multi-tenant isolation)

This pattern will be used throughout the application for accessing authenticated user and tenant information.

## Acceptance Criteria

1. ✅ A GET API route exists at `/api/users/me/route.ts`
2. ✅ An unauthenticated request to this endpoint fails with a `401 Unauthorized` error
3. ✅ An authenticated request succeeds and returns a `200 OK` response
4. ✅ The response includes a JSON object containing:
   - `userId` - The authenticated user's ID
   - `tenantId` - The user's tenant ID (if available)
   - `email` - The user's email (optional, from our database)
5. ✅ The endpoint uses the middleware to verify authentication
6. ✅ The endpoint extracts user context from the session

## Technical Details

### API Route Structure

```typescript
// app/api/users/me/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { users } from '@/lib/db/schema';
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

    // Get user details from our database
    const [user] = await db
      .select({
        id: users.id,
        email: users.email,
        name: users.name,
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

    return NextResponse.json(
      {
        userId: session.userId,
        tenantId: session.tenantId || null,
        email: user.email,
        name: user.name,
      },
      { status: 200 }
    );
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
  "userId": "uuid-here",
  "tenantId": "tenant-uuid-here",
  "email": "user@example.com",
  "name": "John Doe"
}
```

**Error Response (401):**

```json
{
  "error": "Unauthorized"
}
```

## Implementation Notes

- Rely on middleware for authentication verification
- Extract user and tenant context from session
- Fetch additional user details from our database
- Handle cases where user doesn't exist in our database
- Never return sensitive information (passwords, etc.)
- This endpoint will be used by the frontend to get current user info
- Consider caching user data to reduce database queries (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Multi-tenant context
- [Team Workflow](../../docs/quick-access/team-workflow) - User context and roles

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured
- **CORE-3.2** - Middleware must be implemented
- **CORE-3.3** - Signup endpoint must be working (to create test users)
- **CORE-3.4** - Login endpoint must be working (to authenticate)
- **CORE-2.2** - Users table schema must be defined

## Testing

- [ ] Test unauthenticated request - verify 401 error
- [ ] Test authenticated request - verify 200 response with user data
- [ ] Verify userId matches the authenticated user
- [ ] Verify tenantId is extracted correctly (if available)
- [ ] Test with user that doesn't exist in our database - verify 404 or handle gracefully
- [ ] Verify sensitive data (passwords) is not returned
- [ ] Test error handling for session retrieval failures
- [ ] Test error handling for database query failures
