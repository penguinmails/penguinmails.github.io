---
title: "CORE-4.3: Implement a Redis Health Check Endpoint"
description: "Documentation for CORE-4.3: Implement a Redis Health Check Endpoint - CORE 4.3 Implement Redis Health Check"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# CORE-4.3: Implement a Redis Health Check Endpoint

**Ticket ID:** CORE-4.3  
**Milestone:** 4 - High-Performance Services Layer  
**Priority:** 🔴 Critical  
**Status:** Not Started

## Description

Create a temporary API route (`/api/test/health/redis`) that uses the Redis client to run the `PING` command. This will serve as a simple way to verify that the API server can successfully connect to the Redis instance.

## Context

Health check endpoints are essential for monitoring and debugging. According to the [High-Level Architecture](../../docs/quick-access/high-level-architecture), system health monitoring is critical for:

- **Uptime Target:** 99.9% availability
- **Performance Monitoring:** Real-time system health checks
- **Infrastructure Health:** Verify all services are operational

This endpoint will be used during development and can be integrated into monitoring systems.

## Acceptance Criteria

1. ✅ A GET API route exists at `/api/test/health/redis`
2. ✅ The endpoint returns a `200 OK` status when Redis is connected
3. ✅ The response body is a JSON object like `{ "status": "ok", "response": "PONG" }`
4. ✅ If the connection fails, it returns a `503 Service Unavailable` error
5. ✅ The endpoint uses the Redis singleton from CORE-4.2
6. ✅ Error messages are clear and helpful for debugging

## Technical Details

### API Route Structure

```typescript
// app/api/test/health/redis/route.ts
import { NextResponse } from 'next/server';
import { redis } from '@/lib/redis';

export async function GET() {
  try {
    const response = await redis.ping();
    
    return NextResponse.json(
      {
        status: 'ok',
        service: 'redis',
        response: response,
        timestamp: new Date().toISOString(),
      },
      { status: 200 }
    );
  } catch (error) {
    return NextResponse.json(
      {
        status: 'error',
        service: 'redis',
        error: error instanceof Error ? error.message : 'Unknown error',
        timestamp: new Date().toISOString(),
      },
      { status: 503 }
    );
  }
}
```

### Expected Response Formats

**Success Response (200):**

```json
{
  "status": "ok",
  "service": "redis",
  "response": "PONG",
  "timestamp": "2025-10-27T12:00:00.000Z"
}
```

**Error Response (503):**

```json
{
  "status": "error",
  "service": "redis",
  "error": "Connection refused",
  "timestamp": "2025-10-27T12:00:00.000Z"
}
```

## Implementation Notes

- Use the Redis singleton from CORE-4.2
- Provide clear error messages for debugging
- Include timestamp in response for monitoring
- Consider adding response time metrics (future enhancement)
- This is a test endpoint - consider protecting or removing it in production
- Consider adding authentication for production use (future enhancement)

## Related Documentation

- [High-Level Architecture](../../docs/quick-access/high-level-architecture) - Health monitoring
- [Performance Monitoring Guide](../../operations_runbooks/performance_monitoring_guide) - Health checks

## Dependencies

- **CORE-4.2** - Redis singleton service must be created
- **CORE-1.1** - Next.js project must be initialized

## Testing

- [ ] Test with Redis connected - verify 200 response with "PONG"
- [ ] Test with Redis disconnected - verify 503 error response
- [ ] Test with invalid Redis URL - verify 503 error response
- [ ] Verify response includes timestamp
- [ ] Verify error messages are clear and helpful
- [ ] Test endpoint response time (should be < 100ms)
- [ ] Verify endpoint works in different environments (dev, staging, prod)
