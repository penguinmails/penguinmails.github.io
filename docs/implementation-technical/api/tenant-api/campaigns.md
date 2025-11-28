---
title: "Campaigns API"
description: "Detailed endpoint specifications for Campaign Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Campaigns API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/tenant/campaigns`

---

## Endpoints

### List Campaigns

**Method**: `GET`  
**URL**: `/api/v1/tenant/campaigns`  
**Purpose**: Retrieve a paginated list of campaigns for a specific workspace.

**Query Parameters**:

- `workspace` (string, required): Workspace slug

- `status` (string, optional): Filter by status (draft, active, paused, completed)

- `limit` (integer, optional): Default 20

- `offset` (integer, optional): Default 0

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "cmp_123",
      "name": "Q4 Outreach",
      "status": "active",
      "stats": {
        "sent": 150,
        "opened": 45,
        "replied": 12
      },
      "created_at": "2025-11-01T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 1,
    "limit": 20,
    "offset": 0,
    "has_more": false
  }
}


```

### Create Campaign

**Method**: `POST`  
**URL**: `/api/v1/tenant/campaigns`  
**Purpose**: Create a new campaign draft.

**Request**:

```json
{
  "workspace_slug": "acme-corp",
  "name": "New Campaign",
  "goal": "lead_gen" // awareness, lead_gen, sales
}


```

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "cmp_456",
    "name": "New Campaign",
    "status": "draft"
  }
}


```

### Get Campaign Details

**Method**: `GET`  
**URL**: `/api/v1/tenant/campaigns/{id}`  
**Purpose**: Get full details of a campaign, including sequence and settings.

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "cmp_123",
    "name": "Q4 Outreach",
    "status": "active",
    "sequence": [
      {
        "step": 1,
        "type": "email",
        "subject": "Hello {{firstName}}",
        "body": "..."
      }
    ],
    "settings": {
      "daily_limit": 50,
      "track_opens": true
    }
  }
}


```

### Update Campaign

**Method**: `PATCH`  
**URL**: `/api/v1/tenant/campaigns/{id}`  
**Purpose**: Update campaign details. Only allowed if campaign is not 'completed'.

**Request**:

```json
{
  "name": "Updated Name",
  "settings": {
    "daily_limit": 100
  }
}


```

### Launch Campaign

**Method**: `POST`  
**URL**: `/api/v1/tenant/campaigns/{id}/send`  
**Purpose**: Trigger the campaign to start or resume sending.

**Request**:

```json
{
  "action": "start" // or "resume", "pause"
}


```
