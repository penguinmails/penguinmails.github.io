---
title: "Inbox Rotation"
description: "Maximize deliverability by automatically rotating sending across multiple email accounts with smart health monitoring"
level: "2"
status: "AVAILABLE"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:
  - inbox/unified-inbox/overview
  - warmup/reputation-monitoring
  - campaigns/campaign-management/overview
  - infrastructure/free-mailbox-creation/overview
related_tasks:
  - epic-8-inbox-management
---

# Inbox Rotation

**Quick Access**: Scale your outreach volume safely by distributing sending load across multiple email accounts, domains, and IPs.

## Overview

Inbox Rotation protects your sender reputation by ensuring no single email account exceeds safe sending limits. Instead of sending 500 emails from one address (high risk), PenguinMails automatically distributes them across 10 addresses (50 emails each, low risk). If an account's health score drops, it's automatically paused while others pick up the slack.

### Key Capabilities

- **Rotation Pools**: Group accounts by purpose (e.g., "Sales Team", "Newsletter", "Cold Outreach")
- **Smart Load Balancing**: Distribute volume based on account age, warmup status, and health score
- **Auto-Pause & Recovery**: Automatically remove accounts with high bounce rates or low reputation
- **Domain Diversity**: Rotate across different domains to prevent domain-wide blacklisting
- **Volume Ramping**: Automatically increase limits as accounts mature
- **Unified Analytics**: Track performance of the entire pool as a single entity

---

## Level 1: Quick Start Guide

### Set Up Your First Rotation Pool

#### Step 1: Create a Pool

```
Dashboard → Infrastructure → Rotation Pools → Create New

Pool Configuration:
┌─────────────────────────────────────────────────────┐
│ Pool Name: "SDR Outreach Team"                      │
│ Description: Cold outreach for Q1 Sales             │
│                                                     │
│ Strategy:                                           │
│ ● Round Robin (Even distribution)                   │
│ ○ Weighted (Based on health/limit)                  │
│ ○ Random                                            │
│                                                     │
│ Daily Limit per Account: [50] emails                │
│ Min. Delay between sends: [120] seconds             │
└─────────────────────────────────────────────────────┘
```

#### Step 2: Add Accounts

Select accounts to include in this rotation.

```
Available Accounts:
☑ sarah@company.com (Health: 98%)
☑ mike@company.com (Health: 95%)
☑ sales@company.net (Health: 92%)
☑ hello@company.io (Health: 88%)

[Add to Pool]
```

#### Step 3: Assign to Campaign

Link your campaign to the pool instead of a single sender.

```
Campaign Settings → Sender:
┌─────────────────────────────────────────────────────┐
│ From: [Rotation Pool: SDR Outreach Team ▼]          │
│                                                     │
│ Fallback Behavior:                                  │
│ If pool capacity reached:                           │
│ ● Pause campaign until tomorrow                     │
│ ○ Continue with warning                             │
└─────────────────────────────────────────────────────┘
```

#### Step 4: Monitor Health

**Pool Dashboard:**

```
Status: Healthy (4/4 Active)
Capacity: 200 emails/day
Used Today: 145 (72%)

Account Performance:
- sarah@company.com: 45 sent | 0 bounces
- mike@company.com: 42 sent | 1 bounce
- sales@company.net: 38 sent | 0 bounces
- hello@company.io: 20 sent | 0 bounces
```

---

## Level 2: Advanced Configuration

### Smart Rotation Logic

Configure how the system selects the next sender.

**Weighted by Health Score:**

```yaml
rotation_strategy:
  type: "weighted_health"
  
  weights:
    health_score: 0.6  # Prioritize healthy accounts
    warmup_status: 0.3 # Prioritize fully warmed accounts
    usage_today: 0.1   # Deprioritize heavily used accounts
    
  constraints:
    min_health_score: 85
    max_bounce_rate: 2.5%
```

**Domain Diversity Enforcement:**

Ensure consecutive emails don't come from the same domain to avoid pattern detection.

```yaml
diversity_rules:
  prevent_consecutive_domains: true
  max_consecutive_provider: 3  # Don't send >3 Gmails in a row
  
  # Example pattern:
  # 1. user@domain-a.com (Google)
  # 2. user@domain-b.com (Outlook)
  # 3. user@domain-c.com (Zoho)
```

### Auto-Pause & Recovery Rules

Protect accounts from burning out.

```yaml
safety_rules:
  # Pause triggers
  triggers:
    - if: bounce_rate_24h > 5%
      action: pause_account
      duration: 24h
      notify: admin
      
    - if: spam_complaint_count > 1
      action: pause_account
      duration: 48h
      
    - if: consecutive_failures > 3
      action: pause_account
      duration: 1h
      
  # Recovery logic
  recovery:
    - after: pause_duration
      action: enable_warmup_only
      duration: 3d
      
    - if: warmup_score > 95
      action: restore_to_pool
```

### Volume Ramping

Automatically increase sending limits for new accounts.

```json
{
  "ramping_schedule": {
    "week_1": { "daily_limit": 10, "min_delay": 300 },
    "week_2": { "daily_limit": 20, "min_delay": 240 },
    "week_3": { "daily_limit": 35, "min_delay": 180 },
    "week_4": { "daily_limit": 50, "min_delay": 120 }
  },
  "condition": "health_score > 90"
}
```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Rotation Pools
CREATE TABLE rotation_pools (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  strategy VARCHAR(50) DEFAULT 'round_robin', -- round_robin, weighted, random
  
  -- Limits
  daily_limit_per_account INTEGER DEFAULT 50,
  max_pool_capacity INTEGER, -- Total daily emails for pool
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_rotation_pools_tenant ON rotation_pools(tenant_id);

-- Pool Members (Accounts in the pool)
CREATE TABLE pool_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pool_id UUID NOT NULL REFERENCES rotation_pools(id) ON DELETE CASCADE,
  account_id UUID NOT NULL REFERENCES email_accounts(id),
  
  status VARCHAR(50) DEFAULT 'active', -- active, paused, cooling_down
  priority INTEGER DEFAULT 1,
  weight DECIMAL(3,2) DEFAULT 1.0,
  
  -- Stats for rotation logic
  sent_today INTEGER DEFAULT 0,
  last_sent_at TIMESTAMP,
  
  -- Override limits
  custom_daily_limit INTEGER,
  
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(pool_id, account_id)
);

CREATE INDEX idx_pool_members_pool ON pool_members(pool_id);
CREATE INDEX idx_pool_members_account ON pool_members(account_id);

