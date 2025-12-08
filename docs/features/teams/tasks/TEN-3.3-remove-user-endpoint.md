
# TEN-3.3: Create API Endpoint to Remove a User (DELETE /api/tenants/users/{userId})

**Ticket ID:** TEN-3.3  
**Milestone:** 3 - Tenant User Management  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected DELETE API route at `/api/tenants/users/[userId]/route.ts`. This endpoint will use the Nile SDK's `tenants.removeUserFromTenant()` function to remove a member from the current tenant.

## Context

Removing users from tenants is essential for team management. According to the [Team Workflow](/docs/quick-access/team-workflow), team membership management is a core feature. This endpoint enables users to remove team members while maintaining security by preventing self-removal.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It retrieves the `userId` to be removed from the URL parameters
3. ✅ It prevents a user from removing themselves (returns appropriate error)
4. ✅ It successfully calls the Nile SDK function `tenants.removeUserFromTenant()`
5. ✅ It returns a `204 No Content` response on success
6. ✅ An unauthenticated request returns a `401 Unauthorized` error
7. ✅ Attempting to remove self returns a `400 Bad Request` or `403 Forbidden` error
8. ✅ Attempting to remove non-existent user returns appropriate error

## Technical Details

### API Route Structure

```typescript
// app/api/tenants/users/[userId]/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';

export async function DELETE(
  request: NextRequest,
  { params }: { params: { userId: string } }
) {
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

    // Get userId from URL parameters
    const { userId } = params;

    // Prevent self-removal
    if (userId === session.userId) {
      return NextResponse.json(
        { error: 'You cannot remove yourself from the tenant' },
        { status: 403 }
      );
    }

    // Remove user from tenant using Nile SDK
    await nile.tenants.removeUserFromTenant({
      tenantId: tenantId,
      userId: userId,
    });

    // Return 204 No Content on success
    return new NextResponse(null, { status: 204 });
  } catch (error) {
    // Handle user not found or not in tenant
    if (error.message?.includes('not found') || error.message?.includes('not a member')) {
      return NextResponse.json(
        { error: 'User not found or not a member of this tenant' },
        { status: 404 }
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

**Success Response (204):**
No response body (204 No Content)

**Error Response (403) - Self Removal:**

```json
{
  "error": "You cannot remove yourself from the tenant"
}
```

**Error Response (404) - User Not Found:**

```json
{
  "error": "User not found or not a member of this tenant"
}
```

## Implementation Notes

- Use DELETE method for removal operations
- Always check that user is not removing themselves
- Use NileDB SDK's built-in function for removal
- Return 204 No Content on success (standard for DELETE operations)
- Handle errors gracefully (user not found, not a member, etc.)
- Consider adding permission checks (e.g., only admins can remove users) (future enhancement)
- Consider adding confirmation step or soft delete (future enhancement)
- Log user removals for audit trail (future enhancement)
- Consider adding notification to removed user (future enhancement)

## Related Documentation

- [Team Workflow](/docs/quick-access/team-workflow) - Team management
- [Features & Capabilities](/docs/features-capabilities/index) - Team collaboration

## Dependencies

- [CORE-3.1](/docs/features/authentication/tasks/CORE-3.1-install-configure-niledb) - NileDB SDK must be configured (from Epic 1)
- [CORE-3.2](/docs/features/authentication/tasks/CORE-3.2-implement-middleware) - Middleware must be implemented (from Epic 1)
- [TEN-3.1](/docs/features/teams/tasks/TEN-3.1-list-tenant-members-endpoint) - List users endpoint should exist (for context)

## Testing

- [ ] Test authenticated request with valid userId - verify 204 response
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test attempting to remove self - verify 403 error
- [ ] Test with invalid userId - verify 404 error
- [ ] Test with userId from another tenant - verify 404 error
- [ ] Verify user is removed from tenant in NileDB
- [ ] Test error handling for NileDB failures
- [ ] Verify tenantId from session is used (not from request)
- [ ] Verify response is 204 No Content (no body)

---

## Cross-References

- **Routes**: [workspace-management.md]()
- **API**: [tenant-api/](/docs/implementation-technical/api/tenant-api/)
