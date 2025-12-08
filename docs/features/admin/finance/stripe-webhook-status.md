---
title: "Stripe Webhook Status"
description: "Monitor Stripe webhook health and subscription sync status"
last_modified_date: "2025-12-04"
level: "3"
persona: "Finance Team, Platform Engineers"
status: "ACTIVE"
category: "Admin"
---

# Stripe Webhook Status

**Monitor webhook health to ensure subscription and payment data stays in sync with Stripe.**

---

## Overview

Stripe Webhook Status provides visibility into the health of PenguinMails' integration with Stripe. This feature monitors incoming webhooks, tracks sync status, and alerts teams to potential integration issues.

### Key Capabilities

- **Webhook Health Monitoring**: Real-time status of Stripe webhook processing
- **Last Sync Timestamp**: When the last webhook was successfully processed
- **Failed Payment Indicators**: Count of subscriptions with payment issues
- **Stripe Dashboard Links**: Quick access to payment and invoice details in Stripe

---

## User Story

### Accounting Team
>
> *"As an accountant, I need to access Stripe to reconcile payments and download invoices."*

### Workflow

1. **Check Webhook Status**
   - Navigate to finance dashboard
   - Review webhook health indicator:
     - ✅ **Healthy**: Last webhook <10 minutes ago
     - ⚠️ **Delayed**: Last webhook 10-60 minutes ago
     - 🔴 **Error**: Last webhook >60 minutes ago or webhook errors

2. **Review Sync Details**
   - **Last Webhook**: "2 minutes ago"
   - **Event Type**: `invoice.paid`
   - **Processing Status**: Success

3. **Access Stripe for Details**
   - Click **"Open Stripe Dashboard"** link
   - Review payment details in Stripe
   - Download invoice reports from Stripe

4. **Reconcile Payments**
   - Export payment data from Stripe
   - Import into accounting system (QuickBooks, Xero, etc.)
   - Verify all transactions recorded

---

## Webhook Health Indicators

### Health Status

| Status | Indicator | Description | Action Required |
|--------|-----------|-------------|-----------------|
| **Healthy** | 🟢 Green | Last webhook <10 min ago | None |
| **Delayed** | 🟡 Yellow | Last webhook 10-60 min ago | Monitor; may be normal during low activity |
| **Error** | 🔴 Red | Last webhook >60 min ago or errors | Investigate webhook configuration in Stripe |

### Metrics Displayed

- **Last Webhook Received**: Timestamp of most recent webhook (e.g., "2 minutes ago")
- **Last Event Type**: Most recent webhook event (e.g., `invoice.paid`, `subscription.updated`)
- **Failed Payments Count**: Number of subscriptions with status `past_due`
- **Processing Status**: Success / Failed / Retrying

---

## Webhook Events Monitored

### Subscription Events

| Event | Description | Action Taken |
|-------|-------------|--------------|
| `customer.subscription.created` | New subscription created | Create local subscription reference |
| `customer.subscription.updated` | Subscription modified | Update subscription status and plan |
| `customer.subscription.deleted` | Subscription canceled | Mark subscription as `canceled` |

### Payment Events

| Event | Description | Action Taken |
|-------|-------------|--------------|
| `invoice.paid` | Invoice successfully paid | Update subscription status to `active` |
| `invoice.payment_failed` | Payment failed | Flag subscription as `past_due` |
| `invoice.finalized` | Invoice generated | Log invoice reference (details in Stripe) |

### Customer Events

| Event | Description | Action Taken |
|-------|-------------|--------------|
| `customer.created` | New customer in Stripe | Create customer reference |
| `customer.updated` | Customer info changed | Update customer metadata |

---

## Failed Payment Monitoring

### Failed Payment Count

Displays the number of subscriptions with payment issues:

- **Count**: e.g., "5 failed payments"
- **Link**: "View Payment Details in Stripe" (opens filtered Stripe Dashboard)
- **Status**: Subscriptions with `status = 'past_due'`

### Workflow for Failed Payments

1. **View Count** in finance dashboard
2. **Click Link** to Stripe Dashboard (pre-filtered to failed payments)
3. **Review in Stripe**:
   - Payment failure reasons
   - Customer contact attempts
   - Retry schedules
4. **Take Action** (in Stripe):
   - Contact customer for payment update
   - Retry payment manually
   - Apply grace period or cancel subscription

> [!NOTE]
> Payment retry logic, dunning management, and customer communication are handled by Stripe. PenguinMails reflects the final subscription status.

---

## Manual Sync Tools

### Force Sync Transaction

**Purpose**: Manually pull the latest status of a specific invoice or subscription from Stripe when webhooks fail or are delayed. This ensures the local database reflects the authoritative state in Stripe.

**User Story**:
> *"As a finance admin, I see a customer claims they paid an invoice, but their subscription is still 'past_due' in PenguinMails. I need to force a sync to update their status immediately."*

**Workflow**:

1. **Locate ID**: Get the Invoice ID (e.g., `in_123abc`) or Subscription ID (e.g., `sub_456xyz`) from Stripe Dashboard.
2. **Input ID**: Enter the ID into the "Force Sync Transaction" input field in the Finance Dashboard.
3. **Trigger Sync**: Click **"Sync Now"**.
4. **System Action**:
   - Calls Stripe API (`invoices.retrieve` or `subscriptions.retrieve`)
   - Updates local database record with latest status
   - Logs the manual sync action
5. **Result**: Subscription status updates to `active` immediately.

> [!NOTE]
> This tool respects the **Stripe-First** philosophy: it pulls data *from* Stripe to update PenguinMails. It does not push changes to Stripe.

---

## Technical Implementation

### Webhook Processing

**Webhook Endpoint**: `/api/webhooks/stripe`

**Processing Flow**:

1. Receive webhook from Stripe
2. Verify webhook signature (security)
3. Parse event type and payload
4. Update local database (subscriptions, customers)
5. Acknowledge webhook (200 OK response)
6. Update "Last Webhook" timestamp in dashboard

**Idempotency**:

- Each webhook has unique `event.id`
- Duplicate webhooks are ignored (idempotent processing)
- Retry logic handles transient failures

### Database Tracking

**Webhook Log Table** (optional):

```sql
CREATE TABLE webhook_events (
  id UUID PRIMARY KEY,
  stripe_event_id TEXT UNIQUE,
  event_type TEXT,
  processed_at TIMESTAMP,
  status TEXT, -- 'success', 'failed', 'retrying'
  error_message TEXT
);
```

**Status Query**:

```sql
SELECT 
  MAX(processed_at) as last_webhook,
  event_type as last_event_type
FROM webhook_events
WHERE status = 'success';
```

### Performance

- **Webhook Processing**: <500ms per event
- **Dashboard Query**: <50ms (simple MAX query)
- **Real-Time Updates**: Webhook processed within seconds of Stripe event

---

## Troubleshooting

### Common Issues

#### No Recent Webhooks

**Symptom**: Last webhook >1 hour ago, but subscriptions are active

**Possible Causes**:

- Low subscription activity (normal during off-hours)
- Webhook endpoint unreachable
- Webhook disabled in Stripe Dashboard

**Resolution**:

1. Check Stripe Dashboard > Webhooks for endpoint status
2. Verify webhook endpoint URL is correct
3. Test webhook manually in Stripe
4. Check server logs for processing errors

#### Failed Webhook Processing

**Symptom**: "Error" status with failed webhook count increasing

**Possible Causes**:

- Database connection issues
- Invalid webhook signature
- Application error in processing logic

**Resolution**:

1. Check application logs for error details
2. Verify Stripe webhook signing secret is correct
3. Test database connectivity
4. Stripe automatically retries failed webhooks (up to 3 days)

#### Subscription Status Mismatch

**Symptom**: Subscription status in PenguinMails doesn't match Stripe

**Resolution**:

1. Trust Stripe as source of truth
2. **Trigger Manual Sync**: Use the [Force Sync Transaction](#manual-sync-tools) tool with the specific Invoice or Subscription ID
3. Review recent webhook events in Stripe Dashboard
4. Update local status to match Stripe status

---

## Stripe Dashboard Access

### Quick Links from Webhook Status Panel

1. **View Recent Webhooks**: Stripe Dashboard > Webhooks > Event History
2. **View Failed Payments**: Stripe Dashboard > Payments (filtered to failed)
3. **View Invoice Status**: Stripe Dashboard > Invoices
4. **Webhook Logs**: Full event payload and retry history

### What's Available in Stripe

**Webhook Management**:

- Event history (up to 30 days)
- Webhook retry logs
- Manual webhook resend
- Event payload inspection

**Payment Details**:

- Detailed failure reasons
- Customer payment methods
- Retry schedules
- Dunning management

---

## Best Practices

### Monitoring Frequency

- **Finance Team**: Check daily for failed payment count
- **Engineering Team**: Set up alerting for webhook errors
- **Accounting**: Check before monthly reconciliation

### Alert Configuration

**Recommended Alerts**:

- Webhook error rate >5% in 1 hour → Alert engineering team
- No webhooks received in 2 hours → Alert platform team
- Failed payment count >20 → Alert finance team

### Webhook Security

- **Signature Verification**: Always verify `Stripe-Signature` header
- **HTTPS Only**: Webhook endpoint must use HTTPS
- **Idempotency**: Handle duplicate webhooks gracefully
- **Rate Limiting**: Protect webhook endpoint from abuse

---

## Related Documentation

- **[Subscription Monitoring](./subscription-monitoring.md)**: View active subscription counts
- **[Stripe Dashboard Access](./stripe-dashboard-access.md)**: Quick links to Stripe analytics
- **[Stripe Integration](/docs/features/payments/stripe-integration)**: Technical webhook implementation
- **[Finance API](/docs/implementation-technical/api/platform-api/finance)**: API endpoints including Force Sync
- **[Platform Admin Routes - Finance](/docs/design/routes/platform-admin#dashboard-finance)**: Finance dashboard UI specification
- **[OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide)**: Database structure for webhooks
