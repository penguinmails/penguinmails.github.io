# BILL-3.3: Implement Handlers for Subscription Updates and Deletions

**Ticket ID:** BILL-3.3  
**Milestone:** 3 - Subscription State Synchronization with Webhooks  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Within the webhook, add logic to handle `customer.subscription.updated` and `customer.subscription.deleted` events. These will update the status of an existing subscription in our database (e.g., to `past_due`, `canceled`).

## Context

Subscription state changes are critical for billing management. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), webhook events keep subscription state synchronized. This handler ensures our database reflects subscription changes like upgrades, downgrades, cancellations, and payment failures.

## Acceptance Criteria

1. ✅ The webhook correctly handles the `customer.subscription.updated` event
2. ✅ It updates fields like `status`, `plan_id` (for upgrades/downgrades), and `cancel_at_period_end`
3. ✅ It updates `current_period_start` and `current_period_end` if changed
4. ✅ The webhook correctly handles the `customer.subscription.deleted` event
5. ✅ It sets the subscription status to `canceled` when deleted
6. ✅ It handles subscriptions that don't exist in our database gracefully
7. ✅ All updates are logged for audit trail

## Technical Details

### Webhook Handler Logic

```typescript
// app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { stripe, STRIPE_WEBHOOK_SECRET } from '@/lib/stripe';
import { db } from '@/lib/db';
import { subscriptions, plans } from '@/lib/db/schema';
import { eq, or } from 'drizzle-orm';
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

    // Handle customer.subscription.updated event
    if (event.type === 'customer.subscription.updated') {
      const subscription = event.data.object as Stripe.Subscription;
      
      // Find subscription in database
      const [existing] = await db
        .select()
        .from(subscriptions)
        .where(eq(subscriptions.stripeSubscriptionId, subscription.id))
        .limit(1);

      if (!existing) {
        console.warn(`Subscription ${subscription.id} not found in database`);
        return NextResponse.json({ received: true }, { status: 200 });
      }

      // Determine plan_id from Stripe price
      const priceId = subscription.items.data[0]?.price.id;
      const [plan] = await db
        .select()
        .from(plans)
        .where(
          or(
            eq(plans.stripePriceIdMonthly, priceId),
            eq(plans.stripePriceIdYearly, priceId)
          )
        )
        .limit(1);

      // Update subscription
      await db
        .update(subscriptions)
        .set({
          status: subscription.status,
          planId: plan?.id || existing.planId, // Keep existing if plan not found
          currentPeriodStart: new Date(subscription.current_period_start * 1000),
          currentPeriodEnd: new Date(subscription.current_period_end * 1000),
          cancelAtPeriodEnd: subscription.cancel_at_period_end || false,
          updatedAt: new Date(),
        })
        .where(eq(subscriptions.stripeSubscriptionId, subscription.id));

      console.log(`Subscription ${subscription.id} updated`);
    }

    // Handle customer.subscription.deleted event
    if (event.type === 'customer.subscription.deleted') {
      const subscription = event.data.object as Stripe.Subscription;
      
      // Find subscription in database
      const [existing] = await db
        .select()
        .from(subscriptions)
        .where(eq(subscriptions.stripeSubscriptionId, subscription.id))
        .limit(1);

      if (!existing) {
        console.warn(`Subscription ${subscription.id} not found in database`);
        return NextResponse.json({ received: true }, { status: 200 });
      }

      // Update subscription status to canceled
      await db
        .update(subscriptions)
        .set({
          status: 'canceled',
          updatedAt: new Date(),
        })
        .where(eq(subscriptions.stripeSubscriptionId, subscription.id));

      console.log(`Subscription ${subscription.id} canceled`);
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

- Handle both updated and deleted events
- Update plan_id when subscription changes (upgrade/downgrade)
- Set status to 'canceled' for deleted subscriptions
- Handle subscriptions not found in database gracefully
- Update all relevant fields (periods, cancel_at_period_end, etc.)
- Log all updates for audit trail
- Consider adding soft delete instead of hard delete (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Webhook processing
- [Stripe Webhooks Documentation](https://stripe.com/docs/webhooks) - Official Stripe docs

## Dependencies

- **BILL-3.1** - Webhook handler must be implemented
- **BILL-3.2** - Checkout completed handler should exist (for context)
- **BILL-1.1** - Subscriptions and plans schemas must be defined

## Testing

- [ ] Test with customer.subscription.updated event - verify subscription updated
- [ ] Test with customer.subscription.deleted event - verify status set to canceled
- [ ] Test with subscription not in database - verify graceful handling
- [ ] Test plan upgrade/downgrade - verify plan_id updated
- [ ] Test status changes (active → past_due) - verify status updated
- [ ] Verify cancel_at_period_end is updated correctly
- [ ] Verify period dates are updated correctly
- [ ] Use Stripe CLI to send test events

