---
title: "Stripe Integration"
description: "Stripe payment processing for secure subscription billing in PenguinMails"
last_modified_date: "2025-11-24"
level: "2"
persona: "Developers, Billing Administrators"
status: "ACTIVE"
category: "Payments"
---


# Stripe Integration

**Secure, PCI-compliant payment processing powered by Stripe.**

---

## Overview

PenguinMails uses [Stripe](https://stripe.com) as our payment processor to handle all subscription billing, ensuring secure, reliable, and compliant payment processing.

### Why Stripe?

- **Security** - PCI DSS Level 1 compliant (highest security standard)

- **Global** - Supports 135+ currencies and payment methods

- **Reliable** - 99.99% uptime SLA

- **No Card Storage** - PenguinMails never stores card details

- **Fraud Protection** - Advanced fraud detection built-in

- **Developer-Friendly** - Robust API and webhooks

---

## Level 1: Payment Flow

### How Payments Work

```text
User Signs Up
  ↓
Redirect to Stripe Checkout
  ↓
User Enters Payment Info (on Stripe's secure page)
  ↓
Stripe Processes Payment
  ↓
Stripe Sends Webhook to PenguinMails
  ↓
Subscription Activated
  ↓
User Redirected to Dashboard


```

**Security:** Card details never touch PenguinMails servers - all handled by Stripe.

---

### Stripe Checkout

**Hosted checkout page** for seamless payment experience.

#### Checkout Features

- ✅ **Mobile-optimized** - Perfect on any device

- ✅ **Multiple payment methods** - Credit/debit cards,Apple Pay, Google Pay

- ✅ **Localized** - Available in 25+ languages

- ✅ **Tax calculation** - Automatic tax computation

- ✅ **Saved payment methods** - Quick checkout for returning users

#### Implementation

```javascript
// Create Checkout Session
POST /api/v1/billing/checkout
Authorization: Bearer {api_key}

{
  "plan": "professional",
  "billing_cycle": "monthly",
  "success_url": "https://app.penguinmails.com/billing/success",
  "cancel_url": "https://app.penguinmails.com/billing/cancel"
}

Response:
{
  "checkout_url": "https://checkout.stripe.com/c/pay/cs_test_..."
}


```

---

## Level 2: Subscription Management

### Creating Subscriptions

**Automatic subscription creation** via Stripe Checkout.

1. User selects plan

2. Redirected to Stripe Checkout

3. Enters payment information

4. Stripe creates subscription

5. Webhook notifies PenguinMails

6. Subscription activated in database

### Updating Payment Methods

**Update card without subscription interruption.**

**Customer Portal:**

```javascript
POST /api/v1/billing/portal
Authorization: Bearer {api_key}

Response:
{
  "portal_url": "https://billing.stripe.com/p/session/cs_..."
}


```

**Users can:**

- Update payment method

- View billing history

- Download invoices

- Update billing address

---

### Handling Failed Payments

**Automatic retry logic** for declined payments.

#### Retry Schedule

- **Day 0:** Payment fails, email notification sent

- **Day 3:** First retry attempt

- **Day 5:** Second retry attempt

- **Day 7:** Third retry attempt, account suspended

- **Day 14:** Final retry, subscription canceled if fails

**User Actions:**

- Update payment method anytime

- Retry payment manually

- Contact support for assistance

---

## Level 3: Webhooks & Sync

### Stripe Webhooks

**Real-time subscription state sync** via webhooks.

#### Webhook Endpoint

```text
POST https://api.penguinmails.com/webhooks/stripe
Header: stripe-signature: {signature}


```

#### Handled Events

```javascript
// Subscription Events


- customer.subscription.created


- customer.subscription.updated


- customer.subscription.deleted


- customer.subscription.trial_will_end

// Payment Events


- invoice.paid


- invoice.payment_failed


- invoice.payment_action_required

// Customer Events


- customer.updated


- customer.deleted


```

#### Event Processing

```javascript
// Example: Subscription Created
{
  "type": "customer.subscription.created",
  "data": {
    "object": {
      "id": "sub_abc123",
      "customer": "cus_xyz789",
      "status": "active",
      "plan": {
        "id": "price_professional_monthly",
        "amount": 14900 // $149.00 in cents
      },
      "current_period_end": 1735027200
    }
  }
}

// PenguinMails Action:
// 1. Verify webhook signature
// 2. Update tenant subscription status
// 3. Activate features for plan tier
// 4. Send confirmation email
// 5. Log event in audit trail


```

---

### Subscription Status Sync

**Database schema for subscription state:**

```sql
CREATE TABLE tenant_subscriptions (
  id UUID PRIMARY KEY,
  tenant_id UUID REFERENCES tenants(id),
  stripe_customer_id VARCHAR(255) UNIQUE,
  stripe_subscription_id VARCHAR(255) UNIQUE,
  plan_id VARCHAR(50),
  status VARCHAR(20), -- active, past_due, canceled, etc.
  current_period_start TIMESTAMP,
  current_period_end TIMESTAMP,
  cancel_at_period_end BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


```

---

## Billing Dashboard Integration

### Invoices

**Automatic invoice generation** via Stripe.

- **Auto-generated** - Every billing cycle

- **Email delivery** - Sent to billing email

- **PDF download** - Available in customer portal

- **Itemized** - Subscription + usage charges + taxes

### Payment History

**Complete transaction history:**

```javascript
GET /api/v1/billing/payments
Authorization: Bearer {api_key}

Response:
{
  "payments": [
    {
      "id": "pi_abc123",
      "amount": 149.00,
      "currency": "USD",
      "status": "succeeded",
      "description": "Professional Plan - Monthly",
      "created": "2025-11-24T10:30:00Z",
      "receipt_url": "https://stripe.com/receipts/..."
    }
  ]
}


```

---

## Security & Compliance

### PCI Compliance

**PenguinMails is PCI DSS compliant** by using Stripe.

- ✅ **No card data stored** - Stripe handles all card info

- ✅ **Tokenization** - Only store Stripe tokens

- ✅ **Secure transmission** - TLS 1.3 encryption

- ✅ **Annual audits** - Stripe maintains compliance

### SCA (Strong Customer Authentication)

**European regulation compliance** for card payments.

- **3D Secure** - Built into Stripe Checkout

- **Automatic handling** - Stripe manages SCA requirements

- **Fallback methods** - Alternative authentication if needed

---

## Related Documentation

### Payments

- **[Subscription Management](./subscription-management.md)** - Plan details and management

- **[Billing Dashboard](./billing-dashboard.md)** - Usage and invoices

- **[Payments Overview](./README.md)** - All payment features

### Technical

- **[Stripe API Documentation](../../implementation-technical/integration/stripe.md)** - Technical integration details

- **[Webhook Handling](../../implementation-technical/api/platform-api/webhooks.md)** - Webhook implementation

### Support

- **[Billing FAQ](../../business/faq/billing-faq.md)** - Common questions

- **[Contact Support](mailto:support@penguinmails.com)** - Payment issues

---

**Last Updated:** November 24, 2025
**Stripe API Version:** 2023-10-16
**Compliance:** PCI DSS Level 1, SCA compliant

*All payments are processed securely by Stripe. PenguinMails never stores credit card information.*
