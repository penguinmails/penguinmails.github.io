---
title: "Team Management & Admin Analytics"
description: "Core team management operations, member dashboards, and administrative organization analytics."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Team Management & Admin Analytics

#### 3. **Ongoing Team Management**

**Journey Flow:** `Team Dashboard → Member Actions → Permission Updates → Activity Monitoring`

##### Team Dashboard Access (`)

- **Member List**: Table showing all team members with status
- **Columns**: Name, Email, Role, Join Date, Last Active, Status
- **Actions**: Edit role, remove member, resend invitation (per member)
- **Bulk Actions**: Select multiple members for batch operations
- **Company Context**: All actions scoped to current company workspace

##### Role Management Interface

- **Role Change Modal**:
  - Current role display
  - New role dropdown (Member → Admin → Owner hierarchy)
  - Permission preview (what changes with role)
  - Confirmation with impact warning
  - Tenant-level role validation (roles managed at tenant level)
- **Security Logging**: All role changes audited with tenant association

##### Team Activity Monitoring

- **Activity Feed**: Recent team actions and changes within company
- **Usage Analytics**: Per-member campaign activity scoped to company
- **Access Logs**: Login patterns and feature usage by company
- **Alerts**: Inactive members, permission changes, company-specific alerts

---

## Organization Analytics Framework

### **Team Performance Metrics**

#### **Team Engagement Analytics**

```typescript
interface TeamEngagement {
  companyId: string;
  teamMetrics: {
    totalMembers: number;
    activeMembers: number;
    invitedMembers: number;
    pendingInvites: number;
  };
  roleDistribution: {
    owners: number;
    admins: number;
    members: number;
  };
  activity: {
    dailyActiveUsers: number;
    weeklyActiveUsers: number;
    averageSessionTime: number;
    featureAdoptionByRole: Record<string, number>;
  };
  collaboration: {
    sharedCampaigns: number;
    teamActions: number;
    crossMemberInteractions: number;
    mentorshipPairs: number;
  };
}


```

#### **Organization Health KPIs**

- **Team Utilization Rate**: Active members / total invited
- **Invitation Acceptance Rate**: Accepted / total sent
- **Role Distribution Balance**: Admin-to-member ratios
- **Team Productivity Score**: Campaign creation and performance by team
- **Access Control Effectiveness**: Permission-related security metrics
- **Onboarding Completion Rate**: Team members completing setup
- **Multi-tenant Performance**: Cross-company data isolation metrics

### **Role-Based Access Control Analytics**

- Staff roles follow a clearly defined, least-privilege hierarchy (super_admin, admin, support, QA) mapped to explicit permission sets.
- All staff operations that touch tenant data, billing, security configurations, or incident handling must be fully auditable.

#### **Permission Analytics**

```typescript
interface AccessControlAnalytics {
  companyId: string;
  permissions: {
    totalPermissions: number;
    usedPermissions: number;
    unusedPermissions: number;
    permissionEfficiency: number;
  };
  roleAnalytics: {
    [roleType: string]: {
      count: number;
      averageTenure: number;
      activityScore: number;
      securityScore: number;
    };
  };
  securityMetrics: {
    unauthorizedAttempts: number;
    permissionEscalations: number;
    failedAccessAttemps: number;
    roleChangeFrequency: number;
  };
}


```

### **Multi-Tenant Organization Analytics**

#### **Tenant Performance Metrics**

```typescript
interface TenantAnalytics {
  tenantId: string;
  organizationMetrics: {
    totalCompanies: number;
    activeCompanies: number;
    averageCompanySize: number;
    companyGrowthRate: number;
  };
  crossCompanyActivity: {
    userMultiCompanyAccess: number;
    companySwitchFrequency: number;
    crossCompanyCollaborations: number;
    dataIsolationViolations: number;
  };
  performance: {
    responseTime: number;
    throughput: number;
    errorRate: number;
    availability: number;
  };
}


```
