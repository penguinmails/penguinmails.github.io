---
title: "Scheduled Reporting"
description: "Configuration and management of automated daily, weekly, and monthly performance reports."
last_modified_date: "2026-02-24"
level: "2"
persona: "Marketers, Business Owners"
---

# Scheduled Reporting

**Automated intelligence delivered directly to your inbox.**

---

## 1. Report Configurations

PenguinMails supports multiple report types tailored to different stakeholders.

### Available Report Types

- **Campaign Performance**: Granular metrics for specific initiatives.
- **Overall Performance**: Aggregated top-level growth metrics.
- **Deliverability Report**: Critical focus on bounces, spam, and reputation.
- **Workspace Summary**: Performance breakdown for agencies and multi-tenant setups.

### Recurrence Settings

Reports can be scheduled with the following frequencies:

- **Daily**: Best for operational monitoring (e.g., deliverability check).
- **Weekly**: Recommended for campaign optimization and team reviews.
- **Monthly**: High-level executive summaries and ROI analysis.

---

## 2. Report Templates

Reusable templates ensure consistency across different clients or workspaces.

```yaml
name: "Weekly Performance Template"
recipients: ["team@company.com"]
format: PDF
sections:
  - type: summary_metrics
    metrics: [sent, delivered, opened, clicked]
  - type: chart
    metric: delivery_rate
    title: "14-Day Delivery Trend"
  - type: recommendation_engine
    enabled: true
```

---

## 3. Delivery Options

- **Email Delivery**: Reports sent as PDF/Excel attachments or links.
- **Recipient Management**: Support for internal team members and external stakeholders.
- **Timezone Support**: Reports delivered at the optimal local time for the recipient.
