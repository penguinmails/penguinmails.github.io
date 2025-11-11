# BILL-3.1: Create Stripe Webhook Handler Endpoint (POST /api/webhooks/stripe)

**Ticket ID:** BILL-3.1  
**Milestone:** 3 - Subscription State Synchronization with Webhooks  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a public POST API route at `/api/webhooks/stripe/route.ts`. This endpoint will be configured in your Stripe dashboard to receive events. It must be able to handle raw request bodies to verify the webhook signature.

## Context

Webhook handling is essential for keeping subscription state synchronized with Stripe. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), reliable event processing is critical for maintaining accurate billing state. This endpoint receives all Stripe billing events.

## Acceptance Criteria

1. ✅ The endpoint is public (no authentication required, but signature verification provides security)
2. ✅ The Next.js config is updated to disable body parsing for this specific route so the raw body can be accessed
3. ✅ It successfully verifies the `stripe-signature` header using the `STRIPE_WEBHOOK_SECRET`
4. ✅ Requests with invalid signatures are rejected with a `400 Bad Request` error
5. ✅ Valid webhook events are parsed and can be processed
6. ✅ The endpoint returns appropriate status codes (200 for success, 400 for invalid signature)

## Technical Details

### Next.js Config Update

```typescript
// next.config.js
module.exports = {
  // ... other config
  async headers() {
    return [
      {
        source: '/api/webhooks/stripe',
        headers: [
          {
            key: 'Content-Type',
            value: 'application/json',
          },
        ],
      },
    ];
  },
};
```

### API Route Structure

```typescript
// app/api/webhooks/stripe/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { stripe, STRIPE_WEBHOOK_SECRET } from '@/lib/stripe';
import Stripe from 'stripe';

export async function POST(request: NextRequest) {
  try {
    // Get raw body for signature verification
    const body = await request.text();
    const signature = request.headers.get('stripe-signature');

    if (!signature) {
      return NextResponse.json(
        { error: 'Missing stripe-signature header' },
        { status: 400 }
      );
    }

    if (!STRIPE_WEBHOOK_SECRET) {
      return NextResponse.json(
        { error: 'Webhook secret not configured' },
        { status: 500 }
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
      console.error('Webhook signature verification failed:', error);
      return NextResponse.json(
        { error: 'Invalid signature' },
        { status: 400 }
      );
    }

    // Event verified successfully
    // Event processing will be handled in subsequent tickets
    return NextResponse.json(
      { received: true, eventType: event.type },
      { status: 200 }
    );
  } catch (error) {
    console.error('Webhook handler error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}

// Disable body parsing to get raw body for signature verification
export const config = {
  api: {
    bodyParser: false,
  },
};
```

### Route Segment Config (Next.js 13+ App Router)

For App Router, you may need to use a different approach:

```typescript
// app/api/webhooks/stripe/route.ts
export const runtime = 'nodejs';
export const dynamic = 'force-dynamic';
```

## Implementation Notes

- Use raw body for signature verification (Stripe requires this)
- Verify signature before processing any events
- Log webhook events for debugging and audit trail
- Handle signature verification errors gracefully
- Consider adding idempotency handling (future enhancement)
- Consider adding event replay protection (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Webhook processing
- [Stripe Webhooks Documentation](https://stripe.com/docs/webhooks) - Official Stripe docs

## Dependencies

- **BILL-2.1** - Stripe SDK must be configured
- **CORE-1.5** - Environment variables must be set up (STRIPE_WEBHOOK_SECRET)

## Testing

- [ ] Test with valid Stripe signature - verify 200 response
- [ ] Test with invalid signature - verify 400 error
- [ ] Test with missing signature header - verify 400 error
- [ ] Test with missing webhook secret - verify 500 error
- [ ] Verify raw body is accessible for signature verification
- [ ] Test error handling for malformed requests
- [ ] Verify webhook can receive events from Stripe (use Stripe CLI for testing)

