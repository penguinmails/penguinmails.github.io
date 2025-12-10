---
title: "Subdomain Support & Reputation Isolation"
description: "Enable sending from subdomains with independent DKIM keys and reputation tracking"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Teams, Technical Leaders"
parent: "/docs/roadmap/product/domains/README.md"
---

# Subdomain Support & Reputation Isolation

## Overview

**Priority**: P1 (High - Enterprise Enabler)
**Effort**: 3-5 days
**Timeline**: Q1 2026

**Description**:
Enable sending from subdomains with independent DKIM keys and reputation tracking for team segmentation and brand isolation.

## Use Cases

- Marketing team sends from `marketing.example.com`
- Sales team sends from `sales.example.com`
- Support team sends from `support.example.com`
- Each subdomain maintains independent reputation

## Acceptance Criteria

- Subdomain validation and verification
- Independent DKIM key generation per subdomain
- Subdomain-level reputation tracking (isolated from parent domain)
- UI subdomain organization (grouping/filtering)
- Subdomain tree view (optional)
- API endpoints for subdomain operations

## Business Impact

- Unlocks enterprise tier pricing
- Enables multi-brand organizations
- Provides reputation isolation for different teams
- Supports A/B testing with separate domain reputations

## Dependencies

- Domain verification system (✅ implemented)
- Reputation monitoring system (✅ implemented)
