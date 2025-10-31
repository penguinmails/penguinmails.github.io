---
last_modified_date: "2025-10-28"
---

# Metrics & KPIs

---

## Executive Summary

This document defines the key metrics and KPIs that drive PenguinMails' business decisions, product development, and growth strategies. All metrics are designed to provide actionable insights for continuous improvement.

## Core Metric Categories

### North Star Metric
**Monthly Recurring Revenue (MRR)** - Primary measure of business health and growth

### Growth Metrics
- **Monthly Active Users (MAU)**
- **Customer Acquisition Rate**
- **Revenue Growth Rate**
- **Market Share Growth**

### Financial Metrics
- **Customer Lifetime Value (LTV)**
- **Customer Acquisition Cost (CAC)**
- **Monthly Churn Rate**
- **Gross Revenue Margin**

### Product Metrics
- **Feature Adoption Rate**
- **Time to First Value**
- **User Engagement Score**
- **Product Qualified Leads (PQLs)**

### Email Performance Metrics
- **Deliverability Rate**
- **Open Rate**
- **Click-Through Rate (CTR)**
- **Conversion Rate**

## Detailed KPI Definitions

### Growth & Acquisition KPIs

#### **Customer Acquisition Cost (CAC)**
- **Formula**: Total marketing + sales spend / Number of new customers
- **Target**: <$XXX per customer
- **Measurement**: Monthly, rolling 12-month average
- **Breakdown**: Paid ads, content marketing, sales team, partnerships

#### **Customer Lifetime Value (LTV)**
- **Formula**: Average revenue per user × customer lifespan
- **Target**: >$XXXX per customer
- **Measurement**: Rolling 12-month cohorts
- **Factors**: Subscription tier, retention rate, upsell revenue

#### **Monthly Recurring Revenue (MRR)**
- **Formula**: Sum of all active subscriptions
- **Target**: $XXXK by end of year 1
- **Measurement**: End of month calculation
- **Components**: New subscriptions, expansions, churn

#### **Annual Recurring Revenue (ARR)**
- **Formula**: MRR × 12
- **Target**: $XM by end of year 1
- **Measurement**: Annual calculation
- **Use Case**: Investor reporting, strategic planning

### Retention & Engagement KPIs

#### **Monthly Churn Rate**
- **Formula**: Customers lost during month / Total customers at start of month
- **Target**: <5%
- **Measurement**: Monthly, segmented by cohort
- **Types**: Voluntary churn, involuntary churn, expansion churn

#### **Net Revenue Retention**
- **Formula**: (Starting ARR + Expansion - Churn) / Starting ARR
- **Target**: >110%
- **Measurement**: Monthly cohorts
- **Components**: Upgrades, downgrades, churn

#### **Customer Satisfaction (NPS)**
- **Formula**: % Promoters - % Detractors
- **Target**: >50
- **Measurement**: Monthly surveys
- **Segmentation**: By plan tier, usage level, support interactions

#### **Product Engagement Score**
- **Formula**: Composite of daily active users, feature usage, session length
- **Target**: >75/100
- **Measurement**: Daily, weekly aggregation
- **Components**: Login frequency, feature usage depth, time spent

### Product Performance KPIs

#### **Time to First Value**
- **Definition**: Time from signup to first successful email send
- **Target**: <30 minutes
- **Measurement**: Automated tracking in onboarding flow
- **Breakdown**: By user segment, device type, referral source

#### **Feature Adoption Rate**
- **Formula**: Users using feature / Total eligible users
- **Target**: >60% for core features
- **Measurement**: Weekly, by feature category
- **Categories**: Campaign creation, IP management, analytics

#### **Support Ticket Resolution Time**
- **Formula**: Average time from ticket creation to resolution
- **Target**: <4 hours for critical, <24 hours for normal
- **Measurement**: Daily, by priority level
- **Breakdown**: By issue type, support channel, time of day

### Email Performance KPIs

#### **Deliverability Rate**
- **Formula**: Emails delivered / Emails sent
- **Target**: >98%
- **Measurement**: Real-time, per campaign
- **Factors**: IP reputation, content quality, recipient engagement

#### **Inbox Placement Rate**
- **Formula**: Emails in inbox / Emails delivered
- **Target**: >95%
- **Measurement**: Third-party monitoring services
- **Breakdown**: By ISP, domain, sending volume

#### **Bounce Rate**
- **Formula**: Hard bounces / Total sends
- **Target**: <2%
- **Measurement**: Real-time, automated alerts at 3%
- **Types**: Hard bounces, soft bounces, spam complaints

#### **Sender Reputation Score**
- **Formula**: Composite score from multiple reputation providers
- **Target**: >85/100
- **Measurement**: Daily, per IP/domain
- **Providers**: Google Postmaster, Microsoft SNDS, etc.

## KPI Dashboards

### Executive Dashboard
- **MRR Growth**: Month-over-month, year-over-year
- **Customer Metrics**: Acquisition, retention, LTV/CAC ratio
- **Product Health**: Uptime, critical bugs, support tickets
- **Financial Health**: Burn rate, runway, profitability

