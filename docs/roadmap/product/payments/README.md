---
title: "Billing & Subscriptions Roadmap"
description: "Roadmap for billing, subscriptions, and payment features"
last_modified_date: "2025-12-09"
level: "2"
persona: "Product Team, Development Team"
parent: "/docs/roadmap/product/README.md"
---

# Billing & Subscriptions Roadmap

## Overview

This document provides a detailed timeline for billing and subscription feature development, organized by quarter with effort estimates and priorities.

**Current Status:** Partially Complete (Core infrastructure functional, 7 MVP gaps)

## MVP Roadmap Items (Q1 2026)

### Critical Blockers

* **[Plan Upgrade/Downgrade UI Flow](plan-upgrade-downgrade.md)** (P0): Complete user interface for changing subscription plans.
* **[Usage Tracking Dashboard Implementation](usage-tracking-dashboard.md)** (P0): Real-time usage monitoring dashboard.
* **[Failed Payment Recovery Flow](failed-payment-recovery.md)** (P0): Workflow for recovering from failed payments.

### High Priority

* **[Invoice Access via Stripe](invoice-access.md)** (P1): Invoice list display with links to Stripe Customer Portal.
* **[Payment Method Management UI](payment-method-management.md)** (P1): In-app payment method management using Stripe Elements.
* **[Subscription Cancellation Flow](subscription-cancellation.md)** (P1): User-friendly cancellation process with retention offers.

### Medium Priority

* **[Budget Controls and Spending Limits](budget-controls.md)** (P2): Budget limit configuration with alert thresholds.

## Post-MVP Roadmap (Q2 2026 - Q4 2026)

### Q2 2026: Enterprise Features

* **[Custom Pricing and Enterprise Billing](custom-pricing.md)** (P1): Flexible pricing engine for enterprise customers.
* **[Flexible Payment Options and Installments](flexible-payment-options.md)** (P2): Alternative payment methods (ACH, wire, PO) and installments.

### Q3 2026: International & Advanced

* **[Multi-Currency Support](multi-currency-support.md)** (P1): Support for multiple currencies and local payment methods.
* **[Referral Credits and Promotional Discounts](referral-credits.md)** (P2): Referral program and discount management system.
* **[Trial Plans Support (Spike Required)](trial-plans-support.md)** (P2): Support for trial plans as a separate plan type.

### Q4 2026: Optimization & Retention

* **[Advanced Usage Analytics and Forecasting](advanced-usage-analytics.md)** (P2): Predictive analytics for usage trends and cost forecasting.
* **[Subscription Pause and Seasonal Plans](subscription-pause.md)** (P2): Allow customers to pause subscriptions temporarily.
* **[Billing Automation and Dunning Management](billing-automation.md)** (P2): Advanced dunning workflows with smart retry logic.
