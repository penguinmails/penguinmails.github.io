---
title: "Jobs API"
description: "Detailed endpoint specifications for Background Job Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---

# Jobs API

**Parent API**: [Queue API](/docs/implementation-technical/api/queue)
**URL Prefix**: `/api/v1/queue`

---

## Endpoints

### List Queues

**Method**: `GET`  
**URL**: `/api/v1/queue/list`  
**Purpose**: List all active system queues and their stats.

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "name": "email-sending",
      "counts": {
        "active": 5,
        "waiting": 100,
        "completed": 5000,
        "failed": 2
      }
    }
  ]
}
```

### List Jobs in Queue

**Method**: `GET`  
**URL**: `/api/v1/queue/{name}/jobs`  
**Purpose**: List jobs within a specific queue.

**Query Parameters**:

- `status`: `active`, `waiting`, `completed`, `failed`
- `limit`: Default 20

### Get Job Details

**Method**: `GET`  
**URL**: `/api/v1/queue/{name}/jobs/{id}`  
**Purpose**: Get payload and status of a specific job.

### Retry Job

**Method**: `POST`  
**URL**: `/api/v1/queue/{name}/jobs/{id}/retry`  
**Purpose**: Retry a failed job.

### Pause/Resume Queue

**Method**: `POST`  
**URL**: `/api/v1/queue/{name}/{action}`  
**Purpose**: Pause or resume processing for a queue.
**Action**: `pause` or `resume`
