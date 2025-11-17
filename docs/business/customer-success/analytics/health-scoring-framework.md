---
title: "Customer Health Scoring Framework"
description: "Comprehensive customer health monitoring and scoring methodology for proactive retention and expansion management"
last_modified_date: "2025-11-15"
level: 2
persona: "Customer Success Teams"
---

# Customer Health Scoring Framework

## Health Scoring Overview

Customer health scoring provides a quantitative measure of account health and risk, enabling proactive intervention and strategic resource allocation for optimal customer success outcomes.

## Health Score Calculation Methodology

### Core Health Score Formula
```
Overall Health Score = (Usage Health × 0.35) + (Engagement Health × 0.25) + 
                      (Business Health × 0.25) + (Relationship Health × 0.15)
```

### Health Score Ranges and Action Triggers
- **Green (80-100)**: Healthy accounts - Expansion focus and relationship deepening
- **Yellow (60-79)**: At-risk accounts - Intervention and recovery planning
- **Red (0-59)**: Critical accounts - Emergency response and retention focus

## Detailed Health Dimensions

### 1. Usage Health (35% Weight)

#### Metrics and Thresholds

**Active User Engagement**
- **Daily Active Users**: ≥70% of licensed users = 100 points, 50-69% = 70 points, <50% = 30 points
- **Weekly Active Users**: ≥85% of licensed users = 100 points, 70-84% = 70 points, <70% = 30 points
- **Monthly Active Users**: ≥95% of licensed users = 100 points, 85-94% = 70 points, <85% = 30 points

**Feature Adoption Rates**
- **Core Features**: ≥80% adoption = 100 points, 60-79% = 70 points, <60% = 30 points
- **Advanced Features**: ≥50% adoption = 100 points, 30-49% = 70 points, <30% = 30 points
- **Integration Usage**: ≥3 active integrations = 100 points, 1-2 integrations = 70 points, 0 integrations = 30 points

**Usage Quality Metrics**
- **Session Duration**: Average session ≥15 minutes = 100 points, 10-14 minutes = 70 points, <10 minutes = 30 points
- **API Calls**: Daily API usage ≥1000 calls = 100 points, 500-999 calls = 70 points, <500 calls = 30 points
- **Data Processing**: Monthly data volume ≥500GB = 100 points, 100-499GB = 70 points, <100GB = 30 points

#### Usage Health Calculation
```
Usage Health = (Active User Score × 0.4) + (Feature Adoption × 0.4) + (Usage Quality × 0.2)
```

### 2. Engagement Health (25% Weight)

#### Metrics and Thresholds

**Support Interaction Quality**
- **Ticket Volume**: ≤2 tickets/month = 100 points, 3-5 tickets = 70 points, >5 tickets = 30 points
- **Resolution Time**: ≤24 hours average = 100 points, 25-48 hours = 70 points, >48 hours = 30 points
- **Ticket Severity**: 80% low/medium severity = 100 points, 60-79% = 70 points, <60% = 30 points

**Training and Adoption Support**
- **Training Completion**: ≥90% completion rate = 100 points, 70-89% = 70 points, <70% = 30 points
- **Support Portal Usage**: ≥4 logins/month = 100 points, 2-3 logins = 70 points, 0-1 logins = 30 points
- **Community Participation**: ≥2 posts/replies/month = 100 points, 1 post/reply = 70 points, 0 activity = 30 points

**Proactive Engagement**
- **Success Manager Interactions**: ≥4 interactions/month = 100 points, 2-3 interactions = 70 points, <2 interactions = 30 points
- **Executive Touchpoints**: ≥1 executive meeting/quarter = 100 points, 1 executive meeting/6 months = 70 points, <1 meeting/6 months = 30 points

#### Engagement Health Calculation
```
Engagement Health = (Support Quality × 0.4) + (Training Adoption × 0.3) + (Proactive Engagement × 0.3)
```

### 3. Business Health (25% Weight)

#### Metrics and Thresholds

**Success Metric Achievement**
- **ROI Realization**: ≥100% of target ROI = 100 points, 80-99% = 70 points, <80% = 30 points
- **Business Outcome Achievement**: ≥90% of goals met = 100 points, 70-89% = 70 points, <70% = 30 points
- **Efficiency Gains**: ≥20% efficiency improvement = 100 points, 10-19% = 70 points, <10% = 30 points

**Financial Health**
- **Payment History**: 100% on-time payments = 100 points, 95-99% on-time = 70 points, <95% = 30 points
- **Budget Utilization**: 80-100% of allocated budget = 100 points, 60-79% = 70 points, <60% = 30 points
- **Contract Value**: Renewal value maintained/growth = 100 points, 5-10% decline = 70 points, >10% decline = 30 points

**Strategic Alignment**
- **Goal Alignment**: High alignment with company strategy = 100 points, Medium alignment = 70 points, Low alignment = 30 points
- **Executive Sponsorship**: Strong executive support = 100 points, Moderate support = 70 points, Weak support = 30 points
- **Future Planning**: Clear expansion/renewal plans = 100 points, General future plans = 70 points, No clear plans = 30 points

