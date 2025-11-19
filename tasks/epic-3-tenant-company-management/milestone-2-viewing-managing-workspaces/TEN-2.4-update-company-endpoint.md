# TEN-2.4: Create API Endpoint to Update a Company (PATCH /api/companies/{companyId})

**Ticket ID:** TEN-2.4  
**Milestone:** 2 - Viewing and Managing Workspaces  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected PATCH API route at `/api/companies/[companyId]/route.ts`. This endpoint will validate the request body and update the specified company, ensuring the user has permission to do so.

## Context

Company updates are essential for workspace management. According to the [Features & Capabilities](../../docs/features-capabilities/index), users need to manage their workspace settings. This endpoint enables users to update company information while maintaining tenant isolation and security.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It validates the request body with the `updateCompanySchema` from TEN-2.3
3. ✅ It verifies that the company belongs to the user's tenant before performing the update
4. ✅ On success, it updates the company's record in the database and returns a `200 OK` with the updated data
5. ✅ If company not found or belongs to another tenant, it returns a `404 Not Found` error
6. ✅ Invalid data returns a `400 Bad Request` error
7. ✅ An unauthenticated request returns a `401 Unauthorized` error

## Technical Details

### API Route Structure

```typescript
// app/api/companies/[companyId]/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { companies } from '@/lib/db/schema';
import { eq, and } from 'drizzle-orm';
import { updateCompanySchema } from '@/lib/schemas/tenant.schemas';
import { z } from 'zod';

export async function PATCH(
  request: NextRequest,
  { params }: { params: { companyId: string } }
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

    // Get companyId from URL parameters
    const { companyId } = params;

    // Validate request body
    const body = await request.json();
    const validatedData = updateCompanySchema.parse(body);

    // Verify company exists and belongs to user's tenant
    const [existingCompany] = await db
      .select()
      .from(companies)
      .where(
        and(
          eq(companies.id, companyId),
          eq(companies.tenantId, tenantId)
        )
      )
      .limit(1);

    if (!existingCompany) {
      return NextResponse.json(
        { error: 'Company not found' },
        { status: 404 }
      );
    }

    // Prepare update data
    const updateData: Partial<typeof companies.$inferInsert> = {};
    if (validatedData.name !== undefined) updateData.name = validatedData.name;
    if (validatedData.logoUrl !== undefined) updateData.logoUrl = validatedData.logoUrl;
    updateData.updatedAt = new Date();

    // Update company
    const [updatedCompany] = await db
      .update(companies)
      .set(updateData)
      .where(eq(companies.id, companyId))
      .returning();

    return NextResponse.json(updatedCompany, { status: 200 });
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
  "id": "company-uuid",
  "tenantId": "tenant-uuid",
  "name": "Updated Company Name",
  "workspaceName": "my-company",
  "logoUrl": "https://example.com/new-logo.png",
  "createdAt": "2025-10-27T12:00:00.000Z",
  "updatedAt": "2025-10-27T13:00:00.000Z"
}
```

**Error Response (404):**

```json
{
  "error": "Company not found"
}
```

**Error Response (400):**

```json
{
  "error": "Validation failed",
  "errors": [
    {
      "path": ["logoUrl"],
      "message": "Logo URL must be a valid URL"
    }
  ]
}
```

## Implementation Notes

- Use PATCH method for partial updates
- Always verify company belongs to user's tenant before updating
- Update only provided fields (partial update)
- Update `updatedAt` timestamp
- Return complete updated company in response
- Never allow updating `tenantId` or `workspaceName` (security)
- Consider adding audit logging for company changes (future enhancement)
- Consider adding permission checks (e.g., only admins can update) (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Tenant isolation
- [Features & Capabilities](../../docs/features-capabilities/index) - Workspace management

## Dependencies

- **TEN-2.2** - GET company endpoint exists (for reference)
- **TEN-2.3** - Update company schema must be defined
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request with valid data - verify 200 response
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with companyId from another tenant - verify 404 error
- [ ] Test with invalid companyId - verify 404 error
- [ ] Test updating single field - verify only that field is updated
- [ ] Test updating multiple fields - verify all fields are updated
- [ ] Test with invalid data - verify 400 error with validation details
- [ ] Verify tenantId cannot be updated (security)
- [ ] Verify workspaceName cannot be updated (security)
- [ ] Test error handling for database failures
- [ ] Verify updatedAt timestamp is updated correctly
