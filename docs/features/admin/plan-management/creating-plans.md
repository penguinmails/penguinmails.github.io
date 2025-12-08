---
title: "Creating Subscription Plans"
description: "How to create new subscription plans in Stripe for PenguinMails tenants"
last_modified_date: "2025-12-04"
level: "3"
persona: "Platform Administrators"
status: "ACTIVE"
category: "Admin"
---

# Creating Subscription Plans

**Launch new subscription tiers by creating products in Stripe Dashboard and syncing to PenguinMails.**

---

## Overview

All subscription plans for PenguinMails are created and managed directly in the **Stripe Dashboard**. PenguinMails syncs plan metadata from Stripe and uses it for feature gating and tenant limits.

### Stripe-First Approach

- **Source of Truth**: Stripe Dashboard is where all products, prices, and billing configuration live.
- **Automatic Sync**: PenguinMails periodically syncs plan data from Stripe (or can be manually triggered).
- **Feature Limits**: After creating a plan in Stripe, configure tenant limits (emails/month, domains, users) in PenguinMails.

---

## Creating a New Plan

### User Story: Product Manager
>
> *"I want to launch a new 'Enterprise Starter' plan for Q4, so I can target mid-market customers."*

### Workflow

1. **Access Stripe Dashboard**
   - Go to PenguinMails Admin > Plans
   - Click **"Manage Plans in Stripe"** (opens Stripe Dashboard in new tab)

2. **Create Product in Stripe**
   - In Stripe Dashboard: Navigate to Products > Add Product
   - Enter product details:
     - **Name**: "Enterprise Starter"
     - **Description**: "Perfect for growing teams"
     - **Pricing**: Add monthly price (e.g., $99/month) and/or yearly price (e.g., $999/year)
   - Save the product

3. **Return to PenguinMails**
   - Go back to PenguinMails Admin > Plans
   - Click **"Sync Plans from Stripe"** (or wait for automatic sync)

4. **Configure Feature Limits**
   - Locate the newly synced "Enterprise Starter" plan
   - Click **"Edit Limits"**
   - Set tenant limits:
     - Max emails per month: `100,000`
     - Max domains: `5`
     - Max team members: `10`
     - Enable advanced features (if applicable)
   - Save configuration

5. **Verify Availability**
   - The plan is now available for tenant subscriptions
   - Appears in pricing page and checkout flows

---

## Plan Configuration Fields

### Stripe Fields (Managed in Stripe)

- **Product Name**: Display name for the plan
- **Description**: Marketing copy for the plan
- **Pricing**: Monthly/yearly amounts and currency
- **Metadata**: Custom key-value pairs for integration

### PenguinMails Fields (Configured After Sync)

- **Max Emails/Month**: Hard limit for sending volume
- **Max Domains**: Number of custom domains allowed
- **Max Team Members**: Number of users per tenant
- **Advanced Features**: Email validation, A/B testing, etc.
- **Status**: Active/Inactive (controlled by Stripe archive status)

---

## Best Practices

### Naming Conventions

- Use clear, marketing-friendly names: "Starter", "Pro", "Enterprise"
- Avoid technical jargon in product names
- Keep descriptions concise and benefit-focused

### Pricing Strategy

- Always offer both monthly and yearly options
- Apply yearly discount (e.g., 2 months free when paid annually)
- Use rounded numbers for psychological pricing ($99 vs $97.50)

### Feature Limits

- Set conservative limits initially - easier to increase than decrease
- Align limits with value proposition (e.g., "Pro" should have 10x "Starter" limits)
- Monitor usage patterns to adjust limits over time

---

## Technical Details

### Stripe Product ID Mapping

- Each synced plan stores a `stripe_product_id` reference
- Used to generate correct Checkout Session links
- Ensures billing happens against the correct Stripe Product

### Sync Behavior

- **Automatic**: Runs every 6 hours via background job
- **Manual**: Triggered via "Sync Plans" button in admin UI
- **On Webhook**: Stripe webhooks can trigger immediate sync for product updates

---

## Related Documentation

- **[Managing Plan Lifecycle](/docs/features/admin/finance/managing-plan-lifecycle)**: Activating, deactivating, and archiving plans
- **[Product Add-Ons](/docs/features/admin/finance/product-add-ons)**: Creating additional purchasable features
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical details on payment processing
- **[Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure for plans
