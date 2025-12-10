---
title: "Payment & Billing Overview Dashboard"
description: "Admin dashboard views for subscription status monitoring"
---

# Payment & Billing Overview Dashboard

## Overview

**Priority**: P0 (MVP blocker)
**Effort**: Small (3-4 days)
**Status**: Not Started

**Description**:
Build admin dashboard views for subscription status monitoring using existing OLTP data with links to Stripe Dashboard.

**Features**:

- **Tenant Subscription Section**: Current status, next billing date, deep links to Stripe.
- **Subscriptions List View**: List all tenant subscriptions, filter by status, "due soon" calculation.
- **Subscription Summary**: Active count, plan distribution, Stripe webhook status.

**Philosophy**:
Present only basic subscription counts from OLTP. Link to Stripe Dashboard for all revenue analytics.

**Dependencies**:

- OLTP database
- Stripe API integration
- Stripe Dashboard access
