---
title: "Cost Tracking Schema"
description: "SQL implementation for infrastructure cost modeling fields."
last_modified_date: "2026-02-24"
level: "3"
persona: "DBAs, Backend Engineers"
---

## Infrastructure Cost Modeling

These enhancements allow PenguinMails to approximate infrastructure spend per tenant without relying on provider-level metering APIs.

### 1. VPS Instance Tracking

Added to track Hostwinds-related spend per instance for internal ROI analysis.

```sql
ALTER TABLE vps_instances
ADD COLUMN approximate_cost DECIMAL(8,2) DEFAULT 0.00;

COMMENT ON COLUMN vps_instances.approximate_cost IS
'Estimated monthly cost (USD) for this Hostwinds VPS, derived from Hostwinds pricing APIs. 
Maintained for internal ROI; not authoritative customer billing.';

CREATE INDEX idx_vps_approximate_cost ON vps_instances(approximate_cost) WHERE status = 'active';
```

### 2. SMTP IP Tracking

Added to calculate deliverability ROI and optimize resource allocation.

```sql
ALTER TABLE smtp_ip_addresses
ADD COLUMN approximate_cost DECIMAL(6,2) DEFAULT 0.00;

COMMENT ON COLUMN smtp_ip_addresses.approximate_cost IS
'Internally maintained estimated monthly cost per dedicated IP. Default is typically $4.99.';

CREATE INDEX idx_smtp_approximate_cost ON smtp_ip_addresses(approximate_cost) WHERE status = 'active';
```

## Business Rules

- **Non-negative**: All cost fields must be `>= 0`.
- **Directional**: Fields are modeled by Finance/Operations, not pulled from provider billing real-time.
- **Internal**: These values are used for executive dashboards and are never exposed to end-users.
