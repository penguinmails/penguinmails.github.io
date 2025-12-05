---
title: "Multi-Tenant Architecture"
description: "Multi-tenant platform architecture and tenant isolation in PenguinMails"
last_modified_date: "2025-11-24"
level: "2"
persona: "Developers, System Architects"
status: "ACTIVE"
category: "Infrastructure"
---

# Multi-Tenant Architecture

**Enterprise-grade multi-tenancy with complete data isolation and workspace management.**

---

## Overview

PenguinMails is built on a **multi-tenant architecture** powered by NileDB, providing complete tenant isolation, scalable workspace management, and secure data partitioning - all built into the platform from day one.

### What is Multi-Tenancy?

**Multi-tenancy** means multiple customers (tenants) share the same application infrastructure while maintaining complete data isolation and security.

**Benefits:**

- 🏢 **Complete Isolation** - Tenant data is fully separated

- 🚀 **Scalability** - Add unlimited tenants without infrastructure changes

- 💰 **Cost Efficiency** - Shared infrastructure reduces costs

- 🔒 **Security** - Database-level tenant isolation

- ⚡ **Performance** - Per-tenant query optimization

---

## Level 1: Core Concepts

### Tenant Hierarchy

```text
Platform (PenguinMails)
  ├── Tenant (Company/Organization)
  │   ├── Users (Team Members)
  │   ├── Workspaces (Projects/Clients)
  │   ├── Subscription (Billing)
  │   └── Settings (Company-wide)
  │       ├── Workspace 1
  │       │   ├── Campaigns
  │       │   ├── Domains
  │       │   ├── Templates
  │       │   └── Contacts
  │       └── Workspace 2
  │           └── ...

```

### Tenant

Tenant = Company/Organization.

- Highest level of data isolation

- Maps to one paying customer

- Has one subscription

- Can have multiple users and workspaces

- Complete separation from other tenants

Example tenants:

- Acme Marketing Agency (Tenant ID: `tenant_abc123`)
- Startup Inc (Tenant ID: `tenant_xyz789`)

### Users

Users = Team Members within a Tenant.

- Belong to exactly one tenant

- Have roles (Owner, Admin, Member)

- Can access multiple workspaces within their tenant

- Cannot see data from other tenants

User roles:

- **Tenant Owner** - Full control, billing access

- **Admin** - Manage users, workspaces, settings

- **Member** - Access assigned workspaces only

### Workspaces

Workspaces = Projects, Clients, or Teams.

- Organize work within a tenant

- Optional sub-isolation for campaigns, contacts, domains

- Multiple users can collaborate in one workspace

- Example: "Client A Campaign", "Product Launch 2025"

---

## Level 2: Tenant Isolation

### Database-Level Isolation

NileDB provides native multi-tenancy:

```sql
-- Every table has tenant_id
CREATE TABLE campaigns (
  id UUID PRIMARY KEY,
  tenant_id UUID REFERENCES tenants(id), -- Automatic isolation
  workspace_id UUID REFERENCES workspaces(id),
  name VARCHAR(255),
  created_at TIMESTAMP
);

-- NileDB automatically filters by tenant
SELECT * FROM campaigns WHERE name = 'Welcome Series';
-- Becomes: SELECT * FROM campaigns WHERE tenant_id = {current_tenant} AND name = 'Welcome Series';

```

Automatic tenant context:

- All queries automatically scoped to current tenant

- Impossible to accidentally query another tenant's data

- Row-level security enforced at database level

- No application-level filtering needed

### Authentication & Tenant Context

How tenant context is established:

1. **User logs in** with email/password

2. **NileDB authenticates** and identifies tenant

3. **Session includes tenant_id** in JWT token

4. **All API requests** automatically scoped to that tenant

5. **Database queries** filtered by tenant_id

**Session Token:**

```javascript
{
  "user_id": "user_abc123",
  "tenant_id": "tenant_xyz789", // Current tenant
  "email": "user@acme.com",
  "role": "admin",
  "workspaces": ["ws_1", "ws_2"]
}

```

---

### Data Isolation Guarantees

**What's Isolated:**

