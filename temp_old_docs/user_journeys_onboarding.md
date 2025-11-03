# Setup Onboarding & Setup Journey

> **Journey Flow:** `Email Verification → Company Setup → Team Invitation → Stripe Connect → IP Configuration → Dashboard Access`

**Overview:** Complete user onboarding process from email verification through full platform setup and activation. Onboarding progress is tracked via tenant_users.roles field for better user experience and analytics.

**Status Tracking via tenant_users.roles:**
- **Empty roles array** (`roles: []` or `roles: null`) = pending invitation/onboarding not started
- **Assigned roles** (`roles: ['user', 'admin']`) = active user, onboarding completed
- **Role-based access control** determines feature availability and permissions
- **Analytics integration** tracks onboarding completion rates and drop-off points via role assignments

**Detailed Documentation:**
- **[Normal, Edge, Initial & Emergency Scenarios](user_journeys_onboarding.md)** - Complete onboarding journey specifications
- **[Technical Implementation](onboarding_and_authentication_guide.md)** - Complete user authentication and onboarding flow
- **[Database Schema](database_schema_guide.md)** - Multi-tenant authentication and role-based access control

**Documentation Organization:**
- **Main User Journeys**: [user_journeys.md](user_journeys.md) - All domains with table of contents navigation
- **Legacy References**: Individual journey documents maintained for backward compatibility
- **Technical Implementation**: [Technical Constraints Analysis](technical_constraints_analysis.md) + [Implementation Roadmap](implementation_roadmap.md)

---

## Normal Onboarding Flow

**Onboarding Steps:**
1. **Email Verification**
   - **Action**: Click the signup/verification link from email.
   - **Page**: Email Verification Page
   - **Input**: Enter verification code if required.
   - **Button**: 'Verify Email'
   - **System Response**: Account activation and redirect to onboarding.

2. **Company Foundation**
   - **Action**: Navigate to company setup section.
   - **Page**: Company Setup Wizard
   - **Input**: Enter company name, industry, size, and basic information.
   - **Action**: Select industry from dropdown and specify company size.
   - **Button**: 'Save Company Profile'
   - **Action**: Complete basic company profile setup.

3. **Team Building**
   - **Action**: Access team invitation section.
   - **Page**: Team Management Panel
   - **Input**: Enter email addresses for team members.
   - **Action**: Assign roles (Owner, Admin, Member) to each invitee.
   - **Button**: 'Send Invitations'
   - **Action**: Set up initial team collaboration preferences.

4. **Payment Setup**
   - **Action**: Proceed to Stripe Connect setup.
   - **Page**: Stripe Onboarding Portal
   - **Action**: Complete business verification requirements.
   - **Input**: Provide business details, tax information, bank account.
   - **Button**: 'Complete Stripe Setup'
   - **Action**: Configure payment processing and understand platform fees.

5. **Infrastructure Setup**
   - **Action**: Navigate to IP configuration section.
   - **Page**: IP Management Setup
   - **Action**: Select initial IP type (Shared/Dedicated).
   - **Button**: 'Configure IP'
   - **Action**: Follow DNS setup guidance and instructions.
   - **Page**: DNS Configuration Guide
   - **Action**: Complete email infrastructure preparation.

6. **Dashboard Access**
   - **Action**: Complete onboarding checklist.
   - **Page**: Onboarding Completion
   - **Button**: 'Access Dashboard'
   - **System Response**: Full platform access granted.

### Edge Cases & Recovery

#### **Onboarding Abandonment**
- **Scenario**: User starts but doesn't complete onboarding within expected timeframe.
- **System Response**: Automated detection after 24-48 hours of inactivity using tenant_users.roles status.
- **Database Query**: Check tenant_users where roles is empty array for pending users.
- **Action**: Send recovery email with progress preservation link including user_id and tenant_id.
- **Page**: Onboarding Resume Page
- **Database Check**: Verify user has empty roles array, indicating incomplete onboarding.
- **Action**: Click 'Resume Onboarding' to pick up where they left off.
- **Button**: 'Continue Setup'
- **Action**: Provide completion support if needed.
- **Page**: Support Chat Widget
- **Database Tracking**: Log abandonment analytics via role assignment timestamps for product improvement.

