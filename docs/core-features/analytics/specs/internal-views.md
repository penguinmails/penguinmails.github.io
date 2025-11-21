---
title: "Internal View Specifications"
description: "Detailed widget and data requirements for Internal Command Center views"
---

# Internal Command Center Views

*Restricted access for PenguinMails employees only.*

## 1. Executive Dashboard (The "Pulse")

* **Target**: CEO, Founders, Investors (Internal View)
* **Route**: `/dashboard` (when logged in as Super Admin/Exec)
* **Goal**: Instant health check of the business.
* **Key Questions**: Are we growing? Are we profitable? Is the system stable?

### Widgets

* **MRR Ticker**: Real-time Monthly Recurring Revenue vs Target.
* **Growth Velocity**: New User Signups (Daily/Weekly).
* **Churn Alert**: Net Revenue Retention & Churn Rate.
* **System Health Traffic Light**: Global Uptime & Incident Status.

### Data Sources

* Stripe (Revenue)
* PostHog (Usage/Growth)
* Uptime Monitor (Health)

## 2. Operations Monitor (The "Watchtower")

* **Target**: DevOps, Support, Engineering
* **Route**: `/dashboard` (Admin) and `/dashboard/system/...`
* **Goal**: Proactive incident management and system reliability.
* **Key Questions**: Is anything broken? Are queues backing up?

### Widgets

* **Queue Health**: Job processing rates & backlogs (Redis/BullMQ).
* **Error Stream**: Real-time error logs (Sentry feed).
* **Infrastructure Load**: CPU/Memory/Disk usage heatmaps.
* **Deliverability Global Map**: Real-time sending success rates by region/ISP.

## 3. Product Insight Deck

* **Target**: Product Managers, Designers
* **Route**: `/dashboard/analytics/product` (Proposed)
* **Goal**: Feature adoption and user behavior analysis.
* **Key Questions**: Are users using the new feature? Where are they dropping off?

### Widgets

* **Feature Adoption Funnels**: Step-by-step conversion rates.
* **A/B Test Leaderboard**: Active experiments and significance status.
* **User Journey Flow**: Sankey diagram of user paths.
