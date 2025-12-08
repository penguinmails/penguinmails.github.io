---
title: "Analytics API"
description: "Tenant API endpoints for campaign analytics, engagement tracking, and deliverability metrics"
last_modified_date: "2025-11-26"
level: "3"
persona: "Backend Developers"
---

# Analytics API

**Parent API**: [Tenant API](/docs/implementation-technical/api/tenant-api)
**URL Prefix**: `/api/v1/workspaces/{workspaceId}`

---

## Overview

The Analytics API provides comprehensive campaign performance metrics, engagement tracking, and deliverability analytics for tenant workspaces. All endpoints require workspace-level authentication and return data scoped to the authenticated workspace.

**Key Capabilities:**

- Campaign performance metrics (updated daily via OLAP batch jobs)

- Engagement tracking (opens, clicks, replies)

- Deliverability analytics and inbox placement estimation

- Time-series data for trend analysis

- Aggregated workspace-level metrics

- Data export functionality

> [!NOTE]
> **Data Freshness**: Analytics are updated via daily batch jobs (typically 2 AM UTC). For real-time subscription status, query OLTP directly. Real-time streaming analytics is planned for Q1 2027.

**Technical Architecture:**

- **OLAP Database**: PostgreSQL with TimescaleDB for time-series analytics data

- **PostHog**: Event tracking, user behavior analytics, and operational monitoring

- **Queue System**: PostgreSQL + Redis for background job processing (exports, reports)

---

## Endpoints

### Get Campaign Analytics

**Method**: `GET`
**URL**: `/api/v1/workspaces/{workspaceId}/campaigns/{campaignId}/analytics`
**Purpose**: Retrieve comprehensive analytics for a specific campaign

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

- `campaignId` (string, required) - Campaign identifier

**Query Parameters:**

- `timeRange` (string, optional) - Time range filter: `7d`, `30d`, `90d`, `custom` (default: `30d`)

- `startDate` (ISO 8601, optional) - Start date for custom range

- `endDate` (ISO 8601, optional) - End date for custom range

- `groupBy` (string, optional) - Group results by: `day`, `week`, `month` (default: `day`)

**Response:**

```json
{
  "success": true,
  "data": {
    "campaign_id": "cmp_abc123",
    "campaign_name": "Q4 Outreach Campaign",
    "time_range": {
      "start": "2025-10-27T00:00:00Z",
      "end": "2025-11-26T23:59:59Z",
      "period": "30d"
    },
    "summary": {
      "emails_sent": 5000,
      "emails_delivered": 4900,
      "emails_bounced": 100,
      "emails_opened": 1470,
      "emails_clicked": 245,
      "emails_replied": 98,
      "spam_complaints": 5,
      "unsubscribes": 12
    },
    "rates": {
      "delivery_rate": 98.0,
      "open_rate": 30.0,
      "click_rate": 5.0,
      "click_to_open_rate": 16.67,
      "reply_rate": 2.0,
      "bounce_rate": 2.0,
      "spam_rate": 0.1,
      "unsubscribe_rate": 0.24
    },
    "time_series": [
      {
        "date": "2025-11-01",
        "sent": 200,
        "delivered": 196,
        "opened": 60,
        "clicked": 10,
        "replied": 4
      }
    ]
  }
}
```

> [!NOTE]
> **Email Timing Metrics**: Metrics like `average_time_to_open_hours` require event-level timestamp logging which is not currently captured. This is planned for Q1 2027. See [Analytics Roadmap](/docs/features/analytics/roadmap).

---

### Get Workspace Analytics Overview

**Method**: `GET`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/overview`
**Purpose**: Retrieve aggregated analytics across all campaigns in a workspace

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

**Query Parameters:**

- `timeRange` (string, optional) - Time range filter: `7d`, `30d`, `90d`, `custom` (default: `30d`)

- `startDate` (ISO 8601, optional) - Start date for custom range

- `endDate` (ISO 8601, optional) - End date for custom range

**Response:**

```json
{
  "success": true,
  "data": {
    "workspace_id": "ws_xyz789",
    "time_range": {
      "start": "2025-10-27T00:00:00Z",
      "end": "2025-11-26T23:59:59Z",
      "period": "30d"
    },
    "summary": {
      "total_campaigns": 15,
      "active_campaigns": 8,
      "emails_sent": 75000,
      "emails_delivered": 73500,
      "emails_opened": 22050,
      "emails_clicked": 3675,
      "emails_replied": 1470
    },
    "rates": {
      "delivery_rate": 98.0,
      "open_rate": 30.0,
      "click_rate": 5.0,
      "reply_rate": 2.0
    },
    "top_campaigns": [
      {
        "campaign_id": "cmp_abc123",
        "campaign_name": "Q4 Outreach",
        "open_rate": 35.5,
        "reply_rate": 3.2
      }
    ]
  }
}

```

---

### Get Deliverability Analytics

**Method**: `GET`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/deliverability`
**Purpose**: Retrieve detailed deliverability metrics and inbox placement data

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

**Query Parameters:**

- `timeRange` (string, optional) - Time range filter: `7d`, `30d`, `90d` (default: `30d`)

