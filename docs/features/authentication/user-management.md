---
title: "User Management & Authentication"
description: "User authentication, profile management, and account security in PenguinMails"
last_modified_date: "2026-02-24"
level: "2"
persona: "All Users, Developers"
status: "ACTIVE"
category: "Enterprise"
---

# User Management & Authentication

**Secure user authentication and comprehensive profile management powered by NileDB.**

---

## Implementation Modules

Explore the following modules for detailed specifications and integration guides:

### 1. [Authentication Flows](/docs/features/authentication/user-management/authentication-flows)

Secure workflows for user signup, login, logout, email verification, and password recovery.

### 2. [Profile & Preferences](/docs/features/authentication/user-management/profile-preferences)

Specifications for user identity management, regional settings, and notification preferences.

### 3. [Team & Workspace Management](/docs/features/authentication/user-management/team-workspace-management)

Granular access control for tenants, including team invitations, role assignments, and logical workspace isolation.

### 4. [Session & Token Security](/docs/features/authentication/user-management/session-security)

Technical details on JWT implementation, HttpOnly cookies, and administrative session controls.

---

## Strategic Goals

- **Security First**: Implementing defense-in-depth with multi-factor auth (Roadmap) and secure session management.
- **Tenant Autonomy**: Empowering tenant owners to manage their own teams and workspaces securely.
- **Global Compliance**: Supporting regional settings and data privacy standards (GDPR) through localized preferences.

---

## Access Control Summary

| Role | Scope | Key Permissions |
|------|-------|-----------------|
| **Owner** | Tenant-wide | Billing, Full Deletion, Role Management |
| **Admin** | Tenant-wide | User Invitations, Resource Config |
| **Member** | Workspace-scoped | Campaign Creation, Lead Management |
| **Viewer** | Workspace-scoped | Analytics Access (Read-only) |

---
**Last Updated**: 2026-02-24
**Status**: Active Documentation Hub

---

## Account Deletion

**Delete user account:**

```text
⚠️ Delete Account

This will permanently delete your account and all associated data.

Type "DELETE" to confirm: _______________

[Delete My Account]

```

**Deletion Process:**

```javascript
DELETE /api/v1/users/me
Authorization: Bearer {access_token}

{
  "confirmation": "DELETE",
  "password": "UserPass123!" // Confirm with password
}

Response:
{
  "success": true,
  "scheduled_deletion": "2025-12-24T10:00:00Z", // 30 days
  "message": "Account scheduled for deletion"
}

```

**What Happens:**

- Immediate: Account marked for deletion, access revoked
- 30 days: Grace period for account recovery
- After 30 days: Permanent deletion of all data

---

## Related Documentation

### Authentication & Security

- **[Authentication Roadmap](/docs/features/authentication/authentication-roadmap)** - Detailed authentication timeline and quarterly breakdown
- **[Team Management Roadmap](/docs/features/teams/team-roadmap)** - Detailed team & workspace management timeline
- **[Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture)** - Tenant isolation and workspace architecture
- **[Security Framework](/docs/compliance-security/enterprise/security-framework)** - Security overview
- **[Vault Integration](/docs/features/integrations/overview#vault-integration)** - Secure secrets management for API keys and credentials

### Implementation

- **[NileDB Authentication](/docs/implementation-technical/database-infrastructure/niledb)** - Auth implementation
- **[API Authentication](/docs/implementation-technical/api/platform-api/authentication)** - API auth details
- **[Public & Authentication Routes](/docs/design/routes/public-auth)** - Login, signup, password reset UI
- **[Settings Routes](/docs/design/routes/settings)** - Profile, team management, security settings UI

### Tasks

- **Epic 2: User Authentication** - Internal task reference for implementation work

### Roadmap

- **[Product Roadmap](/docs/operations/roadmap/product-roadmap/overview)** - Authentication features timeline
- **[Executive Roadmap](/docs/business/roadmap/executive-roadmap)** - Strategic authentication priorities

---

**Last Updated:** November 26, 2025
**Authentication Provider:** NileDB SDK
**Current Method:** Email + Password
**MVP Status:** In Progress (8 of 11 MVP features remaining)
**Next Milestone:** Q1 2026 - Complete MVP authentication features

*Secure user authentication is the foundation of platform security. NileDB provides enterprise-grade authentication with tenant isolation built-in. For MVP and near-term releases, we continue using NileDB's email/password authentication. OAuth 2.0 and SSO (SAML, OpenID Connect) are planned for Q2-Q3 2026 to meet enterprise customer requirements.*
