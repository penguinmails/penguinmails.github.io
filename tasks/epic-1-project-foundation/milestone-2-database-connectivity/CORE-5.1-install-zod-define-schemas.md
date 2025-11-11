# CORE-5.1: Install Zod and Define Core Schemas

**Ticket ID:** CORE-5.1  
**Milestone:** 2 - Database Connectivity & Data Integrity  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install the Zod library. In a new `/lib/schemas` directory, define and export Zod schemas for user signup and login, including fields like email, password, and name with appropriate validation rules.

## Context

Data validation is critical for security and data integrity. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), Zod will be used for:
- **API Request Validation:** Validating incoming request data
- **Type Safety:** Ensuring data matches expected types
- **Security:** Preventing invalid or malicious data from entering the system

Zod schemas will be used throughout the application for validating user input, API requests, and data transformations.

## Acceptance Criteria

1. ✅ `zod` is a dependency in `package.json`
2. ✅ A `/lib/schemas` directory exists
3. ✅ A `/lib/schemas/auth.schemas.ts` file exists
4. ✅ The `signupSchema` is defined and includes:
   - `email` (string, valid email format, required)
   - `password` (string, minimum length, required)
   - `name` (string, optional or required based on requirements)
5. ✅ The `loginSchema` is defined and includes:
   - `email` (string, valid email format, required)
   - `password` (string, required)
6. ✅ Both schemas correctly validate test objects
7. ✅ TypeScript types are inferred from the schemas

## Technical Details

### Required Package

```json
{
  "dependencies": {
    "zod": "^latest"
  }
}
```

### Schema Definitions

```typescript
// lib/schemas/auth.schemas.ts
import { z } from 'zod';

export const signupSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
  name: z.string().min(1, 'Name is required').optional(),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
});

// Export TypeScript types
export type SignupInput = z.infer<typeof signupSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
```

### Validation Rules

**Email:**
- Must be a valid email format
- Required field

**Password:**
- Minimum 8 characters (for signup)
- Required field
- Consider adding complexity requirements (future enhancement)

**Name:**
- Optional for signup (or required based on business requirements)
- String validation

## Implementation Notes

- Use Zod's built-in validators (email, min, etc.)
- Provide clear, user-friendly error messages
- Export TypeScript types inferred from schemas for type safety
- Consider adding password strength validation (future enhancement)
- Align validation rules with security best practices
- Consider adding rate limiting validation (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Validation patterns
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards.md) - Data validation requirements

## Dependencies

- **CORE-1.1** - Next.js project must be initialized

## Testing

- [ ] Verify Zod is installed correctly
- [ ] Test `signupSchema` with valid data - should pass
- [ ] Test `signupSchema` with invalid email - should fail with clear error
- [ ] Test `signupSchema` with short password - should fail with clear error
- [ ] Test `loginSchema` with valid data - should pass
- [ ] Test `loginSchema` with invalid email - should fail
- [ ] Verify TypeScript types are correctly inferred
- [ ] Test schema validation with edge cases (empty strings, null, undefined)


