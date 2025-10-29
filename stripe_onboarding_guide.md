---
last_modified_date: "2025-10-27"
---

# Stripe Onboarding and Billing Integration Guide

## Overview

This guide describes the complete Stripe Connect onboarding and billing integration for PenguinMails. The system follows an OLTP-first architecture with NileDB for secure financial data storage and Stripe for payment processing.

## User Flow Architecture

### 1. User Signup and Authentication

**Entry Point**: `/signup`
- User signs up using NileDB authentication
- Creates tenant user account automatically
- Redirects to dashboard on successful signup

**Key Components**:
- `app/signup/` - Signup pages
- `lib/niledb/auth.ts` - NileDB authentication utilities
- `components/auth/` - Authentication components

### 2. Dashboard Entry

**Entry Point**: `/dashboard`
- User lands in main dashboard after signup
- Same user account available in admin panel as tenant user
- Sidebar includes "Setup Guide" link to onboarding

**Key Components**:
- `components/layout/DashboardSidebar.tsx` - Navigation with onboarding link
- `app/dashboard/` - Dashboard pages

### 3. Onboarding Experience

**Entry Point**: `/dashboard/onboarding`
- Multi-step onboarding flow for new users
- Includes billing setup as one of the steps
- Uses context-based state management

**Current Structure**:
```typescript
interface OnboardingStep {
  id: number;
  title: string;
  subtitle: string;
  explanation: string;
  icon: LucideIcon;
  color: string;
  href: string;
  buttonText: string;
  kbLink: string;
  videoId: string;
  completed: boolean;
  promotion?: {
    title: string;
    description: string;
    link: string;
  };
}
```

**Key Components**:
- `context/onboarding-context.tsx` - Onboarding state management
- `components/onboarding/` - Onboarding UI components
- `old/app/dashboard/onboarding/page.tsx` - Onboarding page

### 4. Stripe Connect Setup Step

**New Onboarding Step**: "Connect Payment Processor"

This step should be added to the onboarding flow with the following characteristics:

```typescript
const stripeConnectStep: OnboardingStep = {
  id: 4, // Adjust numbering as needed
  title: "Connect Stripe",
  subtitle: "Set up payments and billing",
  explanation: "Connect your Stripe account to start accepting payments and manage subscriptions. This allows you to bill customers and track revenue.",
  icon: CreditCard, // or DollarSign
  color: "blue",
  href: "/dashboard/onboarding",
  buttonText: "Connect Stripe",
  kbLink: "/docs/stripe-setup",
  videoId: "stripe-connect-tutorial",
  completed: false,
  promotion: {
    title: "Why Stripe Connect?",
    description: "Secure payment processing with enterprise-grade security",
    link: "https://stripe.com/connect"
  }
};
```

**Implementation Requirements**:

1. **Stripe Connect Express Account Creation**
2. **Onboarding Link Generation**
3. **Status Checking**
4. **Skip/Complete Later Option**

## Stripe Connect Integration

### 1. Account Creation Flow

```typescript
// API Endpoint: POST /api/stripe/connect
export async function createStripeConnectAccount(companyId: string, billingEmail?: string) {
  try {
    // 1. Check if account already exists in tenant_config
    const existingAccount = await nile.db.query(
      `SELECT stripe_account_id FROM tenant_config
       WHERE tenant_id = CURRENT_TENANT_ID()`,
      []
    );

    if (existingAccount.rows.length > 0 && existingAccount.rows[0].stripe_account_id) {
      return { accountId: existingAccount.rows[0].stripe_account_id };
    }

    // 2. Create Stripe Connect Express account
    const account = await stripe.accounts.create({
      type: 'express',
      country: 'US', // Default, should be configurable
      email: billingEmail,
      capabilities: {
        card_payments: { requested: true },
        transfers: { requested: true },
      },
    });

    // 3. Store in tenant_config (minimal state)
    await nile.db.query(
      `UPDATE tenant_config SET stripe_account_id = $1, updated_at = CURRENT_TIMESTAMP
       WHERE tenant_id = CURRENT_TENANT_ID()`,
      [account.id]
    );

    return { accountId: account.id };
  } catch (error) {
    console.error('Failed to create Stripe Connect account:', error);
    throw error;
  }
}
```

