---
title: "Campaign Management"
description: "Create, schedule, and optimize multi-step email campaigns with advanced sequencing, A/B testing, and personalization"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "Critical"
related_features:
  - campaigns/ab-testing
  - campaigns/personalization-system
  - templates/template-management
  - leads/contact-segmentation
  - analytics/core-analytics/overview
related_tasks:
  - epic-6-core-email-pipeline
  - epic-7-leads-management
---

# Campaign Management

**Quick Access**: Create, schedule, and optimize sophisticated multi-step email campaigns with advanced sequencing, A/B testing, personalization, and comprehensive analytics.

## Overview

Campaign Management is the core revenue-generating feature of PenguinMails, enabling sophisticated email marketing through multi-step sequences, conditional logic, A/B testing, and personalization at scale. Create campaigns in minutes, not hours, with intuitive drag-and-drop builders and pre-built templates.

### Key Capabilities

- **Multi-Step Sequences**: Create up to 20-step email sequences with time delays and conditional branching
- **Campaign Types**: One-time broadcasts, drip campaigns, triggered campaigns, and A/B tests
- **Visual Builder**: Drag-and-drop campaign builder with real-time preview
- **Template Integration**: Use pre-built templates or create custom designs
- **Advanced Scheduling**: Timezone-aware scheduling with send-time optimization
- **Comprehensive Analytics**: Track performance at campaign and step level

---

## Level 1: Quick Start Guide

### Your First Campaign

#### Step 1: Create a New Campaign

```
Dashboard → Campaigns → Create New Campaign

Campaign Setup:
┌─────────────────────────────────────────────────────┐
│ Campaign Name: "Welcome Series"                     │
│ Campaign Type: ☑ Drip Campaign                      │
│ Target Audience: Select segment (500 contacts)      │
│ From Address: sales@yourcompany.com                 │
└─────────────────────────────────────────────────────┘
```

#### Step 2: Build Your Sequence

**Simple 3-Email Welcome Sequence:**

```
Email 1: Welcome Email (Send immediately)
  ↓ Wait 2 days
Email 2: Product Overview (Send 2 days after signup)
  ↓ Wait 3 days
Email 3: Special Offer (Send 5 days after signup)
```

**Visual Builder:**

```
┌──────────────────────────────────────────────────┐
│ Sequence Builder                                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  [START]                                         │
│     │                                            │
│     ▼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 1: Welcome    │                        │
│  │ Subject: Welcome!   │                        │
│  │ Template: Welcome   │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     │ ⏱ Wait 2 days                             │
│     ▼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 2: Overview   │                        │
│  │ Subject: Features   │                        │
│  │ Template: Product   │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     │ ⏱ Wait 3 days                             │
│     ▼                                            │
│  ┌─────────────────────┐                        │
│  │ Email 3: Offer      │                        │
│  │ Subject: 20% Off    │                        │
│  │ Template: Promo     │                        │
│  └─────────────────────┘                        │
│     │                                            │
│     ▼                                            │
│  [END]                                           │
│                                                  │
└──────────────────────────────────────────────────┘
```

#### Step 3: Configure Email Content

**Email 1 Setup:**

```
Subject Line: Welcome to {{company}}!
Preview Text: Thanks for signing up, {{firstName}}

Template: Select from library or create new
  - Welcome Email Template
  - Getting Started Template
  - Custom Template

Personalization:
  ☑ Use contact first name
  ☑ Include company name
  ☑ Add custom fields
```

#### Step 4: Review and Launch

**Pre-Launch Checklist:**

```
Campaign Review:
✓ Audience: 500 contacts selected
✓ Sequence: 3 emails configured
✓ Templates: All emails have content
✓ Personalization: Variables validated
✓ Schedule: Ready to launch
✓ From Address: Verified and warmed

[Preview Campaign] [Send Test Email] [Launch Campaign]
```

#### Step 5: Monitor Performance

**Campaign Dashboard:**

