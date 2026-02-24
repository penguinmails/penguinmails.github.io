---
title: "Campaign Database Schema"
description: "SQL table definitions for campaigns, sequences, enrollments, and analytics."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, DBAs"
---

## Core Tables

### Campaigns

Root object for all outreach efforts.

- **Status**: Draft, Scheduled, Active, Paused, Completed.
- **Type**: Broadcast, Drip, Triggered, A/B Test.

### Campaign Steps

Defines the sequence of events (Emails, Waits, Conditions).

- **Wait**: Duration-based pauses between steps.
- **Condition**: Logic-driven branching (e.g., "if opened, do X").

### Campaign Contacts

Tracks users through the sequence lifecycle.

- **Progress**: Current step, status, and enrollment timing.
- **Exits**: Tracks why a contact left (Completed, Unsubscribed, Exited).

### Campaign Analytics

Aggregated metrics per campaign and date.

- **Sending**: Sent, Delivered, Bounced.
- **Engagement**: Opens, Clicks, Replies.
- **Negative**: Spam, Unsubscribes.

---

## SQL Reference Snippets

```sql
-- Campaign Steps Schema example
CREATE TABLE campaign_steps (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  step_order INTEGER NOT NULL,
  step_type VARCHAR(50), -- email, wait, condition, action
  template_id UUID REFERENCES templates(id),
  wait_duration_value INTEGER,
  wait_duration_unit VARCHAR(20)
);

-- Analytics Aggregation example
CREATE TABLE campaign_analytics (
  campaign_id UUID NOT NULL,
  date DATE NOT NULL,
  total_opens INTEGER DEFAULT 0,
  unique_clicks INTEGER DEFAULT 0,
  calculated_at TIMESTAMP DEFAULT NOW()
);
```
