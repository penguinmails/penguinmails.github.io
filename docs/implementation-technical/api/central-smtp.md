---
title: "Central SMTP API - Overview"
description: "Hub for Central SMTP Operations: IP Management, Routing, and Infrastructure"
last_modified_date: "2025-11-21"
level: "2"
persona: "Backend Developers"
---


# Central SMTP API

**Server**: Central Monolithic Server  
**URL Prefix**: `/api/v1/smtp/admin/*`  
**Purpose**: Internal operations for managing shared SMTP infrastructure.

---


## Overview

The Central SMTP API manages the underlying infrastructure for email delivery, including IP pools, routing logic, and reputation monitoring. It is **internal-only**.

---


## Endpoint Categories


### 1. IP & Pool Management

**Documentation**: [IP & Pools API](/docs/implementation-technical/api/central-smtp/ip-pools)

Manage IP inventory, pools, and capacity.

**Key Endpoints**:


- `GET /api/v1/smtp/admin/ips` - List IPs


- `GET /api/v1/smtp/admin/pools` - List Pools


### 2. Routing & Assignment

**Documentation**: [Routing API](/docs/implementation-technical/api/central-smtp/routing)

Assign tenants to specific pools or IPs.

**Key Endpoints**:


- `GET /api/v1/smtp/admin/assignments` - View assignments


- `PUT /api/v1/smtp/admin/assignments/{id}` - Update assignment


### 3. Reputation & Health

**Documentation**: [Reputation API](/docs/implementation-technical/api/central-smtp/reputation)

Monitor infrastructure health signals.

**Key Endpoints**:


- `GET /api/v1/smtp/admin/ips/health-summary`

---


## Authentication

**Required Roles**:


- `ROLE_SMTP_ADMIN`


- `ROLE_DELIVERABILITY_ENGINEER`

**Audit**:
All write operations are logged to `admin_audit_log`.
