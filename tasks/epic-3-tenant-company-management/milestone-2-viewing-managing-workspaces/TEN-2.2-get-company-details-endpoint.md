# TEN-2.2: Create API Endpoint to Get Company Details (GET /api/companies/{companyId})

**Ticket ID:** TEN-2.2  
**Milestone:** 2 - Viewing and Managing Workspaces  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/companies/[companyId]/route.ts`. This endpoint will fetch the details for a single company, but must first verify that the requested `companyId` belongs to the user's current tenant.

## Context

Viewing individual company details is essential for workspace management. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), tenant isolation must be enforced—users should only access companies within their tenant. This endpoint enables detailed company viewing while maintaining security.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It retrieves the `companyId` from the URL parameters
3. ✅ It queries the database for a company matching both the `companyId` and the `tenantId` from the session
4. ✅ If found, it returns a `200 OK` with the company's details
5. ✅ If not found (or if it belongs to another tenant), it returns a `404 Not Found` error
6. ✅ An unauthenticated request returns a `401 Unauthorized` error
7. ✅ The response includes all relevant company information

## Technical Details

### API Route Structure

```typescript
// app/api/companies/[companyId]/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { companies } from '@/lib/db/schema';
import { eq, and } from 'drizzle-orm';

export async function GET(
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

    // Query company with tenant isolation check
    const [company] = await db
      .select()
      .from(companies)
      .where(
        and(
          eq(companies.id, companyId),
          eq(companies.tenantId, tenantId)
        )
      )
      .limit(1);

    if (!company) {
      return NextResponse.json(
        { error: 'Company not found' },
        { status: 404 }
      );
    }

    return NextResponse.json(company, { status: 200 });
  } catch (error) {
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
  "name": "My Company",
  "workspaceName": "my-company",
  "logoUrl": "https://example.com/logo.png",
  "createdAt": "2025-10-27T12:00:00.000Z",
  "updatedAt": "2025-10-27T12:00:00.000Z"
}
```

**Error Response (404):**
```json
{
  "error": "Company not found"
}
```

## Implementation Notes

- Always verify company belongs to user's tenant (use AND condition)
- Return 404 if company doesn't exist OR belongs to another tenant (don't reveal which)
- Use URL parameter for companyId (Next.js dynamic route)
- Include all company fields in response
- Consider adding related data (e.g., user count, project count) (future enhancement)
- Consider adding permission checks (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Tenant isolation
- [Features & Capabilities](../../docs/features-capabilities/index.md) - Workspace management

## Dependencies

- **TEN-1.1** - Companies schema must be defined
- **TEN-1.2** - Companies table must exist in database
- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request with valid companyId - verify 200 response
- [ ] Test authenticated request with invalid companyId - verify 404 error
- [ ] Test authenticated request with companyId from another tenant - verify 404 error
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with missing tenantId in session - verify 400 error
- [ ] Verify response includes all company fields
- [ ] Test error handling for database failures
- [ ] Verify tenant isolation is enforced (cannot access other tenant's companies)


