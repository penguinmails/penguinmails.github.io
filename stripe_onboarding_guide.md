# Stripe Onboarding and Billing Integration Guide

> **Status**: ✅ Current  
> **Last Updated**: October 27, 2025  
> **Owner**: Engineering Lead  
> **Version**: 1.0

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
export async function createStripeConnectAccount(companyId: string) {
  try {
    // 1. Check if account already exists
    const existingAccount = await nile.db.query(
      `SELECT stripe_account_id FROM company_stripe_accounts
       WHERE company_id = $1 AND tenant_id = CURRENT_TENANT_ID()`,
      [companyId]
    );

    if (existingAccount.rows.length > 0) {
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

    // 3. Store in database
    await nile.db.query(
      `INSERT INTO company_stripe_accounts (
        company_id, tenant_id, stripe_account_id,
        status, onboarding_completed, created_at
      ) VALUES ($1, CURRENT_TENANT_ID(), $2, $3, $4, CURRENT_TIMESTAMP)`,
      [companyId, account.id, 'pending', false]
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

```sql
-- Company Stripe Accounts Table
CREATE TABLE company_stripe_accounts (
    id SERIAL PRIMARY KEY,
    company_id INTEGER NOT NULL,
    tenant_id UUID NOT NULL DEFAULT CURRENT_TENANT_ID(),

    -- Stripe Account Details
    stripe_account_id VARCHAR(255) NOT NULL UNIQUE,
    status VARCHAR(50) NOT NULL DEFAULT 'pending',
    onboarding_completed BOOLEAN NOT NULL DEFAULT false,

    -- Account Information
    email VARCHAR(255),
    country VARCHAR(2),
    currency VARCHAR(3) DEFAULT 'USD',

    -- Charges/Transfers Enabled
    charges_enabled BOOLEAN NOT NULL DEFAULT false,
    payouts_enabled BOOLEAN NOT NULL DEFAULT false,

    -- Requirements
    requirements JSONB,
    future_requirements JSONB,

    -- Audit Trail
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE(company_id, tenant_id)
);

-- Row Level Security
ALTER TABLE company_stripe_accounts ENABLE ROW LEVEL SECURITY;

CREATE POLICY company_stripe_accounts_tenant_isolation ON company_stripe_accounts
    FOR ALL USING (tenant_id = CURRENT_TENANT_ID());
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
export async function getStripeConnectStatus(companyId: string) {
  try {
    // Get stored account info
    const accountInfo = await nile.db.query(
      `SELECT * FROM company_stripe_accounts
       WHERE company_id = $1 AND tenant_id = CURRENT_TENANT_ID()`,
      [companyId]
    );

    if (accountInfo.rows.length === 0) {
      return { connected: false, status: 'not_connected' };
    }

    const account = accountInfo.rows[0];

    // Fetch latest status from Stripe
    const stripeAccount = await stripe.accounts.retrieve(account.stripe_account_id);

    // Update local database with latest info
    await nile.db.query(
      `UPDATE company_stripe_accounts SET
        status = $1,
        onboarding_completed = $2,
        charges_enabled = $3,
        payouts_enabled = $4,
        requirements = $5,
        future_requirements = $6,
        updated_at = CURRENT_TIMESTAMP
       WHERE id = $7`,
      [
        stripeAccount.details_submitted ? 'complete' : 'pending',
        stripeAccount.details_submitted,
        stripeAccount.charges_enabled,
        stripeAccount.payouts_enabled,
        JSON.stringify(stripeAccount.requirements),
        JSON.stringify(stripeAccount.future_requirements),
        account.id
      ]
    );

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
    // Update account status in database
    await nile.db.query(
      `UPDATE company_stripe_accounts SET
        status = $1,
        onboarding_completed = $2,
        charges_enabled = $3,
        payouts_enabled = $4,
        requirements = $5,
        future_requirements = $6,
        updated_at = CURRENT_TIMESTAMP
       WHERE stripe_account_id = $7`,
      [
        account.details_submitted ? 'complete' : 'pending',
        account.details_submitted,
        account.charges_enabled,
        account.payouts_enabled,
        JSON.stringify(account.requirements),
        JSON.stringify(account.future_requirements),
        account.id
      ]
    );

    console.log(`Updated Stripe account ${account.id} status`);
  } catch (error) {
    console.error('Failed to update account status:', error);
    throw error;
  }
}

async function handleCapabilityUpdated(capability: Stripe.Capability) {
  try {
    const updates: Record<string, any> = {};

    if (capability.id.includes('card_payments')) {
      updates.charges_enabled = capability.status === 'active';
    } else if (capability.id.includes('transfers')) {
      updates.payouts_enabled = capability.status === 'active';
    }

    if (Object.keys(updates).length > 0) {
      updates.updated_at = new Date();

      await nile.db.query(
        `UPDATE company_stripe_accounts SET ${Object.keys(updates).map((key, i) => `${key} = $${i + 2}`).join(', ')}, updated_at = CURRENT_TIMESTAMP
         WHERE stripe_account_id = $1`,
        [capability.account, ...Object.values(updates)]
      );
    }
  } catch (error) {
    console.error('Failed to update capability status:', error);
    throw error;
  }
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
1. ✅ Database schema for Stripe accounts
2. ✅ API endpoints for account creation
3. ✅ Onboarding link generation
4. ✅ Basic webhook handling
5. ⏳ Frontend integration in onboarding

### Phase 2: Enhanced Features
1. ⏳ Status checking and UI updates
2. ⏳ Error handling and retry logic
3. ⏳ Testing and validation
4. ⏳ Documentation and monitoring

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
const status = await getStripeConnectStatus(companyId);
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

## Related Documents

- [Database Schema Guide](database_schema_guide.md) - Database structure and relationships
- [Analytics Architecture](analytics_architecture.md) - Payment analytics implementation
- [Security Documentation](security_documentation.md) - Authentication and security procedures
- [Infrastructure Documentation](infrastructure_documentation.md) - System deployment and operations

## Conclusion

This Stripe Connect integration provides a secure, scalable foundation for payment processing in PenguinMails. The OLTP-first architecture ensures financial data security while maintaining a smooth user experience through thoughtful onboarding and status management.

The implementation follows Stripe's best practices for Connect applications and integrates seamlessly with the existing billing infrastructure documented in the OLTP Billing Infrastructure Implementation guide.