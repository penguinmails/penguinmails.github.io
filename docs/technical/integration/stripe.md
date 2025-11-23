# Stripe Integration

## 1. Overview

This document describes the Stripe payment integration for PenguinMails, specifically focusing on subscription management and checkout flows. The integration allows tenants to upgrade their plans, manage payment methods, and handle billing through Stripe's hosted checkout experience.

### Key Components

- **Stripe Checkout Sessions**: Hosted payment pages for plan upgrades
- **Stripe Webhooks**: Server-side event handlers for subscription lifecycle
- **Stripe Customer Portal**: Self-service billing management (planned)
- **API Routes**: Backend endpoints for creating checkout sessions

### Architecture Approach

The implementation follows a **light database reference** approach:

- Stripe is the source of truth for billing and subscription data
- Local database stores minimal references (subscription IDs, customer IDs, metadata)
- Webhook events keep local state synchronized with Stripe
- API calls fetch real-time data from Stripe when needed

## 2. Environment Configuration

### Required Environment Variables

```bash
# Stripe API Keys
STRIPE_SECRET_KEY=sk_test_...          # Server-side secret key
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_test_...  # Client-side publishable key

# Webhook Configuration
STRIPE_WEBHOOK_SIGNING_SECRET=whsec_...  # Webhook endpoint signature verification

# Application URLs
NEXT_PUBLIC_APP_URL=https://app.penguinmails.com  # Used for redirect URLs
```

### Setup Steps

1. **Create Stripe Account**: Sign up for Stripe and access the Dashboard
2. **Retrieve API Keys**: Copy secret and publishable keys from Stripe Dashboard
3. **Configure Webhooks**: Set up webhook endpoint in Stripe Dashboard
4. **Add Environment Variables**: Update `.env` file with the above values

## 3. Checkout Flow

### User Journey

The checkout flow provides a seamless upgrade experience:

1. **User initiates upgrade**: Clicks "Upgrade Plan" or "Change Plan" button
2. **Plan selection**: Chooses desired plan from pricing modal
3. **Checkout session creation**: Frontend calls API to create Stripe Checkout Session
4. **Stripe redirect**: User is redirected to Stripe's hosted checkout page
5. **Payment processing**: User enters payment details and confirms
6. **Return to app**: User is redirected back based on payment outcome
7. **Success/Failure feedback**: Modal displays payment status

### Technical Implementation

#### Frontend Hook: `useStripeCheckout`

Location: `hooks/useStripeCheckout.ts`

```typescript
export function useStripeCheckout() {
  const [isCheckoutLoading, setIsCheckoutLoading] = useState(false);

  const handleCheckoutForPlan = async (plan: Plan) => {
    try {
      setIsCheckoutLoading(true);
      await createStripeCheckoutSession(plan);
    } catch (err) {
      console.error('Error Stripe Checkout session:', err);
    } finally {
      setIsCheckoutLoading(false);
    }
  };

  return { handleCheckoutForPlan, isCheckoutLoading };
}
```

**Purpose**: Manages checkout state and delegates session creation to utility function.

#### Utility Function: `createStripeCheckoutSession`

Location: `lib/utils/checkoutUtils.ts`

```typescript
export async function createStripeCheckoutSession(plan: Plan): Promise<void> {
  const body = {
    price: plan.priceMonthly,  // Price in cents
    planId: plan.id,           // Plan identifier
  };

  const res = await fetch('/api/stripe/subscription/checkout-session', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(body),
  });

  const data = await res.json();
  if (!res.ok) throw new Error(data.error || 'Failed to create checkout session');

  if (data.url) {
    window.open(data.url, '_blank');  // Opens Stripe Checkout in new tab
    toast.success('Redirecting to checkout...', { duration: 4000 });
  }
}
```

**Flow**:

1. Constructs payload with plan price and ID
2. Sends POST request to backend API
3. Opens returned Stripe Checkout URL in new tab
4. Displays success toast notification

#### UI Components

**Change Plan Dialog**: `components/settings/billing/change-plan-dialog.tsx`

Displays available plans with:

- Plan name and pricing (converted from cents to dollars)
- Feature limits (users, domains, campaigns)
- "Change Plan" button that triggers confirmation dialog
- Confirmation dialog before proceeding to checkout

**Checkout Dialog**: `components/settings/billing/checkout-dialog.tsx`

Displays post-checkout feedback:

- Success state: Green checkmark icon
- Canceled state: Red X icon
- Auto-closes after 2 seconds
- Triggered by `?checkout=success` or `?checkout=canceled` query parameter

