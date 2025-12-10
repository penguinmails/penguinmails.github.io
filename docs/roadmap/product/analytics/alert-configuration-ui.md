---
title: "Alert Configuration UI"
description: "Performance alerts and notifications"
---

# Alert Configuration UI

## Overview

**Priority**: P1 (MVP important)
**Effort**: Medium (5-7 days)
**Timeline**: Q1 2026

**Description**:
Implement user interface for configuring performance alerts and notifications.

**Acceptance Criteria**:

- Create `/dashboard/settings/alerts` route for alert configuration
- Support alert types: deliverability drop, bounce spike, spam complaints, blacklist detection, reputation drop
- Allow custom threshold configuration (e.g., "Alert if bounce rate > 5%")
- Support notification channels: email, SMS (Twilio integration), webhook
- Provide alert history view with timestamps and resolution tracking
- Include alert testing functionality ("Send test alert")
- Implement alert muting/snoozing capability
- Add alert priority levels (critical, warning, info)

**Dependencies**:

- Notification service (email via Loop.so, SMS via Twilio)
- Webhook delivery system
- Alert evaluation engine (background job)
