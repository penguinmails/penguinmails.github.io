---
title: "Data Visualization"
description: "Data visualization components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "visualization, charts, graphs"
---

# Data Visualization

## Data Visualization

### Charts & Graphs

**Recommended Library**: **Recharts** (React-friendly, declarative)

**Requirements**:

- Responsive charts (adapt to container width)

- Accessible (ARIA labels, keyboard navigation)

- Consistent color palette (use design tokens)

- Interactive tooltips

**Chart Types Needed**:

- Line charts: Campaign performance over time

- Bar charts: Comparative metrics

- Pie/Donut charts: Distribution (open rate, click rate)

- Area charts: Cumulative metrics

### Real-time Updates

**Pattern**: Server-Sent Events (SSE) or WebSockets

**Use Cases**:

- Live campaign sending status

- Real-time analytics updates

- Notification feed

**Implementation**:

```typescript
// Server-Sent Events for one-way updates
const eventSource = new EventSource('/api/campaigns/123/live');
eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  updateCampaignMetrics(data);
};


```

---
