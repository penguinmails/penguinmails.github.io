# CORE-4.2: Create a Singleton Redis Service

**Ticket ID:** CORE-4.2  
**Milestone:** 4 - High-Performance Services Layer  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a file at `/lib/redis.ts`. In this file, initialize a new Redis client and export it as a singleton instance. This ensures that only one connection pool is created and shared efficiently across the application.

## Context

A singleton Redis client is essential for performance and resource management. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), Redis handles:

- **Session Storage:** User sessions and authentication tokens
- **Real-time Data:** Current campaign status, deliverability metrics
- **Rate Limiting:** API rate limiting and abuse prevention
- **Queue Processing:** Fast job queues for email processing

A singleton pattern ensures efficient connection reuse and prevents connection pool exhaustion.

## Acceptance Criteria

1. ✅ The `/lib/redis.ts` file exists and exports a single client instance
2. ✅ The application can import and use this client instance in any server-side module without errors
3. ✅ The Redis client is initialized with the `REDIS_URL` from environment variables
4. ✅ The client handles connection errors gracefully
5. ✅ The client supports basic operations (get, set, ping)
6. ✅ Multiple imports of the Redis client use the same instance (singleton pattern)

## Technical Details

### Redis Service Structure

```typescript
// lib/redis.ts
import Redis from 'ioredis';

let redis: Redis | null = null;

export function getRedisClient(): Redis {
  if (!redis) {
    redis = new Redis(process.env.REDIS_URL!, {
      maxRetriesPerRequest: 3,
      retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
      },
      reconnectOnError: (err) => {
        const targetError = 'READONLY';
        if (err.message.includes(targetError)) {
          return true;
        }
        return false;
      },
    });

    redis.on('error', (err) => {
      console.error('Redis Client Error:', err);
    });

    redis.on('connect', () => {
      console.log('Redis Client Connected');
    });
  }

  return redis;
}

// Export singleton instance
export const redis = getRedisClient();
```

### Alternative: Direct Singleton Export

```typescript
// lib/redis.ts
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL!, {
  maxRetriesPerRequest: 3,
  // ... other options
});

redis.on('error', (err) => {
  console.error('Redis Client Error:', err);
});

export { redis };
```

## Implementation Notes

- Use singleton pattern to ensure only one connection is created
- Configure connection retry strategy for resilience
- Add error handling and logging
- Consider adding connection health monitoring
- Support both development (local) and production (cloud) Redis instances
- Configure appropriate timeout and retry settings

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Cache layer
- [Database Schema Guide](../../docs/implementation-technical/database-infrastructure/database-schema-guide) - Queue system architecture (Redis integration)
- [Queue System Implementation Guide](../../docs/implementation-technical/database-infrastructure/queue-system-implementation-guide) - Queue system design and Redis integration
- [Connection Pooling Strategy](../../operations_runbooks/connection_pooling_strategy) - Connection management
- [Performance Monitoring Guide](../../operations_runbooks/performance_monitoring_guide) - Redis monitoring

## Dependencies

- **CORE-4.1** - Redis client must be installed and configured

## Testing

- [ ] Verify Redis client can be imported without errors
- [ ] Test that multiple imports use the same instance
- [ ] Test basic Redis operations (get, set, ping)
- [ ] Verify connection is established successfully
- [ ] Test error handling for invalid connection string
- [ ] Test error handling for Redis server unavailable
- [ ] Verify connection retry logic works
