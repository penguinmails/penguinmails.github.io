---
title: "Automation & API Surface"
description: "Cron jobs, analytics aggregation logic, and development API endpoints."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

## Background Automation (Crons)

| Task | Schedule | Purpose |
|------|----------|---------|
| **Step Processor** | Every 5 mins | Processes pending email/wait steps. |
| **Analytics Aggregator** | 2 AM Daily | Summarizes previous day's engagement data. |
| **Lifecycle Manager** | Hourly | Auto-completes campaigns with 0 active contacts. |

## REST API Surface

Endpoints for programmatic campaign control.

### Management

- `POST /api/campaigns`: Create a draft sequence.
- `GET /api/campaigns/:id`: Retrieve full config, steps, and status.
- `POST /api/campaigns/:id/launch`: Trigger enrollment and execution.
- `POST /api/campaigns/:id/clone`: Duplicate existing templates and logic.

### Live Controls

- `POST /api/campaigns/:id/pause`: Temporarily halt all email sending.
- `POST /api/campaigns/:id/resume`: Re-activate paused participants.

### Analytics

- `GET /api/campaigns/:id/analytics`: Retrieve time-series performance data.

## Analytics Aggregation Logic

The daily aggregator pulls raw events from the `emails` table (Sent, Opened, Clicked) and upserts them into `campaign_analytics`. This ensures that historical reporting remains fast even as the system grows.
