---
title: "Level 2: Advanced Configuration"
description: "Advanced campaign features and optimization"
level: "2"
persona: "Marketing Operations"
keywords: "advanced campaigns, personalization, A/B testing, optimization"
---

# Level 2: Advanced Configuration

## Level 2: Advanced Configuration

### Multi-Step Sequences

#### Complex Sequence Example

**10-Step Lead Nurturing Campaign:**

```text

START
  â”‚
  â–¼
Email 1: Introduction (Day 0)
  â”‚
  â”œâ”€ Opened? â”€â”€YESâ”€â”€â–¶ Email 2A: Engaged Path (Day 2)
  â”‚                      â”‚
  â””â”€ NO â”€â”€â–¶ Email 2B: Re-engagement (Day 3)
                â”‚
                â–¼
            Email 3: Value Proposition (Day 5)
                â”‚
                â”œâ”€ Clicked? â”€â”€YESâ”€â”€â–¶ Email 4A: Demo Offer (Day 7)
                â”‚                       â”‚
                â””â”€ NO â”€â”€â–¶ Email 4B: Case Study (Day 8)
                            â”‚
                            â–¼
                        Email 5: Social Proof (Day 10)
                            â”‚
                            â”œâ”€ Replied? â”€â”€YESâ”€â”€â–¶ [Move to Sales]
                            â”‚
                            â””â”€ NO â”€â”€â–¶ Email 6: Final Offer (Day 14)
                                        â”‚
                                        â–¼
                                    [END or Re-engage]

```

#### Conditional Branching

**Branch Based on Engagement:**

```yaml
sequence_step:
  email_id: "intro_email"
  wait_duration: 2 days

  conditions:

    - if: email_opened
      then: send_email("engaged_path")

    - if: email_clicked
      then: send_email("hot_lead_path")

    - if: email_not_opened
      wait: 1 day
      then: send_email("re_engagement")

    - if: email_replied
      then: exit_sequence("move_to_sales")

```

**Branch Based on Contact Attributes:**

```yaml
sequence_step:
  conditions:

    - if: contact.industry == "SaaS"
      then: send_email("saas_specific_content")

    - if: contact.company_size > 100
      then: send_email("enterprise_content")

    - if: contact.lead_score > 50
      then: send_email("high_value_offer")

    - else:
      then: send_email("standard_content")

```

### Advanced Scheduling

#### Timezone-Aware Scheduling

**Send at Optimal Local Time:**

```yaml
campaign_schedule:
  send_strategy: "recipient_timezone"
  preferred_time: "09:00"
  timezone_fallback: "America/New_York"

  rules:

    - if_timezone_unknown: use_fallback

    - respect_business_hours: true

    - skip_weekends: true

    - skip_holidays: true

```

**Example:**

```text

Contact in New York (EST): Email sent at 9:00 AM EST
Contact in Los Angeles (PST): Email sent at 9:00 AM PST
Contact in London (GMT): Email sent at 9:00 AM GMT

All contacts receive email at their local 9:00 AM

```

#### Send-Time Optimization

**AI-Powered Optimal Send Times:**

```yaml
send_optimization:
  enabled: true
  strategy: "engagement_based"

  analysis:

    - historical_open_times

    - historical_click_times

    - industry_benchmarks

    - contact_behavior_patterns

  optimization_window:
    start: "06:00"
    end: "18:00"
    timezone: "recipient_local"

```

**Results:**

```text

Contact A: Historically opens at 7:30 AM â†’ Send at 7:15 AM
Contact B: Historically opens at 2:00 PM â†’ Send at 1:45 PM
Contact C: No history â†’ Send at industry benchmark (9:00 AM)

```

### Campaign Templates

#### Pre-Built Campaign Templates

**Welcome Series Template:**

```text

Template: "SaaS Welcome Series"
Duration: 14 days
Emails: 5

Day 0: Welcome + Account Setup
Day 2: Feature Overview
Day 5: Quick Win Guide
Day 9: Advanced Features
Day 14: Success Story + Upgrade Offer

Conversion Rate: 12-18% (industry average)

```

