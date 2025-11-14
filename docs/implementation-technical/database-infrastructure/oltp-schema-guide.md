# OLTP Schema Guide - Operational Database

## Strategic Alignment
**Strategic Alignment**: This OLTP schema guide supports our enterprise infrastructure framework by providing comprehensive database schemas, multi-tenant design principles, and performance optimization strategies for the PenguinMails operational database.

**Technical Authority**: Our OLTP database architecture integrates with enterprise database systems, authentication platforms, and monitoring tools featuring NileDB-managed authentication, multi-tenant security, and optimized query performance for high-frequency operations.

**Operational Excellence**: Backed by enterprise database systems with 99.9% uptime guarantees, automated backup procedures, and comprehensive monitoring across all OLTP components with real-time performance tracking.

**User Journey Integration**: This database foundation is part of your complete user experience - connects to business logic operations, security frameworks, and operational excellence for reliable data management.

---

## Table Naming Standards

**OLTP Tier Naming Conventions:**
- **Core Entities**: No prefix, plural nouns (`users`, `companies`, `campaigns`)
- **Junction Tables**: Singular compound names (`tenant_users`, `campaign_sequence_steps`)
- **Configuration Tables**: Descriptive names (`user_preferences`, `tenant_config`)
- **System Tables**: Prefixed with table type (`system_config`, `feature_flags`)

**Table Name Examples:**
- `users` - User identity and profiles
- `tenants` - Tenant organizations
- `companies` - Tenant workspaces
- `domains` - Email sending domains
- `campaigns` - Campaign definitions
- `leads` - Contact database
- `templates` - Email templates
- `plans` - Subscription plans
- `subscriptions` - Active tenant subscriptions

---

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

#### **companies** - Tenant Workspaces (Marketing Access)
```sql
CREATE TABLE companies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    workspace_name VARCHAR(255) UNIQUE,
    logo_url TEXT,
    status VARCHAR(20) DEFAULT 'active',
    -- Marketing-accessible fields (no sensitive operational data)
    industry VARCHAR(100), -- Optional enrichment field
    company_size VARCHAR(50), -- Optional enrichment field (Small/Medium/Large)
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
    
    -- DNS Operational Metadata (Added for DNS Storage Integration)
    mailu_domain TEXT,                           -- Mailu's canonical hostname
    dns_ttl_observed INTEGER,                    -- Observed DNS TTL in seconds
    dns_last_verified_at TIMESTAMP WITH TIME ZONE, -- Last successful DNS verification
    dns_verification_error TEXT,                 -- Human-friendly error messages
    dns_verification_attempts INTEGER DEFAULT 0, -- Verification retry counter
    
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **DNS Records JSON Structure** (dns_records JSONB)
The `dns_records` JSONB field stores per-record DNS configuration with lifecycle management:

```json
{
  "records": [
    {
      "record_type": "SPF",
      "name": "@",
      "value": "v=spf1 include:_spf.mailu.io include:_spf.sendgrid.net -all",
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    },
    {
      "record_type": "DKIM",
      "name": "default._domainkey",
      "selector": "default",
      "value": "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSI....",
      "public_key": "MIGfMA0GCSqGSI....",
      "managed_by": "platform",              -- "platform" or "mailu"
      "secret_ref": "vault://mail/dkim/domain.com/default", -- Vault reference
      "needs_deployment": false,             -- Flag for Mailu sync jobs
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "platform"
    },
    {
      "record_type": "DMARC",
      "name": "_dmarc",
      "value": "v=DMARC1; p=quarantine; rua=mailto:dmarc@domain.com",
      "policy": "quarantine",
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    },
    {
      "record_type": "MX",
      "name": "@",
      "value": "mail.penguinmails.io.",
      "priority": 10,
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:40:00Z",
      "mx_hosts": ["203.0.113.5"],
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    }
  ]
}
```

**DNS Record Field Meanings**:
- `record_type`: DNS record type (SPF, DKIM, DMARC, MX, A, AAAA, CNAME)
- `name`: DNS record name (@ for root, subdomain for others)
- `value`: Expected DNS record value
- `verification_status`: Current verification state (pending, verified, failed, error)
- `last_verified_at`: Timestamp of last successful verification
- `verification_attempts`: Number of verification attempts
- `verification_error`: Error message from last failed verification
- `managed_by`: Who manages the record ("platform" or "mailu")
- `secret_ref`: Vault reference for DKIM private keys (platform-managed only)
- `needs_deployment`: Flag for Mailu sync jobs to deploy DKIM keys
- `source`: Source of record creation ("ui", "platform", "api")

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
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Template-to-folder mapping (UUID → BIGINT optimization)
CREATE TABLE template_folders (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    folder_id BIGINT REFERENCES folders(id) ON DELETE CASCADE,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, folder_id)
);

-- Template tagging system (UUID → BIGINT optimization)
CREATE TABLE tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    value TEXT NOT NULL,
    description TEXT,
    name TEXT,
    tenant_id UUID,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE,
    is_default BOOLEAN DEFAULT FALSE
);

CREATE TABLE template_tags (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    template_id UUID REFERENCES templates(id) ON DELETE CASCADE,
    tag_id BIGINT REFERENCES tags(id) ON DELETE CASCADE,
    tenant_id UUID NOT NULL,
    updated TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(template_id, tag_id)
);
```

