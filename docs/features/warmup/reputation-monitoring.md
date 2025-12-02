---
title: "Reputation Monitoring"
description: "Real-time sender reputation tracking, blacklist monitoring, domain health scores, deliverability alerts, and recovery recommendations"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q3 2026"
priority: "High"
related_features:

  - warmup/warmup-management

  - warmup/warmup-scheduling

  - domains/domain-management

  - compliance/security-features
related_tasks:

  - epic-4-warmup-deliverability
---

# Reputation Monitoring

**Quick Access**: Monitor sender reputation in real-time with blacklist checking, domain health scores, deliverability alerts, and automated recovery recommendations.

## Overview

Reputation Monitoring provides comprehensive visibility into your email sending reputation across domains, IPs, and email accounts. Get instant alerts when issues arise and receive actionable recommendations to maintain optimal deliverability.

### Key Capabilities

- **Real-Time Reputation Tracking**: Monitor sender scores across all major providers

- **Blacklist Monitoring**: Check 50+ blacklists automatically

- **Domain Health Scores**: Aggregate health metrics for each domain

- **Deliverability Alerts**: Instant notifications for reputation issues

- **Recovery Recommendations**: AI-powered guidance to fix problems

- **Historical Trends**: Track reputation changes over time

- **Competitive Benchmarking**: Compare against industry standards

- **Automated Remediation**: Auto-pause sending when issues detected

---

## Level 1: Quick Start Guide

### Reputation Dashboard

#### Overview

```text

Reputation Dashboard

Overall Health: 87/100 (Good) âœ“

Domains (3):
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚ penguinmails.com          92/100  âœ“ Excellent     â”‚
â”‚ marketing.penguinmails.com 85/100  âœ“ Good         â”‚
â”‚ sales.penguinmails.com    78/100  âš  Fair          â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜

Email Accounts (5):
  âœ“ 4 Healthy
  âš  1 Warning

Blacklists:
  âœ“ Clean (0/52 lists)
  Last checked: 5 minutes ago

Recent Alerts:
  âš  sales.penguinmails.com: Bounce rate elevated (4.2%)
  â„¹ Warmup completed: support@penguinmails.com

[View Details] [Run Full Scan] [Export Report]

```

#### Domain Health Details

```text

Domain: penguinmails.com
Health Score: 92/100 (Excellent) âœ“

Reputation Metrics:
  Sender Score: 95/100 âœ“
  Domain Authority: 88/100 âœ“
  IP Reputation: 90/100 âœ“

Authentication:
  SPF: âœ“ Pass
  DKIM: âœ“ Pass
  DMARC: âœ“ Pass (p=quarantine)

Deliverability:
  Inbox Rate: 94% âœ“
  Spam Rate: 3% âœ“
  Bounce Rate: 1.8% âœ“

Engagement:
  Open Rate: 28% (Industry avg: 21%)
  Click Rate: 4.2% (Industry avg: 2.8%)

Blacklists:
  âœ“ Clean (0/52 lists)

Trend: â†— Improving (+3 points this week)

[View History] [Run Diagnostics] [Export Report]

```

### Blacklist Monitoring

#### Blacklist Status

```text

Blacklist Monitor

Status: âœ“ All Clear

Checked Lists (52):
  âœ“ Spamhaus ZEN
  âœ“ Spamhaus DBL
  âœ“ Spamhaus PBL
  âœ“ Spamcop
  âœ“ SORBS
  âœ“ Barracuda
  âœ“ SURBL
  âœ“ URIBL
  ... and 44 more

Last Scan: 5 minutes ago
Next Scan: in 55 minutes

Domains Monitored:
  âœ“ penguinmails.com
  âœ“ marketing.penguinmails.com
  âœ“ sales.penguinmails.com

IPs Monitored:
  âœ“ 192.0.2.100 (Dedicated)
  âœ“ 192.0.2.101 (Dedicated)

[Run Scan Now] [Configure Alerts]

```

#### Blacklist Alert

```text

âš  BLACKLIST ALERT

Domain: sales.penguinmails.com
Listed on: Spamcop
Detected: 2 minutes ago

Details:
  List: Spamcop
  Reason: Spam reports
  Listed Since: Today, 2:15 PM
  Estimated Impact: Medium

Immediate Actions Taken:
  âœ“ Paused sending from sales@penguinmails.com
  âœ“ Notified admin team
  âœ“ Created support ticket

Recommended Actions:

  1. Review recent campaigns for spam triggers

  2. Check for compromised accounts

  3. Request delisting from Spamcop

  4. Implement stricter list hygiene

[View Delisting Instructions] [Contact Support]

```

### Health Alerts

#### Alert Types

```text

Active Alerts (2):

âš  High Bounce Rate
  Domain: sales.penguinmails.com
  Current: 4.2% (Threshold: 3%)
  Detected: 1 hour ago

  Impact: Medium
  Action: Review list quality

  [View Details] [Dismiss]

â„¹ Warmup Milestone
  Account: support@penguinmails.com
  Status: Reached 50% of target volume
  Day: 21/42

  [View Progress]

```

#### Alert Configuration

```text

Alert Settings

Email Notifications:
  Send to: admin@penguinmails.com

  â˜‘ Blacklist detections (Immediate)
  â˜‘ High bounce rate (> 3%)
  â˜‘ High spam rate (> 0.5%)
  â˜‘ Low engagement (< 10% open rate)
  â˜‘ Authentication failures
  â˜ Daily summary reports

Slack Notifications:
  Webhook: https://hooks.slack.com/...
  Channel: #deliverability-alerts

  â˜‘ Critical alerts only
  â—‹ All alerts

Auto-Actions:
  â˜‘ Pause sending on blacklist detection
  â˜‘ Pause sending on high bounce rate (> 5%)
  â˜‘ Pause sending on spam complaints (> 0.1%)

[Save Settings]

```

---

## Level 2: Advanced Monitoring

### Reputation Metrics

#### Sender Score Breakdown

```text

Sender Score: 95/100

Components:
  Infrastructure (30 points):
    SPF/DKIM/DMARC: 30/30 âœ“

  Volume & Consistency (25 points):
    Sending Pattern: 23/25 âœ“
    Volume Stability: 22/25 âœ“

  Engagement (25 points):
    Open Rate: 20/25 âœ“
    Click Rate: 18/25 âœ“

  Complaints (20 points):
    Bounce Rate: 19/20 âœ“
    Spam Rate: 20/20 âœ“

Compared to Industry:
  Your Score: 95/100
  Industry Avg: 72/100
  Top 10%: 88/100

  You're in the top 5% âœ“

```

#### Provider-Specific Reputation

```text

Reputation by Email Provider

Gmail:
  Reputation: Excellent âœ“
  Inbox Rate: 96%
  Spam Rate: 2%
  Postmaster Tools: Connected
  Domain Reputation: High
  IP Reputation: High

Outlook/Microsoft:
  Reputation: Good âœ“
  Inbox Rate: 92%
  Spam Rate: 4%
  SNDS: Connected
  Junk Rate: Low

Yahoo:
  Reputation: Good âœ“
  Inbox Rate: 90%
  Spam Rate: 5%
  Complaint Feedback Loop: Active

Apple Mail:
  Reputation: Excellent âœ“
  Inbox Rate: 95%
  Estimated Spam Rate: 3%

```

### Blacklist Deep Dive

#### Blacklist Categories

```text

Blacklist Coverage (52 lists)

IP-Based Lists (24):
  âœ“ Spamhaus ZEN
  âœ“ Spamhaus PBL
  âœ“ Spamcop
  âœ“ SORBS
  âœ“ Barracuda
  ... and 19 more

Domain-Based Lists (18):
  âœ“ Spamhaus DBL
  âœ“ SURBL
  âœ“ URIBL
  âœ“ Spamhaus DQS
  ... and 14 more

Combined Lists (10):
  âœ“ Composite Blocking List (CBL)
  âœ“ PSBL
  âœ“ Invaluement
  ... and 7 more

```

#### Delisting Process

```text

Delisting Guide: Spamcop

Status: Listed
Listed Since: Nov 25, 2025 2:15 PM
Auto-Delist: 24 hours after last report

Steps to Delist:

1. Identify Root Cause
   â˜ Review recent campaigns
   â˜ Check for compromised accounts
   â˜ Verify list quality

2. Fix Issues
   â˜ Remove problematic content
   â˜ Clean email list
   â˜ Secure compromised accounts

3. Request Delisting
   URL: https://www.spamcop.net/bl.shtml

   Information Needed:

   - IP Address: 192.0.2.100

   - Listing ID: ABC123XYZ

   - Explanation of corrective actions

4. Monitor Status
   â˜ Check delisting status (every 4 hours)
   â˜ Verify removal (may take 24-48 hours)

5. Resume Sending
   â˜ Gradually increase volume
   â˜ Monitor reputation closely

[Copy Delisting Template] [Track Progress]

```

### Domain Health Monitoring

#### Health Score Components

```text

Domain Health: penguinmails.com (92/100)

Authentication (25 points): 25/25 âœ“
  SPF: âœ“ Pass (v=spf1 include:_spf.google.com ~all)
  DKIM: âœ“ Pass (2048-bit key)
  DMARC: âœ“ Pass (p=quarantine, pct=100)
  BIMI: âœ“ Configured

Deliverability (30 points): 28/30 âœ“
  Inbox Rate: 94% (28/30)
  Bounce Rate: 1.8% (âœ“)
  Spam Rate: 3% (âœ“)

Engagement (25 points): 22/25 âœ“
  Open Rate: 28% (18/25)
  Click Rate: 4.2% (4/25)

Infrastructure (20 points): 17/20 âœ“
  DNS Configuration: âœ“ Correct
  SSL/TLS: âœ“ Valid
  Reverse DNS: âœ“ Configured
  Blacklists: âœ“ Clean (20/20)
  IP Reputation: 85/100 (-3 points)

```

#### Historical Trends

```text

Reputation Trend: Last 30 Days

Health Score:
  Nov 1:  85 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘
  Nov 8:  87 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘
  Nov 15: 89 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘
  Nov 22: 91 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘
  Nov 25: 92 â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘

  Trend: â†— +7 points (30 days)

Inbox Rate:
  Nov 1:  89% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘
  Nov 8:  91% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘
  Nov 15: 92% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘
  Nov 22: 93% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘
  Nov 25: 94% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ

  Trend: â†— +5% (30 days)

Engagement:
  Open Rate: 24% â†’ 28% (â†— +4%)
  Click Rate: 3.8% â†’ 4.2% (â†— +0.4%)

```

### Recovery Recommendations

#### AI-Powered Insights

```text

Reputation Recovery Plan

Current Status:
  Domain: sales.penguinmails.com
  Health Score: 78/100 (Fair)
  Primary Issue: Elevated bounce rate (4.2%)

Recommended Actions:

Priority 1: Immediate (Next 24 hours)

  1. â˜ Pause all campaigns from this domain
     Impact: Prevent further damage
     Effort: 5 minutes

  2. â˜ Clean email list (remove hard bounces)
     Impact: Reduce bounce rate by ~2%
     Effort: 30 minutes

  3. â˜ Verify list source and acquisition method
     Impact: Identify root cause
     Effort: 1 hour

Priority 2: Short-term (Next 7 days)

  4. â˜ Implement double opt-in for new signups
     Impact: Improve list quality long-term
     Effort: 2 hours

  5. â˜ Re-engage inactive subscribers
     Impact: Improve engagement metrics
     Effort: 4 hours

  6. â˜ Reduce sending volume by 50%
     Impact: Rebuild reputation gradually
     Effort: 15 minutes

Priority 3: Long-term (Next 30 days)

  7. â˜ Implement list hygiene automation
     Impact: Maintain high list quality
     Effort: 8 hours

  8. â˜ Set up engagement-based segmentation
     Impact: Send only to engaged subscribers
     Effort: 4 hours

Expected Outcome:
  Week 1: Health score â†’ 82/100
  Week 2: Health score â†’ 86/100
  Week 4: Health score â†’ 90/100

[Start Recovery Plan] [Customize Plan]

```

#### Automated Remediation

```text

Auto-Remediation Rules

Rule 1: High Bounce Rate
  Trigger: Bounce rate > 5%
  Actions:
    â˜‘ Pause all sending
    â˜‘ Send alert to admin
    â˜‘ Create support ticket
    â˜‘ Remove hard bounces from list

Rule 2: Blacklist Detection
  Trigger: Listed on any blacklist
  Actions:
    â˜‘ Pause sending from affected domain/IP
    â˜‘ Send immediate alert
    â˜‘ Create delisting ticket
    â˜‘ Notify deliverability team

Rule 3: Spam Complaints
  Trigger: Spam rate > 0.1%
  Actions:
    â˜‘ Pause campaign
    â˜‘ Review content for spam triggers
    â˜‘ Check list acquisition method
    â˜‘ Send alert to sender

Rule 4: Low Engagement
  Trigger: Open rate < 10% for 3 consecutive campaigns
  Actions:
    â˜ Pause sending (optional)
    â˜‘ Send warning to sender
    â˜‘ Suggest list cleaning
    â˜‘ Recommend re-engagement campaign

[Edit Rules] [Add Custom Rule]

```

### Competitive Benchmarking

```text

Industry Benchmarks

Your Performance vs Industry Average

Inbox Rate:
  You: 94% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ
  Avg: 85% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘
  Top: 97% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆ

  You're 9% above average âœ“

Open Rate:
  You: 28% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘
  Avg: 21% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Top: 35% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘

  You're 7% above average âœ“

Click Rate:
  You: 4.2% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Avg: 2.8% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Top: 6.5% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘

  You're 1.4% above average âœ“

Bounce Rate:
  You: 1.8% â–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Avg: 2.5% â–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘
  Top: 0.8% â–ˆâ–ˆâ–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘â–‘

  You're 0.7% below average âœ“

Industry: SaaS
Region: North America
Company Size: 51-200 employees

```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Domain reputation tracking
CREATE TABLE domain_reputation (
  id UUID PRIMARY KEY,
  domain_id UUID NOT NULL REFERENCES domains(id),

  -- Reputation scores
  health_score INTEGER,
  sender_score INTEGER,
  domain_authority INTEGER,

  -- Deliverability metrics
  inbox_rate DECIMAL(5,2),
  spam_rate DECIMAL(5,2),
  bounce_rate DECIMAL(5,2),

  -- Engagement metrics
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),
  reply_rate DECIMAL(5,2),

  -- Authentication
  spf_status VARCHAR(50),
  dkim_status VARCHAR(50),
  dmarc_status VARCHAR(50),

  -- Provider-specific
  gmail_reputation VARCHAR(50),
  outlook_reputation VARCHAR(50),
  yahoo_reputation VARCHAR(50),

  -- Timestamp
  measured_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_domain_reputation_domain ON domain_reputation(domain_id, measured_at);