```
Campaign: Welcome Series
Status: Active | Started: Nov 25, 2025

Overall Performance:
┌─────────────────────────────────────────────────────┐
│ Sent: 500 | Delivered: 485 (97%)                    │
│ Opens: 242 (50%) | Clicks: 97 (20%)                 │
│ Replies: 23 (4.7%) | Unsubscribes: 2 (0.4%)         │
└─────────────────────────────────────────────────────┘

Step Performance:
Email 1: 500 sent | 50% open | 20% click
Email 2: 350 sent | 45% open | 18% click
Email 3: 200 sent | 40% open | 15% click
```

### Campaign Types

#### One-Time Broadcast

Send a single email to your entire list or segment:

```
Use Cases:
- Product announcements
- Newsletter broadcasts
- Event invitations
- Special promotions

Setup Time: 5 minutes
Best For: Time-sensitive announcements
```

#### Drip Campaign

Automated sequence delivered over time:

```
Use Cases:
- Welcome series (3-5 emails)
- Onboarding sequences (5-10 emails)
- Educational content series
- Lead nurturing campaigns

Setup Time: 15-30 minutes
Best For: Relationship building
```

#### Triggered Campaign

Event-based campaigns that start automatically:

```
Triggers:
- Contact signup
- Form submission
- Purchase completion
- Abandoned cart
- Custom events

Setup Time: 20-40 minutes
Best For: Behavioral automation
```

#### A/B Test Campaign

Compare variations to optimize performance:

```
Test Elements:
- Subject lines
- Email content
- Send times
- Sender names

Setup Time: 10-20 minutes
Best For: Performance optimization
```

---

## Level 2: Advanced Configuration

### Multi-Step Sequences

#### Complex Sequence Example

**10-Step Lead Nurturing Campaign:**

```
START
  │
  ▼
Email 1: Introduction (Day 0)
  │
  ├─ Opened? ──YES──▶ Email 2A: Engaged Path (Day 2)
  │                      │
  └─ NO ──▶ Email 2B: Re-engagement (Day 3)
                │
                ▼
            Email 3: Value Proposition (Day 5)
                │
                ├─ Clicked? ──YES──▶ Email 4A: Demo Offer (Day 7)
                │                       │
                └─ NO ──▶ Email 4B: Case Study (Day 8)
                            │
                            ▼
                        Email 5: Social Proof (Day 10)
                            │
                            ├─ Replied? ──YES──▶ [Move to Sales]
                            │
                            └─ NO ──▶ Email 6: Final Offer (Day 14)
                                        │
                                        ▼
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

```
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

```
Contact A: Historically opens at 7:30 AM → Send at 7:15 AM
Contact B: Historically opens at 2:00 PM → Send at 1:45 PM
Contact C: No history → Send at industry benchmark (9:00 AM)
```

### Campaign Templates

#### Pre-Built Campaign Templates

**Welcome Series Template:**

```
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

```
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

```
Campaign Actions:
  → Save as Template
  
Template Configuration:
┌─────────────────────────────────────────────────────┐
│ Template Name: "Custom Onboarding"                  │
│ Category: Onboarding                                │
│ Tags: SaaS, B2B, Welcome                            │
│ Description: 7-day onboarding for new users         │
│                                                     │
│ ☑ Include sequence structure                        │
│ ☑ Include email templates                           │
│ ☑ Include conditional logic                         │
│ ☐ Include specific content (use placeholders)       │
│                                                     │
│ Sharing:                                            │
│ ○ Private (only me)                                 │
│ ● Team (all workspace members)                      │
│ ○ Public (template library)                         │
└─────────────────────────────────────────────────────┘
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

```
Day 1: 500 contacts match criteria → Enrolled
Day 5: 50 new contacts match → Auto-enrolled at step 1
Day 5: 20 contacts no longer match → Removed from sequence
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

