---
title: "Score Decay & Automation"
description: "Time-based decay rules and automated lifecycle triggers based on lead scores."
last_modified_date: "2026-02-24"
level: "2"
persona: "Marketers, Automation Specialists"
---

# Score Decay & Automation

**Maintaining score accuracy and triggering real-time response to high-intent behavior.**

---

## 1. Score Decay & Recency

Ensures lead scores reflect current engagement rather than historical interest.

### Time-Based Decay

Scores automatically decrease during periods of inactivity.

```yaml
decay_rules:
  engagement_decay:
    enabled: true
    rate: 5_percent
    interval: 30_days
    min_score: 0

  example:
    initial_score: 80
    after_30_days: 76  # -5%
    after_60_days: 72  # -5% again
    after_90_days: 68
```

### Recency Boosting

Multipliers applied to actions based on how recently they occurred.

```yaml
recency_multipliers:
  action_within_24h:
    multiplier: 2.0

  action_within_7d:
    multiplier: 1.5

  action_within_30d:
    multiplier: 1.0

  action_older_than_30d:
    multiplier: 0.5
```

---

## 2. Score-Based Automation

Triggering workflows and segments automatically when score thresholds are met.

### Lifecycle Stage Mapping

| Score Range | Status | Suggested Campaign |
|-------------|--------|--------------------|
| 0-25 | Cold Lead | Nurture / educational |
| 26-50 | Nurture | Feature deep dives |
| 51-75 | MQL | Case studies / webinars |
| 76-100 | SQL | Direct demo / sales outreach |

### Automation Triggers

Logic executed when specific score milestones are reached:

```text
Threshold Reached (Score 75+):
  1. Add to "Hot Leads" segment
  2. Map lifecycle stage to "SQL"
  3. Send Slack/Email notification to sales owner
  4. Trigger "Book a Demo" automated sequence
```

---

## 3. CRM Synchronization

When a lead crosses a high-intent threshold (typically SQL), the profile is synced to the sales CRM.

- **Salesforce**: Create Lead or Update Contact.
- **HubSpot**: Update Lifecycle Stage and set Lead Status.
- **Priority**: High-priority follow-up flag set in CRM.
- **Assignment**: Round-robin assignment to sales reps.
