---
title: "Billing Dashboard"
description: "Usage tracking, invoices, and billing management for PenguinMails"
last_modified_date: "2025-11-24"
level: "2"
persona: "Billing Administrators, Finance Teams"
status: "ACTIVE"
category: "Payments"
---

# Billing Dashboard

**Centralized billing management with usage tracking, invoices, and payment history.**

---

## Overview

The Billing Dashboard provides complete visibility into your PenguinMails subscription, usage, costs, and payment history - all in one place.

**Access:** Settings → Billing

---

## Dashboard Overview

### At-a-Glance Summary

**Top of Dashboard Shows:**

| Section | Information |
|---------|-------------|
| **Current Plan** | Plan name, monthly cost, billing cycle |
| **Usage Summary** | Emails sent, team members, workspaces |
| **Next Billing** | Date and amount of next charge |
| **Payment Method** | Last 4 digits of card, expiration |

**Quick Actions:**

- [Change Plan] - Upgrade/downgrade

- [Update Payment] - Modify payment method

- [View Invoices] - Download past invoices

- [Cancel Subscription] - End billing

---

## Level 1: Usage Tracking

### Real-Time Usage Metrics

**Monitor usage against plan limits:**

#### Email Sends

```text
📧 Email Sends
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 46.9%
23,450 / 50,000 emails sent this month

Remaining: 26,550 emails
Resets: December 24, 2025

```

**Features:**

- Progress bar visualization

- Percentage used

- Exact counts

- Reset date

#### Team Members

```text
👥 Team Members
━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 60%
3 / 5 seats occupied

Available: 2 seats
[Invite Team Member]

```

#### Workspaces

```text
🗂️ Workspaces
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 70%
7 / 10 workspaces created

Available: 3 workspaces
[Create Workspace]

```

#### Custom Domains

```text
🌐 Custom Domains
━━━━━━━━━━━━━━━━━ 33.3%
5 / 15 domains configured

Available: 10 domains
[Add Domain]

```

---

### Usage Alerts

**Proactive notifications** when approaching limits.

**Alert Thresholds:**

- 🟡 **80% Used** - Warning email

- 🟠 **90% Used** - Upgrade suggestion

- 🔴 **95% Used** - Urgent action needed

- ⛔ **100% Used** - Limit reached

**Alert Actions:**

- Email notification to billing admin

- In-app notification

- Dashboard banner

- Recommended actions (upgrade, reduce usage)

---

### Usage History

**Track usage trends over time.**

**Monthly Usage Chart:**

```text
Email Sends (Last 6 Months)

50k |                     ┍━●
40k |                  ┍━━┯
30k |            ●━━━━━━┯
20k |      ┍━━━━━━┯
10k | ●━━━━━┯
 0k └──────────────────────────────
    Jun Jul Aug Sep Oct Nov

```

**Export Options:**

- CSV download

- PDF report

- API access

---

## Level 2: Invoice Management

### Invoice List

**All invoices in one place:**

| Date | Invoice # | Description | Amount | Status | Actions |
|------|-----------|-------------|--------|--------|---------|
| Nov 24, 2025 | INV-001234 | Professional Plan | $149.00 | Paid | [Download PDF] |
| Oct 24, 2025 | INV-001198 | Professional Plan | $149.00 | Paid | [Download PDF] |
| Sep 24, 2025 | INV-001167 | Starter Plan | $49.00 | Paid | [Download PDF] |

**Invoice Details:**

- Date issued

- Unique invoice number

- Line items (subscription, add-ons, taxes)

- Total amount

- Payment status

- PDF download

---

### Invoice Contents

**Standard invoice includes:**

```text
INVOICE #INV-001234

Bill To:
Acme Corporation
123 Main Street
San Francisco, CA 94105
United States

Date: November 24, 2025
Due: November 24, 2025 (paid)

Line Items:

- Professional Plan (Nov 24 - Dec 24)    $149.00

- Additional Emails (10,000)              $10.00

- Sales Tax (CA)                           $12.72
                                         ────────
                                  TOTAL: $171.72

Payment Method: •••• 4242 (Visa)
Status: PAID

```

**Features:**

- Company billing information

- Itemized charges

- Tax breakdown

- Payment method

- Payment status

---

### Upcoming Invoice Preview

**See next charge before it happens.**

```text
🧾 Next Invoice Preview

Billing Date: December 24, 2025
Estimated Amount: $149.00

Line Items:

- Professional Plan (Monthly)             $149.00

- Tax (estimated)                          $11.92
                                         ────────
                                  TOTAL: $160.92

[Update Plan] [Update Payment Method]

```

**Benefits:**

- No billing surprises

- Adjust plan before charge

- Update payment method if needed

- Verify pricing

---

## Level 3: Payment History

### Transaction Log

**Complete payment history:**

