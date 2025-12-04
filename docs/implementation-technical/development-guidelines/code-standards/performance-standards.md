---
title: "Performance Standards"
description: "Performance optimization guidelines and best practices"
last_modified_date: "2025-12-04"
level: "3"
persona: "Senior Developers"
keywords: "performance, optimization, caching, database, queries"
---

# Performance Standards

## Performance Standards

### Database Optimization

```typescript
// Optimized database queries with TypeScript

interface Campaign {
  id: string;
  name: string;
  subject: string;
  userId: string;
  createdAt: Date;
  recipients?: EmailRecipient[];
  analytics?: CampaignAnalytics[];
  user?: User;
}

interface EmailRecipient {
  id: string;
  email: string;
  name?: string;
  campaignId: string;
}

interface CampaignAnalytics {
  id: string;
  campaignId: string;
  sentCount: number;
  deliveredCount: number;
  openedCount: number;
  clickedCount: number;
}

interface User {
  id: string;
  email: string;
  name: string;
}

interface CampaignQueryOptions {
  includeRecipients?: boolean;
  includeAnalytics?: boolean;
  includeUser?: boolean;
  limit?: number;
  offset?: number;
}

/**

 * Service with performance-optimized database operations
 */
class OptimizedCampaignService {
  constructor(private readonly db: DatabaseService) {}

  /**

   * Eager load related data to minimize N+1 queries
   */
  async getCampaignWithMetrics(
    campaignId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign | null> {
    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.id = :campaignId', { campaignId });

    // Eager load recipients to avoid N+1 queries
    if (options.includeRecipients !== false) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    // Join with user table
    if (options.includeUser) {
      queryBuilder.leftJoinAndSelect('campaign.user', 'user');
    }

    // Load analytics in one query
    if (options.includeAnalytics) {
      queryBuilder.leftJoinAndSelect('campaign.analytics', 'analytics');
    }

    return queryBuilder.getOne();
  }

  /**

   * Efficiently load campaigns with pagination
   */
  async getCampaignsBatch(
    userId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign[]> {
    const { limit = 50, offset = 0, includeRecipients = true, includeAnalytics = true } = options;

    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.userId = :userId', { userId })
      .orderBy('campaign.createdAt', 'DESC')
      .take(limit)
      .skip(offset);

    // Eager load related data
    if (includeRecipients) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    if (includeAnalytics) {
      queryBuilder.leftJoinAndSelect('campaign.analytics', 'analytics');
    }

    return queryBuilder.getMany();
  }

  /**

   * Use database-level search for better performance
   */
  async searchCampaigns(
    query: string,
    userId: string,
    options: CampaignQueryOptions = {}
  ): Promise<Campaign[]> {
    const queryBuilder = this.db.createQueryBuilder()
      .select('campaign')
      .from(Campaign, 'campaign')
      .where('campaign.userId = :userId', { userId })
      .andWhere(
        '(campaign.name ILIKE :query OR campaign.subject ILIKE :query)',
        { query: `%${query}%` }
      )
      .orderBy('campaign.createdAt', 'DESC');

    // Include recipients for search results
    if (options.includeRecipients !== false) {
      queryBuilder.leftJoinAndSelect('campaign.recipients', 'recipients');
    }

    return queryBuilder.getMany();
  }
}

/**

 * Enhanced query builder interface
 */
interface QueryBuilder<T> {
  select(alias: string): QueryBuilder<T>;
  from(entity: Function, alias: string): QueryBuilder<T>;
  where(condition: string, parameters?: Record<string, unknown>): QueryBuilder<T>;
  andWhere(condition: string, parameters?: Record<string, unknown>): QueryBuilder<T>;
  leftJoinAndSelect(propertyPath: string, alias: string): QueryBuilder<T>;
  orderBy(sort: string, order?: 'ASC' | 'DESC'): QueryBuilder<T>;
  take(limit: number): QueryBuilder<T>;
  skip(offset: number): QueryBuilder<T>;
  getOne(): Promise<T | null>;
  getMany(): Promise<T[]>;
}

interface DatabaseService {
  createQueryBuilder<T>(): QueryBuilder<T>;
}

```

