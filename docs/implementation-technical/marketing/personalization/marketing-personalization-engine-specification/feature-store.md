---
title: "Personalization Engine - Feature Store"
description: "Implementation details of the customer feature store for real-time personalization."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# Personalization Engine - Feature Store

## Feature Store Implementation

### Customer Feature Schema

```typescript
interface CustomerFeature {
  customerId: string;
  features: Record<string, number>;
  timestamp: number;
  featureType: 'customer' | 'behavioral' | 'contextual';
  version: string;
}

interface RedisHashClient {
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

  async setCustomerFeatures(customerId: string, features: Record<string, number>): Promise<void> {
    const redisKey = `features:customer:${customerId}`;
    
    for (const [featureName, value] of Object.entries(features)) {
      await this.redisClient.hset(redisKey, featureName, value.toString());
    }

    // Set TTL for the entire feature set
    await this.redisClient.expire(redisKey, this.defaultTTL);
  }

  async getCustomerFeatures(customerId: string, featureNames: string[]): Promise<Record<string, number>> {
    const redisKey = `features:customer:${customerId}`;
    const values = await this.redisClient.hmget(redisKey, ...featureNames);
    
    const features: Record<string, number> = {};
    featureNames.forEach((name, index) => {
      const val = values[index];
      features[name] = val !== null ? parseFloat(val) : 0.0;
    });

    return features;
  }

  async getFeatureHistory(customerId: string, featureName: string, limit: number = 10): Promise<Array<CustomerFeature>> {
    // In a real implementation, this would query a time-series database
    // For now, return empty array as placeholder
    return [];
  }

  async refreshFeatureStore(customerId: string): Promise<CustomerFeature> {
    const redisKey = `features:customer:${customerId}`;
    const allFeatures = await this.redisClient.hgetall(redisKey);
    
    const numericFeatures: Record<string, number> = {};
    for (const [key, value] of Object.entries(allFeatures)) {
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