## 4. API Routes

### Checkout Session Creation

**Endpoint**: `POST /api/stripe/subscription/checkout-session`

**Location**: `app/api/stripe/subscription/checkout-session/route.ts`

**Request Body**:

```json
{
  "planId": "starter",
  "price": 3500
}
```

**Response**:

```json
{
  "url": "https://checkout.stripe.com/c/pay/cs_test_..."
}
```

**Implementation**:

```typescript
export async function POST(request: NextRequest) {
  // 1. Extract plan details from request body
  const { planId, price } = await request.json();

  // 2. Get authenticated user and tenant context from NileDB
  const user = await nile.users.getSelf();
  const userId = user.id;
  const tenantId = user.tenantId; // NileDB provides tenantId for multi-tenant isolation

  // 3. Define redirect URLs
  const successUrl = `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/settings/billing?checkout=success`;
  const cancelUrl = `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/settings/billing?checkout=canceled`;

  // 4. Create Stripe Checkout Session
  const session = await stripeApi.checkout.sessions.create({
    mode: 'subscription',
    line_items: [{
      quantity: 1,
      price_data: {
        currency: 'usd',
        recurring: { interval: 'month' },
        product_data: { name: `plan ${planId}` },
        unit_amount: price,  // Price in cents
      },
    }],
    metadata: {
      requested_plan_id: planId,
      tenant_id: String(tenantId),     // Tenant ID for webhook reconciliation
      initiated_by_user: userId,
    },
    success_url: successUrl,
    cancel_url: cancelUrl,
  });

  // 5. Return checkout URL
  return NextResponse.json({ url: session.url }, { status: 201 });
}
```

**Key Features**:

- **Authentication**: Verifies user session via NileDB SDK
- **Multi-Tenant Context**: Uses `tenant_id` from NileDB for tenant isolation
- **Dynamic Pricing**: Creates price on-the-fly (not using pre-created Stripe Prices)
- **Metadata Tracking**: Attaches tenant and user context for webhook reconciliation
- **Redirect URLs**: Returns user to billing page with status query parameter

## 5. Webhook Handling

### Webhook Endpoint

**Endpoint**: `POST /api/webhooks/stripe`

**Location**: `app/api/webhooks/stripe/route.ts`

**Purpose**: Receives and processes Stripe events to keep local state synchronized.

**Security**: Verifies webhook signature using `STRIPE_WEBHOOK_SIGNING_SECRET`.

**Implementation**:

```typescript
export async function POST(request: NextRequest) {
  const body = await request.text();
  const sig = (await headers()).get('stripe-signature');

  // Verify webhook signature
  let event = stripeApi.webhooks.constructEvent(body, sig, endpointSecret);

  // Route event to appropriate handler
  switch (event.type) {
    case 'checkout.session.completed':
      await handleCheckoutSessionCompleted(event.data.object);
      break;

    case 'invoice.paid':
      await handleInvoicePaid(event.data.object);
      break;

    case 'customer.subscription.updated':
    case 'customer.subscription.created':
      await handleSubscriptionUpdated(event.data.object);
      break;

    default:
      console.log(`Unhandled event type: ${event.type}`);
  }

  return NextResponse.json({ received: true });
}
```

### Event Handlers

**Location**: `lib/stripe/webhook-handlers.ts`

#### 1. `checkout.session.completed`

**Triggered**: When user completes checkout successfully.

**Purpose**: Links the new Stripe subscription to the tenant's subscription record and creates/updates Stripe customer reference.

**Process**:

```typescript
export async function handleCheckoutSessionCompleted(session: Stripe.Checkout.Session) {
  // Extract subscription ID and metadata
  const subscriptionId = session.subscription;
  const tenantId = session.metadata?.tenant_id;
  const planId = session.metadata?.requested_plan_id;

  // Fetch full subscription details from Stripe
  const subscription = await stripeApi.subscriptions.retrieve(subscriptionId);

  // Update subscriptions table with Stripe subscription reference
  await db.subscriptions.update({
    where: { tenant_id: tenantId },
    data: {
      stripe_subscription_id: subscription.id,
      plan_id: planId,
      status: subscription.status,
      current_period_start: new Date(subscription.current_period_start * 1000),
      current_period_end: new Date(subscription.current_period_end * 1000),
    },
  });

  // Create/update tenant_config with Stripe customer ID
  await db.tenant_config.upsert({
    where: { tenant_id: tenantId },
    create: { tenant_id: tenantId, stripe_customer_id: subscription.customer },
    update: { stripe_customer_id: subscription.customer },
  });

  console.log(`Updated subscription for tenant ${tenantId} with Stripe subscription ${subscription.id}`);
}
```

