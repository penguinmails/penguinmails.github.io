---
title: "Engagement Heatmaps"
description: "Visual heatmaps for send time optimization"
---

# Engagement Heatmaps

## Overview

**Priority**: P1 (MVP important)
**Effort**: Medium (4-6 days)
**Timeline**: Q1 2026

**Description**:
Implement visual heatmaps showing optimal send times and engagement patterns by day and hour.

**Acceptance Criteria**:

- Create engagement heatmap visualization component
- Show day-of-week × hour-of-day engagement grid (7 days × 24 hours)
- Color-code cells by engagement level (green = high, yellow = medium, red = low)
- Support filtering by campaign, workspace, or audience segment
- Provide "optimal send time" recommendation based on heatmap data
- Allow export of heatmap data (CSV with day/hour/engagement values)
- Include timezone adjustment for user's local time
- Add tooltip showing exact engagement metrics on hover

**Dependencies**:

- Historical engagement data (minimum 30 days)
- Heatmap visualization library
- Timezone handling
