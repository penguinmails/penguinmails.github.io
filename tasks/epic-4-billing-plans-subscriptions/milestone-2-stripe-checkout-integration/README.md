
# Milestone 2: Stripe Checkout Integration

**Goal:** To allow a user to select a plan and complete a payment through a secure, Stripe-hosted checkout page.

## Tickets

- [BILL-2.1](./BILL-2.1-install-configure-stripe) - Install and Configure Stripe Node.js SDK
- [BILL-2.2](./BILL-2.2-get-or-create-stripe-customer) - Implement "Get or Create Stripe Customer" Logic
- [BILL-2.3](./BILL-2.3-create-checkout-session-endpoint) - Create API Endpoint for Stripe Checkout Session (POST /api/subscriptions/checkout)

## Dependencies

- **Milestone 1** must be completed
- Requires Stripe account and API keys
- Requires Stripe products and prices configured

## Success Criteria

- ✅ Stripe SDK installed and configured
- ✅ Customer creation logic working
- ✅ Checkout session creation working
- ✅ Users can initiate subscription checkout
- ✅ All operations properly scoped to tenant context

## Context

This milestone implements the payment flow. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index), Stripe Connect is used for B2B billing. This milestone enables users to subscribe to plans through Stripe's secure checkout.
