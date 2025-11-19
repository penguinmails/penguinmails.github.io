---
title: "TEN-2.1: Create API Endpoint to List Companies (GET /api/companies)"
description: "Documentation for TEN-2.1: Create API Endpoint to List Companies (GET /api/companies) - TEN 2.1 List Companies Endpoint"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# TEN-2.1: Create API Endpoint to List Companies (GET /api/companies)

**Ticket ID:** TEN-2.1  
**Milestone:** 2 - Viewing and Managing Workspaces  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected GET API route at `/api/companies/route.ts`. This endpoint will use the `tenantId` from the Nile session context to query the companies table via Drizzle and return a list of all companies belonging to that tenant.

## Context

Listing companies is essential for workspace management. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), tenant isolation is critical—users should only see companies within their tenant. This endpoint enables users to view all their workspaces while maintaining complete data isolation.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It correctly uses the `tenantId` from the Nile session context in its WHERE clause
3. ✅ It returns a `200 OK` with an array of company objects
4. ✅ The array should be empty if no companies exist for that tenant
5. ✅ An unauthenticated request returns a `401 Unauthorized` error
6. ✅ The response includes relevant company information (id, name, workspace_name, logo_url, etc.)
7. ✅ Companies from other tenants are never returned (tenant isolation enforced)

## Technical Details

### API Route Structure

```typescript
// app/api/companies/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { db } from '@/lib/db';
import { companies } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

export async function GET(request: NextRequest) {
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

    // Query companies for this tenant
    const companiesList = await db
      .select({
        id: companies.id,
        name: companies.name,
        workspaceName: companies.workspaceName,
        logoUrl: companies.logoUrl,
        createdAt: companies.createdAt,
        updatedAt: companies.updatedAt,
      })
      .from(companies)
      .where(eq(companies.tenantId, tenantId))
      .orderBy(companies.createdAt);

    return NextResponse.json(
      {
        companies: companiesList,
        count: companiesList.length,
      },
      { status: 200 }
    );
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
  "companies": [
    {
      "id": "company-uuid",
      "name": "My Company",
      "workspaceName": "my-company",
      "logoUrl": "https://example.com/logo.png",
      "createdAt": "2025-10-27T12:00:00.000Z",
      "updatedAt": "2025-10-27T12:00:00.000Z"
    }
  ],
  "count": 1
}
```

**Empty Response (200):**

```json
{
  "companies": [],
  "count": 0
}
```

## Implementation Notes

- Use `tenantId` from session context (not from request parameters)
- Always filter by tenantId to enforce tenant isolation
- Order results by creation date (newest first) or name (alphabetical)
- Return empty array if no companies exist (not an error)
- Include count in response for convenience
- Consider adding pagination (future enhancement)
- Consider adding filtering/sorting options (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Tenant isolation
- [Features & Capabilities](../../docs/features-capabilities/index) - Workspace management

## Dependencies

- **TEN-1.1** - Companies schema must be defined
- **TEN-1.2** - Companies table must exist in database
- **CORE-3.1** - NileDB SDK must be configured (from Epic 1)
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request - verify 200 response with companies array
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with tenant that has companies - verify all companies returned
- [ ] Test with tenant that has no companies - verify empty array returned
- [ ] Verify companies from other tenants are never returned
- [ ] Verify tenantId from session is used (not from request)
- [ ] Test error handling for database failures
- [ ] Verify response format matches expected structure
