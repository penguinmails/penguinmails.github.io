---
title: "Campaign Execution Engine"
description: "Technical logic for launching campaigns and processing sequence steps."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

## Launch Lifecycle

When a campaign is launched via the `CampaignExecutionEngine`:

1. **Audience Extraction**: Fetches all contacts matching the assigned `segment_id`.
2. **Enrollment**: Creates records in `campaign_contacts` for each user.
3. **Status Update**: Transitions the campaign state to `active`.
4. **Trigger**: Initiates the processing of Step 1 for the new batch.

## Step Processing Logic

The engine iterates through participants whose `next_scheduled_at` timestamp is in the past.

### 1. Email Steps

- **Personalization**: Renders templates with contact-specific metadata.
- **Queueing**: Pushes the job to the high-priority `Email Pipeline`.
- **Progress**: Determines the next step and schedules it.

### 2. Wait Steps

- **Calculation**: Adds the defined duration (hours/days) to the current time.
- **Scheduling**: Updates the contact record to sleep until that window.

### 3. Conditional Steps

- **Evaluation**: Checks engagement behavior (Opened? Clicked?) or lead attributes (Score > 50?).
- **Branching**: Points the contact's `current_step_id` to either the `true` or `false` path.

## Optimization Strategy

- **Send Strategy**: Options for "Immediate", "Scheduled", or AI-powered "Optimized" (sends when the user is most likely to open).
- **Concurrency**: Parallel processing for high-volume broadcast launches.
