---
title: "Metrics Glossary"
description: "Reference guide for all available metrics in PenguinMails, their sources, and update frequencies"
last_modified_date: "2025-12-07"
level: "2"
persona: "Operations Engineers, Data Analysts"
status: "ACTIVE"
category: "Admin"
---

# Metrics Glossary

## Overview

This glossary documents all metrics available in PenguinMails, organized by source and purpose. Use this as the authoritative reference for what data is available and where it comes from.

> [!IMPORTANT]
> **OLAP data is NOT real-time.** Analytics tables are updated via daily batch jobs (typically 2 AM UTC). For real-time status, query OLTP or use [PostHog](https://posthog.com/).

---

## Data Sources

| Source | Purpose | Status |
|--------|---------|--------|
| **OLAP** | Business analytics, billing, campaign performance | ✅ MVP |
| **OLTP** | Operational status, access control | ✅ MVP |
| **PostHog** | User behavior, engagement, login, infrastructure alerts | ✅ MVP |
| **Prometheus/Grafana** | Infrastructure performance | 🔮 2026 Spike |
| **Elasticsearch** | Log aggregation and search | 🔮 2026 Spike |

> [!NOTE]
> For launch, **PostHog is the primary external analytics tool**. Prometheus, Grafana, Elasticsearch, and other monitoring tools are planned for evaluation in a 2026 spike.

---

## Email & Campaign Metrics (OLAP)

**Source Tables**: `campaign_analytics`, `lead_analytics`, `sequence_step_analytics`

| Metric | Description | Notes |
|--------|-------------|-------|
| `sent` | Total emails sent | Per campaign/step/lead |
| `delivered` | Successfully delivered | Provider confirmed |
| `opened_tracked` | Tracked email opens | Pixel-based tracking |
| `clicked_tracked` | Tracked link clicks | URL redirect tracking |
| `replied` | Reply count | Detected via mailbox |
| `bounced` | Bounce count | Hard + soft bounces |
| `unsubscribed` | Unsubscribe count | Link clicks |
| `spam_complaints` | Spam complaint count | Provider feedback loops |
| `completed_leads` | Leads completing sequence | Campaign-level only |

**Derived Metrics** (calculated, not stored):

- **Open Rate**: `opened_tracked / delivered`
- **Click Rate**: `clicked_tracked / delivered`
- **Reply Rate**: `replied / delivered`
- **Bounce Rate**: `bounced / sent`

---

## Mailbox Health Metrics (OLAP)

**Source Tables**: `mailbox_analytics`, `warmup_analytics`

| Metric | Description | Notes |
|--------|-------------|-------|
| `health_score` | Deliverability health (0-100) | Calculated from bounce/spam rates |
| `current_volume` | Current sending volume | Emails per day |
| `warmup_status` | Warmup state | pending/active/completed/paused |
| `progress_percentage` | Warmup completion % | 0-100 |

---

## Usage & Billing Metrics (OLAP)

**Source Table**: `billing_analytics`

| Metric | Description | Notes |
|--------|-------------|-------|
| `emails_sent` | Total emails in period | Per tenant, per billing period |
| `mailboxes_used` | Active mailbox count | Usage for billing checks |
| `domains_used` | Domain count | Connected domains |
| `campaigns_used` | Campaign count | Active + completed |
| `leads_used` | Lead count | Total leads in system |
| `warmups_active` | Active warmups | Currently warming mailboxes |

---

## Operational Metrics (OLTP)

**Source Tables**: `subscriptions`, `email_accounts`, `plans`

| Metric | Description | Notes |
|--------|-------------|-------|
| `subscription.status` | Subscription state | active/past_due/canceled/unpaid |
| `current_period_end` | Renewal date | Used for access control |
| `email_accounts.daily_count` | Daily send count | Per-mailbox, operational |

---

## Compliance & Audit Metrics (OLAP)

**Source Table**: `admin_audit_log`

| Data | Description |
|------|-------------|
| Admin actions | High-risk action audit trail |
| Resource changes | Permission/billing/config changes |
| Metadata | IP address, user agent, timestamps |

---

## External Analytics (PostHog)

The following metrics are tracked via [PostHog](https://posthog.com/), not internal databases:

| Metric Category | Examples | Notes |
|-----------------|----------|-------|
| **Login Analytics** | Daily logins, unique users, failed attempts | *Post-MVP: May migrate to OLAP* |
| **User Engagement** | Session duration, feature usage, page views | PostHog event tracking |
| **Feature Adoption** | Feature clicks, workflow completion | PostHog funnels |

> [!TIP]
> PostHog login events can use the `identify` call to link anonymous sessions to authenticated users.

---

## Infrastructure Metrics (2026 Spike)

The following monitoring tools are **planned for evaluation** in 2026:

| Tool | Purpose | Status |
|------|---------|--------|
| **Prometheus** | System metrics (CPU, memory, disk) | 🔮 Spike planned |
| **Grafana** | Dashboards and visualization | 🔮 Spike planned |
| **Sentry** | Error tracking | 🔮 Spike planned |

> [!TIP]
> **For launch**, use PostHog for basic infrastructure alerts. More advanced monitoring will be evaluated post-MVP.

See [Infrastructure Monitoring](/docs/features/admin/system-monitoring/infrastructure-monitoring) for details on planned capabilities.

---

## What's NOT Available

To set realistic expectations, the following are **not currently tracked**:

| Not Available | Reason | Alternative |
|---------------|--------|-------------|
| Real-time campaign stats | OLAP is batch-updated | Query OLTP for current counts |
| Individual email open times | Privacy/performance | Use `opened_tracked` count |
| Detailed login history | Not in schema | PostHog session recordings |
| Revenue/MRR analytics | Stripe is source of truth | [Stripe Dashboard](/docs/features/admin/finance/stripe-dashboard-access) |

---

## Related Documentation

- [OLAP Schema Guide](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide) - Full table definitions
- [OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide) - Operational tables
- [System Monitoring](/docs/features/admin/system-monitoring/overview) - Monitoring features
- [Infrastructure Monitoring](/docs/features/admin/system-monitoring/infrastructure-monitoring) - External tools

---

**Keywords**: metrics, analytics, OLAP, OLTP, PostHog, monitoring, KPIs