#### **Partial Completion Recovery**
- **Scenario**: User encounters error or failure at a specific onboarding step.
- **Database Check**: Query tenant_users.roles to verify user status and permissions.
- **Action**: System detects step failure and displays error message with role-based context.
- **Page**: Error Resolution Modal
- **Database Update**: Log error details and timestamp in tenant_users record.
- **Action**: Attempt automatic retry or provide manual instructions.
- **Button**: 'Retry Step' or 'Manual Setup'
- **Action**: Use alternative verification methods if primary fails.
- **Page**: Alternative Setup Options
- **Database Persistence**: Update tenant_users.roles array when steps are successfully completed.
- **Action**: Preserve progress and allow continuation from failed step based on current role assignments.

#### **Browser/Technology Issues**
- **Scenario**: Compatibility problems with browser, device, or network.
- **Action**: Detect browser compatibility issues.
- **Page**: Compatibility Check Page
- **Action**: Suggest alternative browsers or devices.
- **Button**: 'Try Different Browser'
- **Action**: Provide manual setup instructions for unsupported environments.
- **Page**: Manual Setup Guide
- **Action**: Contact support for assistance.
- **Button**: 'Contact Support'

### Initial Setup Scenarios

#### **First-Time User Experience**
- **Scenario**: Completely new user with no platform experience.
- **Action**: System detects first-time user and triggers welcome tour.
- **Page**: Welcome Tour Modal
- **Action**: Follow interactive feature overview and quick start guide.
- **Button**: 'Start Tour'
- **Action**: Complete first successful action (e.g., send test email).
- **Page**: First Success Celebration
- **Action**: Receive continued learning recommendations.
- **Page**: Learning Dashboard

#### **Company Profile Setup**
- **Scenario**: Detailed company information configuration.
- **Action**: Access comprehensive profile setup.
- **Page**: Advanced Company Profile
- **Input**: Enter detailed company information, industry specifics.
- **Action**: Configure team structure and organizational hierarchy.
- **Page**: Organization Chart Builder
- **Action**: Set up billing and subscription preferences.
- **Button**: 'Complete Profile Setup'
- **Status**: Company profile fully configured.

### Emergency Scenarios

#### **Onboarding System Failure**
- **Scenario**: Critical system error prevents normal onboarding flow.
- **Action**: System automatically detects failure and activates backup process.
- **Page**: Alternative Onboarding Portal
- **Action**: Use manual form submission for critical information.
- **Button**: 'Submit Manually'
- **Action**: Escalate to support team for immediate assistance.
- **Page**: Emergency Support Channel
- **Action**: Receive personalized onboarding assistance.
- **Status**: Onboarding completed through alternative methods.

#### **Data Loss During Setup**
- **Scenario**: User data corrupted or lost during onboarding process.
- **Database Verification**: Check tenant_users.roles for user status and permissions.
- **Action**: System detects data inconsistency and initiates recovery using role-based progress.
- **Page**: Data Recovery Portal
- **Database Recovery**: Restore access based on tenant_users.roles assignments.
- **Action**: Re-enter information using recovery assistance tools.
- **Button**: 'Start Recovery'
- **Database Update**: Update tenant_users record with recovery timestamp.
- **Action**: Verify recovered data integrity.
- **Page**: Data Verification Dashboard
- **Action**: Resume setup from last verified checkpoint based on assigned roles.
- **Status**: Setup completed with data integrity restored and access preserved.

## Technical Implementation Links

- **[Onboarding & Authentication Guide](onboarding_and_authentication_guide.md)** - Complete user authentication and onboarding flow
- **[Database Schema Guide](database_schema_guide.md)** - tenant_users.roles for status tracking and role-based access control
- **[API Reference](api_reference.md)** - NileDB tenant user management and role assignment endpoints