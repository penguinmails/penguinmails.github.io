---
title: "Notifications API"
description: "Detailed endpoint specifications for System Notifications"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Notifications API

**Parent API**: [Queue API](/docs/implementation-technical/api/queue)
**URL Prefix**: `/api/v1/queue/notifications`

---

## Endpoints

### System Notifications Feed

**Method**: `GET`  
**URL**: `/api/v1/queue/notifications`  
**Purpose**: Retrieve notification feed for system monitoring.

**Query Parameters**:

- `scope`: `system` (default), `operational`, `business`, `alerts`

- `priority`: `critical`, `high`, `medium`, `low`

- `status`: `unread`, `reviewed`

- `limit`: Default 25

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "id": "ntf_123",
      "type": "system_alert",
      "priority": "high",
      "title": "System Performance Alert",
      "status": "pending_review",
      "created_at": "2025-12-19T12:05:00Z"
    }
  ]
}


```

### Mark Notification Reviewed

**Method**: `POST`  
**URL**: `/api/v1/queue/notifications/{id}/reviewed`  
**Purpose**: Mark a notification as reviewed.

**Request**:

```json
{
  "reviewed": true,
  "notes": "System trend acknowledged"
}


```

### Bulk Review

**Method**: `POST`  
**URL**: `/api/v1/queue/notifications/bulk-review`  
**Purpose**: Mark multiple notifications as reviewed.

**Request**:

```json
{
  "ids": ["ntf_123", "ntf_456"],
  "action": "quarterly_review",
  "context": "Q1 operational planning cycle"
}


```
