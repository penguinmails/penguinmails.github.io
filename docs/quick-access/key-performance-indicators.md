---
title: "Key Performance Indicators"
nav_order: 3
nav_exclude: false
description: "Success metrics, performance benchmarks, and business impact measurements"
---

# Key Performance Indicators

## Overview

PenguinMails provides comprehensive tracking and analysis of performance metrics across all aspects of your email infrastructure and campaign management. Our KPI framework is designed to provide actionable insights for continuous improvement and strategic decision-making.

---

## North Star Metric
**Monthly Recurring Revenue (MRR)** - Primary measure of business health and growth

---

## Core Metric Categories

### **Financial Metrics**
- **Customer Lifetime Value (LTV)**
- **Customer Acquisition Cost (CAC)**
- **Monthly Churn Rate**
- **Gross Revenue Margin**
- **Net Revenue Retention**

### **Growth Metrics**
- **Monthly Active Users (MAU)**
- **Customer Acquisition Rate**
- **Revenue Growth Rate**
- **Market Share Growth**

### **Product Metrics**
- **Feature Adoption Rate**
- **Time to First Value**
- **User Engagement Score**
- **Product Qualified Leads (PQLs)**

### **Email Performance Metrics**
- **Deliverability Rate**
- **Open Rate**
- **Click-Through Rate (CTR)**
- **Conversion Rate**
- **Inbox Placement Rate**
- **Sender Reputation Score**

---

## Detailed KPI Definitions

### **Customer Acquisition Cost (CAC)**
- **Formula**: Total marketing + sales spend / Number of new customers
- **Target**: <$XXX per customer
- **Measurement**: Monthly, rolling 12-month average
- **Breakdown**: Paid ads, content marketing, sales team, partnerships

### **Customer Lifetime Value (LTV)**
- **Formula**: Average revenue per user × customer lifespan
- **Target**: >$XXXX per customer
- **Measurement**: Rolling 12-month cohorts
- **Factors**: Subscription tier, retention rate, upsell revenue

### **Monthly Recurring Revenue (MRR)**
- **Formula**: Sum of all active subscriptions
- **Target**: $XXXK by end of year 1
- **Measurement**: End of month calculation
- **Components**: New subscriptions, expansions, churn

---

## Email Performance KPIs

### **Deliverability Rate**
- **Formula**: Emails delivered / Emails sent
- **Target**: >98%
- **Measurement**: Real-time, per campaign
- **Factors**: IP reputation, content quality, recipient engagement

### **Inbox Placement Rate**
- **Formula**: Emails in inbox / Emails delivered
- **Target**: >95%
- **Measurement**: Third-party monitoring services
- **Breakdown**: By ISP, domain, sending volume

### **Bounce Rate**
- **Formula**: Hard bounces / Total sends
- **Target**: <2%
- **Measurement**: Real-time, automated alerts at 3%
- **Types**: Hard bounces, soft bounces, spam complaints

### **Sender Reputation Score**
- **Formula**: Composite score from multiple reputation providers
- **Target**: >85/100
- **Measurement**: Daily, per IP/domain
- **Providers**: Google Postmaster, Microsoft SNDS, etc.

---

## Product Performance KPIs

### **Time to First Value**
- **Definition**: Time from signup to first successful email send
- **Target**: <30 minutes
- **Measurement**: Automated tracking in onboarding flow
- **Breakdown**: By user segment, device type, referral source

### **Feature Adoption Rate**
- **Formula**: Users using feature / Total eligible users
- **Target**: >60% for core features
- **Measurement**: Weekly, by feature category
- **Categories**: Campaign creation, IP management, analytics

### **Customer Satisfaction (NPS)**
- **Formula**: % Promoters - % Detractors
- **Target**: >50
- **Measurement**: Monthly surveys
- **Segmentation**: By plan tier, usage level, support interactions

---

## System Performance KPIs

### **System Health Metrics**
- **Uptime**: 99.9% target availability
- **Response Time**: <2 seconds for 95th percentile API responses
- **Error Rate**: <1% of total requests
- **Throughput**: 1000+ requests per minute capacity