```
Campaign Creation:
  ↓
Draft Review (Creator)
  ↓
Submit for Approval
  ↓
Manager Review ──REJECT──▶ Back to Creator
  │
  APPROVE
  ↓
Compliance Review ──REJECT──▶ Back to Creator
  │
  APPROVE
  ↓
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

```
Campaign Editor:
┌─────────────────────────────────────────────────────┐
│ 👤 Sarah (editing Email 2)                          │
│ 👤 Mike (viewing sequence)                          │
│ 👤 Lisa (editing Email 3)                           │
│                                                     │
│ Activity Feed:                                      │
│ • Sarah updated subject line (2 min ago)            │
│ • Mike added comment on Email 1 (5 min ago)         │
│ • Lisa uploaded new template (10 min ago)           │
└─────────────────────────────────────────────────────┘
```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Campaigns table
CREATE TABLE campaigns (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),
  
  -- Campaign details
  name VARCHAR(255) NOT NULL,
  description TEXT,
  campaign_type VARCHAR(50), -- broadcast, drip, triggered, ab_test
  status VARCHAR(50), -- draft, scheduled, active, paused, completed
  
  -- Audience
  segment_id UUID REFERENCES segments(id),
  total_contacts INTEGER DEFAULT 0,
  
  -- Sending configuration
  from_email VARCHAR(255),
  from_name VARCHAR(255),
  reply_to_email VARCHAR(255),
  
  -- Scheduling
  start_date TIMESTAMP,
  end_date TIMESTAMP,
  timezone VARCHAR(100) DEFAULT 'UTC',
  send_strategy VARCHAR(50), -- immediate, scheduled, optimized
  
  -- Settings
  track_opens BOOLEAN DEFAULT TRUE,
  track_clicks BOOLEAN DEFAULT TRUE,
  unsubscribe_enabled BOOLEAN DEFAULT TRUE,
  
  -- Metadata
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  launched_at TIMESTAMP,
  completed_at TIMESTAMP
);

CREATE INDEX idx_campaigns_tenant ON campaigns(tenant_id);
CREATE INDEX idx_campaigns_status ON campaigns(status);
CREATE INDEX idx_campaigns_type ON campaigns(campaign_type);

-- Campaign steps (sequence emails)
CREATE TABLE campaign_steps (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  
  -- Step details
  step_order INTEGER NOT NULL,
  step_name VARCHAR(255),
  step_type VARCHAR(50), -- email, wait, condition, action
  
  -- Email content (if step_type = 'email')
  template_id UUID REFERENCES templates(id),
  subject_line TEXT,
  email_content TEXT,
  
  -- Wait configuration (if step_type = 'wait')
  wait_duration_value INTEGER,
  wait_duration_unit VARCHAR(20), -- minutes, hours, days, weeks
  
  -- Conditional logic (if step_type = 'condition')
  condition_rules JSONB,
  true_next_step_id UUID REFERENCES campaign_steps(id),
  false_next_step_id UUID REFERENCES campaign_steps(id),
  
  -- Analytics
  emails_sent INTEGER DEFAULT 0,
  emails_delivered INTEGER DEFAULT 0,
  opens INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  replies INTEGER DEFAULT 0,
  unsubscribes INTEGER DEFAULT 0,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE(campaign_id, step_order)
);

CREATE INDEX idx_campaign_steps_campaign ON campaign_steps(campaign_id);

-- Campaign contacts (enrollment tracking)
CREATE TABLE campaign_contacts (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  contact_id UUID NOT NULL REFERENCES contacts(id),
  
  -- Enrollment status
  status VARCHAR(50), -- enrolled, active, paused, completed, exited
  current_step_id UUID REFERENCES campaign_steps(id),
  
  -- Progress tracking
  enrolled_at TIMESTAMP DEFAULT NOW(),
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  exited_at TIMESTAMP,
  exit_reason VARCHAR(255),
  
  -- Step history
  steps_completed INTEGER DEFAULT 0,
  last_email_sent_at TIMESTAMP,
  next_email_scheduled_at TIMESTAMP,
  
  UNIQUE(campaign_id, contact_id)
);

CREATE INDEX idx_campaign_contacts_campaign ON campaign_contacts(campaign_id);
CREATE INDEX idx_campaign_contacts_contact ON campaign_contacts(contact_id);
CREATE INDEX idx_campaign_contacts_status ON campaign_contacts(status);
CREATE INDEX idx_campaign_contacts_next_scheduled ON campaign_contacts(next_email_scheduled_at);

-- Campaign analytics (aggregated metrics)
CREATE TABLE campaign_analytics (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  
  -- Date tracking
  date DATE NOT NULL,
  
  -- Sending metrics
  emails_sent INTEGER DEFAULT 0,
  emails_delivered INTEGER DEFAULT 0,
  emails_bounced INTEGER DEFAULT 0,
  
  -- Engagement metrics
  unique_opens INTEGER DEFAULT 0,
  total_opens INTEGER DEFAULT 0,
  unique_clicks INTEGER DEFAULT 0,
  total_clicks INTEGER DEFAULT 0,
  replies INTEGER DEFAULT 0,
  
  -- Negative metrics
  spam_complaints INTEGER DEFAULT 0,
  unsubscribes INTEGER DEFAULT 0,
  
  -- Calculated rates
  delivery_rate DECIMAL(5,2),
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),
  reply_rate DECIMAL(5,2),
  unsubscribe_rate DECIMAL(5,2),
  
  -- Metadata
  calculated_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE(campaign_id, date)
);

CREATE INDEX idx_campaign_analytics_campaign ON campaign_analytics(campaign_id);
CREATE INDEX idx_campaign_analytics_date ON campaign_analytics(date);

-- Campaign approvals
CREATE TABLE campaign_approvals (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  
  -- Approval details
  approver_id UUID NOT NULL REFERENCES users(id),
  approval_role VARCHAR(100), -- campaign_manager, compliance_officer, etc.
  status VARCHAR(50), -- pending, approved, rejected
  
  -- Review
  comments TEXT,
  reviewed_at TIMESTAMP,
  
  -- Metadata
  requested_at TIMESTAMP DEFAULT NOW(),
  
  UNIQUE(campaign_id, approver_id, approval_role)
);

CREATE INDEX idx_campaign_approvals_campaign ON campaign_approvals(campaign_id);
CREATE INDEX idx_campaign_approvals_status ON campaign_approvals(status);
```

