---
title: "Global User Management"
description: "Platform-wide user lookup, audit trails, and administrative actions for PenguinMails internal staff"
last_modified_date: "2025-12-04"
level: "2"
persona: "Platform Administrators, Support Staff"
status: "ACTIVE"
category: "Admin"
---

# Global User Management

**Platform-wide user lookup, audit trails, and account management for support and administrative operations.**

---

## Overview

The Global User Management feature provides PenguinMails internal staff with comprehensive tools to search, view, and manage user accounts across all tenants. It serves as the primary interface for support ticket resolution, account troubleshooting, and compliance operations.

### Key Capabilities

- **Global User Search**: Search across all users by email, name, or user ID
- **Comprehensive Audit Trails**: View complete user activity history for debugging and compliance
- **Account Actions**: Suspend, delete, change role, or reset passwords for user accounts
- **GDPR Compliance**: Support for data subject access requests and account deletion

---

## User Stories

### Support Admin

> *"As a support admin, I need to quickly look up a user by email to review their audit trail and debug a login issue they reported 2 hours ago."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/users`
> 2. Search for user by email in global search bar
> 3. Click "View Audit Trail" to see recent activity
> 4. Identify failed login attempts and root cause
> 5. Take corrective action (e.g., reset password)

### Compliance Officer

> *"As a compliance officer, I need to fulfill a GDPR data deletion request for a user who no longer uses our platform."*
>
> **Workflow**:
>
> 1. Search for user by email
> 2. Verify user identity and deletion request
> 3. Click "Delete Account" action
> 4. Confirm irreversible hard delete
> 5. Document deletion in compliance log

---

## Feature Components

### Global User Search

- **Search Bar**: Real-time autocomplete across all users
- **Filters**:
  - Role (Owner, Admin, Member)
  - Status (Active, Suspended, Deleted)
  - Plan (Free, Pro, Enterprise)
  - Tenant

### User Table

- **Columns**: User ID, Name, Email, Plan, Tenant, Status, Created Date, Last Login
- **Color Coding**:
  - Red: Suspended users
  - Orange: Churned users (expired plan)
- **Sorting & Pagination**: Support for large datasets

### Audit Trail Viewer

- **Activity Timeline**: Chronological view of all user actions
  - Login events
  - Campaign operations
  - Settings changes
  - API calls
- **Filters**: Date range, action type, IP address
- **Search**: Full-text search across audit entries
- **Export**: Download as CSV for compliance reporting

### Administrative Actions

- **View Details**: Full user profile with activity summary
- **View Audit Trail**: Opens comprehensive audit viewer
- **Change Role**: Promote or demote users (e.g., Member to Admin)
- **Reset Password**: Sends password reset email
- **Suspend Account**: Temporarily disable account access
- **Delete Account**: GDPR-compliant hard delete (irreversible)

### Change User Role

**User Story**: *"As a support admin, I need to promote a user to 'Admin' so they can help manage their organization's billing."*

**Workflow**:

1. Navigate to User Details page
2. Click **"Change Role"** in the actions menu
3. Select new role from dropdown (Owner, Admin, Member)
4. Confirm action
5. **System Action**: Updates `tenant_users` table and invalidates user session to enforce new permissions immediately

---

## Integration Architecture

### Database Integration

- **Users Table**: Primary source for user data (OLTP)
- **Staff Members Table**: Separate table for internal platform admin users (security guard)
- **Audit Log Table**: Stores all user actions with retention policy
- **Search Index**: Elasticsearch for fast full-text search

### Access Control

- **super_admin**: Full access to all users and actions
- **admin**: View-only access to user data
- **support**: Read-only access, no PII (personally identifiable information)
- **qa**: Sandbox-only access

> [!SECURITY]
> **Staff Guard Architecture**:
> Admin access is strictly authenticated against the `staff_members` table (see [Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide#staff-members---staff-user-mapping)).
>
> - **Middleware Check**: Every request to `/admin/*` or `/dashboard/admin/*` verifies the user exists in `staff_members` and has `is_active=true`.
> - **Role Enforcement**: Staff roles (Super Admin, Support, etc.) are distinct from tenant roles and are enforced at the API gateway level.
> - **Separation of Concerns**: Regular tenant users, even with "Owner" permissions, have NO access to these internal admin views.

### Audit Logging

All admin actions are logged:

- User lookups
- Audit trail views
- Account modifications
- Data exports

---

## Technical Considerations

### Performance

- **Search**: Elasticsearch indexes ~10M users with <100ms response time
- **Audit Trail**: Paginated with lazy loading for large activity histories
- **Caching**: User metadata cached for 5 minutes to reduce database load

### Security

- **Re-authentication**: Sensitive actions require password confirmation
- **Rate Limiting**: Search API limited to 100 requests/minute per admin
- **Audit Trail**: All admin views logged with timestamp, user, IP address

### Compliance

- **GDPR**: Hard delete removes all user data across all systems
- **Data Retention**: Audit logs retained for 7 years for compliance
- **Access Logging**: All user data access logged for SOC 2 compliance

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes - User Management](/docs/design/routes/platform-admin#dashboard-users) - UI specification

### API Documentation

- [Platform Admin API](/docs/implementation-technical/api/platform-api/admin) - User management endpoints
- [Audit Trail API](/docs/implementation-technical/api/platform-api/admin#user-audit-trail) - Audit log retrieval

### Database Schema

- [OLTP Database Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) - Users and audit tables

### Compliance

- [GDPR Compliance](/docs/features/compliance/gdpr-compliance) - Data subject rights and deletion procedures
- [Support Role Guide](/docs/operations/support/role-guide) - Support staff access policies

---

## Future Enhancements

### Q2 2026

- **Advanced Filtering**: Filter by last login date, signup source, feature usage
- **Bulk Actions**: Suspend or export multiple users at once
- **Enhanced Analytics**: User behavior patterns and engagement metrics

### Q3 2026

- **Automated Risk Detection**: Flag suspicious user activity patterns
- **Compliance Automation**: Automated GDPR request processing
- **Support Ticket Integration**: Direct link from audit trail to support tickets

### Team Collaboration Roadmap

- **Advanced RBAC**: Granular permission sets beyond standard roles (currently handled by NileDB auth).
- **Team Workspaces**: Isolated environments for different departments or teams.
- **Approval Workflows**: Multi-step approval chains for sensitive actions (e.g., campaign sending).
- **Shared Assets**: Collaborative template and list management within workspaces.
