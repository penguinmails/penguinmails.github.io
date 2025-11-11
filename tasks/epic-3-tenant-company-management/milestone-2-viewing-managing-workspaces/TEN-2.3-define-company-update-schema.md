# TEN-2.3: Define Zod Schema for Company Updates

**Ticket ID:** TEN-2.3  
**Milestone:** 2 - Viewing and Managing Workspaces  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In `/lib/schemas/tenant.schemas.ts`, define and export a Zod schema (`updateCompanySchema`) for validating requests to update a company. Fields like `name` and `logo_url` should be optional.

## Context

Data validation is critical for security and data integrity. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), Zod schemas are used throughout the application for API request validation. This schema will validate company update requests, allowing users to update individual fields without requiring all fields to be present.

## Acceptance Criteria

1. ✅ The `updateCompanySchema` is defined in `/lib/schemas/tenant.schemas.ts`
2. ✅ The schema includes optional fields:
   - `name` (string, optional)
   - `logo_url` (string, optional, valid URL format)
3. ✅ All fields are optional (using `.optional()`)
4. ✅ Validation rules are appropriate (e.g., length limits, URL format)
5. ✅ TypeScript types are inferred from the schema
6. ✅ The schema correctly validates test objects
7. ✅ At least one field must be provided (using `.refine()`)

## Technical Details

### Schema Definition

```typescript
// lib/schemas/tenant.schemas.ts
import { z } from 'zod';

// Add to existing file or create new
export const updateCompanySchema = z.object({
  name: z
    .string()
    .min(1, 'Company name cannot be empty')
    .max(255, 'Company name must be 255 characters or less')
    .trim()
    .optional(),
  logoUrl: z
    .string()
    .url('Logo URL must be a valid URL')
    .max(500, 'Logo URL must be 500 characters or less')
    .optional(),
}).refine(
  (data) => Object.keys(data).length > 0,
  {
    message: 'At least one field must be provided for update',
  }
);

// Export TypeScript type
export type UpdateCompanyInput = z.infer<typeof updateCompanySchema>;
```

### Validation Rules

**Name:**
- Optional field
- If provided, must be non-empty string (after trimming)
- Maximum 255 characters
- Trimmed to remove leading/trailing whitespace

**Logo URL:**
- Optional field
- If provided, must be valid URL format
- Maximum 500 characters

**General:**
- At least one field must be provided (using `.refine()`)

## Implementation Notes

- Use Zod's built-in validators (string, url, min, max, trim)
- Provide clear, user-friendly error messages
- Use `.refine()` to ensure at least one field is provided
- Export TypeScript types inferred from schemas
- Consider adding more strict validation (e.g., image URL validation) (future enhancement)
- Align validation rules with database schema constraints

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Validation patterns
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards.md) - Data validation requirements

## Dependencies

- **CORE-5.1** - Zod must be installed (from Epic 1)
- **TEN-1.3** - Tenant schemas file should exist (can add to same file)

## Testing

- [ ] Test schema with valid data - should pass
- [ ] Test schema with single field update - should pass
- [ ] Test schema with multiple fields - should pass
- [ ] Test schema with empty object - should fail (at least one field required)
- [ ] Test schema with invalid URL - should fail with clear error
- [ ] Test schema with very long name - should fail if exceeds max length
- [ ] Verify TypeScript types are correctly inferred
- [ ] Test schema with all fields - should pass


