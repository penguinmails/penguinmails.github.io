---
title: "Workspaces API"
description: "Detailed endpoint specifications for Workspace Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Workspaces API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/tenant/workspaces`

---

## Endpoints

### List Workspaces

**Method**: `GET`
**URL**: `/api/v1/tenant/workspaces`
**Purpose**: List all workspaces the current user has access to.

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "ws_123",
      "name": "Acme Corp",
      "slug": "acme-corp",
      "role": "owner",
      "stats": {
        "active_campaigns": 2,
        "total_leads": 1500
      }
    }
  ]
}


```

### Create Workspace

**Method**: `POST`
**URL**: `/api/v1/tenant/workspaces`
**Purpose**: Create a new workspace (Agency or Tenant).

**Request**:

```json
{
  "name": "New Client",
  "slug": "new-client" // Optional, auto-generated if missing
}


```

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "ws_456",
    "name": "New Client",
    "slug": "new-client"
  }
}


```

### Get Workspace Details

**Method**: `GET`
**URL**: `/api/v1/tenant/workspaces/{slug}`
**Purpose**: Get detailed information about a specific workspace.

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "ws_123",
    "name": "Acme Corp",
    "slug": "acme-corp",
    "settings": {
      "timezone": "UTC",
      "branding": {
        "logo_url": "..."
      }
    },
    "members": [
      {
        "user_id": "usr_789",
        "role": "admin"
      }
    ]
  }
}


```
