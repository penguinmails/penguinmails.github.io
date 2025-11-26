---
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---
# Marketing Personalization Engine Technical Specification

## Overview

**Document Level:** Level 4 - Technical Implementation
**Target Audience:** Backend Engineers, ML Engineers, Personalization System Architects
**Technical Focus:** Segmentation, feature stores, real-time decisioning, content/offer APIs

This technical specification defines the implementation architecture for real-time marketing personalization including customer segmentation, feature management, and dynamic content delivery systems.

---

## Architecture Overview

### Core Personalization Pipeline

**Customer Data Platform (CDP):** PostgreSQL + Redis for real-time event streaming, PostgreSQL batch processing, Elasticsearch for customer indexing, data privacy controls with field-level encryption

**Real-Time Feature Store:** Redis for low-latency serving (<10ms), PostgreSQL for storage, PostgreSQL feature management, feature versioning with automated rollbacks

**Decision Engine:** Drools rule engine for business logic, TensorFlow Serving for ML inference, Redis-based contextual bandit, A/B testing framework with traffic allocation

### Segmentation Engine

```typescript
interface SegmentDefinition {
  name: string;
  conditions: SegmentCondition[];
  description?: string;
  createdAt: string;
}

interface SegmentCondition {
  field: string;
  operator: 'equals' | 'greater_than' | 'less_than' | 'contains' | 'in';
  value: string | number | string[];
}

interface ElasticsearchQuery {
  bool: {
    must: Array<{
      [key: string]: unknown;
    }>;
  };
}

interface CustomerSearchResult {
  hits: {
    hits: Array<{
      _source: {
        customer_id: string;
      };
    }>;
    total: {
      value: number;
    };
  };
}

interface RedisClient {
  sadd(key: string, ...values: string[]): Promise<number>;
  srem(key: string, ...values: string[]): Promise<number>;
  smembers(key: string): Promise<string[]>;
}

interface ElasticsearchClient {
  search(params: {
    index: string;
    body: {
      query: ElasticsearchQuery;
      _source?: string[];
    };
  }): Promise<CustomerSearchResult>;
}

class SegmentationEngine {
  private esClient: ElasticsearchClient;
  private redisClient: RedisClient;

  constructor(esClient: ElasticsearchClient, redisClient: RedisClient) {
    this.esClient = esClient;
    this.redisClient = redisClient;
  }

  async createDynamicSegment(segmentDefinition: SegmentDefinition): Promise<number> {
    // Build Elasticsearch query from segment conditions
    const esQuery = this.buildSegmentQuery(segmentDefinition.conditions);
    
    // Search for customers matching the segment criteria
    const segmentCustomers = await this.esClient.search({
      index: 'customer_profiles',
      body: {
        query: esQuery,
        _source: ['customer_id']
      }
    });

    // Add matching customers to Redis segment set
    const customerIds = segmentCustomers.hits.hits.map(hit => hit._source.customer_id);
    
    for (const customerId of customerIds) {
      await this.redisClient.sadd(`segment:${segmentDefinition.name}`, customerId);
    }

    return customerIds.length;
  }

  private buildSegmentQuery(conditions: SegmentCondition[]): ElasticsearchQuery {
    const mustQueries = conditions.map(condition => {
      switch (condition.operator) {
        case 'equals':
          return { term: { [condition.field]: condition.value } };
        case 'greater_than':
          return { range: { [condition.field]: { gt: condition.value } } };
        case 'less_than':
          return { range: { [condition.field]: { lt: condition.value } } };
        case 'contains':
          return { match: { [condition.field]: condition.value } };
        case 'in':
          return { terms: { [condition.field]: condition.value as string[] } };
        default:
          return { match_all: {} };
      }
    });

    return {
      bool: {
        must: mustQueries
      }
    };
  }

  async removeCustomerFromSegment(segmentName: string, customerId: string): Promise<void> {
    await this.redisClient.srem(`segment:${segmentName}`, customerId);
  }

  async getSegmentMembers(segmentName: string): Promise<string[]> {
    return await this.redisClient.smembers(`segment:${segmentName}`);
  }
}
```

---

## Feature Store Implementation

### Customer Feature Schema

