---
last_modified_date: "2025-12-19"
---

# **Onboarding & Setup Journey**

## Strategic Alignment

**Strategic Alignment**: This comprehensive onboarding journey supports our [enterprise user activation strategy] by providing [seamless user setup and platform initialization], ensuring users achieve measurable value within their first 30 minutes while maintaining operational excellence and success across all user segments.

**Technical Authority**: Our [comprehensive onboarding infrastructure] integrates with [advanced user progress tracking systems] featuring [real-time status monitoring, automated intervention triggers, and role-based access control].

**Operational Excellence**: Backed by [enterprise-grade customer success platforms] with [99.9% uptime guarantees, advanced monitoring systems, and automated escalation protocols].

**User Journey Integration**: This journey is part of your complete [user activation experience] - connects to [authentication workflows, billing operations, campaign management, and ongoing user engagement optimization].

---

> **Framework Context**: This journey implements the progressive disclosure methodology outlined in [User Journey Framework](user-journey-framework.md#progressive-disclosure-framework)

> **Journey Flow:** `Email Verification → Company Setup → Team Invitation → Stripe Connect → IP Configuration → Dashboard Access`
> **Documentation Strategy:** Progressive setup complexity aligned with business model tiers

> **Quick Navigation:**
> - **[User Journey Framework](user-journey-framework.md)** - Complete progressive disclosure methodology
> - **[Authentication Journey](authentication-journey.md)** - Pre-requisite user authentication
> - **[Payment & Billing Journey](payment-billing-journey.md)** - Billing and payment setup
> - **[Campaign Operations Journey](campaign-operations-journey.md)** - Post-onboarding campaign management

---

## Normal Onboarding Flow

**Onboarding Status Tracking via tenant_users.roles:**
- **Empty roles array** (`roles: []` or `roles: null`) = pending invitation/onboarding not started
- **Assigned roles** (`roles: ['user', 'admin']`) = active user, onboarding completed
- **Role-based access control** determines feature availability and permissions
- **Analytics integration** tracks onboarding completion rates and drop-off points via role assignments

### Step 1: Email Verification
**⭐ Beginner Path:**
- **Action**: Click the signup/verification link from email.
- **Page**: Email Verification Page
- **Input**: Enter verification code if required.
- **Button**: 'Verify Email'
- **System Response**: Account activation and redirect to onboarding.
- **Success Metric**: <5 minutes verification time
- **Educational Content**: Simple explanation of security benefits

**⭐⭐ Intermediate Path:**
- **Advanced Verification**: Business email verification with domain validation
- **Backup Options**: Multiple verification methods, backup email setup
- **Team Verification**: Bulk verification for team members
- **Security Enhancement**: Advanced security features explanation

**⭐⭐⭐ Expert Path:**
- **Enterprise Verification**: KYC/AML verification for enterprise accounts
- **Compliance Integration**: Advanced compliance verification requirements
- **API Integration**: Programmatic verification for enterprise setups
- **White-label Verification**: Custom branded verification flows

### Step 2: Company Foundation
**⭐ Beginner Path:**
- **Action**: Navigate to company setup section.
- **Page**: Company Setup Wizard
- **Input**: Enter company name, industry, size, and basic information.
- **Action**: Select industry from dropdown and specify company size.
- **Button**: 'Save Company Profile'
- **Action**: Complete basic company profile setup.
- **Success Metric**: Company profile completion rate >80%
- **Time Estimate**: 2-3 minutes for basic setup

**⭐⭐ Intermediate Path:**
- **Advanced Profile**: Detailed company information, industry specifics
- **Integration Setup**: CRM connections, marketing stack integration
- **Team Structure**: Organizational hierarchy and team structure setup
- **Business Intelligence**: Advanced analytics and reporting setup

**⭐⭐⭐ Expert Path:**
- **Enterprise Profile**: Comprehensive enterprise setup with compliance
- **Custom Integration**: White-label company profiles, custom fields
- **Bulk Setup**: CSV import, API-based company configuration
- **Advanced Compliance**: Industry-specific compliance requirements

### Step 3: Team Building
**⭐ Beginner Path:**
- **Action**: Access team invitation section.
- **Page**: Team Management Panel
- **Input**: Enter email addresses for team members.
- **Action**: Assign roles (Owner, Admin, Member) to each invitee.
- **Button**: 'Send Invitations'
- **Action**: Set up initial team collaboration preferences.
- **Success Metric**: >60% team invitation acceptance rate
- **Role Explanation**: Simple role hierarchy explanation

**⭐⭐ Intermediate Path:**
- **Advanced Permissions**: Granular permission control, custom roles
- **Team Analytics**: Team usage tracking and optimization
- **Integration Setup**: Team management with external systems
- **Security Policies**: Team security and access policies

**⭐⭐⭐ Expert Path:**
- **Enterprise Team**: Complex organizational structures, multiple departments
- **Custom Roles**: White-label role systems, custom permission matrices
- **Bulk Management**: Bulk team management, automated provisioning
- **Advanced Integration**: Enterprise SSO, advanced security integration

### Step 4: Payment Setup
**⭐ Beginner Path:**
- **Action**: Proceed to Stripe Connect setup.
- **Page**: Stripe Onboarding Portal
- **Action**: Complete business verification requirements.
- **Input**: Provide business details, tax information, bank account.
- **Button**: 'Complete Stripe Setup'
- **Action**: Configure payment processing and understand platform fees.
- **Revenue Model**: Clear explanation of $100 → $77 fee structure
- **Success Metric**: <15 minutes for basic setup, <1% setup failure rate

**⭐⭐ Intermediate Path:**
- **Advanced Verification**: Enhanced business verification with documentation
- **Revenue Optimization**: Advanced fee optimization strategies
- **Team Billing**: Multi-user billing and expense management
- **Analytics Integration**: Revenue tracking and analytics setup

**⭐⭐⭐ Expert Path:**
- **Enterprise Billing**: Complex billing scenarios, custom payment terms
- **API Integration**: Programmatic billing setup and management
- **Compliance Integration**: Advanced compliance for enterprise billing
- **Custom Integration**: White-label billing with custom fee structures

### Step 5: Infrastructure Setup
**⭐ Beginner Path:**
- **Action**: Navigate to IP configuration section.
- **Page**: IP Management Setup
- **Action**: Select initial IP type (Shared/Dedicated).
- **Button**: 'Configure IP'
- **Action**: Follow DNS setup guidance and instructions.
- **Page**: DNS Configuration Guide
- **Action**: Complete email infrastructure preparation.
- **Success Metric**: <30 minutes to first email send, <5% bounce rate
- **Educational Content**: Basic deliverability concepts and best practices

**⭐⭐ Intermediate Path:**
- **Advanced IP Management**: Multiple IP setup, reputation monitoring
- **Deliverability Optimization**: Advanced deliverability strategies
- **Compliance Setup**: GDPR, CAN-SPAM compliance configuration
- **Integration Setup**: Email infrastructure with marketing stack

**⭐⭐⭐ Expert Path:**
- **Enterprise Infrastructure**: Complex IP management, enterprise compliance
- **API Integration**: Programmatic infrastructure management
- **Custom Infrastructure**: White-label infrastructure with custom DNS
- **Advanced Optimization**: AI-powered deliverability optimization

### Step 6: Dashboard Access
**⭐ Beginner Path:**
- **Action**: Complete onboarding checklist.
- **Page**: Onboarding Completion
- **Button**: 'Access Dashboard'
- **System Response**: Full platform access granted.
- **Welcome Tour**: Optional guided tour of key features
- **Success Metric**: >90% onboarding completion rate
- **Time to Value**: <30 minutes from signup to first action

**⭐⭐ Intermediate Path:**
- **Custom Dashboard**: Personalized dashboard configuration
- **Advanced Features**: Full feature access with optimization guidance
- **Team Onboarding**: Advanced team collaboration features
- **Analytics Setup**: Custom analytics and reporting configuration

**⭐⭐⭐ Expert Path:**
- **Enterprise Dashboard**: White-label dashboard with custom branding
- **API Access**: Full API access with documentation and examples
- **Custom Configuration**: Fully customized platform configuration
- **Advanced Integration**: Enterprise integrations and custom workflows

---

## Edge Cases & Recovery

### Onboarding Abandonment
- **Scenario**: User starts but doesn't complete onboarding within expected timeframe.
- **System Response**: Automated detection after 24-48 hours of inactivity using tenant_users.roles status.
- **Database Query**: Check tenant_users where roles is empty array for pending users.
- **Action**: Send recovery email with progress preservation link including user_id and tenant_id.

**⭐ Beginner Recovery:**
- **Page**: Onboarding Resume Page
- **Database Check**: Verify user has empty roles array, indicating incomplete onboarding.
- **Action**: Click 'Resume Onboarding' to pick up where they left off.
- **Button**: 'Continue Setup'
- **Support**: Simple chat support for basic assistance

**⭐⭐ Intermediate Recovery:**
- **Advanced Resume**: Detailed progress tracking with step-by-step resumption
- **Analytics**: Detailed abandonment analysis and prevention
- **Personalized Recovery**: Customized recovery based on abandonment reason
- **Enhanced Support**: Live chat, video calls, advanced troubleshooting

**⭐⭐⭐ Expert Recovery:**
- **Enterprise Recovery**: Dedicated support for enterprise onboarding
- **Custom Recovery**: White-label recovery processes
- **API Recovery**: Programmatic onboarding recovery and management
- **Advanced Analytics**: Comprehensive onboarding analytics and optimization

### Partial Completion Recovery
- **Scenario**: User encounters error or failure at a specific onboarding step.
- **Database Check**: Query tenant_users.roles to verify user status and permissions.
- **Action**: System detects step failure and displays error message with role-based context.

**⭐ Beginner Recovery:**
- **Page**: Error Resolution Modal
- **Database Update**: Log error details and timestamp in tenant_users record.
- **Action**: Attempt automatic retry or provide manual instructions.
- **Button**: 'Retry Step' or 'Manual Setup'
- **Support**: Basic troubleshooting with clear instructions

**⭐⭐ Intermediate Recovery:**
- **Advanced Diagnosis**: Detailed error analysis and recommendations
- **Alternative Setup**: Multiple setup approaches and options
- **Enhanced Support**: Screen sharing, advanced troubleshooting
- **Prevention**: Proactive error prevention and monitoring

**⭐⭐⭐ Expert Recovery:**
- **Enterprise Support**: Dedicated technical support for enterprise clients
- **Custom Solutions**: Tailored solutions for unique requirements
- **API Recovery**: Programmatic error recovery and management
- **Advanced Monitoring**: Comprehensive error tracking and prevention

---

## Business Model Integration

### Market Segment Alignment

#### Enterprise Agencies (Primary Market - 40% of TAM)
**Onboarding Priority:**
- **White-label Setup**: Custom branding and domain configuration
- **Multi-tenant Management**: Advanced team and client management setup
- **Compliance Integration**: Industry-specific compliance and security setup
- **Revenue Optimization**: Advanced revenue tracking and optimization setup

**Success Metrics:**
- **Time to Revenue**: <24 hours from signup to revenue generation
- **Setup Completion**: >95% onboarding completion for enterprise clients
- **Support Efficiency**: <4 hour resolution for enterprise onboarding issues

#### Mid-Market Companies (Secondary Market - 35% of TAM)
**Onboarding Priority:**
- **Professional Setup**: Advanced feature configuration and optimization
- **Team Collaboration**: Comprehensive team setup and collaboration features
- **Analytics Integration**: Business intelligence and reporting setup
- **Integration Setup**: CRM and marketing stack integration

**Success Metrics:**
- **Time to Value**: <2 hours from signup to first value realization
- **Feature Adoption**: >70% feature adoption within first week
- **Team Productivity**: >80% team activation within first month

#### High-Growth Startups (Future Market - 25% of TAM)
**Onboarding Priority:**
- **Rapid Deployment**: Quick setup with minimal configuration
- **Growth Optimization**: Features designed for rapid scaling
- **Viral Features**: Built-in viral and referral optimization
- **Cost Efficiency**: Optimized for cost-effective scaling

**Success Metrics:**
- **Time to First Send**: <30 minutes from signup to first email
- **Viral Coefficient**: >1.2 viral coefficient for user acquisition
- **Scaling Velocity**: >20% monthly user growth through viral mechanisms

### Progressive Disclosure Implementation

#### Content Complexity by User Type
- **⭐ Beginner**: Essential setup with guided assistance
- **⭐⭐ Intermediate**: Advanced features with optimization guidance
- **⭐⭐⭐ Expert**: Enterprise features with technical depth
- **Custom**: White-label and API-driven setup options

#### Feature Introduction Strategy
1. **Core Features First**: Essential email sending and management
2. **Business Features Second**: Revenue optimization and analytics
3. **Advanced Features Third**: Enterprise features and integrations
4. **Custom Features Last**: White-label and API capabilities

---

## Initial Setup Scenarios

### First-Time User Experience
- **Scenario**: Completely new user with no platform experience.
- **Action**: System detects first-time user and triggers welcome tour.

**⭐ Beginner Experience:**
- **Page**: Welcome Tour Modal
- **Action**: Follow interactive feature overview and quick start guide.
- **Button**: 'Start Tour'
- **Action**: Complete first successful action (e.g., send test email).
- **Page**: First Success Celebration
- **Action**: Receive continued learning recommendations.

**⭐⭐ Intermediate Experience:**
- **Personalized Tour**: Customized tour based on business type and goals
- **Advanced Tutorial**: Detailed feature walkthrough with best practices
- **Integration Guide**: Step-by-step integration with existing tools
- **Optimization Tips**: Advanced tips for maximizing platform value

**⭐⭐⭐ Expert Experience:**
- **Technical Deep Dive**: Comprehensive technical overview and architecture
- **Enterprise Setup**: Advanced enterprise configuration and customization
- **API Introduction**: Developer-focused onboarding with API examples
- **Custom Configuration**: White-label and custom setup options

### Company Profile Setup
- **Scenario**: Detailed company information configuration.
- **Action**: Access comprehensive profile setup.

**⭐ Beginner Setup:**
- **Page**: Advanced Company Profile
- **Input**: Enter detailed company information, industry specifics.
- **Action**: Configure team structure and organizational hierarchy.
- **Page**: Organization Chart Builder
- **Action**: Set up billing and subscription preferences.
- **Button**: 'Complete Profile Setup'
- **Status**: Company profile fully configured.

**⭐⭐ Advanced Setup:**
- **Integration Profile**: Advanced profile with integration requirements
- **Compliance Profile**: Industry-specific compliance and security setup
- **Analytics Profile**: Business intelligence and reporting configuration
- **Custom Fields**: Tailored profile fields and information collection

**⭐⭐⭐ Expert Setup:**
- **Enterprise Profile**: Comprehensive enterprise profile with all requirements
- **API Profile**: Programmatic profile management and bulk setup
- **Custom Profile**: White-label profile with custom fields and branding
- **Compliance Profile**: Advanced compliance with industry requirements

---

## Emergency Scenarios

### Onboarding System Failure
- **Scenario**: Critical system error prevents normal onboarding flow.
- **Action**: System automatically detects failure and activates backup process.

**⭐ Beginner Emergency:**
- **Page**: Alternative Onboarding Portal
- **Action**: Use manual form submission for critical information.
- **Button**: 'Submit Manually'
- **Action**: Escalate to support team for immediate assistance.
- **Page**: Emergency Support Channel
- **Action**: Receive personalized onboarding assistance.
- **Status**: Onboarding completed through alternative methods.

**⭐⭐ Intermediate Emergency:**
- **Advanced Backup**: Sophisticated backup onboarding with full feature parity
- **Priority Support**: Expedited support with advanced troubleshooting
- **Recovery Analytics**: Detailed failure analysis and prevention
- **Alternative Setup**: Multiple setup approaches and backup methods

**⭐⭐⭐ Expert Emergency:**
- **Enterprise Emergency**: Dedicated emergency support for enterprise clients
- **Custom Recovery**: White-label emergency recovery processes
- **API Recovery**: Programmatic emergency recovery and management
- **Advanced Analysis**: Comprehensive failure analysis and system optimization

---

## Strategic Documentation Impact

### Success Metrics Alignment
**Core KPIs:**
- **Time to First Value**: <30 minutes (aligned with Product Performance KPI)
- **Onboarding Completion Rate**: >80% (aligned with User Engagement KPI)
- **Support Ticket Reduction**: 40% decrease in onboarding-related tickets
- **Conversion Improvement**: 25% improvement in documentation → trial conversion

### Content Prioritization Framework
1. **Critical Path**: Authentication → Payment → Basic Setup → First Send
2. **Enhancement Path**: Advanced Features → Optimization → Integration
3. **Enterprise Path**: Custom Setup → Compliance → Advanced Integration
4. **Support Path**: Troubleshooting → Recovery → Escalation

### User Journey Integration
- **Progressive Complexity**: Each step increases in complexity and capability
- **Business Alignment**: Content depth matches business model tier
- **Market Segmentation**: Content approach varies by target market segment
- **Success Tracking**: Every step includes success metrics and validation

## Technical Implementation Links

- **[Onboarding & Authentication Guide](../technical/architecture/detailed-technical/onboarding-authentication.md)** - Complete user authentication and onboarding flow
- **[Database Schema Integration](../technical/architecture/detailed-technical/olap-analytics-schema.md)** - tenant_users.roles for status tracking and role-based access control
- **[Analytics Architecture](../technical/architecture/detailed-technical/analytics-architecture.md)** - Onboarding analytics and success tracking
- **[Business Model Alignment](../business/model/overview.md)** - Onboarding strategy aligned with revenue model
- **[Success Metrics Framework](../core-features/analytics/overview.md)** - Onboarding KPIs and measurement systems

**Keywords**: onboarding, user activation, setup process, role-based access, progressive disclosure, customer success, emergency recovery