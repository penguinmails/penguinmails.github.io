---
title: "Failed Payment Recovery Flow"
description: "Implement user-friendly workflow for recovering from failed payments"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Failed Payment Recovery Flow

## Overview

**Priority**: P0 (MVP Blocker)
**Timeline**: Q1 2026 (Week 5-6)
**Effort**: Small (2-3 days)

**Description**:
Implement user-friendly workflow for recovering from failed payments with prominent dashboard banner, one-click retry, and clear failure reasons. Quick recovery prevents service interruption and reduces churn.

## Acceptance Criteria

- Dashboard banner shows failed payment alert (red, dismissible)
- Display failure reason: card declined, insufficient funds, expired card, authentication required
- "Update Payment & Retry" button triggers immediate payment retry
- Countdown timer shows days until account suspension (7 days)
- Email notification with recovery link sent immediately after failure
- Success confirmation after successful retry (banner turns green)
- Redirect to payment method update if retry fails again
- Grace period indicator (read-only access after 7 days)
- API integration: `POST /api/v1/billing/retry-payment`

## Dependencies

- Stripe webhook integration (invoice.payment_failed event)
- Payment retry API
- Email notification system (Loop.so)
