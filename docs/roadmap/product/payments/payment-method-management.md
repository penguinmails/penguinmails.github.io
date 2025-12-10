---
title: "Payment Method Management UI"
description: "Build in-app payment method management using Stripe Elements"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Payment Method Management UI

## Overview

**Priority**: P1 (High)
**Timeline**: Q1 2026 (Week 4-5)
**Effort**: Medium (4-6 days)

**Description**:
Build in-app payment method management using Stripe Elements for seamless card updates without external redirects. Payment failures are a major churn driver - making updates easy is critical for retention.

## Acceptance Criteria

- Display current payment method with last 4 digits, brand (Visa, Mastercard), expiration date
- In-app card update form using Stripe Elements (PCI compliant)
- Support multiple payment methods (primary + backup cards)
- Set default payment method with radio button selection
- Delete old payment methods with confirmation modal
- Verify new payment method with $1 test charge (refunded immediately)
- Loading states during card verification
- Error handling for invalid cards, expired cards, declined cards
- Success confirmation after payment method update

## Dependencies

- Stripe Elements integration
- Stripe payment method API
- Payment method verification logic
