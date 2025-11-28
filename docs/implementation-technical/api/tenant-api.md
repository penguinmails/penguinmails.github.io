---
title: "Tenant API - Overview"
description: "Hub for Tenant-facing API endpoints: Campaigns, Workspaces, Templates, and Inbox"
last_modified_date: "2025-11-21"
level: "2"
persona: "Backend Developers, Frontend Developers"
---


# Tenant API

**Server**: Central Monolithic Server  
**URL Prefix**: `/api/v1/tenant/*`  
**Purpose**: Core application operations for customers (Tenants) and Agencies.

---

## Overview

The Tenant API handles all user-facing functionality within the dashboard. It is the primary API consumed by the Next.js frontend via Server Actions.

---

## Endpoint Categories

### 1. Workspace Management

**Documentation**: [Workspaces API](/docs/implementation-technical/api/tenant-api/workspaces)

Manage workspaces, client assignments, and workspace-specific settings.

**Key Endpoints**:

- `GET /api/v1/tenant/workspaces` - List accessible workspaces

- `POST /api/v1/tenant/workspaces` - Create a new workspace

- `GET /api/v1/tenant/workspaces/{slug}` - Get workspace details

### 2. Campaign Management

**Documentation**: [Campaigns API](/docs/implementation-technical/api/tenant-api/campaigns)

Create, configure, and manage email campaigns.

**Key Endpoints**:

- `GET /api/v1/tenant/campaigns` - List campaigns

- `POST /api/v1/tenant/campaigns` - Create campaign

- `PATCH /api/v1/tenant/campaigns/{id}` - Update campaign

- `POST /api/v1/tenant/campaigns/{id}/send` - Launch campaign

### 3. Template Management

**Documentation**: [Templates API](/docs/implementation-technical/api/tenant-api/templates)

Manage reusable email templates and assets.

### 4. Lead Management

**Documentation**: [Leads API](/docs/implementation-technical/api/tenant-api/leads)

Manage contacts, segments, and lists.

### 5. Unified Inbox

**Documentation**: [Inbox API](/docs/implementation-technical/api/tenant-api/inbox)

Manage threads, replies, and inbox organization.

---

## Authentication

All endpoints require a valid session authenticated via **NileDB**.

**Headers**:

- `Authorization`: Bearer token (handled by Server Actions)

- `x-tenant-id`: The active tenant context

- `x-workspace-id`: (Optional) The active workspace context

---

## Common Patterns

### Pagination

Endpoints returning lists use cursor-based or offset-based pagination:

```json
{
  "data": [...],
  "pagination": {
    "total": 100,
    "limit": 20,
    "offset": 0,
    "has_more": true
  }
}


```

### Error Handling

Standard error format:

```json
{
  "success": false,
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "Campaign not found",
    "details": {}
  }
}


```