### 2. Onboarding Link Generation

```typescript
// API Endpoint: GET /api/stripe/connect/onboarding-link
export async function getStripeOnboardingLink(accountId: string) {
  try {
    const accountLink = await stripe.accountLinks.create({
      account: accountId,
      refresh_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/settings/billing`,
      return_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/settings/billing`,
      type: 'account_onboarding',
    });

    return { url: accountLink.url };
  } catch (error) {
    console.error('Failed to create onboarding link:', error);
    throw error;
  }
}
```

### 3. Database Schema

**Minimal Schema Changes**: Add to existing `tenant_config` table

```sql
-- Add to existing tenant_config table
ALTER TABLE tenant_config ADD COLUMN stripe_account_id VARCHAR(255) UNIQUE;

-- Existing tables cover all other billing needs:
-- - subscriptions: subscription management
-- - payments: payment history and billing
-- - plans: plan definitions and limits
-- - subscription_addons: additional features
-- - Usage calculated at runtime from campaigns, emails, companies tables
```

## Settings/Billing Integration

### 1. Billing Settings Page

**Entry Point**: `/dashboard/settings/billing`

**Current Implementation**: `components/settings/billing/BillingSettings.tsx`

The current implementation shows plan information and links to Stripe portal/checkout. It needs enhancement to:

1. Check Stripe Connect status
2. Show appropriate UI based on connection state
3. Display alerts for incomplete setup
4. Provide direct link to Stripe onboarding

### 2. Status Checking Logic

```typescript
// API Endpoint: GET /api/stripe/connect/status
export async function getStripeConnectStatus() {
  try {
    // Get stored account info from tenant_config
    const accountInfo = await nile.db.query(
      `SELECT stripe_account_id FROM tenant_config
       WHERE tenant_id = CURRENT_TENANT_ID()`,
      []
    );

    if (!accountInfo.rows.length || !accountInfo.rows[0].stripe_account_id) {
      return { connected: false, status: 'not_connected' };
    }

    const stripeAccountId = accountInfo.rows[0].stripe_account_id;

    // Fetch latest status from Stripe (no local storage of status)
    const stripeAccount = await stripe.accounts.retrieve(stripeAccountId);

    return {
      connected: true,
      status: stripeAccount.details_submitted ? 'complete' : 'pending',
      chargesEnabled: stripeAccount.charges_enabled,
      payoutsEnabled: stripeAccount.payouts_enabled,
      requirements: stripeAccount.requirements,
    };
  } catch (error) {
    console.error('Failed to get Stripe Connect status:', error);
    throw error;
  }
}
```

### 3. UI State Management

```typescript
type StripeStatus = 'not_connected' | 'pending' | 'complete' | 'error';

interface BillingSettingsState {
  stripeStatus: StripeStatus;
  canAcceptPayments: boolean;
  onboardingUrl?: string;
  requirements?: Stripe.Account.Requirements;
}

// Alert component for incomplete setup
function StripeConnectionAlert({ status, onConnect }: {
  status: StripeStatus;
  onConnect: () => void;
}) {
  if (status === 'complete') return null;

  return (
    <Alert className="border-yellow-200 bg-yellow-50">
      <AlertTriangle className="h-4 w-4" />
      <AlertTitle>Stripe Setup Required</AlertTitle>
      <AlertDescription className="mt-2">
        {status === 'not_connected'
          ? "Connect your Stripe account to start accepting payments."
          : "Complete your Stripe account setup to enable payments."
        }
        <Button
          variant="link"
          className="p-0 h-auto ml-2"
          onClick={onConnect}
        >
          {status === 'not_connected' ? 'Connect Now' : 'Complete Setup'}
        </Button>
      </AlertDescription>
    </Alert>
  );
}
```

## Webhook Integration

### 1. Webhook Endpoint

**Endpoint**: `POST /api/webhooks/stripe`

