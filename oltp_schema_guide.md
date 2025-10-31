# OLTP Schema Guide - Operational Database

## Overview

The **OLTP (Online Transaction Processing) Database** is PenguinMails' primary operational database designed for fast transactional operations, real-time data access, and primary business logic execution.

### 🎯 **Purpose & Characteristics**

- **Primary Focus**: Fast queries, quick inserts, operational metadata
- **Performance**: Optimized for high-frequency operations and small record sizes
- **Architecture**: Normalized for data integrity, indexed for speed
- **Multi-Tenant**: Row Level Security (RLS) for complete tenant isolation

### ⚡ **Performance Strategy**

- **Denormalized Fields**: `tenant_id` on operational tables for fast filtering
- **Index Coverage**: Covering indexes for common query patterns
- **Connection Pooling**: Aggressive pooling for high-throughput operations
- **Partitioning**: Consider date-based partitioning for large operational tables

---

## 🏗️ **Core Multi-Tenant Infrastructure**

### **NileDB-Managed Tables** (Authentication & User Management)

#### **users** - User Identity & Profile
```sql
CREATE TABLE users (
    id UUID PRIMARY KEY,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted TIMESTAMP WITH TIME ZONE,
    name TEXT,
    family_name TEXT,
    given_name TEXT,
    email TEXT,
    picture TEXT,
    email_verified TIMESTAMP WITH TIME ZONE
);
```

#### **tenants** - Tenant Organization
```sql
CREATE TABLE tenants (
    id UUID PRIMARY KEY,
    name TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted TIMESTAMP WITH TIME ZONE,
    compute_id UUID
);
```

#### **tenant_users** - Multi-Tenant User Associations
```sql
CREATE TABLE tenant_users (
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted TIMESTAMP WITH TIME ZONE,
    roles TEXT[] DEFAULT '{}' "NileDB-managed ARRAY - mandatory for authentication",
    email TEXT,
    PRIMARY KEY (tenant_id, user_id)
);
```

---

## 🏢 **Business Logic Tables**

### **Company & Workspace Management**

#### **companies** - Tenant Workspaces
```sql
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    workspace_name VARCHAR(255) UNIQUE,
    logo_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Domain Management**

#### **domains** - Email Sending Domains
```sql
CREATE TABLE domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    domain VARCHAR(253) NOT NULL,
    verification_status VARCHAR(50) DEFAULT 'pending',
    dns_records JSONB,
    is_primary BOOLEAN DEFAULT FALSE,
    verified TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **email_accounts** - Email Account Configuration
```sql
CREATE TABLE email_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    provider VARCHAR(50) DEFAULT 'mailu',
    vault_key_path VARCHAR(500),
    imap_settings JSONB,
    smtp_settings JSONB,
    status VARCHAR(50) DEFAULT 'active',
    last_warmed TIMESTAMP WITH TIME ZONE,
    daily_count INTEGER DEFAULT 0,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Lead Management**

#### **leads** - Contact Database
```sql
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(200),
    company VARCHAR(200),
    status VARCHAR(20) DEFAULT 'active',
    updated TIMESTAMP WITH TIME ZONE,
    
    UNIQUE(tenant_id, email)
);
```

### **Template Management**

#### **templates** - Email Templates
```sql
CREATE TABLE templates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    name VARCHAR(100) NOT NULL,
    subject VARCHAR(255),
    content TEXT,
    is_started BOOLEAN DEFAULT FALSE,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **Template Organization**
```sql
-- Template folders for organization (UUID → BIGINT optimization)
CREATE TABLE folders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Template-to-folder mapping (UUID → BIGINT optimization)
CREATE TABLE template_folders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    folder_id BIGINT REFERENCES folders(id) ON DELETE CASCADE,
    updated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, folder_id)
);

-- Template tagging system (UUID → BIGINT optimization)
CREATE TABLE tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    value TEXT NOT NULL,
    description TEXT,
    name TEXT,
    tenant_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE template_tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    tag_id BIGINT REFERENCES tags(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, tag_id)
);
```

---

## 📧 **Email Message System (OLTP Metadata)**

### **Message Tracking & Orchestration**

