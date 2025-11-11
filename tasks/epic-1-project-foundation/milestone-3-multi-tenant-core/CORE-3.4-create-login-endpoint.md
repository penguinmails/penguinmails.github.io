# CORE-3.4: Create Public API Endpoint for User Login

**Ticket ID:** CORE-3.4  
**Milestone:** 3 - The Secure, Multi-Tenant Core  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a POST API route at `/api/auth/login/route.ts`. It will validate the request body and call Nile's `auth.signInWithPassword` function, which handles session cookie creation.

## Context

User login is essential for authentication. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), NileDB handles:
- **Password verification**
- **Session creation**
- **Cookie management**

The login endpoint validates credentials and establishes an authenticated session that the middleware will use for route protection.

## Acceptance Criteria

1. ✅ A POST API route exists at `/api/auth/login/route.ts`
2. ✅ The endpoint validates the request body using the `loginSchema` from CORE-5.1
3. ✅ An existing user can log in via this endpoint
4. ✅ A successful login returns a `200 OK` response
5. ✅ The browser receives a session cookie after successful login
6. ✅ An incorrect password returns a `401 Unauthorized` error
7. ✅ A non-existent email returns a `401 Unauthorized` error
8. ✅ Invalid input data returns a `400 Bad Request` error
9. ✅ Password is never returned in the response

## Technical Details

### API Route Structure

```typescript
// app/api/auth/login/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { loginSchema } from '@/lib/schemas/auth.schemas';
import { nile } from '@/lib/nile';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = loginSchema.parse(body);

    // Sign in with NileDB
    const session = await nile.auth.signInWithPassword({
      email: validatedData.email,
      password: validatedData.password,
    });

    if (!session) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
      );
    }

    // NileDB handles cookie creation automatically
    // Return success response
    return NextResponse.json(
      {
        success: true,
        user: {
          id: session.userId,
          email: validatedData.email,
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

    // Handle authentication errors
    if (error.message?.includes('Invalid') || error.message?.includes('password')) {
      return NextResponse.json(
        { error: 'Invalid email or password' },
        { status: 401 }
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
- NileDB handles session cookie creation automatically
- Provide generic error messages for security (don't reveal if email exists)
- Handle authentication errors gracefully
- Never return passwords or sensitive data in responses
- Consider adding rate limiting to prevent brute force attacks (future enhancement)
- Consider adding account lockout after failed attempts (future enhancement)
- Log login events for security monitoring (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Authentication flow
- [Implementation & Getting Started](../../docs/implementation-getting-started/index.md) - User login

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured
- **CORE-3.2** - Middleware must allow public access to this route
- **CORE-5.1** - Zod login schema must be defined

## Testing

- [ ] Test login with valid credentials - verify 200 response and session cookie
- [ ] Test login with incorrect password - verify 401 error
- [ ] Test login with non-existent email - verify 401 error
- [ ] Test login with invalid email format - verify 400 error
- [ ] Test login with missing fields - verify 400 error
- [ ] Verify session cookie is set correctly
- [ ] Verify password is not returned in response
- [ ] Test that session cookie works for subsequent authenticated requests
- [ ] Test error handling for NileDB failures


