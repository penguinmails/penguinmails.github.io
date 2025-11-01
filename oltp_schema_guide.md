# OLTP Schema Guide - Operational Database

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

## ⚙️ **System Configuration & Connection Pooling**

### **Connection Pooling Strategy**
```sql
-- Connection pool configuration table
CREATE TABLE connection_pool_config (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tier VARCHAR(20) CHECK (tier IN ('oltp', 'content', 'queue', 'olap')),
    pool_name VARCHAR(50) NOT NULL,
    min_connections INTEGER DEFAULT 2,
    max_connections INTEGER DEFAULT 20,
    connection_timeout_seconds INTEGER DEFAULT 30,
    idle_timeout_seconds INTEGER DEFAULT 300,
    max_lifetime_seconds INTEGER DEFAULT 3600,
    acquire_timeout_seconds INTEGER DEFAULT 60,
    leak_detection_threshold_seconds INTEGER DEFAULT 0,
    validation_query TEXT DEFAULT 'SELECT 1',
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(tier, pool_name)
);

-- Connection pool metrics
CREATE TABLE connection_pool_metrics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    pool_config_id UUID REFERENCES connection_pool_config(id),
    collected_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active_connections INTEGER,
    idle_connections INTEGER,
    pending_acquires INTEGER,
    total_connections_created BIGINT,
    total_connections_destroyed BIGINT,
    connection_wait_time_avg_ms INTEGER,
    connection_usage_rate DECIMAL(5,2), -- Percentage of pool utilization
    connection_errors_count INTEGER DEFAULT 0,
    pool_exhaustion_events INTEGER DEFAULT 0
);

-- Pool sizing recommendations by tier
INSERT INTO connection_pool_config (tier, pool_name, min_connections, max_connections, connection_timeout_seconds, idle_timeout_seconds) VALUES
-- OLTP: High throughput, low latency
('oltp', 'primary_pool', 5, 50, 30, 600),
('oltp', 'read_replica_pool', 3, 30, 30, 600),
-- Content: Heavy content, longer queries
('content', 'content_pool', 3, 25, 60, 900),
('content', 'archival_pool', 1, 10, 120, 1800),
-- Queue: Fast operations, high concurrency
('queue', 'queue_pool', 5, 40, 15, 300),
('queue', 'worker_pool', 2, 20, 20, 300),
-- OLAP: Complex queries, variable load
('olap', 'analytics_pool', 3, 15, 120, 1800),
('olap', 'reporting_pool', 2, 25, 90, 1200);

-- Connection leak detection function
CREATE OR REPLACE FUNCTION detect_connection_leaks()
RETURNS void AS $$
DECLARE
    leak_threshold INTERVAL := INTERVAL '30 minutes';
    long_running_connections RECORD;
    pool_stats RECORD;
BEGIN
    -- Find connections that have been active too long
    FOR long_running_connections IN
        SELECT pid, usename, client_addr, query_start, state_change, query
        FROM pg_stat_activity
        WHERE state = 'active'
        AND query_start < NOW() - leak_threshold
        AND usename NOT IN ('postgres', 'pg_monitor')
        AND query NOT LIKE '%pg_stat_activity%'
    LOOP
        -- Log potential connection leak
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'connection_pool',
            'Potential Connection Leak Detected',
            format('Connection PID %s has been active for %s minutes',
                   long_running_connections.pid,
                   EXTRACT(EPOCH FROM (NOW() - long_running_connections.query_start))/60),
            'warning',
            jsonb_build_object(
                'pid', long_running_connections.pid,
                'user', long_running_connections.usename,
                'query_start', long_running_connections.query_start,
                'query', left(long_running_connections.query, 200),
                'detected_at', NOW()
            )
        );
    END LOOP;

    -- Check pool utilization
    FOR pool_stats IN
        SELECT
            cpc.tier,
            cpc.pool_name,
            cpm.active_connections,
            cpm.idle_connections,
            cpm.pending_acquires,
            ROUND(cpm.connection_usage_rate, 2) as usage_rate
        FROM connection_pool_config cpc
        JOIN connection_pool_metrics cpm ON cpc.id = cpm.pool_config_id
        WHERE cpm.collected_at >= NOW() - INTERVAL '5 minutes'
        ORDER BY cpm.collected_at DESC
    LOOP
        -- Alert on high utilization or pending acquires
        IF pool_stats.usage_rate > 90 OR pool_stats.pending_acquires > 5 THEN
            INSERT INTO system_notifications (
                category, title, message, severity, metadata
            ) VALUES (
                'connection_pool',
                'Connection Pool Under Pressure',
                format('%s pool %s utilization: %s%%, pending: %s',
                       pool_stats.tier, pool_stats.pool_name,
                       pool_stats.usage_rate, pool_stats.pending_acquires),
                CASE
                    WHEN pool_stats.pending_acquires > 10 THEN 'critical'
                    WHEN pool_stats.usage_rate > 95 THEN 'high'
                    ELSE 'warning'
                END,
                jsonb_build_object(
                    'tier', pool_stats.tier,
                    'pool_name', pool_stats.pool_name,
                    'usage_rate', pool_stats.usage_rate,
                    'pending_acquires', pool_stats.pending_acquires,
                    'alert_time', NOW()
                )
            );
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Pool optimization function
CREATE OR REPLACE FUNCTION optimize_connection_pools()
RETURNS void AS $$
DECLARE
    workload_stats RECORD;
    recommendation TEXT;
BEGIN
    -- Analyze recent workload patterns
    SELECT
        AVG(active_connections) as avg_active,
        MAX(active_connections) as peak_active,
        AVG(connection_wait_time_avg_ms) as avg_wait_time,
        SUM(connection_errors_count) as total_errors,
        AVG(connection_usage_rate) as avg_usage
    INTO workload_stats
    FROM connection_pool_metrics
    WHERE collected_at >= NOW() - INTERVAL '24 hours';

    -- Generate pool sizing recommendations
    IF workload_stats.avg_usage > 80 THEN
        recommendation := 'Consider increasing max_connections for higher utilization';
    ELSIF workload_stats.avg_usage < 30 THEN
        recommendation := 'Consider decreasing max_connections to reduce resource usage';
    ELSIF workload_stats.avg_wait_time > 100 THEN
        recommendation := 'Consider increasing max_connections to reduce wait times';
    ELSIF workload_stats.total_errors > 10 THEN
        recommendation := 'Investigate connection errors - may indicate network or authentication issues';
    ELSE
        recommendation := 'Connection pools are well-balanced';
    END IF;

    -- Log optimization recommendation
    INSERT INTO system_notifications (
        category, title, message, severity, metadata
    ) VALUES (
        'connection_pool',
        'Pool Optimization Analysis',
        format('24h analysis: avg usage %s%%, peak %s connections, avg wait %sms. %s',
               ROUND(workload_stats.avg_usage, 1),
               workload_stats.peak_active,
               ROUND(workload_stats.avg_wait_time, 0),
               recommendation),
        'info',
        jsonb_build_object(
            'analysis_period_hours', 24,
            'avg_usage_percent', workload_stats.avg_usage,
            'peak_connections', workload_stats.peak_active,
            'avg_wait_ms', workload_stats.avg_wait_time,
            'total_errors', workload_stats.total_errors,
            'recommendation', recommendation,
            'analyzed_at', NOW()
        )
    );
END;
$$ LANGUAGE plpgsql;
```

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

