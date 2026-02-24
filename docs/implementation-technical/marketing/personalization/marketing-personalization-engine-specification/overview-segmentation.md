---
title: "Personalization Engine - Overview & Segmentation"
description: "Overview of the Marketing Personalization Engine and technical implementation of the segmentation engine."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - Overview & Segmentation

## Overview

The Marketing Personalization Engine is responsible for delivering targeted content and offers based on customer behavior, preferences, and real-time context.

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
  value: any;
}

interface RedisClient {
  sadd(key: string, value: string): Promise<number>;
  srem(key: string, value: string): Promise<number>;
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

  async refreshSegment(segmentDefinition: SegmentDefinition): Promise<number> {
    const query = this.buildSegmentQuery(segmentDefinition.conditions);
    const searchResult = await this.esClient.search({
      index: 'customers',
      body: { query }
    });

    const customerIds = searchResult.hits.map(hit => hit.id);
    const segmentName = segmentDefinition.name;

    // Clear existing segment members
    await this.redisClient.del(`segment:${segmentName}`);

    // Add new members
    for (const customerId of customerIds) {
      await this.redisClient.sadd(`segment:${segmentName}`, customerId);
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
          return { terms: { [condition.field]: condition.value } };
        default:
          throw new Error(`Unsupported operator: ${condition.operator}`);
      }
    });

    return { bool: { must: mustQueries } };
  }

  async addCustomerToSegment(segmentName: string, customerId: string): Promise<void> {
    await this.redisClient.sadd(`segment:${segmentName}`, customerId);
  }

  async removeCustomerFromSegment(segmentName: string, customerId: string): Promise<void> {
    await this.redisClient.srem(`segment:${segmentName}`, customerId);
  }

  async getSegmentMembers(segmentName: string): Promise<string[]> {
    return await this.redisClient.smembers(`segment:${segmentName}`);
  }
}
```
