
# AUTH-4.3: Implement "Reset Password" Endpoint

**Ticket ID:** AUTH-4.3  
**Milestone:** 2 - Enhanced Authentication and Security  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a public POST API route at `/api/auth/reset-password/route.ts`. This endpoint will accept a password reset token (from the email link) and a new password, then use the Nile SDK to securely update the user's credentials.

## Context

Password reset completion is the second step in the password recovery flow. According to the [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards), secure password management is essential for data protection. This endpoint allows users to complete the password reset process initiated in AUTH-4.2.

## Acceptance Criteria

1. ✅ The endpoint is public (no authentication required)
2. ✅ It validates the request body:
   - `token` is present and valid format
   - `newPassword` meets complexity requirements (minimum length, etc.)
3. ✅ It calls the Nile SDK's function to confirm the password update
4. ✅ After a successful reset, the user should be able to log in with their new password
5. ✅ Invalid token returns a `400 Bad Request` or `401 Unauthorized` error
6. ✅ Weak password returns a `400 Bad Request` error with validation details
7. ✅ Successful reset returns a `200 OK` response

## Technical Details

### API Route Structure

```typescript
// app/api/auth/reset-password/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { z } from 'zod';

const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  newPassword: z.string().min(8, 'Password must be at least 8 characters'),
  // Consider adding password complexity requirements:
  // .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
  // .regex(/[a-z]/, 'Password must contain at least one lowercase letter')
  // .regex(/[0-9]/, 'Password must contain at least one number')
});

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = resetPasswordSchema.parse(body);

    // Use Nile SDK to reset password
    await nile.auth.resetPassword({
      token: validatedData.token,
      newPassword: validatedData.newPassword,
    });

    return NextResponse.json(
      {
        success: true,
        message: 'Password has been reset successfully. You can now log in with your new password.',
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

    // Handle invalid or expired token
    if (error.message?.includes('token') || error.message?.includes('invalid') || error.message?.includes('expired')) {
      return NextResponse.json(
        { error: 'Invalid or expired reset token' },
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
  "message": "Password has been reset successfully. You can now log in with your new password."
}
```

**Error Response (400) - Invalid Token:**

```json
{
  "error": "Invalid or expired reset token"
}
```

**Error Response (400) - Validation Error:**

```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["newPassword"],
      "message": "Password must be at least 8 characters"
    }
  ]
}
```

## Implementation Notes

- Validate token format and presence
- Enforce password complexity requirements (minimum length, etc.)
- Use NileDB's reset password function
- Provide clear error messages for invalid/expired tokens
- Consider adding password strength validation (future enhancement)
- Consider adding token expiration checking (if not handled by NileDB)
- Log password reset completions for security monitoring (future enhancement)
- After successful reset, the user should log in with the new password

## Related Documentation

- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards) - Password security requirements
- [Features & Capabilities](../../docs/features-capabilities/index) - Account security features

## Dependencies

- **AUTH-4.2** - Forgot password endpoint should be implemented (for context)
- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-5.1** - Zod must be installed (from Epic 1)

## Testing

- [ ] Test with valid token and strong password - verify 200 response
- [ ] Test with invalid token - verify 400 error
- [ ] Test with expired token - verify 400 error
- [ ] Test with short password - verify 400 error with validation details
- [ ] Test with missing token - verify 400 error
- [ ] Test with missing password - verify 400 error
- [ ] Verify user can log in with new password after reset
- [ ] Test error handling for NileDB failures
- [ ] Test that old password no longer works after reset
