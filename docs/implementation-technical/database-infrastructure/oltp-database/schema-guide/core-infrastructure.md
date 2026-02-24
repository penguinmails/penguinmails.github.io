---
title: "OLTP Schema - Core Infrastructure"
description: "Core multi-tenant infrastructure tables including users, tenants, and companies."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Core Infrastructure

## Core Multi-Tenant Infrastructure

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
    suspended BOOLEAN DEFAULT FALSE, -- Temporary account suspension (distinct from deletion)
    roles TEXT[] DEFAULT '{}' "NileDB-managed ARRAY - mandatory for authentication",
    email TEXT,
    PRIMARY KEY (tenant_id, user_id)
);
```

---

## Business Logic Tables

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
    company_size VARCHAR(50), -- Optional enrichment field (Small/Medium)
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