```typescript
// app/api/webhooks/stripe/route.ts
import { headers } from 'next/headers';
import { NextRequest, NextResponse } from 'next/server';
import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!);
const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET!;

export async function POST(request: NextRequest) {
  try {
    const body = await request.text();
    const sig = headers().get('stripe-signature')!;

    let event: Stripe.Event;

    try {
      event = stripe.webhooks.constructEvent(body, sig, endpointSecret);
    } catch (err) {
      console.error('Webhook signature verification failed:', err);
      return NextResponse.json({ error: 'Invalid signature' }, { status: 400 });
    }

    // Handle different event types
    switch (event.type) {
      case 'account.updated':
        await handleAccountUpdated(event.data.object as Stripe.Account);
        break;

      case 'capability.updated':
        await handleCapabilityUpdated(event.data.object as Stripe.Capability);
        break;

      // Add more event handlers as needed

      default:
        console.log(`Unhandled event type: ${event.type}`);
    }

    return NextResponse.json({ received: true });
  } catch (error) {
    console.error('Webhook processing error:', error);
    return NextResponse.json({ error: 'Internal error' }, { status: 500 });
  }
}
```

### 2. Event Handlers

```typescript
async function handleAccountUpdated(account: Stripe.Account) {
  try {
    // Log account updates (no local status storage needed)
    console.log(`Stripe account ${account.id} updated:`, {
      details_submitted: account.details_submitted,
      charges_enabled: account.charges_enabled,
      payouts_enabled: account.payouts_enabled,
      requirements: account.requirements
    });

    // Status checks will fetch live data from Stripe when needed
  } catch (error) {
    console.error('Failed to process account update:', error);
    throw error;
  }
}

async function handleCapabilityUpdated(capability: Stripe.Capability) {
  try {
    // Log capability changes (live status checked via API calls)
    console.log(`Capability updated for account ${capability.account}:`, {
      capability: capability.id,
      status: capability.status
    });

    // No local storage - status verified through live Stripe API calls
  } catch (error) {
    console.error('Failed to process capability update:', error);
    throw error;
  }
}
```

## Trial Periods and Promotional Credits

### Trial Period Implementation

**Trial periods** - Use subscription status (no extra fields):

```sql
-- Extend subscription status enum to include trial
-- Status values: 'active', 'past_due', 'canceled', 'unpaid', 'trial'
```

- **Trial plans** in `plans` table with `price_monthly = 0`
- **Trial status** tracked via `subscriptions.status = 'trial'`
- **Trial duration** calculated from `current_period_start/end`
- **No additional fields needed** - reuse existing subscription period tracking

### Promotional Credits Implementation

**Promotional credits** - Simplified promo table:

```sql
-- Promotional codes table
CREATE TABLE promo_codes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(50) UNIQUE NOT NULL,
    discount_type VARCHAR(20) NOT NULL, -- 'percentage' or 'fixed_amount'
    discount_value DECIMAL(10,2) NOT NULL, -- Percentage (0-100) or USD amount
    max_uses INTEGER, -- NULL = unlimited
    used_count INTEGER DEFAULT 0,
    valid_from TIMESTAMP,
    expires_at TIMESTAMP,
    applicable_plans TEXT[], -- Array of plan slugs, NULL = all plans
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (discount_type IN ('percentage', 'fixed_amount')),
    CHECK (discount_value > 0)
);
```

**Promo application tracking**:
- Apply promos during subscription creation/updates
- Track usage in `promo_codes.used_count`
- Store applied promo in `subscriptions` or `payments` if needed for history

## Payment Processing Logic

### 1. Payment Intent Creation with Platform Fees