```typescript
interface CustomerFeature {
  customerId: string;
  features: Record<string, number>;
  timestamp: number;
  featureType: 'customer' | 'behavioral' | 'contextual' | 'derived';
  version: string;
  metadata?: Record<string, unknown>;
}

interface FeatureStore {
  getCustomerFeatures(customerId: string, featureNames: string[]): Promise<Record<string, number>>;
  setCustomerFeatures(customerId: string, features: Record<string, number>): Promise<void>;
  getFeatureHistory(customerId: string, featureName: string, limit?: number): Promise<Array<CustomerFeature>>;
}

interface RedisHashClient {
  hgetall(key: string): Promise<Record<string, string>>;
  hset(key: string, field: string, value: string): Promise<number>;
  hget(key: string, field: string): Promise<string | null>;
  hmget(key: string, ...fields: string[]): Promise<(string | null)[]>;
  expire(key: string, seconds: number): Promise<boolean>;
}

class FeatureStoreImpl implements FeatureStore {
  private redisClient: RedisHashClient;
  private defaultTTL: number = 3600; // 1 hour

  constructor(redisClient: RedisHashClient) {
    this.redisClient = redisClient;
  }

  async getCustomerFeatures(customerId: string, featureNames: string[]): Promise<Record<string, number>> {
    const redisKey = `customer_features:${customerId}`;
    
    // Retrieve features from Redis hash
    const cachedFeatures = await this.redisClient.hmget(redisKey, ...featureNames);
    
    const features: Record<string, number> = {};
    
    for (let i = 0; i < featureNames.length; i++) {
      const featureName = featureNames[i];
      const value = cachedFeatures[i];
      
      features[featureName] = value !== null ? parseFloat(value) : 0.0;
    }
    
    return features;
  }

  async setCustomerFeatures(customerId: string, features: Record<string, number>): Promise<void> {
    const redisKey = `customer_features:${customerId}`;
    
    // Set each feature in the Redis hash
    for (const [featureName, value] of Object.entries(features)) {
      await this.redisClient.hset(redisKey, featureName, value.toString());
    }
    
    // Set TTL for the entire feature set
    await this.redisClient.expire(redisKey, this.defaultTTL);
  }

  async getFeatureHistory(customerId: string, featureName: string, limit: number = 10): Promise<Array<CustomerFeature>> {
    // In a real implementation, this would query a time-series database
    // For now, return empty array as placeholder
    return [];
  }

  async getFeatureVector(customerId: string): Promise<CustomerFeature> {
    const redisKey = `customer_features:${customerId}`;
    const features = await this.redisClient.hgetall(redisKey);
    
    const numericFeatures: Record<string, number> = {};
    for (const [key, value] of Object.entries(features)) {
      numericFeatures[key] = parseFloat(value) || 0.0;
    }
    
    return {
      customerId,
      features: numericFeatures,
      timestamp: Date.now(),
      featureType: 'customer',
      version: '1.0'
    };
  }
}
```

### Behavioral Feature Computation

```typescript
interface CustomerEvent {
  customerId: string;
  eventType: 'page_view' | 'email_open' | 'email_click' | 'form_submit' | 'purchase' | 'login';
  timestamp: string;
  metadata?: Record<string, unknown>;
  sessionId?: string;
  pageUrl?: string;
  userAgent?: string;
}

interface EngagementFeatures {
  engagementScore: number;
  pageViews30d: number;
  emailOpens30d: number;
  formSubmits30d: number;
  conversionRate: number;
  loginFrequency: number;
  sessionDuration: number;
}

interface SparkDataFrame {
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
    
    const recentEvents = customerEvents.filter(event =>
      new Date(event.timestamp) >= thirtyDaysAgo
    );

    // Create Spark DataFrame from events
    const df = this.sparkSession.createDataFrame(recentEvents);

    // Compute aggregate features
    const engagementFeatures = await this.computeAggregatedFeatures(df);

    // Calculate engagement score with weighted components
    const engagementScore = this.calculateEngagementScore(engagementFeatures);

    // Calculate conversion rate
    const conversionRate = this.calculateConversionRate(engagementFeatures);

    return {
      engagementScore: Math.min(engagementScore, 1.0),
      pageViews30d: engagementFeatures.pageViews,
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
    // Simulate Spark aggregation (in real implementation, this would use actual Spark)
    const sampleEvents = await df.collect();
    
    let pageViews = 0;
    let emailOpens = 0;
    let formSubmits = 0;
    let purchases = 0;
    let logins = 0;
    let sessionDuration = 0;

    for (const event of sampleEvents) {
      switch (event.eventType) {
        case 'page_view':
          pageViews++;
          break;
        case 'email_open':
          emailOpens++;
          break;
        case 'form_submit':
          formSubmits++;
          break;
        case 'purchase':
          purchases++;
          break;
        case 'login':
          logins++;
          break;
      }
    }

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
    const normalizedFormSubmits = Math.min(features.formSubmits / 20, 1);
    const normalizedPurchases = Math.min(features.purchases / 10, 1);
    const normalizedLogins = Math.min(features.logins / 30, 1);

    // Calculate weighted engagement score
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

---

## Real-Time Decisioning System

### Contextual Bandit Implementation

```typescript
interface ContentItem {
  id: string;
  type: 'article' | 'product' | 'video' | 'email' | 'banner';
  title: string;
  category: string;
  tags: string[];
  metadata: Record<string, unknown>;
}

interface CustomerFeatures {
  [key: string]: number;
}

interface ContextualFeatures {
  [key: string]: number;
}

interface PersonalizationContext {
  availableItems: ContentItem[];
  customerContext?: Record<string, unknown>;
  timeContext?: {
    hour: number;
    dayOfWeek: number;
    season: string;
  };
}

interface PersonalizationDecision {
  selectedContent: ContentItem;
  confidenceScore: number;
  reasoning: string;
  alternativeOptions: ContentItem[];
  explorationUsed: boolean;
}

interface MLModel {
  predict(features: number[]): Promise<number[]>;
}

class ContextualBanditDecisionEngine {
  private models: Record<string, MLModel>;
  private featureStore: FeatureStore;
  private explorationRate: number = 0.1; // 10% exploration
  private minExplorationBonus: number = 0;
  private maxExplorationBonus: number = 0.2;

  constructor(models: Record<string, MLModel>, featureStore: FeatureStore) {
    this.models = models;
    this.featureStore = featureStore;
  }

  async selectPersonalizedContent(
    customerId: string,
    context: PersonalizationContext
  ): Promise<PersonalizationDecision> {
    // Retrieve customer features
    const customerFeatures = await this.featureStore.getCustomerFeatures(customerId, [
      'engagement_score',
      'recency_score',
      'frequency_score',
      'monetary_score',
      'category_preferences'
    ]);

    const availableContent = context.availableItems;
    const scores: Array<{ item: ContentItem; score: number; features: number[] }> = [];

    // Score each content item
    for (const contentItem of availableContent) {
      const contextFeatures = this.buildContextFeatures(customerFeatures, contentItem, context);
      
      // Get predicted reward from ML model
      const predictedReward = await this.models['content_recommendation'].predict(contextFeatures);
      
      // Apply exploration-exploitation strategy
      const explorationBonus = this.shouldExplore() ?
        this.getExplorationBonus() : 0;

      const finalScore = predictedReward[0] + explorationBonus;
      
      scores.push({
        item: contentItem,
        score: finalScore,
        features: contextFeatures
      });
    }

    // Select content with highest score
    const sortedScores = scores.sort((a, b) => b.score - a.score);
    const bestScore = sortedScores[0];
    const selectedContent = bestScore.item;
    const confidenceScore = bestScore.score;

    // Select alternative options (top 3 excluding the selected)
    const alternativeOptions = sortedScores
      .slice(1, 4)
      .map(score => score.item);

    // Generate reasoning
    const reasoning = this.generateReasoning(selectedContent, customerFeatures, confidenceScore);

    return {
      selectedContent,
      confidenceScore,
      reasoning,
      alternativeOptions,
      explorationUsed: explorationBonus > 0
    };
  }

  private buildContextFeatures(
    customerFeatures: Record<string, number>,
    contentItem: ContentItem,
    context: PersonalizationContext
  ): number[] {
    const features: number[] = [];

    // Customer features
    features.push(customerFeatures.engagement_score || 0);
    features.push(customerFeatures.recency_score || 0);
    features.push(customerFeatures.frequency_score || 0);
    features.push(customerFeatures.monetary_score || 0);

    // Content features
    features.push(this.encodeCategory(contentItem.category));
    features.push(contentItem.tags.length / 10); // Normalize tag count
    features.push(this.getContentAge(contentItem));

    // Context features
    if (context.timeContext) {
      features.push(context.timeContext.hour / 24);
      features.push(context.timeContext.dayOfWeek / 7);
    } else {
      features.push(0, 0); // Default values
    }

    return features;
  }

