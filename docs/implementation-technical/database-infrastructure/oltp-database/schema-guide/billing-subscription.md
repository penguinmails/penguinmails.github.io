---
title: "OLTP Schema - Billing & Subscriptions"
description: "Subscription plans, tenant subscriptions, addons, and payment reference schema."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Billing & Subscriptions

## Billing & Subscription Management

### **Subscription Plans**

#### **plans** - Subscription Plan Definitions

```sql
CREATE TABLE plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    max_users INTEGER,
    max_domains INTEGER,
    max_campaigns_per_month INTEGER,
    api_rate_limit INTEGER,
    max_email_accounts INTEGER,
    max_emails_per_month INTEGER,
    max_warmups INTEGER,
    max_contacts INTEGER,
    max_storage_gb INTEGER,
    api_access BOOLEAN DEFAULT FALSE,
    priority_support BOOLEAN DEFAULT FALSE,
    advanced_analytics BOOLEAN DEFAULT FALSE,
    white_label BOOLEAN DEFAULT FALSE,
    price_monthly INTEGER,
    price_yearly INTEGER,
    notes TEXT,  -- Additional plan details and notes
    is_active BOOLEAN DEFAULT TRUE,
    stripe_product_id VARCHAR(255),  -- Stripe Product reference for dashboard/portal links
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Stripe Product integration index
CREATE INDEX idx_plans_stripe_product
    ON plans(stripe_product_id)
    WHERE stripe_product_id IS NOT NULL;
```

##### Stripe Product Integration

The `stripe_product_id` field links PenguinMails plans to Stripe Products for billing management:

**Purpose**:

- Enables "View Plan in Stripe" or "Manage Subscription" redirects to Stripe Dashboard
- Product ID remains stable even when prices change in Stripe
- Links to Stripe Customer Portal for self-service billing

**Why NOT storing `stripe_price_id`**:

- Stripe manages all pricing via Checkout and Customer Portal
- PenguinMails UI displays `price_monthly` and `price_yearly` from local database  
- When user clicks "Subscribe" or "Change Plan", redirects to Stripe Checkout
- Stripe handles price selection, proration calculations, and payment collection
- **Single source of truth for prices**: Stripe

**Admin Workflow**:

1. Create Stripe Product via Stripe Dashboard
2. Create Prices (monthly, yearly) for the Product in Stripe
3. Copy Product ID into `plans.stripe_product_id` field
4. Set `is_active = true` to make plan available for purchase

##### Plan Lifecycle with `is_active`

The `is_active` field provides flexible plan management for seasonal and exclusive offerings:

**Active Plans** (`is_active = true`):

- Visible in tenant purchase/upgrade options
- Available for new subscriptions
- Default state for standard plans

**Inactive Plans** (`is_active = false`):

- **Hidden** from purchase UI
- **Existing subscribers can still renew** and maintain their subscription
- Provides exclusive access to grandfathered customers

---

#### **subscriptions** - Active Tenant Subscriptions

```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    plan_id UUID REFERENCES plans(id),
    pending_plan_id UUID REFERENCES plans(id),
    status VARCHAR(50) CHECK (status IN ('active', 'past_due', 'canceled', 'unpaid')),
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    cancel_at_period_end BOOLEAN DEFAULT FALSE,
    cancel_reason TEXT,  -- User-provided cancellation reason
    cancel_date TIMESTAMP WITH TIME ZONE,  -- When cancellation was initiated
    billing_contact_user_id UUID REFERENCES users(id),
    stripe_subscription_id VARCHAR(255),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **subscription_addons** - Additional Features

```sql
CREATE TABLE subscription_addons (
    id VARCHAR(255) PRIMARY KEY,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    addon_type VARCHAR(50) NOT NULL,
    quantity INTEGER DEFAULT 1,
    price_monthly DECIMAL(10,2),
    stripe_price_id VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **payments** - Payment Reference Records

> [!IMPORTANT]
> **OLTP Constraint:** This table stores **minimal payment references only**.
> For full payment details, transaction history, and accounting reconciliation, use the **Stripe Dashboard** or Stripe API.

```sql
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    initiated_by_user_id UUID REFERENCES users(id),  -- For audit trail
    amount DECIMAL(10,2) NOT NULL,                    -- Minimal copy for quick display
    currency VARCHAR(3) DEFAULT 'USD',                -- Minimal copy for quick display
    status VARCHAR(20) NOT NULL,                      -- succeeded, failed, refunded
    processed TIMESTAMP WITH TIME ZONE,               -- When payment completed
    description TEXT,                                 -- Brief description
    stripe_payment_intent_id VARCHAR(255),            -- KEY: Link to Stripe Dashboard
    billing_period_start TIMESTAMP WITH TIME ZONE,    -- Subscription period reference
    billing_period_end TIMESTAMP WITH TIME ZONE,      -- Subscription period reference
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
