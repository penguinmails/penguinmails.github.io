---
title: "Authentication & Access Control"
description: "Strategic alignment, authentication flows via NileDB, and comprehensive RBAC/RLS implementations."
last_modified_date: "2025-10-27"
level: "2"
persona: "Documentation Users"
---

# Authentication & Access Control

## Overview

This framework outlines the identity management and access control protocols for the PenguinMails platform, ensuring that only authorized users can access specific tenant resources.

## Strategic Alignment

- **Regulatory Compliance**: Supports enterprise compliance by providing granular access controls.
- **Risk Mitigation**: Establishes comprehensive security architecture through advanced identity protection.
- **Operational Excellence**: Ensures secure service delivery across all operational domains.

## Authentication Framework

### NileDB Authentication Integration

NileDB handles core authentication (users table) and session management.

#### Authentication Flow

1. **Client** sends login request.
2. **App** authenticates via NileDB.
3. **NileDB** returns auth token and user data.
4. **App** stores session in Redis.
5. **App** grants dashboard access to Client.

#### Security Features

- **Managed Auth**: Core user management handled by NileDB.
- **Email Verification**: Implemented using Loop service.
- **Planned**: Password reset and MFA (under feature flag).

### Role-Based Access Control (RBAC)

Our 7-tier permission system provides granular access control.

| Role | User Management | Billing | Email Config | Data Export |
|------|----------------|---------|--------------|-------------|
| **Super Admin** | Full | Full | Full | Full |
| **Admin** | Tenant Users | Plans | Full | Full |
| **Owner** | Team Members | History | Email Setup | Download |
| **Manager** | View Users | Stats | Templates | Reports |
| **Employee** | Own Profile | None | Send Emails | Own Data |
| **QA** | None | None | Test Config | Test Data |
| **Blocked** | None | None | None | None |

## Data Isolation & RLS

### Row Level Security (RLS)

We use PostgreSQL Row Level Security to enforce tenant isolation at the database level.

- **NileDB Enforcement**: Ensures users can only see data belonging to their `tenant_id`.
- **Staff Bypass**: Emergency access protocols for Super Admins/Admins via logged internal tickets.

```sql
-- Row Level Security Example
ALTER TABLE tenant_data ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON tenant_data
  USING (tenant_id = current_setting('app.current_tenant_id')::bigint);
```