  private shouldExplore(): boolean {
    return Math.random() < this.explorationRate;
  }

  private getExplorationBonus(): number {
    return this.minExplorationBonus +
           Math.random() * (this.maxExplorationBonus - this.minExplorationBonus);
  }

  private encodeCategory(category: string): number {
    // Simple category encoding (in production, would use proper encoding)
    const categories = ['article', 'product', 'video', 'email', 'banner'];
    return categories.indexOf(category) / categories.length;
  }

  private getContentAge(contentItem: ContentItem): number {
    // In real implementation, would calculate from contentItem creation date
    return Math.random(); // Placeholder
  }

  private generateReasoning(
    selectedContent: ContentItem,
    customerFeatures: Record<string, number>,
    confidenceScore: number
  ): string {
    const reasons = [];

    if (customerFeatures.engagement_score > 0.7) {
      reasons.push('high customer engagement');
    }

    if (selectedContent.category === 'product' && customerFeatures.monetary_score > 0.6) {
      reasons.push('strong purchase intent');
    }

    if (confidenceScore > 0.8) {
      reasons.push('high prediction confidence');
    }

    if (reasons.length === 0) {
      reasons.push('best overall match based on customer profile');
    }

    return `Selected due to ${reasons.join(', ')}`;
  }
}
```

### Real-Time API Endpoints

```typescript
import express, { Request, Response } from 'express';

interface PersonalizationRequest {
  customerId: string;
  availableItems: ContentItem[];
  context?: {
    pageUrl?: string;
    referrer?: string;
    deviceType?: 'mobile' | 'desktop' | 'tablet';
    location?: string;
  };
}

interface PersonalizationResponse {
  selectedItem: ContentItem;
  confidenceScore: number;
  reasoning: string;
  latencyMs: number;
  alternativeOptions: ContentItem[];
}

interface DecisionEngine {
  selectPersonalizedContent(customerId: string, context: PersonalizationContext): Promise<PersonalizationDecision>;
}

class PersonalizationAPIController {
  private decisionEngine: DecisionEngine;
  private app: express.Application;

  constructor(decisionEngine: DecisionEngine) {
    this.decisionEngine = decisionEngine;
    this.app = express();
    this.setupRoutes();
  }

  private setupRoutes(): void {
    this.app.post('/api/v1/personalize', this.personalizeContent.bind(this));
    this.app.get('/api/v1/health', this.healthCheck.bind(this));
  }

