---
title: "Managing Plan Lifecycle"
description: "How to activate, deactivate, and archive subscription plans"
last_modified_date: "2025-12-04"
level: "3"
persona: "Platform Administrators"
status: "ACTIVE"
category: "Admin"
---

# Managing Plan Lifecycle

**Control plan visibility and availability while preserving existing customer subscriptions.**

---

## Overview

Plan lifecycle management allows you to control which subscription plans are available for new customers while maintaining existing subscriptions. All lifecycle operations are performed in **Stripe Dashboard** and automatically sync to PenguinMails.

### Lifecycle States

- **Active**: Plan is visible and available for new subscriptions
- **Inactive/Archived**: Plan is hidden from new customers but existing subscriptions continue normally
- **Deleted**: Plan is permanently removed (not recommended - use archiving instead)

---

## Deactivating a Plan

### User Story: Operations Admin
>
> *"I need to sunset the 'Legacy Basic' plan but keep it working for current customers."*

### Workflow

1. **Access Plan in Stripe**
   - Go to PenguinMails Admin > Plans
   - Locate "Legacy Basic" plan
   - Click **"Manage in Stripe"** (opens specific product in Stripe Dashboard)

2. **Archive Product in Stripe**
   - In Stripe Dashboard: Click **"Archive product"**
   - Confirm the action
   - **Effect**: Prevents new subscriptions while maintaining existing ones

3. **Verify in PenguinMails**
   - Return to PenguinMails Admin > Plans
   - The plan automatically shows as **"Inactive"** after sync
   - Existing customers with this plan continue billing normally

4. **Result**
   - New users cannot subscribe to "Legacy Basic"
   - Plan is hidden from pricing page and checkout flows
   - Current "Legacy Basic" subscribers are unaffected

---

## Reactivating a Plan

### Workflow

1. **Unarchive in Stripe**
   - Go to Stripe Dashboard > Products
   - Filter to show "Archived" products
   - Select the plan to reactivate
   - Click **"Unarchive product"**

2. **Sync to PenguinMails**
   - Return to PenguinMails Admin > Plans
   - Click **"Sync Plans from Stripe"**
   - The plan now shows as **"Active"**

3. **Result**
   - Plan is available for new subscriptions
   - Appears in pricing page and checkout flows

---

## Updating Plan Pricing

### Important: Stripe Pricing Model

Stripe uses **immutable prices**. You cannot edit the price of an existing Price object. Instead:

### Workflow for Price Changes

1. **Create New Price in Stripe**
   - Go to Stripe Dashboard > Product
   - Click **"Add another price"**
   - Enter new amount (e.g., increase from $49 to $59)
   - Save the new price

2. **Set as Default Price**
   - Mark the new price as the **default price** for the product
   - Archive the old price (prevents new subscriptions at old rate)

3. **Existing Customers**
   - Existing subscriptions **continue at their original price**
   - To migrate existing customers, use Stripe's subscription update API or manual migration

4. **Sync to PenguinMails**
   - Trigger sync in PenguinMails Admin > Plans
   - New pricing displays in checkout flows

---

## Best Practices

### Sunsetting Plans

- **Always archive, never delete** - preserves historical data and existing subscriptions
- Communicate with affected customers before archiving popular plans
- Consider offering migration incentives to newer plans

### Pricing Updates

- Grandfather existing customers at old pricing to maintain goodwill
- Provide advance notice (30-60 days) for any forced price migrations
- Use Stripe price metadata to track pricing history

### Plan Versioning

- Create new products for major plan changes (e.g., "Pro v2") rather than modifying existing ones
- Use Stripe metadata to link related plan versions

---

## Common Scenarios

### Scenario: Limited-Time Promotion

**Goal**: Offer "Pro Plan" at $39/month for Q4, normally $49/month

**Approach**:

1. Add a new price ($39/month) to the "Pro Plan" product in Stripe
2. Set metadata: `promotion: "Q4_2025"`
3. Set as default price for duration of promotion
4. After promotion ends: Archive promotional price, restore original price as default

### Scenario: Plan Migration

**Goal**: Move all "Basic" customers to "Starter" plan

**Approach**:

1. Archive "Basic" plan in Stripe
2. Use Stripe API or Dashboard to update subscriptions individually
3. Communication: Email affected customers with migration details
4. Consider offering discount or bonus features for disruption

---

## Technical Details

### Sync Behavior

- **Archived Status**: Syncs automatically within 6 hours or via manual trigger
- **Database Field**: `plans.status` reflects Stripe archive state
- **Subscriptions**: Existing `subscriptions.plan_id` references remain valid even after archiving

### Feature Gating Impact

- Archived plans **still enforce feature limits** for existing subscribers
- Application checks `subscription.plan.max_emails_per_month` regardless of plan status

---

## Related Documentation

- **[Creating Plans](/docs/features/admin/finance/creating-plans)**: How to create new subscription plans
- **[Product Add-Ons](/docs/features/admin/finance/product-add-ons)**: Managing additional purchasable features
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical webhook handling
- **[Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure
