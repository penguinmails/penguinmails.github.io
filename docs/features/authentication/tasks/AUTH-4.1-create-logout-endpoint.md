
# AUTH-4.1: Create API Endpoint for User Logout (POST /api/auth/logout)

**Ticket ID:** AUTH-4.1  
**Milestone:** 2 - Enhanced Authentication and Security  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route at `/api/auth/logout/route.ts`. This endpoint will call the appropriate Nile SDK function to invalidate the user's current session and clear their session cookie.

## Context

Session management is critical for security. According to the [High-Level Architecture](/docs/quick-access/high-level-architecture), PenguinMails uses:

- **Session Management:** JWT-based session management via NileDB
- **Security:** Proper session invalidation prevents unauthorized access

Logout functionality allows users to securely end their session, which is essential for shared devices and security best practices.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ Calling this endpoint successfully invalidates the session in NileDB
3. ✅ The session cookie is cleared from the browser
4. ✅ Subsequent requests to protected routes (like `/api/users/me`) should fail with a `401 Unauthorized` error until the user logs in again
5. ✅ A successful logout returns a `200 OK` response
6. ✅ An unauthenticated request returns a `401 Unauthorized` error

## Technical Details

### API Route Structure

```typescript
// app/api/auth/logout/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';

export async function POST(request: NextRequest) {
  try {
    // Get session from NileDB
    const session = await nile.auth.getSession();

    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Invalidate session using Nile SDK
    await nile.auth.signOut();

    // Clear session cookie
    const response = NextResponse.json(
      { success: true, message: 'Logged out successfully' },
      { status: 200 }
    );

    // Clear the session cookie
    response.cookies.delete('nile-session'); // Adjust cookie name based on NileDB implementation
    // Or use NileDB's built-in cookie clearing if available

    return response;
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
  "success": true,
  "message": "Logged out successfully"
}
```

**Error Response (401):**

```json
{
  "error": "Unauthorized"
}
```

## Implementation Notes

- Use NileDB's `signOut()` method to invalidate the session
- Clear the session cookie from the response
- Verify the cookie name matches NileDB's implementation
- Consider adding logging for security monitoring (future enhancement)
- Handle errors gracefully
- The endpoint should work even if the session is already invalid

## Related Documentation

- [High-Level Architecture](/docs/quick-access/high-level-architecture) - Session management
- [Compliance & Regulatory Standards](/docs/quick-access/compliance-regulatory-standards) - Security requirements

## Dependencies

- [CORE-3.1](/docs/features/authentication/tasks/CORE-3.1-install-configure-niledb) - NileDB SDK must be configured (from Epic 1)
- [CORE-3.2](/docs/features/authentication/tasks/CORE-3.2-implement-middleware) - Middleware must be implemented (from Epic 1)
- [CORE-3.4](/docs/features/authentication/tasks/CORE-3.4-create-login-endpoint) - Login endpoint must be working (from Epic 1)

## Testing

- [ ] Test authenticated logout - verify 200 response
- [ ] Test unauthenticated logout - verify 401 error
- [ ] Verify session is invalidated after logout
- [ ] Verify session cookie is cleared
- [ ] Test that protected endpoints return 401 after logout
- [ ] Test that user can log in again after logout
- [ ] Test error handling for NileDB failures
- [ ] Verify logout works with multiple concurrent sessions (if applicable)

---

## Cross-References

- **Routes**: [public-auth.md]()
- **API**: [platform-api/](/docs/implementation-technical/api/platform-api/)
