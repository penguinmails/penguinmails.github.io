---
title: "Performance & Security"
description: "Indexing strategies and RBAC/RLS security for financial views."
last_modified_date: "2026-02-24"
level: "3"
persona: "Security Engineers, DBAs"
---

## Performance Optimization

### Indexing Strategy

To ensure <3 second load times for executive dashboards, the following indexes are implemented:

```sql
-- View specific indexes
CREATE INDEX idx_exec_summary_tenant ON executive_business_summary(tenant_id);
CREATE INDEX idx_exec_summary_date ON executive_business_summary(dashboard_date);

-- Profitability query speed
CREATE INDEX idx_cost_allocation_profit ON business_cost_allocation(monthly_profit) 
WHERE monthly_profit > 0;
```

### Resource Benchmarks

- **Concurrent Users**: Support for 100+ simultaneous executive sessions.
- **Latency**: <500ms for health check summaries; <5s for complex cost breakdowns.

---

## Security & Access Control

### Role-Based Access Control (RBAC)

Financial data is restricted to internal roles:

- `business_analysts`: Read-only access to views.
- `db_administrators`: Full schema management.
- `application_service`: Automated sync permissions.

### Row-Level Security (RLS)

Ensures data isolation between internal administrative tenants.

```sql
CREATE POLICY exec_summary_isolation ON executive_business_summary
FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY cost_allocation_isolation ON business_cost_allocation
FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```
