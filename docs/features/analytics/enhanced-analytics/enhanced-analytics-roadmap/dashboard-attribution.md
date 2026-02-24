---
title: "Dashboard Service & ROI Attribution"
description: "Implementation details for custom dashboard widgets and multi-touch ROI attribution models."
last_modified_date: "2026-02-24"
level: "2"
---

# Dashboard Service & ROI Attribution

## Custom Dashboard Service

```typescript
interface DashboardWidget {
  id: string;
  type: 'metric' | 'chart' | 'table' | 'funnel';
  title: string;
  config: any;
  position: { x: number; y: number; w: number; h: number };
}

class CustomDashboardService {
  async renderWidget(widget: DashboardWidget): Promise<any> {
    switch (widget.type) {
      case 'metric':
        return await this.renderMetricWidget(widget);
      case 'chart':
        return await this.renderChartWidget(widget);
      case 'table':
        return await this.renderTableWidget(widget);
    }
  }

  private async renderMetricWidget(widget: DashboardWidget): Promise<any> {
    const { metric, timeRange, comparison } = widget.config;
    const currentValue = await this.calculateMetric(metric, timeRange);
    const previousValue = comparison ? await this.calculateMetric(metric, this.getPreviousPeriod(timeRange)) : null;

    return {
      value: currentValue,
      previousValue,
      change: previousValue ? ((currentValue - previousValue) / previousValue) * 100 : null,
      trend: currentValue > previousValue ? 'up' : 'down',
    };
  }
}
```

## ROI Attribution Service

```typescript
class ROIAttributionService {
  async calculateCampaignROI(
    campaignId: string,
    attributionModel: 'first_touch' | 'last_touch' | 'linear' | 'time_decay' | 'position_based'
  ): Promise<{
    revenue: number;
    cost: number;
    roi: number;
    attributedConversions: number;
  }> {
    const conversions = await this.getConversions(campaignId);
    const attributedRevenue = await this.applyAttributionModel(conversions, attributionModel);
    const cost = this.calculateCampaignCost(campaignId);
    const roi = ((attributedRevenue - cost) / cost) * 100;

    return { revenue: attributedRevenue, cost, roi, attributedConversions: conversions.length };
  }
}
```

---

## Technical Stack & Accuracy

### Infrastructure

- **ML/AI**: Gemini AI API
- **Database**: PostgreSQL + TimescaleDB (Time-series)
- **OLAP**: Optimized analytics queries
- **Tracking**: PostHog integration

### Accuracy Targets (75% → 90%)

1. **Multi-pixel tracking**: Fingerprinting for better open detection.
2. **Bot Detection**: Behavioral filtering of automated interactions.
3. **MPP Handling**: Privacy-safe tracking adaptations for Apple MPP.
4. **Enhanced Signals**: Read time, scroll depth, and forward rate tracking.
5. **classification**: ML-driven bounce reason identification.
