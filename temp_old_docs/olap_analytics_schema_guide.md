# OLAP Analytics Schema Guide

## Table Naming Standards

**OLAP Analytics Tier Naming Conventions:**
- **Business Analytics**: `[entity]_analytics` suffix for core analytics tables (`campaign_analytics`, `billing_analytics`)
- **Administrative**: `admin_` prefix for audit and system tables (`admin_audit_logs`, `admin_system_events`)
- **System Events**: Singular for event tracking (`admin_system_events`)
- **Audit Logs**: Plural for comprehensive logs (`admin_audit_logs`)

**Table Name Examples:**
- `billing_analytics` - Usage tracking per billing period (central hub)
- `campaign_analytics` - Campaign performance metrics
- `mailbox_analytics` - Individual mailbox performance
- `lead_analytics` - Individual lead engagement
- `warmup_analytics` - Email warmup progression
- `sequence_step_analytics` - Campaign step performance
- `admin_audit_logs` - Complete audit trail with performance tracking
- `admin_system_events` - Unified admin activity and system monitoring

## Document Summary
This comprehensive guide details the OLAP (Online Analytical Processing) schema for PenguinMails' business intelligence and analytics system. It provides complete table definitions, relationships, indexing strategies, and implementation patterns for comprehensive reporting and analytics capabilities.

---

## Overview

### OLAP Schema Purpose
The OLAP schema provides business intelligence capabilities through:
- **Comprehensive Analytics**: Campaign, mailbox, and lead performance metrics
- **Billing Analytics**: Usage tracking and revenue reporting
- **Administrative Audit**: System administration and compliance tracking
- **Historical Analysis**: Long-term trend analysis and forecasting
- **Data Warehousing**: Optimized for aggregations and complex queries

### Schema Architecture
```mermaid
erDiagram
    %% Billing Analytics (Central Hub)
    billingAnalytics {
        bigint id PK
        text tenantId
        text subscriptionId
        int emailsSent
        int mailboxesUsed
        int domainsUsed
        int campaignsUsed
        int leadsUsed
        int warmupsActive
        timestamp period_start
        timestamp period_end,
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Campaign Performance Analytics
    campaignAnalytics {
        bigint id PK
        text campaignId
        text companyId
        int sent
        int delivered
        int opened_tracked
        int clicked_tracked
        int replied
        int bounced
        int unsubscribed
        int spamComplaints
        text status
        int completedLeads
        billing_id BIGINT REFERENCES billing_analytics(id),
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Mailbox Performance Analytics
    mailboxAnalytics {
        bigint id PK
        text mailboxId
        text companyId
        int sent
        int delivered
        int opened_tracked
        int clicked_tracked
        int replied
        int bounced
        int unsubscribed
        int spamComplaints
        text warmupStatus
        int healthScore
        int currentVolume
        bigint billingId FK
        campaign_status TEXT,
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Lead Engagement Analytics
    leadAnalytics {
        bigint id PK
        text leadId
        text campaignId
        int sent
        int delivered
        int opened_tracked
        int clicked_tracked
        int replied
        int bounced
        int unsubscribed
        int spamComplaints
        text status
        billing_id BIGINT REFERENCES billing_analytics(id),
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Warmup Progression Analytics
    warmupAnalytics {
        bigint id PK
        text mailboxId
        text companyId
        int sent
        int delivered
        int opened_tracked
        int clicked_tracked
        int replied
        int bounced
        int unsubscribed
        int spamComplaints
        int healthScore
        int progressPercentage
        billing_id BIGINT REFERENCES billing_analytics(id),
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Sequence Step Analytics
    sequenceStepAnalytics {
        bigint id PK
        text stepId
        text campaignId
        text companyId
        int sent
        int delivered
        int opened_tracked
        int clicked_tracked
        int replied
        int bounced
        int unsubscribed
        int spamComplaints
        billing_id BIGINT REFERENCES billing_analytics(id),
        updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    }

    %% Administrative Analytics
    admin_audit_log {
        bigint id PK
        timestamptz creation_time
        text adminUserId
        text action
        text resourceType
        text resourceId
        text tenantId
        jsonb oldValues
        jsonb newValues
        text ipAddress
        text userAgent
        bigint timestamp
        text notes
        jsonb metadata
    }

    admin_sessions {
        bigint id PK
        timestamptz creation_time
        text adminUserId
        text sessionToken
        text ipAddress
        text userAgent
        bigint startedAt
        bigint lastActivity
        bigint expiresAt
        boolean isActive
        text deviceInfo
    }

    admin_system_events {
        bigint id PK
        timestamptz creation_time
        text eventType
        text severity
        text message
        jsonb details
        text adminUserId
        text tenantId
        bigint timestamp
        bigint resolvedAt
        text resolution
    }

    %% ===============================
    %% RELATIONSHIPS
    %% ===============================

    billingAnalytics ||--o{ campaignAnalytics : "tracks usage period"
    billingAnalytics ||--o{ mailboxAnalytics : "tracks usage period"
    billingAnalytics ||--o{ leadAnalytics : "tracks usage period"
    billingAnalytics ||--o{ warmupAnalytics : "tracks usage period"
    billingAnalytics ||--o{ sequenceStepAnalytics : "tracks usage period"

    campaignAnalytics ||--o{ sequenceStepAnalytics : "includes steps"
    mailboxAnalytics ||--o{ warmupAnalytics : "warmup data"
```

---

## Core Analytics Tables

### 1. Billing Analytics (Central Hub)

```sql
-- Billing Analytics - Usage tracking per billing period
CREATE TABLE billing_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tenant_id TEXT NOT NULL,
    subscription_id TEXT,
    emails_sent INTEGER DEFAULT 0,
    mailboxes_used INTEGER DEFAULT 0,
    domains_used INTEGER DEFAULT 0,
    campaigns_used INTEGER DEFAULT 0,
    leads_used INTEGER DEFAULT 0,
    warmups_active INTEGER DEFAULT 0,
    period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Unique constraint to prevent duplicate periods
CREATE UNIQUE INDEX idx_billing_analytics_tenant_period 
ON billing_analytics(tenant_id, period_start, period_end);

-- Indexes for common queries
CREATE INDEX idx_billing_analytics_tenant ON billing_analytics(tenant_id);
CREATE INDEX idx_billing_analytics_subscription ON billing_analytics(subscription_id);
CREATE INDEX idx_billing_analytics_period ON billing_analytics(period_start, period_end);
```

**Purpose**: Central hub for all billing-related analytics, tracking tenant usage across all features per billing period.

**Key Metrics**:
- **Usage Tracking**: emails_sent, mailboxes_used, domains_used, campaigns_used, leads_used, warmups_active
- **Period Management**: period_start, period_end for billing cycle tracking
- **Subscription Context**: subscription_id for billing relationship

