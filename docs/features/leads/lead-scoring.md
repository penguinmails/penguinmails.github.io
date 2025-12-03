---
title: "Lead Scoring"
description: "Behavioral and demographic lead scoring to prioritize high-value contacts and personalize outreach"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:

  - leads/leads-management

  - leads/contact-segmentation

  - campaigns/personalization-system

  - analytics/core-analytics/overview
related_tasks:

  - epic-7-leads-management
---

# Lead Scoring

**Quick Access**: Automatically score leads based on engagement behavior, demographics, and custom criteria to identify your hottest prospects.

## Overview

Lead Scoring assigns numeric values to contacts based on their actions, characteristics, and engagement patterns. Focus your efforts on high-value leads and personalize outreach based on interest level.

### Key Benefits

- **Prioritization**: Focus on highest-potential leads

- **Automation**: Auto-score based on behavior and attributes

- **Segmentation**: Create score-based segments

- **Sales Alignment**: Pass qualified leads to sales at threshold

- **Personalization**: Tailor messaging by score range

---

## Level 1: Quick Start Guide

### Understanding Lead Scores

**Score Range**: 0-100

- **0-25**: Cold/Unengaged

- **26-50**: Warming Up

- **51-75**: Interested/Engaged

- **76-100**: Hot/Ready to Buy

**Recalculation**: Real-time as contacts take actions

### Your First Scoring Model

#### Default Scoring Rules

```text

Email Engagement:
  âœ“ Email Opened: +5 points
  âœ“ Link Clicked: +10 points
  âœ“ Replied to Email: +15 points

Negative Actions:
  âœ— Email Bounced: -10 points
  âœ— Marked as Spam: -50 points
  âœ— Unsubscribed: -100 points (auto-set to 0)

Demographics:
  âœ“ Job Title (Decision Maker): +20 points
  âœ“ Company Size (51-200): +10 points
  âœ“ Company Size (200+): +15 points

Time Decay:

  - Score decreases 5% every 30 days of inactivity

```

### View Lead Scores

```text

Contacts â†’ View All

Sort by: Lead Score (High to Low)

Contact                Score  Last Activity
â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
Sarah Johnson          92     2 hours ago
Michael Chen           87     1 day ago
Emily Rodriguez        76     3 days ago
David Kim              68     1 week ago
...

```

### Use Scores in Campaigns

#### Score-Based Segments

```text

Hot Leads (Score 76-100):
  Campaign: "Book a Demo" (Aggressive CTA)

Warm Leads (Score 51-75):
  Campaign: "Feature Deep Dive" (Educational)

Cold Leads (Score 0-50):
  Campaign: "Getting Started Guide" (Nurture)

```

---

## Level 2: Advanced Scoring Configuration

### Custom Scoring Rules

#### Behavioral Scoring

##### Engagement Actions

```yaml
email_actions:
  opened_email:
    points: 5
    decay: true  # Points decay over time

  clicked_link:
    points: 10
    multiplier: 1.5  # 15 points if clicked multiple times

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
    threshold: 75%  # Must watch 75% to count

  replied_to_email:
    points: 20

  forwarded_email:
    points: 12

```

##### Website Activity (if integrated)

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

##### Negative Actions

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

#### Demographic Scoring

##### Firmographic Data

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

##### Role-Based Scoring

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

##### Geographic Scoring

```yaml
location:
  tier_1_markets:  # US, UK, Canada, Australia
    points: 10

  tier_2_markets:  # Western Europe
    points: 5

  tier_3_markets:  # Rest of world
    points: 0

```

### Score Decay & Recency

#### Time-Based Decay

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

#### Recency Boosting

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

### Multi-Dimensional Scoring

#### Separate Scores for Different Aspects

```yaml
scoring_dimensions:
  engagement_score:  # 0-40 points
    email_opens: 5
    email_clicks: 10
    email_replies: 15

  fit_score:  # 0-40 points
    company_size: 15
    industry: 15
    job_title: 10

  intent_score:  # 0-20 points
    pricing_page_visit: 10
    demo_request: 20
    trial_started: 20

  composite_score:  # Total 0-100
    formula: engagement + fit + intent

```

### Score-Based Automation

#### Auto-Segmentation

```text

When lead score reaches 75:
  â†’ Add to "Hot Leads" segment
  â†’ Trigger "Sales Qualified Lead" workflow
  â†’ Notify sales team
  â†’ Send "Book a Demo" campaign

```

#### Lead Lifecycle Stages

```text

Score 0-25:    Status = "Cold Lead"
Score 26-50:   Status = "Nurture"
Score 51-75:   Status = "Marketing Qualified Lead (MQL)"
Score 76-100:  Status = "Sales Qualified Lead (SQL)"

```

#### CRM Sync

