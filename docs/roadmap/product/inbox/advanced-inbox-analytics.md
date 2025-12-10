---
title: "Advanced Inbox Analytics & Reporting"
description: "Build advanced analytics dashboard for inbox performance metrics"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/inbox/README.md"
---

# Advanced Inbox Analytics & Reporting

## Overview

**Priority**: P1 (High Value)
**Timeline**: Q2 2026
**Effort**: 3-4 weeks

**Description**:
Build advanced analytics dashboard for inbox performance metrics, extending the existing OLAP Analytics Database with inbox-specific tables.

## Acceptance Criteria

- **Create OLAP analytics tables**:
  - `inbox_analytics` - Daily aggregated inbox metrics
  - `inbox_rep_analytics` - Per-rep performance metrics
  - `inbox_category_analytics` - Per-category conversion metrics
  - Link to existing `billing_analytics` via foreign key
- **Create ETL jobs** to populate OLAP tables from OLTP data
- **Build reporting dashboard** with 10+ key metrics:
  - Average response time (overall, by rep, by campaign)
  - Conversion rate by AI category
  - Time-to-close analysis
  - Rep performance leaderboard
  - Category distribution
  - Thread volume trends
- Add custom report builder and export to CSV/PDF
- Add scheduled report emails (daily/weekly digests)
- Update OLAP documentation with new tables

## Dependencies

- Unified Inbox MVP
- Sentiment Analysis (for category-based analytics)
