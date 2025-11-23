---
title: "Analytics UI Patterns"
description: "Visual design guidelines and patterns for displaying analytics data in PenguinMails"
last_modified_date: "2025-11-21"
level: "2"
persona: "Product Designers & Developers"
---

# Analytics UI Patterns

**Purpose**: This document defines the standard visual patterns for displaying data within the PenguinMails application. It focuses on **how** to present information to ensure consistency, readability, and actionable insights.

---

## 1. Data Presentation Hierarchy

We follow a "Progressive Disclosure" philosophy for analytics:

1. **Headline Metrics (Data Cards)**: Immediate, high-level health check.
2. **Trends (Charts)**: Visual context over time.
3. **Details (Tables)**: Granular data for deep dives.

---

## 2. Data Cards (Headline Metrics)

Data cards are the primary entry point for understanding performance. They should be used at the top of dashboards.

### Visual Structure

* **Label**: Uppercase, small, muted (e.g., "TOTAL REVENUE").
* **Value**: Large, bold, high-contrast (e.g., "$12,450").
* **Trend Indicator**: Small pill or text showing % change vs. previous period (e.g., "↑ 12% vs last month").
  * **Green**: Positive change (Good).
  * **Red**: Negative change (Bad).
  * **Neutral**: No significant change.
* **Sparkline (Optional)**: A simplified line chart background to show the trend shape.

### Usage Rules

* **Grouping**: Group related cards (e.g., "Engagement" group: Sent, Opened, Clicked).
* **Clickability**: If a card represents a summary of a detailed report, the entire card should be clickable and link to that report.

---

## 3. Charts & Graphs

Charts provide context to the raw numbers.

### Standard Chart Types

* **Line/Area Charts**: Use for trends over time (e.g., "Daily Email Opens").
  * *Style*: Smooth curves (monotone), gradient fill below the line for depth.
* **Bar Charts**: Use for categorical comparisons (e.g., "Opens by Device Type").
* **Heatmaps**: Use for density data (e.g., "Best Time to Send" - Day vs. Hour).

### Interaction Patterns

* **Tooltips**: Essential. Hovering over any data point must reveal the exact value and date.
* **Cross-Filtering**: Clicking a data point (e.g., a bar for "Mobile") should filter adjacent components (e.g., the Data Table below) to show only that segment.
* **Empty States**: Never show a blank space. If no data exists, show a "No data available for this period" placeholder with a call to action (e.g., "Start a campaign").

---

## 4. Data Tables

Tables are for detailed analysis and individual record management.

### Visual Patterns

* **Density**: Offer "Comfortable" (default) and "Compact" modes.
* **Zebra Striping**: Avoid. Use subtle border separators for a cleaner look.
* **Row Hover**: Highlight the entire row on hover to aid readability.
* **Sticky Header**: Column headers must remain visible when scrolling.

### Columns & Data Types

* **Status Pills**: Use colored pills for status (e.g., Active, Paused, Error).
* **Numbers**: Always right-align numerical data. Use monospaced fonts for tabular figures if possible.
* **Actions**: The last column should contain row actions (Edit, Delete, View) or a "..." menu.

---

## 5. Linking & Navigation Strategy

How users move from a high-level metric to the underlying data.

### The "Drill-Down" Pattern

* **From Card to Report**: Clicking a "Bounces" data card should navigate to the `Reports > Bounces` view.
* **From Chart to Filtered List**: Clicking a spike in a "Daily Errors" chart should navigate to the Logs table, pre-filtered for that specific date.

### Contextual Links

* **"View Details"**: Use a standard "View Details ->" link or icon in the top-right of a card or chart container to take the user to the full-page version of that metric.
* **Breadcrumbs**: When drilling down, ensure breadcrumbs reflect the path (e.g., `Dashboard > Campaigns > Summer Sale > Analytics`).

---

## 6. Color Palette for Data

Use the semantic colors defined in [Design Tokens](/docs/design/design-tokens) to ensure accessibility and consistency.

* **Primary Data**: Brand Primary Color.
* **Secondary Data**: Brand Secondary or Neutral Gray.
* **Success/Good**: Semantic Green.
* **Warning**: Semantic Yellow/Orange.
* **Error/Bad**: Semantic Red.
* **Categorical**: Use the defined "Data Visualization" palette (distinct from UI colors) to ensure distinguishable categories.
