---
title: "Multi-Region Sending Pools & DKIM Selectors"
description: "Send from multiple geographic regions with region-specific DKIM selectors"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams, Technical Leaders"
parent: "/docs/roadmap/product/domains/README.md"
---

# Multi-Region Sending Pools & DKIM Selectors

## Overview

**Priority**: P1 (High - Global Expansion)
**Effort**: 10-14 days
**Timeline**: Q4 2026

**Description**:
Send from multiple geographic regions with region-specific DKIM selectors and IP pools for global reach and compliance.
**Note:** Users still manage DNS at their registrar. We provide region-specific DKIM records for them to add.

## Use Cases

- Send from US, EU, and APAC regions with optimized routing
- Meet data residency requirements (GDPR compliance)
- Reduce latency by sending from nearest region
- Automatic failover to backup region

## Acceptance Criteria

- Multi-region domain configuration
- Region-specific DKIM selectors (e.g., `us._domainkey`, `eu._domainkey`)
- Region-specific IP pools
- Geographic routing logic (send from nearest region)
- Region failover mechanism
- Region-level reputation tracking
- Multi-region analytics dashboard

## Business Impact

- Enables global enterprise customers
- Unlocks international markets
- Meets regional compliance requirements
- Improves global deliverability

## Dependencies

- Multi-region infrastructure (Post-MVP infrastructure work)
- Domain management system (✅ implemented)
- Reputation monitoring system (✅ implemented)
