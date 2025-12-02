---
title: "User Management & Authentication"
description: "User authentication, profile management, and account security in PenguinMails"
last_modified_date: "2025-11-26"
level: "2"
persona: "All Users, Developers"
status: "ACTIVE"
category: "Enterprise"
---

# User Management & Authentication

**Secure user authentication and comprehensive profile management powered by NileDB.**

---

## MVP Status & Roadmap

### Current Status: MVP In Progress

**What's Available Today:**

- âœ… Email/password signup and login

- âœ… Email verification flow

- âœ… Password reset flow

- âœ… Change password (authenticated)

- âœ… JWT-based session management

- âœ… Token refresh mechanism

- âœ… Profile management (view/edit)

- âœ… Team member invitations

- âœ… Role-based access control (Owner/Admin/Member)

- âœ… Account deletion with grace period

**Missing MVP Features (Q1 2026):**

- â³ Account lockout / brute force protection

- â³ Session management UI (view/revoke active sessions)

- â³ Email change verification flow UI

- â³ Password strength enforcement (server-side)

- â³ Login activity log

- â³ Unverified email restrictions

- â³ Remember me functionality

- â³ CAPTCHA for sensitive operations

**Post-MVP Enhancements (2026+):**

- ðŸ”® Two-factor authentication (2FA) - Q1 2026

- ðŸ”® Social login (OAuth) - Q2 2026

- ðŸ”® Single sign-on (SSO) for enterprise - Q3 2026

- ðŸ”® Biometric authentication - Q4 2026

- ðŸ”® Advanced session management - Q4 2026

**Detailed Roadmap:** [Authentication Roadmap](/docs/features/enterprise/authentication-roadmap)

---

## Overview

PenguinMails provides enterprise-grade user authentication with email/password login, profile management, password security features, and session management - all built on NileDB's secure authentication framework.

### Authentication Features

- ðŸ” **Secure Login** - Email/password authentication via NileDB SDK

- ðŸ‘¤ **Profile Management** - Self-service profile editing

- ðŸ”‘ **Password Security** - Forgot/reset/change password workflows

- ðŸšª **Session Management** - Secure token-based sessions

- ðŸ‘¥ **Team Management** - Multi-user tenant support

- ðŸ“§ **Email Verification** - Confirmed email addresses only

---

## Level 1: User Authentication

### Sign Up (Registration)

**Create a new account and tenant:**

```text
Sign Up Form:

- Email Address *

- Full Name *

- Password * (min 8 characters)

- Company Name *

- [ ] I agree to Terms of Service

[Create Account]

```

**Sign Up Flow:**

1. User submits registration form

2. Backend creates tenant + owner user

3. Email verification sent

4. User clicks verification link

5. Account activated

6. Redirected to onboarding

**API Endpoint:**

```javascript
POST /api/v1/auth/signup

{
  "email": "user@example.com",
  "name": "John Doe",
  "password": "SecurePass123!",
  "company_name": "Acme Corp"
}

Response:
{
  "user_id": "user_abc123",
  "tenant_id": "tenant_xyz789",
  "email": "user@example.com",
  "email_verified": false,
  "verification_sent": true
}

```

---

### Login

**Secure email/password authentication:**

```text
Login Form:

- Email Address

- Password

- [x] Remember me (optional)

[Login] | [Forgot Password?]

```

**Login Flow:**

1. User enters email/password

2. NileDB validates credentials

3. JWT token generated (includes tenant_id)

4. Session established

5. Redirect to dashboard

**API Endpoint:**

```javascript
POST /api/v1/auth/login

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}

Response:
{
  "access_token": "eyJhbGciOiJIUzI1NiIs...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "user_abc123",
    "email": "user@example.com",
    "name": "John Doe",
    "tenant_id": "tenant_xyz789",
    "role": "owner"
  },
  "expires_in": 3600 // 1 hour
}

```

---

### Logout

**End user session:**

```javascript
POST /api/v1/auth/logout
Authorization: Bearer {access_token}

Response:
{
  "success": true,
  "message": "Successfully logged out"
}

// Backend:
// 1. Invalidate access token
// 2. Revoke refresh token
// 3. Clear server-side session

```

