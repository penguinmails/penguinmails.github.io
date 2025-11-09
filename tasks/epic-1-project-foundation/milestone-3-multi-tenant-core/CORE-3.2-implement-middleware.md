# CORE-3.2: Implement Next.js Middleware for Route Protection

**Ticket ID:** CORE-3.2  
**Milestone:** 3 - The Secure, Multi-Tenant Core  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a `middleware.ts` file at the root of the project. Use the Nile SDK to check for a valid user session. Configure the middleware's matcher to protect all API routes under `/api/` except for the public `/api/auth/` routes.

## Context

Middleware is essential for implementing authentication and authorization at the application level. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), PenguinMails requires:
- **Route Protection:** Secure API endpoints
- **Session Management:** Valid user sessions
- **Multi-tenant Context:** Tenant identification from sessions

The middleware will enforce authentication before requests reach protected API routes, ensuring only authenticated users can access sensitive endpoints.

## Acceptance Criteria

1. ✅ A `middleware.ts` file exists at the root of the project
2. ✅ The middleware is correctly configured to run on API routes
3. ✅ Making a request to a test endpoint like `/api/test/protected` without a session cookie results in a `401 Unauthorized` error
4. ✅ The `/api/auth/signup` route remains publicly accessible
5. ✅ The `/api/auth/login` route remains publicly accessible
6. ✅ Authenticated requests (with valid session) pass through the middleware successfully
7. ✅ The middleware extracts user and tenant context from the session

## Technical Details

### Middleware Structure

```typescript
// middleware.ts
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { nile } from '@/lib/nile';

export async function middleware(request: NextRequest) {
  // Allow public auth routes
  if (request.nextUrl.pathname.startsWith('/api/auth/')) {
    return NextResponse.next();
  }

  // Protect all other API routes
  if (request.nextUrl.pathname.startsWith('/api/')) {
    try {
      // Check for valid session using Nile SDK
      const session = await nile.auth.getSession();
      
      if (!session) {
        return NextResponse.json(
          { error: 'Unauthorized' },
          { status: 401 }
        );
      }

      // Add user context to request headers for downstream use
      const requestHeaders = new Headers(request.headers);
      requestHeaders.set('x-user-id', session.userId);
      requestHeaders.set('x-tenant-id', session.tenantId || '');

      return NextResponse.next({
        request: {
          headers: requestHeaders,
        },
      });
    } catch (error) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: '/api/:path*',
};
```

### Public Routes

The following routes should be publicly accessible:
- `/api/auth/signup`
- `/api/auth/login`
- `/api/test/validation` (if needed for testing)

## Implementation Notes

- Use Next.js middleware API correctly
- Configure the matcher to only run on API routes
- Extract session information using Nile SDK
- Add user and tenant context to request headers for downstream use
- Handle errors gracefully with appropriate HTTP status codes
- Consider adding rate limiting (future enhancement)
- Log authentication failures for security monitoring (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Security architecture
- [Team Workflow](../../docs/quick-access/team-workflow.md) - Authentication and authorization

## Dependencies

- **CORE-3.1** - NileDB SDK must be installed and configured
- **CORE-1.1** - Next.js project must be initialized

## Testing

- [ ] Test unauthenticated request to protected endpoint - verify 401 response
- [ ] Test authenticated request to protected endpoint - verify 200 response
- [ ] Test public auth routes - verify they are accessible without authentication
- [ ] Verify middleware extracts user and tenant context correctly
- [ ] Test middleware with invalid session cookie - verify 401 response
- [ ] Test middleware with expired session - verify 401 response
- [ ] Verify middleware doesn't interfere with non-API routes