#### Business Health Calculation
```
Business Health = (Success Achievement × 0.4) + (Financial Health × 0.3) + (Strategic Alignment × 0.3)
```

### 4. Relationship Health (15% Weight)

#### Metrics and Thresholds

**Stakeholder Relationships**
- **Executive Relationship**: C-level relationship established = 100 points, VP-level relationship = 70 points, Manager-level only = 30 points
- **Team Relationships**: Strong team relationships = 100 points, Moderate team relationships = 70 points, Limited relationships = 30 points
- **User Adoption**: High user satisfaction = 100 points, Moderate satisfaction = 70 points, Low satisfaction = 30 points

**Advocacy and References**
- **NPS Score**: ≥9 = 100 points, 7-8 = 70 points, ≤6 = 30 points
- **Reference Willingness**: Actively references us = 100 points, Willing when asked = 70 points, Unwilling = 30 points
- **Case Study Participation**: Participated in case study = 100 points, Interested in participating = 70 points, Not interested = 30 points

**Brand Perception**
- **Competitive Position**: Prefer us over competitors = 100 points, Neutral position = 70 points, Considering alternatives = 30 points
- **Loyalty Indicators**: Long-term commitment signals = 100 points, Mixed signals = 70 points, Churn signals = 30 points

#### Relationship Health Calculation
```
Relationship Health = (Stakeholder Relationships × 0.5) + (Advocacy Indicators × 0.3) + (Brand Perception × 0.2)
```

## Health Score Monitoring and Alerting

### Automated Health Monitoring
- **Daily Health Calculations**: Automated score updates based on activity data
- **Threshold Alerts**: Immediate notifications when scores drop below defined thresholds
- **Trend Analysis**: 7-day, 30-day, and 90-day health score trend monitoring
- **Comparative Analysis**: Account health comparison against similar accounts

### Health Score Actions

#### Green Account Actions (80-100 points)
- **Expansion Focus**: Prioritize upsell and cross-sell opportunities
- **Reference Development**: Leverage for case studies and testimonials
- **Strategic Partnership**: Deepen executive relationships and collaboration
- **Innovation Partnership**: Include in beta programs and feature feedback

#### Yellow Account Actions (60-79 points)
- **Intervention Planning**: Develop action plans to address health decline
- **Enhanced Touchpoints**: Increase interaction frequency and support
- **Value Rediscovery**: Re-engage with ROI and benefit communication
- **Risk Mitigation**: Address specific risk factors identified

#### Red Account Actions (0-59 points)
- **Emergency Response**: Immediate executive escalation and intervention
- **Root Cause Analysis**: Comprehensive investigation of health decline factors
- **Recovery Planning**: Detailed action plan with measurable milestones
- **Retention Focus**: Prioritize retention over expansion or reference activities

## Health Score Reporting and Analytics

### Dashboard and Reporting
- **Executive Health Dashboard**: High-level health score distribution and trends
- **Account Health Details**: Individual account health scores and components
- **Health Score Trends**: Historical health score analysis and prediction
- **Comparative Analysis**: Account health benchmarking and peer comparison

### Predictive Health Modeling
- **Churn Prediction**: Machine learning models to predict churn risk
- **Expansion Scoring**: Models to identify expansion-ready accounts
- **Health Trajectory**: Predictive health score trends and scenarios
- **Intervention Optimization**: AI-driven intervention strategy recommendations

## Implementation Requirements

### Data Integration
- **CRM Integration**: Customer and opportunity data synchronization
- **Product Analytics**: Usage and engagement data collection
- **Support Systems**: Ticket and interaction data integration
- **Financial Systems**: Payment and contract data synchronization

### Technology Platform
- **Customer Success Platform**: Dedicated health scoring and management tools
- **Business Intelligence**: Analytics and reporting infrastructure
- **Automation Systems**: Alert and notification management
- **Integration Hub**: Data pipeline and synchronization management

### Process Integration
- **Health Score Review**: Regular health score assessment and validation
- **Action Planning**: Systematic intervention and recovery planning
- **Performance Tracking**: Health score impact measurement and optimization
- **Continuous Improvement**: Health scoring methodology refinement

## Success Metrics and KPIs

### Health Score Distribution
- **Target Distribution**: 80% green, 15% yellow, 5% red
- **Health Improvement**: Percentage of yellow/red accounts improving
- **Churn Prevention**: Churn rate reduction for at-risk accounts
- **Expansion Success**: Account health correlation with expansion revenue

### Business Impact Metrics
- **Retention Improvement**: Overall customer retention rate improvement
- **Expansion Revenue**: Revenue growth from healthy accounts
- **Intervention ROI**: Return on investment from health-based interventions
- **Time to Intervention**: Speed of response to health score declines

---

**Related Documentation:**
- [Customer Success Framework](../strategy.md)
- [Customer Journey Analytics](../journey.md)
- [Predictive Churn Analysis](predictive-churn-analysis)
- [Customer Retention Strategies](../retention.md)

---
*Level 2: Analytics framework for customer health monitoring and proactive management*