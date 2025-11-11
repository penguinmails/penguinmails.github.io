# TEN-3.2: Create API Endpoint to Invite a User (POST /api/tenants/invites)

**Ticket ID:** TEN-3.2  
**Milestone:** 3 - Tenant User Management  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route at `/api/tenants/invites/route.ts`. The endpoint will accept an email and a role (e.g., 'member', 'admin'). It will then use the Nile SDK's `tenants.createInvitation()` function to generate a secure invitation.

## Context

User invitations are essential for team collaboration. According to the [Team Workflow](../../docs/quick-access/team-workflow.md), PenguinMails supports team management with role-based access control. This endpoint enables users to invite team members to their tenant/workspace.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It validates the request body:
   - `email` is valid email format
   - `role` is one of the allowed values (e.g., 'member', 'admin', 'viewer')
3. ✅ It successfully calls the Nile SDK function `tenants.createInvitation()`
4. ✅ Nile handles sending the invitation email automatically
5. ✅ The endpoint returns a `201 Created` response on success
6. ✅ An unauthenticated request returns a `401 Unauthorized` error
7. ✅ Invalid data returns a `400 Bad Request` error

## Technical Details

### API Route Structure

```typescript
// app/api/tenants/invites/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { z } from 'zod';

const inviteUserSchema = z.object({
  email: z.string().email('Invalid email address'),
  role: z.enum(['owner', 'admin', 'member', 'viewer'], {
    errorMap: () => ({ message: 'Role must be one of: owner, admin, member, viewer' }),
  }),
});

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

    // Get tenantId from session context
    const tenantId = session.tenantId;

    if (!tenantId) {
      return NextResponse.json(
        { error: 'No tenant context found' },
        { status: 400 }
      );
    }

    // Validate request body
    const body = await request.json();
    const validatedData = inviteUserSchema.parse(body);

    // Create invitation using Nile SDK
    const invitation = await nile.tenants.createInvitation({
      tenantId: tenantId,
      email: validatedData.email,
      role: validatedData.role,
    });

    return NextResponse.json(
      {
        success: true,
        message: 'Invitation sent successfully',
        invitation: {
          id: invitation.id,
          email: validatedData.email,
          role: validatedData.role,
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

    // Handle duplicate invitation or other NileDB errors
    if (error.message?.includes('already') || error.message?.includes('exists')) {
      return NextResponse.json(
        { error: 'User is already a member or has a pending invitation' },
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

### Expected Response Format

**Success Response (201):**
```json
{
  "success": true,
  "message": "Invitation sent successfully",
  "invitation": {
    "id": "invitation-uuid",
    "email": "newuser@example.com",
    "role": "member"
  }
}
```

**Error Response (400):**
```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["email"],
      "message": "Invalid email address"
    }
  ]
}
```

**Error Response (409):**
```json
{
  "error": "User is already a member or has a pending invitation"
}
```

## Implementation Notes

- Validate email format and role enum
- Use NileDB SDK's built-in invitation function
- NileDB handles email sending automatically
- Handle duplicate invitation errors gracefully
- Consider adding permission checks (e.g., only admins can invite) (future enhancement)
- Consider adding rate limiting to prevent abuse (future enhancement)
- Log invitations for audit trail (future enhancement)
- Consider adding invitation expiration handling (future enhancement)

## Related Documentation

- [Team Workflow](../../docs/quick-access/team-workflow.md) - Team management and roles
- [Features & Capabilities](../../docs/features-capabilities/index.md) - Team collaboration

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-3.2** - Middleware must be implemented (from Epic 1)
- **CORE-5.1** - Zod must be installed (from Epic 1)

## Testing

- [ ] Test authenticated request with valid data - verify 201 response
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with invalid email - verify 400 error
- [ ] Test with invalid role - verify 400 error
- [ ] Test with duplicate invitation - verify 409 error
- [ ] Verify invitation is created in NileDB
- [ ] Verify invitation email is sent (if testable)
- [ ] Test error handling for NileDB failures
- [ ] Verify tenantId from session is used (not from request)


