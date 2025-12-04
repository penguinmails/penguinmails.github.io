---
title: "Finance Overview"
description: "Hub for subscription monitoring and Stripe Dashboard access for financial analytics"
last_modified_date: "2025-12-04"
level: "2"
persona: "Finance Team, CFO"
status: "ACTIVE"
category: "Admin"
---

# Finance Overview

**Basic subscription monitoring with links to Stripe Dashboard for detailed financial analytics.**

---

## Overview

The Finance features provide PenguinMails finance team with basic subscription monitoring and convenient access to **Stripe Dashboard** for detailed revenue analytics, MRR tracking, and invoice management.

> [!IMPORTANT]
> **Stripe-First Approach**: PenguinMails stores only minimal payment references for access control. All detailed financial analytics, MRR calculations, invoice management, and revenue reporting are accessed via Stripe Dashboard.

### Key Philosophy

- **Simple Counts**: PenguinMails provides basic subscription counts from OLTP database
- **Stripe for Analytics**: MRR, ARR, churn, and revenue analytics handled by Stripe
- **Quick Links**: Direct navigation to relevant Stripe Dashboard sections
- **No Duplication**: Avoid maintaining redundant financial data

---

## Finance Features

### [Subscription Monitoring](./subscription-monitoring.md)

View active subscription counts and plan distribution for basic financial oversight.

**Key Topics**:

- Active subscription counts (real-time from OLTP)
- Plan distribution breakdown (Starter, Pro, Enterprise)
- Simple queries for fast dashboard load
- Links to Stripe for MRR and revenue analytics

**Use Cases**:

- Quick subscription count checks
- Plan distribution analysis
- Board reporting (total customer count)

---

### [Stripe Webhook Status](./stripe-webhook-status.md)

Monitor webhook health to ensure subscription and payment data stays in sync with Stripe.

**Key Topics**:

- Webhook health indicators (Healthy, Delayed, Error)
- Last webhook timestamp and event type
- Failed payment count monitoring
- Webhook troubleshooting

**Use Cases**:

- Verify sync health before reconciliation
- Monitor failed payments
- Investigate subscription sync issues

---

### [Stripe Dashboard Access](./stripe-dashboard-access.md)

Quick links to Stripe Dashboard for MRR analytics, invoice management, and revenue reporting.

**Key Topics**:

- Direct links to MRR analytics, invoices, customers
- What's available in Stripe Dashboard
- Export workflows (CSV, PDF)
- Third-party integrations (QuickBooks, Baremetrics)

**Use Cases**:

- Access MRR trends for board reporting
- Download invoices for accounting
- Export revenue data for financial forecasting

---

## Quick Reference

### Common Finance Tasks

| Task | Feature | Action |
|------|---------|--------|
| Check subscription count | [Subscription Monitoring](./subscription-monitoring.md) | View finance dashboard |
| Access MRR analytics | [Stripe Dashboard Access](./stripe-dashboard-access.md) | Click "View MRR in Stripe" |
| Download invoices | [Stripe Dashboard Access](./stripe-dashboard-access.md) | Click "Download Invoices" |
| Check webhook health | [Stripe Webhook Status](./stripe-webhook-status.md) | View webhook status panel |
| Review failed payments | [Stripe Webhook Status](./stripe-webhook-status.md) | Click "View Failed Payments" |

### What's in PenguinMails vs. Stripe

| Data Type | PenguinMails | Stripe Dashboard |
|-----------|--------------|------------------|
| **Subscription Count** | ✅ Real-time count | ✅ Full customer list |
| **Plan Distribution** | ✅ Basic breakdown | ✅ Detailed cohort analysis |
| **MRR / ARR** | ❌ Use Stripe | ✅ Real-time dashboards |
| **Churn Rate** | ❌ Use Stripe | ✅ Retention analytics |
| **Invoices** | ❌ Use Stripe | ✅ Full invoice management |
| **Payment Details** | ❌ Use Stripe | ✅ Transaction history |
| **Revenue Forecasting** | ❌ Use Stripe | ✅ Projections and trends |

---

## Integration Architecture

### Stripe Connection

- **Webhooks**: Real-time subscription status updates via Stripe webhooks
  - `invoice.paid` → Update subscription to `active`
  - `invoice.payment_failed` → Flag subscription as `past_due`
  - `customer.subscription.created` → Create local subscription reference
  - `customer.subscription.deleted` → Mark subscription as `canceled`
- **Sync Logic**: Idempotent webhook processing with automatic retry
- **Status Flow**: Stripe is source of truth for all payment and subscription state

### Database Schema

**OLTP Tables**:

- `subscriptions`: Current subscription state (minimal references)
- `plans`: Plan definitions and feature limits
- `payments`: Payment references with `stripe_payment_intent_id`

**What's NOT Stored**:

- Invoice PDFs or line items (use Stripe)
- Full payment transaction details (use Stripe)
- MRR calculations or aggregates (use Stripe Dashboard)
- Revenue forecasting data (use Stripe Dashboard)

See [OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) for details.

---

## Best Practices

### When to Use Finance Dashboard

- Quick subscription count ("How many active customers?")
- Basic plan distribution ("What's our plan mix?")
- Webhook health check (before reconciliation)
- Access point to Stripe Dashboard

### When to Use Stripe Dashboard

- MRR and ARR analytics
- Revenue growth trends
- Churn rate analysis
- Invoice downloads
- Payment transaction details
- Financial forecasting
- Accounting reconciliation

### Data Accuracy

- **Subscription Counts**: Real-time from OLTP database (<5 min cache)
- **Stripe as Source of Truth**: All payment and revenue data authoritative in Stripe
- **Webhook Sync**: Status updates within seconds of Stripe events
- **Reconciliation**: If discrepancies exist, trust Stripe data

---

## Related Documentation

### Technical Implementation

- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Webhook processing and API integration
- **[OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure
- **[Finance API](/docs/implementation-technical/api/platform-api/finance)**: API endpoints for finance dashboard

### Admin Features

- **[Plan Management](/docs/features/admin/plan-management/overview.md)**: Create and manage subscription plans
- **[Platform Admin Routes](/docs/design/routes/platform-admin#dashboard-finance)**: Finance dashboard UI specification

### Roadmap

- **[Finance Roadmap](/docs/roadmap/feature-roadmaps/finance-roadmap.md)**: Planned enhancements and integrations

---

## Future Enhancements

All advanced financial analytics features will be handled by Stripe Dashboard and third-party integrations:

### Integration Options

- **Stripe Sigma**: SQL-based custom revenue reports
- **QuickBooks/Xero**: Export Stripe data for accounting
- **Baremetrics/ChartMogul**: Advanced SaaS metrics and MRR analytics
- **Data Warehouses**: BigQuery, Snowflake integration for custom dashboards

### Potential Internal Features

- **Enhanced Stripe Links**: Pre-filtered Stripe Dashboard URLs per tenant
- **Webhook History**: Detailed webhook event log viewer in PenguinMails
- **Subscription Alerts**: Automated notifications for subscription changes
- **Embedded Charts**: Limited Stripe charts embedded via API (investigate feasibility)
