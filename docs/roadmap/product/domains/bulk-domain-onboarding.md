---
title: "Bulk Domain Onboarding & Templates"
description: "Bulk subdomain provisioning and DNS instruction templates for agencies"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams, Technical Leaders"
parent: "/docs/roadmap/product/domains/README.md"
---

# Bulk Domain Onboarding & Templates

## Overview

**Priority**: P2 (Medium - Agency Focus)
**Effort**: 5-7 days
**Timeline**: Q2 2026

**Description**:
Bulk subdomain provisioning and DNS instruction templates for agencies managing many client domains.

## Use Cases

- Agency imports 50 client subdomains via CSV
- Pre-configured DNS templates for consistent setup
- Standardized DKIM/SPF/DMARC policies across domains
- Team-based subdomain routing

## Acceptance Criteria

- CSV import for bulk subdomain creation (50+ at once)
- DNS instruction templates (save/reuse configurations)
- Bulk DKIM key generation
- Subdomain policy engine (apply rules to groups)
- Subdomain grouping and tagging
- Subdomain-level access control (RBAC integration)

## Business Impact

- Increases agency customer retention
- Enables agencies to scale client management
- Reduces manual configuration work
- Improves consistency across client domains

## Dependencies

- Subdomain support (Q1 2026)
- Team & tenant management (✅ implemented)
- RBAC system (✅ implemented)