### Product Dashboard
- **User Engagement**: DAU/MAU, session length, feature usage
- **Onboarding Success**: Completion rates, time to value
- **Email Performance**: Deliverability, reputation scores
- **Quality Metrics**: Bug rates, performance issues

### Growth Dashboard
- **Acquisition Channels**: CAC by channel, conversion rates
- **Market Penetration**: Market share, competitive positioning
- **Expansion Revenue**: Upsell rates, plan migrations
- **Customer Success**: NPS, retention by cohort

## Alert Thresholds & Monitoring

### Critical Alerts (Immediate Action Required)
- **System Downtime**: >5 minutes
- **Deliverability Drop**: >5% below target
- **Security Incident**: Any confirmed breach
- **Data Loss**: Any production data loss

### Warning Alerts (Action Within 24 Hours)
- **MRR Decline**: >10% month-over-month
- **Churn Spike**: >15% above baseline
- **Support Backlog**: >50 open tickets
- **Performance Degradation**: >20% slower than baseline

### Trend Alerts (Weekly Review)
- **Engagement Decline**: >10% drop in key metrics
- **Competition Changes**: New features from competitors
- **Market Shifts**: Changes in email deliverability landscape

## Data Collection & Analysis

### Data Sources
- **Product Analytics**: PostHog events, user behavior tracking
- **Business Intelligence**: Stripe payments, subscription data
- **Customer Success**: Support tickets, NPS surveys
- **External Monitoring**: Email reputation services, uptime monitors

### Analysis Framework
- **Cohort Analysis**: User behavior by signup month
- **Funnel Analysis**: Conversion rates through user journey
- **Attribution Modeling**: Revenue attribution to marketing channels
- **Predictive Modeling**: Churn prediction, LTV forecasting

## Metric Ownership

### Executive Team
- **MRR/ARR Growth**: CEO
- **Customer Satisfaction**: COO
- **Market Share**: CMO
- **Product-Market Fit**: CPO

### Department Leads
- **Engineering**: System uptime, performance metrics
- **Product**: Feature adoption, user engagement
- **Marketing**: CAC, conversion rates, brand metrics
- **Sales**: Deal size, sales cycle, win rates
- **Customer Success**: Retention, NPS, support metrics

## Performance Monitoring Implementation

### System Health KPIs
- **Uptime**: 99.9% target availability
- **Response Time**: <2 seconds for 95th percentile API responses
- **Error Rate**: <1% of total requests
- **Throughput**: 1000+ requests per minute capacity
- **Resource Utilization**: <80% CPU/memory usage under normal load

### Operational KPIs
- **Mean Time to Resolution (MTTR)**: Average incident resolution time
- **Mean Time Between Failures (MTBF)**: System reliability metrics
- **Deployment Frequency**: Weekly release cadence
- **Change Failure Rate**: <5% deployment failure rate

### Traffic Analysis & Scaling Metrics

#### High-Traffic Tables Heatmap
| **Table Category** | **Table Name** | **Operations/Hour** | **Data Volume** | **User Impact** | **Traffic Level** |
|-------------------|----------------|-------------------|----------------|----------------|-----------------|
| **🔥 Critical OLTP** | `inbox_message_refs` | 100K-1M | High | High | 🔴 **CRITICAL** |
| **🔥 High OLTP** | `campaigns` | 5K-50K | Medium | Medium | 🟡 **HIGH** |
| **⚡ Content DB** | `content_objects` | 200K-2M | Very High | High | 🔴 **CRITICAL** |
| **⚡ Content DB** | `email_opens` | 200K-2M | Very High | High | 🔴 **CRITICAL** |
| **⚡ Content DB** | `email_clicks` | 50K-500K | High | High | 🔴 **CRITICAL** |
| **⚡ Content DB** | `attachments` | 100K-500K | High | Medium | 🟡 **HIGH** |
| **📊 Analytics OLAP** | `daily_analytics` | 1K-10K | Medium | Medium | 🟢 **MEDIUM** |
| **📊 Analytics OLAP** | `campaign_analytics` | 500-5K | Low | Low | 🟢 **MEDIUM** |
| **📊 Analytics OLAP** | `billing_analytics` | 100-1K | Low | Low | 🟢 **MEDIUM** |
| **⚡ Queue System** | `jobs` | 10K-100K | Medium | Critical | 🟡 **HIGH** |
| **⚡ Queue System** | `job_logs` | 5K-50K | Medium | Medium | 🟡 **HIGH** |

#### Scaling Projections by Tenant Count
- **100 Tenants**: 10K-50K emails/day, 500-2.5K concurrent users
- **1,000 Tenants**: 100K-500K emails/day, 5K-25K concurrent users
- **2,000 Tenants**: 200K-1M emails/day, 10K-50K concurrent users
- **3,000 Tenants**: 300K-1.5M emails/day, 15K-75K concurrent users
- **4,000 Tenants**: 400K-2M emails/day, 20K-100K concurrent users
- **5,000 Tenants**: 500K-2.5M emails/day, 25K-150K concurrent users

