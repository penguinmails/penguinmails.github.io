
# Milestone 2: Viewing and Managing Workspaces

**Goal:** To provide users with the ability to see and manage the Companies (Workspaces) that exist within their current tenant context.

## Tickets

- [TEN-2.1](./TEN-2.1-list-companies-endpoint) - Create API Endpoint to List Companies (GET /api/companies)
- [TEN-2.2](./TEN-2.2-get-company-details-endpoint) - Create API Endpoint to Get Company Details (GET /api/companies/{companyId})
- [TEN-2.3](./TEN-2.3-define-company-update-schema) - Define Zod Schema for Company Updates
- [TEN-2.4](./TEN-2.4-update-company-endpoint) - Create API Endpoint to Update a Company (PATCH /api/companies/{companyId})

## Dependencies

- **Milestone 1** must be completed
- Requires companies table to exist
- Requires tenant context from session

## Success Criteria

- ✅ Users can list all companies in their tenant
- ✅ Users can view individual company details
- ✅ Users can update company information
- ✅ All endpoints properly enforce tenant isolation
- ✅ Validation schemas working correctly

## Context

This milestone enables workspace management functionality. According to the [Features & Capabilities](../../docs/features-capabilities/index), agencies need to manage multiple client workspaces, which this milestone supports through the companies management endpoints.
