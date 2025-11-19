---
title: "Epic 4: Billing, Plans, & Subscriptions"
description: "Documentation for Epic 4: Billing, Plans, & Subscriptions - README"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# Epic 4: Billing, Plans, & Subscriptions

**Last Updated:** October 27, 2025  
**Status:** Not Started  
**Epic ID:** BILL-EPIC-4

## Overview

### Objective

To integrate Stripe as our payment processor to manage the entire billing lifecycle. This includes defining subscription plans, allowing tenants to subscribe to a plan, handling payments, and reflecting the subscription status and features within our application.

### Description

This epic is the monetization engine of the platform. We will build the infrastructure to turn PenguinMails into a commercial product. The work involves creating the database schemas for plans and subscriptions, building API endpoints to interact with the Stripe API, and creating a secure webhook to keep our system's state synchronized with Stripe's billing events. By the end of this epic, a tenant will be able to view pricing, choose a plan, pay for it, and have their subscription status correctly managed by the system.

### Prerequisites

**Epic 1, 2, & 3 must be fully completed.** This includes:

- ✅ A fully functional multi-tenant system where users can create and manage tenants
- ✅ A Stripe account must be created, and API keys (Publishable and Secret) must be available
- ✅ Products and Prices must be configured in the Stripe Dashboard to correspond with our plans

## Milestones

1. **[Milestone 1: Plans and Subscriptions Schema Setup](./milestone-1-plans-subscriptions-schema/)** - Prepare our database to store all necessary billing-related information
2. **[Milestone 2: Stripe Checkout Integration](./milestone-2-stripe-checkout-integration/)** - Allow a user to select a plan and complete a payment through Stripe-hosted checkout
3. **[Milestone 3: Subscription State Synchronization with Webhooks](./milestone-3-subscription-state-synchronization/)** - Reliably receive and process billing events from Stripe to keep subscription data in sync

## Context & Alignment

This epic implements the billing infrastructure that aligns with:

- **Business Model:** From [Goals & Competitive Edge](../docs/goals-competitive-edge/index), PenguinMails uses a B2B SaaS subscription model with multi-tier pricing
- **Implementation Roadmap:** This epic supports the Q4 2025 MVP Launch phase from [Roadmap & Development Priorities](../docs/quick-access/roadmap-development-priorities)
- **Subscription Tiers:** From [Implementation & Getting Started](../docs/implementation-getting-started/index), the platform offers Starter ($99/month), Professional ($299/month), and Enterprise (custom pricing) plans
- **Stripe Connect:** The [Implementation & Getting Started](../docs/implementation-getting-started/index) document outlines the Stripe Connect integration for B2B billing

## Success Criteria

- ✅ Billing schemas created and migrated
- ✅ Plans seeded in database
- ✅ Stripe integration configured
- ✅ Users can view plans and pricing
- ✅ Users can subscribe through Stripe Checkout
- ✅ Webhooks synchronize subscription state
- ✅ Users can manage subscriptions via Stripe Customer Portal
- ✅ All billing operations properly scoped to tenant context

---

*For detailed ticket information, navigate to the individual milestone folders above.*