-- Rotation Rules (Safety & Logic)
CREATE TABLE rotation_rules (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  pool_id UUID NOT NULL REFERENCES rotation_pools(id) ON DELETE CASCADE,
  
  rule_type VARCHAR(50), -- pause_trigger, diversity, ramping
  config JSONB NOT NULL,
  
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Account Health History (for scoring)
CREATE TABLE account_health_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID NOT NULL REFERENCES email_accounts(id),
  
  health_score INTEGER, -- 0-100
  bounce_rate DECIMAL(5,2),
  spam_rate DECIMAL(5,2),
  open_rate DECIMAL(5,2),
  
  snapshot_date DATE DEFAULT CURRENT_DATE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_account_health_account ON account_health_logs(account_id);
```

### Rotation Algorithm (TypeScript)

The core logic for selecting the next sender.

```typescript
class RotationService {
  
  /**
   * Select the best account for the next email
   */
  async selectNextSender(poolId: string): Promise<EmailAccount> {
    // 1. Fetch active members
    const members = await db.poolMembers.find({
      where: {
        pool_id: poolId,
        status: 'active'
      },
      include: ['account']
    });

    // 2. Filter out ineligible accounts
    const eligible = members.filter(member => {
      const limit = member.custom_daily_limit || member.pool.daily_limit_per_account;
      
      // Check limits
      if (member.sent_today >= limit) return false;
      
      // Check cooldown (min delay)
      const minDelay = 120 * 1000; // 2 mins
      const timeSinceLast = Date.now() - new Date(member.last_sent_at).getTime();
      if (timeSinceLast < minDelay) return false;
      
      return true;
    });

    if (eligible.length === 0) {
      throw new Error('Pool exhausted: No accounts available');
    }

    // 3. Apply Strategy
    const pool = await db.rotationPools.findById(poolId);
    
    if (pool.strategy === 'weighted') {
      return this.selectWeighted(eligible);
    } else if (pool.strategy === 'random') {
      return eligible[Math.floor(Math.random() * eligible.length)].account;
    } else {
      // Round Robin (default): Select one with least sends today, or longest time since last send
      return eligible.sort((a, b) => a.sent_today - b.sent_today)[0].account;
    }
  }

  /**
   * Weighted selection based on health and capacity
   */
  private selectWeighted(members: PoolMember[]): EmailAccount {
    // Calculate score: Health * (Remaining Capacity / Total Capacity)
    const scored = members.map(m => {
      const health = m.account.health_score || 50;
      const limit = m.custom_daily_limit || 50;
      const remaining = limit - m.sent_today;
      
      return {
        member: m,
        score: health * (remaining / limit)
      };
    });

    // Sort by score desc
    scored.sort((a, b) => b.score - a.score);
    return scored[0].member.account;
  }
}
```

### Health Monitoring Service

Runs periodically to update scores and trigger safety rules.

```typescript
class HealthMonitor {
  
  async checkPoolHealth(poolId: string) {
    const members = await db.poolMembers.findByPool(poolId);
    
    for (const member of members) {
      const stats = await this.getDailyStats(member.account_id);
      
      // 1. Check Pause Triggers
      if (stats.bounceRate > 0.05) { // 5% bounce rate
        await this.pauseMember(member, 'High bounce rate detected');
        continue;
      }
      
      // 2. Update Health Score
      const newScore = this.calculateHealthScore(stats);
      await db.emailAccounts.update(member.account_id, { health_score: newScore });
      
      // 3. Check Ramping
      if (newScore > 90 && member.sent_today >= member.custom_daily_limit) {
        // Auto-scale limit if eligible
        await this.increaseLimit(member);
      }
    }
  }
  
  private calculateHealthScore(stats: DailyStats): number {
    // Simple algorithm: Start at 100, deduct for bad signals
    let score = 100;
    score -= (stats.bounceRate * 100 * 2); // Heavy penalty for bounces
    score -= (stats.spamComplaintRate * 100 * 5); // Severe penalty for spam
    score += (stats.openRate > 0.3 ? 5 : 0); // Bonus for good engagement
    return Math.max(0, Math.min(100, score));
  }
}
```

### API Endpoints

```typescript
// Create Pool
router.post('/api/rotation/pools', async (req, res) => {
  const pool = await db.rotationPools.create({
    tenant_id: req.user.tenantId,
    ...req.body
  });
  res.json(pool);
});

// Add Members
router.post('/api/rotation/pools/:id/members', async (req, res) => {
  const { accountIds } = req.body;
  const members = await Promise.all(accountIds.map(accId => 
    db.poolMembers.create({
      pool_id: req.params.id,
      account_id: accId
    })
  ));
  res.json(members);
});

// Get Pool Status
router.get('/api/rotation/pools/:id/status', async (req, res) => {
  const members = await db.poolMembers.find({
    where: { pool_id: req.params.id },
    include: ['account']
  });
  
  const stats = {
    total_accounts: members.length,
    active_accounts: members.filter(m => m.status === 'active').length,
    total_sent_today: members.reduce((sum, m) => sum + m.sent_today, 0),
    total_capacity: members.reduce((sum, m) => sum + (m.custom_daily_limit || 50), 0)
  };
  
  res.json({ stats, members });
});
```

---

**Last Updated:** November 25, 2025
**Status:** Available - Core Feature
**Target Release:** Q1 2026
**Owner:** Infrastructure Team
