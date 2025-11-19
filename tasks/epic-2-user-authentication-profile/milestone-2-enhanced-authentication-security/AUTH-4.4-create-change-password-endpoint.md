---
title: "AUTH-4.4: Create API Endpoint to Change Password (POST /api/users/me/change-password)"
description: "Documentation for AUTH-4.4: Create API Endpoint to Change Password (POST /api/users/me/change-password) - AUTH 4.4 Create Change Password Endpoint"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# AUTH-4.4: Create API Endpoint to Change Password (POST /api/users/me/change-password)

**Ticket ID:** AUTH-4.4  
**Milestone:** 2 - Enhanced Authentication and Security  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route for an already authenticated user to change their password. The endpoint will accept their `currentPassword` and a `newPassword`.

## Context

Password change functionality allows authenticated users to update their password without going through the reset flow. According to the [Features & Capabilities](../../docs/features-capabilities/index), users need self-service account management. This endpoint enables users to proactively change their passwords for security purposes.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It uses the Nile SDK to verify the user's `currentPassword` is correct
3. ✅ If correct, it updates the user to the `newPassword`
4. ✅ It returns a `403 Forbidden` if the `currentPassword` is incorrect
5. ✅ It validates that `newPassword` meets complexity requirements
6. ✅ It returns a `400 Bad Request` for invalid input data
7. ✅ An unauthenticated request returns a `401 Unauthorized` error
8. ✅ Successful password change returns a `200 OK` response

## Technical Details

### API Route Structure

```typescript
// app/api/users/me/change-password/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { z } from 'zod';

const changePasswordSchema = z.object({
  currentPassword: z.string().min(1, 'Current password is required'),
  newPassword: z.string().min(8, 'Password must be at least 8 characters'),
  // Consider adding password complexity requirements:
  // .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
  // .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
  // .regex(/[0-9]/, 'Password must contain at least one number')
}).refine(
  (data) => data.currentPassword !== data.newPassword,
  {
    message: 'New password must be different from current password',
    path: ['newPassword'],
  }
);

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

    // Validate request body
    const body = await request.json();
    const validatedData = changePasswordSchema.parse(body);

    // Verify current password by attempting to sign in
    // Note: This approach may vary based on NileDB SDK capabilities
    try {
      // First, verify the current password is correct
      // NileDB may have a specific method for this, or we may need to attempt sign-in
      const verifyResult = await nile.auth.signInWithPassword({
        email: session.user.email, // Get email from session or user lookup
        password: validatedData.currentPassword,
      });

      if (!verifyResult) {
        return NextResponse.json(
          { error: 'Current password is incorrect' },
          { status: 403 }
        );
      }
    } catch (error) {
      // If sign-in fails, current password is incorrect
      return NextResponse.json(
        { error: 'Current password is incorrect' },
        { status: 403 }
      );
    }

    // Update password using Nile SDK
    await nile.auth.updatePassword({
      userId: session.userId,
      newPassword: validatedData.newPassword,
    });

    return NextResponse.json(
      {
        success: true,
        message: 'Password has been changed successfully.',
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
  "success": true,
  "message": "Password has been changed successfully."
}
```

**Error Response (403) - Incorrect Current Password:**

```json
{
  "error": "Current password is incorrect"
}
```

**Error Response (400) - Validation Error:**

```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["newPassword"],
      "message": "New password must be different from current password"
    }
  ]
}
```

## Implementation Notes

- Verify current password before allowing change
- Validate new password meets complexity requirements
- Ensure new password is different from current password
- Use appropriate HTTP status codes (403 for incorrect password, 400 for validation errors)
- Consider adding rate limiting to prevent brute force attacks (future enhancement)
- Log password changes for security monitoring (future enhancement)
- After successful change, user should remain logged in (session should persist)
- The actual password update is handled by NileDB

## Related Documentation

- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards) - Password security requirements
- [Features & Capabilities](../../docs/features-capabilities/index) - Account security features

## Dependencies

- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-3.2** - Middleware must be implemented (from Epic 1)
- **CORE-5.1** - Zod must be installed (from Epic 1)

## Testing

- [ ] Test with correct current password and valid new password - verify 200 response
- [ ] Test with incorrect current password - verify 403 error
- [ ] Test with same password for current and new - verify 400 error
- [ ] Test with short new password - verify 400 error with validation details
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with missing fields - verify 400 error
- [ ] Verify user can log in with new password after change
- [ ] Verify old password no longer works after change
- [ ] Verify user session persists after password change
- [ ] Test error handling for NileDB failures