**Lead Nurturing Template:**

```text

Template: "B2B Lead Nurturing"
Duration: 30 days
Emails: 8

Week 1: Problem awareness (2 emails)
Week 2: Solution education (2 emails)
Week 3: Product positioning (2 emails)
Week 4: Conversion push (2 emails)

Conversion Rate: 8-12% (industry average)

```

#### Custom Template Creation

**Save Campaign as Template:**

```text

Campaign Actions:
  â†’ Save as Template

Template Configuration:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ Template Name: "Custom Onboarding"                  â”‚
â”‚ Category: Onboarding                                â”‚
â”‚ Tags: SaaS, B2B, Welcome                            â”‚
â”‚ Description: 7-day onboarding for new users         â”‚
â”‚                                                     â”‚
â”‚ â˜‘ Include sequence structure                        â”‚
â”‚ â˜‘ Include email templates                           â”‚
â”‚ â˜‘ Include conditional logic                         â”‚
â”‚ â˜ Include specific content (use placeholders)       â”‚
â”‚                                                     â”‚
â”‚ Sharing:                                            â”‚
â”‚ â—‹ Private (only me)                                 â”‚
â”‚ â— Team (all workspace members)                      â”‚
â”‚ â—‹ Public (template library)                         â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

```

### Audience Segmentation Integration

#### Dynamic Audience Selection

**Segment-Based Campaigns:**

```yaml
campaign_audience:
  type: "dynamic_segment"
  segment_id: "engaged_users"

  criteria:

    - lead_score: "> 30"

    - last_activity: "< 30 days"

    - email_verified: true

    - unsubscribed: false

  refresh: "daily"  # Re-evaluate segment membership

  enrollment_rules:

    - new_contacts: "auto_enroll"

    - exited_contacts: "remove_from_sequence"

```

**Example:**

```text

Day 1: 500 contacts match criteria â†’ Enrolled
Day 5: 50 new contacts match â†’ Auto-enrolled at step 1
Day 5: 20 contacts no longer match â†’ Removed from sequence

```

#### Exclusion Rules

**Prevent Over-Messaging:**

```yaml
exclusion_rules:

  - exclude_if: "in_other_campaign"

  - exclude_if: "received_email_last_24h"

  - exclude_if: "marked_as_customer"

  - exclude_if: "unsubscribed_from_category"

  priority_handling:

    - if_conflict: "pause_lower_priority"

    - resume_after: "higher_priority_complete"

```

### Team Collaboration

#### Campaign Approval Workflow

**Enterprise Approval Process:**

```text

Campaign Creation:
  â†“
Draft Review (Creator)
  â†“
Submit for Approval
  â†“
Manager Review â”€â”€REJECTâ”€â”€â–¶ Back to Creator
  â”‚
  APPROVE
  â†“
Compliance Review â”€â”€REJECTâ”€â”€â–¶ Back to Creator
  â”‚
  APPROVE
  â†“
Schedule & Launch

```

**Approval Configuration:**

```yaml
approval_workflow:
  required_approvers:

    - role: "campaign_manager"
      required: true

    - role: "compliance_officer"
      required: true
      conditions:

        - if: audience_size > 10000

        - if: contains_promotional_content

  approval_timeout: 48 hours
  timeout_action: "auto_reject"

```

#### Collaborative Editing

**Real-Time Collaboration:**

```text

Campaign Editor:
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ ðŸ‘¤ Sarah (editing Email 2)                          â”‚
â”‚ ðŸ‘¤ Mike (viewing sequence)                          â”‚
â”‚ ðŸ‘¤ Lisa (editing Email 3)                           â”‚
â”‚                                                     â”‚
â”‚ Activity Feed:                                      â”‚
â”‚ â€¢ Sarah updated subject line (2 min ago)            â”‚
â”‚ â€¢ Mike added comment on Email 1 (5 min ago)         â”‚
â”‚ â€¢ Lisa uploaded new template (10 min ago)           â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

```

---

