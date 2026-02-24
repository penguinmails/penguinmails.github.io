---
title: "ESP Webhooks & Analytics"
description: "Specifications for real-time delivery event webhooks and comparative provider performance analytics dashboards."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# ESP Webhooks & Analytics

### `/dashboard/settings/integrations/esp/webhooks` - Webhook Configuration

**User Story**: *"As an admin, I want to receive real-time delivery events from ESPs, so I can track email performance accurately."*

**What You'll Find**:

### Webhook Endpoints

**Postmark Webhook**:

- **Endpoint URL**: `https://api.penguinmails.com/webhooks/postmark`
- **Copy Button**: Copy URL to clipboard.
- **Status**: Active (Green) or Inactive (Gray).
- **Events Received Today**: "1,234"
- **Last Event**: "2 minutes ago"

**Mailgun Webhook**:

- **Endpoint URL**: `https://api.penguinmails.com/webhooks/mailgun`
- **Copy Button**: Copy URL to clipboard.
- **Status**: Active (Green) or Inactive (Gray).
- **Events Received Today**: "5,678"
- **Last Event**: "5 minutes ago"

### Event Subscriptions

**Postmark Events** (Checkboxes):

- ☑ **Delivery**: Email successfully delivered.
- ☑ **Bounce**: Email bounced (hard or soft).
- ☑ **Open**: Recipient opened email.
- ☑ **Click**: Recipient clicked link.
- ☐ **Spam Complaint**: Recipient marked as spam.
- ☐ **Subscription Change**: Unsubscribe or resubscribe.

**Mailgun Events** (Checkboxes):

- ☑ **Delivered**: Email successfully delivered.
- ☑ **Failed**: Permanent delivery failure.
- ☑ **Opened**: Recipient opened email.
- ☑ **Clicked**: Recipient clicked link.
- ☐ **Unsubscribed**: Recipient unsubscribed.
- ☐ **Complained**: Spam complaint.

### Webhook Security

**Signature Verification**:

- **Postmark**: Uses `X-Postmark-Signature` header.
- **Mailgun**: Uses `X-Mailgun-Signature` header with timestamp.
- **Status**: Verified (Green checkmark) or "Configure signing key".

### Webhook Logs

**Recent Events Table**:

- Columns: Timestamp, Provider, Event Type, Email, Status, Details.
- **Filters**: Provider, Event Type, Date Range.
- **Search**: Search by email or message ID.
- **Export**: Download logs as CSV.

**Example Rows**:

| Timestamp | Provider | Event | Email | Status | Details |
|-----------|----------|-------|-------|--------|---------|
| 2:34 PM | Postmark | Delivery | <user@example.com> | Success | Delivered in 1.2s |
| 2:33 PM | Mailgun | Open | <lead@company.com> | Success | Opened on mobile |
| 2:30 PM | Postmark | Bounce | <invalid@test.com> | Hard Bounce | User unknown |

**"View Full Log" Link**: Opens detailed webhook event viewer.

### Webhook Testing

**Test Webhook Section**:

- **Provider**: Dropdown (Postmark, Mailgun).
- **Event Type**: Dropdown (Delivery, Bounce, Open, Click).
- **"Send Test Event" Button**: Triggers test webhook from ESP.
- **Result Display**: Shows received payload and processing status.

**User Journey Context**: Set up once during ESP configuration, check logs when troubleshooting delivery issues.

**Related Documentation**:

- [Webhook Integration](/docs/features/integrations/webhook-system)
- [ESP Webhooks](/docs/features/integrations/esp-integration#webhook-integration)

**Technical Integration**:

- **Webhook Handler**: Express.js endpoint with signature verification.
- **Event Processing**: Async job queue for webhook events.
- **Retry Logic**: Exponential backoff for failed webhook processing.

---

## `/dashboard/settings/integrations/esp/analytics` - ESP Analytics

**User Story**: *"As an admin, I want to compare ESP performance, so I can optimize my email routing strategy."*

**What You'll Find**:

### Provider Comparison Dashboard

**Time Range Selector**:

- Buttons: Last 7 Days, Last 30 Days, Last 90 Days, Custom Range.

**Metrics Cards** (Top Row):

- **Total Emails Sent**: "156,789"
- **Average Delivery Rate**: "97.8%"
- **Average Open Rate**: "38.5%"
- **Average Click Rate**: "9.2%"

### Deliverability Comparison

**Table View**:

| Provider | Sent | Delivered | Bounced | Opened | Clicked | Delivery Rate |
|----------|------|-----------|---------|--------|---------|---------------|
| Postmark | 5,234 | 5,192 | 42 (0.8%) | 2,352 (45.3%) | 634 (12.1%) | 99.2% |
| Mailgun | 95,123 | 93,678 | 1,445 (1.5%) | 35,789 (38.2%) | 9,234 (9.7%) | 98.5% |
| Built-in | 56,432 | 53,098 | 3,334 (5.9%) | 16,726 (31.5%) | 3,876 (7.3%) | 94.1% |

### Performance Insights

**Recommendations Section**:

- ✅ **Postmark**: "Excellent for transactional emails. 99.2% delivery rate."
- ⚠️ **Mailgun**: "Good performance. Consider warming up new domains."
- ⚠️ **Built-in SMTP**: "Lower delivery rate. Review IP reputation and warmup strategy."

**Cost Analysis**:

```text
Cost per Delivered Email:

- Postmark: $0.00126 (5,192 delivered)
- Mailgun: $0.00059 (93,678 delivered)
- Built-in: $0.00000 (53,098 delivered)

Total Cost This Month: $61.25
Projected Annual Cost: $735.00
```

### Bounce Analysis

**Bounce Reasons** (Pie Chart):

- Hard Bounce (User Unknown): 45%
- Soft Bounce (Mailbox Full): 30%
- Spam Block: 15%
- Invalid Domain: 10%

**Top Bouncing Domains**:

1. `example.com` - 234 bounces
2. `test.org` - 156 bounces
3. `invalid.net` - 89 bounces

**User Journey Context**: Regular monitoring (weekly/monthly) to optimize ESP usage and routing.

**Related Documentation**:

- [Analytics Overview](/docs/features/analytics/core-analytics/overview)
- [Deliverability Monitoring](/docs/features/warmup/monitoring/overview)

**Technical Integration**:

- **Data Source**: Aggregated from webhook events and ESP APIs.
- **Caching**: Metrics cached for 15 minutes.
- **Export**: Generate CSV/PDF reports.
