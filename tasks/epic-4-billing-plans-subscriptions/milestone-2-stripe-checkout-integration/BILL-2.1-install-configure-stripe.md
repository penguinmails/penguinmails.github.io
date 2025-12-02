
# BILL-2.1: Install and Configure Stripe Node.js SDK

**Ticket ID:** BILL-2.1  
**Milestone:** 2 - Stripe Checkout Integration  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install the official `stripe` Node.js library. Add the `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` to the environment variables. Create a singleton Stripe client instance in `/lib/stripe.ts`.

## Context

Stripe integration is essential for payment processing. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index), PenguinMails uses Stripe Connect for B2B billing. The Stripe SDK will handle all payment operations securely.

## Acceptance Criteria

1. ✅ The `stripe` package is a dependency in `package.json`
2. ✅ A `/lib/stripe.ts` file exists and exports a configured Stripe client
3. ✅ The required Stripe keys are added to `.env.example`:
   - `STRIPE_SECRET_KEY`
   - `STRIPE_WEBHOOK_SECRET`
   - `STRIPE_PUBLISHABLE_KEY` (for frontend, optional but recommended)
4. ✅ The Stripe client is initialized with the secret key from environment variables
5. ✅ The client can be imported and used in other parts of the application

## Technical Details

### Required Package

```json
{
  "dependencies": {
    "stripe": "^latest"
  }
}
```

### Stripe Client Configuration

```typescript
// lib/stripe.ts
import Stripe from 'stripe';

if (!process.env.STRIPE_SECRET_KEY) {
  throw new Error('STRIPE_SECRET_KEY is not set');
}

export const stripe = new Stripe(process.env.STRIPE_SECRET_KEY, {
  apiVersion: '2024-11-20.acacia', // Use latest stable version
  typescript: true,
});

// Export webhook secret for webhook verification
export const STRIPE_WEBHOOK_SECRET = process.env.STRIPE_WEBHOOK_SECRET;
```

### Environment Variables

```env
# Stripe Configuration
STRIPE_SECRET_KEY=sk_test_xxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxx
```

## Implementation Notes

- Use the latest stable Stripe API version
- Enable TypeScript support for better type safety
- Validate that required environment variables are present
- Export webhook secret for webhook verification (Milestone 3)
- Consider adding Stripe API version configuration (future enhancement)
- Document which Stripe account mode (test/live) is being used

## Related Documentation

- [Implementation & Getting Started](../../docs/implementation-getting-started/index) - Stripe Connect setup
- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Payment processing

## Dependencies

- **CORE-1.5** - Environment variables must be set up (from Epic 1)

## Testing

- [ ] Verify Stripe package is installed correctly
- [ ] Test that Stripe client can be imported without errors
- [ ] Verify environment variables are read correctly
- [ ] Test application startup with valid Stripe configuration
- [ ] Verify application fails gracefully with missing Stripe configuration
- [ ] Test Stripe client initialization with invalid key (should handle errors)
