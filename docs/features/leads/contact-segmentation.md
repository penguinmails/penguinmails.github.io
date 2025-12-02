---
title: "Contact Segmentation"
description: "Dynamic contact segmentation with rule-based and manual list creation for targeted campaigns"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:


  - leads/leads-management


  - leads/lead-scoring


  - campaigns/campaign-management/overview


  - campaigns/personalization-system
related_tasks:


  - epic-7-leads-management
---


# Contact Segmentation

**Quick Access**: Create targeted contact segments using behavioral data, demographics, and custom criteria for precise campaign targeting.

## Overview

Contact Segmentation enables you to divide your contact database into meaningful groups based on shared characteristics, behaviors, or custom criteria. Send the right message to the right people at the right time.

### Key Capabilities

- **Dynamic Segments**: Auto-updating lists based on rules

- **Static Segments**: Manual, fixed contact lists

- **Multi-Criteria Filtering**: Combine multiple conditions

- **Behavioral Segmentation**: Based on email engagement

- **Import/Export**: Bulk segment management

- **Campaign Integration**: Direct segment-to-campaign assignment

---

## Level 1: Quick Start Guide

### Your First Segment

#### Step 1: Create Segment

```text

Contacts → Segments → Create New Segment

Segment Name: Active Subscribers
Description: Contacts who opened emails in last 30 days
Type: ○ Dynamic  ○ Static


```

#### Step 2: Define Rules (Dynamic Segment)

```text

Conditions (Match ALL):
  ☑ Last Email Opened: within last 30 days
  ☑ Subscription Status: Active
  ☑ Unsubscribed: No

Preview: 2,847 contacts match


```

#### Step 3: Save & Use

```text

[Save Segment]

✓ Segment created: "Active Subscribers"
  2,847 contacts

Quick Actions:
  [Create Campaign] [Export List] [View Contacts]


```

### Common Segment Types

#### By Engagement Level

**Highly Engaged:**

```text

Conditions:


  - Opened emails: ≥ 5 in last 30 days


  - Clicked links: ≥ 2 in last 30 days


  - Last activity: Within 7 days


```

**Inactive Contacts:**

```text

Conditions:


  - Last opened: More than 90 days ago


  - Subscription status: Active


  - Unsubscribed: No


```

**Never Engaged:**

```text

Conditions:


  - Total opens: 0


  - Total clicks: 0


  - Date added: More than 30 days ago


```

#### By Demographics

**Location-Based:**

```text

Conditions:


  - Country: United States


  - State: California
  OR


  - City: San Francisco


```

**Company Size:**

```text

Conditions:


  - Custom Field: company_size


  - Value: 51-200 employees


```

**Industry:**

```text

Conditions:


  - Custom Field: industry


  - Value: SaaS, Technology, Software


```

#### By Lifecycle Stage

**New Leads (Last 7 Days):**

```text

Conditions:


  - Date added: Within last 7 days


  - Emails sent: 0


```

**Trial Users:**

```text

Conditions:


  - Custom Field: account_type = "trial"


  - Custom Field: trial_end_date: Within next 7 days


```

**Customers:**

```text

Conditions:


  - Custom Field: account_type = "paid"


  - Custom Field: last_purchase_date: Within last 90 days


```

### Static Segments

**When to Use:**

- One-time campaigns (event invitations, announcements)

- Manual contact selection

- Imported lists from external sources

- A/B test control groups

**Creating Static Segment:**

```text


1. Select contacts manually from list


2. Or import CSV file


3. Name segment


4. Save as static segment (won't auto-update)


```

---

## Level 2: Advanced Segmentation

### Complex Rule Logic

#### AND/OR Combinations

**Engaged OR High-Value:**

```text

Match ANY of these groups:

Group 1 (Engaged):


  - Opens: ≥ 3 in last 30 days


  - Clicks: ≥ 1 in last 30 days

Group 2 (High-Value):


  - Custom Field: lead_score ≥ 75


  - Custom Field: customer_ltv ≥ $1,000


```

**Advanced Multi-Condition:**

```text

Match ALL:
  Group 1 (Location):


    - Country: United States OR Canada


    - Timezone: PST, MST, CST, EST

  Group 2 (Engagement):


    - Last opened: Within 60 days


    - Total clicks: ≥ 5

  Group 3 (Not):


    - Tag: does NOT include "unqualified"


    - Custom Field: bounced ≠ true


```

