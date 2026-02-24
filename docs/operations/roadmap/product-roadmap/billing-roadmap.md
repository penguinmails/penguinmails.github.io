---
title: "Billing & Subscriptions Roadmap"
description: "Future roadmap for payment processing, subscription management, and financial reporting."
last_modified_date: "2025-12-09"
level: "2"
persona: "Product, Finance, Developers"
---

## Feature Roadmap: Billing & Subscriptions

### Q2 2026: Enterprise Readiness

* **[P0] Usage-Based Billing Foundation** (2-3 weeks)
  * Real-time usage tracking infrastructure
  * Automated overage calculation and invoicing
  * Usage dashboard for customers
  * **Business Impact:** Enables scalable pricing models, captures revenue from high-volume users
* **[P1] Customer Portal & Self-Service** (2-3 weeks)
  * Self-service plan upgrades/downgrades
  * Payment method management
  * Invoice history and PDF downloads
  * Subscription cancelation/pause workflow
  * **Business Impact:** Reduces support overhead, improves customer experience
* **[P2] Flexible Payment Options** (2-3 weeks)
  * ACH direct debit for US customers
  * SEPA direct debit for EU customers
  * Wire transfer instructions
  * Purchase order workflow
  * Installment plans (3, 6, 12 months)
  * **Business Impact:** Enterprise customers require alternative payment methods

### Q3 2026: International Expansion

* **[P1] Multi-Currency Support** (3-4 weeks)
  * Support EUR, GBP, CAD, AUD currencies
  * Local payment methods (SEPA, iDEAL, Bancontact)
  * Currency-specific invoicing with local tax
  * Multi-currency financial reporting
  * **Business Impact:** Enables international expansion, unlocks global markets
* **[P2] Revenue Recognition & Financial Reporting** (3-4 weeks)
  * Automated revenue recognition (ASC 606 / IFRS 15)
  * Deferred revenue tracking
  * Revenue waterfall reports
  * Cohort retention analysis
  * Export to QuickBooks, Xero, NetSuite
  * **Business Impact:** Automated financial reporting for investor/board meetings
* **[P2] Referral Credits & Promotional Discounts** (2-3 weeks)
  * Referral link generation and tracking
  * Account credit system ($50 per referral)
  * Promotional discount codes
  * Discount analytics dashboard
  * **Business Impact:** Referral rewards drive word-of-mouth growth

### Q4 2026: Optimization & Retention

* **[P2] Advanced Usage Analytics & Forecasting** (3-4 weeks)
  * Predict next month's usage (ML model)
  * Forecast monthly costs for next 3 months
  * Anomaly detection (unusual usage spikes)
  * Recommend optimal plan based on usage
  * **Business Impact:** Proactive recommendations prevent service interruptions
* **[P2] Subscription Pause & Seasonal Plans** (2-3 weeks)
  * Pause subscription for 1-3 months
  * Reduced-rate pause option ($10/month)
  * Automatic resume after pause period
  * **Business Impact:** Flexibility for seasonal businesses reduces churn
* **[P2] Advanced Dunning Management** (3-4 weeks)
  * Smart retry timing based on failure reason
  * Multi-channel dunning (email, SMS, in-app)
  * Pre-expiration notifications
  * Payment recovery campaigns
  * **Business Impact:** Reduces involuntary churn by 50%

---

### Key Dependencies

* **Stripe** - Payment processing, subscriptions, invoicing (fully integrated)
* **Stripe Tax** - Automated tax calculation (Q3 2026)
* **Accounting Systems** - QuickBooks, Xero, NetSuite (Q3 2026)

### Success Metrics

* Payment success rate > 95%
* Failed payment recovery rate > 60%
* Usage tracking accuracy > 98%
* Failed payment churn reduced by 40%
