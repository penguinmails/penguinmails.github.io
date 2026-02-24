---
title: "Payment & Billing Journey"
description: "End-to-end user journey for payments, billing, and subscription management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Users, Customer Success"
---

## Payment & Billing Journey

### Journey Flow

`Stripe Connect Setup → Payment Method → Subscription Activation → Billing Dashboard`

### Normal Payment Flow

#### 1. Onboarding Payment Setup

- **Context**: User reaches payment setup logic in the standard onboarding flow.
- **Workflow**:
  - **Onboarding Modal**: Triggered when a new user enters the billing step.
  - **Stripe Connect Express Setup**: External redirect to Stripe for business verification (Legal name, Tax ID, SSN).
  - **Payment Method Addition**: PCI-compliant tokenization via Stripe Elements inside PenguinMails.
  - **Subscription Activation**: Immediate feature access (IPs, volume, seats) after confirmation.

#### 2. Ongoing Billing Management

- **Dashboard Widgets**: Real-time monitoring of email volume, IP reputation, and monthly spending.
- **Alert System**: Threshold notifications at 80% and 100% usage.
- **Payment Method Management**: Add/remove cards and update billing addresses via `/billing`.
- **Invoice Access**: Detailed PDF downloads and historical payment tracking.

---

## Plan Changes & Proration

When a user upgrades or downgrades:

1. **Selection**: Choose new tier in the billing portal.
2. **Proration**: Calculate unused time credits vs. new plan costs.
3. **Activation**: Immediate granting of new feature limits.
4. **Lifecycle**: New billing cycle reflects the adjusted plan.