**Client-side:**

- Remove tokens from storage

- Clear user state

- Redirect to login page

---

### Email Verification

**Verify email address after signup:**

**Verification Email:**

```text
Subject: Verify your PenguinMails account

Hi John,

Welcome to PenguinMails! Please verify your email address:

[Verify Email Address]

Or copy this link:
https://app.penguinmails.com/verify-email?token=abc123

This link expires in 24 hours.

```

**Verification Flow:**

```javascript
GET /api/v1/auth/verify-email?token={verification_token}

Response:
{
  "success": true,
  "email_verified": true,
  "redirect_url": "/onboarding"
}

```

**Re-send Verification:**

```javascript
POST /api/v1/auth/resend-verification
{
  "email": "user@example.com"
}

```

---

## Level 2: Password Management

### Forgot Password

**Reset password via email link:**

**Forgot Password Form:**

```text
Forgot Password

Enter your email address and we'll send you a link to reset your password.

Email Address: _______________

[Send Reset Link]

```

**Reset Flow:**

1. User enters email

2. System sends reset link (if email exists)

3. Link expires in 1 hour

4. User clicks link

5. Enter new password

6. Password updated

7. Auto-login with new password

**API Endpoints:**

```javascript
// Step 1: Request reset
POST /api/v1/auth/forgot-password
{
  "email": "user@example.com"
}

Response:
{
  "success": true,
  "message": "If that email exists, we sent a reset link"
  // Note: Don't reveal if email exists (security)
}

// Step 2: Reset password
POST /api/v1/auth/reset-password
{
  "token": "reset_token_abc123",
  "new_password": "NewSecurePass456!"
}

Response:
{
  "success": true,
  "message": "Password reset successful",
  "access_token": "eyJhbGc..." // Auto-login
}

```

---

### Change Password

**Change password while logged in:**

```text
Change Password

Current Password: _______________
New Password: _______________
Confirm New Password: _______________

[Update Password]

```

**Password Requirements:**

- âœ… Minimum 8 characters

- âœ… At least one uppercase letter

- âœ… At least one lowercase letter

- âœ… At least one number

- âœ… At least one special character (optional but recommended)

**API Endpoint:**

```javascript
POST /api/v1/auth/change-password
Authorization: Bearer {access_token}

{
  "current_password": "OldPass123!",
  "new_password": "NewPass456!"
}

Response:
{
  "success": true,
  "message": "Password updated successfully"
}

```

---

## Level 3: Profile Management

### View Profile

**User profile information:**

```javascript
GET /api/v1/users/me
Authorization: Bearer {access_token}

Response:
{
  "user_id": "user_abc123",
  "email": "user@example.com",
  "name": "John Doe",
  "tenant_id": "tenant_xyz789",
  "role": "owner",
  "email_verified": true,
  "created_at": "2025-11-01T10:00:00Z",
  "preferences": {
    "timezone": "America/Los_Angeles",
    "date_format": "MM/DD/YYYY",
    "email_notifications": true
  }
}

```

---

### Update Profile

**Edit profile information:**

```text
Edit Profile

Full Name: John Doe
Email: user@example.com (verified âœ“)
Timezone: America/Los_Angeles
Date Format: MM/DD/YYYY

[Save Changes]

```

**API Endpoint:**

```javascript
PUT /api/v1/users/me
Authorization: Bearer {access_token}

{
  "name": "John Smith",
  "preferences": {
    "timezone": "America/New_York",
    "date_format": "YYYY-MM-DD"
  }
}

Response:
{
  "success": true,
  "user": {
    "name": "John Smith",
    "preferences": {
      "timezone": "America/New_York",
      "date_format": "YYYY-MM-DD"
    }
  }
}

```

**Changing Email:**

```javascript
// Requires email verification
POST /api/v1/users/me/change-email
{
  "new_email": "newemail@example.com",
  "password": "CurrentPass123!" // Confirm with password
}

Response:
{
  "success": true,
  "email_verification_sent": true,
  "message": "Verify your new email address"
}

```

---

### User Preferences

**Customizable user settings:**

