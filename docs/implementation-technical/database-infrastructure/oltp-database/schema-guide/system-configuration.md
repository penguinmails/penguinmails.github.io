---
title: "OLTP Schema - System Configuration"
description: "System-wide config, feature flags, user preferences, and tenant security policies."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - System Configuration

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
