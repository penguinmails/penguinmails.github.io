---
title: "Technical Architecture"
description: "System architecture for API key management"
level: "3"
keywords: "architecture, design, system"
---

# Technical Architecture

## Technical Architecture

### API Key Format

**Structure:** `pm_live_{32_random_chars}`

**Example:** `pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6`

**Components:**

- `pm` - PenguinMails prefix

- `live` - Environment indicator (live, test)

- `{32_random_chars}` - Cryptographically secure random string (base62: a-z, A-Z, 0-9)

**Generation:**

```typescript
import crypto from 'crypto';

function generateAPIKey(): string {
  const randomBytes = crypto.randomBytes(24); // 24 bytes = 32 base62 chars
  const base62 = randomBytes.toString('base64')
    .replace(/\+/g, '')
    .replace(/\//g, '')
    .replace(/=/g, '')
    .substring(0, 32);

  return `pm_live_${base62}`;
}

```

### Vault Secret Structure

**Path:** `/api_keys/{tenant_id}/{key_id}`

**Secret Fields:**

```json
{
  "key_hash": "bcrypt_hash_of_api_key",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "created_at": "2025-11-26T10:00:00Z",
  "last_used": "2025-11-26T15:30:00Z",
  "request_count": 15234,
  "error_count": 42,
  "rotation_policy": "on_demand",
  "status": "active",
  "name": "Production Server",
  "created_by": "user_id_123"
}

```

**Field Descriptions:**

- `key_hash` - bcrypt hash of API key (salt rounds: 12)

- `permissions` - Array of permission scopes

- `rate_limit` - Requests per minute allowed (tier-based)

- `created_at` - ISO 8601 timestamp of key creation

- `last_used` - ISO 8601 timestamp of last API request

- `request_count` - Total API requests made with this key

- `error_count` - Total errors (4xx, 5xx responses)

- `rotation_policy` - "on_demand" (manual regeneration only)

- `status` - "active" or "revoked"

- `name` - User-provided key name

- `created_by` - User ID who created the key

### Bcrypt Hashing

**Why bcrypt?**

- Slow hashing algorithm (prevents brute force attacks)

- Adaptive (can increase cost factor over time)

- Industry standard for password/key hashing

**Configuration:**

- Salt rounds: 12 (2^12 = 4096 iterations)

- Hashing time: ~250ms per key (acceptable for key generation)

**Implementation:**

```typescript
import bcrypt from 'bcrypt';

async function hashAPIKey(apiKey: string): Promise<string> {
  const saltRounds = 12;
  const hash = await bcrypt.hash(apiKey, saltRounds);
  return hash;
}

async function verifyAPIKey(apiKey: string, hash: string): Promise<boolean> {
  return await bcrypt.compare(apiKey, hash);
}

```

### Permission Scopes

| Scope | Description | API Endpoints |
|-------|-------------|---------------|
| `send_email` | Send emails via API | `POST /api/v1/emails/send` |
| `read_analytics` | Read campaign and email analytics | `GET /api/v1/analytics/*` |
| `manage_contacts` | Create, update, delete contacts | `POST/PUT/DELETE /api/v1/contacts/*` |
| `manage_campaigns` | Create, update, delete campaigns | `POST/PUT/DELETE /api/v1/campaigns/*` |
| `manage_templates` | Create, update, delete templates | `POST/PUT/DELETE /api/v1/templates/*` |
| `manage_domains` | Add, verify, delete domains | `POST/PUT/DELETE /api/v1/domains/*` |
| `read_inbox` | Read unified inbox messages | `GET /api/v1/inbox/*` |
| `manage_webhooks` | Configure webhooks | `POST/PUT/DELETE /api/v1/webhooks/*` |

**Scope Validation:**

- Each API endpoint checks required scope

- Returns 403 Forbidden if scope missing

- Multiple scopes can be assigned to single key

**Example:**

```typescript
// API endpoint with scope validation
app.post('/api/v1/emails/send',
  authenticateAPIKey,
  requireScope('send_email'),
  async (req, res) => {
    // Send email logic
  }
);

// Middleware to check scope
function requireScope(scope: string) {
  return (req, res, next) => {
    if (!req.apiKey.permissions.includes(scope)) {
      return res.status(403).json({
        error: 'Insufficient permissions',
        required_scope: scope,
        available_scopes: req.apiKey.permissions
      });
    }
    next();
  };
}

```

### Rate Limiting

**Tier-Based Limits:**

| Subscription Tier | Rate Limit | Burst Limit | Overage Behavior |
|-------------------|------------|-------------|------------------|
| Starter | 60 requests/min | 100 requests | 429 Too Many Requests |
| Pro | 300 requests/min | 500 requests | 429 Too Many Requests |
| Enterprise | 1000 requests/min | 2000 requests | 429 Too Many Requests |

**Rate Limit Algorithm:** Token Bucket

**Implementation:**

```typescript
import Redis from 'ioredis';

const redis = new Redis();

async function checkRateLimit(
  apiKeyId: string,
  rateLimit: number
): Promise<{ allowed: boolean; remaining: number }> {
  const key = `rate_limit:${apiKeyId}`;
  const now = Date.now();
  const windowStart = now - 60000; // 1 minute window

  // Remove old requests outside window
  await redis.zremrangebyscore(key, 0, windowStart);

  // Count requests in current window
  const requestCount = await redis.zcard(key);

  if (requestCount >= rateLimit) {
    return { allowed: false, remaining: 0 };
  }

  // Add current request
  await redis.zadd(key, now, `${now}-${Math.random()}`);
  await redis.expire(key, 60); // Expire after 1 minute

  return {
    allowed: true,
    remaining: rateLimit - requestCount - 1
  };
}

```

**Rate Limit Headers:**

```text

X-RateLimit-Limit: 300
X-RateLimit-Remaining: 287
X-RateLimit-Reset: 1732618800

```

### Usage Tracking

**Tracked Metrics:**

- Total requests (lifetime)

- Error count (4xx, 5xx responses)

- Last used timestamp

- Requests per day (last 30 days)

- Most common endpoints

- Geographic distribution (IP-based)

**Storage:** PostgreSQL + Redis

**Database Schema:**

```sql
CREATE TABLE api_key_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  api_key_id UUID NOT NULL,
  endpoint VARCHAR(255) NOT NULL,
  method VARCHAR(10) NOT NULL,
  status_code INTEGER NOT NULL,
  response_time_ms INTEGER NOT NULL,
  ip_address INET,
  user_agent TEXT,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_api_key_usage_tenant_key
  ON api_key_usage(tenant_id, api_key_id, created_at DESC);

CREATE INDEX idx_api_key_usage_created_at
  ON api_key_usage(created_at DESC);

```

**Usage Aggregation:**

```typescript
async function getAPIKeyUsageStats(
  tenantId: string,
  apiKeyId: string
): Promise<UsageStats> {
  const stats = await db.query(`
    SELECT
      COUNT(*) as total_requests,
      COUNT(*) FILTER (WHERE status_code >= 400) as error_count,
      MAX(created_at) as last_used,
      AVG(response_time_ms) as avg_response_time
    FROM api_key_usage
    WHERE tenant_id = $1 AND api_key_id = $2
  `, [tenantId, apiKeyId]);

  return stats.rows[0];
}

```

---