### 2. Campaign Analytics

```sql
-- Campaign Analytics - Campaign performance metrics
CREATE TABLE campaign_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    campaign_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,                    -- Sum of all steps
    delivered INTEGER DEFAULT 0,               -- Sum of all steps
    opened_tracked INTEGER DEFAULT 0,          -- Sum of all steps
    clicked_tracked INTEGER DEFAULT 0,         -- Sum of all steps
    replied INTEGER DEFAULT 0,                 -- Sum of all steps
    bounced INTEGER DEFAULT 0,                 -- Sum of all steps
    unsubscribed INTEGER DEFAULT 0,            -- Sum of all steps
    spam_complaints INTEGER DEFAULT 0,         -- Sum of all steps
    status TEXT,
    completed_leads INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for campaign analytics
CREATE INDEX idx_campaign_analytics_campaign ON campaign_analytics(campaign_id);
CREATE INDEX idx_campaign_analytics_company ON campaign_analytics(company_id);
CREATE INDEX idx_campaign_analytics_status ON campaign_analytics(status);
CREATE INDEX idx_campaign_analytics_billing ON campaign_analytics(billing_id);
```

**Purpose**: Aggregated campaign performance metrics, summing all sequence steps for comprehensive campaign analysis.

**Key Metrics**:
- **Email Performance**: sent, delivered, opened_tracked, clicked_tracked, replied, bounced
- **Compliance Metrics**: unsubscribed, spam_complaints
- **Business Metrics**: completed_leads (conversion tracking)
- **Status Tracking**: current campaign status

### 3. Mailbox Analytics

```sql
-- Mailbox Analytics - Individual mailbox performance
CREATE TABLE mailbox_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mailbox_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    warmup_status TEXT,
    health_score INTEGER DEFAULT 0,
    current_volume INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    campaign_status TEXT,
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for mailbox analytics
CREATE INDEX idx_mailbox_analytics_mailbox ON mailbox_analytics(mailbox_id);
CREATE INDEX idx_mailbox_analytics_company ON mailbox_analytics(company_id);
CREATE INDEX idx_mailbox_analytics_warmup ON mailbox_analytics(warmup_status);
CREATE INDEX idx_mailbox_analytics_health ON mailbox_analytics(health_score);
CREATE INDEX idx_mailbox_analytics_billing ON mailbox_analytics(billing_id);
```

**Purpose**: Individual mailbox performance tracking including warmup status and health scoring.

**Key Metrics**:
- **Sending Performance**: All standard email metrics (sent, delivered, opened, etc.)
- **Warmup Tracking**: warmup_status, health_score (0-100), current_volume
- **Campaign Context**: campaign_status for active campaign tracking

### 4. Lead Analytics

```sql
-- Lead Analytics - Individual lead engagement
CREATE TABLE lead_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    lead_id TEXT NOT NULL,
    campaign_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,                    -- Per campaign
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    status TEXT,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for lead analytics
CREATE INDEX idx_lead_analytics_lead ON lead_analytics(lead_id);
CREATE INDEX idx_lead_analytics_campaign ON lead_analytics(campaign_id);
CREATE INDEX idx_lead_analytics_status ON lead_analytics(status);
CREATE INDEX idx_lead_analytics_billing ON lead_analytics(billing_id);
```

**Purpose**: Individual lead engagement tracking per campaign for lead scoring and segmentation analysis.

**Key Metrics**:
- **Engagement Tracking**: Per-lead email interaction metrics
- **Campaign Context**: Links leads to specific campaigns
- **Lead Scoring**: status field for lead qualification tracking

### 5. Warmup Analytics

```sql
-- Warmup Analytics - Email warmup progression
CREATE TABLE warmup_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    mailbox_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    health_score INTEGER DEFAULT 0,
    progress_percentage INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for warmup analytics
CREATE INDEX idx_warmup_analytics_mailbox ON warmup_analytics(mailbox_id);
CREATE INDEX idx_warmup_analytics_company ON warmup_analytics(company_id);
CREATE INDEX idx_warmup_analytics_health ON warmup_analytics(health_score);
CREATE INDEX idx_warmup_analytics_progress ON warmup_analytics(progress_percentage);
CREATE INDEX idx_warmup_analytics_billing ON warmup_analytics(billing_id);
```

**Purpose**: Dedicated warmup progression tracking with health scoring and completion percentage.

**Key Metrics**:
- **Warmup Progression**: progress_percentage (0-100%), health_score (0-100)
- **Warmup Performance**: Email metrics during warmup phase
- **Deliverability Insights**: Enhanced tracking for reputation building

### 6. Sequence Step Analytics

```sql
-- Sequence Step Analytics - Campaign step performance
CREATE TABLE sequence_step_analytics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    step_id TEXT NOT NULL,
    campaign_id TEXT NOT NULL,
    company_id TEXT NOT NULL,
    sent INTEGER DEFAULT 0,
    delivered INTEGER DEFAULT 0,
    opened_tracked INTEGER DEFAULT 0,
    clicked_tracked INTEGER DEFAULT 0,
    replied INTEGER DEFAULT 0,
    bounced INTEGER DEFAULT 0,
    unsubscribed INTEGER DEFAULT 0,
    spam_complaints INTEGER DEFAULT 0,
    billing_id BIGINT REFERENCES billing_analytics(id),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for sequence step analytics
CREATE INDEX idx_sequence_step_analytics_step ON sequence_step_analytics(step_id);
CREATE INDEX idx_sequence_step_analytics_campaign ON sequence_step_analytics(campaign_id);
CREATE INDEX idx_sequence_step_analytics_company ON sequence_step_analytics(company_id);
CREATE INDEX idx_sequence_step_analytics_billing ON sequence_step_analytics(billing_id);
```

**Purpose**: Granular step-level analytics for campaign sequence optimization and A/B testing.

**Key Metrics**:
- **Step Performance**: Individual step email metrics
- **Sequence Optimization**: Enables analysis of step effectiveness
- **A/B Testing**: Foundation for step-level experimentation

---

## Administrative Analytics Tables

### 7. Enhanced Admin Audit Log with Performance Tracking