---

### 📧 **Campaign Execution System (OLTP Metadata)**

#### **campaign_sequence_steps** - Campaign Execution Orchestration
*(Note: Email message analytics moved to Content Database as `email_messages` and `email_content`)*

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

## ⚙️ **System Configuration & Settings**

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

## 📊 **Performance Indexes**

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

## 🔐 **Security & RLS Policies**

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

---

## 📈 **External Analytics Integration**

### **Monitoring & Observability**

The following infrastructure and monitoring concerns have been externalized to specialized analytics platforms for better observability and product insights:

#### **Connection Pool Monitoring**
- **External Events**: `connection_pool_metrics`, `pool_utilization`, `connection_leaks`
- **Tracking**: Connection pool performance, utilization rates, leak detection
- **Platform**: External analytics platform (PostHog, Segment, or similar)
- **Benefits**: Better visualization of database performance trends, alerting capabilities

#### **Security Event Monitoring**
- **External Events**: `security_incidents`, `authentication_failures`, `suspicious_activity`
- **Tracking**: Security events, audit trails, incident patterns
- **Platform**: External analytics platform with security focus
- **Benefits**: Centralized security analytics, threat detection, compliance reporting

#### **Infrastructure Metrics**
- **External Events**: `system_performance`, `error_rates`, `resource_utilization`
- **Tracking**: Application performance, error rates, system health
- **Platform**: Infrastructure monitoring platform
- **Benefits**: Unified monitoring dashboard, proactive alerting

> 📋 **See [External Analytics Integration Plan](((external_analytics_integration_plan))** for detailed implementation strategies, event schemas, and platform migration guidelines.

---

## Business Impact & Technical Excellence

### 📈 **Revenue & Performance Intelligence**
- **Unified Billing Analytics**: `billing_analytics` table centralizes all tenant usage tracking with period-based aggregation
- **Enhanced Plan Flexibility**: Explicit limits in `plans` table support enterprise pricing models
- **Subscription Lifecycle**: `pending_plan_id` enables seamless plan upgrades/downgrades at billing cycle end
- **Separate Billing Contacts**: `billing_contact_user_id` allows different billing emails from tenant accounts

### 🚀 **Operational Excellence Achievements**
- **4-Tier Architecture**: Clear separation between OLTP operations, content storage, analytics, and job processing
- **Multi-Tenant Security**: Row-level security with NileDB-managed authentication using ARRAY-type roles
- **Infrastructure Intelligence**: `admin_system_events` provides comprehensive system monitoring and alerting
- **Queue-Driven Processing**: Reliable job processing with retry logic and dead letter queues

### 💡 **Technical Architecture Excellence**
- **Data Collection Strategy**: 
  - **OLTP Layer**: Fast transactional operations for real-time business logic (users, campaigns, leads)
  - **Content Layer**: Heavy email storage with retention policies and compression
  - **Analytics Layer**: Aggregated metrics with OLAP optimization for dashboards
  - **Queue Layer**: Asynchronous processing with Redis + PostgreSQL hybrid storage

---

## Success Metrics & Validation

### Performance Targets
- **OLTP Query Performance**: 60-80% improvement in campaign operations
- **Content DB Throughput**: Handle 100K+ message analytics operations/hour
- **Cross-Database Queries**: <500ms for campaign + message analytics
- **Queue Integration**: <1 second for email to email_messages creation

---

## Related Documents

### 📚 **Supporting Documentation**
- [Database Infrastructure README](((README)) - Database and infrastructure overview
- [Architecture System](((../architecture-system/README)) - System architecture decisions
- [Development Guidelines](((../development-guidelines/README)) - Development standards
- [Quality Assurance](((../quality-assurance/README)) - Testing protocols and procedures

### 🔧 **Business Integration**
- [Business Strategy Overview](((../../business/strategy/overview)) - Strategic business alignment
- [Operations Management](((../../operations-analytics/operations-management/README)) - Operational procedures
- [Security Framework](((../../compliance-security/enterprise/security-framework)) - Security architecture
- [Analytics Performance](((../../operations-analytics/analytics-performance/README)) - Performance monitoring

---

**Keywords**: OLTP, operational database, transactional processing, multi-tenant, row level security, performance optimization, database schema, real-time operations, unified security