  async personalizeContent(req: Request, res: Response): Promise<void> {
    const startTime = Date.now();

    try {
      const request: PersonalizationRequest = req.body;

      // Validate request
      if (!request.customerId || !request.availableItems || request.availableItems.length === 0) {
        res.status(400).json({
          error: 'Invalid request: customerId and availableItems are required'
        });
        return;
      }

      // Create personalization context
      const context: PersonalizationContext = {
        availableItems: request.availableItems,
        customerContext: request.context,
        timeContext: {
          hour: new Date().getHours(),
          dayOfWeek: new Date().getDay(),
          season: this.getCurrentSeason()
        }
      };

      // Get personalization decision
      const decision = await this.decisionEngine.selectPersonalizedContent(
        request.customerId,
        context
      );

      // Calculate latency
      const latencyMs = Date.now() - startTime;

      // Prepare response
      const response: PersonalizationResponse = {
        selectedItem: decision.selectedContent,
        confidenceScore: decision.confidenceScore,
        reasoning: decision.reasoning,
        latencyMs,
        alternativeOptions: decision.alternativeOptions
      };

      // Log decision for analytics
      this.logDecision(request.customerId, decision, latencyMs);

      res.json(response);
    } catch (error) {
      console.error('Personalization error:', error);
      res.status(500).json({
        error: 'Internal server error',
        message: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  private async healthCheck(req: Request, res: Response): Promise<void> {
    try {
      // Check decision engine health
      const testContext: PersonalizationContext = {
        availableItems: [{
          id: 'test',
          type: 'article',
          title: 'Test',
          category: 'general',
          tags: [],
          metadata: {}
        }]
      };

      await this.decisionEngine.selectPersonalizedContent('test-customer', testContext);

      res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        services: {
          decisionEngine: 'healthy',
          featureStore: 'healthy'
        }
      });
    } catch (error) {
      res.status(503).json({
        status: 'unhealthy',
        timestamp: new Date().toISOString(),
        error: error instanceof Error ? error.message : 'Unknown error'
      });
    }
  }

  private getCurrentSeason(): string {
    const month = new Date().getMonth();
    if (month >= 2 && month <= 4) return 'spring';
    if (month >= 5 && month <= 7) return 'summer';
    if (month >= 8 && month <= 10) return 'fall';
    return 'winter';
  }

  private logDecision(
    customerId: string,
    decision: PersonalizationDecision,
    latencyMs: number
  ): void {
    // Log decision for analytics and model improvement
    console.log('Personalization decision', {
      customerId,
      selectedItemId: decision.selectedContent.id,
      confidenceScore: decision.confidenceScore,
      latencyMs,
      timestamp: new Date().toISOString()
    });
  }

  getExpressApp(): express.Application {
    return this.app;
  }
}
```

---

## Content and Offer APIs

### Content Management Integration

```typescript
import fetch from 'node-fetch';

interface ContentAPIResponse {
  content_items: ContentItem[];
  pagination: {
    page: number;
    per_page: number;
    total: number;
    has_more: boolean;
  };
  metadata: {
    generated_at: string;
    processing_time_ms: number;
  };
}

interface ContentAPIClient {
  getPersonalizedContent(
    customerSegment: string,
    contentType: string,
    count?: number
  ): Promise<ContentItem[]>;
  getContentByIds(ids: string[]): Promise<ContentItem[]>;
  getContentByCategory(category: string, limit?: number): Promise<ContentItem[]>;
}

class ContentAPIClientImpl implements ContentAPIClient {
  private baseUrl: string;
  private headers: Record<string, string>;
  private defaultTimeout: number = 5000; // 5 seconds

  constructor(baseUrl: string, apiKey: string) {
    this.baseUrl = baseUrl.replace(/\/$/, ''); // Remove trailing slash
    this.headers = {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
  }

  async getPersonalizedContent(
    customerSegment: string,
    contentType: string,
    count: number = 10
  ): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/personalized`;
      const params = new URLSearchParams({
        segment: customerSegment,
        type: contentType,
        limit: count.toString(),
        include_metadata: 'true'
      });

      const response = await fetch(`${url}?${params.toString()}`, {
        method: 'GET',
        headers: this.headers,
        signal: AbortSignal.timeout(this.defaultTimeout)
      });

      if (!response.ok) {
        throw new APIException(`Content API error: ${response.status} ${response.statusText}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch personalized content: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async getContentByIds(ids: string[]): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/batch`;
      
      const response = await fetch(url, {
        method: 'POST',
        headers: this.headers,
        body: JSON.stringify({ ids }),
        signal: AbortSignal.timeout(this.defaultTimeout)
      });

      if (!response.ok) {
        throw new APIException(`Content API error: ${response.status} ${response.statusText}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch content by IDs: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }

  async getContentByCategory(category: string, limit: number = 20): Promise<ContentItem[]> {
    try {
      const url = `${this.baseUrl}/api/v2/content/category/${encodeURIComponent(category)}`;
      const params = new URLSearchParams({ limit: limit.toString() });

      const response = await fetch(`${url}?${params.toString()}`, {
        method: 'GET',
        headers: this.headers,
        signal: AbortSignal.timeout(this.defaultTimeout)
      });

      if (!response.ok) {
        throw new APIException(`Content API error: ${response.status} ${response.statusText}`);
      }

      const data: ContentAPIResponse = await response.json();
      return data.content_items;
    } catch (error) {
      if (error instanceof APIException) {
        throw error;
      }
      throw new APIException(`Failed to fetch content by category: ${error instanceof Error ? error.message : 'Unknown error'}`);
    }
  }
}

class APIException extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'APIException';
  }
}
```

### Performance Monitoring

```typescript
interface PrometheusClient {
  histogram(name: string, value: number, labels?: Record<string, string>): void;
  counter(name: string, value?: number, labels?: Record<string, string>): void;
  gauge(name: string, value: number, labels?: Record<string, string>): void;
}

interface DecisionMetrics {
  decisionId: string;
  customerId: string;
  latencyMs: number;
  selectedItemId: string;
  confidenceScore: number;
  timestamp: string;
}

