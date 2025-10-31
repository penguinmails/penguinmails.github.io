
# Staff Operations & Support Implementation Guide

**Last Updated:** October 30, 2025  
**Version:** 1.0  
**Status:** Implementation Guide

## Overview

This guide provides comprehensive implementation details for PenguinMails' staff operations and support system, covering both current production features and planned roadmap enhancements.

### System Architecture Summary

```
┌─────────────────────────────────────────────────────────────┐
│                    STAFF OPERATIONS SYSTEM                  │
├─────────────────────────────────────────────────────────────┤
│  🟢 PRODUCTION READY          🔄 IN PROGRESS      📅 PLANNED │
├─────────────────────────────────────────────────────────────┤
│  • 4-Tier Staff Hierarchy    • Help Center Links   • Q4 2026 │
│  • Role-Based Access Control • Email Support       • 2027    │
│  • User Management           • Floating Button     • Full    │
│  • Staff Member Management                    • Ticket     │
│                                               • System     │
└─────────────────────────────────────────────────────────────┘
```

---

## 🟢 Current Implementation - Production Ready

### 1. Staff Management System

#### Database Implementation

**Core Tables (Already Implemented):**

```sql
-- Staff roles with 4-tier hierarchy
CREATE TABLE staff_roles (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) UNIQUE,           -- super_admin, admin, support, qa
    description TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Staff members table
CREATE TABLE staff_members (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    role_id INTEGER REFERENCES staff_roles(id),
    notes TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Permissions system
CREATE TABLE permissions (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    description TEXT,
    category VARCHAR(50) DEFAULT 'general',
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE TABLE staff_role_permissions (
    id INTEGER PRIMARY KEY,
    role_id INTEGER REFERENCES staff_roles(id),
    permission_id INTEGER REFERENCES permissions(id),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### Staff Hierarchy Implementation

**4-Tier Staff System:**

1. **super_admin**
   - Full system administration and tenant management
   - Can access all data across all tenants
   - User management and system configuration
   - Staff role assignment and permission management

2. **admin**
   - High-level operational oversight
   - Billing and subscription management
   - Tenant-level administration
   - Cannot modify staff roles or system-wide settings

3. **support**
   - Customer support and tenant assistance
   - Read access to customer data for troubleshooting
   - Cannot make billing changes or system modifications
   - Access to help center and support tools

4. **qa**
   - Quality assurance and testing operations
   - Read-only access to test environments
   - Campaign testing and validation
   - No customer data access in production

#### Role Assignment Process

```typescript
// Add staff member to system
async function addStaffMember(userId: string, roleName: string, notes?: string) {
  const role = await db.staff_roles.findUnique({
    where: { name: roleName }
  });
  
  if (!role) {
    throw new Error(`Role '${roleName}' not found`);
  }
  
  return await db.staff_members.create({
    data: {
      user_id: userId,
      role_id: role.id,
      notes: notes || null
    }
  });
}

// Check staff permissions
async function checkStaffPermission(userId: string, permissionName: string) {
  const staffMember = await db.staff_members.findUnique({
    where: { user_id: userId },
    include: {
      staff_roles: {
        include: {
          staff_role_permissions: {
            include: {
              permissions: true
            }
          }
        }
      }
    }
  });
  
  return staffMember?.staff_roles?.staff_role_permissions?.some(
    permission => permission.permissions.name === permissionName
  ) || false;
}
```

### 2. Help System Integration

#### Dashboard Help Integration

**File Location:** `components/layout/components/DashboardHeader.tsx`

**Current Implementation:**
```tsx
const helpLinks = [
  {
    name: 'Knowledge Base',
    url: 'https://help.penguinmails.com/knowledge-base',
    icon: 'BookOpenIcon'
  },
  {
    name: 'Support',
    url: 'https://help.penguinmails.com/support',
    icon: 'SupportIcon'
  },
  {
    name: 'Video Tutorials',
    url: 'https://help.penguinmails.com/video-tutorials',
    icon: 'PlayIcon'
  },
  {
    name: 'Glossary',
    url: 'https://help.penguinmails.com/glossary',
    icon: 'GlossaryIcon'
  },
  {
    name: 'Our Services',
    url: 'https://help.penguinmails.com/our-services',
    icon: 'ServiceIcon'
  }
];

// Help dropdown in user menu
<DropdownMenu>
  <DropdownMenuTrigger asChild>
    <Button variant="ghost" size="sm">
      <HelpCircleIcon className="h-4 w-4" />
    </Button>
  </DropdownMenuTrigger>
  <DropdownMenuContent>
    {helpLinks.map((link) => (
      <DropdownMenuItem key={link.name} asChild>
        <a href={link.url} target="_blank" rel="noopener noreferrer">
          <link.icon className="mr-2 h-4 w-4" />
          {link.name}
        </a>
      </DropdownMenuItem>
    ))}
  </DropdownMenuContent>