```typescript
// Before Stripe payment requests:
// Verify Stripe account exists and is capable
export async function verifyStripeAccount() {
  const status = await getStripeConnectStatus();
  if (!status.connected || !status.chargesEnabled) {
    throw new Error('Stripe account not connected or not capable of processing payments');
  }
  return status;
}

// Calculate platform fees for revenue sharing
export async function calculatePlatformFees(amount: number, planType: string) {
  // Platform fee logic based on plan and amount
  const platformFeePercent = 0.05; // 5% platform fee
  const platformFee = Math.round(amount * platformFeePercent);
  return {
    amount,
    platformFee,
    connectedAccountReceives: amount - platformFee
  };
}

// Create payment intent with platform fees
export async function createPaymentIntentWithFees(
  amount: number,
  planType: string,
  customerId: string
) {
  // 1. Verify account capability
  const accountStatus = await verifyStripeAccount();

  // 2. Calculate fees
  const feeCalculation = await calculatePlatformFees(amount, planType);

  // 3. Get connected account ID
  const accountInfo = await nile.db.query(
    `SELECT stripe_account_id FROM tenant_config WHERE tenant_id = CURRENT_TENANT_ID()`,
    []
  );

  if (!accountInfo.rows[0]?.stripe_account_id) {
    throw new Error('No connected Stripe account found');
  }

  // 4. Create payment intent with application fee
  const paymentIntent = await stripe.paymentIntents.create({
    amount: feeCalculation.amount,
    currency: 'usd',
    customer: customerId,
    application_fee_amount: feeCalculation.platformFee,
    transfer_data: {
      destination: accountInfo.rows[0].stripe_account_id,
    },
  });

  return {
    paymentIntent,
    feeBreakdown: feeCalculation
  };
}
```

### 2. Usage Calculation Logic

```typescript
// lib/actions/billing/usage.ts
export async function calculateCurrentUsage(companyId: string) {
  // Current period usage against plans limits
  const currentPeriod = await nile.db.query(`
    SELECT
      COUNT(c.id) as campaigns_count,
      SUM(c.emails_sent) as total_emails_sent,
      COUNT(DISTINCT c.target_audience_id) as audiences_used
    FROM campaigns c
    WHERE c.company_id = $1
      AND c.created_at >= date_trunc('month', CURRENT_DATE)
      AND c.tenant_id = CURRENT_TENANT_ID()
  `, [companyId]);

  return {
    campaigns: currentPeriod.rows[0].campaigns_count,
    emailsSent: currentPeriod.rows[0].total_emails_sent,
    audiencesUsed: currentPeriod.rows[0].audiences_used
  };
}

export async function calculateProjectedCosts(companyId: string, currentUsage: any) {
  // Get current plan limits and pricing
  const planInfo = await nile.db.query(`
    SELECT p.* FROM plans p
    JOIN subscriptions s ON s.plan_id = p.id
    WHERE s.company_id = $1 AND s.status = 'active'
    AND s.tenant_id = CURRENT_TENANT_ID()
  `, [companyId]);

  if (!planInfo.rows.length) return null;

  const plan = planInfo.rows[0];
  const projectedUsage = { ...currentUsage };

  // Estimate remaining usage for month
  const daysInMonth = new Date(new Date().getFullYear(), new Date().getMonth() + 1, 0).getDate();
  const daysPassed = new Date().getDate();
  const remainingDaysRatio = (daysInMonth - daysPassed) / daysInMonth;

  // Calculate projected costs
  const additionalEmails = Math.max(0, (projectedUsage.emailsSent / daysPassed * daysInMonth) - plan.emails_limit);
  const additionalCampaigns = Math.max(0, (projectedUsage.campaigns / daysPassed * daysInMonth) - plan.campaigns_limit);

  return {
    projectedOverage: {
      emails: additionalEmails,
      campaigns: additionalCampaigns
    },
    estimatedCost: (additionalEmails * plan.overage_email_rate) + (additionalCampaigns * plan.overage_campaign_rate)
  };
}
```

## Frontend Integration

### 1. Onboarding Step Component

