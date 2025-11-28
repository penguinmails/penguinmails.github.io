---
title: "Events API"
description: "Detailed endpoint specifications for System Event Processing"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Events API

**Parent API**: [Queue API](/docs/implementation-technical/api/queue)
**URL Prefix**: `/api/../queue/events`

---

## Endpoints

### Publish System Event

**Method**: `POST`  
**URL**: `/api/v1/queue/events`  
**Purpose**: Publish a system event for processing and notification generation.

**Request**:

```json
{
  "type": "system_alert",
  "source": "monitoring_system",
  "tenant_id": "tn_123",
  "timestamp": "2025-12-19T12:00:00Z",
  "payload": {
    "impact": "moderate_increasing_risk",
    "priority": "medium",
    "context": "deliverability_trend_analysis"
  }
}


```

**Response**:

```json
{
  "success": true,
  "data": {
    "event_id": "evt_abc123",
    "processed": true,
    "notification_generated": true
  }
}


```

### Domain-Specific Events

**Method**: `POST`  
**URL**: `/api/v1/queue/events/{domain}`  
**Purpose**: Publish domain-specific events (system-alerts, business-metrics, operational-updates).

**Supported Domains**:

- `system-alerts`

- `business-metrics`

- `operational-updates`
