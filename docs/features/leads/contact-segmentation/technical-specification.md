---
title: "Segmentation Technical Specification"
description: "Database schema, rules engine architecture, background jobs, and API endpoints for contact segmentation."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Segmentation Technical Specification

The segmentation engine provides a high-performance filtering layer above the contact database, supporting both manual lists and real-time dynamic rules.

## Database Schema

### Core Tables

- `segments`: Stores segment metadata and JSONB rule definitions.
- `segment_contacts`: Pivot table for many-to-many relationships (membership). Supports `rule_match`, `manual`, or `import`.
- `segment_analytics`: Daily snapshots of segment performance metrics (opens, clicks, revenue, etc.).

```sql
-- Dynamic Segment Rules Example
{
  "match": "all",
  "groups": [
    {
      "field": "contact.email",
      "operator": "contains",
      "value": "@gmail.com"
    }
  ]
}
```

## Segment Rules Engine

The `SegmentEngine` class is responsible for converting JSONB rules into optimized SQL queries.

### Process Flow

1. **Fetch Segment**: Load rules and type.
2. **Build Query**: Recursively parse Groups and Rules into an ORM-compatible query object.
3. **Evaluate**: Execute the query against the `contacts` table.
4. **Update Cache**: Wipe and repopulate `segment_contacts` for the given segment.

## Background Operations

### Recalculation Jobs

- **Frequency**: Every 30 minutes.
- **Scope**: All active dynamic segments.
- **Reliability**: Uses a queue system (e.g., Bull or Kafka) to prevent system wide performance degradation.

### Analytics Aggregation

- **Frequency**: Daily at 2:00 AM.
- **Action**: Aggregates campaign engagement data scoped to segment members for historical reporting.

## API Integration

### Creating Segments

`POST /api/segments`
Supports both dynamic rule configuration and manual contact ID lists for static segments.

### Fetching Members

`GET /api/segments/:id/contacts`
Returns paginated list of contacts currently belonging to the segment.
