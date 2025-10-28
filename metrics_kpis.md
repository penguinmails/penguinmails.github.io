# 📈 Metrics & KPIs

> **Status**: Current | **Last Updated**: October 28, 2025

---

## Executive Summary

This document defines the key metrics and KPIs that drive PenguinMails' business decisions, product development, and growth strategies. All metrics are designed to provide actionable insights for continuous improvement.

## Core Metric Categories

### 🎯 **North Star Metric**
**Monthly Recurring Revenue (MRR)** - Primary measure of business health and growth

### 📊 **Growth Metrics**
- **Monthly Active Users (MAU)**
- **Customer Acquisition Rate**
- **Revenue Growth Rate**
- **Market Share Growth**

### 💰 **Financial Metrics**
- **Customer Lifetime Value (LTV)**
- **Customer Acquisition Cost (CAC)**
- **Monthly Churn Rate**
- **Gross Revenue Margin**

### 🎨 **Product Metrics**
- **Feature Adoption Rate**
- **Time to First Value**
- **User Engagement Score**
- **Product Qualified Leads (PQLs)**

### 📧 **Email Performance Metrics**
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