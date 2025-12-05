---
title: "Billing & Subscriptions Roadmap"
description: "Payment processing, subscription management, and billing features"
last_modified_date: "2025-12-04"
level: "2"
persona: "Business Operations"
keywords: "billing, subscriptions, payments, stripe integration"
---

# Billing & Subscriptions Roadmap

## Feature Deep Dive: Billing & Subscriptions

### Overview

**Status:** Partially Complete (Core infrastructure functional, 7 MVP gaps)
**Timeline:** Q1 2026 (MVP) → Q2-Q4 2026 (Post-MVP)
**Priority:** Critical (Revenue infrastructure - MVP gaps block launch)

### Current State: Partially Complete

## What's Available Today

- ✅ Multi-tier subscription plans (Starter, Professional, Business, Enterprise)

- ✅ Stripe Checkout integration for secure payment processing

- ✅ Automatic subscription creation and management

- ✅ Prorated upgrades and downgrades

- ✅ Usage tracking (emails, users, workspaces, domains)

- ✅ Automatic invoice generation via Stripe

- ✅ Payment method updates via Stripe Customer Portal

- ✅ Failed payment retry logic (Days 3, 5, 7, 14)

- ✅ Subscription cancellation with 90-day grace period

- ✅ MRR tracking and financial reporting

**Assessment:** Core billing infrastructure is functional, but critical user-facing features are missing. 7 MVP gaps block production readiness.

### MVP Gaps (Q1 2026)

## Critical Missing Features

- **[P0] Plan Upgrade/Downgrade UI Flow** (3-5 days)

  - Plan comparison modal with feature differences

  - Proration preview before confirmation

  - Downgrade validation (usage vs new limits)

  - **Business Impact:** Core monetization feature - users must self-service plan changes

- **[P0] Usage Tracking Dashboard** (4-6 days)

  - Real-time progress bars with color-coded alerts

  - Historical usage charts (6-month trends)

  - CSV export functionality

  - **Business Impact:** Prevents service interruptions, drives upgrade conversions

- **[P1] Invoice Management System** (3-5 days)

  - Direct PDF download from PenguinMails UI

  - Invoice preview modal and search/filtering

  - Bulk download capability

  - **Business Impact:** Professional businesses expect self-service invoice management

- **[P1] Payment Method Management UI** (4-6 days)

  - In-app card updates using Stripe Elements

  - Multiple payment methods support

  - Payment method verification

  - **Business Impact:** Payment failures are major churn driver - easy updates critical

- **[P0] Failed Payment Recovery Flow** (2-3 days)

  - Dashboard banner with failure reason

  - One-click "Update Payment & Retry" button

  - Grace period countdown timer

  - **Business Impact:** Quick recovery prevents service interruption and churn

- **[P1] Subscription Cancellation Flow** (2-3 days)

  - Cancellation reason survey

  - Retention offer modal (discount, pause option)

  - Data export reminder

  - **Business Impact:** Graceful cancellation reduces negative sentiment

- **[P2] Budget Controls** (3-4 days)

  - Budget limit configuration

  - Alert thresholds (80%, 100%)

  - Overage handling options

  - **Business Impact:** Budget-conscious customers need spending controls

**Total MVP Effort:** 21-36 days (4-7 weeks)

### Post-MVP Roadmap (Q2-Q4 2026)

### Q2 2026: Enterprise Features

- **[P1] Custom Pricing and Enterprise Billing** (2-3 weeks)

  - Custom pricing configuration per tenant

  - Volume discount tiers

  - Custom billing cycles (quarterly, annual)

  - Custom payment terms (Net 30, Net 60)

  - Contract management with renewals

  - **Business Impact:** Enables enterprise segment, unlocks $50K+ ARR deals

- **[P2] Flexible Payment Options** (2-3 weeks)

  - ACH direct debit for US customers

  - SEPA direct debit for EU customers

  - Wire transfer instructions

  - Purchase order workflow

  - Installment plans (3, 6, 12 months)

  - **Business Impact:** Enterprise customers require alternative payment methods

### Q3 2026: International & Advan

- **[P1] Multi-Currency Support** (3-4 weeks)

  - Support EUR, GBP, CAD, AUD currencies

  - Local payment methods (SEPA, iDEAL, Bancontact)

  - Currency-specific invoicing with local tax

  - Multi-currency financial reporting

  - **Business Impact:** Enables international expansion, unlocks global markets

- **[P2] Revenue Recognition & Financial Reporting** (3-4 weeks)

  - Automated revenue recognition (ASC 606 / IFRS 15)

  - Deferred revenue tracking

  - Revenue waterfall reports

  - Cohort retention analysis

  - Export to QuickBooks, Xero, NetSuite

  - **Business Impact:** Automated financial reporting for investor/board meetings

- **[P2] Referral Credits & Promotional Discounts** (2-3 weeks)

  - Referral link generation and tracking

  - Account credit system ($50 per referral)

  - Promotional discount codes

  - Discount analytics dashboard

  - **Business Impact:** Referral rewards drive word-of-mouth growth

### Q4 2026: Optimization & Retent

- **[P2] Advanced Usage Analytics & Forecasting** (3-4 weeks)

  - Predict next month's usage (ML model)

  - Forecast monthly costs for next 3 months

  - Anomaly detection (unusual usage spikes)

  - Recommend optimal plan based on usage

  - **Business Impact:** Proactive recommendations prevent service interruptions

- **[P2] Subscription Pause & Seasonal Plans** (2-3 weeks)

  - Pause subscription for 1-3 months

  - Reduced-rate pause option ($10/month)

  - Automatic resume after pause period

  - **Business Impact:** Flexibility for seasonal businesses reduces churn

- **[P2] Advanced Dunning Management** (3-4 weeks)

  - Smart retry timing based on failure reason

  - Multi-channel dunning (email, SMS, in-app)

  - Pre-expiration notifications

  - Payment recovery campaigns

  - **Business Impact:** Reduces involuntary churn by 50%

### Total Post-MVP Effort

**Effort:** 20-28 weeks (5-7 months)
**Priority Distribution:** 2 P0 features, 3 P1 features, 6 P2 features

### Key Dependencies

## Third-Party Services

- **Stripe** - Payment processing, subscriptions, invoicing (fully integrated)

- **Loop.so** - Transactional email delivery (Q1 2026, replaced Q3 2026)

- **Stripe Tax** - Automated tax calculation (Q3 2026)

- **Accounting Systems** - QuickBooks, Xero, NetSuite (Q3 2026)

## Infrastructure

- Usage tracking system (Q1 2026) - Required for budget controls

- Analytics infrastructure (Q1-Q4 2026) - Required for forecasting

- ML infrastructure (Q4 2026) - Required for predictive analytics

- Historical data (6+ months) - Required for churn prediction

### Success Metrics

## Technical

- Payment success rate > 95%

- Invoice generation success rate > 99%

- Failed payment recovery rate > 60%

- Usage tracking accuracy > 98%

## Business

- Support tickets reduced by 30%

- Self-service plan changes > 80%

- Payment failure churn reduced by 40%

- Enterprise customer acquisition enabled (Q2 2026)

- International revenue > 20% of total (Q3 2026)

- Involuntary churn reduced by 50% (Q4 2026)

**Detailed Roadmap:** [Billing & Subscriptions Roadmap](/docs/features/payments/roadmap)

---
