
# Milestone 1: Tenant and Company Creation

**Goal:** To enable a new user to create their first Tenant and an associated Company (Workspace). This is the crucial first step in the user onboarding flow after they sign up.

## Tickets

- [TEN-1.1](./TEN-1.1-define-companies-schema) - Define Drizzle Schema for companies
- [TEN-1.2](./TEN-1.2-generate-apply-migration) - Generate and Apply companies Migration
- [TEN-1.3](./TEN-1.3-define-tenant-creation-schema) - Define Zod Schema for Tenant & Company Creation
- [TEN-1.4](./TEN-1.4-create-tenant-company-endpoint) - Create API Endpoint for Tenant & Company Creation (POST /api/tenants)

## Dependencies

- **Epic 1** must be fully completed
- **Epic 2** must be fully completed
- Requires NileDB tenant creation functionality
- Requires database connection and Drizzle ORM configured

## Success Criteria

- ✅ Companies table schema defined
- ✅ Migration applied successfully
- ✅ Validation schema for tenant/company creation
- ✅ Users can create their first tenant and company
- ✅ Tenant isolation properly enforced

## Context

This milestone establishes the foundation for multi-tenancy. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), each tenant gets complete data isolation while sharing efficient infrastructure. This milestone enables users to create their isolated workspace.