-- Blacklist monitoring
CREATE TABLE blacklist_checks (
  id UUID PRIMARY KEY,

  -- Target
  check_type VARCHAR(50),  -- domain, ip
  check_value VARCHAR(255),  -- domain.com or IP address
  tenant_id UUID REFERENCES tenants(id),

  -- Blacklist
  blacklist_name VARCHAR(255),
  blacklist_category VARCHAR(100),  -- ip, domain, combined

  -- Result
  is_listed BOOLEAN DEFAULT FALSE,
  listed_since TIMESTAMP,
  delisted_at TIMESTAMP,
  listing_reason TEXT,

  -- Metadata
  checked_at TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_blacklist_checks_value ON blacklist_checks(check_value, checked_at);
CREATE INDEX idx_blacklist_checks_listed ON blacklist_checks(is_listed);

-- Reputation alerts
CREATE TABLE reputation_alerts (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Alert details
  alert_type VARCHAR(100),  -- blacklist, bounce_rate, spam_rate, etc.
  severity VARCHAR(50),  -- info, warning, critical

  -- Target
  domain_id UUID REFERENCES domains(id),
  email_account_id UUID REFERENCES email_accounts(id),

  -- Alert data
  title VARCHAR(255),
  description TEXT,
  alert_data JSONB,

  -- Recommendations
  recommended_actions JSONB,

  -- Status
  status VARCHAR(50),  -- active, acknowledged, resolved
  acknowledged_by UUID REFERENCES users(id),
  acknowledged_at TIMESTAMP,
  resolved_at TIMESTAMP,

  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_reputation_alerts_tenant ON reputation_alerts(tenant_id, created_at);
CREATE INDEX idx_reputation_alerts_status ON reputation_alerts(status);

-- Reputation history (daily snapshots)
CREATE TABLE reputation_history (
  id UUID PRIMARY KEY,
  domain_id UUID NOT NULL REFERENCES domains(id),

  -- Date
  snapshot_date DATE NOT NULL,

  -- Scores
  health_score INTEGER,
  sender_score INTEGER,

  -- Metrics
  inbox_rate DECIMAL(5,2),
  spam_rate DECIMAL(5,2),
  bounce_rate DECIMAL(5,2),
  open_rate DECIMAL(5,2),
  click_rate DECIMAL(5,2),

  -- Blacklists
  blacklist_count INTEGER DEFAULT 0,

  created_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(domain_id, snapshot_date)
);

CREATE INDEX idx_reputation_history_domain ON reputation_history(domain_id, snapshot_date);

```

### Reputation Monitoring Service

```typescript
interface ReputationMetrics {
  healthScore: number;
  senderScore: number;
  inboxRate: number;
  spamRate: number;
  bounceRate: number;
  openRate: number;
  clickRate: number;
}

class ReputationMonitoringService {
  async calculateDomainHealth(domainId: string): Promise<ReputationMetrics> {
    const domain = await db.domains.findById(domainId);

    // Get recent campaign metrics
    const campaigns = await db.campaigns.findAll({
      where: {
        domainId,
        sentAt: { [Op.gte]: subDays(new Date(), 30) },
      },
    });

    // Calculate aggregate metrics
    const totalSent = campaigns.reduce((sum, c) => sum + c.sentCount, 0);
    const totalDelivered = campaigns.reduce((sum, c) => sum + c.deliveredCount, 0);
    const totalOpens = campaigns.reduce((sum, c) => sum + c.openCount, 0);
    const totalClicks = campaigns.reduce((sum, c) => sum + c.clickCount, 0);
    const totalBounces = campaigns.reduce((sum, c) => sum + c.bounceCount, 0);
    const totalSpam = campaigns.reduce((sum, c) => sum + c.spamCount, 0);

    const inboxRate = totalSent > 0 ? (totalDelivered / totalSent) * 100 : 0;
    const bounceRate = totalSent > 0 ? (totalBounces / totalSent) * 100 : 0;
    const spamRate = totalSent > 0 ? (totalSpam / totalSent) * 100 : 0;
    const openRate = totalDelivered > 0 ? (totalOpens / totalDelivered) * 100 : 0;
    const clickRate = totalDelivered > 0 ? (totalClicks / totalDelivered) * 100 : 0;

    // Calculate health score
    const healthScore = this.calculateHealthScore({
      inboxRate,
      bounceRate,
      spamRate,
      openRate,
      clickRate,
    });

    // Calculate sender score
    const senderScore = await this.calculateSenderScore(domainId);

    // Save metrics
    await db.domainReputation.create({
      domainId,
      healthScore,
      senderScore,
      inboxRate,
      spamRate,
      bounceRate,
      openRate,
      clickRate,
      measuredAt: new Date(),
    });

    return {
      healthScore,
      senderScore,
      inboxRate,
      spamRate,
      bounceRate,
      openRate,
      clickRate,
    };
  }

  private calculateHealthScore(metrics: {
    inboxRate: number;
    bounceRate: number;
    spamRate: number;
    openRate: number;
    clickRate: number;
  }): number {
    let score = 100;

    // Penalize for poor deliverability
    score -= (100 - metrics.inboxRate) * 0.5;  // Max -50 points
    score -= metrics.bounceRate * 5;  // -5 points per 1% bounce
    score -= metrics.spamRate * 10;  // -10 points per 1% spam

    // Reward for engagement
    score += Math.min(metrics.openRate * 0.5, 20);  // Max +20 points
    score += Math.min(metrics.clickRate * 2, 10);  // Max +10 points

    return Math.max(0, Math.min(100, Math.floor(score)));
  }

  private async calculateSenderScore(domainId: string): Promise<number> {
    let score = 0;

    // Infrastructure (30 points)
    const authScore = await this.checkAuthentication(domainId);
    score += authScore;

    // Volume & Consistency (25 points)
    const volumeScore = await this.checkSendingPattern(domainId);
    score += volumeScore;

    // Engagement (25 points)
    const engagementScore = await this.checkEngagement(domainId);
    score += engagementScore;

    // Complaints (20 points)
    const complaintsScore = await this.checkComplaints(domainId);
    score += complaintsScore;

    return Math.min(100, score);
  }

  async checkBlacklists(
    type: 'domain' | 'ip',
    value: string,
    tenantId: string
  ): Promise<{ listed: string[]; clean: string[] }> {
    const blacklists = this.getBlacklistsToCheck(type);
    const listed: string[] = [];
    const clean: string[] = [];

    for (const blacklist of blacklists) {
      const isListed = await this.queryBlacklist(blacklist, value);

      await db.blacklistChecks.create({
        checkType: type,
        checkValue: value,
        tenantId,
        blacklistName: blacklist.name,
        blacklistCategory: blacklist.category,
        isListed,
        listedSince: isListed ? new Date() : null,
        checkedAt: new Date(),
      });

      if (isListed) {
        listed.push(blacklist.name);

        // Create alert
        await this.createBlacklistAlert(tenantId, blacklist.name, value);
      } else {
        clean.push(blacklist.name);
      }
    }

    return { listed, clean };
  }

  private getBlacklistsToCheck(type: 'domain' | 'ip'): any[] {
    const ipBlacklists = [
      { name: 'Spamhaus ZEN', category: 'ip', dnsbl: 'zen.spamhaus.org' },
      { name: 'Spamcop', category: 'ip', dnsbl: 'bl.spamcop.net' },
      { name: 'SORBS', category: 'ip', dnsbl: 'dnsbl.sorbs.net' },
      { name: 'Barracuda', category: 'ip', dnsbl: 'b.barracudacentral.org' },
      // ... more IP blacklists
    ];

    const domainBlacklists = [
      { name: 'Spamhaus DBL', category: 'domain', dnsbl: 'dbl.spamhaus.org' },
      { name: 'SURBL', category: 'domain', dnsbl: 'multi.surbl.org' },
      { name: 'URIBL', category: 'domain', dnsbl: 'multi.uribl.com' },
      // ... more domain blacklists
    ];

    return type === 'ip' ? ipBlacklists : domainBlacklists;
  }

  private async queryBlacklist(blacklist: any, value: string): Promise<boolean> {
    try {
      // Reverse IP for DNSBL query
      const query = blacklist.category === 'ip'
        ? this.reverseIP(value) + '.' + blacklist.dnsbl
        : value + '.' + blacklist.dnsbl;

      const result = await dns.resolve4(query);
      return result.length > 0;
    } catch (error) {
      // NXDOMAIN means not listed
      return false;
    }
  }

  private reverseIP(ip: string): string {
    return ip.split('.').reverse().join('.');
  }

  private async createBlacklistAlert(
    tenantId: string,
    blacklistName: string,
    value: string
  ): Promise<void> {
    await db.reputationAlerts.create({
      tenantId,
      alertType: 'blacklist_detection',
      severity: 'critical',
      title: `Blacklist Detection: ${blacklistName}`,
      description: `${value} has been detected on ${blacklistName}`,
      alertData: {
        blacklist: blacklistName,
        value,
      },
      recommendedActions: [
        'Pause sending immediately',
        'Review recent campaigns',
        'Check for compromised accounts',
        'Request delisting',
      ],
      status: 'active',
    });

    // Send notification
    await this.sendAlert(tenantId, 'blacklist', {
      blacklist: blacklistName,
      value,
    });
  }

  async checkReputationHealth(domainId: string): Promise<void> {
    const metrics = await this.calculateDomainHealth(domainId);

    // Check for issues
    if (metrics.bounceRate > 3) {
      await this.createAlert(domainId, 'high_bounce_rate', {
        bounceRate: metrics.bounceRate,
        threshold: 3,
      });
    }

    if (metrics.spamRate > 0.5) {
      await this.createAlert(domainId, 'high_spam_rate', {
        spamRate: metrics.spamRate,
        threshold: 0.5,
      });
    }

    if (metrics.openRate < 10) {
      await this.createAlert(domainId, 'low_engagement', {
        openRate: metrics.openRate,
        threshold: 10,
      });
    }
  }

  private async createAlert(
    domainId: string,
    alertType: string,
    data: any
  ): Promise<void> {
    const domain = await db.domains.findById(domainId);

    await db.reputationAlerts.create({
      tenantId: domain.tenantId,
      domainId,
      alertType,
      severity: this.getAlertSeverity(alertType, data),
      title: this.getAlertTitle(alertType, data),
      description: this.getAlertDescription(alertType, data),
      alertData: data,
      recommendedActions: this.getRecommendedActions(alertType, data),
      status: 'active',
    });
  }
}

```

### Background Jobs

```typescript
// Check blacklists hourly
cron.schedule('0 * * * *', async () => {
  const service = new ReputationMonitoringService();

  // Check all domains
  const domains = await db.domains.findAll({ where: { isActive: true } });

  for (const domain of domains) {
    await service.checkBlacklists('domain', domain.name, domain.tenantId);
  }

  // Check all dedicated IPs
  const ips = await db.dedicatedIPs.findAll({ where: { isActive: true } });

  for (const ip of ips) {
    await service.checkBlacklists('ip', ip.address, ip.tenantId);
  }
});

// Calculate reputation daily
cron.schedule('0 2 * * *', async () => {  // 2 AM daily
  const service = new ReputationMonitoringService();

  const domains = await db.domains.findAll({ where: { isActive: true } });

  for (const domain of domains) {
    const metrics = await service.calculateDomainHealth(domain.id);

    // Save daily snapshot
    await db.reputationHistory.create({
      domainId: domain.id,
      snapshotDate: new Date(),
      ...metrics,
    });

    // Check for issues
    await service.checkReputationHealth(domain.id);
  }
});

```

### API Endpoints

```typescript
// Get domain reputation
app.get('/api/reputation/domain/:id', authenticate, async (req, res) => {
  const service = new ReputationMonitoringService();
  const metrics = await service.calculateDomainHealth(req.params.id);

  return res.json(metrics);
});

// Check blacklists
app.post('/api/reputation/blacklist-check', authenticate, async (req, res) => {
  const service = new ReputationMonitoringService();

  const result = await service.checkBlacklists(
    req.body.type,
    req.body.value,
    req.user.tenantId
  );

  return res.json(result);
});

// Get reputation history
app.get('/api/reputation/domain/:id/history', authenticate, async (req, res) => {
  const history = await db.reputationHistory.findAll({
    where: { domainId: req.params.id },
    order: [['snapshotDate', 'DESC']],
    limit: 30,
  });

  return res.json(history);
});

// Get active alerts
app.get('/api/reputation/alerts', authenticate, async (req, res) => {
  const alerts = await db.reputationAlerts.findAll({
    where: {
      tenantId: req.user.tenantId,
      status: 'active',
    },
    order: [['createdAt', 'DESC']],
  });

  return res.json(alerts);
});

```

---

## Related Documentation

- **[Email Warmups](/docs/features/warmup/email-warmups/overview)** - Overall warmup strategy overview

- **[Warmup Scheduling](/docs/features/warmup/warmup-scheduling)** - Automated warmup

- **[Domain Management](/docs/features/domains/domain-management)** - Domain configuration

- **[Security Features](/docs/features/compliance/security-features)** - Authentication setup

---

**Last Updated:** November 25, 2025
**Status:** Planned - High Priority (Level 2)
**Target Release:** Q3 2026
**Owner:** Deliverability Team
