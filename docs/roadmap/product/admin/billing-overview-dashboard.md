---
title: "Payment & Billing Overview Dashboard"
description: "Build admin dashboard views for subscription status monitoring"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams"
parent: "/docs/roadmap/product/admin/README.md"
---

# Payment & Billing Overview Dashboard

## Overview

**Priority**: P0 (MVP blocker)
**Timeline**: Q1 2026 (3-4 days)
**Effort**: Small

**Description**:
Build admin dashboard views for subscription status monitoring using existing OLTP data with links to Stripe Dashboard.

## Features

- **Tenant Subscription Section**:
  - Display current subscription status
  - Show next billing date
  - Last payment status
  - "View Subscription in Stripe" deep link

- **Subscriptions List View**:
  - List all tenant subscriptions
  - Calculate "due soon" status
  - Filter by status
  - Search by tenant name

- **Subscription Summary**:
  - Active subscription count
  - Plan distribution
  - Stripe webhook status
  - "View MRR in Stripe Dashboard" button

## Dependencies

- OLTP database: `subscriptions`, `payments`, `plans`, `tenants`
- Stripe API integration (read-only)
- Stripe Dashboard access