- ✅ **Campaigns** - Tenant A cannot see Tenant B's campaigns

- ✅ **Contacts** - Complete contact list separation

- ✅ **Templates** - Email templates not shared

- ✅ **Analytics** - Performance data isolated

- ✅ **Workspaces** - Workspace data tenant-scoped

- ✅ **Domains** - Domain configurations isolated

- ✅ **Users** - User accounts tenant-specific

**What's Shared (Platform-Level):**

- ⚙️ **Application Code** - Same codebase for all tenants

- ⚙️ **Infrastructure** - Shared servers (with isolation)

- ⚙️ **Global Suppression** - Platform-wide spam/abuse blocks

---

## Level 3: Technical Implementation

### Tenant Provisioning

**Creating a new tenant:**

```javascript
// POST /api/v1/tenants
{
  "company_name": "Acme Marketing",
  "owner_email": "owner@acme.com",
  "owner_name": "John Doe",
  "plan": "professional"
}

// Backend Process:
// 1. Create tenant record in NileDB
// 2. Create owner user account
// 3. Initialize default workspace
// 4. Set up Stripe customer
// 5. Send welcome email
// 6. Return tenant_id and access token

Response:
{
  "tenant_id": "tenant_abc123",
  "owner_user_id": "user_xyz789",
  "default_workspace_id": "ws_default",
  "access_token": "eyJhbGc...",
  "onboarding_url": "/onboarding"
}

```

### Tenant Database Schema

```sql
-- Tenants Table (managed by NileDB)
CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  settings JSONB DEFAULT '{}'
);

-- Users Table (tenant-scoped)
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id),
  email VARCHAR(255) NOT NULL,
  name VARCHAR(255),
  role VARCHAR(50), -- owner, admin, member
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  UNIQUE(tenant_id, email) -- Email unique per tenant
);

-- Workspaces Table (tenant-scoped)
CREATE TABLE workspaces (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  slug VARCHAR(255) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

  UNIQUE(tenant_id, slug)
);

-- Workspace Members (access control)
CREATE TABLE workspace_members (
  workspace_id UUID REFERENCES workspaces(id),
  user_id UUID REFERENCES users(id),
  role VARCHAR(50), -- admin, member, viewer

  PRIMARY KEY(workspace_id, user_id)
);

```

### Tenant-Scoped Queries

**Application code example:**

```javascript
// Get campaigns for current tenant
async function getCampaigns(tenantId) {
  // NileDB automatically adds tenant_id filter
  const campaigns = await db.campaigns.findMany({
    where: {
      // tenant_id automatically added by NileDB
      status: 'active'
    }
  });
  return campaigns;
}

// Create campaign (tenant context from session)
async function createCampaign(req, campaignData) {
  const tenantId = req.user.tenant_id; // From JWT

  const campaign = await db.campaigns.create({
    data: {
      tenant_id: tenantId, // Explicit tenant assignment
      workspace_id: campaignData.workspace_id,
      name: campaignData.name,
      // ...
    }
  });

  return campaign;
}

```

---

## Workspace Management

### Creating Workspaces

**Workspaces organize work within a tenant:**

```javascript
// POST /api/v1/workspaces
{
  "name": "Client A - Holiday Campaign",
  "slug": "client-a-holiday",
  "description": "Q4 2025 marketing push"
}

Response:
{
  "workspace_id": "ws_abc123",
  "name": "Client A - Holiday Campaign",
  "slug": "client-a-holiday",
  "members": [
    {
      "user_id": "user_xyz",
      "role": "admin" // Creator is auto-admin
    }
  ]
}

```

### Workspace Access Control

**Assign users to workspaces:**

```javascript
// POST /api/v1/workspaces/{workspace_id}/members
{
  "user_id": "user_def456",
  "role": "member" // admin, member, viewer
}

// User now has access to workspace
// Can view/edit campaigns, contacts, templates in that workspace

```

**Workspace Roles:**

- **Admin** - Full control over workspace

- **Member** - Create/edit campaigns, manage contacts

- **Viewer** - Read-only access

---

## Multi-Tenant Security

### Security Features

1. **Row-Level Security (RLS)**

   - Database enforces tenant isolation

   - Impossible to bypass tenant filters

   - Automatic on all queries