- `campaignId` (string, optional) - Filter by specific campaign

- `domainId` (string, optional) - Filter by specific sending domain

**Response:**

```json
{
  "success": true,
  "data": {
    "workspace_id": "ws_xyz789",
    "time_range": {
      "start": "2025-10-27T00:00:00Z",
      "end": "2025-11-26T23:59:59Z"
    },
    "overall": {
      "estimated_inbox_placement_rate": 95.5,
      "spam_rate": 2.5,
      "bounce_rate": 2.0,
      "health_score": 92
    },
    "bounce_analysis": {
      "hard_bounces": 800,
      "soft_bounces": 700,
      "hard_bounce_rate": 1.07,
      "soft_bounce_rate": 0.93,
      "top_bounce_reasons": [
        {
          "reason": "Mailbox full",
          "count": 350,
          "percentage": 23.3
        },
        {
          "reason": "Invalid recipient",
          "count": 500,
          "percentage": 33.3
        }
      ]
    },
    "reputation_trend": [
      {
        "date": "2025-11-01",
        "score": 90
      },
      {
        "date": "2025-11-15",
        "score": 92
      }
    ],
    "blacklist_status": {
      "any_ip_blacklisted": false,
      "ips_checked": 3,
      "last_check": "2025-11-26T10:00:00Z"
    }
  }
}

```

> [!IMPORTANT]
> **Deliverability Metrics Explained**:
>
> - `estimated_inbox_placement_rate`: Derived from `(sent - bounced - spam_complaints) / sent`. True inbox placement requires external seed list tools (planned Q2 2026 spike).
> - `health_score`: Internal deliverability health (0-100) from OLAP `mailbox_analytics`. External reputation tools (Google Postmaster, Microsoft SNDS) integration is planned. See [Sender Reputation Feature](/docs/features/domains/sender-reputation).
> - `blacklist_status`: Aggregated from per-IP checks in OLTP `smtp_ip_addresses.provider_blacklist_status`.
>
> **Provider-Level Breakdown**: Per-provider analytics (Gmail, Outlook, Yahoo) is **Post-MVP** (Q4 2026 spike). See [Analytics Roadmap](/docs/features/analytics/roadmap).

---

### Get Engagement Heatmap

**Method**: `GET`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/engagement-heatmap`
**Purpose**: Retrieve engagement patterns by day of week and hour of day

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

**Query Parameters:**

- `timeRange` (string, optional) - Time range for analysis: `30d`, `90d` (default: `30d`)

- `campaignId` (string, optional) - Filter by specific campaign

- `timezone` (string, optional) - Timezone for hour calculations (default: workspace timezone)

**Response:**

```json
{
  "success": true,
  "data": {
    "workspace_id": "ws_xyz789",
    "timezone": "America/New_York",
    "optimal_send_time": {
      "day_of_week": "Tuesday",
      "hour": 10,
      "engagement_score": 85.5
    },
    "heatmap": [
      {
        "day_of_week": "Monday",
        "time_period": "office_hours",
        "emails_sent": 500,
        "emails_opened": 150,
        "open_rate": 30.0,
        "engagement_score": 75.5
      },
      {
        "day_of_week": "Tuesday",
        "time_period": "office_hours",
        "emails_sent": 600,
        "emails_opened": 210,
        "open_rate": 35.0,
        "engagement_score": 85.5
      }
    ]
  }
}
```

> [!NOTE]
> **Engagement Score Formula**: `engagement_score = (opens × 0.3 + clicks × 0.4 + replies × 0.3) / sent × 100`
>
> **Time Periods** (MVP simplified granularity):
>
> - `nighttime`: 12 AM - 6 AM
> - `early_morning`: 6 AM - 9 AM  
> - `office_hours`: 9 AM - 5 PM
> - `evening`: 5 PM - 12 AM
>
> **Roadmap**: Finer hourly granularity and audience-specific timing planned for Q3 2026 spike.

---

### Compare Campaigns

**Method**: `POST`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/compare`
**Purpose**: Compare performance metrics across multiple campaigns

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

**Request Body:**

```json
{
  "campaign_ids": ["cmp_abc123", "cmp_def456", "cmp_ghi789"],
  "time_range": "30d",
  "metrics": ["open_rate", "click_rate", "reply_rate", "delivery_rate"]
}

```

**Response:**

```json
{
  "success": true,
  "data": {
    "comparison": [
      {
        "campaign_id": "cmp_abc123",
        "campaign_name": "Q4 Outreach",
        "metrics": {
          "open_rate": 35.5,
          "click_rate": 6.2,
          "reply_rate": 3.1,
          "delivery_rate": 98.5
        }
      },
      {
        "campaign_id": "cmp_def456",
        "campaign_name": "Product Launch",
        "metrics": {
          "open_rate": 28.3,
          "click_rate": 4.8,
          "reply_rate": 2.2,
          "delivery_rate": 97.8
        }
      }
    ],
    "statistical_significance": [
      {
        "metric": "open_rate",
        "winner": "cmp_abc123",
        "p_value": 0.03,
        "is_significant": true
      }
    ]
  }
}

```