```typescript
// components/onboarding/steps/StripeConnectStep.tsx
"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { useOnboarding } from "@/context/onboarding-context";
import { CreditCard, ExternalLink, CheckCircle } from "lucide-react";

export function StripeConnectStep() {
  const { completeStep } = useOnboarding();
  const [isConnecting, setIsConnecting] = useState(false);
  const [isConnected, setIsConnected] = useState(false);

  const handleConnectStripe = async () => {
    setIsConnecting(true);
    try {
      const response = await fetch('/api/stripe/connect/onboarding-link', {
        method: 'GET',
      });

      const { url } = await response.json();

      // Open Stripe onboarding in new tab
      window.open(url, '_blank');

      // Mark as completed (user can finish later)
      completeStep(4); // Adjust step ID
      setIsConnected(true);
    } catch (error) {
      console.error('Failed to connect Stripe:', error);
    } finally {
      setIsConnecting(false);
    }
  };

  return (
    <Card>
      <CardHeader>
        <CardTitle className="flex items-center gap-2">
          <CreditCard className="h-5 w-5" />
          Connect Payment Processor
        </CardTitle>
        <CardDescription>
          Set up Stripe to accept payments and manage subscriptions
        </CardDescription>
      </CardHeader>
      <CardContent className="space-y-4">
        <p className="text-sm text-muted-foreground">
          Connect your Stripe account to start accepting payments from customers.
          This process is secure and handled entirely by Stripe.
        </p>

        {isConnected ? (
          <div className="flex items-center gap-2 text-green-600">
            <CheckCircle className="h-4 w-4" />
            <span className="text-sm">Stripe connection initiated</span>
          </div>
        ) : (
          <Button
            onClick={handleConnectStripe}
            disabled={isConnecting}
            className="w-full"
          >
            {isConnecting ? (
              "Connecting..."
            ) : (
              <>
                <ExternalLink className="mr-2 h-4 w-4" />
                Connect Stripe Account
              </>
            )}
          </Button>
        )}

        <p className="text-xs text-muted-foreground">
          You can complete this setup later in Settings → Billing
        </p>
      </CardContent>
    </Card>
  );
}
```

### 2. Billing Settings Enhancement

```typescript
// Enhanced BillingSettings.tsx with Stripe Connect status
"use client";

import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert";
import { AlertTriangle, ExternalLink, CheckCircle } from "lucide-react";
import { config } from "@/lib/config";

interface StripeStatus {
  connected: boolean;
  status: 'not_connected' | 'pending' | 'complete' | 'error';
  canAcceptPayments: boolean;
  onboardingUrl?: string;
}

export function StripeConnectSection() {
  const [stripeStatus, setStripeStatus] = useState<StripeStatus | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStripeStatus();
  }, []);

  const fetchStripeStatus = async () => {
    try {
      const response = await fetch('/api/stripe/connect/status');
      const status = await response.json();
      setStripeStatus(status);
    } catch (error) {
      console.error('Failed to fetch Stripe status:', error);
      setStripeStatus({ connected: false, status: 'error', canAcceptPayments: false });
    } finally {
      setLoading(false);
    }
  };

  const handleConnectStripe = async () => {
    try {
      const response = await fetch('/api/stripe/connect/onboarding-link');
      const { url } = await response.json();
      window.open(url, '_blank');
      // Refresh status after some delay
      setTimeout(fetchStripeStatus, 3000);
    } catch (error) {
      console.error('Failed to get onboarding link:', error);
    }
  };

  if (loading) {
    return <div className="animate-pulse h-20 bg-gray-100 rounded"></div>;
  }

  if (!stripeStatus?.connected) {
    return (
      <Alert className="border-yellow-200 bg-yellow-50">
        <AlertTriangle className="h-4 w-4" />
        <AlertTitle>Stripe Setup Required</AlertTitle>
        <AlertDescription className="mt-2">
          Connect your Stripe account to start accepting payments.
          <Button
            variant="link"
            className="p-0 h-auto ml-2"
            onClick={handleConnectStripe}
          >
            Connect Now
          </Button>
        </AlertDescription>
      </Alert>
    );
  }

  if (stripeStatus.status === 'pending') {
    return (
      <Alert className="border-blue-200 bg-blue-50">
        <AlertTriangle className="h-4 w-4" />
        <AlertTitle>Complete Stripe Setup</AlertTitle>
        <AlertDescription className="mt-2">
          Your Stripe account setup is in progress. Please complete the onboarding process.
          <Button
            variant="link"
            className="p-0 h-auto ml-2"
            onClick={handleConnectStripe}
          >
            Complete Setup
          </Button>
        </AlertDescription>
      </Alert>
    );
  }

  return (
    <div className="flex items-center gap-2 text-green-600">
      <CheckCircle className="h-4 w-4" />
      <span className="text-sm">Stripe Connected</span>
      <Button
        variant="link"
        size="sm"
        onClick={() => window.open(config.stripe.portalUrl, '_blank')}
      >
        <ExternalLink className="h-3 w-3 mr-1" />
        Manage
      </Button>
    </div>
  );
}
```

