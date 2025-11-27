---
title: "Templates API"
description: "Detailed endpoint specifications for Template Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Templates API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/tenant/templates`

---


## Endpoints


### List Templates

**Method**: `GET`  
**URL**: `/api/v1/tenant/templates`  
**Purpose**: List all templates for a specific workspace.

**Query Parameters**:


- `workspace` (string, required): Workspace slug


- `limit` (integer, optional): Default 20


- `offset` (integer, optional): Default 0

**Response**:


```json
{
  "success": true,
  "data": [
    {
      "id": "tpl_123",
      "name": "Welcome Email",
      "subject": "Welcome to {{company}}",
      "created_at": "2025-11-01T10:00:00Z",
      "updated_at": "2025-11-05T14:30:00Z"
    }
  ],
  "pagination": {
    "total": 5,
    "limit": 20,
    "offset": 0,
    "has_more": false
  }
}


```


### Create Template

**Method**: `POST`  
**URL**: `/api/v1/tenant/templates`  
**Purpose**: Create a new email template.

**Request**:


```json
{
  "workspace_slug": "acme-corp",
  "name": "Follow-up Sequence",
  "subject": "Just checking in...",
  "body": "<p>Hi {{firstName}},</p>..."
}


```

**Response**:


```json
{
  "success": true,
  "data": {
    "id": "tpl_456",
    "name": "Follow-up Sequence",
    "created_at": "2025-11-21T12:00:00Z"
  }
}


```


### Get Template Details

**Method**: `GET`  
**URL**: `/api/v1/tenant/templates/{id}`  
**Purpose**: Retrieve full content of a template.

**Response**:


```json
{
  "success": true,
  "data": {
    "id": "tpl_123",
    "name": "Welcome Email",
    "subject": "Welcome to {{company}}",
    "body": "...",
    "variables": ["firstName", "company"]
  }
}


```


### Update Template

**Method**: `PATCH`  
**URL**: `/api/v1/tenant/templates/{id}`  
**Purpose**: Update template content.

**Request**:


```json
{
  "name": "New Welcome Email",
  "subject": "Welcome aboard!"
}


```


### Delete Template

**Method**: `DELETE`  
**URL**: `/api/v1/tenant/templates/{id}`  
**Purpose**: Remove a template.
