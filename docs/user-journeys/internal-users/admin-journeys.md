---
title: "Internal Users: Admin Journeys"
description: "Key user journeys for Platform Administrators managing the PenguinMails platform"
last_modified_date: "2025-12-07"
level: "2"
persona: "Platform Administrators"
---

# Internal Users: Admin Journeys

## Overview

This document outlines the key user journeys for Platform Administrators who manage the PenguinMails platform. These journeys focus on system administration, user management, security, and platform configuration.

**Purpose**: Provide clear workflows for administrative users to efficiently manage platform operations.

---

## User Profile: Platform Administrators

### **Primary Characteristics**

- Full system access and configuration management
- Responsible for user management and tenant administration
- Implement security policies and compliance measures
- Manage system configuration and environment settings
- Technical expertise in platform administration

### **Common Tools & Systems**

- Platform admin dashboard
- User management interface
- Security and compliance tools
- Analytics and monitoring systems
- Configuration management tools

---

## Core Admin Journeys

### **Journey 1: User Management & Access Control**

> **Feature Reference**: [Global User Management](/docs/features/admin/user-management/overview.md) | **Route**: [`/dashboard/users`](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management)

#### **Initial Setup**

1. **Access Admin Dashboard**
   - Log into administrative interface (authenticated via [`staff_members` table](/docs/features/admin/user-management/overview.md#access-control))
   - Navigate to [user management section](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management)
   - Review current user base and access levels

2. **Create New User Accounts** ([Administrative Actions](/docs/features/admin/user-management/overview.md#administrative-actions))
   - Set up internal team member accounts
   - Configure [role-based access permissions](/docs/features/admin/user-management/overview.md#access-control)
   - Set up multi-factor authentication ([Planned](/docs/features/authentication/mfa-roadmap.md))

3. **Onboard External Users** ([Tenant Management](/docs/design/routes/platform-admin.md#dashboard-tenants---tenant-organization-management))
   - Process customer account approvals
   - Configure customer-specific settings
   - Set up [billing and subscription](/docs/features/admin/finance/overview.md) information
   - Establish communication preferences

#### **Daily Operations**

1. **Monitor User Activity** ([Audit Trail Viewer](/docs/features/admin/user-management/overview.md#audit-trail-viewer))
   - Review login activity via [PostHog](https://posthog.com/) analytics
   - Identify unusual access patterns
   - Monitor failed login attempts ([Audit Trail](/docs/features/admin/user-management/overview.md#audit-trail-viewer))
   - Check engagement metrics via PostHog (see [Metrics Glossary](/docs/features/admin/system-monitoring/metrics-glossary#external-analytics-posthog))

2. **Manage Permissions** ([Change Role](/docs/features/admin/user-management/overview.md#change-user-role))
   - Adjust access levels based on role changes
   - Handle [permission escalation requests](/docs/design/routes/platform-admin.md#row-actions)
   - Review and audit access rights
   - Process [user deactivation](/docs/design/routes/platform-admin.md#row-actions) requests

#### **Advanced Management**

1. **Bulk User Operations** *(Planned - Q3 2026)*
   - Mass user updates and migrations
   - Department restructuring and reassignments
   - Access policy updates across user groups
   - Data export and reporting
   - See [User Management Future Enhancements](/docs/features/admin/user-management/overview.md#future-enhancements)

2. **Compliance & Audit** ([Audit Trail](/docs/features/admin/user-management/overview.md#audit-trail-viewer))
   - Generate access reports for compliance
   - Review [user activity logs](/docs/design/routes/platform-admin.md#audit-trail-viewer)
   - Conduct permission audits
   - Document security incidents

---

### **Journey 2: System Configuration & Environment Management**

> **Feature Reference**: [Tenant Management](/docs/features/admin/tenant-management) | **Route**: [`/dashboard/tenants`](/docs/design/routes/platform-admin.md#dashboard-tenants---tenant-organization-management)

#### **Environment Setup**

1. **Initial Platform Configuration**
   - Configure basic platform settings
   - Set up email domains and routing
   - Establish deliverability settings
   - Configure [monitoring and alerting](/docs/features/admin/system-monitoring/overview.md)

2. **Feature Flag Management** ([Tenant Management](/docs/design/routes/platform-admin.md#dashboard-tenants---tenant-organization-management))
   - Enable/disable platform features
   - Manage beta feature rollouts via [Tenant Management](/docs/features/admin/tenant-management/overview.md#feature-flags)
   - Control feature access by user segments (percentage rollouts, allowlists)

   > **Note:** A/B testing and advanced experimentation uses [PostHog](https://posthog.com/).

#### **Ongoing Configuration**

1. **Performance Monitoring** ([System Monitoring](/docs/features/admin/system-monitoring/overview.md))
   - Monitor system performance via Prometheus/Grafana (planned for 2026 Spike; see [Metrics Glossary](/docs/features/admin/system-monitoring/metrics-glossary#infrastructure-metrics-external))
   - View queue health and job processing rates
   - Check service availability and error rates

   > **Note:** Resource allocation, database optimization, and caching are DevOps operations and are Post-MVP for the Admin UI. See [Operations Runbooks](/docs/operations/incident-management/runbooks) for infrastructure tasks.

2. **Integration Management** *(Roadmap - 2027)*
   - Third-party integration management planned post-internal API stabilization
   - Current: API keys managed via [Vault Management](/docs/features/admin/vault-management/overview.md)
   - See [Enterprise Roadmap](/docs/features/admin/enterprise-roadmap.md) for planned integration features

---

### **Journey 3: Security & Compliance Management**

> **Feature Reference**: [Vault Management](/docs/features/admin/vault-management) | **Route**: [`/admin/secrets`](/docs/design/routes/platform-admin.md#admin-secrets---vault-secrets-management)

#### **Security Setup**

1. **Access Control Implementation** ([User Management Access Control](/docs/features/admin/user-management/overview.md#access-control))
   - Configure [role-based access control (RBAC)](/docs/features/admin/user-management/overview.md#access-control)
   - Set up multi-factor authentication ([Planned](/docs/features/authentication/mfa-roadmap.md))
   - Establish password policies
   - Configure session management

2. **Data Protection** ([Vault Secrets](/docs/design/routes/platform-admin.md#admin-secrets---vault-secrets-management))
   - Configure data encryption settings
   - Establish data retention policies
   - Set up [backup and recovery](/docs/design/routes/platform-admin.md#vault-health-dashboard) procedures
   - Manage data classification

#### **Ongoing Security Operations**

1. **Threat Monitoring** ([Audit Log Viewer](/docs/design/routes/platform-admin.md#audit-log-viewer))
   - Review security alerts and notifications
   - Investigate [suspicious activities](/docs/features/admin/user-management/overview.md#audit-trail-viewer)
   - Monitor [failed authentication attempts](/docs/design/routes/platform-admin.md#suspicious-activity-alerts)
   - Track unusual system access patterns

2. **Compliance Management**
   - Generate compliance reports
   - Conduct security assessments
   - Review and update security policies
   - Manage security incident responses

---

### **Journey 4: Platform Monitoring & Analytics**

> **Feature Reference**: [System Monitoring](/docs/features/admin/system-monitoring/overview.md) | **Routes**: [`/dashboard/system/infrastructure`](/docs/design/routes/platform-admin.md#dashboard-system-infrastructure---system-health-monitoring), [`/dashboard/system/logs`](/docs/design/routes/platform-admin.md#dashboard-system-logs---system-log-viewer)

#### **Daily Monitoring**

1. **System Health Dashboard** ([System Monitoring](/docs/features/admin/system-monitoring/overview.md))
   - Review overall system status
   - Check critical service health
   - Monitor resource utilization
   - Review error rates and performance

2. **User Activity Analytics** *(PostHog + OLAP)*
   - Engagement metrics and feature adoption tracked via [PostHog](https://posthog.com/)
   - Admin audit logs available in [OLAP admin_audit_log](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide.md#admin-activity)
   - Customer satisfaction and support ticket trends via external tools (Zendesk, Intercom)
   - See [Enterprise Roadmap](/docs/features/admin/enterprise-roadmap.md) for enhanced analytics (Q1 2027)

#### **Reporting & Insights**

1. **Administrative Reporting**
   - Generate user growth reports
   - Create system performance summaries
   - Develop compliance documentation
   - Prepare executive dashboards

2. **Problem Resolution**
   - Investigate system issues
   - Troubleshoot user problems
   - Coordinate with technical teams
   - Document resolutions and solutions

---

### **Journey 5: Staff & Role Management**

> **Feature Reference**: [User Management](/docs/features/admin/user-management/overview.md) | **Route**: [`/dashboard/users`](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management)

#### **Staff Offboarding**

1. **Role Removal** ([Change Role](/docs/features/admin/user-management/overview.md#change-user-role))
    - **User Story**: "I want to remove a penguinmails employee so I remove the roles."
    - **Action**: Navigate to [Staff Management](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management) > Select Employee > Edit Roles > Remove all assigned roles.
    - **System Effect**: Immediate invalidation of staff session tokens; user loses access to all admin routes.
    - **Verification**: Attempt to access admin dashboard with the user's credentials (should fail).

2. **Emergency Access Revocation** ([Revoke All Sessions](/docs/design/routes/platform-admin.md#row-actions))
    - **User Story**: "A staff member's device was compromised, and I need to revoke access immediately."
    - **Action**: Navigate to [Staff Management](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management) > Select Employee > Click "[Revoke All Sessions](/docs/design/routes/platform-admin.md#row-actions)" > Click "[Suspend Account](/docs/design/routes/platform-admin.md#row-actions)".
    - **System Effect**: All active sessions are terminated; account status set to 'Suspended'.
    - **Follow-up**: Trigger [security audit log review](/docs/design/routes/platform-admin.md#audit-trail-viewer) for the compromised user's recent activity.

3. **Role Promotion/Demotion** ([Change Role](/docs/features/admin/user-management/overview.md#change-user-role))
    - **User Story**: "A support agent has been promoted to a team lead and needs advanced user management permissions."
    - **Action**: Navigate to [Staff Management](/docs/design/routes/platform-admin.md#dashboard-users---global-user-management) > Select Employee > [Edit Roles](/docs/features/admin/user-management/overview.md#change-user-role) > Add 'User Manager' role.
    - **System Effect**: User gains access to 'Ban User' and 'Bulk Edit' capabilities upon next login.

---

### **Journey 6: Financial Operations (Stripe-First)**

> **Feature Reference**: [Finance Overview](/docs/features/admin/finance/overview.md) | **Route**: [`/dashboard/finance`](/docs/design/routes/platform-admin.md#dashboard-finance---subscription-overview)

#### **Payment Dispute & Stop Requests**

1. **Dispute Verification** ([Tenant Billing](/docs/design/routes/platform-admin.md#dashboard-tenants---tenant-organization-management))
    - **User Story**: "I want to stop the payments for a specific tenant due to a legal dispute."
    - **Action**: Navigate to [Tenant Details](/docs/design/routes/platform-admin.md#row-actions) > Billing > Review current subscription status.
    - **Process**: Create a "Billing Dispute" ticket in Jira/Support System assigned to the Finance Team.
    - **Finance Action**: Finance team pauses subscription directly in [Stripe Dashboard](/docs/features/admin/finance/stripe-dashboard-access.md).
    - **System Effect**: [Stripe webhook](/docs/features/admin/finance/stripe-webhook-status.md) updates tenant status to 'Paused' in PenguinMails.

2. **Payment Reconciliation** ([Subscription Monitoring](/docs/features/admin/finance/subscription-monitoring.md))
    - **User Story**: "I had a payment in tenant side he shows the stripe invoice but we dont show on our side so I want to confirm."
    - **Action**: Navigate to [Finance Dashboard](/docs/design/routes/platform-admin.md#dashboard-finance---subscription-overview) > Transaction Search > Enter Tenant ID.
    - **Verification**: Click "[View in Stripe](/docs/features/admin/finance/stripe-dashboard-access.md)" to compare local status with Stripe data.
    - **Resolution**: If discrepancy found, escalate to Engineering via "Sync Issue" ticket (or use "Force Sync" if available).

3. **Refund Request Processing**
    - **User Story**: "A customer was double-charged due to a glitch, and I need to request a refund."
    - **Action**: Navigate to [Tenant Details](/docs/design/routes/platform-admin.md#row-actions) > Billing > Invoices > Verify duplicate charge.
    - **Process**: Create "Refund Request" ticket including Invoice ID and reason ("Duplicate Charge").
    - **Finance Action**: Finance team issues refund in [Stripe Dashboard](/docs/features/admin/finance/stripe-dashboard-access.md).
    - **Completion**: Support agent notifies customer once refund is confirmed in Stripe.

---

## User Type Context

### **Key Pain Points**

- Complex user permission management across large user base
- Balancing security with usability for different user types
- Managing platform configuration changes without service disruption
- Keeping up with compliance requirements and security threats
- Coordinating with multiple internal teams for system updates

### **Success Metrics**

> See [Metrics Glossary](/docs/features/admin/system-monitoring/metrics-glossary) for detailed definitions of success metrics.

- **User Satisfaction**: Admin users rate experience positively
- **Security Compliance**: 100% compliance with security policies
- **System Uptime**: Maintain high availability for admin functions
- **Response Time**: Quick resolution of user access issues
- **Efficiency**: Reduced time for common administrative tasks

---

## Integration Points

### **With Other Internal Teams**

- **Technical Teams**: Coordinate on system updates and feature deployments
- **Customer Success**: Handle escalations and customer account management
- **Marketing**: Manage marketing user accounts and campaign access
- **Finance**: Coordinate billing and subscription management

### **With External Systems**

- **Google Workspace**: User authentication and directory integration
- **Jira**: Issue tracking and project management coordination
- **CRM Systems**: Customer account synchronization
- **Analytics Platforms**: User behavior tracking and reporting

---

## Common Admin Workflows

### **Weekly Administrative Tasks**

1. **User Account Review**
   - Review new user requests
   - Process account modifications
   - Conduct access audits
   - Update permissions as needed

2. **System Health Check**
   - Review performance dashboards
   - Check error rates and alerts
   - Monitor resource utilization
   - Update configuration settings

### **Monthly Administrative Tasks**

1. **Security Review**
   - Conduct security assessments
   - Review access logs and permissions
   - Update security policies
   - Generate compliance reports

2. **Platform Analytics**
   - Analyze user growth trends
   - Review feature adoption metrics
   - Generate usage reports
   - Plan system improvements

### **Quarterly Administrative Tasks**

1. **System Optimization**
   - Review and optimize platform performance
   - Update configuration baselines
   - Plan system upgrades and improvements
   - Coordinate with technical teams on roadmap

2. **Compliance & Audit**
   - Conduct comprehensive security audits
   - Review and update compliance documentation
   - Generate executive reporting
   - Plan compliance improvements

---

### Related Documents

**User Journeys**:

- [Operations Journeys](operations-journeys.md)
- [Technical Teams Journeys](technical-teams-journeys.md)
- [Internal Tools Integration](internal-tools-integration.md)

**Feature Documentation**:

- [Global User Management](/docs/features/admin/user-management/overview.md) - User lookup, audit trails, account actions
- [Finance Overview](/docs/features/admin/finance/overview.md) - Subscription monitoring, Stripe access
- [System Monitoring](/docs/features/admin/system-monitoring/overview.md) - Infrastructure health, queues, logs
- [Plan Management](/docs/features/admin/plan-management/overview.md) - Subscription plans and pricing
- [Vault Management](/docs/features/admin/vault-management) - Secrets and SSH key management

**Route Specifications**:

- [Platform Admin Routes](/docs/design/routes/platform-admin.md) - Complete UI specification for admin dashboard

---

**Keywords**: admin journeys, platform administration, user management, security, compliance, system configuration
