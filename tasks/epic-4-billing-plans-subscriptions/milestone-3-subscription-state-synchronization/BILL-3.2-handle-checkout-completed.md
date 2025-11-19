---
title: "BILL-3.2: Implement Handler for checkout.session.completed Event"
description: "Documentation for BILL-3.2: Implement Handler for checkout.session.completed Event - BILL 3.2 Handle Checkout Completed"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# BILL-3.2: Implement Handler for checkout.session.completed Event

**Ticket ID:** BILL-3.2  
**Milestone:** 3 - Subscription State Synchronization with Webhooks  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Within the webhook, add logic to handle the `checkout.session.completed` event. When this event is received, parse the metadata to get the `tenant_id`. Create a new record in our `subscriptions` table with the details from the Stripe subscription object.

## Context

Subscription creation is triggered when a user completes checkout. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), webhook events keep the system synchronized with Stripe. This handler creates the subscription record in our database when payment is successful.

## Acceptance Criteria

1. ✅ The webhook correctly identifies the `checkout.session.completed` event type
2. ✅ It retrieves the `tenant_id` from the checkout session metadata
3. ✅ It retrieves the Stripe subscription object using the subscription ID from the checkout session
4. ✅ It successfully creates a new subscription record in the database linked to the correct tenant and plan
5. ✅ The `status`, `current_period_start`, and `current_period_end` fields are populated correctly
6. ✅ The `stripe_subscription_id` is stored correctly
7. ✅ If subscription already exists, it handles gracefully (idempotency)

## Technical Details

### Webhook Handler Logic

```typescript
// app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { stripe, STRIPE_WEBHOOK_SECRET } from '@/lib/stripe';
import { db } from '@/lib/db';
import { subscriptions } from '@/lib/db/schema';
import { eq } from 'drizzle-orm';
import Stripe from 'stripe';

export async function POST(request: NextRequest) {
  try {
    const body = await request.text();
    const signature = request.headers.get('stripe-signature');

    if (!signature || !STRIPE_WEBHOOK_SECRET) {
      return NextResponse.json(
        { error: 'Missing signature or webhook secret' },
        { status: 400 }
      );
    }

    // Verify webhook signature
    let event: Stripe.Event;
    try {
      event = stripe.webhooks.constructEvent(
        body,
        signature,
        STRIPE_WEBHOOK_SECRET
      );
    } catch (error) {
      return NextResponse.json(
        { error: 'Invalid signature' },
        { status: 400 }
      );
    }

    // Handle checkout.session.completed event
    if (event.type === 'checkout.session.completed') {
      const session = event.data.object as Stripe.Checkout.Session;
      
      // Get tenant_id from metadata
      const tenantId = session.metadata?.tenantId;
      const planId = session.metadata?.planId;

      if (!tenantId || !planId) {
        console.error('Missing tenant_id or plan_id in checkout session metadata');
        return NextResponse.json(
          { error: 'Missing metadata' },
          { status: 400 }
        );
      }

      // Retrieve the subscription from Stripe
      const subscriptionId = session.subscription as string;
      if (!subscriptionId) {
        console.error('No subscription ID in checkout session');
        return NextResponse.json(
          { error: 'No subscription ID' },
          { status: 400 }
        );
      }

      const subscription = await stripe.subscriptions.retrieve(subscriptionId);
      
      // Check if subscription already exists (idempotency)
      const existing = await db
        .select()
        .from(subscriptions)
        .where(eq(subscriptions.stripeSubscriptionId, subscriptionId))
        .limit(1);

      if (existing.length > 0) {
        console.log('Subscription already exists, skipping creation');
        return NextResponse.json({ received: true }, { status: 200 });
      }

      // Create subscription record
      await db.insert(subscriptions).values({
        tenantId: tenantId,
        planId: planId,
        stripeSubscriptionId: subscriptionId,
        status: subscription.status,
        currentPeriodStart: new Date(subscription.current_period_start * 1000),
        currentPeriodEnd: new Date(subscription.current_period_end * 1000),
        cancelAtPeriodEnd: subscription.cancel_at_period_end || false,
      });

      console.log(`Subscription created for tenant ${tenantId}`);
    }

    return NextResponse.json({ received: true }, { status: 200 });
  } catch (error) {
    console.error('Webhook handler error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
```

## Implementation Notes

- Retrieve full subscription object from Stripe for complete data
- Check for existing subscription to ensure idempotency
- Extract tenant_id and plan_id from checkout session metadata
- Convert Stripe timestamps (Unix seconds) to JavaScript Date objects
- Handle missing metadata gracefully
- Log subscription creation for audit trail
- Consider adding transaction support for atomicity (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Webhook processing
- [Stripe Webhooks Documentation](https://stripe.com/docs/webhooks) - Official Stripe docs

## Dependencies

- **BILL-3.1** - Webhook handler must be implemented
- **BILL-1.1** - Subscriptions schema must be defined
- **BILL-1.2** - Subscriptions table must exist in database

## Testing

- [ ] Test with valid checkout.session.completed event - verify subscription created
- [ ] Test with missing metadata - verify error handling
- [ ] Test with existing subscription - verify idempotency
- [ ] Verify subscription record has correct tenant_id and plan_id
- [ ] Verify timestamps are correctly converted
- [ ] Verify status matches Stripe subscription status
- [ ] Test error handling for Stripe API failures
- [ ] Use Stripe CLI to send test events