```sql
-- Enhanced Admin Audit Log - Complete audit trail with performance tracking
CREATE TABLE admin_audit_log (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    admin_user_id TEXT NOT NULL,
    action TEXT NOT NULL,
    resource_type TEXT NOT NULL,
    resource_id TEXT NOT NULL,
    tenant_id TEXT NOT NULL,
    old_values JSONB,
    new_values JSONB,
    ip_address TEXT,
    user_agent TEXT,
    timestamp BIGINT,
    notes TEXT,
    metadata JSONB,
    -- Performance tracking additions
    query_duration_ms INTEGER,              -- How long the operation took
    affected_rows INTEGER DEFAULT 0,        -- Number of rows affected
    query_complexity_score INTEGER,         -- Complexity metric (0-100)
    analytics_event_id TEXT,                -- Link to analytics events (optional)
    performance_category VARCHAR(20) CHECK (performance_category IN ('fast', 'normal', 'slow', 'critical')),

    -- Technical performance tracking moved to PostHog:
    -- Track via PostHog events: 'db_query_performance', 'admin_action_timing'
    -- Properties: {query_duration_ms, query_complexity_score, affected_rows, performance_category}
    -- Enhanced compliance tracking
    compliance_flags TEXT[],                -- GDPR, SOX, HIPAA flags
    data_classification VARCHAR(20) CHECK (data_classification IN ('public', 'internal', 'confidential', 'restricted')),
    retention_category VARCHAR(20) CHECK (retention_category IN ('short_term', 'medium_term', 'long_term', 'permanent'))
);

-- Enhanced indexes for admin audit log with performance tracking
CREATE INDEX idx_admin_audit_admin_user ON admin_audit_log(admin_user_id, creation_time DESC);
CREATE INDEX idx_admin_audit_tenant ON admin_audit_log(tenant_id, creation_time DESC);
CREATE INDEX idx_admin_audit_resource ON admin_audit_log(resource_type, resource_id);
CREATE INDEX idx_admin_audit_action ON admin_audit_log(action, creation_time DESC);
CREATE INDEX idx_admin_audit_timestamp ON admin_audit_log(timestamp);
-- Performance monitoring indexes
CREATE INDEX idx_admin_audit_performance ON admin_audit_log(performance_category, query_duration_ms DESC) WHERE query_duration_ms IS NOT NULL;
CREATE INDEX idx_admin_audit_analytics ON admin_audit_log(analytics_event_id) WHERE analytics_event_id IS NOT NULL;
CREATE INDEX idx_admin_audit_compliance ON admin_audit_log USING gin(compliance_flags) WHERE compliance_flags IS NOT NULL;
CREATE INDEX idx_admin_audit_classification ON admin_audit_log(data_classification, retention_category);
CREATE INDEX idx_admin_audit_complexity ON admin_audit_log(query_complexity_score DESC) WHERE query_complexity_score IS NOT NULL;
```

**Purpose**: Comprehensive audit trail for administrative actions across all tenants.

**Key Features**:
- **Change Tracking**: old_values, new_values for before/after comparisons
- **User Context**: admin_user_id, tenant_id for accountability
- **Technical Context**: ip_address, user_agent for security analysis
- **Compliance**: timestamp, metadata for regulatory requirements

### 8. Admin System Events (Consolidated)

```sql
-- Admin System Events - Unified admin activity and system monitoring
CREATE TABLE admin_system_events (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    event_type TEXT NOT NULL,
    severity TEXT NOT NULL,                    -- 'low', 'medium', 'high', 'critical'
    message TEXT NOT NULL,
    details JSONB,                            -- Flexible storage for event-specific data
    admin_user_id TEXT,                       -- NULL for system events
    tenant_id TEXT,                           -- NULL for system-wide events
    timestamp BIGINT,
    resolved TIMESTAMP WITH TIME ZONE,
    resolution TEXT,
    
    -- Session-specific fields (stored in details JSONB)
    session_token TEXT,                       -- For session events
    ip_address TEXT,                          -- For session and audit events
    user_agent TEXT,                          -- For session and audit events
    device_info TEXT,                         -- For session events
    started BIGINT,                        -- For session events
    last_activity BIGINT,                     -- For session events
    expires BIGINT,                        -- For session events
    is_active BOOLEAN DEFAULT TRUE            -- For session events
);

-- Indexes for consolidated admin system events
CREATE INDEX idx_admin_system_events_type ON admin_system_events(event_type, creation_time DESC);
CREATE INDEX idx_admin_system_events_severity ON admin_system_events(severity, creation_time DESC);
CREATE INDEX idx_admin_system_events_tenant ON admin_system_events(tenant_id, creation_time DESC);
CREATE INDEX idx_admin_system_events_admin_user ON admin_system_events(admin_user_id, creation_time DESC);
CREATE INDEX idx_admin_system_events_unresolved ON admin_system_events(resolved_at) WHERE resolved IS NULL;
CREATE INDEX idx_admin_system_events_session_token ON admin_system_events(session_token) WHERE session_token IS NOT NULL;
CREATE INDEX idx_admin_system_events_active_sessions ON admin_system_events(admin_user_id, is_active) WHERE is_active = true;
CREATE INDEX idx_admin_system_events_timestamp ON admin_system_events(timestamp);
```

**Purpose**: Unified administrative activity tracking including sessions, system events, and audit logs.

**Event Types**:
- **Session Events**: 'session_started', 'session_ended', 'session_extended', 'session_expired'
- **System Events**: 'system_alert', 'performance_degradation', 'security_incident', 'maintenance'
- **Audit Events**: 'user_action', 'configuration_change', 'data_access', 'permission_change'

**Key Features**:
- **Unified Storage**: Both session management and system monitoring in one table
- **Flexible Details**: JSONB field stores event-specific metadata
- **Session Tracking**: session_token, device_info, activity monitoring via details
- **Security Context**: ip_address, user_agent for all admin activities
- **Event Classification**: event_type and severity for prioritization and filtering

**Example Usage**:
```sql
-- Session started event
INSERT INTO admin_system_events (
    event_type, severity, message, admin_user_id, tenant_id,
    session_token, ip_address, user_agent, device_info,
    started_at, expires_at, details
) VALUES (
    'session_started', 'low', 'Admin user logged in',
    'admin_123', 'tenant_456', 'token_abc789', '192.168.1.100',
    'Mozilla/5.0...', 'Chrome on Windows',
    1234567890, 1234567890 + 28800,
    '{"login_method": "password", "mfa_used": true}'
);

-- System alert event
INSERT INTO admin_system_events (
    event_type, severity, message, details
) VALUES (
    'system_alert', 'high', 'High CPU usage detected',
    '{"cpu_usage": 95, "threshold": 80, "duration_minutes": 15, "affected_services": ["email_sending"]}'
);
```

### 9. Admin Audit Log (Separate for Detailed Change Tracking)

```sql
-- Admin System Events - System-wide events and notifications
CREATE TABLE admin_system_events (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    creation_time TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    event_type TEXT NOT NULL,
    severity TEXT NOT NULL,                    -- 'low', 'medium', 'high', 'critical'
    message TEXT NOT NULL,
    details JSONB,
    admin_user_id TEXT,
    tenant_id TEXT,
    timestamp BIGINT,
    resolved TIMESTAMP WITH TIME ZONE,
    resolution TEXT
);

-- Indexes for admin system events
CREATE INDEX idx_admin_system_events_type ON admin_system_events(event_type, creation_time DESC);
CREATE INDEX idx_admin_system_events_severity ON admin_system_events(severity, creation_time DESC);
CREATE INDEX idx_admin_system_events_tenant ON admin_system_events(tenant_id, creation_time DESC);
CREATE INDEX idx_admin_system_events_unresolved ON admin_system_events(resolved_at) WHERE resolved IS NULL;
CREATE INDEX idx_admin_system_events_timestamp ON admin_system_events(timestamp);
```

