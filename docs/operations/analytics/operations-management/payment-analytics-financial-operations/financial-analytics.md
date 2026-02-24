---
title: "Financial Analytics Framework"
description: "Revenue calculation models, cost breakdown strategies, and executive KPIs."
last_modified_date: "2026-02-24"
level: "2"
persona: "Finance, Executives"
---

## Revenue Metrics

Core streams used for MRR (Monthly Recurring Revenue) and ARR (Annual Recurring Revenue) calculations:

- **Subscription Revenue**: Tier-based monthly/annual charges.
- **Add-on Revenue**: Dedicated IPs, extra domains.
- **Marketplace**: Third-party template and integration commissions.

### ROI & LTV Formulas

```typescript
// Net Revenue Retention (NRR)
const calculateNRR = (startingARR: number, endingARR: number, expansions: number) => {
  return ((endingARR + expansions) / startingARR) * 100;
};

// Customer Lifetime Value (LTV)
const calculateLTV = (arpu: number, margin: number, churn: number) => {
  return (arpu * margin) / (churn / 100);
};
```

## Cost Structure Analysis

- **Fixed Costs**: Infrastructure (VPS, DB), Software licenses, Legal.
- **Variable Costs**: Payment fees (2.9% + $0.30), Email volume costs (per 1k), Acquisition costs (CAC).

### Unit Economics

- **Gross Margin**: Total revenue minus COGS.
- **CAC Payback**: Number of months required to recover acquisition costs.
- **Burn Rate**: Monthly net cash outflow.

## Dashboard KPIs

| KPI | Description | Target |
|-----|-------------|--------|
| **NRR** | Net Revenue Retention | >110% |
| **Gross Margin** | Efficiency of service delivery | >75% |
| **LTV:CAC** | Customer profitability ratio | >3:1 |
| **Churn Rate** | Monthly subscriber loss | <3% |
