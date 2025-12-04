---
title: "Subscription Monitoring"
description: "Basic subscription counting and plan distribution monitoring"
last_modified_date: "2025-12-04"
level: "3"
persona: "Finance Team, CFO"
status: "ACTIVE"
category: "Admin"
---

# Subscription Monitoring

**View active subscription counts and plan distribution for basic financial oversight.**

---

## Overview

Subscription Monitoring provides finance teams with real-time visibility into active subscription counts and plan distribution. This feature queries the OLTP database for simple subscription counts, while detailed revenue analytics are available in **Stripe Dashboard**.

> [!IMPORTANT]
> **Stripe-First Approach**: This feature provides basic counts only. For MRR, ARR, churn rates, and revenue analytics, use Stripe Dashboard directly.

### Key Capabilities

- **Active Subscription Count**: Real-time count of active subscriptions
- **Plan Distribution**: Breakdown of subscriptions by plan tier (Starter, Pro, Enterprise)
- **Stripe Dashboard Link**: Quick access to detailed revenue analytics in Stripe
- **Simple Queries**: Fast, read-only queries against OLTP database

---

## User Story

### Finance Admin
>
> *"As a finance admin, I need to check our active subscription count and access Stripe for revenue details."*

### Workflow

1. **Access Finance Dashboard**
   - Navigate to `/dashboard/finance`
   - View subscription summary panel

2. **Review Basic Metrics**
   - **Total Active Subscriptions**: e.g., 1,247 active
   - **Plan Distribution**:
     - Starter: 823 subscriptions
     - Pro: 389 subscriptions
     - Enterprise: 35 subscriptions

3. **Access Detailed Analytics**
   - Click **"View MRR & Revenue in Stripe"** button
   - Opens Stripe Dashboard in new tab
   - Access detailed revenue reports, MRR trends, churn analysis

4. **Export Data**
   - In Stripe: Export revenue data (CSV, PDF)
   - Import into board presentation or accounting system

---

## Subscription Summary Display

See [Analytics UI Patterns](/docs/design/analytics-ui-patterns#data-cards) for visual design.

### Metrics Displayed

| Metric | Description | Data Source |
|--------|-------------|-------------|
| **Active Subscriptions** | Total count of active subscriptions | OLTP `subscriptions` table (`status = 'active'`) |
| **Plan Distribution** | Subscriptions grouped by plan tier | GROUP BY `plan_id` |
| **Last Updated** | Timestamp of last database query | Real-time |

### Not Displayed (Available in Stripe)

The following metrics require complex calculations and should be accessed via **Stripe Dashboard**:

- **MRR (Monthly Recurring Revenue)**: Real-time MRR calculations with proration
- **ARR (Annual Recurring Revenue)**: Annualized revenue projections
- **Churn Rate**: Customer and revenue churn percentages
- **LTV (Lifetime Value)**: Customer lifetime value by cohort
- **Revenue Growth**: Month-over-month and year-over-year trends
- **Cohort Analysis**: Subscription retention by signup month

---

## Technical Implementation

### Query Logic

**Simple Count Query**:

```sql
SELECT 
  COUNT(*) as active_count
FROM subscriptions
WHERE status = 'active';
```

**Plan Distribution Query**:

```sql
SELECT 
  plans.name,
  COUNT(*) as subscription_count
FROM subscriptions
JOIN plans ON subscriptions.plan_id = plans.id
WHERE subscriptions.status = 'active'
GROUP BY plans.id, plans.name
ORDER BY subscription_count DESC;
```

### Performance Characteristics

- **Query Time**: <50ms (simple COUNT with indexed status column)
- **Dashboard Load**: <200ms total (includes all finance dashboard metrics)
- **Caching**: Results cached for 5 minutes to reduce database load
- **Real-Time**: Reflects subscription changes within 5 minutes

### Database Schema

**Tables Used**:

- `subscriptions`: Current subscription state (OLTP)
  - `id`, `tenant_id`, `plan_id`, `status`, `stripe_subscription_id`
- `plans`: Plan definitions
  - `id`, `name`, `stripe_product_id`

**Status Values**:

- `active`: Subscription is current and paid
- `past_due`: Payment failed, grace period active
- `canceled`: Subscription canceled by customer
- `trialing`: In trial period

---

## Stripe Dashboard Integration

### Quick Links Provided

From the subscription monitoring panel, finance admins can access:

1. **View MRR Analytics**: Direct link to Stripe Revenue section
2. **View Customer List**: Stripe Customers page filtered by active subscriptions
3. **Export Data**: Stripe Data Export tools

### What's Available in Stripe

**Revenue Analytics**:

- Real-time MRR and ARR dashboards
- Revenue growth charts (daily, weekly, monthly)
- Breakdown by plan, geography, and customer segment

**Customer Insights**:

- Customer cohort analysis
- Retention rates by signup month
- Average revenue per customer (ARPU)

**Export Capabilities**:

- CSV exports with custom date ranges
- Automated reports via email
- SQL access via Stripe Sigma (paid add-on)

---

## Best Practices

### When to Use Subscription Monitoring

- **Quick Checks**: "How many active subscriptions do we have?"
- **Plan Distribution**: "Which plan tier is most popular?"
- **Board Reporting**: "Total customer count for board deck"

### When to Use Stripe Dashboard

- **Revenue Analysis**: "What's our MRR growth rate this quarter?"
- **Churn Analysis**: "What's our monthly churn rate?"
- **Financial Forecasting**: "Projected ARR for next quarter"
- **Accounting Reconciliation**: "Download all invoices for Q4"

### Data Accuracy

- **Subscription Counts**: Real-time from OLTP database
- **Stripe as Source of Truth**: Payment and revenue data always authoritative in Stripe
- **Webhook Sync**: Subscription status updated via Stripe webhooks
- **Reconciliation**: If discrepancies exist, trust Stripe data

---

## Common Scenarios

### Scenario: Monthly Board Report

**Goal**: Prepare subscription metrics for monthly board presentation

**Workflow**:

1. Access finance dashboard
2. Note total active subscriptions: 1,247
3. Note plan distribution: Starter (66%), Pro (31%), Enterprise (3%)
4. Click "View MRR in Stripe"
5. Export MRR trend chart from Stripe
6. Include both subscription count and MRR trend in board deck

### Scenario: Plan Performance Analysis

**Goal**: Determine which plan tier has best retention

**Workflow**:

1. View plan distribution in finance dashboard
2. Click "View Cohort Analysis in Stripe"
3. In Stripe: Filter cohorts by plan tier
4. Compare retention rates across plan tiers
5. Use insights to adjust marketing strategy

---

## Limitations

### What This Feature Does NOT Provide

- **MRR Calculations**: Use Stripe Dashboard
- **Revenue Forecasting**: Use Stripe Dashboard or third-party tools
- **Invoice Management**: Use Stripe Dashboard
- **Payment Transaction Details**: Use Stripe Dashboard
- **Churn Rate Calculations**: Use Stripe Dashboard

> [!NOTE]
> PenguinMails stores only minimal subscription references for access control. All detailed financial analytics are handled by Stripe.

---

## Related Documentation

- **[Stripe Webhook Status](./stripe-webhook-status.md)**: Monitor webhook health and sync status
- **[Stripe Dashboard Access](./stripe-dashboard-access.md)**: Quick links to Stripe analytics
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical webhook processing
- **[OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Subscriptions table structure
