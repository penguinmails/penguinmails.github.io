---
title: "Personalization Engine - Behavioral Computation"
description: "Technical implementation of behavioral feature computation using Spark and real-time event processing."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - Behavioral Computation

### Behavioral Feature Computation

```typescript
interface CustomerEvent {
  customerId: string;
  eventType: 'page_view' | 'email_open' | 'email_click' | 'form_submit' | 'purchase' | 'login';
  timestamp: string;
  metadata: Record<string, string | number>;
}

interface EngagementFeatures {
  pageViews: number;
  emailOpens: number;
  formSubmits: number;
  purchases: number;
  logins: number;
  engagementScore: number;
  sessionDuration: number;
}

interface SparkDataFrame {
  groupBy(col: string): SparkDataFrame;
  count(): SparkDataFrame;
  agg(aggregations: Record<string, unknown>): SparkDataFrame;
  collect(): Array<Record<string, unknown>>;
  filter(condition: string): SparkDataFrame;
}

interface SparkSession {
  createDataFrame(data: CustomerEvent[]): SparkDataFrame;
}

class BehavioralFeatureComputer {
  private sparkSession: SparkSession;
  private featureWeights = {
    pageView: 0.3,
    emailOpen: 0.2,
    formSubmit: 0.2,
    purchase: 0.3,
    login: 0.1
  };

  constructor(sparkSession: SparkSession) {
    this.sparkSession = sparkSession;
  }

  async computeEngagementFeatures(customerEvents: CustomerEvent[]): Promise<EngagementFeatures> {
    // Filter events from the last 30 days
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const df = this.sparkSession.createDataFrame(customerEvents)
      .filter(`timestamp >= '${thirtyDaysAgo.toISOString()}'`);

    const engagementFeatures = await this.computeAggregatedFeatures(df);
    const engagementScore = this.calculateEngagementScore(engagementFeatures);
    const conversionRate = this.calculateConversionRate(engagementFeatures);

    return {
      ...engagementFeatures,
      engagementScore,
      emailOpens30d: engagementFeatures.emailOpens,
      formSubmits30d: engagementFeatures.formSubmits,
      conversionRate,
      loginFrequency: engagementFeatures.logins,
      sessionDuration: engagementFeatures.sessionDuration
    };
  }

  private async computeAggregatedFeatures(df: SparkDataFrame): Promise<{
    pageViews: number;
    emailOpens: number;
    formSubmits: number;
    purchases: number;
    logins: number;
    sessionDuration: number;
  }> {
    const counts = df.groupBy('eventType').count().collect();
    
    const pageViews = counts.find(c => c.eventType === 'page_view')?.count || 0;
    const emailOpens = counts.find(c => c.eventType === 'email_open')?.count || 0;
    const formSubmits = counts.find(c => c.eventType === 'form_submit')?.count || 0;
    const purchases = counts.find(c => c.eventType === 'purchase')?.count || 0;
    const logins = counts.find(c => c.eventType === 'login')?.count || 0;
    
    // Simplified session duration aggregation
    const sessionDuration = df.agg({ 'metadata.duration': 'sum' }).collect()[0]?.sum || 0;

    return {
      pageViews,
      emailOpens,
      formSubmits,
      purchases,
      logins,
      sessionDuration: sessionDuration / Math.max(logins, 1)
    };
  }

  private calculateEngagementScore(features: {
    pageViews: number;
    emailOpens: number;
    formSubmits: number;
    purchases: number;
    logins: number;
  }): number {
    // Normalize features to 0-1 scale (simplified)
    const normalizedPageViews = Math.min(features.pageViews / 100, 1);
    const normalizedEmailOpens = Math.min(features.emailOpens / 50, 1);
    const normalizedFormSubmits = Math.min(features.formSubmits / 10, 1);
    const normalizedPurchases = Math.min(features.purchases / 5, 1);
    const normalizedLogins = Math.min(features.logins / 20, 1);

    return (
      normalizedPageViews * this.featureWeights.pageView +
      normalizedEmailOpens * this.featureWeights.emailOpen +
      normalizedFormSubmits * this.featureWeights.formSubmit +
      normalizedPurchases * this.featureWeights.purchase +
      normalizedLogins * this.featureWeights.login
    );
  }

  private calculateConversionRate(features: {
    formSubmits: number;
    pageViews: number;
  }): number {
    if (features.pageViews === 0) return 0;
    return features.formSubmits / features.pageViews;
  }
}
```
