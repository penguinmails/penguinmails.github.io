# Authentication Authentication & Access Control Journey

> **Journey Flow:** `Landing → Email Verification → Dashboard Access → Session Management`

## Normal Authentication Flow

### First-Time User Registration Flow
**Journey Flow:** `Landing Page → Email Signup → Verification → Onboarding → Dashboard`

#### 1. Landing Page Discovery (`/`)
- **Page**: WordPress marketing site (external)
- **Discovery Elements**:
  - Hero section "Get Started Free" CTA button
  - Feature comparison section "Start Your Free Trial" button
  - Footer signup form
- **User Action**: Clicking any CTA redirects to `/signup`
- **Analytics**: Tracks source (hero, features, footer) for conversion optimization

#### 2. Account Registration (`/signup`)
- **Page**: Clean Next.js registration form
- **Form Elements**:
  - Email input with real-time validation
  - Cloudflare Turnstile CAPTCHA (invisible or interactive)
  - Terms of service checkbox + "Sign Up" button
  - "Already have an account? Sign in" link
- **Validation**: Email format + domain allowlist/blocklist
- **Error States**: Invalid email, CAPTCHA failure, rate limiting

#### 3. Email Verification (`/verify-email`)
- **Page**: Confirmation page with email preview
- **Email Options**: Magic link (primary) or 6-digit code (fallback)
- **Magic Link Flow**:
  - **Email Content**: Personalized link with 1-hour expiration
  - **Click Action**: Direct dashboard access with token validation
  - **Security**: Single-use token, IP logging
- **Code Fallback**:
  - **Page**: Code entry form (`/verify-code`)
  - **Elements**: 6 individual input fields + "Verify" button
  - **UX**: Auto-advance between fields, paste support

#### 4. Onboarding Initiation
- **Page**: Dashboard with onboarding modal overlay (`/onboarding`)
- **Modal Sequence**:
  - **Step 1**: Company information (name, industry, size)
  - **Step 2**: Team invitation (optional)
  - **Step 3**: Payment setup (Stripe Connect)
  - **Step 4**: Infrastructure config (IP selection)
- **Progress**: Step indicator + estimated completion time (15-20 min)
- **Skip Option**: "Complete later" with feature gating

#### 5. Full Dashboard Access
- **Page**: Main dashboard (`/dashboard`)
- **Welcome Experience**:
  - Optional guided tour
  - Quick action cards (Create Campaign, Upload Contacts, etc.)
  - Progress widgets for setup completion
- **Feature Unlocking**: All premium features available after onboarding

---

### Returning User Login Flow
**Journey Flow:** `Login Page → Authentication → Dashboard Access → Session Resume`

#### 1. Login Page Access (`/login`)
- **Page**: Dedicated login form
- **Access Methods**:
  - Direct URL navigation
  - "Sign In" link from landing page
  - Automatic redirect from protected routes
- **Form Elements**:
  - Email field (auto-filled from localStorage)
  - Password field with show/hide toggle
  - "Remember me" checkbox
  - "Forgot Password?" link
  - "Sign Up" link for new users

#### 2. Authentication Processing
- **Validation**: Email exists + password hash comparison
- **Security Checks**:
  - Account status (active/suspended/locked)
  - Geographic/IP allowlist (enterprise feature)
  - Device fingerprinting for fraud detection
- **Multi-Factor**: Not implemented (planned under feature flag)

#### 3. Dashboard Restoration
- **Page**: Main dashboard (`/dashboard`)
- **State Recovery**:
  - Last viewed page/URL restoration
  - Form data preservation (if applicable)
  - Shopping cart/wishlist persistence
- **Recent Activity**: "Welcome back" notification with recent actions

#### 4. Ongoing Session Management
- **Technical Details**: See [Onboarding & Authentication Guide](onboarding_and_authentication_guide.md) for implementation specifications
- **User Experience**: Sessions persist across browser restarts and device switches
- **Security**: Automatic logout after configurable inactivity period

