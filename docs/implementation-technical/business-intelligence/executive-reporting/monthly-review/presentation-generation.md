---
title: "Executive Presentation Generation"
description: "Automated generation of executive-level slide decks and visual reports from analysis data."
last_modified_date: "2025-12-04"
level: "3"
persona: "Technical Implementation"
---

# Executive Presentation Generation

The `ExecutivePresentationGenerator` converts complex raw analysis results into curated, visually impactful presentations tailored to specific audiences (Board, C-Suite, or VPs).

## Presentation Templates

### 1. Board Template

- **Focus**: Strategic overview, financial ROI, and long-term risk assessment.
- **Style**: High-level, executive-focused visualizations.
- **Slide Count**: ~15 slides.

### 2. C-Suite Template

- **Focus**: Business health, operational excellence, and market intelligence.
- **Style**: Analytical, data-driven visualizations.
- **Slide Count**: ~20 slides.

### 3. VP Template

- **Focus**: Performance metrics, operational details, and resource optimization.
- **Style**: Granular, operational dashboards.
- **Slide Count**: ~25 slides.

## Slide Construction Components

### Visualization Types

The generator supports multiple chart types dynamically populated from analysis data:

- **Scorecards**: Big bold numbers for high-level KPIs (e.g., Business Health Score).
- **Bar/Line Charts**: Comparative analysis and trend visualization.
- **Pie Charts**: Distribution of initiative statuses or recommendation priorities.
- **KPI Grids**: Multi-metric comparison summaries.

### Automated Content Mapping

| Source Data | Slide Type | Key Visuals |
|-------------|------------|-------------|
| Executive Scorecard | Executive Summary | Business Health KPI, Strategic Achievement |
| Financial Analysis | Financial Performance | ROI Bar Chart, Revenue Protection Metrics |
| Operational Metrics | Operational Excellence | Efficiency Trends Line Chart |
| Strategic Initiatives | Project Progress | Initiative Status Pie Chart |
| Market Analysis | Market Position | Competitive Advantage KPI Matrix |

## Appendix & Supporting Data

The generator automatically appends:

- **Analysis Methodology**: Transparent documentation of data sources (e.g., PostHog).
- **Key Definitions**: Glossary for standardized executive metric terminology.
- **Raw Data Tables**: Exportable links for deeper drill-down.
