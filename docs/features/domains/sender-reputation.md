---
title: "Sender Reputation Tracking"
description: "Domain and mailbox reputation monitoring with internal health scores and external tool integration"
last_modified_date: "2025-12-08"
level: "2"
persona: "Product Teams, Email Administrators"
status: "MVP"
category: "Domains"
---

# Sender Reputation Tracking

## Overview

Sender reputation tracking provides visibility into email deliverability health at the domain and mailbox level. This feature combines internal proprietary algorithms with external reputation tools to give users comprehensive reputation insights.

> [!IMPORTANT]
> **MVP Scope**: Internal `health_score` algorithm is available at launch. External tool integration (Google Postmaster, Microsoft SNDS) is planned for post-MVP.

---

## Key Capabilities

### MVP (Q1 2026)

- **Internal Health Score** (0-100): Proprietary algorithm based on:
  - Bounce rate (hard and soft bounces)
  - Spam complaint rate
  - Unsubscribe rate
  - Send volume trends
  - Historical deliverability patterns

- **Per-Mailbox Tracking**: Health scores stored in OLAP `mailbox_analytics` table

- **Reputation Trend**: Historical score data for trend visualization

### Post-MVP

- **External Tool Integration** (Q2 2026):
  - Google Postmaster API: Domain reputation, spam rate, authentication
  - Microsoft SNDS: IP reputation, trap hits, complaint rate

- **Comparison View**:
  - Display internal health score alongside external scores
  - "Compare with external tools" toggle in UI
  - Highlight discrepancies for investigation

---

## Data Architecture

### Internal Health Score

**Source**: OLAP `mailbox_analytics` table

```sql
-- Existing fields (MVP)
health_score INTEGER,           -- 0-100 internal score
current_volume INTEGER,         -- Current daily send volume
```

### External Reputation (Post-MVP)

**Proposed schema additions** to `mailbox_analytics`:

```sql
-- External reputation integration (Q2 2026)
external_reputation_google INTEGER,     -- Google Postmaster score (0-100)
external_reputation_microsoft INTEGER,  -- Microsoft SNDS score (0-100)
external_last_sync_at TIMESTAMPTZ       -- Last external API sync
```

**Sync Schedule**: External APIs called daily after mailbox warmup completes (approximately 30 days post-mailbox creation).

---

## Health Score Algorithm

The internal `health_score` uses a weighted formula:

```text
health_score = 100 - (
  bounce_penalty × 0.35 +
  spam_penalty × 0.35 +
  unsubscribe_penalty × 0.15 +
  volume_penalty × 0.15
)
```

**Penalty Calculations**:

| Factor | Threshold | Penalty |
|--------|-----------|---------|
| Hard bounces | > 2% | 10-30 points |
| Spam complaints | > 0.1% | 15-40 points |
| Unsubscribes | > 1% | 5-15 points |
| Volume drop | > 50% week-over-week | 5-10 points |

---

## API Reference

- **Tenant Analytics API**: [Deliverability Analytics](/docs/implementation-technical/api/tenant-api/analytics#get-deliverability-analytics)
- **Response field**: `health_score` (0-100)

---

## User Interface

See [Workspace Domains Routes](/docs/design/routes/workspace-domains) for UI specifications.

**Key UI Elements**:

- Health score gauge (0-100 with color gradient)
- Trend chart (last 30 days)
- External comparison section (Post-MVP)
- Action recommendations based on score

---

## Roadmap

| Timeline | Milestone |
|----------|-----------|
| Q1 2026 | MVP: Internal health_score algorithm |
| Q2 2026 | External API integration (Google Postmaster, Microsoft SNDS) |
| Q3 2026 | Comparison view and discrepancy alerts |
| Q1 2027 | Predictive reputation forecasting |

---

## Related Documentation

- [Domain Management](/docs/features/domains/domain-management) - Core domain features
- [Domains Roadmap](/docs/features/domains/roadmap) - Feature timeline
- [Mailbox Analytics Schema](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide#mailbox-analytics) - Data model
- [Analytics API](/docs/implementation-technical/api/tenant-api/analytics) - API endpoints
- [Workspace Domains Routes](/docs/design/routes/workspace-domains) - UI specifications

---

**Keywords**: sender reputation, health score, deliverability, Google Postmaster, Microsoft SNDS, domain health
