---
title: "Stripe Dashboard Access"
description: "Quick links to Stripe Dashboard for detailed financial analytics and revenue reporting"
last_modified_date: "2025-12-04"
level: "3"
persona: "Finance Team, CFO, Accountants"
status: "ACTIVE"
category: "Admin"
---

# Stripe Dashboard Access

**Quick links to Stripe Dashboard for MRR analytics, invoice management, and revenue reporting.**

---

## Overview

Stripe Dashboard Access provides finance teams with convenient links from PenguinMails directly to relevant sections of the **Stripe Dashboard**. This ensures teams can quickly access detailed financial analytics, revenue reports, and invoice management without navigating through Stripe manually.

> [!IMPORTANT]
> **Stripe as Source of Truth**: All revenue analytics, MRR calculations, invoice management, and financial reporting are handled exclusively in Stripe Dashboard.

### Key Benefits

- **Direct Navigation**: Pre-filtered Stripe URLs to relevant financial sections
- **No Duplication**: Avoids maintaining redundant analytics in PenguinMails
- **Real-Time Data**: Always access latest financial data from Stripe
- **Comprehensive Tools**: Leverage Stripe's full suite of analytics and reporting

---

## Quick Links Overview

### Available Links

From the PenguinMails finance dashboard, teams can access:

| Link | Destination | Use Case |
|------|-------------|----------|
| **Open Stripe Dashboard** | Stripe Home | General access to all Stripe features |
| **View MRR Analytics** | Stripe > Revenue | MRR, ARR, and revenue growth trends |
| **Download Invoices** | Stripe > Invoices | Invoice list with filters and exports |
| **Export Revenue Data** | Stripe > Data Export | Custom CSV/PDF exports with date ranges |
| **View Customers** | Stripe > Customers | Customer list with subscription details |
| **View Payment Methods** | Stripe > Payments | Payment transaction history |
| **Webhook Logs** | Stripe > Webhooks | Webhook event history and debugging |

---

## Financial Analytics in Stripe

### MRR & ARR Analytics

**What's Available**:

- **MRR Dashboard**: Real-time monthly recurring revenue with trends
- **MRR Growth**: Month-over-month and year-over-year growth rates
- **ARR Projections**: Annualized revenue forecasts
- **MRR Breakdown**: By plan, geography, customer segment

**Use Cases**:

- Monthly board reporting
- Investor updates
- Financial forecasting
- Plan pricing analysis

**How to Access**:

1. Click **"View MRR Analytics"** in PenguinMails finance dashboard
2. Opens Stripe > Revenue section
3. View dashboard with charts and trends
4. Export data for presentations

---

### Revenue Reports

**Available Reports**:

- **Revenue Recognition**: Track recognized vs. deferred revenue
- **Revenue by Product**: Breakdown by subscription plan
- **Geographic Revenue**: Revenue by customer country
- **Cohort Analysis**: Revenue retention by signup cohort

**Export Options**:

- CSV exports with custom date ranges
- PDF summary reports
- Automated email reports (scheduled in Stripe)
- API access via Stripe SDK

**Use Cases**:

- Quarterly financial reporting
- Tax preparation
- Accounting reconciliation
- Audit documentation

---

### Invoice Management

**What's Available in Stripe**:

- **Invoice List**: All invoices with search and filters
- **Invoice Status**: Paid, unpaid, past_due, void
- **Invoice PDFs**: Download individual or bulk invoices
- **Line Items**: Detailed breakdown of charges and credits

**Workflow for Invoice Download**:

1. Click **"Download Invoices"** in PenguinMails
2. Opens Stripe > Invoices
3. Apply filters:
   - Date range (e.g., Q4 2025)
   - Status (e.g., paid only)
   - Customer (specific tenant)
4. Select invoices (bulk select available)
5. Export as CSV or download PDFs
6. Import into accounting system

**Use Cases**:

- Monthly reconciliation
- Customer billing inquiries
- Tax documentation
- Audit trails

---

### Customer Insights

**Available in Stripe > Customers**:

- **Customer List**: All customers with subscription status
- **Lifetime Value (LTV)**: Revenue per customer over time
- **Payment Methods**: Credit cards, ACH, other payment sources
- **Subscription History**: Full subscription timeline per customer

**Filters Available**:

- Active subscriptions only
- Canceled customers
- Customers with failed payments
- Customers by plan tier

**Use Cases**:

- Customer support inquiries
- Churn analysis
- Payment method updates
- Subscription history review

---

## Payment Transaction Details

### Transaction History

**What's Available in Stripe > Payments**:

- **All Transactions**: Complete payment history
- **Payment Methods**: Cards, bank transfers, etc.
- **Refunds**: Refund history with reasons
- **Disputes**: Chargeback management

**Filters**:

- Date range
- Payment status (succeeded, failed, refunded)
- Customer
- Amount range

**Use Cases**:

- Payment reconciliation
- Fraud investigation
- Refund processing
- Customer billing disputes

---