### Behavioral Segmentation

#### Email Engagement Patterns

**Click-But-Never-Convert:**

```text

Conditions:


  - Total clicks: ≥ 10


  - Total conversions: 0


  - Last clicked: Within 30 days


```

**Opens Mobile vs Desktop:**

```text

Conditions:


  - Last opened device: Mobile


  - Open count (mobile): ≥ 5


  - Open count (desktop): 0


```

**Time-Based Engagement:**

```text

Conditions:


  - Most common open time: 9am-12pm


  - Preferred day: Monday-Friday


```

#### Campaign-Specific Behavior

**Clicked Specific Link:**

```text

Conditions:


  - Campaign: "Product Launch Q4"


  - Clicked URL: contains "pricing"


  - Did NOT click URL: contains "demo"


```

**Opened But Didn't Click:**

```text

Conditions:


  - Campaign: "Feature Announcement"


  - Opened: Yes


  - Clicked any link: No


  - Days since sent: ≥ 3


```

### Lead Score Integration

**Score-Based Segments:**

```text

Hot Leads (Score 80-100):


  - Lead Score: 80-100


  - Last activity: Within 14 days


  - Opened last email: Yes

Warm Leads (Score 50-79):


  - Lead Score: 50-79


  - Last activity: Within 30 days

Cold Leads (Score 0-49):


  - Lead Score: 0-49
  OR


  - Last activity: More than 60 days ago


```

### Custom Field Segmentation

**Multi-Select Custom Fields:**

```text

Conditions:


  - Custom Field: interests


  - Contains ANY: "email marketing", "automation", "analytics"


```

**Date-Based Custom Fields:**

```text

Trial Expiring Soon:


  - Custom Field: trial_end_date


  - Is between: today and 7 days from now

Anniversary Outreach:


  - Custom Field: signup_date


  - Anniversary: this month


```

**Numeric Range Custom Fields:**

```text

High-Value Cohort:


  - Custom Field: total_revenue


  - Is greater than: $5,000



  - Custom Field: lifetime_opens


  - Is greater than: 50


```

### Segment Exclusions

**Exclude Other Segments:**

```text

Include:


  - Segment: "All Active Subscribers"

Exclude:


  - Segment: "Recent Purchasers"


  - Segment: "Unengaged (90+ days)"


```

**Suppress Based on Recent Activity:**

```text

Include:


  - All contacts in "Product Users"

Exclude:


  - Received campaign: Within last 7 days


  - Campaign name: contains "Product"


```

### Segment Performance Tracking

**View Segment Analytics:**

```text

Segment: "Active Subscribers" (2,847 contacts)

Performance (Last 30 Days):
  Average Open Rate: 32%
  Average Click Rate: 8%
  Unsubscribe Rate: 0.2%
  Revenue Generated: $12,450

Trend:


  - Segment size: +12% month-over-month


  - Engagement: +5% vs all contacts


```

### Segment A/B Testing

**Test Segment Criteria:**

```text

Hypothesis: "High engagement = Lead Score > 60"

Test Setup:
  Segment A: Lead Score > 60 (500 contacts)
  Segment B: Lead Score 40-60 (500 contacts)

  Send same campaign to both
  Compare: Open rate, Click rate, Conversion rate

Result: Segment A 2.3x higher conversion
Action: Adjust scoring model


```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Segments table
CREATE TABLE segments (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),

  name VARCHAR(255) NOT NULL,
  description TEXT,

  -- Segment type
  segment_type VARCHAR(50), -- dynamic, static

  -- Rules (for dynamic segments)
  rules JSONB, -- Filtering criteria

  -- Metadata
  contact_count INTEGER DEFAULT 0,
  last_recalculated_at TIMESTAMP,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,

  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_segments_tenant ON segments(tenant_id);
CREATE INDEX idx_segments_workspace ON segments(workspace_id);
CREATE INDEX idx_segments_type ON segments(segment_type);

