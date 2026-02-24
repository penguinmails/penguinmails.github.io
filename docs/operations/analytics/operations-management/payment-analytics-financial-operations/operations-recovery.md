---
title: "Operations Recovery"
description: "Procedures for handling payment failures, chargebacks, and service emergencies."
last_modified_date: "2026-02-24"
level: "2"
persona: "Operations, Support"
---

## Failed Payment Handling

Process: `Detection → Automated Retry → Grace Period → Suspension`

1. **Detection**: Stripe webhook `invoice.payment_failed` triggers a dashboard alert.
2. **Automated Retries**: Scheduled for days 1, 3, and 5 after the initial failure.
3. **Grace Period**: 7-day window where the account remains active but warns the user.
4. **Suspension**: Complete feature lock after grace period; users are directed to the recovery portal.

## Chargeback & Dispute Management

Disputes trigger a high-priority workflow to mitigate revenue loss.

- **Detection**: Webhook `charge.dispute.created`.
- **Evidence Collection**: Gather service agreements, email delivery timestamps, and signup IP logs.
- **Time Limit**: Submissions must be finalized within 7 days.
- **Resolution**: Status is synchronized via Stripe webhooks until final adjudication.

## Emergency Scenarios

### Stripe Outage

1. **Graceful Degradation**: Queue non-critical payment tasks.
2. **Persistence**: Billing state remains cached in NileDB.
3. **Recovery**: Re-sync data once the provider status returns to green.

### Revenue Share Disputes

In a multi-tenant environment, disputes regarding platform fees are escalated to the Finance Reconciler service for manual review and adjustment.