## Advanced Analytics & Reporting

### Stripe Sigma (Optional Add-On)

**What is Stripe Sigma?**

- SQL-based custom reporting on Stripe data
- Direct queries on transactions, subscriptions, customers
- Scheduled reports and dashboards

**Use Cases**:

- Custom revenue reports
- Complex cohort analysis
- Financial modeling
- Data science / BI integration

**Example Queries**:

- "MRR by plan and country"
- "Average revenue per customer by signup month"
- "Churn rate by plan tier"

**Access**:

- Available as paid add-on in Stripe
- Click "Explore Stripe Sigma" link from finance dashboard

---

### Third-Party Integrations

**Accounting Software**:

- **QuickBooks**: Sync Stripe invoices and payments
- **Xero**: Automated invoice import
- **NetSuite**: Enterprise accounting integration

**SaaS Analytics**:

- **Baremetrics**: Advanced MRR, churn, and LTV analytics
- **ChartMogul**: Subscription analytics and forecasting
- **ProfitWell**: Free subscription metrics

**Data Warehouses**:

- Export Stripe data to BigQuery, Snowflake, Redshift
- Build custom dashboards in Looker, Tableau, Power BI

**How to Access**:

- Click "View Integrations" in finance dashboard
- Opens Stripe > Settings > Integrations
- Configure desired third-party tools

---

## Best Practices

### When to Use Each Link

| Goal | Use This Link |
|------|---------------|
| Quick MRR check | "View MRR Analytics" |
| Download invoices for accounting | "Download Invoices" |
| Check payment failure reason | "View Payment Methods" |
| Investigate webhook issue | "Webhook Logs" |
| Custom revenue report | "Export Revenue Data" |
| General exploration | "Open Stripe Dashboard" |

### Data Export Workflow

1. **Determine Data Needed**: MRR, invoices, transactions, customers
2. **Access Stripe**: Use appropriate quick link
3. **Apply Filters**: Date range, status, plan, etc.
4. **Export**: CSV for spreadsheets, PDF for documentation
5. **Import**: Into accounting system, BI tool, or presentation

### Security Considerations

- **Access Control**: Only finance team members have access to finance dashboard links
- **Stripe Login**: Users must have Stripe account access (separate authentication)
- **Audit Logging**: All Stripe Dashboard access logged in PenguinMails
- **Sensitive Data**: Payment details remain in Stripe, not exposed in PenguinMails

---

## Common Scenarios

### Scenario: Monthly Board Report

**Goal**: Prepare financial metrics for monthly board meeting

**Workflow**:

1. Click "View MRR Analytics"
2. Review MRR trend (last 12 months)
3. Note MRR growth rate: +15% MoM
4. Export MRR chart as PNG
5. Click "View Customers" to get total customer count
6. Include metrics in board deck

---

### Scenario: Quarterly Accounting Reconciliation

**Goal**: Reconcile Q4 revenue for accounting close

**Workflow**:

1. Click "Download Invoices"
2. Filter to Q4 2025 (Oct 1 - Dec 31)
3. Filter to "Paid" status only
4. Export as CSV
5. Import into QuickBooks
6. Verify total revenue matches Stripe dashboard
7. Download invoice PDFs for audit documentation

---

### Scenario: Customer Billing Inquiry

**Goal**: Customer asks about charge on their credit card

**Workflow**:

1. Click "View Customers"
2. Search for customer email
3. View subscription history
4. Click on specific invoice
5. Review line items and amount charged
6. Download invoice PDF
7. Send to customer as proof of charge

---

## Technical Details

### Link Generation

**Pre-Filtered URLs**:

- Links include filters to show relevant data
- Example: `https://dashboard.stripe.com/invoices?status=paid&created[gte]=2025-10-01`

**URL Parameters**:

- `status`: Filter by status (paid, unpaid, etc.)
- `created[gte]`: Date range start
- `created[lte]`: Date range end
- `customer`: Filter by specific customer ID

**Security**:

- Links open in new tab with `target="_blank"`
- User must be authenticated in Stripe separately
- No sensitive data passed in URL parameters

---

## Future Enhancements

### Potential Improvements

- **Deep Links**: Pre-filter Stripe URLs per specific tenant
- **Embedded Reports**: Embed select Stripe charts in PenguinMails (via Stripe API)
- **Automated Exports**: Scheduled exports from Stripe to email or storage
- **Custom Dashboards**: Build limited finance dashboards using Stripe API data

### Integration Roadmap

See [Finance Roadmap](/docs/roadmap/feature-roadmaps/finance-roadmap) for planned enhancements.

---

## Related Documentation

- **[Subscription Monitoring](/docs/features/admin/finance/subscription-monitoring)**: View active subscription counts
- **[Stripe Webhook Status](/docs/features/admin/finance/stripe-webhook-status)**: Monitor webhook health
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical Stripe API details
- **[Platform Admin Routes](/docs/design/routes/platform-admin#dashboard-finance)**: Finance dashboard UI spec