```javascript
{
  "preferences": {
    // Regional Settings
    "timezone": "America/Los_Angeles",
    "date_format": "MM/DD/YYYY",
    "time_format": "12h", // 12h or 24h
    "language": "en",

    // Notification Settings
    "email_notifications": true,
    "campaign_alerts": true,
    "weekly_reports": true,
    "billing_alerts": true,

    // Dashboard Settings
    "default_workspace": "ws_abc123",
    "dashboard_layout": "compact",
    "show_onboarding": false
  }
}

```

---

## Team & Workspace Management

### MVP Status & Roadmap

#### Current Status: Partially Complete

**What's Available Today:**

- âœ… Team member invitation system

- âœ… Role-based access control (Owner, Admin, Member)

- âœ… View all team members with status

- âœ… Update user roles

- âœ… Remove team members from tenant

- âœ… Workspace assignment during invitation

- âœ… Multi-tenant architecture with complete data isolation

**Missing MVP Features (Q1 2026):**

- â³ Workspace management feature documentation (2-3 days)

- â³ Workspace health scoring system (3-5 days)

- â³ Organization settings & branding documentation (2-3 days)

- â³ RBAC permission matrix documentation (2-3 days)

- â³ Team member removal workflow documentation (1-2 days)

- â³ Workspace member management documentation (3-5 days)

- â³ Workspace deletion & data handling documentation (3-5 days)

**Post-MVP Enhancements (2026+):**

- ðŸ”® Advanced permissions system (custom roles) - Q2 2026

- ðŸ”® Audit logs for team actions - Q3 2026

- ðŸ”® Team analytics & activity monitoring - Q4 2026

- ðŸ”® Bulk user management - Q3 2026

- ðŸ”® User groups & teams within tenant - Q1 2027

- ðŸ”® Workspace templates - Q2 2027

- ðŸ”® Workspace duplication - Q3 2027

- ðŸ”® Advanced session management - Q4 2026

- ðŸ”® Team member onboarding workflows - Q1 2027

- ðŸ”® External user collaboration (client portal) - Q2 2027

**Detailed Roadmap:** [Team Management Roadmap](/docs/features/enterprise/team-roadmap)

---

### Team Management

#### Inviting Users

**Add team members to tenant:**

```text
Invite Team Member

Email Address: _______________
Role: [Admin â–¼]
Workspaces: [x] Client A  [ ] Client B

[Send Invitation]

```

**Invitation Flow:**

1. Admin sends invitation

2. Email sent to invitee

3. Invitee clicks link

4. Creates account or logs in

5. Automatically added to tenant

6. Assigned to selected workspaces

**API Endpoint:**

```javascript
POST /api/v1/tenants/{tenant_id}/invitations
Authorization: Bearer {access_token}

{
  "email": "newuser@example.com",
  "role": "admin", // owner, admin, member
  "workspaces": ["ws_abc123", "ws_def456"]
}

Response:
{
  "invitation_id": "inv_abc123",
  "email": "newuser@example.com",
  "status": "pending",
  "expires_at": "2025-12-01T10:00:00Z"
}

```

---

#### Managing Team Members

**View all team members:**

```javascript
GET /api/v1/tenants/{tenant_id}/users
Authorization: Bearer {access_token}

Response:
{
  "users": [
    {
      "user_id": "user_abc123",
      "name": "John Doe",
      "email": "john@example.com",
      "role": "owner",
      "status": "active",
      "last_login": "2025-11-24T10:00:00Z"
    },
    {
      "user_id": "user_def456",
      "name": "Jane Smith",
      "email": "jane@example.com",
      "role": "admin",
      "status": "active",
      "last_login": "2025-11-23T15:30:00Z"
    }
  ],
  "total": 2
}

```

**Update User Role:**

```javascript
PUT /api/v1/tenants/{tenant_id}/users/{user_id}
{
  "role": "member" // Downgrade from admin
}

```

**Remove User:**

```javascript
DELETE /api/v1/tenants/{tenant_id}/users/{user_id}

// User removed from tenant
// Loses access to all workspaces
// Data ownership transferred to tenant owner

```

---

### Workspace Management

