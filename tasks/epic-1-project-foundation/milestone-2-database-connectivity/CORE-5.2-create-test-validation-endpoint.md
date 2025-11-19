---
title: "CORE-5.2: Create a Test API Endpoint for Zod Validation"
description: "Documentation for CORE-5.2: Create a Test API Endpoint for Zod Validation - CORE 5.2 Create Test Validation Endpoint"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# CORE-5.2: Create a Test API Endpoint for Zod Validation

**Ticket ID:** CORE-5.2  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a POST API route handler at `/app/api/test/validation/route.ts`. This endpoint should parse the request body using the `signupSchema` from the previous ticket and return a success or error response.

## Context

This endpoint serves as a test to verify that Zod validation is working correctly in the Next.js API route context. It demonstrates the pattern that will be used throughout the application for validating API requests.

## Acceptance Criteria

1. ✅ A POST API route exists at `/app/api/test/validation/route.ts`
2. ✅ The endpoint uses the `signupSchema` from CORE-5.1 to validate the request body
3. ✅ Sending a valid JSON body returns a `200 OK` response with a success message
4. ✅ Sending a body with an invalid email returns a `400 Bad Request` response with a clear JSON error message detailing the validation failures
5. ✅ Sending a body with a short password returns a `400 Bad Request` response with validation error details
6. ✅ The error response includes specific field-level error messages
7. ✅ The endpoint handles missing request body gracefully

## Technical Details

### API Route Structure

```typescript
// app/api/test/validation/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { signupSchema } from '@/lib/schemas/auth.schemas';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const validatedData = signupSchema.parse(body);
    
    return NextResponse.json(
      { 
        success: true, 
        message: 'Validation passed',
        data: validatedData 
      },
      { status: 200 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { 
          success: false,
          errors: error.errors 
        },
        { status: 400 }
      );
    }
    
    return NextResponse.json(
      { 
        success: false,
        message: 'Internal server error' 
      },
      { status: 500 }
    );
  }
}
```

### Expected Response Formats

**Success Response (200):**

```json
{
  "success": true,
  "message": "Validation passed",
  "data": {
    "email": "user@example.com",
    "password": "securepassword123",
    "name": "John Doe"
  }
}
```

**Error Response (400):**

```json
{
  "success": false,
  "errors": [
    {
      "path": ["email"],
      "message": "Invalid email address"
    },
    {
      "path": ["password"],
      "message": "Password must be at least 8 characters"
    }
  ]
}
```

## Implementation Notes

- Use Next.js 15 App Router API route conventions
- Handle JSON parsing errors gracefully
- Provide clear, user-friendly error messages
- Consider adding request logging for debugging
- This is a test endpoint - consider removing or protecting it in production
- Use proper TypeScript types throughout

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - API architecture
- [Implementation & Getting Started](../../docs/implementation-getting-started/index) - API development

## Dependencies

- **CORE-1.1** - Next.js project must be initialized
- **CORE-5.1** - Zod schemas must be defined

## Testing

- [ ] Send a POST request with valid data - verify 200 response
- [ ] Send a POST request with invalid email - verify 400 response with error details
- [ ] Send a POST request with short password - verify 400 response with error details
- [ ] Send a POST request with missing required fields - verify 400 response
- [ ] Send a POST request with invalid JSON - verify 400 or 500 response
- [ ] Send a POST request with no body - verify appropriate error response
- [ ] Test with various edge cases (empty strings, null values, etc.)
- [ ] Verify error messages are clear and helpful