#### 2. `invoice.paid`

**Triggered**: When a subscription invoice is successfully paid.

**Purpose**: Records payment in the payments table and confirms service continuation.

**Process**:

```typescript
export async function handleInvoicePaid(invoice: Stripe.Invoice) {
  // Resolve tenant from subscription metadata
  const stripeSubscriptionId = invoice.subscription;
  const subscription = await stripeApi.subscriptions.retrieve(stripeSubscriptionId);
  const tenantId = subscription.metadata?.tenant_id;

  // Find internal subscription record
  const internalSubscription = await db.subscriptions.findUnique({
    where: { stripe_subscription_id: stripeSubscriptionId },
  });

  // Record payment in payments table
  await db.payments.create({
    data: {
      subscription_id: internalSubscription.id,
      amount: invoice.amount_paid / 100, // Convert cents to dollars
      currency: invoice.currency.toUpperCase(),
      status: 'succeeded',
      processed: new Date(),
      stripe_payment_intent_id: invoice.payment_intent,
      billing_period_start: new Date(invoice.period_start * 1000),
      billing_period_end: new Date(invoice.period_end * 1000),
    },
  });

  console.log(`Recorded payment for tenant ${tenantId} - Invoice ${invoice.id}`);
}
```

#### 3. `customer.subscription.updated`

**Triggered**: When subscription changes (plan upgrade, renewal, cancellation).

**Purpose**: Syncs subscription status, billing period, and cancellation flags.

**Process**:

```typescript
export async function handleSubscriptionUpdated(subscription: Stripe.Subscription) {
  const tenantId = subscription.metadata?.tenant_id;

  // Update subscriptions table with new subscription details
  await db.subscriptions.update({
    where: { stripe_subscription_id: subscription.id },
    data: {
      status: subscription.status, // active, past_due, canceled, etc.
      current_period_start: new Date(subscription.current_period_start * 1000),
      current_period_end: new Date(subscription.current_period_end * 1000),
      cancel_at_period_end: subscription.cancel_at_period_end,
    },
  });

  console.log(`Updated subscription status for tenant ${tenantId}: ${subscription.status}`);
}
```

## 6. Billing Page Integration

### Location

- **Component**: `app/[locale]/dashboard/settings/billing/Billing-Tab.tsx`
- **Page**: `app/[locale]/dashboard/settings/billing/BillingPage.tsx`

### Features

#### Current Plan Display

Shows the active subscription plan with:

- Plan name and limits
- Usage metrics (if applicable)
- "Change Plan" button to upgrade/downgrade

#### Change Plan Trigger

```typescript
const { handleCheckoutForPlan, isCheckoutLoading } = useStripeCheckout();

<ChangePlanTrigger 
  title="Change Plan" 
  onSelectPlan={handleCheckoutForPlan} 
  isLoading={isCheckoutLoading} 
/>
```

#### Checkout Feedback

Monitors `?checkout` query parameter and displays modal:

```typescript
const checkout = searchParams.get("checkout");

useEffect(() => {
  if (typeof checkout === 'string') {
    setTimeout(() => {
      router.push(pathname);  // Clears query param after 2s
    }, 2000);
  }
}, [checkout]);

<CheckoutDialog
  isModalOpen={typeof checkout === 'string'}
  checkout={checkout}
  setIsModalOpen={() => router.push(pathname)}
/>
```

## 7. Plan Configuration

### Plan Schema

**Type Definition**: `types/settings/plans.ts`

```typescript
interface Plan {
  id: string;              // Unique identifier (e.g., "starter")
  name: string;            // Display name (e.g., "Starter")
  slug: string;            // URL-friendly slug
  description: string;     // Marketing description
  maxUsers: number;        // User limit (-1 = unlimited)
  maxDomains: number;      // Domain limit (-1 = unlimited)
  maxCampaignsPerMonth: number;  // Campaign limit (-1 = unlimited)
  apiRateLimit: number;    // API rate limit
  priceMonthly: number;    // Price in cents (e.g., 3500 = $35)
  priceYearly: number;     // Yearly price in cents
  features: string[];      // List of included features
  isActive: boolean;       // Whether plan is available
}
```

### Default Plans

The application defines four tiers:

| Plan    | Price/Month | Users      | Domains    | Campaigns/Month |
|---------|-------------|------------|------------|-----------------|
| Starter | $35         | 1          | 1          | 100             |
| Growth  | $55         | 5          | 3          | 1,000           |
| Scale   | $89         | 20         | 10         | 5,000           |
| Pro     | $189        | Unlimited  | Unlimited  | Unlimited       |

## 8. Stripe Customer Portal (Planned)

### Purpose

Self-service billing management for customers to:

- Update payment methods
- View and download invoices
- Cancel subscriptions
- View billing history

### Implementation Notes

```typescript
// Generate Customer Portal session
const portalSession = await stripeApi.billingPortal.sessions.create({
  customer: customerId,
  return_url: `${process.env.NEXT_PUBLIC_APP_URL}/dashboard/settings/billing`,
});

// Redirect user to portal
window.location.href = portalSession.url;
```

**Status**: Referenced in settings.md but not yet implemented in the diff.

## 9. Database Schema Integration

The Stripe integration uses existing tables in the OLTP database to store subscription and billing references. See the complete schema in [OLTP Database Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide).

### `subscriptions` Table

**Purpose**: Stores active tenant subscription information with Stripe references.

**Key Fields**:

- `id` (UUID PRIMARY KEY) - Internal subscription ID
- `tenant_id` (UUID) - References tenants table (FK)
- `plan_id` (UUID) - References plans table (FK)
- `pending_plan_id` (UUID) - Plan for next billing cycle (for upgrades/downgrades)
- `status` (VARCHAR) - Subscription status: 'active', 'past_due', 'canceled', 'unpaid'
- `current_period_start` (TIMESTAMP) - Current billing period start date
- `current_period_end` (TIMESTAMP) - Current billing period end date (renewal date)
- `cancel_at_period_end` (BOOLEAN) - Scheduled cancellation flag
- `billing_contact_user_id` (UUID) - User responsible for billing
- **`stripe_subscription_id`** (VARCHAR) - **Stripe Subscription ID reference**
- `created` / `updated` (TIMESTAMP) - Record timestamps

**Stripe Integration Points**:

- `stripe_subscription_id` stores the Stripe Subscription ID returned from checkout
- Webhook handlers update `status`, `current_period_start`, `current_period_end` based on Stripe events
- `pending_plan_id` enables seamless plan changes at billing cycle end

### `tenant_config` Table

**Purpose**: Stores tenant-level configuration including Stripe customer reference.

**Key Stripe Fields**:

- `tenant_id` (UUID PRIMARY KEY) - References tenants table
- **`stripe_customer_id`** (VARCHAR) - **Stripe Customer ID reference**
- `billing_email` (VARCHAR) - Email for billing communications
- `billing_address` (JSONB) - Structured billing address
- `notify_on_billing_changes` (BOOLEAN) - Billing notification preference

**Stripe Integration Points**:

- `stripe_customer_id` links tenant to Stripe Customer object
- Created when first subscription is processed
- Used for Customer Portal access and invoice management

### `plans` Table

**Purpose**: Defines available subscription plans and their limits.

**Key Fields**:

- `id` (UUID PRIMARY KEY) - Internal plan ID
- `name` (VARCHAR) - Plan display name (e.g., "Starter", "Pro")
- `slug` (VARCHAR UNIQUE) - URL-friendly identifier
- `max_users`, `max_domains`, `max_campaigns_per_month` - Plan limits
- `price_monthly`, `price_yearly` (INTEGER) - Prices in cents
- `is_active` (BOOLEAN) - Whether plan is available for purchase

**Stripe Integration Points**:

- Plan data is passed to Stripe Checkout as `price_data` (dynamic pricing)
- Plan ID stored in Stripe session metadata for reconciliation
- Plan limits enforced in application logic based on active subscription

### Webhook Handler Database Updates

The webhook event handlers should update these tables:

#### `checkout.session.completed` Handler

```typescript
// Updates after successful checkout
await db.subscriptions.update({
  where: { tenant_id: tenantId },
  data: {
    stripe_subscription_id: subscription.id,
    plan_id: metadata.requested_plan_id,
    status: subscription.status,
    current_period_start: new Date(subscription.current_period_start * 1000),
    current_period_end: new Date(subscription.current_period_end * 1000),
  },
});

await db.tenant_config.upsert({
  where: { tenant_id: tenantId },
  create: { tenant_id: tenantId, stripe_customer_id: subscription.customer },
  update: { stripe_customer_id: subscription.customer },
});
```

#### `invoice.paid` Handler