### **Security Event Logging**
```sql
-- Security event logging for audit trails
CREATE TABLE security_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    user_id UUID REFERENCES users(id),
    tenant_id UUID REFERENCES tenants(id),
    ip_address INET,
    user_agent TEXT,
    resource_type VARCHAR(50),
    resource_id VARCHAR(255),
    action_attempted VARCHAR(100),
    success BOOLEAN DEFAULT FALSE,
    failure_reason TEXT,
    metadata JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Security monitoring indexes
CREATE INDEX idx_security_events_tenant_created ON security_events(tenant_id, created DESC);
CREATE INDEX idx_security_events_type_severity ON security_events(event_type, severity, created DESC);
CREATE INDEX idx_security_events_ip ON security_events(ip_address, created DESC);
```

### **Security Monitoring and Alerting**
```sql
-- Security incident alerting function
CREATE OR REPLACE FUNCTION alert_security_incident(
    p_event_type VARCHAR(50),
    p_severity VARCHAR(20),
    p_description TEXT,
    p_tenant_id UUID DEFAULT NULL,
    p_user_id UUID DEFAULT NULL,
    p_ip_address INET DEFAULT NULL
)
RETURNS void AS $$
DECLARE
    incident_count INTEGER;
BEGIN
    -- Count recent similar incidents (last hour)
    SELECT COUNT(*) INTO incident_count
    FROM security_events
    WHERE event_type = p_event_type
    AND tenant_id IS NOT DISTINCT FROM p_tenant_id
    AND created > NOW() - INTERVAL '1 hour';

    -- Log the security event
    INSERT INTO security_events (
        event_type, severity, user_id, tenant_id, ip_address,
        action_attempted, success, failure_reason, metadata
    ) VALUES (
        p_event_type, p_severity, p_user_id, p_tenant_id, p_ip_address,
        'security_incident', false, p_description,
        jsonb_build_object(
            'incident_count_last_hour', incident_count,
            'alert_timestamp', NOW()
        )
    );

    -- Alert on high-severity or frequent incidents
    IF p_severity IN ('high', 'critical') OR incident_count > 5 THEN
        -- This would integrate with notification system
        -- For now, just log escalated alert
        INSERT INTO system_notifications (
            category, title, message, severity, tenant_id, metadata
        ) VALUES (
            'security_incident',
            CASE
                WHEN p_severity = 'critical' THEN 'Critical Security Alert'
                WHEN incident_count > 10 THEN 'Frequent Security Incidents'
                ELSE 'Security Alert'
            END,
            format('Security incident detected: %s. Severity: %s, Count (last hour): %s',
                   p_description, p_severity, incident_count + 1),
            p_severity,
            p_tenant_id,
            jsonb_build_object(
                'event_type', p_event_type,
                'incident_count', incident_count + 1,
                'alert_level', CASE
                    WHEN p_severity = 'critical' THEN 'escalated'
                    WHEN incident_count > 10 THEN 'frequent'
                    ELSE 'standard'
                END
            )
        );
    END IF;
END;
$$ LANGUAGE plpgsql;
```