---

## Common Authentication Issues & Troubleshooting

### "Why is my login not working?"

**Possible Causes & Solutions:**

1. **Incorrect Password**
   - **Symptom**: "Invalid credentials" error
   - **Solution**: Use "Forgot Password?" link to reset
   - **Prevention**: Check caps lock, clear browser cache

2. **Account Not Verified**
   - **Symptom**: "Please verify your email" message
   - **Solution**: Check email for verification link or request new one
   - **Prevention**: Complete email verification immediately after signup

3. **Account Suspended/Locked**
    - **Symptom**: "Account temporarily suspended" (not implemented - users contact support)
    - **Solution**: Contact support for account recovery - no automatic lockout exists
    - **Prevention**: Use password reset flow for access recovery

4. **Browser/Cookie Issues**
   - **Symptom**: Constant redirects or session loss
   - **Solution**: Clear browser cookies, try incognito mode
   - **Prevention**: Enable cookies for the domain

5. **Network/Security Blocking**
   - **Symptom**: "Connection blocked" or firewall warnings
   - **Solution**: Whitelist domain, disable VPN temporarily
   - **Prevention**: Check corporate firewall policies

### "Why is my name not appearing if I put it during signup?"

**Possible Causes & Solutions:**

1. **Onboarding Not Completed**
   - **Symptom**: Basic email shown instead of full name
   - **Solution**: Complete the onboarding process with company/team setup
   - **Location**: Look for onboarding modal or visit `/onboarding`

2. **Profile Data Not Saved**
   - **Symptom**: Name missing from account settings
   - **Solution**: Update profile in account settings (`/settings/profile`)
   - **Fields**: First name, last name, display preferences

3. **Session Cache Issues**
   - **Symptom**: Name appears in some places but not others
   - **Solution**: Log out and log back in to refresh session data
   - **Prevention**: Profile updates require session refresh

### "Why am I not able to access the admin panel?"

**Possible Causes & Solutions:**

1. **Insufficient Permissions**
   - **Symptom**: "Access denied" or admin features hidden
   - **Solution**: Check role assignment in team management
   - **Required Roles**: Must be Owner or Admin in the company

2. **Company Setup Incomplete**
   - **Symptom**: Admin features not available
   - **Solution**: Complete company registration and payment setup
   - **Requirements**: Active Stripe Connect account

3. **Multi-Tenant Isolation**
   - **Symptom**: Admin access works in one company but not another
   - **Solution**: Switch company context or contact support
   - **Technical**: Each user has separate permissions per company

4. **Billing Status Issues**
   - **Symptom**: Admin panel blocked due to payment problems
   - **Solution**: Resolve outstanding invoices or payment method issues
   - **Check**: Billing dashboard for account status

---

### Customer Service Access Recovery
**Journey Flow:** `Access Issue → Support Contact → Identity Verification → Account Recovery`

#### 1. Support Portal Access (`/support`)
- **Page**: Customer support portal
- **Access Points**:
  - "Contact Support" links throughout app
  - Account lockout screens
  - Error pages with support buttons
- **Categories**: Authentication, Billing, Technical, Account Recovery

#### 2. Account Recovery Request
- **Form Elements**:
  - Incident type selection (dropdown)
  - Description textarea
  - File upload for screenshots
  - Contact preference (email/chat/phone)
- **Priority Assessment**: Automatic urgency detection
- **Response SLA**: < 2 hours for urgent, < 24 hours for standard

#### 3. Identity Verification Process
- **Verification Methods**:
  - Email confirmation with security questions
  - Phone verification (SMS code)
  - Document upload (ID, account statements)
  - Knowledge-based authentication
  - **NileDB Invitation System**: For team member access recovery (available Q4 2025)
- **Staff Review**: Manual verification for high-value accounts

#### 4. Account Restoration
- **Recovery Options**:
  - Password reset with temporary access
  - Account unlock with security monitoring
  - Data export for account migration
  - **NileDB Invitation Resend**: For pending team invitations
  - Full account restoration
