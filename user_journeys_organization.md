# Organization Organization & Team Management Journey

> **Journey Flow:** `Company Setup → Team Invitation → Role Assignment → Active Collaboration`

## Normal Team Operations

### Company Setup & Onboarding
**Journey Flow:** `Onboarding Modal → Company Details → Team Size → Initial Owner → Company Created`

#### 1. Company Information Collection (`/onboarding` - Step 1)
- **Modal Elements**:
  - Company name input field (required)
  - Industry dropdown selection
  - Team size range selector (1-10, 11-50, 51-200, 200+)
  - Company website URL (optional)
  - Company description textarea
- **Validation**: Real-time company name uniqueness check
- **Progress**: Step indicator shows 1 of 4 completed

#### 2. Initial Team Configuration
- **Owner Assignment**: Current user automatically becomes Owner
- **Team Size Confirmation**: Affects plan recommendations and feature limits
- **Optional Team Invites**: Can add initial team members immediately or skip

#### 3. Company Creation & Database Setup
- **Backend Process**: Tenant record creation in NileDB
- **Multi-tenant Setup**: RLS policies configured for new tenant
- **Feature Provisioning**: Base plan features activated
- **Email Notification**: Company creation confirmation

---

### Team Invitation & Onboarding
**Journey Flow:** `Team Dashboard → Invite Form → Email Sent → Recipient Journey → Team Integration`

#### 1. Invitation Initiation (`/team` or `/settings/team`)
- **Page Access**: Team management section in settings
- **Permission Check**: Only Owner/Admin can send invites
- **Invite Button**: Prominent "Invite Team Member" CTA

#### 2. Invitation Form
- **Form Elements**:
  - Email address input (required)
  - Role selection dropdown (Member, Admin, Owner)
  - Personal message textarea (optional)
  - "Send Invitation" button
- **Validation**: Email format, domain checks, duplicate prevention
- **Bulk Invites**: Option to upload CSV for multiple invites

#### 3. Invitation Email & Token Generation
- **Email Content**: Personalized invite with company branding
- **Security Token**: Time-limited invitation link (7 days expiration)
- **Tracking**: Invitation status monitoring (sent, viewed, accepted, expired)

#### 4. Recipient Invitation Journey
- **Email Reception**: Invitation email with clear subject line
- **Link Click**: Directs to invitation acceptance page
- **Account Check**: System checks if email already has an account
- **New User Flow**: Redirects to signup if needed
- **Existing User Flow**: Adds company association if account exists

#### 5. Invitation Acceptance & Role Assignment
- **Acceptance Page**: Clean confirmation screen
- **Role Confirmation**: Shows assigned role and permissions
- **Company Integration**: User added to company tenant
- **Welcome Email**: Confirmation of team membership

---

### Ongoing Team Management
**Journey Flow:** `Team Dashboard → Member Actions → Permission Updates → Activity Monitoring`

#### 1. Team Dashboard Access (`/team`)
- **Member List**: Table showing all team members with status
- **Columns**: Name, Email, Role, Join Date, Last Active, Status
- **Actions**: Edit role, remove member, resend invitation (per member)
- **Bulk Actions**: Select multiple members for batch operations

#### 2. Role Management Interface
- **Role Change Modal**:
  - Current role display
  - New role dropdown (Member → Admin → Owner hierarchy)
  - Permission preview (what changes with role)
  - Confirmation with impact warning
- **Security Logging**: All role changes audited

#### 3. Team Activity Monitoring
- **Activity Feed**: Recent team actions and changes
- **Usage Analytics**: Per-member campaign activity
- **Access Logs**: Login patterns and feature usage
- **Alerts**: Inactive members, permission changes

### Edge Cases & Recovery

#### Team Member Removal Process
```
Team Dashboard → Member Selection → Removal Confirmation → Asset Transfer → Access Termination → Notifications
```

**Detailed Steps:**
1. **Removal Initiation** (`/team`):
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

#### Role Escalation & Changes
```
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

#### Owner Role Transfer
```
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

### Initial Setup Scenarios

#### Company Creation & Setup
```
Onboarding Start → Company Form → Industry/Type Selection → Team Size Config → Owner Setup → Database Creation
```

**Detailed Steps:**
1. **Onboarding Context**:
   - **Trigger**: Post-email verification, pre-dashboard access
   - **Modal Sequence**: 4-step wizard with progress indicator
   - **Skip Prevention**: Required fields marked clearly

2. **Company Information Form**:
   - **Required Fields**: Company name, industry, team size
   - **Optional Fields**: Website, description, logo upload
   - **Validation**: Company name uniqueness, industry categorization
   - **Auto-save**: Draft saving to prevent data loss

3. **Industry & Team Configuration**:
   - **Industry Selection**: Predefined categories with growth analytics
   - **Team Size Impact**: Affects initial plan recommendations
   - **Customization**: Option for custom industry entry

4. **Owner Role Confirmation**:
   - **Automatic Assignment**: Current user becomes Owner
   - **Permission Preview**: Shows Owner capabilities
   - **Account Creation**: Company tenant created in database

#### First Team Member Invitation
```
Post-Company Creation → Team Tab Access → Invite Modal → Email Config → Send → Recipient Flow
```

