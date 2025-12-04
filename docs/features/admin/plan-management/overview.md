---
title: "Admin Plan Management"
description: "Feature documentation for managing subscription plans and pricing in PenguinMails"
last_modified_date: "2025-12-02"
level: "2"
persona: "Platform Administrators"
status: "ACTIVE"
category: "Admin"
---

# Admin Plan Management

**Centralized control for subscription plans, pricing tiers, and feature limits.**

---

## Overview

The Plan Management feature allows platform administrators to define and manage the subscription products available to PenguinMails tenants. It serves as the bridge between Stripe's billing engine and PenguinMails' internal feature gating logic.

### Key Capabilities

- **Plan Definition**: Create and update plans with specific feature limits (e.g., "Pro Plan" with 50k emails/month).
- **Stripe Mapping**: Link internal plans to Stripe Products for seamless checkout flows.
- **Lifecycle Control**: Activate or deactivate plans to control their visibility in the purchase UI without affecting existing subscribers.
- **Pricing Display**: Manage displayed pricing (monthly/yearly) for marketing and comparison tables.

---

## User Stories

### Product Manager
>
> *"I want to launch a new 'Enterprise Starter' plan for Q4, so I can target mid-market customers."*
>
> **Workflow**:
>
> 1. Create Product & Price in Stripe Dashboard.
> 2. Go to PenguinMails Admin > Plans > New.
> 3. Enter details and paste Stripe Product ID.
> 4. Set limits (e.g., 10 users, 5 domains).
> 5. Set Status to "Active".

### Operations Admin
>
> *"I need to sunset the 'Legacy Basic' plan but keep it working for current customers."*
>
> **Workflow**:
>
> 1. Go to PenguinMails Admin > Plans.
> 2. Find "Legacy Basic".
> 3. Toggle Status to "Inactive".
> 4. Result: New users can't see it; existing users continue billing normally.

---

## Integration Architecture

### Stripe Connection

- **Source of Truth**: Stripe handles the actual billing, charging, and subscription state.
- **Reference**: Plans in PenguinMails store a `stripe_product_id` to generate correct Checkout links.
- **Pricing**: While Stripe controls the actual charge amount, PenguinMails stores `price_monthly` and `price_yearly` for display purposes (e.g., pricing tables).

### Feature Gating

- The `plans` table acts as the configuration source for tenant limits.
- When a tenant subscribes, their `subscription` record links to a `plan`.
- The application checks `subscription.plan.max_emails_per_month` to enforce usage limits.

---

## Related Documentation

- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical details on payment processing.
- **[Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema/overview)**: Database structure for plans and subscriptions.
- **[Admin Route Spec](/docs/design/routes/platform-admin#plan-management)**: UI specification for the management interface.