```javascript
GET /api/v1/billing/payments
Authorization: Bearer {api_key}

Response:
{
  "payments": [
    {
      "id": "pi_abc123",
      "date": "2025-11-24",
      "amount": 149.00,
      "currency": "USD",
      "status": "succeeded",
      "description": "Professional Plan - Monthly",
      "payment_method": "card_4242",
      "receipt_url": "https://stripe.com/receipts/..."
    }
  ],
  "total_count": 12,
  "page": 1
}

```

**Transaction Details:**

- Payment date and time

- Amount charged

- Payment method used

- Payment status (succeeded, failed, refunded)

- Receipt link

- Associated invoice

---

### Failed Payment Handling

**What happens when payment fails:**

1. **Immediate Notification**

   - Email to billing admin

   - In-app alert

   - Dashboard warning banner

2. **Grace Period** (7 days)

   - Service continues

   - Automatic retry attempts

   - Update payment method anytime

3. **Account Suspension** (Day 7)

   - Email sending disabled

   - Read-only access to data

   - Final retry attempt

4. **Cancellation** (Day 14)

   - Subscription canceled

   - Free tier activated (90-day data retention)

**Resolution:**

- [Update Payment Method] button prominently displayed

- [Retry Payment] manual retry option

- Contact support for assistance

---

### Refunds

**Refund policy and processing:**

**Eligible for Refund:**

- ✅ Double-charged (full refund)

- ✅ Billing error (full refund)

- ✅ Service issue (prorated refund)

- ✅ Within 7 days of charge (goodwill refund)

**Not Eligible:**

- ❌ Simply changed mind after 7 days

- ❌ Service not used (non-usage doesn't qualify)

- ❌ Annual plans mid-term (no partial refunds)

**Request Refund:**

1. Contact support: <billing@penguinmails.com>

2. Provide invoice number and reason

3. Review by billing team (1-2 business days)

4. Refund processed (5-10 business days to card)

---

## Budget Management

### Spending Limits

**Set maximum monthly spend:**

```text
💰 Budget Controls

Monthly Budget: $200.00
Current Month Spend: $159.00
Remaining Budget: $41.00

[●●●●●●●●●●●●●●●●●●●○○○○○○] 79.5%

Alert When:
☑ 80% of budget ($160.00)
☑ 100% of budget ($200.00)

Action at 100%:
● Alert only
○ Block overage charges
○ Auto-upgrade to next tier

```

**Budget Options:**

- Set monthly maximum

- Alert thresholds

- Overage handling (alert, block, auto-upgrade)

- Email notifications

---

### Cost Optimization Tips

**Dashboard provides recommendations:**

- 💡 **Switch to Annual** - Save 20% ($358/year savings)

- 💡 **Downgrade Unused Seats** - Remove 2 inactive users ($30/mo savings)

- 💡 **Archive Old Workspaces** - Reduce workspace count (back to plan limit)

- 💡 **Optimize Send Frequency** - Reduce emails by segmentation

---

## Billing Administration

### Billing Contact

**Manage who receives billing notifications:**

**Primary Billing Contact:**

- Receives all invoices

- Payment failure notifications

- Usage alerts

- Subscription changes

**Additional Contacts:**

- CC on invoices (optional)

- Separate finance team email

- Multiple recipients supported

**Configuration:**

```text
Billing Contacts

Primary: billing@acme.com [Edit]

Additional Recipients:
finance@acme.com [Remove]
cfo@acme.com [Remove]

[+ Add Recipient]

```

---

### Company Billing Information

**Tax and invoice details:**

```text
Company Information

Legal Name: Acme Corporation
Tax ID: 12-3456789
Billing Address:
  123 Main Street
  San Francisco, CA 94105
  United States

[Edit Information]

```

**Used For:**

- Invoice generation

- Tax calculation

- Payment processing

- Legal compliance

---

## API Access

### Billing API Endpoints

```javascript
// Get Current Usage
GET /api/v1/billing/usage
Authorization: Bearer {api_key}

// Get Invoices
GET /api/v1/billing/invoices?limit=10

// Download Invoice PDF
GET /api/v1/billing/invoices/{invoice_id}/pdf

// Get Payment History
GET /api/v1/billing/payments?page=1&per_page=20

// Update Billing Info
PUT /api/v1/billing/company-info
{
  "legal_name": "Acme Corp",
  "tax_id": "12-3456789",
  "address": {...}
}

```

---

## Related Documentation

### Payments

- **[Subscription Management](/docs/features/payments/subscription-management)** - Plan upgrades and downgrades

- **[Stripe Integration](/docs/features/payments/stripe-integration)** - Payment processing

- **[Payments Overview](https://github.com/penguinmails/penguinmails.github.io/blob/main/README.md)** - All payment features

### Support

- **[Billing FAQ](/docs/business/faq/billing-faq)** - Common billing questions

- **[Contact Billing](mailto:billing@penguinmails.com)** - Billing support

---

**Last Updated:** November 24, 2025
**Access Level:** Billing Admin, Tenant Owner
**Data Retention:** Invoices retained for 7 years

*The Billing Dashboard provides complete transparency into your PenguinMails costs and usage.*
