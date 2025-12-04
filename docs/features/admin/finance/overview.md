---
title: "Revenue Operations"
description: "Financial reporting, MRR tracking, and Stripe sync monitoring for PenguinMails finance team"
last_modified_date: "2025-12-04"
level: "2"
persona: "Finance Team, CFO"
status: "ACTIVE"
category: "Admin"
---

# Revenue Operations

**Financial dashboards, MRR tracking, and revenue reconciliation for business intelligence.**

---

## Overview

The Revenue Operations feature provides PenguinMails finance team with real-time visibility into recurring revenue, Stripe sync status, and financial reporting. It serves as the primary dashboard for monthly financial close, revenue forecasting, and payment reconciliation.

### Key Capabilities

- **MRR Dashboard**: Real-time Monthly Recurring Revenue tracking
- **Stripe Sync Monitoring**: Webhook sync status and payment reconciliation
- **Revenue Reporting**: Historical trends and growth metrics
- **Financial Exports**: CSV and PDF reports for accounting systems
- **Payment Monitoring**: Failed payment tracking and recovery

---

## User Stories

### Finance Admin

> *"As a finance admin, I need to view our current MRR and growth trend for the monthly board report due tomorrow."*
>
> **Workflow**:
>
> 1. Navigate to `/dashboard/finance`
> 2. View MRR headline metrics
> 3. Review 12-month MRR trend chart
> 4. Export MRR report as CSV
> 5. Import into board presentation

### Accounting Team

> *"As an accountant, I need to reconcile today's payments with Stripe to close the books for the month."*
>
> **Workflow**:
>
> 1. Navigate to finance dashboard
> 2. Check Stripe sync status
> 3. Review "Last Sync" timestamp
> 4. Identify any failed payments
> 5. Export invoice summary as PDF
> 6. Reconcile with Stripe dashboard

---

## Feature Components

### MRR Dashboard

See [Analytics UI Patterns](/docs/design/analytics-ui-patterns#data-cards) for visual design.

**Headline Metrics**:

- **Current MRR**: Total monthly recurring revenue
- **MRR Growth**: Month-over-month percentage change
- **Active Subscriptions**: Count of paying customers
- **Churn Rate**: Percentage of lost subscriptions

**MRR Trend Chart**:

- Line chart showing 12-month MRR history
- Drill-down by plan tier (Free, Pro, Enterprise)
- Exportable data for analysis

### Stripe Sync Status

**Health Indicators**:

- **Last Sync**: Timestamp of most recent webhook sync
- **Sync Status**: All invoices synced / Sync issues detected
- **Failed Payments**: Count and links to details
- **Manual Actions**: "Force Sync Now" button for troubleshooting

**Sync Details**:

- Webhook event history
- Invoice processing status
- Payment status reconciliation
- Error logs and resolution

### Financial Reports

**Export Options**:

- **MRR Report (CSV)**: Monthly breakdown by plan and tenant
- **Invoice Summary (PDF)**: Detailed invoice listing
- **Revenue Trend (CSV)**: Historical MRR data for forecasting
- **Failed Payments (CSV)**: Outstanding payment issues

**Filters**:

- Date range selection
- Plan type (Free, Pro, Enterprise)
- Subscription status (Active, Churned, Trial)

---

## Integration Architecture

### Stripe Integration

- **Webhooks**: Real-time payment event processing
  - `invoice.paid` - Successful payment
  - `invoice.payment_failed` - Failed payment
  - `customer.subscription.created` - New subscription
  - `customer.subscription.deleted` - Cancellation
- **Sync Logic**: Idempotent webhook processing with retry
- **Reconciliation**: Daily batch job to verify consistency

### MRR Calculation

**Formula**: Sum of all active subscriptions' monthly value

**Data Sources**:

- `subscriptions` table (OLTP)
- Aggregated daily in OLAP for historical trends
- Cached for 1 hour on dashboard

**Normalization**:

- Annual plans divided by 12 for monthly value
- Pro-rated for mid-month starts/cancellations

### Database Schema

- **Subscriptions Table**: Current subscription state
- **Invoices Table**: Historical payment records
- **Webhook Events Table**: Stripe webhook audit trail
- **MRR Snapshots Table** (OLAP): Daily MRR aggregates

---

## Technical Considerations

### Performance

- **Dashboard Load**: <500ms with cached metrics
- **MRR Calculation**: Pre-aggregated daily, not real-time
- **Export Generation**: Async job for large datasets

### Data Accuracy

- **Stripe as Source of Truth**: All billing data originates from Stripe
- **Reconciliation**: Daily automated checks for discrepancies
- **Manual Sync**: Force sync for immediate reconciliation

### Security

- **Access Control**: Finance role required
- **Sensitive Data**: Payment details not exposed in exports
- **Audit Logging**: All financial data access logged

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes - Finance](/docs/design/routes/platform-admin#dashboard-finance) - UI specification

### API Documentation

- [Finance API](/docs/implementation-technical/api/platform-api/finance) - MRR and revenue endpoints
- [Subscriptions API](/docs/implementation-technical/api/platform-api/subscriptions) - Subscription data

### Related Features

- [Stripe Integration](/docs/features/payments/stripe-integration) - Payment processing
- [Subscription Management](/docs/features/payments/subscription-management) - Customer billing

### Database Schema

- [OLTP Database Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) - Subscriptions and invoices
- [OLAP Database Schema](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide) - MRR aggregates

---

## Future Enhancements

### Q1 2026

- **Revenue Forecasting**: Predict MRR growth based on trends
- **Cohort Analysis**: Revenue retention by signup cohort
- **LTV Calculation**: Customer lifetime value metrics

### Q2 2026

- **CFO Dashboard**: Executive-level financial KPIs
- **Automated Reconciliation**: Alert on Stripe discrepancies
- **Custom Reporting**: Ad-hoc financial queries

### Q3 2026

- **Multi-Currency Support**: International revenue tracking
- **Tax Reporting**: Sales tax and VAT breakdowns
- **Financial Forecasting**: ML-based revenue predictions