### Campaign Execution Engine

```typescript
interface Campaign {
  id: string;
  tenantId: string;
  name: string;
  campaignType: 'broadcast' | 'drip' | 'triggered' | 'ab_test';
  status: 'draft' | 'scheduled' | 'active' | 'paused' | 'completed';
  segmentId: string;
  fromEmail: string;
  fromName: string;
  sendStrategy: 'immediate' | 'scheduled' | 'optimized';
  timezone: string;
}

interface CampaignStep {
  id: string;
  campaignId: string;
  stepOrder: number;
  stepType: 'email' | 'wait' | 'condition' | 'action';
  templateId?: string;
  subjectLine?: string;
  emailContent?: string;
  waitDuration?: { value: number; unit: string };
  conditionRules?: any;
  trueNextStepId?: string;
  falseNextStepId?: string;
}

class CampaignExecutionEngine {
  /**
   * Launch a campaign and enroll contacts
   */
  async launchCampaign(campaignId: string): Promise<void> {
    const campaign = await db.campaigns.findById(campaignId);
    
    if (campaign.status !== 'draft' && campaign.status !== 'scheduled') {
      throw new Error('Campaign must be in draft or scheduled status to launch');
    }
    
    // 1. Get contacts from segment
    const contacts = await db.segments.getContacts(campaign.segmentId);
    
    // 2. Enroll contacts in campaign
    await this.enrollContacts(campaignId, contacts);
    
    // 3. Update campaign status
    await db.campaigns.update(campaignId, {
      status: 'active',
      launchedAt: new Date(),
    });
    
    // 4. Start processing first step
    await this.processNextSteps(campaignId);
    
    logger.info(`Campaign ${campaignId} launched with ${contacts.length} contacts`);
  }
  
  /**
   * Enroll contacts in campaign
   */
  private async enrollContacts(
    campaignId: string,
    contacts: Contact[]
  ): Promise<void> {
    const campaign = await db.campaigns.findById(campaignId);
    const firstStep = await db.campaignSteps.findFirst(campaignId);
    
    const enrollments = contacts.map(contact => ({
      campaignId,
      contactId: contact.id,
      status: 'enrolled',
      currentStepId: firstStep.id,
      enrolledAt: new Date(),
      nextEmailScheduledAt: this.calculateNextSendTime(campaign, contact),
    }));
    
    await db.campaignContacts.createMany(enrollments);
    
    // Update campaign total contacts
    await db.campaigns.update(campaignId, {
      totalContacts: contacts.length,
    });
  }
  
  /**
   * Process next steps for all contacts ready to receive emails
   */
  async processNextSteps(campaignId: string): Promise<void> {
    // Get all contacts ready for next step
    const readyContacts = await db.campaignContacts.findWhere({
      campaignId,
      status: 'active',
      nextEmailScheduledAt: { lte: new Date() },
    });
    
    for (const enrollment of readyContacts) {
      await this.processContactStep(enrollment);
    }
  }
  
  /**
   * Process a single step for a contact
   */
  private async processContactStep(
    enrollment: CampaignContact
  ): Promise<void> {
    const step = await db.campaignSteps.findById(enrollment.currentStepId);
    
    switch (step.stepType) {
      case 'email':
        await this.sendCampaignEmail(enrollment, step);
        break;
        
      case 'wait':
        await this.processWaitStep(enrollment, step);
        break;
        
      case 'condition':
        await this.processConditionalStep(enrollment, step);
        break;
        
      case 'action':
        await this.processActionStep(enrollment, step);
        break;
    }
  }
  
  /**
   * Send campaign email to contact
   */
  private async sendCampaignEmail(
    enrollment: CampaignContact,
    step: CampaignStep
  ): Promise<void> {
    const contact = await db.contacts.findById(enrollment.contactId);
    const campaign = await db.campaigns.findById(enrollment.campaignId);
    
    // 1. Render email with personalization
    const renderedContent = await this.renderEmailContent(
      step.emailContent,
      contact
    );
    const renderedSubject = await this.renderEmailContent(
      step.subjectLine,
      contact
    );
    
    // 2. Queue email for sending
    await emailQueue.add('send-campaign-email', {
      campaignId: campaign.id,
      stepId: step.id,
      contactId: contact.id,
      from: `${campaign.fromName} <${campaign.fromEmail}>`,
      to: contact.email,
      subject: renderedSubject,
      html: renderedContent,
      trackOpens: campaign.trackOpens,
      trackClicks: campaign.trackClicks,
    });
    
    // 3. Update enrollment progress
    const nextStep = await this.getNextStep(step);
    
    await db.campaignContacts.update(enrollment.id, {
      currentStepId: nextStep?.id,
      stepsCompleted: enrollment.stepsCompleted + 1,
      lastEmailSentAt: new Date(),
      nextEmailScheduledAt: nextStep 
        ? this.calculateNextStepTime(nextStep, contact)
        : null,
      status: nextStep ? 'active' : 'completed',
      completedAt: nextStep ? null : new Date(),
    });
    
    // 4. Update step analytics
    await db.campaignSteps.increment(step.id, 'emailsSent', 1);
  }
  
  /**
   * Process wait step
   */
  private async processWaitStep(
    enrollment: CampaignContact,
    step: CampaignStep
  ): Promise<void> {
    const nextStep = await this.getNextStep(step);
    const contact = await db.contacts.findById(enrollment.contactId);
    
    // Calculate when to process next step
    const nextScheduledTime = this.calculateWaitTime(
      step.waitDuration,
      new Date()
    );
    
    await db.campaignContacts.update(enrollment.id, {
      currentStepId: nextStep?.id,
      nextEmailScheduledAt: nextScheduledTime,
      status: nextStep ? 'active' : 'completed',
    });
  }
  
  /**
   * Process conditional step
   */
  private async processConditionalStep(
    enrollment: CampaignContact,
    step: CampaignStep
  ): Promise<void> {
    const contact = await db.contacts.findById(enrollment.contactId);
    
    // Evaluate condition
    const conditionMet = await this.evaluateCondition(
      step.conditionRules,
      contact,
      enrollment
    );
    
    // Determine next step based on condition
    const nextStepId = conditionMet 
      ? step.trueNextStepId 
      : step.falseNextStepId;
    
    if (!nextStepId) {
      // No next step, complete enrollment
      await db.campaignContacts.update(enrollment.id, {
        status: 'completed',
        completedAt: new Date(),
      });
      return;
    }
    
    const nextStep = await db.campaignSteps.findById(nextStepId);
    
    await db.campaignContacts.update(enrollment.id, {
      currentStepId: nextStepId,
      nextEmailScheduledAt: this.calculateNextStepTime(nextStep, contact),
    });
  }
  
  /**
   * Evaluate conditional logic
   */
  private async evaluateCondition(
    rules: any,
    contact: Contact,
    enrollment: CampaignContact
  ): Promise<boolean> {
    // Get contact's email engagement history
    const emailHistory = await db.emails.findWhere({
      contactId: contact.id,
      campaignId: enrollment.campaignId,
    });
    
    // Evaluate based on rule type
    switch (rules.type) {
      case 'email_opened':
        return emailHistory.some(e => e.opened);
        
      case 'email_clicked':
        return emailHistory.some(e => e.clicked);
        
      case 'email_replied':
        return emailHistory.some(e => e.replied);
        
      case 'contact_attribute':
        return this.evaluateAttributeCondition(rules, contact);
        
      case 'lead_score':
        return contact.leadScore >= rules.threshold;
        
      default:
        return false;
    }
  }
  
  /**
   * Calculate next send time based on strategy
   */
  private calculateNextSendTime(
    campaign: Campaign,
    contact: Contact
  ): Date {
    const now = new Date();
    
    switch (campaign.sendStrategy) {
      case 'immediate':
        return now;
        
      case 'scheduled':
        return campaign.startDate || now;
        
      case 'optimized':
        return this.calculateOptimalSendTime(contact);
        
      default:
        return now;
    }
  }
  
  /**
   * Calculate optimal send time based on contact behavior
   */
  private calculateOptimalSendTime(contact: Contact): Date {
    // Get historical engagement data
    const historicalOpens = contact.emailEngagement?.typicalOpenTimes || [];
    
    if (historicalOpens.length > 0) {
      // Find most common open time
      const optimalHour = this.getMostCommonHour(historicalOpens);
      
      // Schedule for that time tomorrow
      const tomorrow = new Date();
      tomorrow.setDate(tomorrow.getDate() + 1);
      tomorrow.setHours(optimalHour, 0, 0, 0);
      
      return tomorrow;
    }
    
    // Default to 9 AM in contact's timezone
    const defaultTime = new Date();
    defaultTime.setHours(9, 0, 0, 0);
    return defaultTime;
  }
  
  /**
   * Render email content with personalization
   */
  private async renderEmailContent(
    template: string,
    contact: Contact
  ): Promise<string> {
    const personalizationService = new PersonalizationService();
    return await personalizationService.render(template, contact);
  }
  
  /**
   * Get next step in sequence
   */
  private async getNextStep(
    currentStep: CampaignStep
  ): Promise<CampaignStep | null> {
    return await db.campaignSteps.findWhere({
      campaignId: currentStep.campaignId,
      stepOrder: currentStep.stepOrder + 1,
    });
  }
}
```