2. **API Middleware**

   - Validates tenant_id from JWT

   - Ensures user belongs to tenant

   - Rejects cross-tenant requests

3. **Tenant Switching Prevention**

   - Users cannot switch tenants

   - Must log out and log in to different account

   - No shared user accounts across tenants

4. **Audit Logging**

   - All tenant actions logged

   - Cross-tenant access attempts flagged

   - Compliance and security monitoring

### Security Validation

**Request flow:**

```text
User Request
  ↓
Extract JWT token
  ↓
Verify signature
  ↓
Extract tenant_id from token
  ↓
Validate user belongs to tenant
  ↓
Set tenant context for database
  ↓
Execute query (auto-filtered)
  ↓
Return results (tenant-scoped only)

```

---

## Tenant Settings

### Per-Tenant Configuration

**Customizable settings:**

```javascript
{
  "tenant_id": "tenant_abc123",
  "settings": {
    "company_name": "Acme Marketing",
    "company_address": "123 Main St, SF, CA",
    "timezone": "America/Los_Angeles",
    "date_format": "MM/DD/YYYY",
    "email_sender_name": "Acme Team",
    "default_reply_to": "hello@acme.com",
    "branding": {
      "logo_url": "https://...",
      "primary_color": "#007bff",
      "custom_domain": "mail.acme.com"
    },
    "limits": {
      "max_workspaces": 10,
      "max_users": 5,
      "email_sends_per_month": 50000
    }
  }
}

```

### Tenant-Specific Features

**Feature flags per tenant:**

- **Beta Features** - Early access for specific tenants

- **Custom Branding** - Enterprise tenant white-labeling

- **API Rate Limits** - Per-tenant throttling

- **Data Retention** - Custom retention policies

---

## Scalability

### Horizontal Scaling

**Multi-tenancy enables:**

- Add unlimited tenants without code changes

- Database sharding (future) - partition tenants across DBs

- Per-tenant performance optimization

- Isolated tenant upgrades/migrations

**Current Architecture:**

- All tenants share one NileDB instance

- Automatic query optimization per tenant

- Connection pooling shared across tenants

**Future Scaling (if needed):**

- Shard large tenants to dedicated databases

- Geo-distributed tenants (US/EU data centers)

- Tenant-specific resource allocation

---

## Related Documentation

### Architecture

- **[Free Mailbox Creation](/docs/features/infrastructure/free-mailbox-creation/overview)** - Infrastructure provisioning

- **[Infrastructure Overview](https://github.com/penguinmails/penguinmails.github.io/blob/main/README.md)** - All infrastructure features

### Implementation

- **[NileDB Documentation](/docs/implementation-technical/database-infrastructure/niledb)** - Database multi-tenancy details

- **[Authentication](/docs/implementation-technical/security/authentication)** - Tenant-aware auth

- **[API Architecture](/docs/implementation-technical/api/README)** - Multi-tenant API design

### Management

- **[User Management](/docs/features/authentication/user-management)** - Team member management

- **[Workspace Management](/docs/business/workspace-management)** - Workspace organization

### Tasks

- **Epic 3: Tenant Management** - Internal task reference for implementation tasks

---

## Best Practices

### For Tenants (Customers)

1. **Use Workspaces** - Organize by client, project, or team

2. **Assign Roles Carefully** - Give minimum necessary permissions

3. **Regular Audits** - Review workspace access quarterly

4. **Naming Conventions** - Use consistent workspace naming

### For Developers

1. **Always Use Tenant Context** - Never query without tenant_id

2. **Validate Tenant Access** - Check tenant membership on every request

3. **Test Isolation** - Verify tenant data separation in tests

4. **Audit Logs** - Log all tenant-scoped operations

5. **Never Hard-Code tenant_id** - Always from session/token

---

**Last Updated:** November 24, 2025
**Technology:** NileDB Multi-Tenant PostgreSQL
**Isolation Level:** Database Row-Level Security (RLS)

*Multi-tenancy is the foundation of PenguinMails' security and scalability. Complete tenant isolation ensures enterprise-grade data protection.*
