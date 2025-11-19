# Milestone 3: Tenant User Management

**Goal:** To implement the functionality for inviting and managing users within a tenant. This relies heavily on the NileDB SDK's built-in user management features.

## Tickets

- [TEN-3.1](./TEN-3.1-list-tenant-members-endpoint) - Create API Endpoint to List Tenant Members (GET /api/tenants/users)
- [TEN-3.2](./TEN-3.2-invite-user-endpoint) - Create API Endpoint to Invite a User (POST /api/tenants/invites)
- [TEN-3.3](./TEN-3.3-remove-user-endpoint) - Create API Endpoint to Remove a User (DELETE /api/tenants/users/{userId})

## Dependencies

- **Milestone 1** must be completed
- **Milestone 2** should be completed (for consistency)
- Requires NileDB tenant user management functionality

## Success Criteria

- ✅ Users can list all members in their tenant
- ✅ Users can invite new members to their tenant
- ✅ Users can remove members from their tenant
- ✅ All operations properly scoped to tenant context
- ✅ Security checks prevent self-removal

## Context

This milestone implements team collaboration features. According to the [Team Workflow](../../docs/quick-access/team-workflow), PenguinMails uses a 4-tier staff hierarchy and team management. This milestone enables the tenant-level user management that supports team collaboration.
