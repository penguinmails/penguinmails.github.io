---
title: "Marketing Platform API - Core Endpoints"
description: "Endpoints for campaign management, lead capture, and performance analytics."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Marketing Platform API - Core Endpoints

## Core Marketing APIs

### Campaign Management API

#### Create Campaign

```http
POST /api/v1/campaigns
```

**Request Body:**

```json
{
  "name": "Q1 Product Launch Campaign",
  "type": "email_marketing",
  "target_audience": {
    "segments": ["enterprise_customers", "trial_users"],
    "criteria": {
      "company_size": "50-500",
      "industry": ["technology", "finance"]
    }
  },
  "schedule": {
    "start_date": "2025-01-15T09:00:00Z",
    "end_date": "2025-02-15T18:00:00Z",
    "timezone": "UTC"
  }
}
```

#### Get Campaign Performance

```http
GET /api/v1/campaigns/{campaign_id}/performance
```

**Response:**

```json
{
  "campaign_id": "camp_789xyz",
  "metrics": {
    "sent": 12500,
    "delivered": 12400,
    "opened": 3720,
    "clicked": 892,
    "converted": 156,
    "bounced": 85,
    "unsubscribed": 12
  }
}
```

### Lead Capture API

#### Submit Lead

```http
POST /api/v1/leads/capture
```

**Request Body:**

```json
{
  "email": "john.doe@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "company": "Acme Inc",
  "source": {
    "campaign_id": "camp_789xyz",
    "channel": "search",
    "referrer": "https://google.com"
  }
}
```

### Analytics and Reporting API

#### Get Campaign Analytics

```http
GET /api/v1/analytics/campaigns?start_date=2025-01-01&end_date=2025-01-31
```

**Response:**

```json
{
  "summary": {
    "total_campaigns": 8,
    "total_recipients": 125000,
    "average_open_rate": 28.5,
    "average_click_rate": 6.8,
    "total_revenue": 385000,
    "overall_roi": 325.8
  }
}
```
