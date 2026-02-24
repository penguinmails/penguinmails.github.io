---
title: "Stripe Connect Integration"
description: "Technical architecture and API specifications for Stripe Connect and billing systems."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

## Technical Architecture

PenguinMails follows an OLTP-first architecture with NileDB for metadata and Stripe for financial processing.

### Account Creation Flow

The system automates account provisioning via `POST /api/stripe/connect`.

```typescript
// API Logic Example
export async function createStripeConnectAccount(companyId: string, billingEmail?: string) {
  // 1. Check existing config in tenant_config
  // 2. Create Stripe Connect Express account
  const account = await stripe.accounts.create({
    type: 'express',
    capabilities: {
      card_payments: { requested: true },
      transfers: { requested: true },
    },
  });
  // 3. Persist stripe_account_id to NileDB
}
```

### Database Schema

Minimal changes required to `tenant_config` to track Stripe metadata.

```sql
ALTER TABLE tenant_config ADD COLUMN stripe_account_id VARCHAR(255) UNIQUE;

-- Other relevant tables:
-- subscriptions: Lifecycle management
-- payments: Transaction history
-- plans: Tier definitions and limits
```

### Webhook Integration

Endpoint: `POST /api/webhooks/stripe`

- **Account Updates**: Syncs business verification status.
- **Capability Updates**: Handles payment capability locks/unlocks.
- **Payment Events**: Updates `payments` table on success or failure.

---

## Onboarding Link Generation

Users are redirected to Stripe-hosted onboarding via `GET /api/stripe/connect/onboarding-link`. The `refresh_url` and `return_url` are configured to navigate back to the PenguinMails billing dashboard.
