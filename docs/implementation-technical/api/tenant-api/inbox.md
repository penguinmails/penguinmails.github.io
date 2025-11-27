---
title: "Inbox API"
description: "Detailed endpoint specifications for Unified Inbox"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Inbox API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/tenant/inbox`

---


## Endpoints


### List Threads

**Method**: `GET`  
**URL**: `/api/v1/tenant/inbox/threads`  
**Purpose**: List email threads for the unified inbox.

**Query Parameters**:


- `workspace` (string, required): Workspace slug


- `status` (string, optional): `open` (default), `archived`, `snoozed`


- `limit` (integer, optional): Default 20

**Response**:


```json
{
  "success": true,
  "data": [
    {
      "id": "th_123",
      "subject": "Re: Introduction",
      "last_message_at": "2025-11-21T10:30:00Z",
      "snippet": "Sounds good, let's meet...",
      "lead": {
        "id": "lead_456",
        "email": "prospect@example.com",
        "name": "Alice"
      },
      "unread": true
    }
  ]
}


```


### Get Thread Details

**Method**: `GET`  
**URL**: `/api/v1/tenant/inbox/threads/{id}`  
**Purpose**: Retrieve full conversation history for a thread.

**Response**:


```json
{
  "success": true,
  "data": {
    "id": "th_123",
    "subject": "Re: Introduction",
    "messages": [
      {
        "id": "msg_1",
        "from": "me",
        "body": "Hi Alice...",
        "timestamp": "2025-11-20T09:00:00Z"
      },
      {
        "id": "msg_2",
        "from": "prospect",
        "body": "Sounds good...",
        "timestamp": "2025-11-21T10:30:00Z"
      }
    ]
  }
}


```


### Reply to Thread

**Method**: `POST`  
**URL**: `/api/v1/tenant/inbox/threads/{id}/reply`  
**Purpose**: Send a reply to a thread.

**Request**:


```json
{
  "body": "Great, see you then!",
  "attachments": []
}


```


### Update Thread Status

**Method**: `PATCH`  
**URL**: `/api/v1/tenant/inbox/threads/{id}`  
**Purpose**: Archive, snooze, or mark as read.

**Request**:


```json
{
  "status": "archived",
  "unread": false
}


```

