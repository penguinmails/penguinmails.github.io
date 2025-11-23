---
title: "Leads API"
description: "Detailed endpoint specifications for Lead Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---

# Leads API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/tenant/leads`

---

## Endpoints

### List Leads

**Method**: `GET`  
**URL**: `/api/v1/tenant/leads`  
**Purpose**: List leads with filtering and pagination.

**Query Parameters**:

- `workspace` (string, required): Workspace slug
- `status` (string, optional): Filter by status (new, contacted, replied, converted)
- `search` (string, optional): Search by email or name
- `limit` (integer, optional): Default 50
- `offset` (integer, optional): Default 0

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "lead_123",
      "email": "john@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "company": "Example Inc",
      "status": "new",
      "created_at": "2025-11-01T10:00:00Z"
    }
  ],
  "pagination": {
    "total": 150,
    "limit": 50,
    "offset": 0,
    "has_more": true
  }
}
```

### Create Lead

**Method**: `POST`  
**URL**: `/api/v1/tenant/leads`  
**Purpose**: Manually add a new lead.

**Request**:

```json
{
  "workspace_slug": "acme-corp",
  "email": "jane@example.com",
  "first_name": "Jane",
  "last_name": "Smith",
  "company": "Tech Corp"
}
```

### Get Lead Details

**Method**: `GET`  
**URL**: `/api/v1/tenant/leads/{id}`  
**Purpose**: Get full lead profile and activity history.

**Response**:

```json
{
  "success": true,
  "data": {
    "id": "lead_123",
    "email": "john@example.com",
    "attributes": {
      "title": "CEO",
      "location": "New York"
    },
    "activity": [
      {
        "type": "email_sent",
        "campaign_id": "cmp_123",
        "timestamp": "2025-11-02T10:00:00Z"
      }
    ]
  }
}
```

### Update Lead

**Method**: `PATCH`  
**URL**: `/api/v1/tenant/leads/{id}`  
**Purpose**: Update lead information or status.

**Request**:

```json
{
  "status": "contacted",
  "attributes": {
    "phone": "+15551234567"
  }
}
```