#### **inbox_message_refs** - Email Message Metadata
```sql
CREATE TABLE inbox_message_refs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email_account_id UUID REFERENCES email_accounts(id),
    campaign_id UUID, -- Nullable - not all messages are from campaigns
    lead_id UUID REFERENCES leads(id),
    parent_message_id UUID REFERENCES inbox_message_refs(id),
    direction VARCHAR(20) CHECK (direction IN ('inbound', 'outbound')),
    message_type VARCHAR(20) CHECK (message_type IN ('email', 'bounce', 'auto_reply')),
    from_email VARCHAR(254),
    to_email VARCHAR(254),
    subject VARCHAR(500),
    status VARCHAR(50) CHECK (status IN ('queued', 'sent', 'delivered', 'bounced', 'failed', 'opened', 'replied')),
    processed TIMESTAMP WITH TIME ZONE,
    content_storage_key VARCHAR(500),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Key Features:**
- **Direction**: 'inbound' for replies, 'outbound' for campaign sends
- **Message Types**: 'email', 'bounce', 'auto_reply' for different message categories
- **Content Storage**: References Content Database via `content_storage_key`
- **Threading**: `parent_message_id` for email thread support
- **Status Progression**: queued → sent → delivered → [opened/replied/bounced]

---

## 📊 **Campaign Management**

### **Campaign Orchestration**

#### **campaigns** - Campaign Definitions
```sql
CREATE TABLE campaigns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(50) CHECK (status IN ('draft', 'scheduled', 'sending', 'completed', 'paused')),
    scheduled TIMESTAMP WITH TIME ZONE,
    completed TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **campaign_sequence_steps** - Individual Campaign Steps