### Background Jobs

```typescript
// Process campaign steps every 5 minutes
cron.schedule('*/5 * * * *', async () => {
  const activeCampaigns = await db.campaigns.findWhere({
    status: 'active',
  });
  
  const engine = new CampaignExecutionEngine();
  
  for (const campaign of activeCampaigns) {
    try {
      await engine.processNextSteps(campaign.id);
    } catch (error) {
      logger.error(`Error processing campaign ${campaign.id}:`, error);
    }
  }
});

// Aggregate campaign analytics daily
cron.schedule('0 2 * * *', async () => {  // 2 AM daily
  const yesterday = new Date();
  yesterday.setDate(yesterday.getDate() - 1);
  yesterday.setHours(0, 0, 0, 0);
  
  const activeCampaigns = await db.campaigns.findWhere({
    status: ['active', 'completed'],
  });
  
  for (const campaign of activeCampaigns) {
    // Aggregate metrics for yesterday
    const metrics = await aggregateCampaignMetrics(campaign.id, yesterday);
    
    await db.campaignAnalytics.upsert({
      campaignId: campaign.id,
      date: yesterday,
      ...metrics,
    });
  }
});

// Auto-complete finished campaigns
cron.schedule('0 * * * *', async () => {  // Every hour
  const campaigns = await db.campaigns.findWhere({
    status: 'active',
  });
  
  for (const campaign of campaigns) {
    const activeContacts = await db.campaignContacts.count({
      campaignId: campaign.id,
      status: 'active',
    });
    
    if (activeContacts === 0) {
      await db.campaigns.update(campaign.id, {
        status: 'completed',
        completedAt: new Date(),
      });
      
      logger.info(`Campaign ${campaign.id} auto-completed`);
    }
  }
});
```

