---
title: "Subscriptions API"
description: "Detailed endpoint specifications for Subscription Management and Billing"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Subscriptions API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)
**URL Prefix**: `/api/v1/platform/subscriptions`

---


## Endpoints


### List Tenant Subscriptions

**Method**: `GET`  
**URL**: `/api/v1/platform/subscriptions`  
**Purpose**: List all tenant subscriptions with filtering and pagination.

**Query Parameters**:


- `status` (optional): Filter by status ('active', 'past_due', 'canceled', 'unpaid')


- `plan_id` (optional): Filter by plan UUID


- `limit` (optional): Number of results (default: 50, max: 100)


- `offset` (optional): Pagination offset (default: 0)

**Response**:


```json
{
  "success": true,
  "data": {
    "subscriptions": [
      {
        "id": "sub_abc123",
        "tenant_id": "tn_123",
        "tenant_name": "Acme Corp",
        "plan": {
          "id": "plan_xyz",
          "name": "Pro",
          "slug": "pro"
        },
        "status": "active",
        "current_period_start": "2025-11-01T00:00:00Z",
        "current_period_end": "2025-12-01T00:00:00Z",
        "cancel_at_period_end": false,
        "stripe_subscription_id": "sub_stripe123"
      }
    ],
    "pagination": {
      "total": 145,
      "limit": 50,
      "offset": 0,
      "has_more": true
    }
  }
}


```


### Get Subscription Details

**Method**: `GET`  
**URL**: `/api/v1/platform/subscriptions/{subscriptionId}`  
**Purpose**: Retrieve detailed information about a specific subscription, including billing history.

**Response**:


```json
{
  "success": true,
  "data": {
    "subscription": {
      "id": "sub_abc123",
      "tenant_id": "tn_123",
      "status": "active",
      "stripe_subscription_id": "sub_stripe123",
      "stripe_customer_id": "cus_stripe456"
    },
    "recent_payments": [
      {
        "id": "pay_123",
        "amount": 189.00,
        "currency": "USD",
        "status": "succeeded",
        "processed": "2025-11-01T00:05:00Z"
      }
    ]
  }
}


```


### Get Tenant Subscription

**Method**: `GET`  
**URL**: `/api/v1/platform/tenants/{tenantId}/subscription`  
**Purpose**: Retrieve the active subscription for a specific tenant.

**Response**:


```json
{
  "success": true,
  "data": {
    "subscription": {
      "id": "sub_abc123",
      "plan": {
        "name": "Pro",
        "slug": "pro",
        "price_monthly": 18900
      },
      "status": "active",
      "current_period_end": "2025-12-01T00:00:00Z"
    },
    "billing_config": {
      "stripe_customer_id": "cus_stripe456",
      "billing_email": "billing@acmecorp.com"
    }
  }
}


```


### Update Subscription Status

**Method**: `PATCH`  
**URL**: `/api/v1/platform/subscriptions/{subscriptionId}`  
**Purpose**: Administrative updates to subscription metadata.

**Request**:


```json
{
  "status": "active",
  "cancel_at_period_end": false,
  "notes": "Manual reactivation after payment issue resolved"
}


```


### Subscription Analytics

**Method**: `GET`  
**URL**: `/api/v1/platform/subscriptions/analytics`  
**Purpose**: Aggregate subscription metrics for business intelligence.

**Query Parameters**:


- `window`: Time window ('weekly', 'monthly', 'quarterly', 'yearly')

**Response**:


```json
{
  "success": true,
  "data": {
    "window": "monthly",
    "metrics": {
      "total_subscriptions": 145,
      "active_subscriptions": 142,
      "monthly_recurring_revenue": 12450.00,
      "churn_rate": "2.1%"
    }
  }
}


```

