# CORE-3.3: Create Public API Endpoint for User Signup

**Ticket ID:** CORE-3.3  
**Milestone:** 3 - The Secure, Multi-Tenant Core  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a POST API route at `/api/auth/signup/route.ts`. It will validate the request body with Zod, then call Nile's `auth.signUp` function. On success, it will also insert a corresponding record into our public `users` table.

## Context

User registration is the first step in the authentication flow. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), users must be created in both:
- **NileDB** - For authentication and session management
- **PostgreSQL** - For application-specific user data

This dual-storage approach ensures authentication works with NileDB while maintaining application data in our database.

## Acceptance Criteria

1. ✅ A POST API route exists at `/api/auth/signup/route.ts`
2. ✅ The endpoint validates the request body using the `signupSchema` from CORE-5.1
3. ✅ A new user can be created via this endpoint
4. ✅ The user exists in both NileDB and our `users` table
5. ✅ A `409 Conflict` error is returned if the email already exists
6. ✅ A `400 Bad Request` error is returned for invalid input data
7. ✅ On success, a `201 Created` response is returned with user data (excluding sensitive information)
8. ✅ Password is never returned in the response

## Technical Details

### API Route Structure

```typescript
// app/api/auth/signup/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { signupSchema } from '@/lib/schemas/auth.schemas';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { users } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = signupSchema.parse(body);

    // Check if user already exists in our database
    const existingUser = await db
      .select()
      .from(users)
      .where(eq(users.email, validatedData.email))
      .limit(1);

    if (existingUser.length > 0) {
      return NextResponse.json(
        { error: 'Email already exists' },
        { status: 409 }
      );
    }

    // Create user in NileDB
    const nileUser = await nile.auth.signUp({
      email: validatedData.email,
      password: validatedData.password,
    });

    // Create user in our database
    const [newUser] = await db
      .insert(users)
      .values({
        id: nileUser.id, // Use NileDB user ID
        email: validatedData.email,
        name: validatedData.name,
      })
      .returning();

    return NextResponse.json(
      {
        success: true,
        user: {
          id: newUser.id,
          email: newUser.email,
          name: newUser.name,
        },
      },
      { status: 201 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', errors: error.errors },
        { status: 400 }
      );
    }

    // Handle NileDB errors
    if (error.message?.includes('already exists')) {
      return NextResponse.json(
        { error: 'Email already exists' },
        { status: 409 }
      );
    }

    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Implementation Notes

- Use Zod schema validation before processing
- Check for existing users in our database first
- Create user in NileDB, then in our database
- Use NileDB user ID as the primary key in our users table
- Handle errors gracefully with appropriate HTTP status codes
- Never return passwords or sensitive data in responses
- Consider adding email verification (future enhancement)
- Log signup events for analytics (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Authentication flow
- [API Reference](../../docs/implementation-technical/development-guidelines/api-reference.md) - **Primary reference** for API development standards and authentication patterns
- [OLTP Schema Guide](../../docs/implementation-technical/database-infrastructure/oltp-schema-guide.md) - Users table structure (NileDB-managed)
- [Implementation & Getting Started](../../docs/implementation-getting-started/index.md) - User registration

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured
- **CORE-3.2** - Middleware must allow public access to this route
- **CORE-5.1** - Zod signup schema must be defined
- **CORE-2.2** - Users table schema must be defined

## Testing

- [ ] Test signup with valid data - verify user created in both systems
- [ ] Test signup with duplicate email - verify 409 error
- [ ] Test signup with invalid email - verify 400 error
- [ ] Test signup with short password - verify 400 error
- [ ] Test signup with missing required fields - verify 400 error
- [ ] Verify password is not returned in response
- [ ] Verify user ID matches between NileDB and our database
- [ ] Test error handling for database failures


