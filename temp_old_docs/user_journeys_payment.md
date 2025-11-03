# Payment Payment & Billing Journey

> **Journey Flow:** `Stripe Connect Setup → Payment Method → Subscription Activation → Billing Dashboard`

## Normal Payment Flow

### Onboarding Payment Setup
**Journey Flow:** `Onboarding Modal → Stripe Connect → Business Verification → Payment Method → Subscription Activation`

#### 1. Onboarding Trigger (`/onboarding` - Step 3)
- **Context**: User reaches payment setup in onboarding flow
- **Modal Elements**:
  - "Connect Payment Method" section header
  - Stripe Connect integration button
  - Business verification requirements notice
  - Platform fee explanation ($100 → $77 model)
- **User Action**: Clicking "Setup Payments" button

#### 2. Stripe Connect Express Setup
- **Page**: Stripe-hosted onboarding flow (external redirect)
- **Business Verification**:
  - Company legal name and tax ID
  - Business address and phone
  - Bank account or debit card details
  - Identity verification (SSN/EIN)
- **Integration**: OAuth connection back to PenguinMails

#### 3. Payment Method Addition
- **Page**: Billing settings (`/billing/payment-methods`)
- **Form Elements**:
  - "Add Payment Method" button
  - Stripe Elements credit card form
  - Billing address collection
  - "Set as Default" checkbox
- **Security**: PCI-compliant card tokenization

#### 4. Subscription Activation
- **Page**: Plan selection (`/billing/plans`)
- **Plan Options**: Freemium → Professional → Enterprise tiers
- **Features**:
  - IP allocation limits
  - Monthly email volume
  - Team member seats
  - Premium support
- **Activation**: Immediate access after payment confirmation

#### 5. Billing Dashboard Access
- **Page**: Main billing overview (`/billing`)
- **Dashboard Elements**:
  - Current plan and usage metrics
  - Next billing date and amount
  - Payment history table
  - Invoice download links
  - Plan upgrade/downgrade options

---

### Ongoing Billing Management
**Journey Flow:** `Billing Dashboard → Usage Monitoring → Payment Updates → Plan Changes → Invoice Handling`

#### 1. Usage Tracking & Alerts
- **Dashboard Widgets**:
  - Email volume progress bars
  - IP reputation scores
  - Team member utilization
  - Monthly spending vs. budget
- **Alert System**: 80% usage threshold notifications

#### 2. Payment Method Management
- **Page**: Payment methods settings (`/billing/payment-methods`)
- **Actions**:
  - Add/remove payment methods
  - Update billing addresses
  - Set default payment method
  - Failed payment retry attempts

#### 3. Invoice & Receipt Access
- **Page**: Billing history (`/billing/history`)
- **Features**:
  - PDF invoice downloads
  - Detailed line items
  - Tax calculations
  - Payment status indicators
  - Email delivery confirmations

### Edge Cases & Recovery

#### Failed Payment Handling
```
Invoice Generated → Payment Due → Failed Attempt → Retry Logic → Grace Period → Account Actions
```

**Detailed Process:**
1. **Payment Failure Detection**:
   - **Trigger**: Stripe webhook for failed payment
   - **Notification**: Email to billing contact + dashboard alert
   - **Grace Period**: 7 days before account impact

2. **Automatic Retry Attempts**:
   - **Schedule**: Days 1, 3, 5 after failure
   - **Methods**: Try all saved payment methods
   - **Communication**: Email updates for each attempt

3. **Account Suspension Flow**:
   - **Warning Phase**: Feature restrictions (campaign limits)
   - **Suspension**: Complete access block after grace period
   - **Recovery Page**: Dedicated payment recovery portal

4. **Payment Recovery**:
   - **Page**: Account recovery (`/billing/recovery`)
   - **Options**: Update payment method, dispute resolution, support contact
   - **Restoration**: Immediate access after successful payment

#### Plan Changes & Proration
```
Current Plan → Change Request → Confirmation → Prorated Billing → Feature Updates → New Cycle
```

**Upgrade Process:**
1. **Plan Selection**:
   - **Page**: Billing plans (`/billing/plans`)
   - **Comparison**: Feature matrix with current vs. new plan
   - **Cost Preview**: Prorated amount calculation

2. **Confirmation & Payment**:
   - **Modal**: Change confirmation with cost breakdown
   - **Immediate**: Feature access granted upon payment
   - **Billing**: Prorated charges applied to current cycle

**Downgrade Process:**
1. **Impact Assessment**:
   - **Warnings**: Feature loss notifications
   - **Grace Period**: 30 days for usage reduction
   - **Data Export**: Option to download campaign data

2. **Scheduled Changes**:
   - **Timing**: Applied at next billing cycle
   - **Partial Refund**: Unused time credited
   - **Notifications**: Countdown emails before change

#### Chargeback & Dispute Management
```
Charge Filed → Stripe Notification → Evidence Collection → Response Submission → Resolution
```

**Detailed Process:**
1. **Dispute Detection**:
   - **Webhook**: Stripe dispute.created event
   - **Notification**: Urgent email to account owner
   - **Dashboard**: Dispute status indicator

2. **Evidence Collection**:
   - **Portal**: Dispute management page (`/billing/disputes`)
   - **Required Documents**: Service agreements, email records, timestamps
   - **Time Limit**: 7 days to respond

3. **Resolution Process**:
   - **Submission**: Evidence uploaded to Stripe
   - **Outcome**: Won/Lost notification
   - **Account Impact**: Feature restrictions if disputed frequently

