---
title: "Webhook Routes - Details & Monitoring"
description: "Monitoring dashboard for specific webhooks, including delivery logs, health stats, and lifecycle management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Developers"
---

# Webhook Routes - Details & Monitoring

### `/dashboard/settings/webhooks/[webhook_id]` - Webhook Details

#### Header Details

- **Webhook Name**: "CRM Contact Sync"
- **Status**: Active / Paused / Failing
- **Actions**: Edit, Test, Pause/Resume, Delete.

**Endpoint**: `https://yourapp.com/webhooks/penguinmails`

- **Copy Button**: Copy URL to clipboard.

**Created**: "November 1, 2025 by <john@company.com>"

---

#### 1. Performance Statistics (Last 24 Hours)

- **Total Deliveries**: "1,234"
- **Success Rate**: "99.8%"
- **Avg. Response Time**: "145ms"
- **Failed Deliveries**: "2"

---

#### 2. Configuration Summary

**Event Subscriptions** (Expandable):

- email.sent
- email.delivered
- email.opened
- email.clicked
- email.bounced

**"Edit Events" Link**: Navigate to edit page.

**Event Filters** (JSON View):

```json
{
  "contact.tags": { "$in": ["vip"] }
}
```

---

#### 3. Recent Delivery Logs

List of the last 10 delivery attempts with status and response time.

| Timestamp | Event Type | Status | Response Time | Actions |
|-----------|------------|--------|---------------|---------|
| 2:34 PM | email.opened | ✓ 200 OK | 142ms | View |
| 2:33 PM | email.clicked | ✓ 200 OK | 156ms | View |
| 2:30 PM | email.bounced | ✘ 500 Error | 5000ms | Retry |

**"View All Logs" Link**: Navigate to the full delivery log page.