**Purpose**: System-wide event tracking for monitoring, alerting, and incident management.

**Key Features**:
- **Event Classification**: event_type, severity for prioritization
- **Context Tracking**: admin_user_id, tenant_id for targeted alerts
- **Resolution Tracking**: resolved_at, resolution for incident management
- **Alerting**: Supports real-time monitoring and notification systems

---

## Data Pipeline Implementation

### 1. Analytics Aggregation Service

```typescript
// services/AnalyticsAggregator.ts
import { Database } from '../Database';
import Redis from 'ioredis';

export class AnalyticsAggregator {
  private db: Database;
  private redis: Redis;

  constructor(db: Database, redis: Redis) {
    this.db = db;
    this.redis = redis;
  }

  async aggregateCampaignAnalytics(campaignId: string, date: string) {
    return await this.db.transaction(async (tx) => {
      // Get all steps for this campaign
      const steps = await tx.campaign_sequence_steps.findMany({
        where: { campaign_id: campaignId }
      });

      let totalSent = 0;
      let totalDelivered = 0;
      let totalOpened = 0;
      let totalClicked = 0;
      let totalReplied = 0;
      let totalBounced = 0;
      let totalUnsubscribed = 0;
      let totalSpamComplaints = 0;

      // Aggregate metrics from all steps
      for (const step of steps) {
        const stepMetrics = await tx.execute(sql`
          SELECT 
            COUNT(*) as sent,
            COUNT(CASE WHEN status = 'delivered' THEN 1 END) as delivered,
            COUNT(CASE WHEN opened IS NOT NULL THEN 1 END) as opened_tracked,
            COUNT(CASE WHEN clicked IS NOT NULL THEN 1 END) as clicked_tracked,
            COUNT(CASE WHEN replied IS NOT NULL THEN 1 END) as replied,
            COUNT(CASE WHEN bounce_type IS NOT NULL THEN 1 END) as bounced,
            COUNT(CASE WHEN unsubscribed IS NOT NULL THEN 1 END) as unsubscribed,
            COUNT(CASE WHEN complaint IS NOT NULL THEN 1 END) as spam_complaints
          FROM emails 
          WHERE campaign_id = ${campaignId} 
            AND sequence_step_id = ${step.id}
            AND DATE(sent_at) = ${date}
        `);

        totalSent += stepMetrics[0].sent;
        totalDelivered += stepMetrics[0].delivered;
        totalOpened += stepMetrics[0].opened_tracked;
        totalClicked += stepMetrics[0].clicked_tracked;
        totalReplied += stepMetrics[0].replied;
        totalBounced += stepMetrics[0].bounced;
        totalUnsubscribed += stepMetrics[0].unsubscribed;
        totalSpamComplaints += stepMetrics[0].spam_complaints;
      }

      // Insert or update campaign analytics
      await tx.campaign_analytics.upsert({
        where: {
          campaign_id_date: {
            campaign_id: campaignId,
            // You might want to add a date column or use updated_at
          }
        },
        create: {
          campaign_id: campaignId,
          company_id: steps[0]?.company_id || '',
          sent: totalSent,
          delivered: totalDelivered,
          opened_tracked: totalOpened,
          clicked_tracked: totalClicked,
          replied: totalReplied,
          bounced: totalBounced,
          unsubscribed: totalUnsubscribed,
          spam_complaints: totalSpamComplaints,
          status: 'active',
          updated_at: new Date()
        },
        update: {
          sent: totalSent,
          delivered: totalDelivered,
          opened_tracked: totalOpened,
          clicked_tracked: totalClicked,
          replied: totalReplied,
          bounced: totalBounced,
          unsubscribed: totalUnsubscribed,
          spam_complaints: totalSpamComplaints,
          updated_at: new Date()
        }
      });

      return {
        campaign_id: campaignId,
        sent: totalSent,
        delivered: totalDelivered,
        opened_tracked: totalOpened,
        clicked_tracked: totalClicked,
        replied: totalReplied,
        bounced: totalBounced,
        unsubscribed: totalUnsubscribed,
        spam_complaints: totalSpamComplaints
      };
    });
  }

  async aggregateBillingAnalytics(tenantId: string, periodStart: Date, periodEnd: Date) {
    return await this.db.transaction(async (tx) => {
      // Get all usage metrics for the period
      const usage = await tx.execute(sql`
        SELECT 
          COUNT(DISTINCT c.id) as campaigns_used,
          COUNT(DISTINCT ea.id) as mailboxes_used,
          COUNT(DISTINCT d.id) as domains_used,
          COUNT(DISTINCT l.id) as leads_used,
          COUNT(DISTINCT w.id) as warmups_active,
          COUNT(e.id) as emails_sent
        FROM tenants t
        LEFT JOIN campaigns c ON t.id = c.tenant_id AND c.created BETWEEN ${periodStart} AND ${periodEnd}
        LEFT JOIN email_accounts ea ON t.id = ea.tenant_id AND ea.created BETWEEN ${periodStart} AND ${periodEnd}
        LEFT JOIN domains d ON t.id = d.tenant_id AND d.created BETWEEN ${periodStart} AND ${periodEnd}
        LEFT JOIN leads l ON t.id = l.tenant_id AND l.imported BETWEEN ${periodStart} AND ${periodEnd}
        LEFT JOIN warmup_status w ON t.id = w.tenant_id AND w.status = 'active'
        LEFT JOIN emails e ON t.id = e.tenant_id AND e.sent BETWEEN ${periodStart} AND ${periodEnd}
        WHERE t.id = ${tenantId}
        GROUP BY t.id
      `);

      const metrics = usage[0] || {
        campaigns_used: 0,
        mailboxes_used: 0,
        domains_used: 0,
        leads_used: 0,
        warmups_active: 0,
        emails_sent: 0
      };

      // Insert or update billing analytics
      await tx.billing_analytics.upsert({
        where: {
          tenant_id_period_start: {
            tenant_id: tenantId,
            period_start: periodStart
          }
        },
        create: {
          tenant_id: tenantId,
          period_start: periodStart,
          period_end: periodEnd,
          ...metrics,
          updated_at: new Date()
        },
        update: {
          ...metrics,
          updated_at: new Date()
        }
      });

      return metrics;
    });
  }
}
```

### 2. Queue-Driven Analytics Processing

```typescript
// workers/AnalyticsWorker.ts
import { AnalyticsAggregator } from '../services/AnalyticsAggregator';
import { JobProcessor } from './JobProcessor';

export class AnalyticsWorker extends JobProcessor {
  private aggregator: AnalyticsAggregator;

  constructor(aggregator: AnalyticsAggregator) {
    super('analytics');
    this.aggregator = aggregator;
  }

  async processDailyAggregate(data: any) {
    const { date, tenant_id } = data;
    
    try {
      // Get all campaigns for this tenant on this date
      const campaigns = await this.db.campaigns.findMany({
        where: {
          tenant_id,
          sent_at: {
            gte: new Date(date),
            lt: new Date(date + ' 23:59:59')
          }
        }
      });

      // Aggregate each campaign
      for (const campaign of campaigns) {
        await this.aggregator.aggregateCampaignAnalytics(campaign.id, date);
      }

      // Aggregate billing analytics
      const periodStart = new Date(date + ' 00:00:00');
      const periodEnd = new Date(date + ' 23:59:59');
      await this.aggregator.aggregateBillingAnalytics(tenant_id, periodStart, periodEnd);

      console.log(`Daily analytics aggregated for ${tenant_id} on ${date}`);

    } catch (error) {
      console.error('Daily aggregate failed:', error);
      throw error;
    }
  }

  async processCampaignAggregate(data: any) {
    const { campaign_id, date } = data;
    
    try {
      await this.aggregator.aggregateCampaignAnalytics(campaign_id, date);
      console.log(`Campaign analytics aggregated for ${campaign_id}`);
      
    } catch (error) {
      console.error('Campaign aggregate failed:', error);
      throw error;
    }
  }

  async processBillingCalculate(data: any) {
    const { tenant_id, period_start, period_end } = data;
    
    try {
      await this.aggregator.aggregateBillingAnalytics(
        tenant_id, 
        new Date(period_start), 
        new Date(period_end)
      );
      console.log(`Billing analytics calculated for ${tenant_id}`);
      
    } catch (error) {
      console.error('Billing calculate failed:', error);
      throw error;
    }
  }
}
```

---

## Business Intelligence Queries

### 1. Campaign Performance Dashboard

```sql
-- Campaign performance summary with trends
WITH campaign_performance AS (
  SELECT 
    ca.campaign_id,
    ca.company_id,
    ca.sent,
    ca.delivered,
    ca.opened_tracked,
    ca.clicked_tracked,
    ca.replied,
    ca.bounced,
    ROUND((ca.delivered::DECIMAL / NULLIF(ca.sent, 0)) * 100, 2) as delivery_rate,
    ROUND((ca.opened_tracked::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as open_rate,
    ROUND((ca.clicked_tracked::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as click_rate,
    ROUND((ca.replied::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as reply_rate,
    ROUND((ca.bounced::DECIMAL / NULLIF(ca.sent, 0)) * 100, 2) as bounce_rate,
    ca.updated_at
  FROM campaign_analytics ca
  WHERE ca.company_id = $1
    AND ca.updated >= NOW() - INTERVAL '30 days'
),
ranked_campaigns AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (ORDER BY sent DESC) as rank_by_volume,
    ROW_NUMBER() OVER (ORDER BY open_rate DESC) as rank_by_open_rate,
    ROW_NUMBER() OVER (ORDER BY reply_rate DESC) as rank_by_reply_rate
  FROM campaign_performance
)
SELECT 
  campaign_id,
  sent,
  delivered,
  opened_tracked,
  clicked_tracked,
  replied,
  bounced,
  delivery_rate,
  open_rate,
  click_rate,
  reply_rate,
  bounce_rate,
  rank_by_volume,
  rank_by_open_rate,
  rank_by_reply_rate,
  updated_at
FROM ranked_campaigns
ORDER BY sent DESC;
```

### 2. Tenant Usage Analytics

```sql
-- Monthly usage summary across all tenants
SELECT 
  ba.tenant_id,
  ba.period_start,
  ba.period_end,
  ba.emails_sent,
  ba.mailboxes_used,
  ba.domains_used,
  ba.campaigns_used,
  ba.leads_used,
  ba.warmups_active,
  -- Calculate usage efficiency metrics
  ROUND(ba.emails_sent::DECIMAL / NULLIF(ba.mailboxes_used, 0), 2) as emails_per_mailbox,
  ROUND(ba.emails_sent::DECIMAL / NULLIF(ba.campaigns_used, 0), 2) as emails_per_campaign,
  -- Compare to previous month
  LAG(ba.emails_sent) OVER (PARTITION BY ba.tenant_id ORDER BY ba.period_start) as prev_month_emails,
  ROUND(
    (ba.emails_sent - LAG(ba.emails_sent) OVER (PARTITION BY ba.tenant_id ORDER BY ba.period_start))::DECIMAL 
    / NULLIF(LAG(ba.emails_sent) OVER (PARTITION BY ba.tenant_id ORDER BY ba.period_start), 0) * 100, 
    2
  ) as month_over_month_growth
FROM billing_analytics ba
WHERE ba.period_start >= NOW() - INTERVAL '3 months'
ORDER BY ba.tenant_id, ba.period_start;
```

### 3. Warmup Performance Analytics

```sql
-- Warmup progression analysis
WITH warmup_progress AS (
  SELECT 
    wa.mailbox_id,
    wa.company_id,
    wa.health_score,
    wa.progress_percentage,
    wa.sent,
    wa.delivered,
    ROUND((wa.delivered::DECIMAL / NULLIF(wa.sent, 0)) * 100, 2) as delivery_rate,
    -- Calculate progression velocity
    wa.progress_percentage - LAG(wa.progress_percentage) OVER (
      PARTITION BY wa.mailbox_id ORDER BY wa.updated_at
    ) as daily_progress_increase,
    wa.updated_at
  FROM warmup_analytics wa
  WHERE wa.updated >= NOW() - INTERVAL '7 days'
)
SELECT 
  mailbox_id,
  company_id,
  AVG(health_score) as avg_health_score,
  AVG(progress_percentage) as avg_progress,
  AVG(delivery_rate) as avg_delivery_rate,
  AVG(daily_progress_increase) as avg_daily_progress,
  COUNT(*) as tracking_days,
  -- Categorize warmup performance
  CASE 
    WHEN AVG(health_score) >= 80 THEN 'Excellent'
    WHEN AVG(health_score) >= 60 THEN 'Good'
    WHEN AVG(health_score) >= 40 THEN 'Fair'
    ELSE 'Poor'
  END as warmup_category
FROM warmup_progress
GROUP BY mailbox_id, company_id
HAVING COUNT(*) >= 3  -- At least 3 days of tracking
ORDER BY avg_health_score DESC, avg_progress DESC;
```

