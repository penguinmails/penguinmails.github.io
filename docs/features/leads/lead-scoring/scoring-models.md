---
title: "Scoring Models & Rules"
description: "Detailed behavioral, demographic, and negative scoring configurations for PenguinMails."
last_modified_date: "2026-02-24"
level: "2"
persona: "Marketers, Business Owners"
---

# Lead Scoring Models & Rules

**Behavioral and demographic logic to prioritize high-value contacts.**

---

## 1. Behavioral Scoring

Assigns points based on engagement actions and intent indicators.

### Email Engagement Actions

```yaml
email_actions:
  opened_email:
    points: 5
    decay: true

  clicked_link:
    points: 10
    multiplier: 1.5

  clicked_pricing_page:
    points: 25
    description: "High intent action"

  downloaded_resource:
    points: 15
    specific_resources:
      whitepaper: 20
      case_study: 15
      ebook: 10

  watched_demo_video:
    points: 30
    threshold: 75%

  replied_to_email:
    points: 20

  forwarded_email:
    points: 12
```

### Website Activity

```yaml
website_actions:
  visited_pricing_page:
    points: 20

  visited_features_page:
    points: 10

  started_trial:
    points: 50

  requested_demo:
    points: 60

  added_to_cart:
    points: 40

  time_on_site:
    gt_5_minutes: 5
    gt_15_minutes: 10
```

---

## 2. Demographic Scoring

Scores contacts based on firmographic and role-based data.

### Firmographic Attributes

```yaml
company_attributes:
  company_size:
    1-10: 0
    11-50: 5
    51-200: 10
    201-1000: 15
    1001+: 20

  industry:
    saas: 20
    technology: 15
    ecommerce: 15
    healthcare: 10
    finance: 10
    other: 0

  revenue:
    lt_1m: 0
    1m_10m: 10
    10m_50m: 15
    50m_plus: 20
```

### Role-Based Scoring

```yaml
job_title_keywords:
  decision_makers:
    ceo: 25
    cto: 25
    vp: 20
    director: 15
    head_of: 15

  influencers:
    manager: 10
    lead: 8
    senior: 8

  end_users:
    specialist: 3
    coordinator: 3
    analyst: 5
```

---

## 3. Negative Scoring

Actions that decrease a lead's score or indicate loss of interest.

```yaml
negative_actions:
  unsubscribed:
    points: -100
    set_score_to: 0

  marked_spam:
    points: -50

  email_bounced_hard:
    points: -25
    set_score_to: 0

  email_bounced_soft:
    points: -5

  inactive_90_days:
    points: -30

  inactive_180_days:
    points: -50
```
