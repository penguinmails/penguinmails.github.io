---
title: "System Monitoring API"
description: "Infrastructure health, queue monitoring, and log access endpoints"
last_modified_date: "2025-12-04"
level: "3"
persona: "Backend Developers"
---

# System Monitoring API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)  
**URL Prefix**: `/api/v1/platform/system`

---

## Overview

The System Monitoring API provides endpoints for infrastructure health monitoring, background job queue management, centralized log access, and IP reputation tracking.

---

## Queue Endpoints

### List Queues

**Method**: `GET`  
**URL**: `/api/v1/platform/system/queues`  
**Purpose**: Get status of all background job queues

**Response**:

```json
{
  "success": true,
  "data": {
    "queues": [
      {
        "name": "queue:email-sending:high",
        "priority": "high",
        "active_jobs": 12,
        "waiting_jobs": 45,
        "completed_last_hour": 1234,
        "failed_jobs": 2,
        "status": "healthy"
      },
      {
        "name": "queue:email-sending",
        "priority": "normal",
        "active_jobs": 50,
        "waiting_jobs": 2500,
        "completed_last_hour": 5678,
        "failed_jobs": 8,
        "status": "warning"
      }
    ]
  }
}
```

**Status Values**:

- `healthy`: waiting < 100
- `warning`: waiting 100-1000
- `critical`: waiting > 1000 or failures > 10

---

### Get Queue Jobs

**Method**: `GET`  
**URL**: `/api/v1/platform/system/queues/{queue_name}/jobs`  
**Purpose**: List jobs in a specific queue

**Query Parameters**:

- `status`: `active` | `waiting` | `failed` | `completed`
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

**Response**:

```json
{
  "success": true,
  "data": {
    "jobs": [
      {
        "id": "job_123",
        "queue": "queue:email-sending",
        "status": "failed",
        "payload": {
          "campaign_id": "cmp_abc",
          "recipient_count": 1000
        },
        "error": {
          "message": "SMTP connection timeout",
          "stack_trace": "..."
        },
        "attempts": 3,
        "created_at": "2025-12-04T10:00:00Z",
        "updated_at": "2025-12-04T10:15:00Z"
      }
    ],
    "pagination": {
      "total": 125,
      "limit": 50,
      "offset": 0
    }
  }
}
```

---

### Pause Queue

**Method**: `POST`  
**URL**: `/api/v1/platform/system/queues/{queue_name}/pause`  
**Purpose**: Emergency stop for troubleshooting

**Response**:

```json
{
  "success": true,
  "data": {
    "queue": "queue:email-sending",
    "status": "paused",
    "timestamp": "2025-12-04T12:00:00Z"
  }
}
```

---

### Resume Queue

**Method**: `POST`  
**URL**: `/api/v1/platform/system/queues/{queue_name}/resume`  
**Purpose**: Re-enable queue processing

---

### Retry Failed Job

**Method**: `POST`  
**URL**: `/api/v1/platform/system/jobs/{job_id}/retry`  
**Purpose**: Re-queue a failed job

**Response**:

```json
{
  "success": true,
  "data": {
    "job_id": "job_123",
    "status": "queued",
    "attempts_reset": true
  }
}
```

---

### Delete Job

**Method**: `DELETE`  
**URL**: `/api/v1/platform/system/jobs/{job_id}`  
**Purpose**: Permanently remove a job from queue

---

## Infrastructure Endpoints

### Get Infrastructure Health

**Method**: `GET`  
**URL**: `/api/v1/platform/system/infrastructure/health`  
**Purpose**: Real-time service health status

**Response**:

```json
{
  "success": true,
  "data": {
    "services": [
      {
        "name": "API Server",
        "status": "healthy",
        "response_time_ms": {
          "avg": 120,
          "p95": 250,
          "p99": 450
        },
        "error_rate_percent": 0.1
      },
      {
        "name": "SMTP Service",
        "status": "degraded",
        "queue_backlog": 5000,
        "reason": "High volume during campaign launch"
      },
      {
        "name": "OLTP Database",
        "status": "healthy",
        "connection_pool_usage_percent": 45,
        "query_latency_ms": 8
      }
    ]
  }
}
```