**Multi-workspace support for agencies:**

- Create multiple client workspaces within tenant

- Workspace-level access control (Admin, Member, Viewer)

- Assign team members to specific workspaces

- Workspace health monitoring (0-100 score)

- Isolated campaigns, leads, and settings per workspace

**Workspace Routes:**

- `/dashboard/workspaces` - List all workspaces with health scores

- `/dashboard/workspaces/new` - Create new workspace

- `/dashboard/workspaces/[slug]/settings` - Workspace settings

**See Also:** [Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture) for technical details

---

## Session Management

### JWT Tokens

**Authentication uses JWT (JSON Web Tokens):**

```javascript
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "user_id": "user_abc123",
    "tenant_id": "tenant_xyz789",
    "email": "user@example.com",
    "role": "admin",
    "iat": 1700830200, // Issued at
    "exp": 1700833800  // Expires (1 hour)
  },
  "signature": "..."
}

```

**Token Types:**

- **Access Token** - Short-lived (1 hour), used for API requests

- **Refresh Token** - Long-lived (30 days), used to get new access tokens

**Token Refresh:**

```javascript
POST /api/v1/auth/refresh
{
  "refresh_token": "eyJhbGciOiJI..."
}

Response:
{
  "access_token": "eyJhbGciOiJI...", // New access token
  "expires_in": 3600
}

```

---

### Session Security

**Security Features:**

1. **Automatic Logout** - 30 minutes of inactivity

2. **Token Expiration** - Access tokens expire in 1 hour

3. **Refresh Rotation** - New refresh token on each refresh

4. **Revocation** - Tokens can be revoked server-side

5. **IP Tracking** - Log IP addresses for security monitoring

**Session Endpoints:**

```javascript
// Get active sessions
GET /api/v1/auth/sessions

Response:
{
  "sessions": [
    {
      "session_id": "sess_abc123",
      "device": "Chrome on macOS",
      "ip_address": "192.168.1.1",
      "last_active": "2025-11-24T10:30:00Z",
      "current": true
    }
  ]
}

// Revoke session
DELETE /api/v1/auth/sessions/{session_id}

```

---

## Account Deletion

**Delete user account:**

```text
âš ï¸ Delete Account

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

- **[Authentication Roadmap](/docs/features/enterprise/authentication-roadmap)** - Detailed authentication timeline and quarterly breakdown

- **[Team Management Roadmap](/docs/features/enterprise/team-roadmap)** - Detailed team & workspace management timeline

- **[Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture)** - Tenant isolation and workspace architecture

- **[Security Framework](/docs/compliance-security/enterprise/security-framework)** - Security overview

- **[Vault Integration](/docs/features/integrations/overview#vault-integration)** - Secure secrets management for API keys and credentials

### Implementation

- **[NileDB Authentication](/docs/implementation-technical/database-infrastructure/niledb)** - Auth implementation

- **[API Authentication](/docs/implementation-technical/api/platform-api/authentication)** - API auth details

- **[Public & Authentication Routes](/docs/design/routes/public-auth)** - Login, signup, password reset UI

- **[Settings Routes](/docs/design/routes/settings)** - Profile, team management, security settings UI

### Tasks

- **[Epic 2: User Authentication](/docs/tasks/epic-2-user-authentication-profile/)** - Implementation tasks

### Roadmap

- **[Product Roadmap](/docs/roadmap/product-roadmap#authentication--security)** - Authentication features timeline

- **[Executive Roadmap](/docs/business/roadmap/executive-roadmap)** - Strategic authentication priorities

---

**Last Updated:** November 26, 2025
**Authentication Provider:** NileDB SDK
**Current Method:** Email + Password
**MVP Status:** In Progress (8 of 11 MVP features remaining)
**Next Milestone:** Q1 2026 - Complete MVP authentication features

*Secure user authentication is the foundation of platform security. NileDB provides enterprise-grade authentication with tenant isolation built-in. For MVP and near-term releases, we continue using NileDB's email/password authentication. OAuth 2.0 and SSO (SAML, OpenID Connect) are planned for Q2-Q3 2026 to meet enterprise customer requirements.*