- **Security Measures**: Enhanced monitoring post-recovery
- **Communication**: Detailed incident report + prevention tips

### NileDB Invitation System Integration (Q4 2025)
**Journey Flow:** `Admin Invitation → User Acceptance → Account Activation`

#### Invitation Creation
```typescript
// Admin sends invitation via NileDB
const n = await nile.withContext({ tenantId: '0196...' });
await n.tenants.invite('user@example.com', {
  callbackUrl: `${process.env.APP_URL}/accept-invite`,
  redirectUrl: process.env.APP_URL
});
```

#### Invitation Acceptance
- **Email Notification**: NileDB handles invitation delivery automatically
- **Security**: Built-in token management and expiration
- **Multi-Tenant**: Automatic tenant association
- **Single-Use**: One-time acceptance tokens

#### Benefits vs Current System
- **Built-in Security**: Automatic token management and expiration
- **Email Integration**: Native email delivery via NileDB
- **Tenant Isolation**: Proper multi-tenant membership handling
- **Audit Trail**: Comprehensive invitation logging
- **Scalability**: No custom invitation table management needed

---

### Account Suspension & Blocking Scenarios
**Journey Flow:** `Suspicious Activity → Account Suspension → Appeal Process → Resolution`

#### 1. Suspension Detection & Implementation
- **Automatic Triggers**:
  - High bounce rates (> 5% threshold)
  - Spam complaints (> 0.2% threshold)
  - Payment failures (after grace period)
  - Security violations (multiple failed logins)
- **Suspension Types**:
  - **Warning**: Feature restrictions with notice
  - **Temporary**: Full access blocked for 24-72 hours
  - **Permanent**: Complete account termination

#### 2. Suspension Notification
- **Communication Channels**:
  - In-app notification banner
  - Email with detailed explanation
  - Dashboard overlay with appeal options
- **Information Provided**:
  - Reason for suspension
  - Resolution steps required
  - Appeal process timeline
  - Contact information for support

#### 3. Appeal & Resolution Process
- **Self-Service Appeal**:
  - **Page**: Account suspension portal (`/account-suspended`)
  - **Form**: Appeal statement + evidence upload
  - **Timeline**: Review within 24-48 hours
- **Support-Assisted Resolution**:
  - Priority support ticket creation
  - Direct staff communication
  - Expedited review process
- **Resolution Outcomes**:
  - Account reinstatement with conditions
  - Feature restoration with monitoring
  - Data export for account migration

### Edge Cases & Recovery

#### Password Recovery Flow (NileDB Native)
```
Dashboard Access Issue → "Forgot Password?" Link → Email Reset → Token Validation → New Password
```

**Detailed Steps:**
1. **Initiation** (`/login` or `/dashboard`):
   - **Page**: Login page or session expired modal
   - **Element**: "Forgot Password?" link/button
   - **Action**: Clicking opens password reset form

2. **Reset Request**:
   - **Page**: Password reset form (`/reset-password`)
   - **Elements**: Email input field + "Send Reset Link" button
   - **Validation**: Email exists in system
   - **Security**: Rate limiting (3 attempts per hour per IP)

3. **Email Processing**:
   - **Email Sent**: Secure reset token (expires in 1 hour)
   - **Content**: Reset link + fallback 6-digit code
   - **Tracking**: Reset attempt logged for security

4. **Password Reset**:
   - **Page**: Secure reset form (`/reset-password/:token`)
   - **Elements**: New password fields + strength indicator + "Update Password" button
   - **Validation**: Password strength requirements
   - **Completion**: All existing sessions invalidated

#### Account Lockout Handling (Roadmap: Q2 2026)
```
Failed Login Attempts → Progressive Delays → Account Lockout → Support Recovery
```