### 4. Administrative Activity Analysis

```sql
-- Admin activity summary for compliance
SELECT 
  aal.admin_user_id,
  aal.action,
  aal.resource_type,
  COUNT(*) as action_count,
  COUNT(DISTINCT aal.tenant_id) as tenants_affected,
  aal.creation_time::DATE as activity_date,
  -- Security analysis
  COUNT(DISTINCT aal.ip_address) as unique_ips,
  -- Time-based analysis
  EXTRACT(HOUR FROM aal.creation_time) as hour_of_day,
  CASE 
    WHEN EXTRACT(HOUR FROM aal.creation_time) BETWEEN 9 AND 17 THEN 'Business Hours'
    WHEN EXTRACT(HOUR FROM aal.creation_time) BETWEEN 18 AND 22 THEN 'After Hours'
    ELSE 'Night Time'
  END as time_category
FROM admin_audit_log aal
WHERE aal.creation_time >= NOW() - INTERVAL '30 days'
GROUP BY 
  aal.admin_user_id,
  aal.action,
  aal.resource_type,
  aal.creation_time::DATE,
  EXTRACT(HOUR FROM aal.creation_time)
ORDER BY action_count DESC, activity_date DESC;
```

---

## Performance Optimization

### 1. Materialized Views for Complex Analytics

```sql
-- Campaign performance materialized view
CREATE MATERIALIZED VIEW campaign_performance_summary AS
SELECT 
  ca.campaign_id,
  ca.company_id,
  c.name as campaign_name,
  c.status as campaign_status,
  ca.sent,
  ca.delivered,
  ca.opened_tracked,
  ca.clicked_tracked,
  ca.replied,
  ca.bounced,
  ca.unsubscribed,
  ca.spam_complaints,
  -- Calculated rates
  ROUND((ca.delivered::DECIMAL / NULLIF(ca.sent, 0)) * 100, 2) as delivery_rate,
  ROUND((ca.opened_tracked::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as open_rate,
  ROUND((ca.clicked_tracked::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as click_rate,
  ROUND((ca.replied::DECIMAL / NULLIF(ca.delivered, 0)) * 100, 2) as reply_rate,
  ROUND((ca.bounced::DECIMAL / NULLIF(ca.sent, 0)) * 100, 2) as bounce_rate,
  -- Time-based metrics
  EXTRACT(EPOCH FROM (c.completed - c.started_at))/3600 as campaign_duration_hours,
  ca.updated_at
FROM campaign_analytics ca
JOIN campaigns c ON ca.campaign_id = c.id;

-- Refresh strategy
CREATE INDEX idx_campaign_performance_company ON campaign_performance_summary(company_id);
CREATE INDEX idx_campaign_performance_status ON campaign_performance_summary(campaign_status);
CREATE INDEX idx_campaign_performance_updated ON campaign_performance_summary(updated_at);

-- Refresh function
CREATE OR REPLACE FUNCTION refresh_campaign_performance()
RETURNS void AS $$
BEGIN
  REFRESH MATERIALIZED VIEW CONCURRENTLY campaign_performance_summary;
END;
$$ LANGUAGE plpgsql;
```

### 2. Partitioning Strategy for Large Tables

```sql
-- Partition billing_analytics by month
CREATE TABLE billing_analytics_partitioned (
    LIKE billing_analytics INCLUDING ALL
) PARTITION BY RANGE (period_start);

-- Create monthly partitions
CREATE TABLE billing_analytics_2025_01 PARTITION OF billing_analytics_partitioned
FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

CREATE TABLE billing_analytics_2025_02 PARTITION OF billing_analytics_partitioned
FOR VALUES FROM ('2025-02-01') TO ('2025-03-01');

-- Continue for other months...

-- Indexes on partition tables
CREATE INDEX idx_billing_analytics_2025_01_tenant ON billing_analytics_2025_01(tenant_id);
CREATE INDEX idx_billing_analytics_2025_02_tenant ON billing_analytics_2025_02(tenant_id);
```

### 3. Automated Maintenance

```sql
-- Analytics maintenance function
CREATE OR REPLACE FUNCTION maintain_analytics_tables()
RETURNS void AS $$
DECLARE
    cutoff_date DATE := CURRENT_DATE - INTERVAL '2 years';
BEGIN
    -- Archive old analytics data
    INSERT INTO analytics_archive 
    SELECT * FROM campaign_analytics 
    WHERE updated < cutoff_date;
    
    DELETE FROM campaign_analytics 
    WHERE updated < cutoff_date;
    
    -- Refresh materialized views
    PERFORM refresh_campaign_performance();
    
    -- Update table statistics
    ANALYZE campaign_analytics;
    ANALYZE mailbox_analytics;
    ANALYZE billing_analytics;
    
    -- Log maintenance
    INSERT INTO admin_system_events (
        event_type,
        severity,
        message,
        details
    ) VALUES (
        'analytics_maintenance',
        'low',
        'Analytics tables maintenance completed',
        jsonb_build_object(
            'cutoff_date', cutoff_date,
            'maintenance_time', NOW()
        )
    );
END;
$$ LANGUAGE plpgsql;
```

---

## Security and Compliance

