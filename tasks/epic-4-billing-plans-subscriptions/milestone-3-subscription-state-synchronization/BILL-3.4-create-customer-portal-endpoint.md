
# BILL-3.4: Create API Endpoint for Customer Portal (POST /api/subscriptions/portal)

**Ticket ID:** BILL-3.4  
**Milestone:** 3 - Subscription State Synchronization with Webhooks  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route at `/api/subscriptions/portal/route.ts`. This endpoint will retrieve the tenant's `stripe_customer_id` and use the Stripe SDK to create a billing portal session, returning a URL for the frontend to redirect to.

## Context

Customer portal access enables self-service subscription management. According to the [Features & Capabilities](../../docs/features-capabilities/index), users need to manage their subscriptions. This endpoint provides access to Stripe's hosted customer portal where users can update payment methods, view invoices, and manage subscriptions.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It successfully retrieves the `stripe_customer_id` for the current tenant
3. ✅ It creates a Stripe Billing Portal session
4. ✅ It returns a `200 OK` with the portal URL
5. ✅ An unauthenticated request returns a `401 Unauthorized` error
6. ✅ If tenant has no Stripe customer ID, it returns an appropriate error

## Technical Details

### API Route Structure

```typescript
// app/api/subscriptions/portal/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { stripe } from '@/lib/stripe';
import { db } from '@/lib/db';
import { tenantConfig } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';

export async function POST(request: NextRequest) {
  try {
    // Get session from NileDB
    const session = await nile.auth.getSession();

    if (!session) {
      return NextResponse.json(
        { error: 'Unauthorized' },
        { status: 401 }
      );
    }

    // Get tenantId from session context
    const tenantId = session.tenantId;

    if (!tenantId) {
      return NextResponse.json(
        { error: 'No tenant context found' },
        { status: 400 }
      );
    }

    // Get Stripe customer ID from tenant_config
    const [config] = await db
      .select()
      .from(tenantConfig)
      .where(eq(tenantConfig.tenantId, tenantId))
      .limit(1);

    if (!config || !config.stripeCustomerId) {
      return NextResponse.json(
        { error: 'No Stripe customer found for this tenant' },
        { status: 404 }
      );
    }

    // Create billing portal session
    const portalSession = await stripe.billingPortal.sessions.create({
      customer: config.stripeCustomerId,
      return_url: `${process.env.NEXT_PUBLIC_APP_URL}/settings/billing`,
    });

    return NextResponse.json(
      {
        url: portalSession.url,
      },
      { status: 200 }
    );
  } catch (error) {
    console.error('Customer portal error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

### Expected Response Format

**Success Response (200):**

```json
{
  "url": "https://billing.stripe.com/p/session/xxxxx"
}
```

**Error Response (404):**

```json
{
  "error": "No Stripe customer found for this tenant"
}
```

## Implementation Notes

- Retrieve Stripe customer ID from tenant_config
- Set appropriate return URL for after portal session
- Handle missing customer ID gracefully
- Consider adding permission checks (future enhancement)
- Log portal access for audit trail (future enhancement)
- Consider customizing portal features (future enhancement)

## Related Documentation

- [Features & Capabilities](../../docs/features-capabilities/index) - Subscription management
- [Stripe Customer Portal Documentation](https://stripe.com/docs/billing/subscriptions/integrating-customer-portal) - Official Stripe docs

## Dependencies

- **BILL-2.1** - Stripe SDK must be configured
- **BILL-1.1** - Tenant_config schema must be defined
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request with valid customer ID - verify 200 response with URL
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with tenant that has no customer ID - verify 404 error
- [ ] Verify portal session is created in Stripe
- [ ] Verify return URL is set correctly
- [ ] Test error handling for Stripe API failures
- [ ] Verify portal URL is valid and accessible