## Configuration

### Environment Variables

```bash
# .env.local
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_WEBHOOK_SECRET=whsec_...
NEXT_PUBLIC_STRIPE_PORTAL_URL=https://billing.stripe.com/p/login/test_...
NEXT_PUBLIC_STRIPE_CHECKOUT_URL=https://checkout.stripe.com/pay/test_...
```

### Stripe Dashboard Setup

1. **Create Connect Application**
2. **Configure Webhook Endpoints**
3. **Set up Portal Configuration**
4. **Enable Required Capabilities**

## Implementation Order

### Phase 1: Basic Connect Setup
1. ✅ **Schema**: Add `stripe_account_id` to `tenant_config` table
2. ⏳ **Connect API**: Account creation and onboarding links (`/api/stripe/connect`, `/api/stripe/connect/onboarding-link`)
3. ⏳ **Status Endpoint**: Live verification function (`/api/stripe/connect/status`)
4. ⏳ **Webhooks**: Event processing for account/capability updates (`/api/webhooks/stripe`)
5. ⏳ **UI Integration**: Settings and onboarding components

### Phase 2: Enhanced Features
1. ⏳ **Payment Logic**: Platform fee calculation and payment processing
2. ⏳ **Usage Calculation**: Runtime usage tracking from existing tables
3. ⏳ **Error Handling**: Retry logic and user feedback
4. ⏳ **Testing**: Integration and webhook testing

### Phase 3: Advanced Features
1. ⏳ Multi-party payments
2. ⏳ Subscription management
3. ⏳ Invoice generation
4. ⏳ Analytics integration

## Testing

### Webhook Testing
```bash
# Use Stripe CLI for webhook testing
stripe listen --forward-to localhost:3000/api/webhooks/stripe

# Send test events
stripe trigger account.updated
stripe trigger capability.updated
```

### Integration Testing
```typescript
// Test account creation
const account = await createStripeConnectAccount(companyId);
expect(account.accountId).toBeDefined();

// Test onboarding link
const link = await getStripeOnboardingLink(account.accountId);
expect(link.url).toContain('stripe.com');

// Test status checking
const status = await getStripeConnectStatus();
expect(status.connected).toBe(true);
```

## Security Considerations

1. **Webhook Verification**: Always verify Stripe webhook signatures
2. **Tenant Isolation**: Ensure proper RLS policies on all Stripe-related tables
3. **Rate Limiting**: Implement rate limiting on webhook endpoints
4. **Error Handling**: Never expose internal errors through API responses
5. **Audit Logging**: Log all Stripe-related operations for compliance

## Monitoring and Alerting

### Key Metrics
- Stripe account creation success rate
- Onboarding completion rate
- Webhook processing success rate
- Payment capability status

### Alerts
- Webhook failures
- Account onboarding stalls
- Capability disablement
- High error rates

## Testing

### Webhook Testing
```bash
# Use Stripe CLI for webhook testing
stripe listen --forward-to localhost:3000/api/webhooks/stripe

# Send test events
stripe trigger account.updated
stripe trigger capability.updated
```

### Integration Testing
```typescript
// Test account creation
const account = await createStripeConnectAccount(companyId);
expect(account.accountId).toBeDefined();

// Test onboarding link
const link = await getStripeOnboardingLink(account.accountId);
expect(link.url).toContain('stripe.com');

// Test status checking
const status = await getStripeConnectStatus(companyId);
expect(status.connected).toBe(true);
```

## Related Documents

- [Database Schema Guide](database_schema_guide.md) - Database structure and relationships
- [Analytics Architecture](analytics_architecture.md) - Payment analytics implementation
- [Security Documentation](security_documentation.md) - Authentication and security procedures
- [Infrastructure Documentation](infrastructure_documentation.md) - System deployment and operations

## Business Implications & Features

### Business Benefits

**Revenue Model Enhancement**:
- **Platform Fees**: Automatic revenue sharing through Stripe Connect (configurable percentage or fixed fees)
- **Subscription Management**: Full lifecycle management with trials, upgrades, downgrades
- **Payment Processing**: Enterprise-grade security and compliance via Stripe
- **Global Payments**: Support for international customers and multiple currencies

