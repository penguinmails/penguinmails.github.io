---
title: "Product Add-Ons"
description: "Managing additional purchasable features and services for PenguinMails tenants"
last_modified_date: "2025-12-04"
level: "3"
persona: "Platform Administrators"
status: "ACTIVE"
category: "Admin"
---

# Product Add-Ons

**Create and manage additional purchasable features that extend base subscription plans.**

---

## Overview

Product add-ons allow tenants to purchase additional features or services beyond their base subscription plan. Examples include private IPs, priority support, extra sending capacity, or premium integrations.

### Add-On vs. Plan Upgrade

- **Add-On**: Supplementary feature purchased alongside base plan (e.g., "Private IP")
- **Plan Upgrade**: Moving to a higher-tier plan with more inclusive features (e.g., "Starter" → "Pro")

Add-ons are ideal for:

- Features that only a subset of customers need
- Services with variable pricing
- Optional enhancements that don't justify a full plan tier

---

## Creating an Add-On

### User Story: Product Manager
>
> *"We're launching a new add-on: 'Private IP for Custom Domain' for $25/month."*

### Workflow

1. **Access Stripe Dashboard**
   - Go to PenguinMails Admin > Add-Ons (or Products)
   - Click **"Create Add-On in Stripe"** (opens Stripe Dashboard)

2. **Create Product in Stripe**
   - In Stripe Dashboard: Products > Add Product
   - Enter add-on details:
     - **Name**: "Private IP for Custom Domain"
     - **Description**: "Dedicated IP address for improved deliverability"
     - **Pricing**: $25/month (recurring)
     - **Metadata**: Add `type: "addon"` and `category: "deliverability"`
   - Save the product

3. **Configure in PenguinMails**
   - Return to PenguinMails Admin > Add-Ons
   - Click **"Sync Products from Stripe"**
   - Locate the new "Private IP for Custom Domain" add-on
   - Configure additional settings:
     - **Availability**: Which plans can purchase this add-on
     - **Limits**: Max quantity per tenant (e.g., 1 private IP)
     - **Category**: Organize in add-on catalog (Deliverability, Support, Capacity, etc.)

4. **Publish**
   - Set status to **"Active"**
   - Add-on appears in tenant's purchase/upgrade UI
   - Tenants can now add this to their subscription

---

## Common Add-On Types

### Deliverability Add-Ons

- **Private IP**: Dedicated IP address ($25-50/month)
- **Email Validation**: Real-time email validation on upload ($0.005/validation)
- **Advanced Warmup**: AI-powered warmup scheduler ($15/month)

#### Private IP Lifecycle

**When Purchased:**

- Dedicated IP assigned from PenguinMails IP pool
- Domains can be configured to send from private IP
- IP reputation isolated from other tenants

**If Not Renewed:**

- Private IP released back to pool
- Domains automatically fall back to default shared VPS IP
- Email sending continues without interruption
- Deliverability may be affected (shared IP reputation)

> [!NOTE]
> Tenant receives email notification 7 days before IP add-on expires with option to renew.

### Capacity Add-Ons

- **Extra Email Credits**: Additional sending volume beyond plan limit ($5 per 10k emails)
- **Additional Domains**: More custom domains ($10 per domain/month)
- **Team Member Seats**: Additional user seats ($5 per user/month)

### Support Add-Ons

- **Priority Support**: Faster response times ($50/month)
- **Dedicated Account Manager**: Personal onboarding and support ($500/month)
- **Custom Integration**: One-time setup for specific CRM/API ($1000 one-time)

### Premium Features

- **White Label**: Remove PenguinMails branding ($100/month)
- **Advanced Analytics**: Custom reports and data exports ($30/month)
- **API Access**: Programmatic access to platform ($20/month)

---

## Pricing Models for Add-Ons

### Recurring (Subscription)

- Charged monthly or annually alongside base plan
- Example: Private IP at $25/month
- **Stripe Setup**: Create recurring Price on Product

### Metered (Usage-Based)

- Charged based on actual usage
- Example: Email validation at $0.005 per email
- **Stripe Setup**: Create metered Price on Product, report usage via API

### One-Time

- Single payment for permanent access or setup
- Example: Custom integration at $1000
- **Stripe Setup**: Create one-time Price on Product

### Quantity-Based

- Price scales with quantity purchased
- Example: Extra team member seats at $5 per seat/month
- **Stripe Setup**: Enable `quantity` on recurring Price

---

## Add-On Configuration

### Stripe Fields (Managed in Stripe)

- **Product Name**: Display name for the add-on
- **Description**: Benefits and use case
- **Pricing Model**: Recurring, metered, one-time, or quantity-based
- **Metadata**: Custom fields for categorization and logic

### PenguinMails Fields (Configured After Sync)

- **Category**: Deliverability, Support, Capacity, Premium
- **Plan Availability**: Which base plans can purchase this add-on
- **Max Quantity**: Limit per tenant (e.g., max 3 private IPs)
- **Status**: Active/Inactive
- **Display Order**: Position in add-on catalog

---

## Managing Add-On Lifecycle

### Activating an Add-On

1. Create product in Stripe
2. Sync to PenguinMails
3. Configure availability and limits
4. Set status to "Active"

### Deactivating an Add-On

1. Archive product in Stripe Dashboard
2. Sync to PenguinMails (status updates to "Inactive")
3. New customers cannot purchase
4. Existing customers with add-on continue billing

### Updating Add-On Pricing

- Same rules as plan pricing: Create new Price in Stripe, set as default
- Existing customers continue at original price unless manually migrated

---

## Technical Details

### Subscription Model

- Add-ons are tracked as separate Stripe Subscription Items
- Each add-on has its own line item in the invoice
- Can be added/removed independently from base plan

### Database Schema

- `subscriptions` table links to `plans` (base plan)
- Add-ons stored in `subscription_items` or metadata
- Stripe manages billing; PenguinMails enforces feature access

### Feature Gating

- Application checks `subscription.addons` to enable features
- Example: `if (subscription.has_addon('private_ip')) { enablePrivateIP() }`

---

## Best Practices

### Pricing Strategy

- Price add-ons relative to base plans (add-on shouldn't exceed plan cost)
- Use psychological pricing ($25 vs $24.99)
- Offer bundles (e.g., "Deliverability Bundle" with multiple add-ons at discount)

### Availability Rules

- Don't offer add-ons that conflict with plan features (e.g., "Extra domains" add-on on "Unlimited" plan)
- Higher-tier plans might include add-ons for free
- Use metadata to track which plans get which add-ons included

### Customer Communication

- Clearly explain what the add-on provides
- Show ROI or use cases (e.g., "Private IP improves deliverability by 15%")
- Offer trial periods for expensive add-ons

---

## Related Documentation

- **[Creating Plans](./creating-plans.md)**: How to create base subscription plans
- **[Managing Plan Lifecycle](./managing-plan-lifecycle.md)**: Activating and archiving products
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical payment processing
- **[Billing Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure
