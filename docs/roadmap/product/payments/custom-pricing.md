---
title: "Custom Pricing and Enterprise Billing"
description: "Build flexible pricing engine for enterprise customers with custom contracts"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Custom Pricing and Enterprise Billing

## Overview

**Priority**: P1 (High)
**Timeline**: Q2 2026
**Effort**: Large (2-3 weeks)

**Description**:
Build flexible pricing engine for enterprise customers with custom contracts, volume discounts, negotiated terms, and custom billing cycles. Enterprise segment requires pricing that matches their scale and procurement requirements.

## Acceptance Criteria

- Admin can configure custom pricing per tenant (override standard rates)
- Volume discount tiers (e.g., 10% off for 1M+ emails/month)
- Custom billing cycles: monthly, quarterly, annual prepay
- Custom payment terms: Net 30, Net 60, Net 90
- Contract management with start date, end date, renewal date
- Minimum commitment tracking with alerts before renewal
- Custom invoice templates for enterprise (company branding)
- API endpoints: `POST /api/v1/admin/pricing/custom`, `GET /api/v1/admin/contracts`
- Contract renewal workflow with notifications
- Negotiated rate overrides per feature/add-on

## Dependencies

- Admin dashboard for pricing configuration
- Contract management system
- Custom invoice generation
- Enterprise tier features
