---
title: "User Flows"
description: "Key user journeys and system flows"
last_modified_date: "2025-12-02"
type: "design"
status: "DRAFT"
---

# User Flows

**Visualizing critical user journeys through the platform.**

---

## Subscription Lifecycle

### 1. Subscription Creation (Onboarding)

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Stripe
    participant DB

    User->>App: Select Plan (Pro Monthly)
    App->>Stripe: Create Checkout Session
    Stripe-->>App: Session URL
    App->>User: Redirect to Checkout
    User->>Stripe: Enter Payment Details
    Stripe->>Stripe: Process Payment
    Stripe->>App: Webhook (checkout.session.completed)
    App->>DB: Create Subscription (Active)
    Stripe->>User: Redirect to Success Page
    App->>User: Welcome Email
```

### 2. Plan Upgrade/Downgrade

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Stripe
    participant DB

    User->>App: Request Upgrade (Business Tier)
    App->>Stripe: Preview Proration
    Stripe-->>App: Proration Amount ($12.50 due now)
    App->>User: Show Confirmation Modal
    User->>App: Confirm Upgrade
    App->>Stripe: Update Subscription
    Stripe->>App: Webhook (customer.subscription.updated)
    App->>DB: Update Plan & Limits
    App->>User: Success Message
```

### 3. Cancellation

```mermaid
sequenceDiagram
    participant User
    participant App
    participant Stripe
    participant DB

    User->>App: Click "Cancel Subscription"
    App->>User: Show Retention Offer / Survey
    User->>App: Confirm Cancellation
    App->>Stripe: Update (cancel_at_period_end=true)
    Stripe->>App: Webhook (customer.subscription.updated)
    App->>DB: Set cancel_at_period_end=true, cancel_reason
    App->>User: "Access continues until [Date]"
```

### 4. Payment Failure (Dunning)

```mermaid
sequenceDiagram
    participant Stripe
    participant App
    participant User

    Stripe->>Stripe: Payment Failed
    Stripe->>App: Webhook (invoice.payment_failed)
    App->>User: Send Dunning Email
    App->>User: Show Dashboard Banner
    Note over Stripe,User: Retry Schedule (Days 3, 5, 7)
    Stripe->>Stripe: Final Failure (Day 14)
    Stripe->>App: Webhook (subscription.deleted)
    App->>App: Deactivate Tenant
```