### Caching Strategy

```typescript
// Efficient caching implementation with TypeScript

interface CacheValue {
  data: unknown;
  timestamp: number;
  ttl: number;
}

interface CacheOptions {
  ttl?: number; // Time to live in seconds
  tags?: string[];
}

interface CacheResult<T> {
  success: boolean;
  data?: T;
  error?: string;
}

/**

 * High-performance caching service
 */
class CacheService {
  private readonly defaultTTL = 3600; // 1 hour
  private readonly redisClient: RedisClient;

  constructor(redisClient: RedisClient) {
    this.redisClient = redisClient;
  }

  /**

   * Get value from cache with error handling
   */
  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redisClient.get(key);
      if (!value) return null;

      const parsed = JSON.parse(value) as CacheValue;

      // Check if cache entry has expired
      if (Date.now() - parsed.timestamp > parsed.ttl * 1000) {
        await this.redisClient.del(key);
        return null;
      }

      return parsed.data as T;
    } catch (error) {
      console.warn(`Cache get failed for key ${key}:`, error);
      return null;
    }
  }

  /**

   * Set value in cache with expiration
   */
  async set<T>(key: string, value: T, options: CacheOptions = {}): Promise<boolean> {
    const ttl = options.ttl || this.defaultTTL;

    try {
      const cacheValue: CacheValue = {
        data: value,
        timestamp: Date.now(),
        ttl
      };

      await this.redisClient.setex(key, ttl, JSON.stringify(cacheValue));
      return true;
    } catch (error) {
      console.warn(`Cache set failed for key ${key}:`, error);
      return false;
    }
  }

  /**

   * Invalidate multiple keys matching a pattern
   */
  async invalidatePattern(pattern: string): Promise<number> {
    try {
      const keys = await this.redisClient.keys(pattern);
      if (keys.length === 0) return 0;

      return await this.redisClient.del(...keys);
    } catch (error) {
      console.warn(`Cache invalidate failed for pattern ${pattern}:`, error);
      return 0;
    }
  }

  /**

   * Get multiple cache values in batch
   */
  async mget<T>(keys: string[]): Promise<(T | null)[]> {
    try {
      const values = await this.redisClient.mget(keys);
      return values.map(value => {
        if (!value) return null;

        try {
          const parsed = JSON.parse(value) as CacheValue;
          if (Date.now() - parsed.timestamp > parsed.ttl * 1000) {
            return null;
          }
          return parsed.data as T;
        } catch {
          return null;
        }
      });
    } catch (error) {
      console.warn(`Cache mget failed for keys ${keys.join(', ')}:`, error);
      return keys.map(() => null);
    }
  }
}

/**

 * Decorator for caching function results
 */
class CampaignCacheDecorator {
  constructor(
    private readonly cacheService: CacheService,
    private readonly defaultTTL: number = 300 // 5 minutes
  ) {}

  /**

   * Decorator for caching campaign data
   */
  cachedCampaign<T extends (...args: unknown[]) => Promise<unknown>>(
    ttl?: number
  ) {
    return (target: unknown, propertyKey: string, descriptor: PropertyDescriptor) => {
      const originalMethod = descriptor.value;

      descriptor.value = async function (...args: unknown[]) {
        const cacheKey = `campaign:${JSON.stringify(args)}`;

        // Try cache first
        const cached = await this.cacheService.get<T>(cacheKey);
        if (cached !== null) {
          return cached;
        }

        // Get from original method
        const result = await originalMethod.apply(this, args);

        // Cache result if not null/undefined
        if (result !== null && result !== undefined) {
          await this.cacheService.set(cacheKey, result, { ttl: ttl || this.defaultTTL });
        }

        return result;
      };

      return descriptor;
    };
  }
}

/**

 * Redis client interface
 */
interface RedisClient {
  get(key: string): Promise<string | null>;
  setex(key: string, ttl: number, value: string): Promise<void>;
  del(...keys: string[]): Promise<number>;
  mget(...keys: string[]): Promise<(string | null)[]>;
  keys(pattern: string): Promise<string[]>;
}

```

