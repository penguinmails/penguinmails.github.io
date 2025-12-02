---
title: "Billing Operations Guide"
description: "Standard operating procedures for billing, payments, and subscription management"
last_modified_date: "2025-12-02"
level: "2"
persona: "Operations & Support"
status: "ACTIVE"
category: "Operations"
---

# Billing Operations Guide

## For Operations & Support Staff

This guide outlines the standard procedures for handling billing inquiries, payment issues, and subscription management.

---

## 1. System Overview

PenguinMails uses **Stripe** as the payment processor and source of truth for all billing data.

- **Stripe**: Handles credit cards, charging, invoices, and receipts.
- **PenguinMails DB**: Mirrors Stripe status via webhooks.
- **Admin Dashboard**: Your primary tool for viewing status and performing basic actions.
- **Stripe Dashboard**: Advanced actions (refunds, disputes) - restricted access.

---

## 2. Common Workflows

### 🔍 Customer Lookup

**Goal**: Find a user's billing details.

1. Go to **Admin Dashboard > Users**.
2. Search by email or name.
3. Click **View Details**.
4. Look for the **Subscription** card:
    - **Plan**: Current tier (e.g., Pro Monthly).
    - **Status**: `active`, `past_due`, `canceled`.
    - **Stripe ID**: Links directly to the customer in Stripe (if you have access).

### 💳 Handling Refunds

**Policy**: Refunds are approved for technical errors or within 7 days of accidental renewal.

1. **Verify Eligibility**: Check if the request meets the refund policy.
2. **Process in Stripe** (Requires Finance/Admin Role):
    - Locate the **Payment** in Stripe Dashboard.
    - Click **Refund**.
    - Select reason (e.g., "Duplicate", "Requested by customer").
    - **Note**: Partial refunds are possible for unused time.
3. **Log the Action**: Add a note in the user's admin profile or support ticket.

### 🛑 Cancellations

**Goal**: Help a user cancel who cannot access the portal.

1. **Direct User to Portal**: Always encourage self-service via "Manage Subscription" in their dashboard.
2. **Manual Cancellation** (If user is locked out):
    - Go to **Admin Dashboard > Tenants**.
    - Find the tenant.
    - Select **Cancel Subscription**.
    - **Option**: "Cancel Immediately" vs "Cancel at Period End" (Preferred).

### 🎁 Granting Comps / Extensions

**Goal**: Give free access for support recovery or VIPs.

1. Go to **Admin Dashboard > Tenants**.
2. Select **Edit Plan / Override**.
3. Choose **Plan**: "Pro" (or relevant tier).
4. **Discount/Comp**:
    - Apply "100% Off Coupon" (if integrated).
    - Or set "Trial End Date" to a future date (e.g., +30 days).

---

## 3. Troubleshooting Payments

### "My payment failed"

**Diagnosis**:

1. Check **Admin Dashboard** for `past_due` status.
2. Check **Stripe Dashboard** (or logs) for decline reason:
    - `insufficient_funds`: User needs to top up.
    - `do_not_honor`: Bank blocked it (User must call bank).
    - `expired_card`: User needs to update card.

**Resolution**:

- Send user the "Update Payment Method" link (from their dashboard).
- Stripe automatically retries 3 times over 2 weeks.

### "I was charged twice"

**Diagnosis**:

1. Check **Stripe** for duplicate charges on the same day.
2. **Scenario A**: Two separate accounts? (Search by last 4 digits of card).
3. **Scenario B**: Authorization hold vs. Charge? (Holds disappear in 5-7 days).

**Resolution**:

- If true duplicate: Refund one immediately.

---

## 4. Dispute Management (Chargebacks)

**⚠️ Critical**: Disputes hurt our reputation with Visa/Mastercard.

1. **Notification**: Finance team receives dispute alert.
2. **Investigation**:
    - Did the user log in? (Check Audit Trail).
    - Did they use the service? (Check Email Volume).
3. **Response**:
    - **Accept**: If fraud is suspected or amount is small (<$20).
    - **Challenge**: If we have proof of usage. Submit evidence (Logs, ToS acceptance) via Stripe.

---

## 5. Escalation Matrix

| Issue | Escalation Route | SLA |
|---|---|---|
| **Standard Refund** | Support Lead | 24h |
| **Dispute / Chargeback** | Finance Team | 48h |
| **Stripe Sync Error** | Engineering (Platform) | 4h |
| **Mass Payment Failure** | Engineering (Critical) | 15m |

---

## Related Documentation

- [Stripe Integration Details](/docs/features/payments/stripe-integration)
- [Admin Route Specs](/docs/design/routes/platform-admin-plans)
