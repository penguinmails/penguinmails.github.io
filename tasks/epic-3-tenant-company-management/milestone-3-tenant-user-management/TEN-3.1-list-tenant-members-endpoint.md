# TEN-3.1: Create API Endpoint to List Tenant Members (GET /api/tenants/users)

**Ticket ID:** TEN-3.1  
**Milestone:** 3 - Tenant User Management  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/tenants/users/route.ts`. This endpoint will use the Nile SDK's `tenants.listUsersInTenant()` function to retrieve a list of all users who are members of the current tenant.

## Context

Listing tenant members is essential for team management. According to the [Team Workflow](../../docs/quick-access/team-workflow), PenguinMails supports team collaboration with role-based access control. This endpoint enables users to see who is part of their tenant/workspace.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It successfully calls the Nile SDK function `tenants.listUsersInTenant()`
3. ✅ It returns a `200 OK` with an array of user objects
4. ✅ The response includes user information: email, roles, and user ID
5. ✅ An unauthenticated request returns a `401 Unauthorized` error
6. ✅ The list is scoped to the current tenant from the session context
7. ✅ Empty array is returned if no users exist in the tenant

## Technical Details

### API Route Structure

```typescript
// app/api/tenants/users/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';

export async function GET(request: NextRequest) {
  try {
    // Get session from NileDB
    const session = await nile.auth.getSession();

    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Get tenantId from session context
    const tenantId = session.tenantId;

    if (!tenantId) {
      return NextResponse.json(
        { error: 'No tenant context found' },
        { status: 400 }
      );
    }

    // List users in tenant using Nile SDK
    const users = await nile.tenants.listUsersInTenant({
      tenantId: tenantId,
    });

    return NextResponse.json(
      {
        users: users,
        count: users.length,
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
  "users": [
    {
      "userId": "user-uuid",
      "email": "user@example.com",
      "role": "admin",
      "joinedAt": "2025-10-27T12:00:00.000Z"
    }
  ],
  "count": 1
}
```

**Empty Response (200):**

```json
{
  "users": [],
  "count": 0
}
```

## Implementation Notes

- Use NileDB SDK's built-in function for listing users
- Get tenantId from session context (not from request)
- Return empty array if no users exist (not an error)
- Include count in response for convenience
- The actual user data structure may vary based on NileDB SDK response format
- Consider enriching response with additional user data from our database (future enhancement)
- Consider adding pagination (future enhancement)
- Consider adding filtering/sorting options (future enhancement)

## Related Documentation

- [Team Workflow](../../docs/quick-access/team-workflow) - Team management
- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Multi-tenant architecture

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-3.2** - Middleware must be implemented (from Epic 1)
- **TEN-1.4** - Tenant creation should be working (for context)

## Testing

- [ ] Test authenticated request - verify 200 response with users array
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with tenant that has users - verify all users returned
- [ ] Test with tenant that has no users - verify empty array returned
- [ ] Verify tenantId from session is used (not from request)
- [ ] Verify response includes user email, role, and ID
- [ ] Test error handling for NileDB failures
- [ ] Verify response format matches expected structure
