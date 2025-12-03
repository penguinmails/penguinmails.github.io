---
title: "Domain Management Roadmap"
description: "Post-MVP enhancements for domain management features including subdomain support, bulk operations, and multi-region sending"
last_modified_date: "2025-11-26"
level: "2"
persona: "Product Teams, Technical Leaders"
---


# Domain Management Roadmap

## Overview

Domain management is **MVP-complete** with all essential features implemented. This roadmap outlines Post-MVP enhancements focused on enterprise features, agency operations, and global expansion.

**Current Status:** ✅ MVP Complete (November 2025)

**Post-MVP Timeline:** Q1 2026 - Q1 2027

## MVP Status Summary

### ✅ Implemented Features

All core domain management features are production-ready:

- **Domain Verification** - Multi-step wizard with automated DNS record generation

- **DNS Management** - Complete DNS record management (SPF, DKIM, DMARC, CNAME, MX)

- **Sender Authentication** - Industry-standard SPF, DKIM (2048-bit RSA), DMARC

- **Health Monitoring** - Real-time reputation tracking, blacklist monitoring, Google Postmaster integration

- **Multi-Domain Support** - Unlimited domains per workspace with independent configuration

- **Email Account Management** - Per-domain email account provisioning and health tracking

- **Custom Tracking Domains** - Branded link tracking with automated SSL (Let's Encrypt)

- **API Access** - Full programmatic domain management

## No MVP-blocking gaps identified

## Post-MVP Roadmap

### Q1 2026: Enterprise Features

#### 1. Subdomain Support & Reputation Isolation

**Priority:** P1 (High - Enterprise Enabler)

**Description:** Enable sending from subdomains with independent DKIM keys and reputation tracking for team segmentation and brand isolation.

##### Use Cases

- Marketing team sends from `marketing.example.com`

- Sales team sends from `sales.example.com`

- Support team sends from `support.example.com`

- Each subdomain maintains independent reputation

##### Key Features

- Subdomain validation and verification

- Independent DKIM key generation per subdomain

- Subdomain-level reputation tracking (isolated from parent domain)

- UI subdomain organization (grouping/filtering)

- Subdomain tree view (optional)

- API endpoints for subdomain operations

##### Business Impact

- Unlocks enterprise tier pricing

- Enables multi-brand organizations

- Provides reputation isolation for different teams

- Supports A/B testing with separate domain reputations

**Effort:** 3-5 days

##### Dependencies

- Domain verification system (✅ implemented)

- Reputation monitoring system (✅ implemented)

---

### Q2 2026: Agency & Power User Features

#### 2. Bulk Domain Onboarding & Templates

**Priority:** P2 (Medium - Agency Focus)

**Description:** Bulk subdomain provisioning and DNS instruction templates for agencies managing many client domains.

##### Use Cases

- Agency imports 50 client subdomains via CSV

- Pre-configured DNS templates for consistent setup

- Standardized DKIM/SPF/DMARC policies across domains

- Team-based subdomain routing

##### Key Features

- CSV import for bulk subdomain creation (50+ at once)

- DNS instruction templates (save/reuse configurations)

- Bulk DKIM key generation

- Subdomain policy engine (apply rules to groups)

- Subdomain grouping and tagging

- Subdomain-level access control (RBAC integration)

##### Business Impact

- Increases agency customer retention

- Enables agencies to scale client management

- Reduces manual configuration work

- Improves consistency across client domains

**Effort:** 5-7 days

##### Dependencies

- Subdomain support (Q1 2026)

- Team & tenant management (✅ implemented)

- RBAC system (✅ implemented)

---

#### 3. Workspace Domain Transfer (Metadata)

**Priority:** P2 (Medium - Agency Focus)

**Description:** Transfer domain metadata between workspaces within PenguinMails with full history preservation.

##### Use Cases

- Agency transfers `client.com` metadata to client's own workspace

- Workspace consolidation during business restructuring

- Client takes ownership of domain after contract ends

- Bulk migration of 10+ domains between workspaces

##### Key Features

- Domain transfer workflow (request → approve → transfer)

- Metadata preservation (reputation, warmup history, analytics, DKIM keys)

- Email account migration

- Transfer audit trail for compliance

- Rollback capability (24-hour window)

- Bulk transfer support (10+ domains)

##### Business Impact

- Supports agency client offboarding

- Enables workspace consolidation

- Maintains historical data during transitions

- Provides flexibility for changing business relationships

**Effort:** 5-7 days

##### Dependencies

- Multi-tenant architecture (✅ implemented)

- Domain reputation system (✅ implemented)

- Audit logging system

**Note:** This is metadata transfer within PenguinMails only. DNS records remain at the user's registrar.

---

#### 4. DNS Instruction Presets & One-Click Copy

**Priority:** P3 (Low - Convenience)

**Description:** Pre-configured DNS instruction templates with one-click copy for faster domain setup.

##### Use Cases

- One-click copy of all DNS records to clipboard

- Pre-validated DNS templates with best practices

- Agency standardization across client domains

- Error reduction through pre-configured templates

##### Key Features

- "Copy All DNS Records" button

- DNS instruction template library

- Template naming and descriptions

- Workspace-level template sharing

- Default PenguinMails templates (best practices)

- Template preview before applying

##### Business Impact

- Improves user experience

- Reduces DNS configuration errors

- Decreases support tickets

- Faster domain onboarding

**Effort:** 2-3 days

##### Dependencies

- Domain management system (✅ implemented)

- Team & workspace management (✅ implemented)

---

### Q3 2026: Advanced Monitoring

#### 5. Real-Time DNS Validation & Misconfiguration Alerts

**Priority:** P2 (Medium - Power Users)

**Description:** Real-time DNS record validation with proactive alerts for common misconfigurations.

##### Use Cases

- Instant feedback on DNS record correctness

- Proactive alerts when DNS records change or break

- Common misconfiguration detection (SPF syntax, DKIM format, DMARC policy)

- Clear troubleshooting guidance

##### Key Features

- Real-time DNS validation (instant feedback)

- DNS configuration validator (detect common mistakes)

- DNS change monitoring (periodic checks for drift)

- Alerting system (email/webhook when DNS breaks)

- DNS health score (0-100 quality indicator)

- Clear error messages with fix instructions

- Dashboard showing DNS health across all domains

##### Business Impact

- Reduces support tickets

- Improves deliverability by catching DNS issues early

- Provides confidence in DNS configuration

- Enables proactive issue resolution

**Effort:** 5-7 days

##### Dependencies

- Domain verification system (✅ implemented)

- Alerting infrastructure

---

### Q4 2026: Global Expansion

#### 6. Multi-Region Sending Pools & DKIM Selectors

**Priority:** P1 (High - Global Expansion)

**Description:** Send from multiple geographic regions with region-specific DKIM selectors and IP pools for global reach and compliance.

##### Use Cases

- Send from US, EU, and APAC regions with optimized routing

- Meet data residency requirements (GDPR compliance)

- Reduce latency by sending from nearest region

- Automatic failover to backup region

##### Key Features

- Multi-region domain configuration

- Region-specific DKIM selectors (e.g., `us._domainkey`, `eu._domainkey`)

- Region-specific IP pools

- Geographic routing logic (send from nearest region)

- Region failover mechanism

- Region-level reputation tracking

- Multi-region analytics dashboard

##### Business Impact

- Enables global enterprise customers

- Unlocks international markets

- Meets regional compliance requirements

- Improves global deliverability

**Effort:** 10-14 days

##### Dependencies

- Multi-region infrastructure (Post-MVP infrastructure work)

- Domain management system (✅ implemented)

- Reputation monitoring system (✅ implemented)

**Note:** Users still manage DNS at their registrar. We provide region-specific DKIM records for them to add.

---

### Q1 2027: Predictive Features

#### 7. Reputation Prediction & Proactive Alerts

**Priority:** P3 (Low - Advanced Feature)

**Description:** Predictive analytics for domain reputation trends with proactive recommendations based on platform-wide patterns.

##### Use Cases

- "Your domain reputation is trending down. Reduce sending volume by 20%."

- "Based on similar domains, we recommend enabling DMARC quarantine policy."

- "Unusual spike in bounces detected. Investigate immediately."

- "Your bounce rate increased 15% this week. Review your lead list quality."

##### Key Features

- Reputation trend analysis (7-14 day predictions)

- Anomaly detection (unusual bounce/spam patterns)

- Recommendation engine (based on platform-wide patterns)

- Historical data analysis

- Proactive alerting system

- Insights dashboard with trend predictions

##### Business Impact

- Competitive differentiator for premium plans

- Improves customer success

- Enables proactive issue resolution

- Provides data-driven optimization guidance

**Effort:** 10-14 days

##### Dependencies

- Domain reputation monitoring (✅ implemented)

- Analytics infrastructure

- Historical data collection (6+ months of MVP data)

**Note:** This is pattern-based analytics, not deep AI/ML. Analyzes platform-wide trends and applies them to individual domains.

---

##### Roadmap Summary

### Timeline Overview

| Quarter | Features | Effort | Focus Area |
|---------|----------|--------|------------|
| **Q1 2026** | Subdomain Support | 3-5 days | Enterprise enabler |
| **Q2 2026** | Bulk Onboarding, Transfers, Presets | 12-17 days | Agency features |
| **Q3 2026** | Real-Time DNS Validation | 5-7 days | Power user features |
| **Q4 2026** | Multi-Region Sending Pools | 10-14 days | Global expansion |
| **Q1 2027** | Reputation Prediction | 10-14 days | Predictive features |

**Total Post-MVP Effort:** 40-57 days (8-11 weeks)

### Priority Distribution

- **P1 (High Priority):** 2 features - Subdomain support, Multi-region sending

- **P2 (Medium Priority):** 3 features - Bulk onboarding, Transfers, DNS validation

- **P3 (Low Priority):** 2 features - DNS presets, Reputation prediction

### Business Impact by Quarter

## Q1 2026

- Unlocks enterprise tier pricing

- Enables multi-brand organizations

## Q2 2026

- Increases agency customer retention

- Enables agencies to scale client management

## Q3 2026

- Reduces support tickets

- Improves deliverability monitoring

## Q4 2026

- Enables global enterprise customers

- Unlocks international markets

## Q1 2027

- Competitive differentiator for premium plans

- Improves customer success

## Scope Constraints

### What We're Building

✅ **SMTP Platform Features:**

- DNS instruction generation (SPF, DKIM, DMARC, CNAME)

- DNS verification (check if records exist)

- DKIM key management (generate, rotate, store in Vault)

- Sending pool management (IPs, regions, reputation)

- Email identity management (authentication, reputation, analytics)

### What We're NOT Building

❌ **Registrar/DNS Authority Features:**

- Domain registrar features (buying domains, NS records)

- DNS hosting/authority (zone files, wildcard DNS control)

- Automated DNS propagation (users manage DNS at their registrar)

- DNS provider integrations (Cloudflare API, Route53 API) - Optional Post-MVP enhancement only

**Rationale:** PenguinMails is an SMTP provider, not a DNS registrar. Users own their domains and manage DNS at their registrar (Cloudflare, Namecheap, etc.). We only generate DNS instructions, verify records exist, and manage email identity.

## Optional MVP Enhancements

These convenience features can be implemented if time permits, but are not blocking MVP launch:

### 1. Bulk Domain Import

**Priority:** P3 (Low)

**Description:** Import multiple domains at once via CSV upload.

**Effort:** 2-3 days

**Target:** MVP (if time permits) or Q1 2026

**Rationale:** Current one-by-one flow is acceptable for MVP. Most users start with 1-3 domains.

### 2. Domain Configuration Templates

**Priority:** P3 (Low)

**Description:** Save DNS configurations as templates for faster setup.

**Effort:** 2-3 days

**Target:** Q2 2026

**Rationale:** Current automated DNS generation is fast enough for MVP. Templates are a convenience feature.

## Related Documentation

### Planning & Strategy

- [Product Roadmap](/docs/operations/roadmap/product-roadmap) - Overall product direction

- [Executive Roadmap](/docs/business/roadmap/executive-roadmap) - Business-level roadmap

- [Technical Roadmap](/docs/operations/roadmap/technical-roadmap) - Technical infrastructure roadmap

### Feature Documentation

- [Domain Management](/docs/features/domains/domain-management) - Current domain features

- [Infrastructure Management](/docs/features/infrastructure/README) - VPS provisioning

- [Email Operations](/docs/features/email-operations/README) - Email sending pipeline

- [Warmup Features](/docs/features/warmup/README) - Email warmup system

### Technical Architecture

- [Vault Integration](/docs/technical/architecture/vault-integration-architecture) - DKIM key storage

- [Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture) - Database isolation

### Implementation

- [Domain Routes](/docs/design/routes/workspace-domains) - UI specifications

- Epic 5: Infrastructure Management - Internal task reference for implementation tasks

---

**Last Updated:** November 26, 2025
**Review Cycle:** Quarterly
**Next Review:** February 2026
