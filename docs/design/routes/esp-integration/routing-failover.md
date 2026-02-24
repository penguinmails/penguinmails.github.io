---
title: "ESP Routing & Failover Strategies"
description: "Specifications for visual routing rules, failover configurations, and cost optimization settings for email delivery."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# ESP Routing & Failover Strategies

### `/dashboard/settings/integrations/esp/routing` - Email Routing Rules

**User Story**: *"As an admin, I want to route different email types through different ESPs, so I can optimize deliverability and costs."*

**What You'll Find**:

### Routing Strategy Overview

**Visual Diagram**:

```text
Email Type → Provider

┌─────────────────────┐
│ Transactional       │ → Postmark
├─────────────────────┤
│ Marketing           │ → Mailgun
├─────────────────────┤
│ Cold Outreach       │ → Built-in SMTP
├─────────────────────┤
│ Default (Fallback)  │ → Built-in SMTP
└─────────────────────┘
```

### Routing Rules Builder

**Rule Cards** (Drag-and-drop reorderable):

Each rule card contains:

#### Rule 1: Transactional Emails

- **Email Type**: Dropdown
  - Options: Transactional, Marketing, Cold Outreach, Newsletter, Promotional, Custom
- **Conditions** (Optional):
  - Add condition: "Subject contains", "Recipient domain is", "Tag equals"
- **Route To**: Dropdown
  - Options: Postmark, Mailgun, Built-in SMTP
- **Priority**: Number (1 = highest)
- **Enabled**: Toggle switch
- **Actions**: Edit, Delete, Duplicate

**"+ Add Routing Rule" Button**: Creates new rule card.

### Email Type Definitions

**Expandable Section** showing what qualifies as each type:

**Transactional**:

- Password resets
- Email verification
- Order confirmations
- Account alerts
- System notifications

**Marketing**:

- Newsletters
- Product announcements
- Promotional campaigns
- Event invitations

**Cold Outreach**:

- Sales prospecting
- Lead generation
- Custom campaigns

### Failover Configuration

**Failover Strategy Section**:

- **Enable Failover**: Toggle switch.
- **Retry Attempts**: Number input (1-5, default: 3).
- **Retry Delay**: Seconds (10-300, default: 30).

**Failover Order** (Drag-and-drop):

1. Primary: Postmark
2. Secondary: Mailgun
3. Final: Built-in SMTP

**Help Text**: "If primary ESP fails, automatically retry with secondary after delay."

### Cost Optimization

**Smart Routing Section**:

- ☑ **Use Free Tiers First**: Route through ESPs with remaining free quota.
- ☑ **Volume-Based Routing**: Route high-volume sends through cheapest provider.
- ☐ **Time-Based Routing**: Route based on time of day (e.g., off-peak hours).

**Estimated Monthly Cost**:

```text
Current Configuration:

- Postmark: 5,000 emails × $0.00125 = $6.25
- Mailgun: 95,000 emails × $0.00058 = $55.00
- Built-in SMTP: 100,000 emails × $0 = $0.00
Total: $61.25/month
```

**Save Button**: Bottom-right, saves routing configuration.

**User Journey Context**: Set up once, adjust as email volume grows or ESP pricing changes.

**Related Documentation**:

- [ESP Routing Strategy](/docs/features/integrations/esp-integration#routing-rules)
- [Cost Optimization](/docs/features/integrations/esp-integration#cost-optimization)

**Technical Integration**:

- **Rule Engine**: Evaluates rules in priority order.
- **Caching**: Routing decisions cached for 5 minutes.
- **Monitoring**: Track routing decisions in analytics.