interface ConversionMetrics {
  customerId: string;
  contentId: string;
  conversionType: string;
  value?: number;
  decisionId?: string;
  timestamp: string;
}

class PersonalizationPerformanceMonitor {
  private prometheusClient: PrometheusClient;
  private metricsBuffer: DecisionMetrics[] = [];

  constructor(prometheusClient: PrometheusClient) {
    this.prometheusClient = prometheusClient;
  }

  trackDecisionMetrics(decisionId: string, customerId: string, latencyMs: number): void {
    // Track latency metrics
    this.prometheusClient.histogram('personalization_decision_latency_ms', latencyMs, {
      customer_segment: this.getCustomerSegment(customerId)
    });

    // Increment decision counter
    this.prometheusClient.counter('personalization_decisions_total', 1, {
      customer_segment: this.getCustomerSegment(customerId)
    });

    // Store for batch processing
    this.metricsBuffer.push({
      decisionId,
      customerId,
      latencyMs,
      selectedItemId: '', // Will be filled by caller
      confidenceScore: 0, // Will be filled by caller
      timestamp: new Date().toISOString()
    });

    // Flush buffer if it gets too large
    if (this.metricsBuffer.length > 1000) {
      this.flushMetricsBuffer();
    }
  }

  trackConversionMetrics(
    customerId: string,
    contentId: string,
    conversionType: string,
    value?: number,
    decisionId?: string
  ): void {
    // Track conversion counter
    this.prometheusClient.counter('personalization_conversions_total', 1, {
      conversion_type: conversionType,
      customer_segment: this.getCustomerSegment(customerId)
    });

    // Track conversion value if provided
    if (value !== undefined) {
      this.prometheusClient.histogram('personalization_conversion_value', value, {
        conversion_type: conversionType
      });
    }

    // Track conversion rate
    this.prometheusClient.counter('personalization_conversion_attempts_total', 1, {
      conversion_type: conversionType,
      customer_segment: this.getCustomerSegment(customerId)
    });

    // Calculate and track conversion rate
    this.trackConversionRate(conversionType, customerId);
  }

  private getCustomerSegment(customerId: string): string {
    // In real implementation, would look up customer segment from database
    // For now, return a default segment
    return 'default';
  }

  private async trackConversionRate(conversionType: string, customerId: string): Promise<void> {
    // Calculate conversion rate metrics
    const segment = this.getCustomerSegment(customerId);
    
    // Track conversion rate as a gauge
    this.prometheusClient.gauge('personalization_conversion_rate', 0, {
      conversion_type: conversionType,
      customer_segment: segment
    });
  }

  private flushMetricsBuffer(): void {
    // Process buffered metrics in batch
    const batch = [...this.metricsBuffer];
    this.metricsBuffer = [];

    // In real implementation, would send to analytics service
    console.log(`Processed ${batch.length} decision metrics`);
  }

  async generatePerformanceReport(timeRange: { start: Date; end: Date }): Promise<{
    totalDecisions: number;
    averageLatencyMs: number;
    p95LatencyMs: number;
    conversionRate: number;
    topPerformingContent: Array<{ contentId: string; conversions: number }>;
  }> {
    // In real implementation, would query time-series database
    // For now, return mock data
    return {
      totalDecisions: 10000,
      averageLatencyMs: 45,
      p95LatencyMs: 120,
      conversionRate: 0.12,
      topPerformingContent: [
        { contentId: 'article-123', conversions: 150 },
        { contentId: 'product-456', conversions: 120 },
        { contentId: 'video-789', conversions: 90 }
      ]
    };
  }
}
```

---

## Dependencies and Infrastructure

**Required Services:** PostgreSQL + Redis for streaming, PostgreSQL for processing, Redis for storage, TensorFlow Serving for ML inference, Elasticsearch for search, Prometheus/Grafana for monitoring

**Infrastructure:** Auto-scaling API servers (8-32 cores), GPU nodes for ML, high-memory instances (64GB+), Redis cluster, performance targets: <50ms decision latency, <10ms feature retrieval, 10,000+ decisions/second

---

## Business Context and Traceability

- **For strategic context see:** `docs/business/marketing/strategy/detailed.md`
- **For journey optimization see:** `docs/business/marketing/journey/summary.md`
- **For technical foundation see:** `../analytics-integration/marketing-analytics-architecture.md`

This technical implementation focuses exclusively on personalization system architecture and real-time decisioning algorithms without business value narratives.
---