**Current Implementation:**
1. **No Failed Attempts Tracking**:
     - **Current State**: No tracking of failed login attempts implemented
     - **User Experience**: Friendly message "contact support" for failed logins
     - **Recovery**: Relies entirely on password reset flow

2. **No Account Lockout**:
     - **Page**: Standard login screen with error message
     - **Elements**: Error message + "Forgot Password?" link
     - **Duration**: No automatic lockout exists
     - **Communication**: No email notifications for failed attempts

3. **Future Implementation (Q2 2026)**:
     - **Tracking**: Login attempts table with IP and user agent logging
     - **Progressive Delays**: 1st attempt = 0s, 2nd = 5s, 3rd = 30s, 4th = 300s
     - **Lockout**: After 5 failed attempts within 15 minutes
     - **Duration**: Configurable (default 30 minutes)
     - **Recovery**: Support-assisted unlock or password reset
     - **Communication**: Email alerts for suspicious activity

4. **Support Resolution**:
     - **Page**: Support portal (`/support`)
     - **Elements**: Incident description + identity verification
     - **Process**: Manual staff assistance → account unlock or password reset

#### Session Recovery
```
Session Timeout → Re-authentication Prompt → Quick Login → Dashboard Restore
```

**Detailed Steps:**
1. **Session Expiration**:
   - **Detection**: Inactivity timeout (configurable, default 24h)
   - **UI**: Session expired modal overlay
   - **State**: Current page/context preserved

2. **Re-authentication**:
   - **Page**: Quick login modal (not full login form)
   - **Elements**: Email field (pre-filled) + password + "Sign In" button
   - **Validation**: Current password required
   - **Security**: CAPTCHA after 3 failed attempts

3. **Dashboard Restoration**:
   - **State**: Returns to exact previous page
   - **Context**: Form data preserved where possible
   - **Notifications**: "Session restored" confirmation

### Initial Setup Scenarios

#### New User Registration
```
WordPress Landing → Signup Form → CAPTCHA Success → Verification Email → Account Ready
```

**Detailed Steps:**
1. **Discovery** (`/` - WordPress landing):
   - **Scroll**: User scrolls to features section
   - **CTA**: "Get Started" button click
   - **Transition**: Redirect to `/signup` in Next.js app

2. **Registration Form** (`/signup`):
   - **Page Load**: Clean form with email field focus
   - **Input**: Email address entry with real-time validation
   - **CAPTCHA**: Cloudflare Turnstile widget loads
   - **Interaction**: User completes CAPTCHA challenge
   - **Submission**: "Send Verification Code" button click

3. **Email Verification** (`/verify-email`):
   - **Loading**: Spinner while email sends
   - **Success Message**: "Check your email" confirmation
   - **Email Arrival**: Magic link + fallback code in email
   - **Link Click**: Direct dashboard access with token validation

4. **Account Activation**:
   - **Database**: User record created in NileDB
   - **Session**: JWT token issued for immediate access
   - **Onboarding Check**: Automatic redirect to `/onboarding`

#### Email Verification Retry
```
Expired Magic Link → "Resend Email" Button → New Verification → Alternative Code → Access
```

**Detailed Steps:**
1. **Expired Link Detection**:
   - **Click**: User clicks expired magic link
   - **Page**: Error page (`/link-expired`) with explanation
   - **Options**: "Send New Link" or "Enter Code Manually"

2. **Resend Flow**:
   - **Button**: "Send New Verification Email" click
   - **Form**: Pre-filled email field + "Resend" button
   - **Confirmation**: Success toast + email sent notification

3. **Alternative Code Entry**:
   - **Page**: Code verification form (`/verify-code`)
   - **Elements**: 6 input fields for code entry + "Verify" button
   - **Validation**: Real-time code validation
   - **Success**: Dashboard access granted

### Emergency Scenarios

#### Security Incident Response
```
Suspicious Login Detected → Immediate Lockout → Security Alert → Manual Review → Access Restoration
```

