---
title: "Enhanced Analytics KPIs & Metrics"
description: "Detailed specifications for deliverability scores, health indices, and ROI tracking formulas."
last_modified_date: "2026-02-24"
level: "2"
---

# Enhanced Analytics KPIs & Metrics

## Enhanced Metrics

### Advanced KPIs

#### Deliverability Score (0-100)

**Components:**

- infrastructure: 30  # SPF/DKIM/DMARC
- reputation: 25  # Sender reputation
- engagement: 25  # Open/click rates
- complaints: 20  # Bounce/spam rates

**Calculation Logic:**

- **infrastructure_score**: spf_pass (10), dkim_pass (10), dmarc_pass (10)
- **reputation_score**: domain_reputation (15), ip_reputation (10)
- **engagement_score**: open_rate_percentile (15), click_rate_percentile (10)
- **complaints_score**: bounce_penalty (-10 per percent), spam_penalty (-50 per percent)

#### Engagement Velocity

**Description**: Rate of engagement change over time.  
**Formula**: `(current_period_engagement - previous_period_engagement) / previous_period_engagement * 100`

#### Mailbox Health Index

**Description**: Predictive health scoring per mailbox.  
**Factors**:

- sending_volume_consistency
- bounce_rate_trend
- spam_complaint_trend
- engagement_trend
- blacklist_status
- authentication_status

**Score Ranges:**

- 90-100: "Excellent - No action needed"
- 75-89: "Good - Monitor closely"
- 50-74: "Fair - Improvement needed"
- 0-49: "Poor - Immediate action required"

#### Campaign Performance Index

**Description**: Multi-factor campaign success metric.  
**Components**:

- deliverability: 30%
- engagement: 40%
- conversion: 30%

---

## ROI Tracking & Attribution

### ROI Metrics

- **revenue_per_email**: total_revenue / emails_sent
- **revenue_per_recipient**: total_revenue / unique_recipients
- **cost_per_acquisition**: campaign_cost / conversions
- **return_on_investment**: (revenue - cost) / cost * 100

### Attribution Models

- **first_touch**: First campaign contact engaged with.
- **last_touch**: Last campaign before conversion.
- **linear**: Equal credit to all touchpoints.
- **time_decay**: More credit to recent touchpoints.
- **position_based**: 40% first, 40% last, 20% middle.

---

## Advanced Segmentation

### Behavioral Segments

- **Highly Engaged**: open_rate >= 50%, click_rate >= 10%, last_activity within 7 days.
- **At Risk**: open_rate < 10%, last_activity > 30 days, previous_open_rate >= 30%.
- **Champions**: lead_score >= 90, conversion_count >= 3, avg_order_value >= $500.

### Predictive Segments

- **Likely to Convert**: model: conversion_prediction, threshold: 0.75.
- **Churn Risk**: model: churn_prediction, threshold: 0.60.
- **High Lifetime Value**: model: ltv_prediction, threshold: $1000.
