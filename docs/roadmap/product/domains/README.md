---
title: "Domain Management Roadmap"
description: "Roadmap for domain management, verification, and reputation features"
last_modified_date: "2025-12-09"
level: "2"
persona: "Product Teams, Technical Leaders"
parent: "/docs/roadmap/product/README.md"
---

# Domain Management Roadmap

## Overview

Domain management is **MVP-complete** with all essential features implemented. This roadmap outlines Post-MVP enhancements focused on enterprise features, agency operations, and global expansion.

**Current Status:** ✅ MVP Complete (November 2025)

## MVP Features (Completed)

* **Domain Verification**: Multi-step wizard with automated DNS record generation.
* **DNS Management**: Complete DNS record management (SPF, DKIM, DMARC, CNAME, MX).
* **Sender Authentication**: Industry-standard SPF, DKIM (2048-bit RSA), DMARC.
* **Health Monitoring**: Real-time reputation tracking, blacklist monitoring, Google Postmaster integration.
* **Multi-Domain Support**: Unlimited domains per workspace with independent configuration.
* **Email Account Management**: Per-domain email account provisioning and health tracking.
* **Custom Tracking Domains**: Branded link tracking with automated SSL (Let's Encrypt).
* **API Access**: Full programmatic domain management.

## Post-MVP Roadmap

### Q1 2026: Enterprise Features

* **[Subdomain Support & Reputation Isolation](subdomain-support.md)** (P1): Enable sending from subdomains with independent DKIM keys and reputation tracking.

### Q2 2026: Agency & Power User Features

* **[Bulk Domain Onboarding & Templates](bulk-domain-onboarding.md)** (P2): Bulk subdomain provisioning and DNS instruction templates for agencies.
* **[Workspace Domain Transfer (Metadata)](workspace-domain-transfer.md)** (P2): Transfer domain metadata between workspaces with history preservation.
* **[DNS Instruction Presets & One-Click Copy](dns-instruction-presets.md)** (P3): Pre-configured DNS instruction templates with one-click copy.

### Q3 2026: Advanced Monitoring

* **[Real-Time DNS Validation & Misconfiguration Alerts](real-time-dns-validation.md)** (P2): Real-time DNS record validation with proactive alerts.

### Q4 2026: Global Expansion

* **[Multi-Region Sending Pools & DKIM Selectors](multi-region-sending.md)** (P1): Send from multiple geographic regions with region-specific DKIM selectors.

### Q1 2027: Predictive Features

* **[Reputation Prediction & Proactive Alerts](reputation-prediction.md)** (P3): Predictive analytics for domain reputation trends.