### **OLAP Connection Pooling Strategy**
```sql
-- OLAP analytics connection pool configuration
CREATE TABLE analytics_connection_pools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pool_type VARCHAR(30) CHECK (pool_type IN ('dashboard_queries', 'report_generation', 'data_exports', 'ad_hoc_analytics')),
    min_connections INTEGER DEFAULT 2,
    max_connections INTEGER DEFAULT 12,
    connection_timeout_seconds INTEGER DEFAULT 120,
    idle_timeout_seconds INTEGER DEFAULT 1800,
    max_lifetime_seconds INTEGER DEFAULT 7200,
    acquire_timeout_seconds INTEGER DEFAULT 180,
    query_timeout_seconds INTEGER DEFAULT 300,
    memory_limit_mb INTEGER DEFAULT 512,
    temp_space_limit_mb INTEGER DEFAULT 1024,
    enable_parallel_queries BOOLEAN DEFAULT TRUE,
    max_parallel_workers INTEGER DEFAULT 4,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(pool_type)
);

-- Analytics pool sizing based on query complexity
INSERT INTO analytics_connection_pools (
    pool_type, min_connections, max_connections,
    connection_timeout_seconds, query_timeout_seconds,
    enable_parallel_queries, max_parallel_workers
) VALUES
('dashboard_queries', 3, 15, 60, 30, true, 2),      -- Fast dashboard queries
('report_generation', 2, 8, 120, 600, true, 4),     -- Complex report generation
('data_exports', 1, 5, 180, 1800, false, 1),        -- Large data exports
('ad_hoc_analytics', 2, 10, 90, 300, true, 3);      -- Exploratory analytics

-- Analytics pool performance metrics
CREATE TABLE analytics_pool_metrics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    pool_type VARCHAR(30),
    collected_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active_connections INTEGER,
    idle_connections INTEGER,
    pending_connections INTEGER,
    active_queries INTEGER,
    query_queue_depth INTEGER,
    avg_query_duration_ms INTEGER,
    max_query_duration_ms INTEGER,
    total_queries_executed BIGINT,
    cache_hit_rate DECIMAL(5,2),
    memory_usage_mb INTEGER,
    temp_space_usage_mb INTEGER,
    parallel_workers_used_avg DECIMAL(3,1),
    query_timeout_count INTEGER DEFAULT 0,
    connection_timeout_count INTEGER DEFAULT 0
);

-- Analytics pool optimization function
CREATE OR REPLACE FUNCTION optimize_analytics_pools()
RETURNS void AS $$
DECLARE
    query_patterns RECORD;
    pool_utilization RECORD;
    optimization_needed BOOLEAN := FALSE;
BEGIN
    -- Analyze query patterns over last 24 hours
    SELECT
        AVG(avg_query_duration_ms) as avg_duration,
        MAX(max_query_duration_ms) as max_duration,
        AVG(active_queries) as avg_concurrent,
        MAX(active_queries) as peak_concurrent,
        SUM(query_timeout_count) as timeout_count,
        AVG(cache_hit_rate) as avg_cache_hit
    INTO query_patterns
    FROM analytics_pool_metrics
    WHERE collected_at >= NOW() - INTERVAL '24 hours';

    -- Check pool utilization
    SELECT
        pool_type,
        AVG(active_connections::DECIMAL / max_connections) * 100 as utilization_rate,
        AVG(pending_connections) as avg_pending
    INTO pool_utilization
    FROM analytics_connection_pools cp
    JOIN analytics_pool_metrics pm ON cp.pool_type = pm.pool_type
    WHERE pm.collected_at >= NOW() - INTERVAL '1 hour'
    GROUP BY pool_type, max_connections;

    -- Optimize based on patterns
    -- High concurrent load: increase connections for dashboard queries
    IF query_patterns.avg_concurrent > 8 THEN
        UPDATE analytics_connection_pools
        SET max_connections = LEAST(max_connections + 3, 25)
        WHERE pool_type = 'dashboard_queries';
        optimization_needed := TRUE;
    END IF;

    -- Long-running reports: increase timeouts and workers
    IF query_patterns.avg_duration > 60000 THEN -- > 1 minute
        UPDATE analytics_connection_pools
        SET query_timeout_seconds = LEAST(query_timeout_seconds + 300, 3600),
            max_parallel_workers = LEAST(max_parallel_workers + 1, 8)
        WHERE pool_type = 'report_generation';
        optimization_needed := TRUE;
    END IF;

    -- High timeout rate: optimize query performance
    IF query_patterns.timeout_count > 10 THEN
        -- This would trigger query optimization recommendations
        INSERT INTO analytics_access_audit (
            query_type, table_accessed, success, failure_reason
        ) VALUES (
            'system_optimization', 'query_performance',
            false, 'high_timeout_rate_detected'
        );
        optimization_needed := TRUE;
    END IF;

    -- Log optimization actions if any changes made
    IF optimization_needed THEN
        INSERT INTO admin_system_events (
            event_type, severity, message, details
        ) VALUES (
            'pool_optimization',
            'info',
            'Analytics connection pools optimized based on query patterns',
            jsonb_build_object(
                'avg_query_duration_ms', query_patterns.avg_duration,
                'peak_concurrent_queries', query_patterns.peak_concurrent,
                'timeout_count_24h', query_patterns.timeout_count,
                'cache_hit_rate', query_patterns.avg_cache_hit,
                'optimization_timestamp', NOW()
            )
        );
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### **Unified Security Policies for Analytics**
```sql
-- Enhanced RLS on all analytics tables
ALTER TABLE billing_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaign_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE mailbox_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE warmup_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE sequence_step_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE admin_system_events ENABLE ROW LEVEL SECURITY;

-- Cross-tier tenant isolation policies
CREATE POLICY billing_analytics_tenant_isolation ON billing_analytics
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::text);

CREATE POLICY campaign_analytics_tenant_isolation ON campaign_analytics
    FOR ALL USING (company_id IN (
        SELECT id FROM companies
        WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
    ));

CREATE POLICY mailbox_analytics_tenant_isolation ON mailbox_analytics
    FOR ALL USING (company_id IN (
        SELECT id FROM companies
        WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
    ));

CREATE POLICY lead_analytics_tenant_isolation ON lead_analytics
    FOR ALL USING (EXISTS (
        SELECT 1 FROM campaign_analytics ca
        WHERE ca.campaign_id = lead_analytics.campaign_id
        AND ca.company_id IN (
            SELECT id FROM companies
            WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
        )
    ));

CREATE POLICY warmup_analytics_tenant_isolation ON warmup_analytics
    FOR ALL USING (company_id IN (
        SELECT id FROM companies
        WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
    ));

CREATE POLICY sequence_step_analytics_tenant_isolation ON sequence_step_analytics
    FOR ALL USING (company_id IN (
        SELECT id FROM companies
        WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
    ));

-- Admin access control - only admin users can access audit logs
CREATE POLICY admin_audit_logs_access ON admin_audit_logs
    FOR ALL USING (
        current_setting('app.user_role') = 'admin'
        OR tenant_id = current_setting('app.current_tenant_id')::text
    );

CREATE POLICY admin_system_events_access ON admin_system_events
    FOR ALL USING (
        current_setting('app.user_role') = 'admin'
        OR tenant_id = current_setting('app.current_tenant_id')::text
    );