</DropdownMenu>
```

#### Landing Page Support Button

**Implementation:**
```tsx
// Floating support button on landing page
const SupportButton = () => {
  const handleSupportClick = () => {
    const subject = encodeURIComponent('PenguinMails Support Request');
    const body = encodeURIComponent(`
      Hi PenguinMails Support Team,
      
      I need assistance with:
      
      [Please describe your issue here]
      
      ---
      Browser: ${navigator.userAgent}
      URL: ${window.location.href}
      Timestamp: ${new Date().toISOString()}
    `);
    
    window.location.href = `mailto:support@penguinmails.com?subject=${subject}&body=${body}`;
  };

  return (
    <div className="fixed bottom-6 right-6 z-50">
      <Button
        onClick={handleSupportClick}
        className="h-14 w-14 rounded-full shadow-lg hover:shadow-xl transition-shadow"
        size="lg"
      >
        <SupportIcon className="h-6 w-6" />
        <span className="sr-only">Contact Support</span>
      </Button>
    </div>
  );
};
```

### 3. Email-Based Support Workflow

#### Current Support Process

**Email Routing:** support@penguinmails.com

**Process Flow:**
1. **Customer Contact** via landing page button or help center
2. **Manual Triage** by support team
3. **Email Assignment** based on category/expertise
4. **Response & Resolution** via email
5. **Follow-up** as needed

#### Email Template System

```typescript
// Support email templates
const supportTemplates = {
  welcome: {
    subject: 'Welcome to PenguinMails Support',
    template: `
      Hi {{customerName}},
      
      Thank you for contacting PenguinMails support. We've received your inquiry and will respond within 24 hours.
      
      Your ticket reference: {{ticketNumber}}
      
      Best regards,
      The PenguinMails Support Team
    `
  },
  
  technical: {
    subject: 'Technical Support - {{ticketNumber}}',
    template: `
      Hi {{customerName}},
      
      Thank you for your patience. Regarding your technical issue:
      
      {{issueDescription}}
      
      {{resolutionSteps}}
      
      If you have any questions, please reply to this email.
      
      Best regards,
      {{agentName}}
      PenguinMails Technical Support
    `
  },
  
  billing: {
    subject: 'Billing Support - {{ticketNumber}}',
    template: `
      Hi {{customerName}},
      
      Thank you for contacting us about billing.
      
      {{billingResponse}}
      
      Best regards,
      {{agentName}}
      PenguinMails Billing Support
    `
  }
};
```

---

## 🔄 In Progress - Help System Enhancement

### Current Help Center Integration

**Help Center URL:** https://help.penguinmails.com/

**Integration Points:**
1. **Dashboard Header Dropdown** - Links to help center sections
2. **Contextual Help** - "What's this?" tooltips for complex features
3. **Onboarding Tour** - Interactive guide for new users

### Implementation Status

✅ **Completed:**
- Help center URL integration
- Dashboard dropdown menu
- Floating support button

🔄 **In Progress:**
- Contextual help tooltips
- Search functionality within help center
- Video tutorial integration

---

## 📅 Planned Implementation - Q4 2026

### 1. Enhanced Staff Audit Logging

#### Database Implementation

```sql
-- Staff access tracking
CREATE TABLE staff_access_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_user_id UUID REFERENCES staff_members(user_id),
    action_type VARCHAR(100) NOT NULL,           -- 'login', 'data_access', 'tenant_view', 'bulk_operation'
    resource_type VARCHAR(50) NOT NULL,          -- 'tenant', 'campaign', 'user', 'billing'
    resource_id UUID,                            -- ID of accessed resource
    tenant_id UUID REFERENCES tenants(id),       -- Tenant context
    ip_address INET,                             -- Staff member IP
    user_agent TEXT,                             -- Browser/device info
    success BOOLEAN DEFAULT TRUE,                -- Whether action succeeded
    details JSONB DEFAULT '{}',                  -- Additional context data
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Permission change audit
CREATE TABLE staff_permission_changes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_user_id UUID REFERENCES staff_members(user_id),
    changed_by_user_id UUID REFERENCES users(id),
    permission_id INTEGER REFERENCES permissions(id),
    change_type VARCHAR(20) NOT NULL,            -- 'grant', 'revoke', 'modify'
    old_permissions JSONB,                       -- Previous permissions
    new_permissions JSONB,                       -- New permissions
    reason TEXT,                                 -- Why change was made
    approved BOOLEAN DEFAULT FALSE,              -- Whether approval required
    approved_by UUID REFERENCES users(id),       -- Who approved
    approved TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Temporary role elevations
CREATE TABLE temporary_role_elevations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    staff_user_id UUID REFERENCES staff_members(user_id),
    elevated_by UUID REFERENCES users(id),
    original_role_id INTEGER REFERENCES staff_roles(id),
    elevated_role_id INTEGER REFERENCES staff_roles(id),
    reason TEXT NOT NULL,                        -- Emergency justification
    expires TIMESTAMP WITH TIME ZONE NOT NULL,
    status VARCHAR(20) DEFAULT 'active',         -- 'active', 'expired', 'revoked'
    auto_revoke BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    revoked TIMESTAMP WITH TIME ZONE
);
```

#### Implementation Code

```typescript
// Audit logging service
export class StaffAuditService {
  
