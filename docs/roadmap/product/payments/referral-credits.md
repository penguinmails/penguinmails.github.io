---
title: "Referral Credits and Promotional Discounts"
description: "Build referral program with account credits and promotional discount management"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Referral Credits and Promotional Discounts

## Overview

**Priority**: P2 (Medium)
**Timeline**: Q3 2026
**Effort**: Medium (2-3 weeks)

**Description**:
Build referral program with account credits and promotional discount management system. Referral rewards incentivize word-of-mouth growth and reduce customer acquisition costs.

## Acceptance Criteria

- Generate unique referral links per user
- Track referral signups and conversions (signup → paid customer)
- Award $50 credit per successful referral (after first payment)
- Display credit balance in billing dashboard
- Auto-apply credits to invoices (oldest first)
- Create promotional discount codes (percentage, fixed amount)
- Set discount expiration dates and usage limits
- Limit discount usage: one-time, recurring (3 months), unlimited
- Discount analytics dashboard: usage, revenue impact, ROI
- Partner-specific discount codes with tracking

## Dependencies

- Referral tracking system
- Credit balance management
- Discount code engine (Stripe Coupons)