```sql
CREATE TABLE campaign_sequence_steps (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    campaign_id UUID REFERENCES campaigns(id) ON DELETE CASCADE,
    step_order INTEGER NOT NULL,
    step_type VARCHAR(50) CHECK (step_type IN ('email', 'wait', 'condition')),
    email_account_id UUID REFERENCES email_accounts(id),
    template_id UUID REFERENCES templates(id),
    subject_override VARCHAR(500),
    from_name_override VARCHAR(100),
    wait_duration_hours INTEGER,
    wait_until_date TIMESTAMP WITH TIME ZONE,
    condition_type VARCHAR(50),
    condition_value VARCHAR(100),
    send_condition TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    executed_count INTEGER DEFAULT 0,
    last_executed TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Step Types:**
- **email**: Send email using template
- **wait**: Delay before next step
- **condition**: Conditional logic based on lead behavior

---

## 💰 **Billing & Subscription Management**

### **Subscription Plans**

#### **plans** - Subscription Plan Definitions
```sql
CREATE TABLE plans (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    slug VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    max_users INTEGER,
    max_domains INTEGER,
    max_campaigns_per_month INTEGER,
    api_rate_limit INTEGER,
    max_email_accounts INTEGER,
    max_emails_per_month INTEGER,
    max_warmups INTEGER,
    max_contacts INTEGER,
    max_storage_gb INTEGER,
    api_access BOOLEAN DEFAULT FALSE,
    priority_support BOOLEAN DEFAULT FALSE,
    advanced_analytics BOOLEAN DEFAULT FALSE,
    white_label BOOLEAN DEFAULT FALSE,
    price_monthly INTEGER,
    price_yearly INTEGER,
    notes TEXT,  -- Additional plan details and notes
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **subscriptions** - Active Tenant Subscriptions
```sql
CREATE TABLE subscriptions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    plan_id UUID REFERENCES plans(id),
    pending_plan_id UUID REFERENCES plans(id),
    status VARCHAR(50) CHECK (status IN ('active', 'past_due', 'canceled', 'unpaid')),
    current_period_start TIMESTAMP WITH TIME ZONE,
    current_period_end TIMESTAMP WITH TIME ZONE,
    cancel_at_period_end BOOLEAN DEFAULT FALSE,
    billing_contact_user_id UUID REFERENCES users(id),
    stripe_subscription_id VARCHAR(255),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **subscription_addons** - Additional Features
```sql
CREATE TABLE subscription_addons (
    id VARCHAR(255) PRIMARY KEY,
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    addon_type VARCHAR(50) NOT NULL,
    quantity INTEGER DEFAULT 1,
    price_monthly DECIMAL(10,2),
    stripe_price_id VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **payments** - Payment Records
```sql
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    subscription_id UUID REFERENCES subscriptions(id) ON DELETE CASCADE,
    initiated_by_user_id UUID REFERENCES users(id),
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    status VARCHAR(20) NOT NULL,
    processed TIMESTAMP WITH TIME ZONE,
    description TEXT,
    stripe_payment_intent_id VARCHAR(255),
    billing_period_start TIMESTAMP WITH TIME ZONE,
    billing_period_end TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 🛠️ **Infrastructure Management**

### **VPS & IP Management**

#### **vps_instances** - VPS Server Instances
```sql
CREATE TABLE vps_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hostwinds_instance_id VARCHAR(255) UNIQUE,
    ip_address VARCHAR(45),
    region VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('active', 'provisioning', 'scheduled_decommission', 'decommissioned')),
    monthly_cost DECIMAL(10,2),
    hostwinds_billing_day INTEGER,
    current_billing_period_start TIMESTAMP WITH TIME ZONE,
    current_billing_period_end TIMESTAMP WITH TIME ZONE,
    decommission_scheduled_for TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **smtp_ip_addresses** - SMTP IP Addresses
```sql
CREATE TABLE smtp_ip_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vps_instance_id UUID REFERENCES vps_instances(id) ON DELETE CASCADE,
    ip_address VARCHAR(45) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('available', 'assigned', 'warming', 'warmed', 'degraded', 'burned', 'quarantined')),
    reputation_state VARCHAR(50) CHECK (reputation_state IN ('good', 'fair', 'poor', 'critical')),
    last_reputation_check TIMESTAMP WITH TIME ZONE,
    assigned_count INTEGER DEFAULT 0,
    provider_blacklist_status JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

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

## 👥 **Staff & Permissions Management**

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

## ⚙️ **System Configuration**

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

## 📊 **Performance Indexes**

### **Critical OLTP Indexes**
```sql
-- Multi-tenant filtering
CREATE INDEX idx_inbox_message_refs_tenant ON inbox_message_refs(tenant_id);
CREATE INDEX idx_campaigns_tenant ON campaigns(tenant_id);
CREATE INDEX idx_leads_tenant ON leads(tenant_id);
CREATE INDEX idx_domains_tenant ON domains(tenant_id);
CREATE INDEX idx_email_accounts_tenant ON email_accounts(tenant_id);

-- Campaign orchestration
CREATE INDEX idx_campaign_sequence_steps_campaign_order ON campaign_sequence_steps(campaign_id, step_order);
CREATE INDEX idx_inbox_message_refs_campaign ON inbox_message_refs(campaign_id);

-- Email processing
CREATE INDEX idx_inbox_message_refs_status ON inbox_message_refs(status);
CREATE INDEX idx_inbox_message_refs_email_account ON inbox_message_refs(email_account_id);
CREATE INDEX idx_inbox_message_refs_created ON inbox_message_refs(created_at);

-- User and tenant management
CREATE INDEX idx_tenant_users_tenant ON tenant_users(tenant_id);
CREATE INDEX idx_tenant_users_user ON tenant_users(user_id);

-- Infrastructure
CREATE INDEX idx_smtp_ip_addresses_status ON smtp_ip_addresses(status);
CREATE INDEX idx_domain_ip_assignments_domain ON domain_ip_assignments(domain_id);
```

---

## 🔐 **Security & RLS Policies**

### **Row Level Security Implementation**
```sql
-- Enable RLS on all multi-tenant tables
ALTER TABLE inbox_message_refs ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaigns ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE domains ENABLE ROW LEVEL SECURITY;
ALTER TABLE email_accounts ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;

-- Tenant isolation policies
CREATE POLICY inbox_message_refs_tenant_isolation ON inbox_message_refs
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY campaigns_tenant_isolation ON campaigns
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY leads_tenant_isolation ON leads
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);
```

---

## 📈 **Related Documentation**

- **[Database Schema Guide](database_schema_guide.md)** - 4-tier architecture overview
- **[Content Database Schema Guide](content_database_schema_guide.md)** - Heavy content storage
- **[OLAP Analytics Schema Guide](olap_analytics_schema_guide.md)** - Business intelligence
- **[Queue System Schema Guide](queue_system_schema_guide.md)** - Job processing
- **[Analytics Architecture](analytics_architecture.md)** - Analytics system design
- **[Performance Dashboard](performance_dashboard.md)** - System performance metrics

**Keywords**: OLTP, operational database, transactional processing, multi-tenant, row level security, performance optimization, database schema, real-time operations