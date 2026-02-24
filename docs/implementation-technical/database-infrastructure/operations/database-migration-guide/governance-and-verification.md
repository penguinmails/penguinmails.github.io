---
title: "Governance & Verification"
description: "Attribution rules, communication guidelines, and rollback procedures."
last_modified_date: "2026-02-24"
level: "3"
persona: "Executives, Operations"
---

## Governance Rules

### Cost Attribution

- **NileDB**: Database/Auth is treated as a shared overhead; we do NOT attempt per-tenant metering for NileDB resources.
- **Hostwinds**: Primary source for VPS and IP pricing. Values are populated via Hostwinds APIs (e.g., `get_price_list`).

### Communication Guidelines

- **Internal Only**: These models are used for PenguinMails business planning. They are NOT authoritative billing documents.
- **Disclaimer**: Official customer invoices originate from Stripe; internal modeling is used for directional sustainability analysis only.

## Verification Checklist

- [ ] **Schema Check**: Columns `approximate_cost` exist in target tables.
- [ ] **Calculation Check**: Profits = Revenue - (VPS Costs + IP Costs).
- [ ] **Audit Check**: Access logs confirm only authorized roles accessed BI views.

## Rollback Procedures

In the event of a critical failure after migration:

```sql
-- 1. Remove views
DROP VIEW IF EXISTS executive_business_summary;

-- 2. Remove indexes
DROP INDEX IF EXISTS idx_vps_approximate_cost;

-- 3. Reset values (Alternative to dropping columns)
UPDATE vps_instances SET approximate_cost = 0.00;
```

> [!WARNING]
> Only drop columns as an absolute last resort, as this will result in permanent loss of modeled historical data.