-- Segment membership (for static segments or cached dynamic)
CREATE TABLE segment_contacts (
  id UUID PRIMARY KEY,
  segment_id UUID NOT NULL REFERENCES segments(id),
  contact_id UUID NOT NULL REFERENCES contacts(id),

  -- For dynamic segments, track when added
  added_at TIMESTAMP DEFAULT NOW(),
  added_via VARCHAR(50), -- rule_match, manual, import

  UNIQUE(segment_id, contact_id)
);

CREATE INDEX idx_segment_contacts_segment ON segment_contacts(segment_id);
CREATE INDEX idx_segment_contacts_contact ON segment_contacts(contact_id);

-- Segment performance tracking
CREATE TABLE segment_analytics (
  id UUID PRIMARY KEY,
  segment_id UUID NOT NULL REFERENCES segments(id),

  -- Timeframe
  date DATE NOT NULL,

  -- Metrics
  contact_count INTEGER,
  emails_sent INTEGER DEFAULT 0,
  emails_delivered INTEGER DEFAULT 0,
  opens INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  conversions INTEGER DEFAULT 0,
  revenue DECIMAL(10,2) DEFAULT 0,

  -- Rates
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),
  conversion_rate DECIMAL(5,2),

  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(segment_id, date)
);

CREATE INDEX idx_segment_analytics_segment_date ON segment_analytics(segment_id, date);


```

### Segment Rules Engine

```typescript
interface SegmentRule {
  field: string; // contact.email, contact.created_at, customField.industry, etc.
  operator: 'equals' | 'not_equals' | 'contains' | 'greater_than' | 'less_than' | 'between' | 'in' | 'not_in';
  value: any;
  dataType: 'string' | 'number' | 'date' | 'boolean' | 'array';
}

interface SegmentConditionGroup {
  match: 'all' | 'any'; // AND or OR
  conditions: (SegmentRule | SegmentConditionGroup)[];
}

interface SegmentDefinition {
  match: 'all' | 'any';
  groups: SegmentConditionGroup[];
  exclusions?: SegmentConditionGroup[];
}

class SegmentEngine {
  async evaluateSegment(segmentId: string): Promise<Contact[]> {
    const segment = await db.segments.findById(segmentId);

    if (segment.segmentType === 'static') {
      return this.getStaticContacts(segmentId);
    }

    // Dynamic segment - evaluate rules
    const query = this.buildQuery(segment.rules);
    const contacts = await db.contacts.findAll(query);

    // Update cached membership
    await this.updateSegmentMembership(segmentId, contacts);

    return contacts;
  }

  private buildQuery(rules: SegmentDefinition): any {
    const conditions = this.buildConditions(rules.groups, rules.match);

    let query: any = {
      where: conditions,
    };

    // Apply exclusions
    if (rules.exclusions) {
      const exclusionConditions = this.buildConditions(
        rules.exclusions.groups,
        rules.exclusions.match
      );
      query.where = {
        [Op.and]: [
          conditions,
          { [Op.not]: exclusionConditions },
        ],
      };
    }

    return query;
  }

  private buildConditions(
    groups: SegmentConditionGroup[],
    match: 'all' | 'any'
  ): any {
    const operator = match === 'all' ? Op.and : Op.or;

    const groupConditions = groups.map(group => {
      return this.buildGroupConditions(group);
    });

    return { [operator]: groupConditions };
  }

  private buildGroupConditions(group: SegmentConditionGroup): any {
    const operator = group.match === 'all' ? Op.and : Op.or;

    const conditions = group.conditions.map(condition => {
      if ('field' in condition) {
        return this.buildRuleCondition(condition as SegmentRule);
      } else {
        return this.buildGroupConditions(condition as SegmentConditionGroup);
      }
    });

    return { [operator]: conditions };
  }

  private buildRuleCondition(rule: SegmentRule): any {
    const { field, operator, value } = rule;

    // Parse field path (e.g., "contact.email" or "customField.industry")
    const [entity, property] = field.split('.');

    let condition: any = {};

    if (entity === 'customField') {
      // Query JSONB custom fields
      condition = {
        [`customFields.${property}`]: this.getOperatorCondition(operator, value),
      };
    } else {
      // Standard field
      condition = {
        [property]: this.getOperatorCondition(operator, value),
      };
    }

    return condition;
  }