---

### Export Analytics Data

**Method**: `POST`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/export`
**Purpose**: Generate and export analytics data in various formats

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

**Request Body:**

```json
{
  "export_type": "campaign_performance",
  "format": "csv",
  "time_range": "30d",
  "campaign_ids": ["cmp_abc123"],
  "include_time_series": true
}

```

**Response:**

```json
{
  "success": true,
  "data": {
    "export_id": "exp_xyz123",
    "status": "processing",
    "estimated_completion": "2025-11-26T10:05:00Z",
    "download_url": null
  }
}

```

---

### Get Export Status

**Method**: `GET`
**URL**: `/api/v1/workspaces/{workspaceId}/analytics/exports/{exportId}`
**Purpose**: Check status of analytics export and retrieve download URL

**Path Parameters:**

- `workspaceId` (string, required) - Workspace identifier

- `exportId` (string, required) - Export job identifier

**Response:**

```json
{
  "success": true,
  "data": {
    "export_id": "exp_xyz123",
    "status": "completed",
    "format": "csv",
    "file_size_bytes": 524288,
    "created_at": "2025-11-26T10:00:00Z",
    "completed_at": "2025-11-26T10:03:00Z",
    "download_url": "https://s3.amazonaws.com/exports/exp_xyz123.csv?expires=3600",
    "expires_at": "2025-11-26T11:03:00Z"
  }
}

```

---

## Data Models

### Analytics Summary

```typescript
interface AnalyticsSummary {
  emails_sent: number;
  emails_delivered: number;
  emails_bounced: number;
  emails_opened: number;
  emails_clicked: number;
  emails_replied: number;
  spam_complaints: number;
  unsubscribes: number;
}

```

### Analytics Rates

```typescript
interface AnalyticsRates {
  delivery_rate: number;      // Percentage (0-100)
  open_rate: number;           // Percentage (0-100)
  click_rate: number;          // Percentage (0-100)
  click_to_open_rate: number;  // Percentage (0-100)
  reply_rate: number;          // Percentage (0-100)
  bounce_rate: number;         // Percentage (0-100)
  spam_rate: number;           // Percentage (0-100)
  unsubscribe_rate: number;    // Percentage (0-100)
}

```

### Time Series Data Point

```typescript
interface TimeSeriesDataPoint {
  date: string;              // ISO 8601 date
  sent: number;
  delivered: number;
  opened: number;
  clicked: number;
  replied: number;
  bounced?: number;
  spam_complaints?: number;
}

```

---

## Error Responses

### Campaign Not Found

```json
{
  "success": false,
  "error": {
    "code": "CAMPAIGN_NOT_FOUND",
    "message": "Campaign with ID cmp_abc123 not found in workspace ws_xyz789"
  }
}

```

### Invalid Time Range

```json
{
  "success": false,
  "error": {
    "code": "INVALID_TIME_RANGE",
    "message": "Start date must be before end date"
  }
}

```

### Export Failed

```json
{
  "success": false,
  "error": {
    "code": "EXPORT_FAILED",
    "message": "Failed to generate export: insufficient data"
  }
}

```

---

## Rate Limits

- **Campaign Analytics**: 100 requests per minute per workspace

- **Workspace Overview**: 60 requests per minute per workspace

- **Deliverability Analytics**: 30 requests per minute per workspace

- **Export Requests**: 10 requests per minute per workspace

---

## Related Documentation

### Feature Documentation

- **[Analytics & Reporting Features](/docs/features/analytics/core-analytics/overview)** - Feature overview and capabilities

- **[Enhanced Analytics](/docs/features/analytics/enhanced-analytics/overview)** - Q1 2026 advanced analytics features

- **[Manual Reporting](/docs/features/analytics/manual-reporting)** - Scheduled reports and data export

- **[Sender Reputation](/docs/features/domains/sender-reputation)** - Health score and external reputation tools

- **[Analytics Roadmap](/docs/features/analytics/roadmap)** - Planned improvements and spikes

### API Documentation

- **[Campaign Management API](/docs/implementation-technical/api/tenant-api/campaigns)** - Campaign CRUD operations

- **[Workspace API](/docs/implementation-technical/api/tenant-api/workspaces)** - Workspace management

- **[Platform Analytics API](/docs/implementation-technical/api/platform-api/analytics)** - System-level analytics

### Frontend Routes

- **[Workspace Campaigns Routes](/docs/design/routes/workspace-campaigns)** - Campaign dashboard with analytics

- **[Platform Admin Routes](/docs/design/routes/platform-admin)** - Finance and system analytics

### Technical Architecture

- **[OLAP Analytics Schema](/docs/implementation-technical/database-infrastructure/olap-analytics-schema-guide)** - Database architecture for analytics

- **[Queue System](/docs/features/queue/background-jobs)** - Background job processing

### Implementation Planning

- **[Analytics Feature Review](/.kiro/specs/feature-completeness-review/findings/analytics-reporting)** - Gap analysis, roadmap, and implementation priorities

---

**Last Updated:** November 26, 2025
**API Version:** v1
**Status:** Active Development
