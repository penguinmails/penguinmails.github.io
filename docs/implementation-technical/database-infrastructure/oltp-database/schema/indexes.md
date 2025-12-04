---
title: "Indexes & Performance"
description: "Database indexes and performance optimization"
last_modified_date: "2025-12-04"
level: "3"
keywords: "indexes, performance, optimization"
---


#### **vps_instances** - VPS Server Instances

```sql
CREATE TABLE vps_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hostwinds_instance_id VARCHAR(255) UNIQUE,
    ip_address VARCHAR(45),
    region VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('active', 'provisioning', 'scheduled_decommission', 'decommissioned')),
    monthly_cost DECIMAL(10,2),
    approximate_cost DECIMAL(8,2), -- Business cost attribution for tenant cost analysis
    hostwinds_billing_day INTEGER,
    current_billing_period_start TIMESTAMP WITH TIME ZONE,
    current_billing_period_end TIMESTAMP WITH TIME ZONE,
    decommission_scheduled_for TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

**Business Justification**: The `approximate_cost` field enables business leaders to track infrastructure costs per tenant for cost optimization and profitability analysis, supporting executive decision-making for resource allocation and pricing strategy.

#### **smtp_ip_addresses** - SMTP IP Addresses

```sql
CREATE TABLE smtp_ip_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vps_instance_id UUID REFERENCES vps_instances(id) ON DELETE CASCADE,
    ip_address VARCHAR(45) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('available', 'assigned', 'warming', 'warmed', 'degraded', 'burned', 'quarantined')),
    reputation_state VARCHAR(50) CHECK (reputation_state IN ('good', 'fair', 'poor', 'critical')),
    approximate_cost DECIMAL(6,2), -- Email service cost per IP for business analysis
    last_reputation_check TIMESTAMP WITH TIME ZONE,
    assigned_count INTEGER DEFAULT 0,
    provider_blacklist_status JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

**Business Justification**: The `approximate_cost` field supports deliverability cost analysis and email service ROI calculations, enabling business leaders to optimize IP allocation and understand the true cost of email deliverability solutions.

#### **domain_ip_assignments** - Domain-to-IP Mappings

```sql
CREATE TABLE domain_ip_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
    smtp_ip_address_id UUID REFERENCES smtp_ip_addresses(id) ON DELETE CASCADE,
    status VARCHAR(50) CHECK (status IN ('active', 'warming', 'scheduled', 'expired')),
    assigned TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires TIMESTAMP WITH TIME ZONE,
    warmup_state VARCHAR(50) CHECK (warmup_state IN ('unwarmed', 'warming', 'warmed')),
    last_sent TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

---

## Staff & Permissions Management

### **Staff System**

#### **staff_members** - Staff User Mapping

```sql
CREATE TABLE staff_members (
    user_id UUID PRIMARY KEY REFERENCES users(id),
    role_id INTEGER REFERENCES staff_roles(id),
    notes TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

#### **staff_roles** - Role Definitions

```sql
CREATE TABLE staff_roles (
    id INTEGER PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    description TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

#### **staff_role_permissions** - Role Permissions

```sql
CREATE TABLE staff_role_permissions (
    role_id INTEGER REFERENCES staff_roles(id),
    permission_id INTEGER REFERENCES permissions(id),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (role_id, permission_id)
);


```

#### **permissions** - Permission Definitions

```sql
CREATE TABLE permissions (
    id INTEGER PRIMARY KEY,
    name VARCHAR(100) UNIQUE,
    description TEXT,
    category VARCHAR(50) DEFAULT 'general',
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

---

## System Configuration & Settings

### **Configuration & Settings**

#### **system_config** - System-Wide Configuration

```sql
CREATE TABLE system_config (
    key VARCHAR(255) PRIMARY KEY,
    value JSONB,
    description VARCHAR(500),
    category VARCHAR(50),
    is_sensitive BOOLEAN DEFAULT FALSE,
    updated_by UUID REFERENCES users(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Platform Stripe account for receiving payments (separate from tenant customer accounts)
-- This is stored in system_config with key='stripe_account_id' as a single row


```

#### **feature_flags** - Feature Flag Management

```sql
CREATE TABLE feature_flags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    is_enabled BOOLEAN DEFAULT FALSE,
    rollout_percentage INTEGER DEFAULT 0,
    updated_by UUID REFERENCES users(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

#### **user_preferences** - User Preferences

```sql
CREATE TABLE user_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    theme VARCHAR(50) DEFAULT 'light',
    language VARCHAR(10) DEFAULT 'en',
    timezone VARCHAR(100) DEFAULT 'UTC',
    email_notifications BOOLEAN DEFAULT TRUE,
    push_notifications BOOLEAN DEFAULT TRUE,
    weekly_reports BOOLEAN DEFAULT FALSE,
    marketing_emails BOOLEAN DEFAULT FALSE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

#### **tenant_config** - Tenant Configuration

```sql
CREATE TABLE tenant_config (
    tenant_id UUID PRIMARY KEY REFERENCES tenants(id),
    stripe_customer_id VARCHAR(255),
    billing_email VARCHAR(255),
    billing_address JSONB,
    notify_on_billing_changes BOOLEAN DEFAULT FALSE,
    notify_on_system_updates BOOLEAN DEFAULT FALSE,
    notify_on_security_alerts BOOLEAN DEFAULT FALSE,
    theme_primary_color VARCHAR(7),
    theme_logo_url VARCHAR(500),
    theme_favicon_url VARCHAR(500),
    ui_sidebar_default_collapsed BOOLEAN DEFAULT FALSE,
    ui_date_format VARCHAR(20),
    ui_timezone VARCHAR(50),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

#### **tenant_policies** - Tenant Security Policies

```sql
CREATE TABLE tenant_policies (
    tenant_id UUID PRIMARY KEY REFERENCES tenants(id),
    password_min_length INTEGER DEFAULT 8,
    password_require_uppercase BOOLEAN DEFAULT FALSE,
    password_require_numbers BOOLEAN DEFAULT FALSE,
    password_require_symbols BOOLEAN DEFAULT FALSE,
    session_timeout_hours INTEGER DEFAULT 8,
    max_login_attempts INTEGER DEFAULT 5,
    two_factor_required BOOLEAN DEFAULT FALSE,
    company_default_status VARCHAR(50) DEFAULT 'active',
    company_allow_member_invites BOOLEAN DEFAULT TRUE,
    company_auto_approve_members BOOLEAN DEFAULT FALSE,
    company_require_email_verification BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);


```

---

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

