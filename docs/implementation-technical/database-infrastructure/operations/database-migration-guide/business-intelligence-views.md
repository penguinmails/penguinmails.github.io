---
title: "Business Intelligence Views"
description: "SQL view definitions for executive reporting and cost allocation."
last_modified_date: "2026-02-24"
level: "3"
persona: "BI Engineers, Executives"
---

## Executive Summary View

**Purpose**: High-level business health metrics (Health Status, Gross Margin, Cost Efficiency).

```sql
CREATE OR REPLACE VIEW executive_business_summary AS
SELECT
    s.tenant_id,
    p.name as plan_name,
    COALESCE(p.price_monthly, 0) as monthly_revenue,
    (COALESCE(SUM(vi.approximate_cost), 0) + COALESCE(SUM(sia.approximate_cost), 0)) as operational_cost,
    CASE
        WHEN p.price_monthly > (operational_cost * 2) THEN 'Excellent'
        WHEN p.price_monthly > operational_cost THEN 'Monitor'
        ELSE 'Critical Action Required'
    END as status
FROM subscriptions s
JOIN plans p ON p.id = s.plan_id
LEFT JOIN vps_instances vi ON vi.status = 'active'
LEFT JOIN smtp_ip_addresses sia ON sia.vps_instance_id = vi.id
GROUP BY s.tenant_id, p.name, p.price_monthly;
```

## Business Cost Allocation View

**Purpose**: Detailed, heuristic cost breakdown for unit economic analysis.

```sql
CREATE OR REPLACE VIEW business_cost_allocation AS
SELECT
    s.tenant_id,
    p.price_monthly,
    SUM(vi.approximate_cost) as infra_cost,
    -- Cost per email calculation logic:
    CASE
        WHEN SUM(ba.emails_sent) > 0
        THEN (infra_cost / SUM(ba.emails_sent))
        ELSE 0
    END as cost_per_email
FROM subscriptions s
JOIN plans p ON s.plan_id = p.id
LEFT JOIN billing_analytics ba ON ba.subscription_id = s.id
GROUP BY s.tenant_id, p.price_monthly;
```

## Usage in Dashboards

- **Daily Health Check**: Filter by `dashboard_date` to see immediate status.
- **Profitability Analysis**: Compare `monthly_revenue` vs. `total_monthly_cost` across cohorts.
