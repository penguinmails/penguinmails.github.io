---
title: "Flexible Payment Options and Installments"
description: "Add alternative payment methods including ACH, wire transfer, and purchase orders"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Flexible Payment Options and Installments

## Overview

**Priority**: P2 (Medium)
**Timeline**: Q2 2026
**Effort**: Medium (2-3 weeks)

**Description**:
Add alternative payment methods including ACH, wire transfer, purchase orders, and installment plans. Enterprise customers require payment methods that match their procurement processes.

## Acceptance Criteria

- ACH direct debit for US customers (Stripe ACH)
- SEPA direct debit for EU customers
- Wire transfer instructions on invoices (manual payment recording)
- Purchase order upload and tracking workflow
- Installment plans: 3, 6, 12 months for annual subscriptions
- Manual payment recording by admin (for wire transfers, checks)
- Payment reminders for pending invoices (7, 14, 30 days)
- Support check payments with manual recording
- API integration: `POST /api/v1/billing/payment/manual`
- Payment status tracking: pending, processing, completed

## Dependencies

- Stripe ACH/SEPA integration
- Manual payment recording system
- Purchase order management
