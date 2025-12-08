---
title: "Admin Plan Management"
description: "Hub for managing subscription plans, pricing, and add-ons through Stripe Dashboard"
last_modified_date: "2025-12-04"
level: "2"
persona: "Platform Administrators"
status: "ACTIVE"
category: "Admin"
---

# Admin Plan Management

**Manage subscription plans, pricing tiers, and add-ons directly through Stripe Dashboard.**

---

## Overview

Plan Management enables platform administrators to control subscription products for PenguinMails tenants through the **Stripe Dashboard**. PenguinMails syncs plan data from Stripe and provides convenient links to Stripe for administration.

### Stripe-First Approach

- **Source of Truth**: All plan creation, pricing, and product configuration happens in Stripe Dashboard
- **Automatic Sync**: PenguinMails syncs plan metadata from Stripe to support feature gating
- **Quick Access Links**: Direct navigation from PenguinMails admin UI to relevant Stripe Dashboard pages
- **Feature Limits**: Configure tenant limits (emails/month, domains, users) after syncing from Stripe

---

## Plan Management Features

### [Creating Subscription Plans](/docs/features/admin/finance/creating-plans)

Launch new subscription tiers by creating products in Stripe Dashboard and configuring feature limits in PenguinMails.

**Key Topics**:

- Creating products in Stripe Dashboard
- Syncing plans to PenguinMails
- Configuring feature limits and tenant quotas
- Best practices for naming and pricing

---

### [Managing Plan Lifecycle](/docs/features/admin/finance/managing-plan-lifecycle)

Control plan visibility and availability while preserving existing customer subscriptions.

**Key Topics**:

- Activating and deactivating plans
- Archiving legacy plans
- Updating plan pricing
- Migrating customers between plans

---

### [Product Add-Ons](/docs/features/admin/finance/product-add-ons)

Create and manage additional purchasable features that extend base subscription plans.

**Key Topics**:

- Creating add-ons in Stripe (e.g., Private IP, Priority Support)
- Pricing models (recurring, metered, one-time)
- Add-on availability rules
- Common add-on types and examples

---

## Quick Reference

### Common Tasks

| Task | Action |
|------|--------|
| Create new plan | Click "Manage Plans in Stripe" → Create Product → Sync to PenguinMails |
| Archive old plan | Click "Manage in Stripe" → Archive Product → Auto-syncs to "Inactive" |
| Update pricing | Add new Price in Stripe → Set as default → Archive old price |
| Create add-on | Click "Create Add-On in Stripe" → Create Product → Sync → Configure availability |

### Integration Points

- **Stripe Connection**: Plans store `stripe_product_id` to generate correct Checkout links
- **Feature Gating**: Application checks `subscription.plan.max_emails_per_month` to enforce limits
- **Sync Behavior**: Automatic sync every 6 hours, or manual trigger via admin UI

---

## Related Documentation

- **[Finance Overview]()**: Revenue tracking and financial analytics
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical payment processing details
- **[Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure for plans and subscriptions
- **[Admin Route Spec](/docs/design/routes/platform-admin#plan-management)**: UI specification for management interface