### API Endpoints

```typescript
// Create campaign
router.post('/api/campaigns', async (req, res) => {
  const { name, campaignType, segmentId, fromEmail, fromName } = req.body;
  
  const campaign = await db.campaigns.create({
    tenantId: req.user.tenantId,
    workspaceId: req.user.workspaceId,
    name,
    campaignType,
    segmentId,
    fromEmail,
    fromName,
    status: 'draft',
    createdBy: req.user.id,
  });
  
  res.json(campaign);
});

// Get campaign details
router.get('/api/campaigns/:id', async (req, res) => {
  const campaign = await db.campaigns.findById(req.params.id);
  const steps = await db.campaignSteps.findWhere({
    campaignId: req.params.id,
  });
  const analytics = await db.campaignAnalytics.findLatest(req.params.id);
  
  res.json({
    campaign,
    steps,
    analytics,
  });
});

// Launch campaign
router.post('/api/campaigns/:id/launch', async (req, res) => {
  const engine = new CampaignExecutionEngine();
  await engine.launchCampaign(req.params.id);
  
  res.json({ success: true });
});

// Pause campaign
router.post('/api/campaigns/:id/pause', async (req, res) => {
  await db.campaigns.update(req.params.id, {
    status: 'paused',
  });
  
  await db.campaignContacts.updateWhere(
    { campaignId: req.params.id, status: 'active' },
    { status: 'paused' }
  );
  
  res.json({ success: true });
});

// Resume campaign
router.post('/api/campaigns/:id/resume', async (req, res) => {
  await db.campaigns.update(req.params.id, {
    status: 'active',
  });
  
  await db.campaignContacts.updateWhere(
    { campaignId: req.params.id, status: 'paused' },
    { status: 'active' }
  );
  
  res.json({ success: true });
});

// Get campaign analytics
router.get('/api/campaigns/:id/analytics', async (req, res) => {
  const { startDate, endDate } = req.query;
  
  const analytics = await db.campaignAnalytics.findWhere({
    campaignId: req.params.id,
    date: {
      gte: new Date(startDate),
      lte: new Date(endDate),
    },
  });
  
  const stepAnalytics = await db.campaignSteps.findWhere({
    campaignId: req.params.id,
  });
  
  res.json({
    overall: analytics,
    byStep: stepAnalytics,
  });
});

// Clone campaign
router.post('/api/campaigns/:id/clone', async (req, res) => {
  const original = await db.campaigns.findById(req.params.id);
  const steps = await db.campaignSteps.findWhere({
    campaignId: req.params.id,
  });
  
  // Create new campaign
  const cloned = await db.campaigns.create({
    ...original,
    id: undefined,
    name: `${original.name} (Copy)`,
    status: 'draft',
    createdAt: new Date(),
    launchedAt: null,
    completedAt: null,
  });
  
  // Clone steps
  for (const step of steps) {
    await db.campaignSteps.create({
      ...step,
      id: undefined,
      campaignId: cloned.id,
    });
  }
  
  res.json(cloned);
});
```

---

## Related Documentation

### Campaign Features

- **[A/B Testing](../ab-testing.md)** - Split testing for campaign optimization
- **[Personalization System](../personalization-system.md)** - Dynamic email personalization
- **[Template Management](../../templates/template-management.md)** - Email template library

### Audience Management

- **[Contact Segmentation](../../leads/contact-segmentation.md)** - Audience targeting
- **[Lead Scoring](../../leads/lead-scoring.md)** - Contact prioritization

### Analytics

- **[Core Analytics](../../analytics/core-analytics/overview.md)** - Performance tracking
- **[Enhanced Analytics](../../analytics/enhanced-analytics/overview.md)** - Advanced insights

### Technical

- **[Email Pipeline](../../queue/email-pipeline.md)** - Email sending infrastructure
- **[API Documentation](../../../implementation-technical/api/tenant-api/campaigns.md)** - Campaign APIs

---

**Last Updated:** November 25, 2025  
**Status:** Planned - Critical Q1 2026 Feature  
**Target Release:** Q1 2026  
**Owner:** Campaigns Team