**Status Values**:

- `healthy`: All metrics normal
- `degraded`: Performance impact
- `down`: Service unavailable

---

### Get IP Reputation

**Method**: `GET`  
**URL**: `/api/v1/platform/system/infrastructure/ip-reputation`  
**Purpose**: Monitor email sending reputation

**Response**:

```json
{
  "success": true,
  "data": {
    "ips": [
      {
        "ip_address": "203.0.113.12",
        "provider": "AWS",
        "reputation_score": 92,
        "blacklists": ["spamhaus"],
        "daily_volume": 50000,
        "status": "critical"
      },
      {
        "ip_address": "203.0.113.13",
        "provider": "SendGrid",
        "reputation_score": 98,
        "blacklists": [],
        "daily_volume": 75000,
        "status": "good"
      }
    ]
  }
}
```

---

### Get Infrastructure Alerts

**Method**: `GET`  
**URL**: `/api/v1/platform/system/infrastructure/alerts`  
**Purpose**: Recent infrastructure alerts

**Query Parameters**:

- `hours` (optional): Hours of history (default: 24, max: 168)
- `severity` (optional): `error` | `warning` | `info`

**Response**:

```json
{
  "success": true,
  "data": {
    "alerts": [
      {
        "id": "alert_123",
        "timestamp": "2025-12-04T11:30:00Z",
        "severity": "error",
        "service": "SMTP",
        "message": "Queue size exceeded 10k threshold",
        "acknowledged": false
      }
    ]
  }
}
```

---

## Log Endpoints

### Search Logs

**Method**: `GET`  
**URL**: `/api/v1/platform/system/logs`  
**Purpose**: Search and filter application logs

**Query Parameters**:

- `query`: Search term (full-text or regex)
- `level`: `error` | `warning` | `info` | `debug`
- `service`: Filter by service name
- `start_time`: ISO 8601 timestamp
- `end_time`: ISO 8601 timestamp
- `request_id` (optional): Filter by request ID
- `user_id` (optional): Filter by user ID
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

**Response**:

```json
{
  "success": true,
  "data": {
    "logs": [
      {
        "id": "log_123",
        "timestamp": "2025-12-04T12:15:30Z",
        "level": "error",
        "service": "api",
        "message": "Payment processing failed",
        "request_id": "req_abc123",
        "user_id": "usr_xyz",
        "metadata": {
          "error_type": "PaymentError",
          "stack_trace": "..."
        }
      }
    ],
    "pagination": {
      "total": 345,
      "limit": 50,
      "offset": 0
    }
  }
}
```

---

### Export Logs

**Method**: `GET`  
**URL**: `/api/v1/platform/system/logs/export`  
**Purpose**: Download filtered logs

**Query Parameters**: Same as search logs, plus:

- `format`: `csv` | `json` | `txt`

**Response** (Async job):

```json
{
  "success": true,
  "data": {
    "export_id": "export_logs_abc",
    "status": "processing",
    "download_url": null
  }
}
```

---

## Error Handling

- `400 Bad Request`: Invalid parameters
- `401 Unauthorized`: Missing or invalid token
- `403 Forbidden`: User does not have Ops role
- `404 Not Found`: Queue, job, or export not found
- `429 Too Many Requests`: Rate limit exceeded

---

## Related Documentation

- [System Monitoring Feature](/docs/features/admin/system-monitoring/) - Feature overview
- [Queue Monitoring](/docs/features/admin/system-monitoring/queue-monitoring) - Queue management details
- [Platform Admin Routes - Queues](/docs/design/routes/platform-admin#dashboard-system-queues) - UI specification
- [Queue System Implementation](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation) - Architecture
