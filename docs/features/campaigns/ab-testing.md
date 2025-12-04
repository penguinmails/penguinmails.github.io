---
title: "A/B Testing"
description: "Split testing for email campaigns to optimize subject lines, content, sending times, and more"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:

  - campaigns/campaign-management/overview

  - campaigns/personalization-system

  - analytics/core-analytics/overview
related_tasks:

  - epic-6-core-email-pipeline
---

# A/B Testing

**Quick Access**: Optimize email campaign performance through systematic split testing of  subject lines, content, send times, and sender names.

## Overview

A/B Testing enables data-driven campaign optimization by testing variations of your emails against each other to identify what drives better engagement. Send different versions to segments of your audience, measure performance, and automatically deploy the winning variant.

### Key Benefits

- **Optimize Performance**: Improve open rates, click rates, and conversions

- **Data-Driven Decisions**: Remove guesswork from email marketing

- **Automated Winner Selection**: System automatically picks and deploys best performer

- **Multi-Variant Testing**: Test up to 5 variants simultaneously (Enterprise)

- **Statistical Significance**: Built-in confidence scoring

---

## Level 1: Quick Start Guide

### Your First A/B Test

#### Step 1: Create Campaign with A/B Test

```text

1. Navigate to Campaigns â†’ Create New Campaign

2. Enable "A/B Testing" toggle

3. Choose test type:
   â˜ Subject Line
   â˜ Email Content
   â˜ Sender Name
   â˜ Send Time

```

#### Step 2: Configure Variations

##### Example: Subject Line Test

```text

Variant A (Control):
Subject: "Limited Time: 50% Off All Products"

Variant B:
Subject: "Flash Sale: Save 50% Today Only"

Variant C (optional):
Subject: "Don't Miss Out: Half Price Sale Ends Tonight"

```

##### Test Parameters

- Test sample size: 30% (10% per variant + 10% holdout)

- Winner deployment: Remaining 70%

- Test duration: 4 hours

- Win criteria: Highest open rate

#### Step 3: Review Test Plan

System displays:

```text

Total Audience: 10,000 contacts

Test Phase:

  - Variant A: 1,000 contacts (10%)

  - Variant B: 1,000 contacts (10%)

  - Variant C: 1,000 contacts (10%)

  - Duration: 4 hours

Winner Deployment:

  - Winning variant: 7,000 contacts (70%)

  - Sent after test completion

```

#### Step 4: Launch Test

1. Review variations and parameters

2. Click "Launch A/B Test"

3. Test emails sent to sample groups

4. Monitor real-time results

#### Step 5: Automatic Winner Deployment

After 4 hours:

```text

Test Results:
  Variant A: 22% open rate
  Variant B: 28% open rate â† WINNER (26% lift)
  Variant C: 24% open rate

Winner selected: Variant B
Deploying to remaining 7,000 contacts...

```

**Result:** 26% improvement in opens vs. original subject line.

### Choosing What to Test

#### Subject Line Testing

**Best Practices:**

- Test one element at a time (length, emoji, personalization)

- Try different tones (urgent vs. casual)

- Test questions vs. statements

- Experiment with personalization

**Examples:**

```text

Control: "New Features Released"
Test:    "{{firstName}}, Check Out What's New"

Control: "Weekly Newsletter - November 25"
Test:    "ðŸŽ‰ Your Weekly Insights Are Here"

Control: "Limited Time Offer Inside"
Test:    "Last Chance: Offer Expires At Midnight"

```

#### Email Content Testing

**What to Test:**

- CTA button text and placement

- Email length (short vs. detailed)

- Image vs. text-heavy

- Single CTA vs. multiple CTAs

**Examples:**

```text

Control: "Learn More" button
Test:    "Get Started Free" button

Control: Long-form email (800 words)
Test:    Short email (200 words) with video

Control: Text-based email
Test:    Visual/image-heavy email

```

#### Sender Name Testing

**Variations:**

```text

Control: "PenguinMails Team"
Test:    "Sarah from PenguinMails"

Control: "marketing@company.com"
Test:    "sarah.jones@company.com"

```

#### Send Time Testing

**Optimize delivery timing:**

```text

Variant A: 9:00 AM Tuesday
Variant B: 2:00 PM Tuesday
Variant C: 6:00 PM Tuesday

```

---

## Level 2: Advanced Testing Strategies

### Multi-Variant Testing

Test up to 5 variants simultaneously:

**Configuration:**

```yaml
test_name: "Q1 Campaign Optimization"
variants:

  - name: "Control"
    subject: "Quarterly Product Update"
    sample_size: 10%

  - name: "Personalized"
    subject: "{{firstName}}, See What's New This Quarter"
    sample_size: 10%

  - name: "Urgent"
    subject: "Don't Miss: Q1 Updates Inside"
    sample_size: 10%

  - name: "Question"
    subject: "Ready For Q1 Growth?"
    sample_size: 10%

  - name: "Emoji"
    subject: "ðŸš€ Q1 Innovation Launch"
    sample_size: 10%

holdout:
  sample_size: 50%

test_duration: 6 hours
win_criteria: open_rate
confidence_threshold: 95%

```

### Statistical Significance

#### Confidence Scoring

- System calculates statistical confidence for each variant

- Requires minimum sample size (typically 100+ opens per variant)

- Won't declare winner below 95% confidence threshold

- Extends test duration if needed to reach significance

#### Results Display

```text

Variant A: 24% open rate (Confidence: 48% - inconclusive)
Variant B: 28% open rate (Confidence: 96% - WINNER)
Variant C: 22% open rate (Confidence: 99% - clear loser)

Winner: Variant B with 96% confidence
Lift over control: +16.7%

```

### Sequential Testing

Test multiple elements in sequence:

#### Example: 3-Stage Test

```text

Stage 1: Subject Line Test (Week 1)
  Result: "{{firstName}}, ..." wins

Stage 2: Content Test (Week 2)
  Using winning subject from Stage 1
  Test: Short vs. Long content
  Result: Short content wins

Stage 3: CTA Test (Week 3)
  Using winning subject + winning content
  Test: "Learn More" vs. "Get Started Free"
  Result: "Get Started Free" wins

Final Optimized Email:
  Subject: "{{firstName}}, Check Out What's New"
  Content: Short (250 words)
  CTA: "Get Started Free"

Combined lift: +45% vs. original

```

### Audience Segmentation in Tests

#### Test Different Segments Separately

```yaml
test_groups:

  - segment: "Active Users"
    variants: [A, B]
    sample_size: 20%

  - segment: "Inactive Users"
    variants: [C, D]  # Different variations for different behavior
    sample_size: 20%

```

**Why**: Different segments may respond better to different messaging.

### Advanced Win Criteria

**Beyond Open Rate:**

```yaml
win_criteria:
  primary: click_rate        # Primary goal
  secondary: conversion_rate # Secondary consideration
  minimum_opens: 100         # Minimum data required

fallback:
  if_no_winner: send_control
  if_tie: highest_open_rate

```

**Multi-Metric Optimization:**

- Optimize for clicks instead of opens

- Consider conversion tracking (if integrated with CRM)

- Balance engagement vs. unsubscribe rate

### Testing Best Practices

#### Sample Size Guidelines

| Audience Size | Test Sample | Winner Deployment | Min. Test Duration |
|--------------|-------------|-------------------|-------------------|
| < 1,000 | 50% | 50% | 2 hours |
| 1,000 - 5,000 | 30% | 70% | 4 hours |
| 5,000 - 20,000 | 20% | 80% | 4 hours |
| 20,000+ | 10% | 90% | 6 hours |

#### Testing Frequency

**Don't Over-Test:**

- Test 1-2 elements per campaign

- Avoid testing every email (causes testing fatigue)

- Focus tests on high-value campaigns

**Recommended Cadence:**

- Major campaigns: Always test

- Weekly newsletters: Test monthly

- Transactional emails: Test quarterly

#### What Not to Test

- **Too Many Variables**: Testing subject + content + send time simultaneously

- **Tiny Differences**: "Hi" vs. "Hello" (unlikely to matter)

- **Small Audiences**: < 500 contacts (insufficient data)

- **Time-Sensitive Emails**: Test phase may delay deployment

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- A/B test configuration
CREATE TABLE ab_tests (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id),
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Test configuration
  test_name VARCHAR(255),
  test_type VARCHAR(50), -- subject, content, sender, send_time
  test_duration_hours INTEGER DEFAULT 4,
  sample_size_percent INTEGER DEFAULT 20,

  -- Win criteria
  win_metric VARCHAR(50), -- open_rate, click_rate, conversion_rate
  confidence_threshold DECIMAL(5,2) DEFAULT 95.0,
  minimum_sample_size INTEGER DEFAULT 100,

  -- Status
  status VARCHAR(50), -- draft, running, completed, winner_deployed
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  winner_variant_id UUID REFERENCES ab_test_variants(id),

  -- Results
  results_summary JSONB,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Test variants
CREATE TABLE ab_test_variants (
  id UUID PRIMARY KEY,
  ab_test_id UUID NOT NULL REFERENCES ab_tests(id),

  -- Variant details
  variant_name VARCHAR(50), -- A, B, C, etc.
  is_control BOOLEAN DEFAULT FALSE,
  sample_size_percent INTEGER,

  -- Content variations
  subject_line TEXT,
  email_content TEXT,
  sender_name VARCHAR(255),
  sender_email VARCHAR(255),
  send_time TIME,

  -- Results
  emails_sent INTEGER DEFAULT 0,
  emails_delivered INTEGER DEFAULT 0,
  opens INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  conversions INTEGER DEFAULT 0,
  unsubscribes INTEGER DEFAULT 0,

  -- Calculated metrics
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),
  conversion_rate DECIMAL(5,2),
  statistical_confidence DECIMAL(5,2),

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW()
);

-- Variant assignment (which contact got which variant)
CREATE TABLE ab_test_assignments (
  id UUID PRIMARY KEY,
  ab_test_id UUID NOT NULL REFERENCES ab_tests(id),
  variant_id UUID NOT NULL REFERENCES ab_test_variants(id),
  contact_id UUID NOT NULL REFERENCES contacts(id),
  email_id UUID REFERENCES emails(id),

  assigned_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(ab_test_id, contact_id) -- One variant per contact per test
);

```

### Test Execution Service

```typescript
class ABTestService {
  async startTest(testId: string): Promise<void> {
    const test = await db.abTests.findById(testId);
    const variants = await db.abTestVariants.findByTest(testId);

    // 1. Calculate sample sizes
    const campaign = await db.campaigns.findById(test.campaignId);
    const totalContacts = await campaign.getContactCount();

    const assignments = this.assignContactsToVariants(
      totalContacts,
      variants,
      test.sampleSizePercent
    );

    // 2. Send test emails
    for (const variant of variants) {
      const contacts = assignments[variant.id];

      await emailQueue.addBulk(contacts.map(contact => ({
        name: 'send-email',
        data: {
          campaignId: campaign.id,
          contactId: contact.id,
          variantId: variant.id,
          subject: variant.subjectLine,
          content: variant.emailContent,
          senderName: variant.senderName,
        },
      })));

      // Track assignment
      await db.abTestAssignments.createMany(
        contacts.map(contact => ({
          abTestId: testId,
          variantId: variant.id,
          contactId: contact.id,
        }))
      );
    }

    // 3. Update test status
    await db.abTests.update(testId, {
      status: 'running',
      startedAt: new Date(),
    });

    // 4. Schedule win selection
    await this.scheduleWinnerSelection(testId, test.testDurationHours);
  }

  private assignContactsToVariants(
    totalContacts: Contact[],
    variants: ABTestVariant[],
    testSamplePercent: number
  ): Record<string, Contact[]> {
    // Shuffle contacts for randomization
    const shuffled = this.shuffle(totalContacts);

    // Calculate how many contacts per variant
    const testSampleSize = Math.floor(totalContacts.length * testSamplePercent / 100);
    const contactsPerVariant = Math.floor(testSampleSize / variants.length);

    const assignments: Record<string, Contact[]> = {};
    let offset = 0;

    for (const variant of variants) {
      assignments[variant.id] = shuffled.slice(offset, offset + contactsPerVariant);
      offset += contactsPerVariant;
    }

    return assignments;
  }

  async selectWinner(testId: string): Promise<ABTestVariant | null> {
    const test = await db.abTests.findById(testId);
    const variants = await db.abTestVariants.findByTest(testId);

    // 1. Calculate current metrics for each variant
    for (const variant of variants) {
      const metrics = await this.calculateVariantMetrics(variant.id);
      await db.abTestVariants.update(variant.id, metrics);
    }

    // 2. Calculate statistical significance
    const winner = this.determineWinner(variants, test);

    if (!winner) {
      // No clear winner, extend test or use control
      logger.info(`No clear winner for test ${testId}, using control`);
      return null;
    }

    // 3. Mark winner
    await db.abTests.update(testId, {
      status: 'completed',
      completedAt: new Date(),
      winnerVariantId: winner.id,
      resultsSummary: this.generateResultsSummary(variants, winner),
    });

    return winner;
  }

  private determineWinner(
    variants: ABTestVariant[],
    test: ABTest
  ): ABTestVariant | null {
    const metric = test.winMetric; // e.g., 'openRate'

    // Sort by metric performance
    const sorted = variants.sort((a, b) => b[metric] - a[metric]);
    const topVariant = sorted[0];
    const secondVariant = sorted[1];

    // Calculate statistical confidence
    const confidence = this.calculateConfidence(
      topVariant,
      secondVariant,
      metric
    );

    topVariant.statisticalConfidence = confidence;

    // Winner must exceed confidence threshold
    if (confidence >= test.confidenceThreshold) {
      return topVariant;
    }

    return null; // No statistically significant winner
  }

  private calculateConfidence(
    variantA: ABTestVariant,
    variantB: ABTestVariant,
    metric: string
  ): number {
    // Simplified chi-square test for proportions
    const n1 = variantA.emailsSent;
    const n2 = variantB.emailsSent;
    const p1 = variantA[metric] / 100;
    const p2 = variantB[metric] / 100;

    const pooled = (n1 * p1 + n2 * p2) / (n1 + n2);
    const se = Math.sqrt(pooled * (1 - pooled) * (1/n1 + 1/n2));
    const z = Math.abs(p1 - p2) / se;

    // Convert z-score to confidence level
    return this.zScoreToConfidence(z);
  }

  async deployWinner(testId: string): Promise<void> {
    const test = await db.abTests.findById(testId);
    const winner = await db.abTestVariants.findById(test.winnerVariantId);

    if (!winner) {
      throw new Error('No winner selected');
    }

    // Get remaining contacts (not in test sample)
    const allContacts = await db.campaigns.getContacts(test.campaignId);
    const testedContacts = await db.abTestAssignments.getContacts(testId);
    const remainingContacts = allContacts.filter(
      c => !testedContacts.includes(c.id)
    );

    // Send winning variant to remaining contacts
    await emailQueue.addBulk(remainingContacts.map(contact => ({
      name: 'send-email',
      data: {
        campaignId: test.campaignId,
        contactId: contact.id,
        subject: winner.subjectLine,
        content: winner.emailContent,
        senderName: winner.senderName,
        abTestWinner: true,
      },
    })));

    await db.abTests.update(testId, {
      status: 'winner_deployed',
    });
  }
}

```

### Background Jobs

```typescript
// Scheduled job: Check for completed tests
cron.schedule('*/30 * * * *', async () => {  // Every 30 minutes
  const runningTests = await db.abTests.findRunning();

  for (const test of runningTests) {
    const testDuration = differenceInHours(new Date(), test.startedAt);

    if (testDuration >= test.testDurationHours) {
      const abTestService = new ABTestService();

      // Select winner
      const winner = await abTestService.selectWinner(test.id);

      // Deploy winner to remaining audience
      if (winner) {
        await abTestService.deployWinner(test.id);

        // Send notification to campaign owner
        await notificationService.send({
          userId: test.createdBy,
          type: 'ab_test_completed',
          data: {
            testId: test.id,
            winnerName: winner.variantName,
            lift: calculateLift(winner, test.control),
          },
        });
      }
    }
  }
});

```

---

## Related Documentation

### Campaign Features

- **[Campaign Management](/docs/features/campaigns/campaign-management/hub)** - Campaign creation and management

- **[Personalization System](/docs/features/campaigns/personalization-system)** - Dynamic email personalization

- **[Email Sequences](/docs/features/campaigns/email-sequences)** - Multi-step campaigns

### Analytics

- **[Core Analytics](/docs/features/analytics/core-analytics/overview)** - Performance metrics

- **[Enhanced Analytics](/docs/features/analytics/enhanced-analytics/overview)** - Advanced metrics (Q1 2026)

### Technical

- **[Email Pipeline](/docs/features/queue/email-pipeline)** - Email sending infrastructure

- **[API Architecture](/docs/implementation-technical/api/tenant-api/campaigns)** - Campaign APIs

---

**Last Updated:** November 25, 2025
**Status:** Planned - MVP Feature (Level 2)
**Target Release:** Q1 2026
**Owner:** Campaigns Team
