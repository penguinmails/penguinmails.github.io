# CORE-4.1: Install Redis Client and Configure Connection

**Ticket ID:** CORE-4.1  
**Milestone:** 4 - High-Performance Services Layer  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Install a Node.js Redis client library (e.g., `ioredis`). Add the `REDIS_URL` connection string to the environment variables and the example template.

## Context

According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture.md), Redis is used for:
- **Cache Layer:** Session storage, real-time data, rate limiting
- **Queue Processing:** Fast job queues for email processing and analytics aggregation
- **Performance:** Reducing database load through caching

Redis is essential for the high-performance requirements outlined in the architecture, supporting 1000+ concurrent users and 100K+ emails per day per tenant.

## Acceptance Criteria

1. ✅ `ioredis` (or equivalent Redis client) is a dependency in `package.json`
2. ✅ The `REDIS_URL` is added to the `.env.example` file
3. ✅ The `REDIS_URL` environment variable is validated (can use validation from CORE-1.5)
4. ✅ The application can read the Redis connection string from environment variables
5. ✅ Connection string format is documented

## Technical Details

### Required Package

```json
{
  "dependencies": {
    "ioredis": "^latest"
  }
}
```

### Environment Variable

```env
# Redis Configuration
REDIS_URL=redis://localhost:6379
# Or for Redis with password:
# REDIS_URL=redis://:password@localhost:6379
# Or for Redis Cloud:
# REDIS_URL=rediss://:password@host:port
```

### Connection String Formats

- **Local:** `redis://localhost:6379`
- **With Password:** `redis://:password@host:port`
- **TLS/SSL:** `rediss://:password@host:port`
- **Cloud Providers:** Follow provider-specific format

## Implementation Notes

- Use `ioredis` as it's the most popular and feature-rich Redis client for Node.js
- Support both local and cloud Redis instances
- Document connection string format for different environments
- Consider adding connection retry logic (future enhancement)
- Consider adding connection pooling configuration (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture.md) - Cache layer architecture
- [Performance Monitoring Guide](../../operations_runbooks/performance_monitoring_guide.md) - Redis monitoring

## Dependencies

- **CORE-1.5** - Environment variables must be set up

## Testing

- [ ] Verify Redis package is installed correctly
- [ ] Verify REDIS_URL is in .env.example with placeholder value
- [ ] Test that environment variable is read correctly
- [ ] Verify connection string format is documented
- [ ] Test with different connection string formats (if applicable)