```

### **Analytics Security Tables**
```sql
-- Analytics access audit log
CREATE TABLE analytics_access_audit (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    user_id TEXT,
    tenant_id TEXT,
    query_type VARCHAR(50) CHECK (query_type IN ('dashboard', 'report', 'export', 'api')),
    table_accessed VARCHAR(100),
    filters_applied JSONB,
    rows_returned INTEGER,
    query_duration_ms INTEGER,
    ip_address TEXT,
    user_agent TEXT,
    success BOOLEAN DEFAULT TRUE,
    failure_reason TEXT,
    data_sensitivity VARCHAR(20) CHECK (data_sensitivity IN ('public', 'internal', 'confidential')),
    compliance_check_passed BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Analytics rate limiting per tenant
CREATE TABLE analytics_rate_limits (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tenant_id TEXT NOT NULL,
    query_type VARCHAR(50),
    time_window_seconds INTEGER DEFAULT 3600,
    max_queries INTEGER NOT NULL,
    current_count INTEGER DEFAULT 0,
    window_start TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(tenant_id, query_type, time_window_seconds)
);

-- Data export security controls
CREATE TABLE analytics_export_controls (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tenant_id TEXT NOT NULL,
    export_type VARCHAR(50) CHECK (export_type IN ('csv', 'json', 'pdf', 'xlsx')),
    max_rows INTEGER DEFAULT 10000,
    requires_approval BOOLEAN DEFAULT FALSE,
    auto_expires_hours INTEGER DEFAULT 24,
    encryption_required BOOLEAN DEFAULT TRUE,
    watermark_required BOOLEAN DEFAULT TRUE,
    created_by TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Security monitoring indexes
CREATE INDEX idx_analytics_access_tenant ON analytics_access_audit(tenant_id, created DESC);
CREATE INDEX idx_analytics_access_user ON analytics_access_audit(user_id, created DESC);
CREATE INDEX idx_analytics_rate_limits_tenant ON analytics_rate_limits(tenant_id, window_start DESC);
```

### **Analytics Security Functions**
```sql
-- Query access validation for analytics
CREATE OR REPLACE FUNCTION validate_analytics_access(
    p_tenant_id TEXT,
    p_user_id TEXT,
    p_query_type VARCHAR(50),
    p_table_accessed VARCHAR(100)
)
RETURNS BOOLEAN AS $$
DECLARE
    rate_limit_record RECORD;
    current_window TIMESTAMP;
BEGIN
    -- Calculate current rate limit window
    current_window := date_trunc('hour', NOW());

    -- Check rate limits for this tenant/query type
    SELECT * INTO rate_limit_record
    FROM analytics_rate_limits
    WHERE tenant_id = p_tenant_id
    AND (query_type = p_query_type OR query_type IS NULL)
    AND window_start >= current_window
    AND is_active = true
    ORDER BY query_type NULLS LAST
    LIMIT 1;

    IF FOUND THEN
        IF rate_limit_record.current_count >= rate_limit_record.max_queries THEN
            -- Log rate limit violation
            INSERT INTO analytics_access_audit (
                user_id, tenant_id, query_type, table_accessed,
                success, failure_reason, data_sensitivity
            ) VALUES (
                p_user_id, p_tenant_id, p_query_type, p_table_accessed,
                false, 'rate_limit_exceeded', 'internal'
            );
            RETURN FALSE;
        END IF;

        -- Increment counter
        UPDATE analytics_rate_limits
        SET current_count = current_count + 1
        WHERE id = rate_limit_record.id;
    END IF;

    -- Log successful access
    INSERT INTO analytics_access_audit (
        user_id, tenant_id, query_type, table_accessed,
        success, data_sensitivity
    ) VALUES (
        p_user_id, p_tenant_id, p_query_type, p_table_accessed,
        true, 'internal'
    );

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Export approval workflow
CREATE OR REPLACE FUNCTION request_analytics_export(
    p_tenant_id TEXT,
    p_user_id TEXT,
    p_export_type VARCHAR(50),
    p_row_count INTEGER
)
RETURNS UUID AS $$
DECLARE
    export_control RECORD;
    export_request_id UUID := gen_random_uuid();
BEGIN
    -- Check export controls for this tenant
    SELECT * INTO export_control
    FROM analytics_export_controls
    WHERE tenant_id = p_tenant_id
    AND export_type = p_export_type
    AND is_active = true;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Export type not allowed for this tenant';
    END IF;

    -- Check row limits
    IF p_row_count > export_control.max_rows THEN
        RAISE EXCEPTION 'Export exceeds maximum allowed rows (%)', export_control.max_rows;
    END IF;

    -- Log export request
    INSERT INTO analytics_access_audit (
        user_id, tenant_id, query_type, table_accessed,
        filters_applied, rows_returned, data_sensitivity
    ) VALUES (
        p_user_id, p_tenant_id, 'export', 'multiple_tables',
        jsonb_build_object('export_type', p_export_type, 'request_id', export_request_id),
        p_row_count, 'confidential'
    );

    -- If approval required, create approval request (would integrate with notification system)
    IF export_control.requires_approval THEN
        -- This would trigger an approval workflow
        NULL; -- Placeholder for approval workflow integration
    END IF;

    RETURN export_request_id;
END;
$$ LANGUAGE plpgsql;
```

```sql
-- Enable RLS on all analytics tables
ALTER TABLE billing_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE campaign_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE mailbox_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE lead_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE warmup_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE sequence_step_analytics ENABLE ROW LEVEL SECURITY;

-- RLS policies for tenant isolation
CREATE POLICY analytics_tenant_isolation ON billing_analytics
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id'));

CREATE POLICY campaign_analytics_tenant_isolation ON campaign_analytics
    FOR ALL USING (company_id IN (
        SELECT id FROM companies 
        WHERE tenant_id = current_setting('app.current_tenant_id')
    ));

-- Similar policies for other tables...
```

### 2. Data Anonymization

```sql
-- Anonymization function for GDPR compliance
CREATE OR REPLACE FUNCTION anonymize_analytics_data(tenant_id_param TEXT)
RETURNS VOID AS $$
BEGIN
    -- Anonymize tenant_id while preserving analytics relationships
    UPDATE billing_analytics 
    SET tenant_id = 'anonymized_' || tenant_id_param
    WHERE tenant_id = tenant_id_param;
    
    UPDATE campaign_analytics 
    SET company_id = 'anonymized_' || company_id
    WHERE company_id IN (
        SELECT id FROM companies 
        WHERE tenant_id = tenant_id_param
    );
    
    -- Similar updates for other tables...
    
    -- Log the anonymization
    INSERT INTO admin_audit_log (
        admin_user_id,
        action,
        resource_type,
        resource_id,
        tenant_id,
        notes
    ) VALUES (
        'system',
        'anonymize_analytics',
        'tenant',
        tenant_id_param,
        tenant_id_param,
        'Analytics data anonymized for GDPR compliance'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## Conclusion

The OLAP analytics schema provides PenguinMails with comprehensive business intelligence capabilities while maintaining security, performance, and compliance requirements. The schema supports:

- **Real-time Analytics**: Queue-driven aggregation for fresh data
- **Historical Analysis**: Long-term trend analysis and forecasting
- **Business Intelligence**: Comprehensive reporting and dashboards
- **Compliance**: Audit trails and data governance features
- **Performance**: Optimized queries and materialized views

For implementation support or analytics queries, contact the Data Engineering team.

---

**Related Documents:**
- [Analytics Architecture](analytics_architecture.md) - Overall analytics system design
- [Database Schema Guide](database_schema_guide.md) - Complete database schema including OLTP tables
- [Queue System Implementation Guide](queue_system_implementation_guide.md) - Queue-driven analytics pipeline

**Keywords**: OLAP, analytics, business intelligence, data warehousing, reporting, analytics schema, campaign analytics, billing analytics, administrative analytics