**Detailed Steps:**
1. **Detection**:
   - **Pattern**: Login from new country/device + failed attempts
   - **IP Analysis**: Blacklisted IP or unusual location
   - **Rate Limiting**: Excessive login attempts from single IP

2. **Immediate Response**:
   - **Lockout**: Account temporarily suspended
   - **Notification**: Email alert to user + security team
   - **Logging**: All incident details captured for review

3. **Security Review**:
   - **Page**: Account recovery portal (`/account-locked`)
   - **Elements**: Identity verification form + support ticket creation
   - **Process**: Manual staff review within 24 hours

4. **Access Restoration**:
   - **Approval**: Security clearance granted
   - **Notification**: Email confirmation of account unlock
   - **Monitoring**: Enhanced security monitoring for 30 days

#### Multi-Device Session Conflicts
```
Concurrent Login Alert → Session Conflict Modal → Device Selection → Primary Session → Logout Others
```

**Detailed Steps:**
1. **Conflict Detection**:
    - **Trigger**: Second simultaneous login detected
    - **UI**: Modal overlay on both sessions
    - **Options**: "Continue Here" or "Logout Other Device"

2. **Session Management**:
    - **Selection**: User chooses primary device
    - **Invalidation**: Other session tokens revoked
    - **Persistence**: Primary session continues uninterrupted

3. **Future Enhancements (Q2 2026)**:
    - **Device Tracking**: Fingerprint devices for security monitoring
    - **Geographic Alerts**: Notify of logins from unusual locations
    - **Session Limits**: Configurable maximum concurrent sessions
    - **Device Management**: Allow users to view/manage trusted devices

4. **Security Logging**:
    - **Audit**: All device information logged
    - **Alert**: Unusual multi-device activity flagged
    - **Policy**: Configurable concurrent session limits (roadmap feature)

### Advanced Edge Cases

#### Enterprise SSO Integration
```
SSO Provider Login → SAML/OAuth Flow → User Provisioning → Company Association → Dashboard
```

**Detailed Steps:**
1. **SSO Initiation**:
   - **Page**: Enterprise login page (`/enterprise-login`)
   - **Elements**: "Login with SSO" button + provider selection
   - **Integration**: SAML/OAuth handshake with identity provider

2. **User Provisioning**:
   - **Validation**: User exists in external system
   - **Mapping**: External user ID mapped to PenguinMails account
   - **Attributes**: Role and company association from SSO claims

3. **Access Control**:
   - **RBAC**: Enterprise roles translated to platform permissions
   - **Company**: Automatic association with enterprise tenant
   - **Compliance**: Audit logging of all SSO events

#### API Token Authentication (Roadmap: Q2 2026)
```
API Key Generation → Token Storage → Request Authentication → Rate Limiting → Access Logging
```

**Detailed Steps:**
1. **Token Creation**:
    - **Page**: Developer settings (`/settings/api`)
    - **Elements**: "Generate API Key" button + permissions selector
    - **Security**: Key displayed once + secure storage required

2. **API Usage**:
    - **Headers**: `Authorization: Bearer <token>` in requests
    - **Validation**: Token authenticity + permissions check
    - **Rate Limiting**: Per-token limits with burst allowances

3. **Future Enhancements (Q2 2026)**:
    - **MFA for API**: Optional 2FA requirement for API key generation
    - **Audit Logging**: Comprehensive API usage tracking
    - **Geographic Restrictions**: IP-based access controls
    - **Token Rotation**: Automated key rotation policies

4. **Monitoring**:
    - **Logging**: All API calls audited (roadmap)
    - **Metrics**: Usage statistics per token
    - **Alerts**: Unusual activity detection

## Technical Implementation Links

- **[Onboarding & Authentication Guide](onboarding_and_authentication_guide.md)** - Complete technical authentication flow with NileDB + Turnstile + Stripe Connect
- **[Database Schema Guide](database_schema_guide.md)** - Multi-tenant authentication tables and RLS policies
- **[Security Documentation](security_documentation.md)** - Security practices and compliance procedures