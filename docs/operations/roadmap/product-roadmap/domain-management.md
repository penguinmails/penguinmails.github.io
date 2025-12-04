---
title: "Domain Management Roadmap"
description: "Domain verification, DNS automation, and management features"
last_modified_date: "2025-12-04"
level: "2"
persona: "Technical Operations"
keywords: "domain management, DNS, verification, automation"
---

# Domain Management Roadmap

## Feature Deep Dive: Domain Management

### Overview

**Status:** MVP-Complete ✅
**Timeline:** Q4 2025 (Complete) → Q1 2026-Q1 2027 (Post-MVP Enhancements)
**Priority:** High (Foundation feature - Complete)

### Current State: MVP-Complete

## What's Available Today

- ✅ Complete domain verification workflow with multi-step wizard

- ✅ Comprehensive DNS record management (SPF, DKIM, DMARC, CNAME, MX)

- ✅ Industry-standard authentication (2048-bit DKIM, SPF, DMARC)

- ✅ Real-time health monitoring and reputation tracking (0-100 score)

- ✅ Multi-domain support per workspace

- ✅ Email account management per domain

- ✅ Custom tracking domains with automated SSL (Let's Encrypt)

- ✅ Full API access for programmatic management

- ✅ Google Postmaster Tools integration

- ✅ Blacklist monitoring (URIBL, SURBL)

- ✅ DKIM key storage in HashiCorp Vault (secure secrets management)

**Assessment:** All essential domain verification, DNS management, and authentication features are implemented. No MVP-blocking gaps identified.

### Post-MVP Roadmap (Q1 2026-Q1 2027)

### Q1 2026: Enterprise Features

- **[P1] Subdomain Support & Reputation Isolation** (3-5 days)

  - Independent DKIM keys per subdomain

  - Subdomain-level reputation tracking

  - Team segmentation by subdomain

  - **Business Impact:** Unlocks enterprise tier pricing, enables multi-brand organizations

### Q2 2026: Agency Features

- **[P2] Bulk Domain Onboarding & Templates** (5-7 days)

  - CSV import for 50+ subdomains at once

  - DNS instruction templates (save/reuse)

  - Bulk DKIM key generation

  - **Business Impact:** Increases agency customer retention, enables scale

- **[P2] Workspace Domain Transfer** (5-7 days)

  - Transfer domain metadata between workspaces

  - Reputation history preservation

  - Bulk transfer support (10+ domains)

  - **Business Impact:** Supports agency client offboarding, workspace consolidation

- **[P3] DNS Instruction Presets & One-Click Copy** (2-3 days)

  - One-click copy all DNS records

  - Pre-configured templates

  - **Business Impact:** Improves UX, reduces support tickets

### Q3 2026: Power User Features

- **[P2] Real-Time DNS Validation & Alerts** (5-7 days)

  - Real-time DNS validation with instant feedback

  - Misconfiguration detection and alerts

  - DNS health score (0-100)

  - **Business Impact:** Reduces support tickets, improves deliverability

### Q4 2026: Global Expansion

- **[P1] Multi-Region Sending Pools & DKIM** (10-14 days)

  - Send from multiple regions (US, EU, APAC)

  - Region-specific DKIM selectors

  - Geographic routing and failover

  - **Business Impact:** Enables global enterprise customers, unlocks international markets

### Q1 2027: Predictive Features

- **[P3] Reputation Prediction & Proactive Alerts** (10-14 days)

  - Predict reputation trends 7-14 days ahead

  - Proactive alerts before reputation drops

  - Platform-wide pattern analysis

  - **Business Impact:** Competitive differentiator, improves customer success

### Total Post-MVP Effort

**Effort:** 40-57 days (8-11 weeks)
**Priority Distribution:** 2 P1 features, 3 P2 features, 2 P3 features

### Key Dependencies

## Infrastructure

- HashiCorp Vault (already implemented) - DKIM key storage

- Multi-region infrastructure (Q4 2026) - Required for multi-region sending

- Analytics infrastructure - Required for reputation prediction

## Features

- Subdomain support (Q1 2026) - Prerequisite for bulk subdomain onboarding

- Historical data (6+ months) - Required for reputation prediction

### Success Metrics

## Technical

- DNS verification success rate > 95%

- DKIM key rotation automated (365-day cycle)

- Domain health monitoring accuracy > 90%

- Multi-region failover < 5 minutes

## Business

- Enterprise customer acquisition enabled (Q1 2026)

- Agency customer retention improved by 20% (Q2 2026)

- Support tickets reduced by 30% (Q3 2026)

- Global market expansion enabled (Q4 2026)

**Detailed Roadmap:** [Domain Management Roadmap](/docs/features/domains/roadmap)

---

