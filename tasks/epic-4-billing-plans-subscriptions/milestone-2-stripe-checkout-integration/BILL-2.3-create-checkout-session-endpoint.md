---
title: "BILL-2.3: Create API Endpoint for Stripe Checkout Session (POST /api/subscriptions/checkout)"
description: "Documentation for BILL-2.3: Create API Endpoint for Stripe Checkout Session (POST /api/subscriptions/checkout) - BILL 2.3 Create Checkout Session Endp"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# BILL-2.3: Create API Endpoint for Stripe Checkout Session (POST /api/subscriptions/checkout)

**Ticket ID:** BILL-2.3  
**Milestone:** 2 - Stripe Checkout Integration  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a protected POST API route at `/api/subscriptions/checkout/route.ts`. This endpoint will accept a `priceId` and `planId` from the frontend. It will use the logic from the previous ticket to get a Stripe Customer ID and then use the Stripe SDK to create a checkout session.

## Context

Checkout session creation is the first step in the subscription flow. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index), users need to subscribe to plans through Stripe Checkout. This endpoint initiates the secure payment process.

## Acceptance Criteria

1. ✅ The endpoint is protected (requires authentication)
2. ✅ It accepts a JSON body with `priceId` and `planId`
3. ✅ It validates that the `planId` exists in our database
4. ✅ It calls `getOrCreateStripeCustomer` to get a customer ID
5. ✅ It successfully creates a Stripe Checkout Session, passing along metadata like `tenant_id` and `user_id`
6. ✅ It returns a `200 OK` with the `sessionId` that the frontend can use to redirect the user to Stripe
7. ✅ An unauthenticated request returns a `401 Unauthorized` error
8. ✅ Invalid data returns a `400 Bad Request` error

## Technical Details

### API Route Structure

```typescript
// app/api/subscriptions/checkout/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { nile } from '@/lib/nile';
import { stripe } from '@/lib/stripe';
import { db } from '@/lib/db';
import { plans } from '@/lib/db/schema';
import { getOrCreateStripeCustomer } from '@/lib/services/billing.service';
import { eq } from 'drizzle-orm';
import { z } from 'zod';

const checkoutSchema = z.object({
  priceId: z.string().min(1, 'Price ID is required'),
  planId: z.string().uuid('Plan ID must be a valid UUID'),
});

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

    // Validate request body
    const body = await request.json();
    const validatedData = checkoutSchema.parse(body);

    // Verify plan exists
    const [plan] = await db
      .select()
      .from(plans)
      .where(eq(plans.id, validatedData.planId))
      .limit(1);

    if (!plan) {
      return NextResponse.json(
        { error: 'Plan not found' },
        { status: 404 }
      );
    }

    // Verify priceId matches plan
    if (plan.stripePriceIdMonthly !== validatedData.priceId && 
        plan.stripePriceIdYearly !== validatedData.priceId) {
      return NextResponse.json(
        { error: 'Price ID does not match plan' },
        { status: 400 }
      );
    }

    // Get or create Stripe customer
    const customerId = await getOrCreateStripeCustomer(
      tenantId,
      session.user.email // Get email from session or user lookup
    );

    // Create Stripe Checkout Session
    const checkoutSession = await stripe.checkout.sessions.create({
      customer: customerId,
      payment_method_types: ['card'],
      line_items: [
        {
          price: validatedData.priceId,
          quantity: 1,
        },
      ],
      mode: 'subscription',
      success_url: `${process.env.NEXT_PUBLIC_APP_URL}/subscription/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/subscription/cancel`,
      metadata: {
        tenantId: tenantId,
        userId: session.userId,
        planId: validatedData.planId,
      },
    });

    return NextResponse.json(
      {
        sessionId: checkoutSession.id,
        url: checkoutSession.url,
      },
      { status: 200 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        { error: 'Validation failed', errors: error.errors },
        { status: 400 }
      );
    }

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
  "sessionId": "cs_test_xxxxx",
  "url": "https://checkout.stripe.com/c/pay/cs_test_xxxxx"
}
```

**Error Response (404):**

```json
{
  "error": "Plan not found"
}
```

## Implementation Notes

- Validate plan exists before creating checkout session
- Verify priceId matches the plan's Stripe Price IDs
- Include tenant and user metadata for webhook processing
- Set appropriate success and cancel URLs
- Use subscription mode for recurring payments
- Consider adding trial period support (future enhancement)
- Consider adding coupon support (future enhancement)

## Related Documentation

- [Implementation & Getting Started](../../docs/implementation-getting-started/index) - Subscription setup
- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Payment processing

## Dependencies

- **BILL-2.1** - Stripe SDK must be configured
- **BILL-2.2** - Get or create customer function must be implemented
- **CORE-3.2** - Middleware must be implemented (from Epic 1)

## Testing

- [ ] Test authenticated request with valid data - verify 200 response with sessionId
- [ ] Test unauthenticated request - verify 401 error
- [ ] Test with invalid planId - verify 404 error
- [ ] Test with priceId that doesn't match plan - verify 400 error
- [ ] Verify checkout session is created in Stripe
- [ ] Verify metadata includes tenant_id and user_id
- [ ] Test error handling for Stripe API failures
- [ ] Verify customer is created if doesn't exist
