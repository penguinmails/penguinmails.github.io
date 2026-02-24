---
title: "Optimization Engine - Data Processing"
description: "Input signals, feature engineering pipelines, and data normalization standards for ML models."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Optimization Engine - Data Processing

## 2. Input Signals and Data Processing

### Real-Time Signals

**Campaign Metrics:** CTR, conversion rate, CPA, impression share, quality score, bid levels, budget utilization, competitor patterns.

**Contextual Data:** Time of day, day of week, device type, geographic location, seasonal trends, industry benchmarks.

```typescript
interface RawCampaignData {
  timestamp: string;
  clicks: number;
  impressions: number;
  conversions: number;
  spend: number;
  impressionShare: number;
  qualityScore: number;
}

interface EngineeredFeatures {
  hourOfDay: number;
  dayOfWeek: number;
  cpc: number;
  ctr: number;
  conversionRate: number;
  costPerConversion: number;
  impressionShare: number;
  qualityScore: number;
  dayOfMonth: number;
  isWeekend: boolean;
  timeCategory: 'morning' | 'afternoon' | 'evening' | 'night';
}

class FeatureEngineeringPipeline {
  async createFeatures(rawData: RawCampaignData[]): Promise<EngineeredFeatures[]> {
    return rawData.map(data => this.extractFeatures(data));
  }

  private extractFeatures(rawData: RawCampaignData): EngineeredFeatures {
    const date = new Date(rawData.timestamp);
    const hour = date.getHours();
    const dayOfWeek = date.getDay();
    const dayOfMonth = date.getDate();
    
    const ctr = rawData.impressions > 0 ? rawData.clicks / rawData.impressions : 0;
    const cpc = rawData.clicks > 0 ? rawData.spend / rawData.clicks : 0;
    const conversionRate = rawData.clicks > 0 ? rawData.conversions / rawData.clicks : 0;
    const costPerConversion = rawData.conversions > 0 ? rawData.spend / rawData.conversions : 0;
    
    const isWeekend = dayOfWeek === 0 || dayOfWeek === 6;
    const timeCategory = this.categorizeTime(hour);

    return {
      hourOfDay: hour,
      dayOfWeek: dayOfWeek,
      cpc,
      ctr,
      conversionRate,
      costPerConversion,
      impressionShare: rawData.impressionShare,
      qualityScore: rawData.qualityScore,
      dayOfMonth,
      isWeekend,
      timeCategory
    };
  }

  private categorizeTime(hour: number): 'morning' | 'afternoon' | 'evening' | 'night' {
    if (hour >= 6 && hour < 12) return 'morning';
    if (hour >= 12 && hour < 18) return 'afternoon';
    if (hour >= 18 && hour < 22) return 'evening';
    return 'night';
  }

  async normalize(features: EngineeredFeatures[]): Promise<EngineeredFeatures[]> {
    const normalized = [...features];
    
    // Normalize hour of day (0-23 -> 0-1)
    const maxHour = 23;
    normalized.forEach(f => f.hourOfDay = f.hourOfDay / maxHour);

    // Normalize day of week (0-6 -> 0-1)
    const maxDayOfWeek = 6;
    normalized.forEach(f => f.dayOfWeek = f.dayOfWeek / maxDayOfWeek);

    return normalized;
  }
}
```
