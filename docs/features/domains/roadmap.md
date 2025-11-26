---
title: "Domain Management Roadmap"
description: "Post-MVP feature roadmap for domain management, including subdomain support, bulk operations, and multi-region sending"
last_modified_date: "2025-11-26"
level: "2"
persona: "Product Managers, Technical Leaders"
---

# Domain Management Roadmap

## MVP Status

**✅ Domain Management is MVP-Complete**

All essential domain verification, DNS management, and authentication features are implemented and ready for launch. No blocking gaps identified.

### What's Already Built

- Complete domain verification workflow with multi-step wizard
- Comprehensive DNS record management (SPF, DKIM, DMARC, CNAME, MX)
- Industry-standard authentication protocols (2048-bit DKIM, SPF, DMARC)
- Real-time health monitoring and reputation tracking
- Multi-domain support per workspace
- Email account management per domain
- Custom tracking domains with automated SSL (Let's Encrypt)
- Full API access for programmatic management
- Google Postmaster Tools integration
- Blacklist monitoring (URIBL, SURBL)

## Post-MVP Roadmap

### Q1 2026: Enterprise Features

#### [P1] Subdomain Support & Reputation Isolation

**Target:** January 2026 | **Effort:** 3-5 days

Enable users to send from subdomains with independent DKIM keys and reputation tracking.

**Key Capabilities:**
- Independent DKIM key generation per subdomain
- Subdomain-level reputation tracking (separate from parent)
- UI for subdomain organization and filtering
- Team segmentation by subdomain

**Business Impact:**
- Unlocks enterprise tier pricing
- Enables multi-brand organizations
- Reputation isolation prevents cross-contamination

**User Benefits:**
- Marketing team sends from `marketing.example.com`
- Sales team sends from `sales.example.com`
- Poor performance in one subdomain doesn't affect others

---

### Q2 2026: Agency Features

#### [P2] Bulk Domain Onboarding & Templates

**Target:** April 2026 | **Effort:** 5-7 days

Bulk subdomain provisioning and DNS instruction templates for agencies managing many client domains.

**Key Capabilities:**
- CSV import for 50+ subdomains at once
- DNS instruction templates (save/reuse configurations)
- Bulk DKIM key generation
- Subdomain policy engine (apply rules across subdomains)

**Business Impact:**
- Increases agency customer retention
- Enables agencies to scale client management
- Reduces onboarding time from hours to minutes

**User Benefits:**
- Rapidly provision client subdomains
- Standardized DNS configurations across domains
- Manage hundreds of subdomains efficiently

---

#### [P2] Workspace Domain Transfer (Metadata Only)

**Target:** May 2026 | **Effort:** 5-7 days

Transfer domain metadata between workspaces within PenguinMails with full history preservation.

**Key Capabilities:**
- Domain transfer workflow (request → approve → transfer)
- Reputation history preserved during transfer
- DKIM keys and email accounts transferred with domain
- Bulk transfer supports 10+ domains at once

**Business Impact:**
- Supports agency client offboarding
- Enables workspace consolidation
- Maintains historical data during transitions

**User Benefits:**
- Agencies can transfer client domains when contracts end
- Clients can take ownership of their domain metadata
- Don't lose historical reputation data

**Note:** This is metadata transfer within PenguinMails only. DNS records remain at the user's registrar.

---

#### [P3] DNS Instruction Presets & One-Click Copy

**Target:** June 2026 | **Effort:** 2-3 days

Pre-configured DNS instruction templates with one-click copy for faster domain setup.

**Key Capabilities:**
- One-click "Copy All DNS Records" button
- Save and reuse DNS instruction templates
- Workspace-level template sharing
- Default PenguinMails templates (best practices)

**Business Impact:**
- Improves user experience
- Reduces support tickets for DNS configuration
- Faster onboarding for new domains

**User Benefits:**
- Copy all DNS records at once instead of one-by-one
- Ensure all domains follow best practices
- Pre-validated configurations reduce DNS mistakes

---

### Q3 2026: Power User Features

#### [P2] Real-Time DNS Validation & Misconfiguration Alerts

**Target:** September 2026 | **Effort:** 5-7 days

Real-time DNS record validation with proactive alerts for common misconfigurations.

**Key Capabilities:**
- Real-time DNS validation with instant feedback
- DNS validator identifies common configuration errors
- DNS change monitoring detects when records break
- DNS health score (0-100) indicates configuration quality
- Email/webhook alerts for DNS issues

**Business Impact:**
- Reduces support tickets
- Improves deliverability by catching DNS issues early
- Proactive monitoring prevents sending problems

**User Benefits:**
- Quickly identify DNS configuration problems
- Catch DNS issues before they affect sending
- Clear guidance reduces DNS mistakes
- Know immediately if DNS is configured correctly

---

### Q4 2026: Global Expansion

#### [P1] Multi-Region Sending Pools & DKIM Selectors

**Target:** December 2026 | **Effort:** 10-14 days

Send from multiple geographic regions with region-specific DKIM selectors and IP pools.

**Key Capabilities:**
- Configure domains for multiple regions (US, EU, APAC)
- Region-specific DKIM selectors (e.g., `us._domainkey`, `eu._domainkey`)
- Geographic routing (send from nearest region to recipient)
- Automatic failover if region unavailable
- Region-level reputation tracking

**Business Impact:**
- Enables global enterprise customers
- Unlocks international markets
- Meets regional data regulations (GDPR, etc.)

**User Benefits:**
- Better deliverability in international markets
- Faster email delivery worldwide
- Compliance with regional data regulations
- Automatic failover between regions

**Note:** Users still manage DNS at their registrar. We provide region-specific DKIM records for them to add.

---

### Q1 2027: Predictive Features

#### [P3] Reputation Prediction & Proactive Alerts

**Target:** March 2027 | **Effort:** 10-14 days

Predictive analytics for domain reputation trends with proactive recommendations.

**Key Capabilities:**
- Predict domain reputation trends 7-14 days ahead
- Proactive alerts before reputation drops significantly
- Recommendations based on platform-wide patterns
- Anomaly detection for unusual bounce/spam patterns
- Insights dashboard with trend predictions

**Business Impact:**
- Competitive differentiator for premium plans
- Improves customer success
- Reduces churn by preventing deliverability issues

**User Benefits:**
- Fix issues before they impact deliverability
- Data-driven decisions based on platform-wide patterns
- Prevent reputation damage before it happens
- Learn from aggregate platform data

**Note:** This is pattern-based analytics, not deep AI/ML. Analyzes platform-wide trends and applies them to individual domains.

---

## Optional MVP Enhancements

These are low-priority convenience features that can be implemented if time permits, but are not blocking MVP launch:

### [P3] Bulk Domain Import

**Effort:** 2-3 days

CSV upload for importing multiple domains at once. Current one-by-one flow is acceptable for MVP.

### [P3] Domain Configuration Templates

**Effort:** 2-3 days

Save DNS configurations as templates for faster setup. Current automated generation is fast enough for MVP.

---

## Roadmap Summary

### Timeline Overview

| Quarter | Features | Total Effort | Focus Area |
|---------|----------|--------------|------------|
| **Q1 2026** | Subdomain Support | 3-5 days | Enterprise enabler |
| **Q2 2026** | Bulk Onboarding, Transfers, Presets | 12-17 days | Agency features |
| **Q3 2026** | Real-Time DNS Validation | 5-7 days | Power user features |
| **Q4 2026** | Multi-Region Sending Pools | 10-14 days | Global expansion |
| **Q1 2027** | Reputation Prediction | 10-14 days | Predictive features |

**Total Post-MVP Effort:** 40-57 days (8-11 weeks)

### Priority Distribution

- **P1 (High Priority):** 2 features - Subdomain support, Multi-region sending
- **P2 (Medium Priority):** 3 features - Bulk onboarding, Transfers, DNS validation
- **P3 (Low Priority):** 5 features - Optional enhancements and convenience features

### Business Impact by Quarter

**Q1 2026:** Enterprise sales enablement
- Subdomain support unlocks enterprise tier pricing
- Enables multi-brand organizations

**Q2 2026:** Agency retention and growth
- Bulk operations support key customer segment
- Transfer features enable flexible client management

**Q3 2026:** User experience and support reduction
- DNS validation reduces support tickets
- Proactive monitoring improves deliverability

**Q4 2026:** Global market expansion
- Multi-region sending enables international customers
- Compliance with regional regulations

**Q1 2027:** Competitive differentiation
- Predictive features differentiate premium plans
- Data-driven insights improve customer success

---

## Scope Constraints

### What We're Building

PenguinMails is an SMTP platform, not a DNS registrar. We focus on:

- ✅ DNS instruction generation (SPF, DKIM, DMARC, CNAME)
- ✅ DNS verification (check if records exist)
- ✅ DKIM key management (generate, rotate, store in Vault)
- ✅ Sending pool management (IPs, regions, reputation)
- ✅ Email identity management (authentication, reputation, analytics)

### What We're NOT Building

- ❌ Domain registrar features (buying domains, NS records)
- ❌ DNS hosting/authority (zone files, wildcard DNS control)
- ❌ Automated DNS propagation (users manage DNS at their registrar)
- ❌ DNS provider integrations (Cloudflare API, Route53 API) - Optional Post-MVP enhancement only

Users continue managing DNS at their registrar (Cloudflare, Namecheap, GoDaddy, etc.). We only generate instructions and verify records exist.

---

## Dependencies

### Infrastructure Dependencies

- **HashiCorp Vault** - DKIM private key storage (already implemented)
- **Multi-Region Infrastructure** - Required for Q4 2026 multi-region sending
- **Analytics Infrastructure** - Required for Q1 2027 reputation prediction

### Feature Dependencies

- **Subdomain Support** (Q1 2026) - Prerequisite for bulk subdomain onboarding (Q2 2026)
- **Historical Data Collection** - 6+ months of MVP data required for reputation prediction (Q1 2027)

### Third-Party Services

- **DNS Providers** - User-managed (Cloudflare, Route53, GoDaddy, Namecheap)
- **Let's Encrypt** - SSL certificates for tracking domains
- **Google Postmaster Tools** - Gmail reputation tracking
- **Blacklist Services** - URIBL, SURBL, Spamhaus

See [Domain Management Review](/.kiro/specs/feature-completeness-review/findings/domain-management.md) for detailed third-party dependency analysis.

---

## Related Documentation

### Planning & Strategy
- [Domain Management README](./README.md) - Feature overview
- [Product Roadmap](/docs/roadmap/product-roadmap) - Overall product direction
- [Feature Completeness Review](/.kiro/specs/feature-completeness-review/findings/domain-management.md) - Detailed gap analysis

### Implementation & Technical
- [Domain Routes](/docs/design/routes/workspace-domains) - UI specifications (7 routes)
- [Infrastructure Management](/docs/features/infrastructure/README.md) - VPS provisioning
- [Email Operations](/docs/features/email-operations/README.md) - Email sending pipeline
- [Warmup Features](/docs/features/warmup/README.md) - Email warmup system

### Security & Architecture
- [Vault Integration](/docs/technical/architecture/vault-integration-architecture) - DKIM key storage
- [Compliance & Security](/docs/compliance-security/overview) - Security architecture

---

**Last Updated:** November 26, 2025  
**Review Cycle:** Quarterly  
**Next Review:** February 2026