**Customer Experience**:
- **Seamless Onboarding**: Integrated billing setup in user onboarding flow
- **Flexible Trials**: Trial plans as first-class citizens with automatic conversion
- **Promotional System**: Percentage and fixed-amount discounts for marketing campaigns
- **Usage Tracking**: Real-time usage monitoring against plan limits

**Operational Benefits**:
- **Automated Billing**: No manual invoice processing or payment chasing
- **Financial Visibility**: Complete transaction history through Stripe Dashboard
- **Risk Management**: Stripe handles fraud prevention and dispute resolution
- **Compliance**: PCI DSS compliance and financial data security

### Business Features

**Subscription Management**:
- **Trial Periods**: 14-day trials with automatic conversion to paid plans
- **Plan Flexibility**: Monthly/yearly billing with mid-cycle upgrades
- **Promotional Codes**: Marketing discounts and referral incentives
- **Usage Monitoring**: Real-time alerts for approaching limits

**Billing Operations**:
- **Invoice Generation**: Automatic invoice creation and email delivery
- **Payment Methods**: Secure tokenized storage with Stripe
- **Failed Payment Recovery**: Automatic retry logic with grace periods
- **Refunds & Disputes**: Complete dispute management through Stripe

**Financial Reporting**:
- **Revenue Analytics**: Real-time revenue tracking and forecasting
- **Customer Metrics**: Churn analysis and lifetime value calculations
- **Platform Fees**: Automated revenue sharing calculations
- **Tax Compliance**: Automatic tax calculation and reporting

## Technical Implications & Features

### Technical Architecture

**Database Schema (Minimal Changes)**:
```sql
-- Extend existing tables only
ALTER TABLE tenant_config ADD COLUMN stripe_account_id VARCHAR(255) UNIQUE;
-- Create promo_codes table for discount management
-- Extend subscriptions.status enum to include 'trial'
```

**API Endpoints**:
- `POST /api/stripe/connect` - Create Express account
- `GET /api/stripe/connect/status` - Live verification endpoint
- `GET /api/stripe/connect/onboarding-link` - Generate onboarding URL
- `POST /api/webhooks/stripe` - Webhook handler for account updates

**Integration Points**:
- **Settings/Billing Page**: Stripe Connect status and management UI
- **Onboarding Flow**: "Connect Stripe" step in user setup
- **Payment Processing**: Platform fee calculation before Stripe calls
- **Usage Tracking**: Runtime calculation against plan limits

### Technical Features

**Stripe Connect Integration**:
- **Express Accounts**: Individual accounts for each tenant
- **Onboarding Flow**: Hosted onboarding with document collection
- **Status Verification**: Live capability checking (charges_enabled, payouts_enabled)
- **Webhook Handling**: Real-time account and capability updates

**Subscription Engine**:
- **Trial Management**: Status-based trials using existing period fields
- **Promo System**: Flexible percentage/fixed-amount discounts
- **Proration Handling**: Stripe-managed proration calculations
- **Change History**: Runtime history via payments table + Stripe API

**Security & Compliance**:
- **Webhook Verification**: Cryptographic signature validation
- **Tenant Isolation**: RLS policies on all billing data
- **PCI Compliance**: No local storage of payment method details
- **Audit Logging**: Comprehensive transaction logging

## Conclusion

This comprehensive Stripe Connect integration provides a complete billing and payments solution for PenguinMails. The OLTP-first architecture ensures financial data security through minimal schema changes while delivering enterprise-grade payment processing capabilities.

The implementation follows Stripe's best practices for Connect applications and provides:

- **Business Value**: Automated revenue sharing, subscription management, and global payment acceptance
- **Technical Excellence**: Secure, scalable architecture with real-time status verification
- **Operational Efficiency**: Automated billing workflows with minimal manual intervention
- **Customer Experience**: Seamless onboarding with flexible trials and promotional systems

The architecture leverages existing infrastructure while adding powerful financial capabilities, creating a foundation for sustainable business growth through Stripe's payment ecosystem.