  private getOperatorCondition(operator: string, value: any): any {
    switch (operator) {
      case 'equals':
        return value;
      case 'not_equals':
        return { [Op.ne]: value };
      case 'contains':
        return { [Op.iLike]: `%${value}%` };
      case 'greater_than':
        return { [Op.gt]: value };
      case 'less_than':
        return { [Op.lt]: value };
      case 'between':
        return { [Op.between]: value }; // value = [min, max]
      case 'in':
        return { [Op.in]: value }; // value = array
      case 'not_in':
        return { [Op.notIn]: value };
      default:
        throw new Error(`Unknown operator: ${operator}`);
    }
  }

  private async updateSegmentMembership(
    segmentId: string,
    contacts: Contact[]
  ): Promise<void> {
    // Remove old memberships
    await db.segmentContacts.destroy({
      where: { segmentId },
    });

    // Add new memberships
    await db.segmentContacts.bulkCreate(
      contacts.map(contact => ({
        segmentId,
        contactId: contact.id,
        addedVia: 'rule_match',
      }))
    );

    // Update contact count
    await db.segments.update(segmentId, {
      contactCount: contacts.length,
      lastRecalculatedAt: new Date(),
    });
  }
}


```

### Background Jobs

```typescript
// Recalculate dynamic segments
cron.schedule('*/30 * * * *', async () => {  // Every 30 minutes
  const dynamicSegments = await db.segments.findAll({
    where: {
      segmentType: 'dynamic',
      isActive: true,
    },
  });

  for (const segment of dynamicSegments) {
    await segmentQueue.add('recalculate-segment', {
      segmentId: segment.id,
    });
  }
});

// Queue worker
segmentQueue.process('recalculate-segment', async (job) => {
  const { segmentId } = job.data;

  const engine = new SegmentEngine();
  await engine.evaluateSegment(segmentId);
});

// Calculate segment analytics daily
cron.schedule('0 2 * * *', async () => {  // 2 AM daily
  const segments = await db.segments.findAll({ where: { isActive: true } });

  for (const segment of segments) {
    await calculateSegmentAnalytics(segment.id);
  }
});


```

### API Endpoints

```typescript
// Create segment
app.post('/api/segments', authenticate, async (req, res) => {
  const { name, description, segmentType, rules, contactIds } = req.body;

  const segment = await db.segments.create({
    tenantId: req.user.tenantId,
    workspaceId: req.body.workspaceId,
    name,
    description,
    segmentType,
    rules: segmentType === 'dynamic' ? rules : null,
    createdBy: req.user.id,
  });

  // For static segments, add contacts
  if (segmentType === 'static' && contactIds) {
    await db.segmentContacts.bulkCreate(
      contactIds.map(contactId => ({
        segmentId: segment.id,
        contactId,
        addedVia: 'manual',
      }))
    );

    await db.segments.update(segment.id, {
      contactCount: contactIds.length,
    });
  }

  // For dynamic segments, trigger calculation
  if (segmentType === 'dynamic') {
    await segmentQueue.add('recalculate-segment', {
      segmentId: segment.id,
    });
  }

  return res.json(segment);
});

// Get segment contacts
app.get('/api/segments/:id/contacts', authenticate, async (req, res) => {
  const segment = await db.segments.findById(req.params.id);

  if (segment.tenantId !== req.user.tenantId) {
    return res.status(403).json({ error: 'Forbidden' });
  }

  const contacts = await db.contacts.findAll({
    include: [{
      model: db.segmentContacts,
      where: { segmentId: req.params.id },
    }],
    offset: req.query.offset || 0,
    limit: req.query.limit || 50,
  });

  return res.json({
    segment,
    contacts,
    total: segment.contactCount,
  });
});


```

---

## Related Documentation

- **[Leads Management](/docs/features/leads/leads-management)** - Contact database and management

- **[Lead Scoring](/docs/features/leads/lead-scoring)** - Behavioral scoring system

- **[Import/Export](/docs/features/leads/import-export)** - Bulk contact operations

- **[Campaign Management](/docs/features/campaigns/campaign-management/overview)** - Use segments in campaigns

- **[Personalization System](/docs/features/campaigns/personalization-system)** - Segment-specific content

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q1 2026
**Owner:** Leads Team

