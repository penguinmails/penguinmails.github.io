# AUTH-3.4: Define Zod Schema for Profile Updates

**Ticket ID:** AUTH-3.4  
**Milestone:** 1 - Foundational User Profile API  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In the `/lib/schemas` directory, create a new `user.schemas.ts` file. Define and export a Zod schema (`updateProfileSchema`) for validating incoming profile update requests. Make all fields optional using `.optional()` so a user can update just one field at a time.

## Context

Data validation is critical for security and data integrity. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), Zod schemas are used throughout the application for:

- **API Request Validation:** Validating incoming request data
- **Type Safety:** Ensuring data matches expected types
- **Security:** Preventing invalid or malicious data from entering the system

This schema will validate profile updates, allowing users to update individual fields without requiring all fields to be present.

## Acceptance Criteria

1. ✅ A `/lib/schemas/user.schemas.ts` file exists
2. ✅ The `updateProfileSchema` is defined with optional fields for:
   - `name` (string, optional)
   - `given_name` (string, optional, if applicable)
   - `family_name` (string, optional, if applicable)
   - `theme` (string, enum: 'light', 'dark', 'system', optional)
   - `language` (string, ISO 639-1 code, optional)
   - `timezone` (string, IANA timezone, optional)
   - `emailNotifications` (boolean, optional)
   - `pushNotifications` (boolean, optional)
3. ✅ All fields are optional (using `.optional()`)
4. ✅ Validation rules are appropriate (e.g., email format, enum values)
5. ✅ TypeScript types are inferred from the schema
6. ✅ The schema correctly validates test objects

## Technical Details

### Schema Definition

```typescript
// lib/schemas/user.schemas.ts
import { z } from 'zod';

export const updateProfileSchema = z.object({
  // User profile fields
  name: z.string().min(1, 'Name cannot be empty').max(255, 'Name is too long').optional(),
  givenName: z.string().min(1).max(100).optional(),
  familyName: z.string().min(1).max(100).optional(),
  
  // User preferences fields
  theme: z.enum(['light', 'dark', 'system'], {
    errorMap: () => ({ message: 'Theme must be light, dark, or system' }),
  }).optional(),
  
  language: z.string().length(2, 'Language must be a 2-letter ISO code').optional(), // ISO 639-1
  timezone: z.string().min(1, 'Timezone cannot be empty').optional(), // IANA timezone
  
  emailNotifications: z.boolean().optional(),
  pushNotifications: z.boolean().optional(),
}).refine(
  (data) => Object.keys(data).length > 0,
  {
    message: 'At least one field must be provided for update',
  }
);

// Export TypeScript type
export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
```

### Validation Rules

**Name Fields:**

- Optional
- If provided, must be non-empty strings
- Reasonable length limits

**Theme:**

- Optional
- Must be one of: 'light', 'dark', 'system'
- Enum validation

**Language:**

- Optional
- Should be ISO 639-1 code (2 letters)
- Consider adding allowed values list (future enhancement)

**Timezone:**

- Optional
- Should be valid IANA timezone
- Consider adding validation for valid timezone (future enhancement)

**Notification Settings:**

- Optional
- Boolean values

## Implementation Notes

- Use Zod's built-in validators (enum, string, boolean)
- Provide clear, user-friendly error messages
- Use `.refine()` to ensure at least one field is provided
- Export TypeScript types inferred from schemas
- Consider adding more strict validation for language and timezone (future enhancement)
- Align validation rules with database schema constraints

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Validation patterns
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards) - Data validation requirements

## Dependencies

- **CORE-5.1** - Zod must be installed (from Epic 1)
- **AUTH-3.1** - User preferences schema must be defined (to know what fields to validate)

## Testing

- [ ] Test schema with valid data - should pass
- [ ] Test schema with single field update - should pass
- [ ] Test schema with multiple fields - should pass
- [ ] Test schema with invalid theme value - should fail with clear error
- [ ] Test schema with empty object - should fail (at least one field required)
- [ ] Test schema with invalid language code - should fail
- [ ] Verify TypeScript types are correctly inferred
- [ ] Test schema with all fields - should pass
