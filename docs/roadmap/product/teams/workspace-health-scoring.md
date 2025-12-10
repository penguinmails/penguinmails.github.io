---
title: "Workspace Health Scoring System"
description: "Document and implement the workspace health scoring algorithm"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/teams/README.md"
---

# Workspace Health Scoring System

## Overview

**Priority**: P1 (High)
**Timeline**: Q1 2026 (3-5 days)
**Effort**: Medium

**Description**:
Document and implement the workspace health scoring algorithm that calculates 0-100 health scores based on campaign performance, deliverability, and engagement metrics.

## Acceptance Criteria

- Document health score calculation algorithm with weighted factors
- Implement background job for periodic health score calculation
- Document health score factors (deliverability rate, engagement rate, bounce rate, complaint rate, sending volume)
- Document color coding system (green 80-100, yellow 60-79, red 0-59)
- Implement health score display in workspace list view
- Document health score history and trending
- Add health score alerts for declining workspaces
- Create admin dashboard for monitoring workspace health

## Dependencies

- Analytics system for campaign metrics
- Background job queue for score calculation
- Workspace management UI