```text

When lead score >= 75:
  â†’ Create lead in Salesforce
  â†’ Assign to sales rep (round-robin)
  â†’ Set priority = "High"
  â†’ Add to sales follow-up queue

```

### Score Analytics

**Score Distribution:**

```text

Lead Score Distribution:

0-25:  â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 45% (2,250 contacts)
26-50: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 28% (1,400 contacts)
51-75: â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ 18% (900 contacts)
76-100: â–ˆâ–ˆâ–ˆ 9% (450 contacts)

Average Score: 38
Median Score: 32

```

**Score Trends:**

```text

Score Movement (Last 30 Days):

Increased Score: 1,200 contacts (+15%)
Decreased Score: 800 contacts (-10%)
No Change: 3,000 contacts

Top Scoring Actions:

  1. Demo Requested: +60 pts (120 actions)

  2. Pricing Page Click: +25 pts (450 actions)

  3. Email Reply: +20 pts (230 actions)

```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Lead scoring configuration
CREATE TABLE lead_scoring_models (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  name VARCHAR(255) NOT NULL,
  description TEXT,

  -- Scoring rules (JSON configuration)
  scoring_rules JSONB NOT NULL,

  -- Decay settings
  decay_enabled BOOLEAN DEFAULT true,
  decay_rate DECIMAL(5,2) DEFAULT 5.0,  -- Percentage
  decay_interval_days INTEGER DEFAULT 30,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Contact scores
CREATE TABLE contact_scores (
  id UUID PRIMARY KEY,
  contact_id UUID NOT NULL REFERENCES contacts(id),
  scoring_model_id UUID REFERENCES lead_scoring_models(id),

  -- Scores
  total_score INTEGER DEFAULT 0,
  engagement_score INTEGER DEFAULT 0,
  fit_score INTEGER DEFAULT 0,
  intent_score INTEGER DEFAULT 0,

  -- Metadata
  last_calculated_at TIMESTAMP DEFAULT NOW(),
  last_activity_at TIMESTAMP,
  previous_score INTEGER DEFAULT 0,  -- For tracking changes

  UNIQUE(contact_id, scoring_model_id)
);

CREATE INDEX idx_contact_scores_score ON contact_scores(total_score DESC);
CREATE INDEX idx_contact_scores_contact ON contact_scores(contact_id);

-- Score history (for analytics)
CREATE TABLE score_events (
  id UUID PRIMARY KEY,
  contact_id UUID NOT NULL REFERENCES contacts(id),

  -- Event details
  event_type VARCHAR(100),  -- email_opened, clicked_link, etc.
  event_data JSONB,

  -- Score change
  points_added INTEGER,
  score_before INTEGER,
  score_after INTEGER,

  -- Timestamp
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_score_events_contact ON score_events(contact_id, created_at);
CREATE INDEX idx_score_events_type ON score_events(event_type);

```

### Scoring Engine

```typescript
interface ScoringRule {
  action: string;
  points: number;
  conditions?: Record<string, any>;
  multiplier?: number;
  decays?: boolean;
}

interface ScoringModel {
  id: string;
  name: string;
  rules: ScoringRule[];
  decayEnabled: boolean;
  decayRate: number;
  decayIntervalDays: number;
}

class LeadScoringEngine {
  async scoreAction(
    contactId: string,
    action: string,
    metadata: Record<string, any> = {}
  ): Promise<number> {
    const contact = await db.contacts.findById(contactId);
    const model = await this.getScoringModel(contact.tenantId);
    const currentScore = await this.getCurrentScore(contactId);

    // Find matching rule
    const rule = model.rules.find(r => r.action === action);

    if (!rule) {
      return currentScore.totalScore;
    }

    // Calculate points
    let points = rule.points;

    // Apply conditions
    if (rule.conditions) {
      const meetsConditions = this.evaluateConditions(rule.conditions, metadata);
      if (!meetsConditions) {
        return currentScore.totalScore;
      }
    }

    // Apply multiplier for repeated actions
    if (rule.multiplier) {
      const recentActions = await this.countRecentActions(contactId, action, 30);
      if (recentActions > 1) {
        points *= rule.multiplier;
      }
    }

    // Apply recency boost
    points = this.applyRecencyBoost(points, new Date());

    // Calculate new score
    const newScore = Math.max(0, Math.min(100, currentScore.totalScore + points));

    // Update score
    await this.updateScore(contactId, newScore, action, points);

    // Log event
    await db.scoreEvents.create({
      contactId,
      eventType: action,
      eventData: metadata,
      pointsAdded: points,
      scoreBefore: currentScore.totalScore,
      scoreAfter: newScore,
    });

    // Check for automation triggers
    await this.checkAutomationTriggers(contactId, currentScore.totalScore, newScore);

    return newScore;
  }

  private applyRecencyBoost(basePoints: number, actionDate: Date): number {
    const hoursSinceAction = differenceInHours(new Date(), actionDate);

    if (hoursSinceAction < 24) {
      return basePoints * 2.0;
    } else if (hoursSinceAction < 168) {  // 7 days
      return basePoints * 1.5;
    } else if (hoursSinceAction < 720) {  // 30 days
      return basePoints * 1.0;
    } else {
      return basePoints * 0.5;
    }
  }

  async applyDecay(contactId: string): Promise<void> {
    const contact = await db.contacts.findById(contactId);
    const model = await this.getScoringModel(contact.tenantId);

    if (!model.decayEnabled) {
      return;
    }

    const currentScore = await this.getCurrentScore(contactId);
    const daysSinceLastActivity = differenceInDays(
      new Date(),
      currentScore.lastActivityAt
    );

    if (daysSinceLastActivity < model.decayIntervalDays) {
      return;
    }

    // Calculate number of decay periods
    const decayPeriods = Math.floor(daysSinceLastActivity / model.decayIntervalDays);

    // Apply exponential decay
    let newScore = currentScore.totalScore;
    for (let i = 0; i < decayPeriods; i++) {
      newScore = newScore * (1 - model.decayRate / 100);
    }

    newScore = Math.max(0, Math.floor(newScore));

    if (newScore !== currentScore.totalScore) {
      await this.updateScore(
        contactId,
        newScore,
        'score_decay',
        newScore - currentScore.totalScore
      );
    }
  }

  private async checkAutomationTriggers(
    contactId: string,
    oldScore: number,
    newScore: number
  ): Promise<void> {
    // Check if score crossed threshold
    const thresholds = [25, 50, 75];

    for (const threshold of thresholds) {
      if (oldScore < threshold && newScore >= threshold) {
        await this.triggerScoreAutomation(contactId, threshold);
      }
    }
  }

  private async triggerScoreAutomation(
    contactId: string,
    threshold: number
  ): Promise<void> {
    switch (threshold) {
      case 75:
        // Sales Qualified Lead
        await this.markAsSQLead(contactId);
        await this.notifySalesTeam(contactId);
        await this.addToSegment(contactId, 'hot-leads');
        break;

      case 50:
        // Marketing Qualified Lead
        await this.markAsMQLead(contactId);
        await this.addToSegment(contactId, 'warm-leads');
        break;

      case 25:
        // Warming up
        await this.addToSegment(contactId, 'nurture-leads');
        break;
    }
  }
}

```

### Background Jobs

```typescript
// Apply decay to all contacts daily
cron.schedule('0 3 * * *', async () => {  // 3 AM daily
  const contacts = await db.contacts.findAll({
    where: {
      isActive: true,
    },
  });

  const scoringEngine = new LeadScoringEngine();

  for (const contact of contacts) {
    await scoringQueue.add('apply-decay', {
      contactId: contact.id,
    });
  }
});

// Queue worker
scoringQueue.process('apply-decay', async (job) => {
  const { contactId } = job.data;
  const engine = new LeadScoringEngine();
  await engine.applyDecay(contactId);
});

// Recalculate scores for contacts with new custom field data
async function recalculateScoresForContact(contactId: string): Promise<void> {
  const engine = new LeadScoringEngine();

  // Recalculate fit score based on demographics
  const contact = await db.contacts.findById(contactId);
  const fitScore = await engine.calculateFitScore(contact);

  await db.contactScores.update(
    { where: { contactId } },
    { fitScore }
  );
}

```

### Event Listeners

```typescript
// Listen for email events and update scores
eventEmitter.on('email.opened', async (event) => {
  const engine = new LeadScoringEngine();
  await engine.scoreAction(event.contactId, 'email_opened', {
    emailId: event.emailId,
    campaignId: event.campaignId,
  });
});

eventEmitter.on('email.clicked', async (event) => {
  const engine = new LeadScoringEngine();

  // Check if clicked URL is high-intent (pricing, demo)
  const isHighIntent = event.url.includes('/pricing') ||
                       event.url.includes('/demo');

  const action = isHighIntent ? 'clicked_high_intent_link' : 'clicked_link';

  await engine.scoreAction(event.contactId, action, {
    url: event.url,
    emailId: event.emailId,
  });
});

eventEmitter.on('contact.updated', async (event) => {
  // Recalculate fit score when demographics change
  await recalculateScoresForContact(event.contactId);
});

```

---

## Related Documentation

- **[Leads Management](/docs/features/leads/leads-management)** - Contact database

- **[Contact Segmentation](/docs/features/leads/contact-segmentation)** - Score-based segments

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Score-based targeting

- **[Analytics](/docs/features/analytics/core-analytics/overview)** - Score analytics

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q1 2026
**Owner:** Leads Team
