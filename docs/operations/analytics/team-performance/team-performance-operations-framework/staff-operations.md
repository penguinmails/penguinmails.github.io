---
title: "Staff Operations & Management"
description: "Hierarchical staff management system, RBAC, and internal support operational workflows."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Staff Operations & Management

### **System Architecture**

#### **Current Design Implementation**

```markdown
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

### **Staff Management System**

#### **Database Design**

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

### **Staff Hierarchy Design**

#### **4-Tier Staff System**

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

### **Role Assignment Process**

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

### **Help System Integration**

#### **Dashboard Help Integration**

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

#### **Landing Page Support Button**

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

### **Email-Based Support Workflow**

#### **Support Process Design**

**Email Routing:** <support@penguinmails.com>

**Process Flow Design:**

1. **Customer Contact** via landing page button or help center
2. **Manual Triage** by support team
3. **Email Assignment** based on category/expertise
4. **Response & Resolution** via email
5. **Follow-up** as needed

#### **Email Template System**

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
