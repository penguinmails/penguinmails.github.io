---
title: "Recovery & Troubleshooting: Team Management"
description: "Procedures for member removal, ownership transfer, emergency admin recovery, and common issues."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Recovery & Troubleshooting: Team Management

### **Team Management Recovery**

#### **Team Member Removal Process**

```markdown
Team Dashboard → Member Selection → Removal Confirmation → Asset Transfer → Access Termination → Notifications


```

**Detailed Steps:**

1. **Removal Initiation** (`):

   - **Access**: Owner/Admin clicks "Remove" action on member row
   - **Confirmation Modal**: Warning about permanent action and data impact
   - **Asset Transfer Options**: Reassign campaigns, contacts, IPs to other members

2. **Asset Transfer Workflow**:

   - **Campaign Ownership**: Dropdown to select new owner for each campaign
   - **Contact Lists**: Option to transfer or archive contact databases
   - **IP Assignments**: Reassign dedicated IPs to remaining team members
   - **Settings Preservation**: Maintain individual user preferences

3. **Access Termination**:

   - **Immediate**: Remove from all company resources
   - **Database**: Update tenant_user record with termination date
   - **Sessions**: Invalidate all active sessions for removed user
   - **API Access**: Revoke API keys and tokens

4. **Communication & Audit**:

   - **Email Notification**: Removed user receives departure confirmation
   - **Team Notification**: Remaining members notified of change
   - **Audit Logging**: Complete record of removal and asset transfers

#### **Role Escalation & Changes**

```markdown
Role Change Request → Permission Impact Review → Security Approval → Access Update → Team Notification


```

**Detailed Steps:**

1. **Role Change Request**:

   - **Initiator**: Owner/Admin accesses member settings
   - **New Role Selection**: Member → Admin → Owner hierarchy
   - **Impact Preview**: Shows what permissions change

2. **Security & Validation**:

   - **Owner Escalation**: Requires additional confirmation (can't be automated)
   - **Permission Review**: System checks for conflicting roles
   - **Audit Logging**: All role changes recorded with timestamps

3. **Access Propagation**:

   - **Immediate**: UI updates reflect new permissions
   - **Backend**: Database role updates propagate to all services
   - **Cache Clearing**: Session caches refreshed for immediate effect

#### **Owner Role Transfer**

```markdown
Owner Departure → Successor Selection → Transfer Confirmation → New Owner Setup → Team Notification


```

**Detailed Steps:**

1. **Transfer Initiation**:

   - **Current Owner**: Accesses "Transfer Ownership" in company settings
   - **Successor Selection**: Choose from existing Admins or Members
   - **Confirmation**: Multi-step confirmation (type company name, etc.)

2. **Transfer Process**:

   - **Role Swap**: Current Owner becomes Admin, selected user becomes Owner
   - **Permission Updates**: All company resources transfer ownership
   - **Billing Updates**: Account ownership transfers for billing purposes

3. **Verification & Communication**:

   - **Confirmation**: New Owner receives verification email
   - **Team Notification**: All members notified of ownership change
   - **Audit Trail**: Complete transfer record for compliance

---

## Emergency Scenarios

### **Critical Admin Protection**

```markdown
Last Admin Removal Attempt → System Block → Alternative Assignment → Permission Preservation


```

**Safety Mechanisms:**

1. **Detection Logic**:

   - **Trigger**: Attempt to remove/change role of last remaining Admin/Owner
   - **Validation**: Count of active admins in company
   - **Block**: Modal prevents action with clear explanation

2. **Resolution Options**:

   - **Promote Member**: Convert existing team member to Admin first
   - **Invite New Admin**: Require adding new admin before removal
   - **Transfer Ownership**: Complete ownership transfer process

### **Lost Administrative Access Recovery**

```markdown
Admin Access Loss → Support Ticket → Identity Verification → Staff Intervention → Access Restoration


```

**Recovery Process:**

1. **Verification Process**:

   - **Identity Proof**: Email confirmation, company details, payment history
   - **Business Ownership**: Articles of incorporation, tax documents
   - **Staff Review**: Manual verification by support team

2. **Access Restoration**:

   - **Temporary Access**: Staff-assisted account access
   - **Password Reset**: Secure reset process with verification
   - **Role Reassignment**: Restore appropriate administrative roles

---

## Troubleshooting & Common Issues

#### **"Why can't I invite team members?"**

1. **Insufficient Permissions**: Check your role - only Owner/Admin can invite.
2. **Plan Limits Reached**: Upgrade subscription plan for more seats.
3. **Email Domain Restrictions**: Use business email addresses or contact support.
4. **Unverified Company**: Complete onboarding process first.

#### **"Why did my team invitation expire?"**

1. **Time Limit Exceeded**: Resend invitation; links expire after 7 days.
2. **Recipient Email Issues**: Check spam folder, add to contacts, resend.
3. **Recipient Already Member**: User may already belong to the company or need to switch contexts.

#### **"Why can't I change someone's role?"**

1. **Hierarchy Restrictions**: Only Owner can change Admin roles.
2. **Last Admin Protection**: Cannot remove/downgrade last Admin.
3. **Permission Scope**: Try logging out and back in to refresh permissions.

#### **"Why am I seeing the wrong company data?"**

1. **Multi-Company Membership**: Use company switcher in top navigation.
2. **Session Issues**: Log out and log back in to select the correct workspace.
3. **Permission Changes**: Contact tenant admin to check your role at the tenant level.
