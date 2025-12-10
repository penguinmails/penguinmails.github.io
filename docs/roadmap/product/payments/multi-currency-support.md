---
title: "Multi-Currency Support"
description: "Implement multi-currency support with automatic conversion and local payment methods"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Multi-Currency Support

## Overview

**Priority**: P1 (High)
**Timeline**: Q3 2026
**Effort**: Large (3-4 weeks)

**Description**:
Implement multi-currency support with automatic conversion, local payment methods, and currency-specific invoicing. International expansion requires localized pricing and payment options to reduce friction.

## Acceptance Criteria

- Support EUR, GBP, CAD, AUD currencies (expandable)
- Automatic currency detection by IP/locale with manual override
- Display prices in selected currency throughout app
- Local payment methods: SEPA (EU), iDEAL (Netherlands), Bancontact (Belgium)
- Currency-specific invoices with local tax (VAT, GST)
- Multi-currency financial reporting for finance team
- Exchange rate updates (daily via API)
- Currency preference saved per tenant
- Stripe multi-currency setup
- Tax calculation per country (Stripe Tax integration)

## Dependencies

- Stripe multi-currency configuration
- Tax calculation service (Stripe Tax or TaxJar)
- Currency conversion API
- Localization system