**Detailed Steps:**
1. **Team Management Discovery**:
   - **Dashboard**: "Invite your first team member" prompt
   - **Settings**: Team management section becomes accessible
   - **Onboarding**: Optional step in company setup wizard

2. **Invitation Interface**:
   - **Simplified Form**: Email + role selection only
   - **Role Guidance**: Tooltips explaining Member vs Admin permissions
   - **Bulk Option**: CSV upload for multiple initial invites

3. **Email & Tracking**:
   - **Branded Email**: Company logo and personalized message
   - **Status Tracking**: Invitation sent, viewed, accepted, expired
   - **Resend Options**: Easy retry for undelivered invites

---

### Emergency Scenarios

#### Critical Admin Protection
```
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

3. **Communication**:
   - **Error Message**: Clear explanation of business requirement
   - **Guidance**: Step-by-step instructions for resolution
   - **Support Contact**: Link to help for complex situations

#### Lost Administrative Access Recovery
```
Admin Access Loss → Support Ticket → Identity Verification → Staff Intervention → Access Restoration
```

**Recovery Process:**
1. **Issue Identification**:
   - **Self-Report**: Affected user contacts support
   - **Detection**: System monitors for orphaned companies
   - **Escalation**: Priority routing for admin access issues

2. **Verification Process**:
   - **Identity Proof**: Email confirmation, company details, payment history
   - **Business Ownership**: Articles of incorporation, tax documents
   - **Staff Review**: Manual verification by support team

3. **Access Restoration**:
   - **Temporary Access**: Staff-assisted account access
   - **Password Reset**: Secure reset process with verification
   - **Role Reassignment**: Restore appropriate administrative roles

---

## Common Team Management Issues & Troubleshooting

### "Why can't I invite team members?"

**Possible Causes & Solutions:**

1. **Insufficient Permissions**
   - **Symptom**: "You don't have permission" error
   - **Solution**: Check your role - only Owner/Admin can invite
   - **Fix**: Contact company owner to upgrade your role

2. **Plan Limits Reached**
   - **Symptom**: "Team size limit exceeded"
   - **Solution**: Upgrade subscription plan for more seats
   - **Check**: Billing dashboard shows current limits

3. **Email Domain Restrictions**
   - **Symptom**: "Email domain not allowed"
   - **Solution**: Use business email addresses or contact support
   - **Prevention**: Set allowed domains in company settings

4. **Unverified Company**
   - **Symptom**: Invites blocked until company setup complete
   - **Solution**: Complete onboarding process first
   - **Status**: Check company verification status

### "Why did my team invitation expire?"

**Possible Causes & Solutions:**

1. **Time Limit Exceeded**
   - **Symptom**: Invitation link no longer works
   - **Solution**: Resend invitation from team management
   - **Timeline**: Invites expire after 7 days for security

2. **Recipient Email Issues**
   - **Symptom**: Invitation never received or marked as spam
   - **Solution**: Check spam folder, add to contacts, resend
   - **Prevention**: Use clear subject lines and recognizable sender

3. **Recipient Already Member**
   - **Symptom**: "User already belongs to this company"
   - **Solution**: Check if user is already in team list
   - **Alternative**: User may need to switch company context

### "Why can't I change someone's role?"

**Possible Causes & Solutions:**

1. **Hierarchy Restrictions**
   - **Symptom**: "Cannot change role" for certain members
   - **Solution**: Only Owner can change Admin roles
   - **Check**: Role hierarchy: Owner > Admin > Member

2. **Last Admin Protection**
   - **Symptom**: Cannot remove last Admin from company
   - **Solution**: Promote another member to Admin first
   - **Business Rule**: Companies must have at least one Admin

3. **Permission Scope**
   - **Symptom**: Role changes don't take effect
   - **Solution**: Log out and log back in to refresh permissions
   - **Technical**: Permission cache may need clearing

### "Why can't I remove a team member?"

**Possible Causes & Solutions:**

1. **Active Asset Ownership**
   - **Symptom**: "Cannot remove: member owns active campaigns"
   - **Solution**: Transfer campaign ownership to another member first
   - **Check**: Asset transfer modal guides through required steps

2. **Billing Impact**
   - **Symptom**: Removal blocked by subscription terms
   - **Solution**: Review billing implications or contact support
   - **Consider**: Per-seat pricing may require plan adjustment

3. **Last Admin Rule**
   - **Symptom**: System prevents removal of last Admin
   - **Solution**: Assign Admin role to another member first
   - **Prevention**: Always maintain at least one Admin in company

### "Why am I seeing the wrong company data?"

**Possible Causes & Solutions:**

1. **Multi-Company Membership**
   - **Symptom**: Seeing data from wrong company
   - **Solution**: Use company switcher in top navigation
   - **Context**: Users can belong to multiple companies

2. **Session Issues**
   - **Symptom**: Company context lost after login
   - **Solution**: Log out and log back in, select correct company
   - **Prevention**: Bookmark company-specific URLs

3. **Permission Changes**
   - **Symptom**: Lost access to company features
   - **Solution**: Contact company admin to check your role
   - **Check**: Team management shows your current permissions

## Technical Implementation Links

- **[Database Schema Guide](database_schema_guide.md)** - Data models and relationships for team management