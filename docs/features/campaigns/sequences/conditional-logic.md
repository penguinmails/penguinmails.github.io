---
title: "Conditional Branching & Triggers"
description: "Creating adaptive email paths based on user engagement and behavioral data."
last_modified_date: "2026-02-24"
level: "2"
persona: "Advanced Marketers"
---

# Conditional Branching & Triggers

Advanced sequences adapt to the recipient's behavior, ensuring the content is always relevant.

## 1. Engagement-Based Branching

You can split the path of a sequence based on whether a user interacted with a previous step.

**Example**:

- Send Email 1.
- Wait 2 days.
- **Check**: Did they click the "Pricing" link in Email 1?
  - **YES**: Send Email 2 (Case Studies).
  - **NO**: Send Email 2 (Feature Highlights).

## 2. Wait Until

Instead of fixed delays, you can pause a sequence until a specific condition is met.

- **Wait until Open**: Pause until the recipient opens the last email (with a timeout of 7 days).
- **Wait until Event**: Pause until a webhook event occurs (e.g., "Goal Completed" on your website).
- **Wait until Enrichment**: Pause until the "Company Size" field has been populated by our data enrichment service.

## 3. Dynamic Logic (JSONB)

Experienced users can define complex multi-rule conditions using our logic builder:

- **Condition**: (Lead Score > 50) AND (Industry IS NOT "Education") AND (Country IS "United Kingdom").

## 4. Jumping & Internal Triggers

- **Go To Step**: Move a contact directly to a different part of the workflow.
- **Remove from Sequence**: Immediately exit a contact if they perform a specific action, even if they aren't at an exit node.