### Infrastructure Requirements by Scale
- **DB Connections**: 20-300 (scaling with tenants)
- **Redis Memory**: 1-64GB (logarithmic scaling)
- **CPU Cores**: 2-64 (linear with traffic)
- **Storage**: 10GB-8TB (compound growth)

### Data Sources
- **Application Metrics**: Response times, error rates, throughput
- **Infrastructure Metrics**: CPU, memory, disk, network utilization
- **Business Metrics**: User activity, revenue, conversion rates
- **External Dependencies**: Email service providers, payment processors
- **User Experience**: Page load times, feature usage, error tracking
- **Traffic Metrics**: Database query patterns, queue processing rates, table growth rates

### Dashboard Layers
- **Executive Dashboard**: High-level business and system health metrics
- **Operations Dashboard**: Detailed system performance and alerting
- **Scaling Dashboard**: Traffic heatmap and infrastructure capacity planning
- **Development Dashboard**: Application performance and debugging
- **Customer Dashboard**: User-facing metrics and SLA tracking

### Monitoring Tools Integration

#### Infrastructure Monitoring
- **Hostwind VPS**: Server metrics and resource monitoring
- **Database Monitoring**: NileDB performance and query optimization
- **Network Monitoring**: Bandwidth usage and latency tracking
- **Container Monitoring**: Docker container health and resource usage

#### Application Performance Monitoring (APM)
- **Error Tracking**: Sentry for real-time error monitoring
- **Performance Profiling**: Application response time analysis
- **Memory Leak Detection**: Automated memory usage monitoring
- **Database Query Monitoring**: Slow query identification and optimization

#### Business Intelligence
- **User Analytics**: PostHog for user behavior tracking
- **Revenue Analytics**: Stripe Connect dashboard integration
- **Email Analytics**: Send rate, deliverability, and engagement metrics
- **Custom Dashboards**: Tailored views for different user roles

### Alerting System

#### Alert Severity Levels
**Critical Alerts (Immediate Response)**
- System Down: Complete service unavailability
- Data Breach: Security incident requiring immediate action
- Payment Processing Failure: Revenue-impacting issues
- Mass Email Failure: Campaign delivery completely blocked

**Warning Alerts (4-hour Response)**
- High Error Rates: >5% error rate sustained
- Performance Degradation: >3s response times
- Resource Exhaustion: >90% resource utilization
- External Service Issues: Third-party API failures

**Info Alerts (Daily Review)**
- Performance Trends: Gradual degradation patterns
- Usage Spikes: Unusual traffic patterns
- Maintenance Reminders: Scheduled maintenance notifications

#### Alert Channels
- **Slack**: Real-time alerts for on-call team
- **Email**: Escalation notifications for management
- **SMS**: Critical alerts for emergency response
- **Dashboard**: Visual indicators and historical tracking

### Incident Response Workflow

#### Detection Phase
1. Automated Alert: Monitoring system detects anomaly
2. Alert Routing: Appropriate team member notified based on severity
3. Initial Assessment: On-call engineer evaluates impact and urgency
4. Stakeholder Notification: Relevant teams informed of potential impact

#### Response Phase
1. Investigation: Root cause analysis using monitoring data
2. Containment: Temporary measures to prevent further impact
3. Resolution: Implement fix and restore normal operations
4. Communication: Regular updates to stakeholders throughout

#### Post-Incident Phase
1. Documentation: Detailed incident report with timeline and impact
2. Root Cause Analysis: Five-why analysis and contributing factors
3. Corrective Actions: Preventative measures and system improvements
4. Review Meeting: Team debrief and process improvement identification

### Performance Optimization

#### Automated Optimization
- **Auto-scaling**: Resource adjustment based on demand patterns
- **Cache Management**: Intelligent caching for improved performance
- **Database Optimization**: Query optimization and index management
- **CDN Integration**: Global content delivery optimization

#### Manual Optimization Processes
- **Performance Audits**: Regular comprehensive performance reviews
- **Code Profiling**: Identification of performance bottlenecks
- **Architecture Review**: System design optimization opportunities
- **Resource Planning**: Capacity planning and infrastructure upgrades

#### Continuous Improvement
- **Performance Budgets**: Defined acceptable performance thresholds
- **Benchmarking**: Industry standard performance comparisons
- **Innovation Tracking**: New technology evaluation for performance gains
- **Cost-Benefit Analysis**: Performance improvement ROI assessment

## Review Cadence

### Daily Reviews
- System health, critical alerts, revenue metrics

### Weekly Reviews
- Product metrics, customer feedback, competitive analysis

### Monthly Reviews
- Financial performance, strategic KPIs, roadmap progress

### Quarterly Reviews
- Annual goals progress, market analysis, strategic adjustments

---

## Related Documents
- [Product Strategy](product_strategy.md) - Strategic alignment and objectives
- [Business Model](business_model.md) - Revenue model and unit economics
- [Roadmap](roadmap.md) - Implementation timeline and priorities
- [Analytics Architecture](analytics_architecture.md) - Technical implementation of metrics tracking
- [Infrastructure Documentation](infrastructure_documentation.md) - System architecture and deployment
- [Security Documentation](security_documentation.md) - Security monitoring and incident response