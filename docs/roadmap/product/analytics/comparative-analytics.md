---
title: "Comparative Analytics"
description: "Campaign comparison and A/B test analysis"
---

# Comparative Analytics

## Overview

**Priority**: P1 (MVP important)
**Effort**: Medium (5-7 days)
**Timeline**: Q1 2026

**Description**:
Implement side-by-side campaign comparison and A/B test result analysis.

**Acceptance Criteria**:

- Create `/dashboard/analytics/compare` route
- Support selecting 2-5 campaigns for comparison
- Display side-by-side metrics table with all key metrics
- Show comparative charts (bar charts, line charts)
- Highlight statistically significant differences (p-value < 0.05)
- Support A/B test result analysis with winner declaration
- Allow export of comparison data (CSV, Excel)
- Include percentage difference calculations between campaigns

**Dependencies**:

- Statistical significance calculation library
- Campaign selection UI component
- Comparative chart components