```typescript
// Record payment in payments table
await db.payments.create({
  data: {
    subscription_id: internalSubscriptionId,
    amount: invoice.amount_paid / 100,
    currency: invoice.currency.toUpperCase(),
    status: 'succeeded',
    processed: new Date(),
    stripe_payment_intent_id: invoice.payment_intent,
    billing_period_start: new Date(invoice.period_start * 1000),
    billing_period_end: new Date(invoice.period_end * 1000),
  },
});
```

#### `customer.subscription.updated` Handler

```typescript
// Sync subscription status changes
await db.subscriptions.update({
  where: { stripe_subscription_id: subscription.id },
  data: {
    status: subscription.status,
    current_period_end: new Date(subscription.current_period_end * 1000),
    cancel_at_period_end: subscription.cancel_at_period_end,
  },
});
```

### Data Flow Summary

1. **Checkout**: User → Stripe Checkout → `checkout.session.completed` webhook → Update `subscriptions` + `tenant_config`
2. **Recurring Payment**: Stripe → `invoice.paid` webhook → Create `payments` record
3. **Subscription Change**: User/Stripe → `customer.subscription.updated` webhook → Update `subscriptions` status

## 10. Error Handling

### Checkout Session Creation Errors

- **Authentication Failure**: Returns 401 if user not authenticated
- **Invalid Plan Data**: Returns 400 if planId or price missing
- **Stripe API Errors**: Returns 500 with error message

### Webhook Processing Errors

- **Invalid Signature**: Returns 400 if signature verification fails
- **Missing Metadata**: Logs warning but does not fail
- **Database Update Errors**: Logs error but returns 200 to prevent retries

### Frontend Error Handling

```typescript
try {
  await createStripeCheckoutSession(plan);
} catch (err) {
  toast.error(err.message || 'Failed to create checkout session');
}
```

## 11. Testing Considerations

### Test Mode

Use Stripe's test mode credentials:

- Test publishable key: `pk_test_...`
- Test secret key: `sk_test_...`

### Test Cards

Stripe provides test card numbers:

- **Success**: `4242 4242 4242 4242`
- **Decline**: `4000 0000 0000 0002`
- **3D Secure**: `4000 0025 0000 3155`

### Webhook Testing

Use Stripe CLI to forward webhooks to localhost:

```bash
stripe listen --forward-to localhost:3000/api/webhooks/stripe
```

## 12. Security Best Practices

### API Key Management

- **Never expose secret key**: Only use in server-side code
- **Use environment variables**: Store keys in `.env.local`, not in code
- **Rotate keys regularly**: Update keys periodically via Stripe Dashboard

### Webhook Verification

Always verify webhook signatures:

```typescript
const event = stripeApi.webhooks.constructEvent(body, sig, endpointSecret);
```

### Metadata Privacy

Avoid storing sensitive data in Stripe metadata:

- ✅ Company ID, User ID, Plan ID
- ❌ Passwords, API tokens, personal data

## 13. Related Documentation

- [Settings Route Specification](/docs/design/routes/settings)
- [Pricing Plans](/docs/finance/pricing/overview) (if exists)
- [NileDB Authentication](/docs/technical/architecture/detailed-technical/onboarding-authentication)
- [Queue System](/docs/technical/architecture/detailed-technical/queue-system-implementation)

## 14. Implementation Checklist

- [x] Install Stripe Node.js SDK (`npm install stripe`)
- [x] Configure environment variables
- [x] Create checkout session API route
- [x] Create webhook handler endpoint
- [x] Implement webhook event handlers
- [x] Build frontend checkout hook
- [x] Add checkout utility function
- [x] Create plan selection UI
- [x] Add checkout feedback dialog
- [x] Integrate with billing page
- [ ] Configure Stripe webhook endpoint in Dashboard
- [x] Database tables exist (`subscriptions`, `tenant_config`, `payments`)
- [ ] Connect webhook handlers to database updates (implement Prisma/ORM queries)
- [ ] Implement Customer Portal (planned feature)
- [ ] Add comprehensive error logging
- [ ] Write integration tests

## 15. Future Enhancements

### Planned Features

- **Customer Portal Integration**: Full self-service billing management
- **Annual Billing**: Support for yearly subscriptions with discount
- **Usage-Based Pricing**: Metered billing for overage charges
- **Payment Method Variety**: Support for ACH, SEPA, and other payment methods
- **Dunning Management**: Automated retry logic for failed payments
- **Proration Handling**: Mid-cycle plan changes with prorated credits