---

## 📈 **Related Documentation**

### **Documentation Synchronization Status**
| Document | Last Updated | Sync Status | Notes |
|----------|-------------|-------------|--------|
| OLTP Schema Guide | Current | ✅ Synchronized | Core business logic tables, unified security, connection pooling |
| Content Database Guide | Current | ✅ Synchronized | Enhanced lifecycle management, automated retention policies |
| Queue System Guide | Current | ✅ Synchronized | Unified security policies, enhanced priority system |
| OLAP Analytics Guide | Current | ✅ Synchronized | Cross-tier security, analytics access controls |
| Database Schema Guide | Needs Update | 🔄 Pending | 4-tier architecture overview |
| Implementation Checklist | Needs Update | 🔄 Pending | Schema optimization tracking |
| Performance Dashboard | Needs Update | 🔄 Pending | Monitoring integration |

### **Cross-Document References**
- **Table Naming Standards**: Now documented in each schema guide header
- **Security Policies**: Unified across all tiers with consistent RLS implementation
- **Connection Pooling**: Tier-specific strategies documented in each guide
- **Performance Indexes**: Standardized approaches across all database tiers

### **Migration Documentation**
```sql
-- Documentation synchronization tracking
CREATE TABLE schema_documentation_status (
    document_name VARCHAR(100) PRIMARY KEY,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    version VARCHAR(20),
    sync_status VARCHAR(20) CHECK (sync_status IN ('synchronized', 'needs_update', 'outdated')),
    changes_summary TEXT,
    next_review_date DATE,
    responsible_team VARCHAR(50),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert current documentation status
INSERT INTO schema_documentation_status (
    document_name, version, sync_status, changes_summary, next_review_date, responsible_team
) VALUES
('OLTP Schema Guide', '2.1', 'synchronized',
 'Added unified security policies, IP-based restrictions, connection pooling strategy, table naming standards', '2026-02-01', 'Platform Team'),
('Content Database Schema Guide', '2.1', 'synchronized',
 'Enhanced lifecycle management, automated retention policies, cross-tier security integration, storage optimization', '2026-02-01', 'Content Team'),
('Queue System Schema Guide', '2.1', 'synchronized',
 'Unified security policies, enhanced priority system, connection pooling optimization, queue access controls', '2026-02-01', 'Queue Team'),
('OLAP Analytics Schema Guide', '2.1', 'synchronized',
 'Cross-tier security policies, analytics access controls, connection pooling strategy, export security', '2026-02-01', 'Analytics Team');
```

**Keywords**: OLTP, operational database, transactional processing, multi-tenant, row level security, performance optimization, database schema, real-time operations, unified security, connection pooling