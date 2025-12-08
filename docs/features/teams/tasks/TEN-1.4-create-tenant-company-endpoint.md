
# TEN-1.4: Create API Endpoint for Tenant & Company Creation (POST /api/tenants)

**Ticket ID:** TEN-1.4  
**Milestone:** 1 - Tenant and Company Creation  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route at `/api/tenants/route.ts`. This endpoint will orchestrate a multi-step process: first, use the Nile SDK to create a new tenant with the given name, and second, insert a new row into our companies table, associating it with the newly created tenant ID.

## Context

This endpoint is the critical first step in user onboarding. According to the [Implementation & Getting Started](/docs/implementation-getting-started/index), users need to create their workspace after signing up. This endpoint enables:

- **Tenant Creation:** Creating an isolated environment in NileDB
- **Company Creation:** Creating the first workspace within that tenant
- **Onboarding Flow:** Completing the initial setup process

The [High-Level Architecture](/docs/quick-access/high-level-architecture) emphasizes that each tenant gets complete data isolation, which begins with this endpoint.

## Acceptance Criteria

1. ✅ The endpoint is protected by the Nile middleware
2. ✅ It validates the request body using the `createTenantSchema` from TEN-1.3
3. ✅ It successfully creates a new tenant in NileDB using the Nile SDK
4. ✅ It generates a URL-friendly `workspace_name` from the company name
5. ✅ It successfully creates a new companies record in our database linked to the new tenant
6. ✅ It returns a `201 Created` response with the new tenant and company information
7. ✅ It handles errors gracefully (e.g., duplicate workspace_name, NileDB failures)
8. ✅ An unauthenticated request returns a `401 Unauthorized` error

## Technical Details

### API Route Structure

```typescript
// app/api/tenants/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { companies } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';
import { createTenantSchema } from '@/lib/schemas/tenant.schemas';
import { z } from 'zod';

// Helper function to generate URL-friendly workspace name
function generateWorkspaceName(companyName: string): string {
  return companyName
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-') // Replace non-alphanumeric with hyphens
    .replace(/^-+|-+$/g, '') // Remove leading/trailing hyphens
    .substring(0, 100); // Limit length
}

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
    const validatedData = createTenantSchema.parse(body);

    // Step 1: Create tenant in NileDB
    const tenant = await nile.tenants.createTenant({
      name: validatedData.tenantName,
    });

    // Step 2: Generate workspace name
    let workspaceName = generateWorkspaceName(validatedData.companyName);
    
    // Ensure uniqueness (add suffix if needed)
    let finalWorkspaceName = workspaceName;
    let suffix = 1;
    while (true) {
      const existing = await db
        .select()
        .from(companies)
        .where(eq(companies.workspaceName, finalWorkspaceName))
        .limit(1);
      
      if (existing.length === 0) break;
      finalWorkspaceName = `${workspaceName}-${suffix}`;
      suffix++;
    }

    // Step 3: Create company in our database
    const [company] = await db
      .insert(companies)
      .values({
        tenantId: tenant.id,
        name: validatedData.companyName,
        workspaceName: finalWorkspaceName,
      })
      .returning();

    return NextResponse.json(
      {
        tenant: {
          id: tenant.id,
          name: tenant.name,
        },
        company: {
          id: company.id,
          name: company.name,
          workspaceName: company.workspaceName,
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

    // Handle duplicate workspace name (shouldn't happen with uniqueness check, but safety)
    if (error.message?.includes('unique') || error.message?.includes('duplicate')) {
      return NextResponse.json(
        { error: 'Workspace name already exists' },
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
  "tenant": {
    "id": "tenant-uuid",
    "name": "My Tenant"
  },
  "company": {
    "id": "company-uuid",
    "name": "My Company",
    "workspaceName": "my-company"
  }
}
```

**Error Response (400):**

```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["tenantName"],
      "message": "Tenant name is required"
    }
  ]
}
```

## Implementation Notes

- Use NileDB SDK to create tenant first
- Generate URL-friendly workspace_name from company name
- Ensure workspace_name uniqueness (check existing and add suffix if needed)
- Create company record linked to the new tenant
- Handle errors gracefully (validation, duplicates, NileDB failures)
- Consider adding transaction support for atomicity (future enhancement)
- Log tenant/company creation for analytics (future enhancement)
- Consider adding limits on number of tenants per user (future enhancement)

## Related Documentation

- [High-Level Architecture](/docs/quick-access/high-level-architecture) - Multi-tenant architecture
- [API Reference](/docs/implementation-technical/development-guidelines/api-reference) - **Primary reference** for API development standards and patterns
- [OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-schema-guide) - Companies table structure
- [Implementation & Getting Started](/docs/implementation-getting-started/index) - Onboarding flow

## Dependencies

- [TEN-1.1](/docs/features/teams/tasks/TEN-1.1-define-companies-schema) - Companies schema must be defined
- [TEN-1.2](/docs/features/teams/tasks/TEN-1.2-generate-apply-migration) - Companies table must exist in database
- [TEN-1.3](/docs/features/teams/tasks/TEN-1.3-define-tenant-creation-schema) - Create tenant schema must be defined
- [CORE-3.1](/docs/features/authentication/tasks/CORE-3.1-install-configure-niledb) - NileDB SDK must be configured (from Epic 1)
- [CORE-3.2](/docs/features/authentication/tasks/CORE-3.2-implement-middleware) - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request with valid data - verify 201 response
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with invalid data - verify 400 error with validation details
- [ ] Verify tenant is created in NileDB
- [ ] Verify company is created in database with correct tenant_id
- [ ] Verify workspace_name is generated correctly and is unique
- [ ] Test with duplicate company name - verify workspace_name uniqueness handling
- [ ] Test error handling for NileDB failures
- [ ] Test error handling for database failures
- [ ] Verify response includes both tenant and company information

---

## Cross-References

- **Routes**: [workspace-management.md]()
- **API**: [tenant-api/](/docs/implementation-technical/api/tenant-api/)
