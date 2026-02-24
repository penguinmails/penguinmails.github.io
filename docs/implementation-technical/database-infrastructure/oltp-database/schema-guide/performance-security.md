---
title: "OLTP Schema - Performance & Security"
description: "Critical database indexes and Row Level Security implementation details."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Performance & Security

## Performance Indexes

### **Critical OLTP Indexes**

```sql
-- Multi-tenant filtering
CREATE INDEX idx_campaigns_tenant ON campaigns(tenant_id);
CREATE INDEX idx_leads_tenant ON leads(tenant_id);
CREATE INDEX idx_domains_tenant ON domains(tenant_id);
CREATE INDEX idx_email_accounts_tenant ON email_accounts(tenant_id);

-- Campaign orchestration
CREATE INDEX idx_campaign_sequence_steps_campaign_order ON campaign_sequence_steps(campaign_id, step_order);

-- User and tenant management
CREATE INDEX idx_tenant_users_tenant ON tenant_users(tenant_id);
CREATE INDEX idx_tenant_users_user ON tenant_users(user_id);

-- Infrastructure
CREATE INDEX idx_smtp_ip_addresses_status ON smtp_ip_addresses(status);
CREATE INDEX idx_domain_ip_assignments_domain ON domain_ip_assignments(domain_id);
```

---

## Security & RLS Policies

### **Row Level Security Implementation**

```sql
-- Enable RLS on all multi-tenant tables
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_preferences ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_config ENABLE ROW LEVEL SECURITY;
ALTER TABLE tenant_policies ENABLE ROW LEVEL SECURITY;

-- Tenant isolation policies
CREATE POLICY campaigns_tenant_isolation ON campaigns
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY leads_tenant_isolation ON leads
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY domains_tenant_isolation ON domains
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY email_accounts_tenant_isolation ON email_accounts
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY templates_tenant_isolation ON templates
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY companies_tenant_isolation ON companies
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

-- User-specific isolation for preferences
CREATE POLICY user_preferences_isolation ON user_preferences
    FOR ALL USING (user_id = current_setting('app.current_user_id')::uuid);

-- Tenant-wide configuration isolation
CREATE POLICY tenant_config_isolation ON tenant_config
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY tenant_policies_isolation ON tenant_policies
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```