  // Log staff access to customer data
  async logDataAccess(
    staffUserId: string,
    actionType: string,
    resourceType: string,
    resourceId: string,
    tenantId: string,
    metadata: Record<string, any> = {}
  ) {
    await db.staff_access_audit.create({
      data: {
        staff_user_id: staffUserId,
        action_type: actionType,
        resource_type: resourceType,
        resource_id: resourceId,
        tenant_id: tenantId,
        ip_address: metadata.ipAddress,
        user_agent: metadata.userAgent,
        details: metadata
      }
    });
  }
  
  // Log permission changes
  async logPermissionChange(
    staffUserId: string,
    changedByUserId: string,
    permissionId: number,
    changeType: string,
    oldPermissions: any[],
    newPermissions: any[],
    reason: string
  ) {
    await db.staff_permission_changes.create({
      data: {
        staff_user_id: staffUserId,
        changed_by_user_id: changedByUserId,
        permission_id: permissionId,
        change_type: changeType,
        old_permissions: oldPermissions,
        new_permissions: newPermissions,
        reason: reason
      }
    });
  }
  
  // Temporary role elevation
  async elevateRole(
    staffUserId: string,
    elevatedByUserId: string,
    elevatedRoleId: number,
    reason: string,
    expiresInMinutes: number = 60
  ) {
    const originalRole = await db.staff_members.findUnique({
      where: { user_id: staffUserId },
      include: { staff_roles: true }
    });
    
    const expiresAt = new Date(Date.now() + expiresInMinutes * 60 * 1000);
    
    return await db.temporary_role_elevations.create({
      data: {
        staff_user_id: staffUserId,
        elevated_by: elevatedByUserId,
        original_role_id: originalRole?.staff_roles.id,
        elevated_role_id: elevatedRoleId,
        reason: reason,
        expires_at: expiresAt,
        auto_revoke: true
      }
    });
  }
}
```

### 2. Compliance and Security Features

#### SOC 2/GDPR Audit Trail Implementation

```typescript
// Comprehensive audit logging middleware
export function staffAuditMiddleware(action: string, resourceType: string) {
  return async (req: Request, res: Response, next: NextFunction) => {
    const staffUserId = req.user?.id;
    const tenantId = req.headers['x-tenant-id'] as string;
    
    // Log the action
    await auditService.logDataAccess(
      staffUserId,
      action,
      resourceType,
      req.params.id || 'bulk',
      tenantId,
      {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
        endpoint: req.originalUrl,
        method: req.method
      }
    );
    
    next();
  };
}

// Compliance reporting service
export class ComplianceReportingService {
  
  async generateAuditReport(
    startDate: Date,
    endDate: Date,
    tenantId?: string
  ) {
    const auditLogs = await db.staff_access_audit.findMany({
      where: {
        created: {
          gte: startDate,
          lte: endDate
        },
        ...(tenantId && { tenant_id: tenantId })
      },
      include: {
        staff_members: {
          include: {
            staff_roles: true
          }
        }
      },
      orderBy: {
        created: 'DESC'
      }
    });
    
    return this.formatComplianceReport(auditLogs);
  }
  
  async detectSuspiciousActivity(staffUserId: string) {
    // Check for unusual access patterns
    const recentAccess = await db.staff_access_audit.findMany({
      where: {
        staff_user_id: staffUserId,
        created: {
          gte: new Date(Date.now() - 24 * 60 * 60 * 1000) // Last 24 hours
        }
      }
    });
    
    return this.analyzeAccessPattern(recentAccess);
  }
}
```

---

## 📅 Planned Implementation - 2027

### 1. Full Support Ticket Management System

#### Database Architecture

```sql
-- Core ticket system
CREATE TABLE support_tickets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ticket_number VARCHAR(20) UNIQUE NOT NULL,
    tenant_id UUID REFERENCES tenants(id),
    customer_email VARCHAR(255) NOT NULL,
    customer_name TEXT,
    subject VARCHAR(500) NOT NULL,
    description TEXT NOT NULL,
    category VARCHAR(100),                       -- 'technical', 'billing', 'feature_request', 'bug_report'
    priority VARCHAR(20) DEFAULT 'medium',       -- 'low', 'medium', 'high', 'critical'
    status VARCHAR(30) DEFAULT 'open',           -- 'open', 'in_progress', 'waiting_customer', 'resolved', 'closed'
    assigned_to UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    first_response TIMESTAMP WITH TIME ZONE,
    resolved TIMESTAMP WITH TIME ZONE,
    customer_satisfaction INTEGER CHECK (customer_satisfaction BETWEEN 1 AND 5),
    tags TEXT[] DEFAULT '{}',
    metadata JSONB DEFAULT '{}',
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Category-based routing
CREATE TABLE support_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT