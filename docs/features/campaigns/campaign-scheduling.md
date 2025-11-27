---
title: "Campaign Scheduling"
description: "Advanced campaign scheduling with timezone handling, send-time optimization, and calendar integration"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:


  - campaigns/campaign-management/overview


  - campaigns/ab-testing


  - leads/contact-segmentation
related_tasks:


  - epic-6-core-email-pipeline
---


# Campaign Scheduling

**Quick Access**: Schedule campaigns with precision using timezone-aware scheduling, AI-powered send-time optimization, and calendar integration for maximum engagement.


## Overview

Campaign Scheduling enables precise control over when your emails are sent, with intelligent features like timezone-aware delivery, send-time optimization based on recipient behavior, business hours enforcement, and calendar integration. Maximize engagement by reaching contacts at their optimal times.


### Key Capabilities


- **Timezone-Aware Scheduling**: Send emails at the perfect local time for each recipient


- **Send-Time Optimization**: AI-powered optimal send time based on historical engagement


- **Business Hours Enforcement**: Automatically respect business hours and skip weekends


- **Calendar Integration**: Sync with Google Calendar and Outlook for event-based campaigns


- **Recurring Campaigns**: Set up daily, weekly, or monthly recurring schedules


- **Batch Scheduling**: Schedule multiple campaigns at once with smart conflict resolution

---


## Level 1: Quick Start Guide


### Schedule Your First Campaign


#### Step 1: Basic Scheduling


```

Campaign Builder → Schedule Tab

┌─────────────────────────────────────────────────────┐
│ When should this campaign be sent?                  │
│                                                     │
│ ○ Send immediately                                  │
│ ● Schedule for later                                │
│                                                     │
│ Date: [Nov 26, 2025 ▼]                             │
│ Time: [09:00 AM ▼]                                  │
│ Timezone: [America/New_York ▼]                      │
│                                                     │
│ Preview: Sends on Monday, Nov 26 at 9:00 AM EST     │
└─────────────────────────────────────────────────────┘


```


#### Step 2: Timezone Options

**Single Timezone (Simple):**


```

All contacts receive email at:
9:00 AM Eastern Time (EST)

Example:


- Contact in New York: 9:00 AM EST


- Contact in Los Angeles: 6:00 AM PST


- Contact in London: 2:00 PM GMT


```

**Recipient Timezone (Smart):**


```

Each contact receives email at their local time:
9:00 AM in their timezone

Example:


- Contact in New York: 9:00 AM EST


- Contact in Los Angeles: 9:00 AM PST


- Contact in London: 9:00 AM GMT


```


#### Step 3: Business Hours

**Enable Business Hours Protection:**


```

┌─────────────────────────────────────────────────────┐
│ Business Hours Settings                             │
│                                                     │
│ ☑ Only send during business hours                   │
│                                                     │
│ Business Hours:                                     │
│ Monday-Friday: 9:00 AM - 5:00 PM                    │
│                                                     │
│ ☑ Skip weekends                                     │
│ ☑ Skip holidays (US calendar)                       │
│                                                     │
│ If outside business hours:                          │
│ ● Delay until next business day                     │
│ ○ Send anyway                                       │
└─────────────────────────────────────────────────────┘


```

**Result:**


```

Scheduled: Saturday, Nov 23 at 3:00 PM
Actual Send: Monday, Nov 25 at 9:00 AM

(Delayed to next business day)


```


### Recurring Campaigns


#### Daily Newsletter


```

Recurrence Pattern:
┌─────────────────────────────────────────────────────┐
│ Frequency: ● Daily                                  │
│                                                     │
│ Send at: 8:00 AM                                    │
│ Timezone: Recipient's local time                    │
│                                                     │
│ Days: ☑ Mon ☑ Tue ☑ Wed ☑ Thu ☑ Fri                │
│       ☐ Sat ☐ Sun                                   │
│                                                     │
│ Start: Nov 25, 2025                                 │
│ End: ○ Never  ● After 30 occurrences                │
└─────────────────────────────────────────────────────┘

Preview:


- First send: Monday, Nov 25 at 8:00 AM


- Next 5 sends: Nov 26, 27, 28, 29, Dec 2


- Total sends: 30 (weekdays only)


```


#### Weekly Report


```

Recurrence Pattern:
┌─────────────────────────────────────────────────────┐
│ Frequency: ● Weekly                                 │
│                                                     │
│ Send every: [1] week(s) on:                         │
│ ☐ Mon ☐ Tue ☐ Wed ☐ Thu ☑ Fri ☐ Sat ☐ Sun         │
│                                                     │
│ Send at: 10:00 AM EST                               │
│                                                     │
│ Start: Nov 29, 2025                                 │
│ End: ○ Never  ● On date: Dec 31, 2025              │
└─────────────────────────────────────────────────────┘

Preview:


- Sends every Friday at 10:00 AM


- Next 3 sends: Nov 29, Dec 6, Dec 13


```


### Quick Schedule Templates

**Pre-Built Schedule Patterns:**


```

Common Patterns:
┌─────────────────────────────────────────────────────┐
│ 📅 Morning Blast (9 AM, recipient timezone)         │
│ 🌆 Afternoon Update (2 PM, recipient timezone)      │
│ 📰 Daily Newsletter (8 AM, weekdays only)           │
│ 📊 Weekly Report (Friday 10 AM)                     │
│ 📅 Monthly Update (1st of month, 9 AM)              │
│ 🎯 Optimal Time (AI-powered, per contact)           │
└─────────────────────────────────────────────────────┘


```

---


## Level 2: Advanced Scheduling


### Send-Time Optimization


#### AI-Powered Optimal Timing

**How It Works:**


```

For each contact, analyze:


1. Historical open times (when they opened past emails)


2. Historical click times (when they clicked links)


3. Industry benchmarks (typical engagement times)


4. Day-of-week patterns (best days for this contact)

Result: Personalized send time for maximum engagement


```

**Configuration:**


```yaml
send_time_optimization:
  enabled: true
  strategy: "engagement_based"
  
  data_sources:


    - historical_opens: weight 40%


    - historical_clicks: weight 30%


    - industry_benchmarks: weight 20%


    - day_patterns: weight 10%
  
  constraints:
    min_data_points: 5  # Require 5+ past interactions
    fallback_time: "09:00"
    optimization_window:
      start: "06:00"
      end: "20:00"
    respect_business_hours: true


```

**Example Results:**


```

Contact A (Software Developer):
  Historical pattern: Opens emails at 7:30 AM
  Optimal send time: 7:15 AM (15 min before typical open)
  
Contact B (Executive):
  Historical pattern: Opens emails at 2:00 PM
  Optimal send time: 1:45 PM
  
Contact C (No history):
  Fallback: Industry benchmark (9:00 AM)


```


### Advanced Timezone Handling


#### Multi-Region Campaigns

**Coordinate Across Timezones:**


```yaml
timezone_strategy:
  mode: "coordinated_rollout"
  
  # Start in earliest timezone, roll west
  rollout_pattern:
    start_timezone: "Pacific/Auckland"  # New Zealand (UTC+13)
    start_time: "09:00"
    
    # Automatically calculate send times for other zones
    auto_calculate: true
    
  regions:


    - name: "APAC"
      timezones: ["Pacific/Auckland", "Australia/Sydney", "Asia/Tokyo"]
      send_time: "09:00 local"
      


    - name: "EMEA"
      timezones: ["Europe/London", "Europe/Paris", "Europe/Moscow"]
      send_time: "09:00 local"
      


    - name: "Americas"
      timezones: ["America/New_York", "America/Chicago", "America/Los_Angeles"]
      send_time: "09:00 local"


```

**Result:**


```

Global Campaign Rollout:
09:00 NZDT (Auckland)    → Nov 25, 9:00 AM
09:00 AEDT (Sydney)      → Nov 25, 9:00 AM (1 hr later)
09:00 JST (Tokyo)        → Nov 25, 9:00 AM (2 hrs later)
09:00 GMT (London)       → Nov 25, 9:00 AM (9 hrs later)
09:00 EST (New York)     → Nov 25, 9:00 AM (14 hrs later)
09:00 PST (Los Angeles)  → Nov 25, 9:00 AM (17 hrs later)

Total rollout window: 17 hours
All contacts receive at their local 9 AM


```


#### Daylight Saving Time Handling

**Automatic DST Adjustment:**


```yaml
dst_handling:
  auto_adjust: true
  
  # When DST changes occur
  transition_behavior:
    spring_forward:  # Clocks move ahead 1 hour
      action: "delay_1_hour"
      reason: "Maintain same wall-clock time"
      
    fall_back:  # Clocks move back 1 hour
      action: "advance_1_hour"
      reason: "Avoid duplicate sends"


```

**Example:**


```

Campaign scheduled: 9:00 AM EST
DST transition: March 10, 2024 (spring forward)

Before DST: 9:00 AM EST (UTC-5)
After DST:  9:00 AM EDT (UTC-4)

System automatically adjusts to maintain 9:00 AM local time


```


### Calendar Integration


#### Google Calendar Sync

**Event-Based Campaigns:**


```yaml
calendar_integration:
  provider: "google_calendar"
  calendar_id: "primary"
  
  trigger_rules:


    - event_type: "webinar"
      campaign_template: "webinar_reminder"
      send_before: "1 hour"
      


    - event_type: "meeting"
      campaign_template: "meeting_followup"
      send_after: "2 hours"
      


    - event_type: "product_launch"
      campaign_template: "launch_announcement"
      send_at: "event_start"


```

**Example Workflow:**


```

Google Calendar Event Created:
  Title: "Product Launch Webinar"
  Date: Dec 1, 2025 at 2:00 PM EST
  
Automatic Campaign Triggers:


  1. Reminder email: Dec 1 at 1:00 PM (1 hour before)


  2. Join link email: Dec 1 at 1:55 PM (5 min before)


  3. Follow-up email: Dec 1 at 4:00 PM (2 hours after)


  4. Recording email: Dec 2 at 9:00 AM (next day)


```


#### Outlook Integration

**Meeting-Based Automation:**


```yaml
outlook_integration:
  enabled: true
  
  sync_calendars:


    - "Sales Team Calendar"


    - "Marketing Events"
  
  automation_rules:


    - calendar: "Sales Team Calendar"
      event_contains: "Demo"
      action:
        send_campaign: "demo_followup"
        delay: "1 day"
        


    - calendar: "Marketing Events"
      event_contains: "Conference"
      action:
        send_campaign: "conference_recap"
        delay: "3 days"


```


### Batch Scheduling


#### Schedule Multiple Campaigns

**Bulk Schedule Interface:**


```

Batch Scheduler:
┌─────────────────────────────────────────────────────┐
│ Selected Campaigns: 5                               │
│                                                     │
│ ☑ Welcome Series                                    │
│ ☑ Product Update                                    │
│ ☑ Feature Announcement                              │
│ ☑ Customer Survey                                   │
│ ☑ Re-engagement Campaign                            │
│                                                     │
│ Schedule Pattern:                                   │
│ ● Stagger sends (recommended)                       │
│   Interval: [2] hours between campaigns             │
│   Start: Nov 25, 9:00 AM                            │
│                                                     │
│ ○ Send all at once                                  │
│   Time: Nov 25, 9:00 AM                             │
│                                                     │
│ Conflict Resolution:                                │
│ ● Skip contacts in multiple campaigns               │
│ ○ Send to all (may receive multiple emails)         │
└─────────────────────────────────────────────────────┘

Preview:
Campaign 1: Nov 25, 9:00 AM
Campaign 2: Nov 25, 11:00 AM
Campaign 3: Nov 25, 1:00 PM
Campaign 4: Nov 25, 3:00 PM
Campaign 5: Nov 25, 5:00 PM


```


#### Smart Conflict Resolution

**Prevent Email Fatigue:**


```typescript
interface ConflictResolution {
  rules: {
    max_emails_per_day: 2;
    min_hours_between: 4;
    priority_based: true;
  };
  
  actions: {
    when_conflict: 'delay_lower_priority';
    delay_duration: '24 hours';
    max_delays: 3;
    after_max_delays: 'skip';
  };
}


```

**Example:**


```

Contact receives:


- Campaign A (Priority: High) at 9:00 AM


- Campaign B (Priority: Medium) scheduled 11:00 AM


- Campaign C (Priority: Low) scheduled 2:00 PM

Conflict Resolution:
✓ Campaign A: Sent at 9:00 AM (high priority)
⏸ Campaign B: Delayed to 1:00 PM (4hr minimum gap)
⏸ Campaign C: Delayed to next day (max 2/day limit)

Result:
Nov 25: Campaign A (9 AM), Campaign B (1 PM)
Nov 26: Campaign C (9 AM)


```


### Holiday and Blackout Dates


#### Configure Blackout Periods


```yaml
blackout_dates:
  # US Holidays


  - date: "2025-12-25"
    name: "Christmas Day"
    action: "delay_to_next_business_day"
    


  - date: "2025-01-01"
    name: "New Year's Day"
    action: "delay_to_next_business_day"
  
  # Company blackouts


  - date_range:
      start: "2025-12-24"
      end: "2025-12-26"
    name: "Holiday Break"
    action: "skip"
  
  # Industry events


  - date: "2025-11-28"
    name: "Black Friday"
    action: "allow"  # Override, send anyway


```

**Custom Holiday Calendars:**


```

Holiday Calendar: US Federal + Company
┌─────────────────────────────────────────────────────┐
│ ☑ New Year's Day                                    │
│ ☑ Martin Luther King Jr. Day                        │
│ ☑ Presidents Day                                    │
│ ☑ Memorial Day                                      │
│ ☑ Independence Day                                  │
│ ☑ Labor Day                                         │
│ ☑ Thanksgiving                                      │
│ ☑ Christmas                                         │
│                                                     │
│ Custom Dates:                                       │
│ + Company Anniversary (June 15)                     │
│ + Annual Conference (Oct 10-12)                     │
└─────────────────────────────────────────────────────┘


```

---


## Level 3: Technical Implementation


### Database Schema


```sql
-- Campaign schedules
CREATE TABLE campaign_schedules (
  id UUID PRIMARY KEY,
  campaign_id UUID NOT NULL REFERENCES campaigns(id) ON DELETE CASCADE,
  
  -- Schedule type
  schedule_type VARCHAR(50), -- immediate, scheduled, recurring, optimized
  
  -- Basic scheduling
  scheduled_date DATE,
  scheduled_time TIME,
  timezone VARCHAR(100) DEFAULT 'UTC',
  
  -- Timezone strategy
  timezone_strategy VARCHAR(50), -- single, recipient_local, coordinated
  
  -- Recurrence
  is_recurring BOOLEAN DEFAULT FALSE,
  recurrence_pattern JSONB,
  recurrence_end_date DATE,
  recurrence_count INTEGER,
  
  -- Optimization
  use_send_time_optimization BOOLEAN DEFAULT FALSE,
  optimization_window_start TIME,
  optimization_window_end TIME,
  
  -- Business hours
  respect_business_hours BOOLEAN DEFAULT FALSE,
  business_hours_start TIME DEFAULT '09:00',
  business_hours_end TIME DEFAULT '17:00',
  skip_weekends BOOLEAN DEFAULT FALSE,
  skip_holidays BOOLEAN DEFAULT FALSE,
  
  -- Calendar integration
  calendar_provider VARCHAR(50), -- google, outlook, null
  calendar_event_id VARCHAR(255),
  calendar_trigger_type VARCHAR(50), -- before, after, at
  calendar_trigger_offset INTERVAL,
  
  -- Status
  status VARCHAR(50), -- pending, processing, completed, failed
  last_processed_at TIMESTAMP,
  next_send_at TIMESTAMP,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_campaign_schedules_campaign ON campaign_schedules(campaign_id);
CREATE INDEX idx_campaign_schedules_next_send ON campaign_schedules(next_send_at);
CREATE INDEX idx_campaign_schedules_status ON campaign_schedules(status);

-- Send time rules (for optimization)
CREATE TABLE send_time_rules (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  
  -- Rule configuration
  rule_name VARCHAR(255),
  rule_type VARCHAR(50), -- global, segment, contact
  
  -- Target
  segment_id UUID REFERENCES segments(id),
  contact_id UUID REFERENCES contacts(id),
  
  -- Optimization settings
  optimization_strategy VARCHAR(50), -- engagement_based, industry_benchmark, custom
  min_data_points INTEGER DEFAULT 5,
  fallback_time TIME DEFAULT '09:00',
  
  -- Constraints
  allowed_days JSONB, -- [1,2,3,4,5] for Mon-Fri
  allowed_hours_start TIME,
  allowed_hours_end TIME,
  
  -- Weights for optimization
  open_time_weight DECIMAL(3,2) DEFAULT 0.40,
  click_time_weight DECIMAL(3,2) DEFAULT 0.30,
  industry_weight DECIMAL(3,2) DEFAULT 0.20,
  day_pattern_weight DECIMAL(3,2) DEFAULT 0.10,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_send_time_rules_tenant ON send_time_rules(tenant_id);
CREATE INDEX idx_send_time_rules_segment ON send_time_rules(segment_id);

-- Blackout dates
CREATE TABLE blackout_dates (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  
  -- Date range
  blackout_date DATE,
  blackout_start_date DATE,
  blackout_end_date DATE,
  
  -- Details
  name VARCHAR(255),
  description TEXT,
  blackout_type VARCHAR(50), -- holiday, company_event, industry_event
  
  -- Action
  action VARCHAR(50), -- skip, delay, allow
  
  -- Scope
  applies_to VARCHAR(50), -- all, specific_campaigns
  campaign_ids JSONB,
  
  -- Metadata
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_blackout_dates_tenant ON blackout_dates(tenant_id);
CREATE INDEX idx_blackout_dates_date ON blackout_dates(blackout_date);

-- Contact send time preferences (learned from behavior)
CREATE TABLE contact_send_preferences (
  id UUID PRIMARY KEY,
  contact_id UUID NOT NULL REFERENCES contacts(id),
  
  -- Optimal times (learned)
  optimal_send_time TIME,
  optimal_send_day INTEGER, -- 1-7 for Mon-Sun
  optimal_timezone VARCHAR(100),
  
  -- Historical patterns
  typical_open_times JSONB, -- Array of times when contact opens emails
  typical_click_times JSONB,
  engagement_by_day JSONB, -- Engagement rates by day of week
  engagement_by_hour JSONB, -- Engagement rates by hour
  
  -- Confidence
  data_points_count INTEGER DEFAULT 0,
  confidence_score DECIMAL(3,2), -- 0.00 - 1.00
  
  -- Last updated
  last_calculated_at TIMESTAMP,
  
  UNIQUE(contact_id)
);

CREATE INDEX idx_contact_send_prefs_contact ON contact_send_preferences(contact_id);


```


### Scheduling Service


```typescript
interface CampaignSchedule {
  id: string;
  campaignId: string;
  scheduleType: 'immediate' | 'scheduled' | 'recurring' | 'optimized';
  scheduledDate?: Date;
  scheduledTime?: string;
  timezone: string;
  timezoneStrategy: 'single' | 'recipient_local' | 'coordinated';
  isRecurring: boolean;
  recurrencePattern?: RecurrencePattern;
  useSendTimeOptimization: boolean;
  respectBusinessHours: boolean;
  skipWeekends: boolean;
  skipHolidays: boolean;
}

interface RecurrencePattern {
  frequency: 'daily' | 'weekly' | 'monthly';
  interval: number;
  daysOfWeek?: number[]; // 0-6 for Sun-Sat
  dayOfMonth?: number;
  endDate?: Date;
  occurrences?: number;
}

class CampaignSchedulingService {
  /**


   * Calculate next send time for a campaign
   */
  async calculateNextSendTime(
    schedule: CampaignSchedule,
    contact?: Contact
  ): Promise<Date> {
    let sendTime: Date;
    
    switch (schedule.scheduleType) {
      case 'immediate':
        sendTime = new Date();
        break;
        
      case 'scheduled':
        sendTime = this.parseScheduledTime(schedule);
        break;
        
      case 'recurring':
        sendTime = this.calculateRecurringSendTime(schedule);
        break;
        
      case 'optimized':
        sendTime = await this.calculateOptimalSendTime(contact);
        break;
    }
    
    // Apply timezone strategy
    if (schedule.timezoneStrategy === 'recipient_local' && contact) {
      sendTime = this.adjustForRecipientTimezone(sendTime, contact);
    }
    
    // Apply business hours constraints
    if (schedule.respectBusinessHours) {
      sendTime = this.enforceBusinessHours(sendTime, schedule);
    }
    
    // Check blackout dates
    sendTime = await this.checkBlackoutDates(sendTime, schedule);
    
    return sendTime;
  }
  
  /**


   * Calculate optimal send time based on contact behavior
   */
  private async calculateOptimalSendTime(contact: Contact): Promise<Date> {
    const preferences = await db.contactSendPreferences.findByContact(
      contact.id
    );
    
    if (!preferences || preferences.dataPointsCount < 5) {
      // Not enough data, use fallback
      return this.getDefaultSendTime();
    }
    
    // Use learned optimal time
    const now = new Date();
    const optimal = new Date(now);
    
    // Set to optimal hour
    const [hour, minute] = preferences.optimalSendTime.split(':');
    optimal.setHours(parseInt(hour), parseInt(minute), 0, 0);
    
    // If optimal time has passed today, schedule for tomorrow
    if (optimal < now) {
      optimal.setDate(optimal.getDate() + 1);
    }
    
    // Adjust for optimal day of week if needed
    if (preferences.optimalSendDay) {
      while (optimal.getDay() !== preferences.optimalSendDay) {
        optimal.setDate(optimal.getDate() + 1);
      }
    }
    
    return optimal;
  }
  
  /**


   * Adjust send time for recipient's timezone
   */
  private adjustForRecipientTimezone(
    sendTime: Date,
    contact: Contact
  ): Date {
    const contactTimezone = contact.timezone || 'UTC';
    const campaignTimezone = 'UTC';
    
    // Convert to contact's local time
    const localTime = moment.tz(sendTime, campaignTimezone)
      .tz(contactTimezone)
      .toDate();
    
    return localTime;
  }
  
  /**


   * Enforce business hours constraints
   */
  private enforceBusinessHours(
    sendTime: Date,
    schedule: CampaignSchedule
  ): Date {
    const hour = sendTime.getHours();
    const day = sendTime.getDay();
    
    // Check if weekend
    if (schedule.skipWeekends && (day === 0 || day === 6)) {
      // Move to next Monday
      const daysToAdd = day === 0 ? 1 : 2;
      sendTime.setDate(sendTime.getDate() + daysToAdd);
      sendTime.setHours(9, 0, 0, 0); // 9 AM
      return sendTime;
    }
    
    // Check if outside business hours
    const businessStart = parseInt(schedule.businessHoursStart.split(':')[0]);
    const businessEnd = parseInt(schedule.businessHoursEnd.split(':')[0]);
    
    if (hour < businessStart) {
      // Too early, move to business start
      sendTime.setHours(businessStart, 0, 0, 0);
    } else if (hour >= businessEnd) {
      // Too late, move to next business day
      sendTime.setDate(sendTime.getDate() + 1);
      sendTime.setHours(businessStart, 0, 0, 0);
      
      // Check if next day is weekend
      if (schedule.skipWeekends && sendTime.getDay() === 6) {
        sendTime.setDate(sendTime.getDate() + 2); // Skip to Monday
      }
    }
    
    return sendTime;
  }
  
  /**


   * Check and handle blackout dates
   */
  private async checkBlackoutDates(
    sendTime: Date,
    schedule: CampaignSchedule
  ): Promise<Date> {
    const blackouts = await db.blackoutDates.findForDate(sendTime);
    
    for (const blackout of blackouts) {
      if (blackout.action === 'skip') {
        throw new Error(`Cannot send on blackout date: ${blackout.name}`);
      }
      
      if (blackout.action === 'delay') {
        // Move to next business day
        sendTime.setDate(sendTime.getDate() + 1);
        sendTime.setHours(9, 0, 0, 0);
        
        // Recursively check new date
        return await this.checkBlackoutDates(sendTime, schedule);
      }
    }
    
    return sendTime;
  }
  
  /**


   * Calculate next occurrence for recurring campaign
   */
  private calculateRecurringSendTime(
    schedule: CampaignSchedule
  ): Date {
    const pattern = schedule.recurrencePattern;
    const lastSend = schedule.lastProcessedAt || new Date();
    const nextSend = new Date(lastSend);
    
    switch (pattern.frequency) {
      case 'daily':
        nextSend.setDate(nextSend.getDate() + pattern.interval);
        break;
        
      case 'weekly':
        nextSend.setDate(nextSend.getDate() + (7 * pattern.interval));
        
        // Adjust to correct day of week
        if (pattern.daysOfWeek && pattern.daysOfWeek.length > 0) {
          while (!pattern.daysOfWeek.includes(nextSend.getDay())) {
            nextSend.setDate(nextSend.getDate() + 1);
          }
        }
        break;
        
      case 'monthly':
        nextSend.setMonth(nextSend.getMonth() + pattern.interval);
        
        // Adjust to correct day of month
        if (pattern.dayOfMonth) {
          nextSend.setDate(pattern.dayOfMonth);
        }
        break;
    }
    
    return nextSend;
  }
}


```


### Background Jobs


```typescript
// Process scheduled campaigns every minute
cron.schedule('* * * * *', async () => {
  const now = new Date();
  
  // Find campaigns ready to send
  const readySchedules = await db.campaignSchedules.findWhere({
    status: 'pending',
    nextSendAt: { lte: now },
  });
  
  const schedulingService = new CampaignSchedulingService();
  
  for (const schedule of readySchedules) {
    try {
      // Launch campaign
      const campaignEngine = new CampaignExecutionEngine();
      await campaignEngine.launchCampaign(schedule.campaignId);
      
      // Update schedule status
      if (schedule.isRecurring) {
        // Calculate next occurrence
        const nextSend = schedulingService.calculateRecurringSendTime(schedule);
        
        await db.campaignSchedules.update(schedule.id, {
          lastProcessedAt: now,
          nextSendAt: nextSend,
        });
      } else {
        // One-time schedule, mark as completed
        await db.campaignSchedules.update(schedule.id, {
          status: 'completed',
          lastProcessedAt: now,
        });
      }
      
      logger.info(`Campaign ${schedule.campaignId} sent on schedule`);
    } catch (error) {
      logger.error(`Error sending scheduled campaign ${schedule.campaignId}:`, error);
      
      await db.campaignSchedules.update(schedule.id, {
        status: 'failed',
      });
    }
  }
});

// Update contact send preferences daily
cron.schedule('0 3 * * *', async () => {  // 3 AM daily
  const contacts = await db.contacts.findAll();
  
  for (const contact of contacts) {
    // Get email engagement history
    const emails = await db.emails.findWhere({
      contactId: contact.id,
      sentAt: { gte: moment().subtract(90, 'days').toDate() },
    });
    
    if (emails.length < 5) continue; // Need minimum data
    
    // Calculate optimal send time
    const openTimes = emails
      .filter(e => e.openedAt)
      .map(e => moment(e.openedAt).hour());
    
    const clickTimes = emails
      .filter(e => e.clickedAt)
      .map(e => moment(e.clickedAt).hour());
    
    // Find most common hour
    const optimalHour = this.getMostCommonValue([...openTimes, ...clickTimes]);
    
    // Calculate engagement by day
    const engagementByDay = this.calculateEngagementByDay(emails);
    const optimalDay = this.getHighestEngagementDay(engagementByDay);
    
    // Update preferences
    await db.contactSendPreferences.upsert({
      contactId: contact.id,
      optimalSendTime: `${optimalHour}:00`,
      optimalSendDay: optimalDay,
      typicalOpenTimes: openTimes,
      typicalClickTimes: clickTimes,
      engagementByDay,
      dataPointsCount: emails.length,
      confidenceScore: Math.min(emails.length / 20, 1.0),
      lastCalculatedAt: new Date(),
    });
  }
  
  logger.info('Contact send preferences updated');
});


```


### API Endpoints


```typescript
// Create campaign schedule
router.post('/api/campaigns/:id/schedule', async (req, res) => {
  const { scheduleType, scheduledDate, scheduledTime, timezone, recurrencePattern } = req.body;
  
  const schedule = await db.campaignSchedules.create({
    campaignId: req.params.id,
    scheduleType,
    scheduledDate,
    scheduledTime,
    timezone,
    isRecurring: !!recurrencePattern,
    recurrencePattern,
    status: 'pending',
  });
  
  // Calculate first send time
  const schedulingService = new CampaignSchedulingService();
  const nextSendAt = await schedulingService.calculateNextSendTime(schedule);
  
  await db.campaignSchedules.update(schedule.id, { nextSendAt });
  
  res.json(schedule);
});

// Get campaign schedule
router.get('/api/campaigns/:id/schedule', async (req, res) => {
  const schedule = await db.campaignSchedules.findByCampaign(req.params.id);
  res.json(schedule);
});

// Update campaign schedule
router.put('/api/campaigns/:id/schedule', async (req, res) => {
  const schedule = await db.campaignSchedules.findByCampaign(req.params.id);
  
  await db.campaignSchedules.update(schedule.id, req.body);
  
  // Recalculate send time
  const schedulingService = new CampaignSchedulingService();
  const nextSendAt = await schedulingService.calculateNextSendTime(schedule);
  
  await db.campaignSchedules.update(schedule.id, { nextSendAt });
  
  res.json({ success: true });
});

// Preview send times for contacts
router.post('/api/campaigns/:id/schedule/preview', async (req, res) => {
  const { sampleSize = 10 } = req.body;
  
  const campaign = await db.campaigns.findById(req.params.id);
  const schedule = await db.campaignSchedules.findByCampaign(req.params.id);
  const contacts = await db.segments.getContacts(campaign.segmentId, sampleSize);
  
  const schedulingService = new CampaignSchedulingService();
  
  const previews = await Promise.all(
    contacts.map(async (contact) => {
      const sendTime = await schedulingService.calculateNextSendTime(schedule, contact);
      
      return {
        contactId: contact.id,
        contactEmail: contact.email,
        contactTimezone: contact.timezone,
        sendTime,
        sendTimeLocal: moment.tz(sendTime, contact.timezone).format('YYYY-MM-DD HH:mm:ss z'),
      };
    })
  );
  
  res.json({ previews });
});


```

---


## Related Documentation


### Campaign Features


- **[Campaign Management](./campaign-management/overview.md)** - Core campaign creation and management


- **[Email Sequences](./email-sequences.md)** - Multi-step automated sequences


- **[A/B Testing](./ab-testing.md)** - Campaign optimization


### Analytics


- **[Core Analytics](../../analytics/core-analytics/overview.md)** - Performance tracking


- **[Enhanced Analytics](../../analytics/enhanced-analytics/overview.md)** - Advanced insights


### Technical


- **[Email Pipeline](../../queue/email-pipeline.md)** - Email sending infrastructure


- **[API Documentation](../../../implementation-technical/api/tenant-api/campaigns.md)** - Campaign APIs

---

**Last Updated:** November 25, 2025  
**Status:** Planned - High Priority Q1 2026 Feature  
**Target Release:** Q1 2026  
**Owner:** Campaigns Team
