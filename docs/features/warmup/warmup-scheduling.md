---
title: "Warmup Scheduling"
description: "Automated email warmup with gradual volume ramping, domain/IP strategies, engagement simulation, and progress tracking"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q3 2026"
priority: "High"
related_features:

  - warmup/warmup-management

  - warmup/reputation-monitoring

  - domains/domain-management

  - infrastructure/email-infrastructure-setup
related_tasks:

  - epic-4-warmup-deliverability
---

# Warmup Scheduling

**Quick Access**: Automatically warm up new email accounts and domains with intelligent scheduling, gradual volume increases, and engagement simulation to build sender reputation.

## Overview

Warmup Scheduling automates the process of establishing sender reputation for new email accounts and domains. The system gradually increases sending volume while simulating natural engagement patterns to avoid spam filters and build trust with email providers.

### Key Capabilities

- **Automated Warmup Schedules**: Pre-configured ramp-up plans

- **Gradual Volume Ramping**: Increase sends progressively over 4-8 weeks

- **Domain & IP Warmup**: Separate strategies for domains and dedicated IPs

- **Engagement Simulation**: Automated opens, clicks, and replies

- **Progress Tracking**: Real-time warmup status and metrics

- **Custom Schedules**: Tailor warmup plans to your needs

- **Multi-Account Warmup**: Warm up multiple accounts simultaneously

- **Safety Limits**: Automatic throttling to prevent reputation damage

---

## Level 1: Quick Start Guide

### Start Your First Warmup

#### Step 1: Select Email Account

```text

Warmup â†’ Start New Warmup

Select Email Account:
  â—‹ sarah@penguinmails.com (Connected 2 days ago)
  â—‹ support@penguinmails.com (Connected 1 day ago)
  â— sales@penguinmails.com (Connected today)

Account Status:
  Domain: penguinmails.com
  Provider: Google Workspace
  Age: New (0 days)
  Current Reputation: Unknown

[Continue â†’]

```

#### Step 2: Choose Warmup Plan

```text

Select Warmup Plan:

â— Standard Warmup (Recommended)
  Duration: 6 weeks
  Starting Volume: 10 emails/day
  Peak Volume: 500 emails/day
  Best for: Most use cases

â—‹ Aggressive Warmup
  Duration: 4 weeks
  Starting Volume: 20 emails/day
  Peak Volume: 1,000 emails/day
  Best for: Established domains, urgent needs

â—‹ Conservative Warmup
  Duration: 8 weeks
  Starting Volume: 5 emails/day
  Peak Volume: 300 emails/day
  Best for: New domains, high-value reputation

â—‹ Custom Plan
  Configure your own schedule

[Continue â†’]

```

#### Step 3: Configure Settings

```text

Warmup Configuration

Engagement Simulation:
  â˜‘ Simulate opens (70% open rate target)
  â˜‘ Simulate clicks (15% click rate target)
  â˜‘ Simulate replies (5% reply rate target)
  â˜ Simulate forwards (2% forward rate)

Warmup Pool:
  â— Use PenguinMails warmup network (Recommended)

    - 10,000+ verified warmup accounts

    - Automatic engagement

    - Best deliverability

  â—‹ Use custom warmup list

    - Upload your own contacts

    - Manual engagement required

Safety Settings:
  â˜‘ Auto-pause on bounce rate > 5%
  â˜‘ Auto-pause on spam complaints > 0.1%
  â˜‘ Daily send limit: 500 emails

[Start Warmup]

```

#### Step 4: Warmup Running

```text

Warmup Progress: sales@penguinmails.com

Status: âœ“ Active (Day 3 of 42)

Today's Activity:
  Scheduled: 30 emails
  Sent: 28 emails
  Delivered: 28 emails (100%)
  Opened: 21 emails (75%)
  Clicked: 5 emails (18%)
  Replied: 2 emails (7%)

Progress:
  Week 1: â–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘ 21% (Day 3/7)

  Current Volume: 30/day
  Target Volume: 500/day

Next Milestone:
  Day 7: Increase to 50 emails/day

Health Score: 95/100 âœ“ Excellent

[View Details] [Pause Warmup] [Adjust Schedule]

```

### Understanding Warmup Phases

#### Phase 1: Foundation (Week 1-2)

```text

Days 1-14: Building Initial Reputation

Daily Volume: 10 â†’ 100 emails/day
Focus: Establish sending pattern

Activities:

  - Send to warmup pool only

  - High engagement simulation (70%+ opens)

  - Consistent sending times

  - Monitor bounce rates closely

Goals:
  âœ“ Zero spam complaints
  âœ“ Bounce rate < 2%
  âœ“ Consistent delivery
  âœ“ Positive engagement signals

```

#### Phase 2: Growth (Week 3-4)

```text

Days 15-28: Scaling Volume

Daily Volume: 100 â†’ 300 emails/day
Focus: Gradual increase

Activities:

  - Continue warmup pool (80%)

  - Introduce real contacts (20%)

  - Maintain high engagement

  - Monitor sender reputation

Goals:
  âœ“ Maintain low bounce rate
  âœ“ Build domain reputation
  âœ“ Inbox placement > 90%
  âœ“ No blacklist appearances

```

#### Phase 3: Maturity (Week 5-6)

```text

Days 29-42: Reaching Target Volume

Daily Volume: 300 â†’ 500 emails/day
Focus: Stabilize at target

Activities:

  - Warmup pool (50%)

  - Real contacts (50%)

  - Natural engagement patterns

  - Full campaign readiness

Goals:
  âœ“ Consistent inbox placement
  âœ“ Strong sender reputation
  âœ“ Ready for production campaigns
  âœ“ Established sending patterns

```

### Quick Actions

#### Pause Warmup

```text

Pause Warmup: sales@penguinmails.com

Reason:
  â—‹ Temporary hold (will resume)
  â—‹ Reputation issue detected
  â— Manual review needed
  â—‹ Other

Resume Plan:
  â—‹ Resume from current day
  â— Restart current week
  â—‹ Restart from beginning

[Pause Warmup]

```

#### Adjust Schedule

```text

Adjust Warmup Schedule

Current: Day 15 of 42
Current Volume: 100 emails/day
Target Volume: 500 emails/day

Adjustment:
  â—‹ Speed up (reach target in 3 weeks)
  â— Slow down (extend to 8 weeks total)
  â—‹ Maintain current pace

New Schedule:
  Week 3-4: 100 â†’ 150 emails/day
  Week 5-6: 150 â†’ 250 emails/day
  Week 7-8: 250 â†’ 500 emails/day

[Apply Changes]

```

---

## Level 2: Advanced Warmup Strategies

### Custom Warmup Schedules

#### Create Custom Plan

```yaml
custom_warmup_plan:
  name: "Enterprise Warmup - High Volume"
  duration: 56  # days

  phases:

    - name: "Foundation"
      days: 1-14
      daily_volume:
        start: 20
        end: 150
        increment: 10  # per day

      engagement_targets:
        open_rate: 75
        click_rate: 18
        reply_rate: 8

      pool_distribution:
        warmup_pool: 100
        real_contacts: 0

    - name: "Growth"
      days: 15-35
      daily_volume:
        start: 150
        end: 600
        increment: 25

      engagement_targets:
        open_rate: 65
        click_rate: 15
        reply_rate: 5

      pool_distribution:
        warmup_pool: 70
        real_contacts: 30

    - name: "Maturity"
      days: 36-56
      daily_volume:
        start: 600
        end: 2000
        increment: 70

      engagement_targets:
        open_rate: 55
        click_rate: 12
        reply_rate: 3

      pool_distribution:
        warmup_pool: 40
        real_contacts: 60

  safety_rules:
    max_bounce_rate: 3
    max_spam_rate: 0.1
    max_daily_increase: 100
    pause_on_blacklist: true

```

### Domain vs IP Warmup

#### Domain Warmup Strategy

```text

Domain Warmup: penguinmails.com

Strategy: New Domain
Duration: 6-8 weeks
Focus: Build domain reputation

Week 1-2: Foundation

  - Use shared IPs

  - Low volume (10-100/day)

  - High engagement simulation

  - SPF, DKIM, DMARC verification

Week 3-4: Growth

  - Gradually increase volume

  - Monitor domain reputation

  - Check blacklist status

  - Maintain engagement

Week 5-6: Scaling

  - Reach target volume

  - Mix warmup + real contacts

  - Monitor inbox placement

Week 7-8: Stabilization

  - Consistent high volume

  - Production-ready

  - Ongoing monitoring

```

#### Dedicated IP Warmup

```text

IP Warmup: 192.0.2.100

Strategy: New Dedicated IP
Duration: 4-6 weeks
Focus: Build IP reputation

Week 1: Start Slow

  - 50-200 emails/day

  - Use existing warm domain

  - High engagement only

  - Monitor IP reputation

Week 2-3: Gradual Increase

  - 200-1,000 emails/day

  - Consistent sending times

  - Maintain engagement

  - Check IP blacklists

Week 4-6: Full Volume

  - 1,000-5,000+ emails/day

  - Production campaigns

  - Ongoing monitoring

  - Reputation maintenance

```

### Engagement Simulation

#### Warmup Pool Network

```text

PenguinMails Warmup Network

Network Size: 12,847 active accounts
Coverage: 50+ email providers

  - Gmail: 4,200 accounts

  - Outlook: 2,800 accounts

  - Yahoo: 1,500 accounts

  - Apple Mail: 1,200 accounts

  - Other: 3,147 accounts

Engagement Patterns:

  - Opens: 65-80% (randomized timing)

  - Clicks: 12-20% (varied links)

  - Replies: 3-8% (automated responses)

  - Spam reports: 0%

  - Bounces: < 0.5%

Behavior Simulation:
  â˜‘ Random open times (not instant)
  â˜‘ Varied click patterns
  â˜‘ Natural reply delays (2-48 hours)
  â˜‘ Different devices (mobile, desktop)
  â˜‘ Geographic diversity

```

#### Custom Warmup List

```text

Upload Custom Warmup List

Requirements:

  - Minimum 100 contacts

  - Valid email addresses

  - Willing to engage (opens, clicks, replies)

  - Low bounce/spam risk

Upload CSV:
  email, first_name, will_open, will_click, will_reply
  john@example.com, John, yes, yes, no
  jane@example.com, Jane, yes, no, no

Engagement Configuration:
  Expected Open Rate: 60%
  Expected Click Rate: 10%
  Expected Reply Rate: 2%

[Upload List]

âš  Note: Manual engagement required
   You must coordinate with these contacts

```

### Multi-Account Warmup

#### Bulk Warmup Management

```text

Warmup Dashboard

Active Warmups: 5

Account                    Status    Day    Volume    Health
â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”â”
sales@penguinmails.com     âœ“ Active  15/42  100/day   95/100
support@penguinmails.com   âœ“ Active  8/42   50/day    92/100
hello@penguinmails.com     â¸ Paused  22/42  200/day   78/100
team@penguinmails.com      âœ“ Active  35/42  400/day   88/100
info@penguinmails.com      âš  Warning 12/42  80/day    65/100

Bulk Actions:
  [Pause All] [Resume All] [Export Report]

Alerts:
  âš  info@penguinmails.com: Bounce rate elevated (4.2%)
  â„¹ hello@penguinmails.com: Paused for manual review

```

### Warmup Analytics

#### Progress Tracking

```text

Warmup Analytics: sales@penguinmails.com

Overall Progress: 36% (Day 15/42)

Volume Progression:
  Day 1:   10 emails â–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Day 5:   30 emails â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Day 10:  60 emails â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Day 15: 100 emails â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘
  Target: 500 emails â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ

Engagement Metrics:
  Open Rate:  72% âœ“ (Target: 70%)
  Click Rate: 16% âœ“ (Target: 15%)
  Reply Rate:  6% âœ“ (Target: 5%)

Deliverability:
  Inbox Rate: 94% âœ“
  Spam Rate:   3% âœ“
  Bounce Rate: 1.2% âœ“

Reputation Score:
  Domain: 85/100 (Good)
  IP: 78/100 (Fair)
  Overall: 82/100 (Good)

Trend: â†— Improving

```

#### Comparative Analysis

```text

Warmup Comparison

Account A: sales@penguinmails.com
  Day 15: 100/day, Health: 95

Account B: support@penguinmails.com
  Day 15: 80/day, Health: 88

Difference:

  - Account A: Faster ramp-up

  - Account B: More conservative

  - Both: On track for target

Recommendation:
  Continue current pace for both accounts

```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Warmup schedules
CREATE TABLE warmup_schedules (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  email_account_id UUID NOT NULL REFERENCES email_accounts(id),

  -- Schedule configuration
  schedule_name VARCHAR(255),
  schedule_type VARCHAR(50),  -- standard, aggressive, conservative, custom

  -- Duration
  total_days INTEGER,
  current_day INTEGER DEFAULT 1,

  -- Volume settings
  start_volume INTEGER,
  target_volume INTEGER,
  current_volume INTEGER,

  -- Engagement targets
  target_open_rate DECIMAL(5,2),
  target_click_rate DECIMAL(5,2),
  target_reply_rate DECIMAL(5,2),

  -- Pool distribution
  warmup_pool_percentage INTEGER DEFAULT 100,
  real_contacts_percentage INTEGER DEFAULT 0,

  -- Status
  status VARCHAR(50),  -- active, paused, completed, failed
  started_at TIMESTAMP,
  paused_at TIMESTAMP,
  completed_at TIMESTAMP,

  -- Safety settings
  max_bounce_rate DECIMAL(5,2) DEFAULT 5.0,
  max_spam_rate DECIMAL(5,2) DEFAULT 0.1,
  auto_pause_enabled BOOLEAN DEFAULT TRUE,

  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_warmup_schedules_account ON warmup_schedules(email_account_id);
CREATE INDEX idx_warmup_schedules_status ON warmup_schedules(status);

-- Warmup daily logs
CREATE TABLE warmup_daily_logs (
  id UUID PRIMARY KEY,
  warmup_schedule_id UUID NOT NULL REFERENCES warmup_schedules(id),

  -- Date
  log_date DATE NOT NULL,
  day_number INTEGER,

  -- Volume
  scheduled_volume INTEGER,
  sent_count INTEGER DEFAULT 0,
  delivered_count INTEGER DEFAULT 0,

  -- Engagement
  opens INTEGER DEFAULT 0,
  clicks INTEGER DEFAULT 0,
  replies INTEGER DEFAULT 0,

  -- Deliverability
  bounces INTEGER DEFAULT 0,
  spam_complaints INTEGER DEFAULT 0,

  -- Rates
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),
  reply_rate DECIMAL(5,2),
  bounce_rate DECIMAL(5,2),
  spam_rate DECIMAL(5,2),

  -- Health
  health_score INTEGER,

  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(warmup_schedule_id, log_date)
);

CREATE INDEX idx_warmup_logs_schedule ON warmup_daily_logs(warmup_schedule_id, log_date);

-- Warmup pool accounts
CREATE TABLE warmup_pool_accounts (
  id UUID PRIMARY KEY,

  email VARCHAR(255) NOT NULL UNIQUE,
  provider VARCHAR(100),  -- gmail, outlook, yahoo, etc.

  -- Engagement settings
  will_open BOOLEAN DEFAULT TRUE,
  will_click BOOLEAN DEFAULT TRUE,
  will_reply BOOLEAN DEFAULT FALSE,

  -- Behavior
  open_delay_min INTEGER DEFAULT 5,  -- minutes
  open_delay_max INTEGER DEFAULT 120,
  click_probability DECIMAL(3,2) DEFAULT 0.15,
  reply_probability DECIMAL(3,2) DEFAULT 0.05,

  -- Status
  is_active BOOLEAN DEFAULT TRUE,
  last_engaged_at TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_warmup_pool_provider ON warmup_pool_accounts(provider);
CREATE INDEX idx_warmup_pool_active ON warmup_pool_accounts(is_active);

-- Warmup events
CREATE TABLE warmup_events (
  id UUID PRIMARY KEY,
  warmup_schedule_id UUID NOT NULL REFERENCES warmup_schedules(id),

  event_type VARCHAR(50),  -- sent, opened, clicked, replied, bounced, spam
  event_data JSONB,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_warmup_events_schedule ON warmup_events(warmup_schedule_id, created_at);

```

### Warmup Service

```typescript
interface WarmupConfig {
  scheduleType: 'standard' | 'aggressive' | 'conservative' | 'custom';
  totalDays: number;
  startVolume: number;
  targetVolume: number;
  targetOpenRate: number;
  targetClickRate: number;
  targetReplyRate: number;
  warmupPoolPercentage: number;
}

class WarmupService {
  async startWarmup(
    emailAccountId: string,
    config: WarmupConfig
  ): Promise<WarmupSchedule> {
    const schedule = await db.warmupSchedules.create({
      emailAccountId,
      scheduleType: config.scheduleType,
      totalDays: config.totalDays,
      currentDay: 1,
      startVolume: config.startVolume,
      targetVolume: config.targetVolume,
      currentVolume: config.startVolume,
      targetOpenRate: config.targetOpenRate,
      targetClickRate: config.targetClickRate,
      targetReplyRate: config.targetReplyRate,
      warmupPoolPercentage: config.warmupPoolPercentage,
      realContactsPercentage: 100 - config.warmupPoolPercentage,
      status: 'active',
      startedAt: new Date(),
    });

    // Schedule first day's warmup emails
    await this.scheduleDailyWarmup(schedule.id);

    return schedule;
  }

  async scheduleDailyWarmup(scheduleId: string): Promise<void> {
    const schedule = await db.warmupSchedules.findById(scheduleId);

    if (schedule.status !== 'active') {
      return;
    }

    // Calculate today's volume
    const dailyVolume = this.calculateDailyVolume(schedule);

    // Get warmup pool accounts
    const warmupCount = Math.floor(dailyVolume * (schedule.warmupPoolPercentage / 100));
    const realCount = dailyVolume - warmupCount;

    const warmupAccounts = await this.getWarmupPoolAccounts(warmupCount);
    const realContacts = await this.getRealContacts(schedule.tenantId, realCount);

    // Create warmup emails
    for (const account of warmupAccounts) {
      await this.createWarmupEmail(schedule, account, 'warmup_pool');
    }

    for (const contact of realContacts) {
      await this.createWarmupEmail(schedule, contact, 'real_contact');
    }

    // Log daily activity
    await db.warmupDailyLogs.create({
      warmupScheduleId: scheduleId,
      logDate: new Date(),
      dayNumber: schedule.currentDay,
      scheduledVolume: dailyVolume,
    });
  }

  private calculateDailyVolume(schedule: WarmupSchedule): number {
    const { currentDay, totalDays, startVolume, targetVolume } = schedule;

    // Linear ramp-up
    const volumeIncrease = (targetVolume - startVolume) / totalDays;
    const dailyVolume = Math.floor(startVolume + (volumeIncrease * currentDay));

    return Math.min(dailyVolume, targetVolume);
  }

  private async getWarmupPoolAccounts(count: number): Promise<any[]> {
    return await db.warmupPoolAccounts.findAll({
      where: { isActive: true },
      order: db.sequelize.random(),
      limit: count,
    });
  }

  private async getRealContacts(tenantId: string, count: number): Promise<any[]> {
    // Get engaged contacts with good history
    return await db.contacts.findAll({
      where: {
        tenantId,
        isActive: true,
        bounceType: null,
        unsubscribedAt: null,
      },
      order: [['lastActivityAt', 'DESC']],
      limit: count,
    });
  }

  private async createWarmupEmail(
    schedule: WarmupSchedule,
    recipient: any,
    type: 'warmup_pool' | 'real_contact'
  ): Promise<void> {
    // Create email with warmup template
    const email = await emailQueue.add('send-warmup-email', {
      scheduleId: schedule.id,
      emailAccountId: schedule.emailAccountId,
      recipientEmail: recipient.email,
      recipientType: type,
      subject: this.generateWarmupSubject(),
      body: this.generateWarmupBody(recipient),
    });
  }

  private generateWarmupSubject(): string {
    const subjects = [
      'Quick question',
      'Following up',
      'Checking in',
      'Hope you\'re well',
      'Quick update',
    ];

    return subjects[Math.floor(Math.random() * subjects.length)];
  }

  private generateWarmupBody(recipient: any): string {
    return `
      Hi ${recipient.firstName || 'there'},

      Hope this email finds you well. Just wanted to check in and see how things are going.

      Let me know if you have any questions!

      Best regards
    `;
  }

  async simulateEngagement(
    emailId: string,
    recipientType: string
  ): Promise<void> {
    if (recipientType !== 'warmup_pool') {
      return;
    }

    const email = await db.emails.findById(emailId);
    const poolAccount = await db.warmupPoolAccounts.findOne({
      where: { email: email.recipientEmail },
    });

    // Simulate open
    if (poolAccount.willOpen) {
      const openDelay = this.randomDelay(
        poolAccount.openDelayMin,
        poolAccount.openDelayMax
      );

      setTimeout(async () => {
        await this.trackOpen(emailId);

        // Simulate click
        if (Math.random() < poolAccount.clickProbability) {
          const clickDelay = this.randomDelay(1, 30);
          setTimeout(() => this.trackClick(emailId), clickDelay * 60 * 1000);
        }

        // Simulate reply
        if (Math.random() < poolAccount.replyProbability) {
          const replyDelay = this.randomDelay(60, 2880);  // 1-48 hours
          setTimeout(() => this.sendReply(emailId), replyDelay * 60 * 1000);
        }
      }, openDelay * 60 * 1000);
    }
  }

  private randomDelay(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  }

  async checkWarmupHealth(scheduleId: string): Promise<void> {
    const schedule = await db.warmupSchedules.findById(scheduleId);
    const todayLog = await db.warmupDailyLogs.findOne({
      where: {
        warmupScheduleId: scheduleId,
        logDate: new Date().toISOString().split('T')[0],
      },
    });

    if (!todayLog) return;

    // Check bounce rate
    if (todayLog.bounceRate > schedule.maxBounceRate) {
      await this.pauseWarmup(scheduleId, 'High bounce rate detected');
      return;
    }

    // Check spam rate
    if (todayLog.spamRate > schedule.maxSpamRate) {
      await this.pauseWarmup(scheduleId, 'Spam complaints detected');
      return;
    }

    // Calculate health score
    const healthScore = this.calculateHealthScore(todayLog);

    await db.warmupDailyLogs.update(todayLog.id, { healthScore });
  }

  private calculateHealthScore(log: any): number {
    let score = 100;

    // Penalize for bounces
    score -= log.bounceRate * 10;

    // Penalize for spam
    score -= log.spamRate * 50;

    // Reward for engagement
    score += (log.openRate / 100) * 20;
    score += (log.clickRate / 100) * 10;

    return Math.max(0, Math.min(100, Math.floor(score)));
  }

  async pauseWarmup(scheduleId: string, reason: string): Promise<void> {
    await db.warmupSchedules.update(scheduleId, {
      status: 'paused',
      pausedAt: new Date(),
    });

    // Send alert
    await this.sendWarmupAlert(scheduleId, reason);
  }
}

```

### Background Jobs

```typescript
// Daily warmup scheduler
cron.schedule('0 9 * * *', async () => {  // 9 AM daily
  const activeSchedules = await db.warmupSchedules.findAll({
    where: { status: 'active' },
  });

  const service = new WarmupService();

  for (const schedule of activeSchedules) {
    await service.scheduleDailyWarmup(schedule.id);

    // Increment day
    await db.warmupSchedules.update(schedule.id, {
      currentDay: schedule.currentDay + 1,
    });

    // Check if completed
    if (schedule.currentDay >= schedule.totalDays) {
      await db.warmupSchedules.update(schedule.id, {
        status: 'completed',
        completedAt: new Date(),
      });
    }
  }
});

// Health check every hour
cron.schedule('0 * * * *', async () => {
  const activeSchedules = await db.warmupSchedules.findAll({
    where: { status: 'active' },
  });

  const service = new WarmupService();

  for (const schedule of activeSchedules) {
    await service.checkWarmupHealth(schedule.id);
  }
});

```

### API Endpoints

```typescript
// Start warmup
app.post('/api/warmup/start', authenticate, async (req, res) => {
  const service = new WarmupService();

  const schedule = await service.startWarmup(
    req.body.emailAccountId,
    req.body.config
  );

  return res.json(schedule);
});

// Get warmup status
app.get('/api/warmup/:id', authenticate, async (req, res) => {
  const schedule = await db.warmupSchedules.findById(req.params.id);
  const logs = await db.warmupDailyLogs.findAll({
    where: { warmupScheduleId: req.params.id },
    order: [['logDate', 'DESC']],
    limit: 30,
  });

  return res.json({ schedule, logs });
});

// Pause warmup
app.post('/api/warmup/:id/pause', authenticate, async (req, res) => {
  const service = new WarmupService();
  await service.pauseWarmup(req.params.id, req.body.reason);

  return res.json({ success: true });
});

// Resume warmup
app.post('/api/warmup/:id/resume', authenticate, async (req, res) => {
  await db.warmupSchedules.update(req.params.id, {
    status: 'active',
    pausedAt: null,
  });

  return res.json({ success: true });
});

```

---

## Related Documentation

- **[Email Warmups](/docs/features/warmup/email-warmups/overview)** - Overall warmup strategy

- **[Reputation Monitoring](/docs/features/warmup/reputation-monitoring)** - Track sender reputation

- **[Domain Management](/docs/features/domains/domain-management)** - Domain configuration

- **[Email Infrastructure](/docs/features/infrastructure/email-infrastructure-setup)** - SMTP setup

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q3 2026
**Owner:** Deliverability Team
