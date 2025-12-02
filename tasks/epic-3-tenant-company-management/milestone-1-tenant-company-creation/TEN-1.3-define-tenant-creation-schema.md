
# TEN-1.3: Define Zod Schema for Tenant & Company Creation

**Ticket ID:** TEN-1.3  
**Milestone:** 1 - Tenant and Company Creation  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

In a new `/lib/schemas/tenant.schemas.ts` file, define and export a Zod schema (`createTenantSchema`) for validating requests to create a new tenant. This schema should include fields for `tenant_name` and `company_name`.

## Context

Data validation is critical for security and data integrity. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), Zod schemas are used throughout the application for:

- **API Request Validation:** Validating incoming request data
- **Type Safety:** Ensuring data matches expected types
- **Security:** Preventing invalid or malicious data from entering the system

This schema will validate tenant and company creation requests, ensuring data quality and security.

## Acceptance Criteria

1. ✅ A `/lib/schemas/tenant.schemas.ts` file exists
2. ✅ The `createTenantSchema` is defined with:
   - `tenant_name` (string, required, non-empty, reasonable length)
   - `company_name` (string, required, non-empty, reasonable length)
3. ✅ The schema correctly validates that both fields are non-empty strings
4. ✅ Validation rules are appropriate (e.g., length limits, character restrictions)
5. ✅ TypeScript types are inferred from the schema
6. ✅ The schema correctly validates test objects

## Technical Details

### Schema Definition

```typescript
// lib/schemas/tenant.schemas.ts
import { z } from 'zod';

export const createTenantSchema = z.object({
  tenantName: z
    .string()
    .min(1, 'Tenant name is required')
    .max(100, 'Tenant name must be 100 characters or less')
    .trim(),
  companyName: z
    .string()
    .min(1, 'Company name is required')
    .max(255, 'Company name must be 255 characters or less')
    .trim(),
});

// Export TypeScript type
export type CreateTenantInput = z.infer<typeof createTenantSchema>;
```

### Validation Rules

**Tenant Name:**

- Required field
- Minimum 1 character (after trimming)
- Maximum 100 characters
- Trimmed to remove leading/trailing whitespace

**Company Name:**

- Required field
- Minimum 1 character (after trimming)
- Maximum 255 characters
- Trimmed to remove leading/trailing whitespace

### Future Enhancements

Consider adding:

- Character restrictions (e.g., no special characters for tenant name)
- Workspace name validation (URL-friendly format)
- Reserved name checking (future enhancement)

## Implementation Notes

- Use Zod's built-in validators (string, min, max, trim)
- Provide clear, user-friendly error messages
- Export TypeScript types inferred from schemas
- Consider adding more strict validation for workspace_name generation (future enhancement)
- Align validation rules with database schema constraints
- Consider adding reserved name validation (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Validation patterns
- [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards) - Data validation requirements

## Dependencies

- **CORE-5.1** - Zod must be installed (from Epic 1)

## Testing

- [ ] Test schema with valid data - should pass
- [ ] Test schema with empty tenant_name - should fail with clear error
- [ ] Test schema with empty company_name - should fail with clear error
- [ ] Test schema with very long names - should fail if exceeds max length
- [ ] Test schema with whitespace-only names - should fail (after trim)
- [ ] Verify TypeScript types are correctly inferred
- [ ] Test schema with missing fields - should fail
- [ ] Test schema with non-string values - should fail
