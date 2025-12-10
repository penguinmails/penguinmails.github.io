---
title: "Invoice Access via Stripe"
description: "Implement invoice list display with links to Stripe Customer Portal"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Team"
parent: "/docs/roadmap/product/payments/README.md"
---

# Invoice Access via Stripe

## Overview

**Priority**: P1 (High)
**Timeline**: Q1 2026 (Week 3-4)
**Effort**: Small (1-2 days)

**Description**:
Implement invoice list display with links to Stripe Customer Portal for PDF access and downloads. Professional businesses need easy invoice access without relying solely on Stripe emails.

## Acceptance Criteria

- Display invoice list from Stripe API (read-only)
- Show invoice details: date, amount, status (paid, pending, failed)
- "View in Stripe" link per invoice opens Stripe Customer Portal
- "Download from Stripe" button redirects to Stripe Customer Portal
- Search invoices by date range
- Filter by status: All, Paid, Pending, Failed
- Sort by date, amount (ascending/descending)
- API endpoint: `GET /api/v1/billing/invoices` (list only, no PDF generation)
- Stripe Customer Portal link for self-service invoice management

## Dependencies

- Stripe API integration (read-only invoice list)
- Stripe Customer Portal configuration