### **Operational KPIs**
- **Mean Time to Resolution (MTTR)**: Average incident resolution time
- **Mean Time Between Failures (MTBF)**: System reliability metrics
- **Deployment Frequency**: Weekly release cadence
- **Change Failure Rate**: <5% deployment failure rate

---

## Traffic Analysis & Scaling Metrics

### **High-Traffic Tables Heatmap**
| **Table Category** | **Table Name** | **Operations/Hour** | **User Impact** |
|-------------------|----------------|-------------------|-----------------|
| **Critical Content** | `email_messages` | 100K-1M | High |
| **Critical Content** | `content_inbox_message_refs` | 100K-1M | High |
| **High OLTP** | `campaign_sequence_steps` | 50K-500K | High |
| **Content DB** | `content_objects` | 200K-2M | Very High |
| **Content DB** | `email_opens` | 200K-2M | Very High |

### **Scaling Projections by Tenant Count**
- **100 Tenants**: 10K-50K emails/day, 500-2.5K concurrent users
- **1,000 Tenants**: 100K-500K emails/day, 5K-25K concurrent users
- **2,000 Tenants**: 200K-1M emails/day, 10K-50K concurrent users
- **5,000 Tenants**: 500K-2.5M emails/day, 25K-150K concurrent users

---

## Alert Thresholds & Monitoring

### **Critical Alerts (Immediate Action Required)**
- **System Downtime**: >5 minutes
- **Deliverability Drop**: >5% below target
- **Security Incident**: Any confirmed breach
- **Data Loss**: Any production data loss

### **Warning Alerts (Action Within 24 Hours)**
- **MRR Decline**: >10% month-over-month
- **Churn Spike**: >15% above baseline
- **Support Backlog**: >50 open tickets
- **Performance Degradation**: >20% slower than baseline

### **Info Alerts (Weekly Review)**
- **Engagement Decline**: >10% drop in key metrics
- **Competition Changes**: New features from competitors
- **Market Shifts**: Changes in email deliverability landscape

---

## Data Sources & Analysis

### **Data Sources**
- **Product Analytics**: PostHog events, user behavior tracking
- **Business Intelligence**: Stripe payments, subscription data
- **Customer Success**: Support tickets, NPS surveys
- **External Monitoring**: Email reputation services, uptime monitors

### **Analysis Framework**
- **Cohort Analysis**: User behavior by signup month
- **Funnel Analysis**: Conversion rates through user journey
- **Attribution Modeling**: Revenue attribution to marketing channels
- **Predictive Modeling**: Churn prediction, LTV forecasting

---

## Dashboard Layers

### **Executive Dashboard**
- MRR Growth: Month-over-month, year-over-year
- Customer Metrics: Acquisition, retention, LTV/CAC ratio
- Product Health: Uptime, critical bugs, support tickets
- Financial Health: Burn rate, runway, profitability

### **Operations Dashboard**
- Detailed system performance and alerting
- Real-time monitoring and metrics
- Infrastructure health and capacity
- Alert management and incident tracking

### **Customer Dashboard**
- User-facing metrics and SLA tracking
- Campaign performance and analytics
- Email deliverability and reputation
- ROI and attribution reporting

---

## KPI Ownership

### **Executive Team**
- **MRR/ARR Growth**: CEO
- **Customer Satisfaction**: COO
- **Market Share**: CMO
- **Product-Market Fit**: CPO

### **Department Leads**
- **Engineering**: System uptime, performance metrics
- **Product**: Feature adoption, user engagement
- **Marketing**: CAC, conversion rates, brand metrics
- **Sales**: Deal size, sales cycle, win rates
- **Customer Success**: Retention, NPS, support metrics

---

## Review Cadence

### **Daily Reviews**
- System health, critical alerts, revenue metrics

### **Weekly Reviews**
- Product metrics, customer feedback, competitive analysis

### **Monthly Reviews**
- Financial performance, strategic KPIs, roadmap progress

### **Quarterly Reviews**
- Annual goals progress, market analysis, strategic adjustments

---

*These KPIs are reviewed and adjusted quarterly based on business priorities and market conditions. For questions about specific metrics or to request custom KPI reports, please contact the Analytics team.*