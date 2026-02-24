---
title: "Team & Workspace Management"
description: "Managing tenant users, team invitations, roles, and workspace isolation."
last_modified_date: "2026-02-24"
level: "2"
persona: "Administrators"
---

# Team & Workspace Management

PenguinMails supports multi-member tenants with granular access control and logical workspace isolation, ideal for agencies and large organizations.

## 1. Team Invitations

Invite new members to a tenant with specific role assignments.

**API Endpoint:**

```javascript
POST /api/v1/tenants/{tenant_id}/invitations
{
  "email": "newuser@example.com",
  "role": "admin",
  "workspaces": ["ws_abc123", "ws_def456"]
}

Response:
{
  "invitation_id": "inv_abc123",
  "status": "pending",
  "expires_at": "2025-12-01T10:00:00Z"
}
```

## 2. Member Management

Tenant owners and admins can view and modify member statuses.

**Fetch Team List:**
`GET /api/v1/tenants/{tenant_id}/users`

**Update Role:**
`PUT /api/v1/tenants/{tenant_id}/users/{user_id}`

**Remove Member:**
`DELETE /api/v1/tenants/{tenant_id}/users/{user_id}`
*Note: Data ownership is transferred to the tenant owner upon removal.*

## 3. User Suspension

Suspension provides a reversible way to restrict access while preserving data.

**Key Features:**

- User cannot log in to the tenant.
- Existing sessions are invalidated.
- Role and workspace assignments are preserved.
- Records are kept for audit logging.

**API Endpoint:**
`POST /api/v1/tenants/{tenant_id}/users/{user_id}/suspend`

## 4. Workspace Isolation

Workspaces provide secure boundaries within a single tenant (Agency model).

- **Isolated Data**: Campaigns, leads, and assets are siloed.
- **Health Monitoring**: Independent deliverability scores (0-100).
- **Organization**: List workspaces via `/dashboard/workspaces`.

**See Also**: [Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture) for deep technical details.