### Initial Setup Scenarios

#### First-Time Stripe Connect Setup
```
Onboarding Flow → Stripe OAuth → Business Info → Bank Details → Verification → Success
```

**Detailed Steps:**
1. **Onboarding Context**:
   - **Trigger**: User reaches Step 3 of onboarding
   - **Education**: Modal explaining B2B payment model and fees
   - **CTA**: "Connect Stripe Account" button

2. **Stripe Hosted Flow**:
   - **Redirect**: User sent to Stripe's secure onboarding
   - **Business Info**: Legal name, address, tax ID collection
   - **Banking**: Bank account or debit card setup
   - **Verification**: Identity verification process

3. **Return & Activation**:
   - **Redirect**: Back to PenguinMails with success token
   - **Validation**: Account verification status checked
   - **Feature Unlock**: Billing features activated

#### Payment Method Addition
```
Billing Settings → Add Method → Card Form → 3DS Verification → Confirmation → Default Set
```

**Detailed Steps:**
1. **Access Point**:
   - **Page**: Billing dashboard (`/billing`)
   - **Element**: "Add Payment Method" button or empty state prompt

2. **Card Collection**:
   - **Form**: Stripe Elements secure card input
   - **Validation**: Real-time card number/format checking
   - **Address**: Billing address collection (AVS compliance)

3. **Verification**:
   - **3D Secure**: Additional authentication when required
   - **Micro-deposits**: Alternative verification for bank accounts
   - **Confirmation**: Success message and method listing

---

### Emergency Scenarios

#### Stripe Service Outage
```
Payment Processing Down → Graceful Degradation → Alternative Handling → Service Restoration
```

**System Response:**
1. **Detection**: Stripe API monitoring alerts
2. **User Communication**: Dashboard banner + email notifications
3. **Graceful Handling**: Queue payments for retry, disable new subscriptions
4. **Alternative Options**: Manual invoice generation, delayed billing

#### Revenue Share Disputes
```
Fee Calculation Error → Investigation → Evidence Review → Adjustment → Reconciliation
```

**Resolution Process:**
1. **Detection**: User reports incorrect fees or calculations
2. **Investigation**: Transaction log review, Stripe Connect reconciliation
3. **Evidence**: Platform usage data, fee structure documentation
4. **Resolution**: Fee adjustment, refund processing, account reconciliation

---

## Common Payment & Billing Issues & Troubleshooting

### "Why was my payment declined?"

**Possible Causes & Solutions:**

1. **Insufficient Funds**
   - **Symptom**: "Payment declined" with bank error code
   - **Solution**: Check account balance, add alternative payment method
   - **Prevention**: Set up payment failure notifications

2. **Card Expired or Invalid**
   - **Symptom**: "Card expired" or "Invalid card number"
   - **Solution**: Update card details in billing settings
   - **Prevention**: Update cards before expiration

3. **Security Block**
   - **Symptom**: Bank fraud protection triggered
   - **Solution**: Contact bank to whitelist PenguinMails, try different card
   - **Prevention**: Use business cards for business subscriptions

4. **International Restrictions**
   - **Symptom**: "Card not accepted in this region"
   - **Solution**: Use local payment method or contact Stripe support
   - **Prevention**: Check card issuer international policies

### "Why am I being charged the wrong amount?"

**Possible Causes & Solutions:**

1. **Prorated Billing**
   - **Symptom**: Unexpected partial charges on plan changes
   - **Solution**: Check billing history for upgrade/downgrade details
   - **Explanation**: Proration calculates unused time credit

2. **Usage Overages**
   - **Symptom**: Extra charges beyond base plan
   - **Solution**: Review usage metrics in billing dashboard
   - **Prevention**: Monitor usage alerts and plan limits

3. **Currency Conversion**
   - **Symptom**: Charges in unexpected currency
   - **Solution**: Update billing country in account settings
   - **Prevention**: Set correct billing address during setup

4. **Tax Calculation Errors**
   - **Symptom**: Incorrect tax amounts
   - **Solution**: Update tax information in billing settings
   - **Prevention**: Complete tax forms during Stripe Connect setup

### "Why can't I change my payment method?"

**Possible Causes & Solutions:**

1. **Account Verification Pending**
   - **Symptom**: Payment method changes disabled
   - **Solution**: Complete Stripe Connect business verification
   - **Status**: Check verification status in billing dashboard

2. **Outstanding Balance**
   - **Symptom**: "Clear outstanding balance first"
   - **Solution**: Pay any overdue invoices before changing methods
   - **Prevention**: Keep payment methods current

3. **Failed Payment Retry**
   - **Symptom**: Changes blocked during retry period
   - **Solution**: Wait for retry attempts to complete or update existing method
   - **Prevention**: Keep valid payment methods on file

### "Why was my account suspended?"

**Possible Causes & Solutions:**

1. **Payment Failures**
   - **Symptom**: Account limited after multiple failed payments
   - **Solution**: Update payment method and clear outstanding balance
   - **Timeline**: Grace period before permanent suspension

2. **Plan Overage**
   - **Symptom**: Usage exceeds plan limits significantly
   - **Solution**: Upgrade plan or reduce usage within grace period
   - **Prevention**: Monitor usage thresholds

3. **Policy Violations**
   - **Symptom**: Account flagged for Terms of Service violations
   - **Solution**: Contact support for appeal process
   - **Review**: Manual review may take 24-48 hours

## Technical Implementation Links

- **[Stripe Onboarding Guide](stripe_onboarding_guide.md)** - Complete Stripe Connect integration and billing setup