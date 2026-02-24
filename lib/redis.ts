import Redis from 'ioredis';
import { env } from '@/lib/env';

const globalForRedis = globalThis as unknown as { redis?: Redis };

export const redis =
  globalForRedis.redis ??
  new Redis(env.REDIS_URL, {
    maxRetriesPerRequest: 3,
    enableAutoPipelining: true,
    lazyConnect: true,
    retryStrategy: attempts => Math.min(attempts * 100, 2_000),
  });

if (process.env.NODE_ENV !== 'production') {
  globalForRedis.redis = redis;
}

redis.on('error', error => {
  console.error('Redis error:', error.message);
});
