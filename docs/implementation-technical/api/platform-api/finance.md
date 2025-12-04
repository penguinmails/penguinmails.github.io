---
title: "Finance API"
description: "Revenue operations, MRR tracking, and financial reporting endpoints"
last_modified_date: "2025-12-04"
level: "3"
persona: "Backend Developers"
---

# Finance API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)  
**URL Prefix**: `/api/v1/platform/finance`

---

---

## Overview

The Finance API provides endpoints for basic subscription monitoring and Stripe webhook status. For detailed revenue analytics, MRR tracking, and financial reporting, use the **Stripe Dashboard** or **Stripe API** directly.

> [!IMPORTANT]
> **Stripe-First Approach**: PenguinMails stores only minimal payment references for access control. All MRR calculations, revenue analytics, and invoice management are handled by Stripe.

---

## Endpoints

### Get Subscription Summary

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/subscription-summary`  
**Purpose**: Retrieve basic subscription counts and plan distribution

**Response**:

```json
{
  "success": true,
  "data": {
    "active_subscriptions": 234,
    "plan_distribution": [
      { "plan_id": "uuid-free", "plan_name": "Free", "count": 45 },
      { "plan_id": "uuid-pro", "plan_name": "Pro", "count": 150 },
      { "plan_id": "uuid-enterprise", "plan_name": "Enterprise", "count": 39 }
    ],
    "stripe_dashboard_url": "https://dashboard.stripe.com/revenue",
    "as_of": "2025-12-04T12:00:00Z"
  }
}
```

**Note**: For MRR calculations, revenue trends, and detailed analytics, use Stripe Dashboard.

---

### Get Stripe Sync Status

**Method**: `GET`  
**URL**: `/api/v1/platform/finance/stripe-sync-status`  
**Purpose**: Monitor Stripe webhook health

**Response**:

```json
{
  "success": true,
  "data": {
    "last_webhook_received": "2025-12-04T12:05:00Z",
    "webhook_health": "healthy",
    "failed_payments_count": 3,
    "last_webhook_event": {
      "id": "evt_abc123",
      "type": "invoice.paid",
      "timestamp": "2025-12-04T12:05:00Z"
    },
    "stripe_dashboard_url": "https://dashboard.stripe.com/payments"
  }
}
```

**Webhook Health Values**:

- `healthy`: Webhooks received within last 10 minutes
- `delayed`: No webhook in 10+ minutes
- `error`: Webhook processing errors detected

---

## For MRR and Revenue Analytics

Use Stripe directly for:

- **MRR Tracking**: Stripe Dashboard → Revenue section
- **Revenue Trends**: Stripe Dashboard → Reports
- **Invoice Management**: Stripe Dashboard → Invoices
- **Payment History**: Stripe Dashboard → Payments
- **Custom Reports**: Stripe Sigma (SQL-based queries)
- **Data Export**: Stripe API or Stripe Dashboard exports

### Stripe API Endpoints

For programmatic access to revenue data:

- `GET /v1/subscriptions` - List all subscriptions
- `GET /v1/invoices` - List invoices
- `GET /v1/charges` - List payment charges
- Stripe Sigma - Custom SQL queries on Stripe data

---

## Error Handling

- `400 Bad Request`: Invalid parameters
- `401 Unauthorized`: Missing or invalid token
- `403 Forbidden`: User does not have Finance role
- `429 Too Many Requests`: Rate limit exceeded (max 100 requests/minute)

---

## Related Documentation

- [Finance Feature](/docs/features/admin/finance/) - Feature overview
- [Platform Admin Routes - Finance](/docs/design/routes/platform-admin#dashboard-finance) - UI specification
- [Subscriptions API](/docs/implementation-technical/api/platform-api/subscriptions) - Subscription data
- [Stripe Integration](/docs/features/payments/stripe-integration) - Stripe integration guide
