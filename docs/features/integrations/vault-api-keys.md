---
title: "Tenant API Key System with Vault"
description: "Secure API key generation, storage, and management system using HashiCorp Vault for programmatic email sending and platform access"
last_modified_date: "2025-11-26"
level: "3"
persona: "Developers, Technical Teams"
keywords: ["API keys", "Vault", "authentication", "security", "programmatic access", "rate limiting", "permissions"]
status: "PLANNED"
priority: "P0 - Critical"
roadmap_milestone: "MVP"
---

# Tenant API Key System with Vault

## Overview

The Tenant API Key System provides secure, self-service API key generation and management for programmatic access to PenguinMails. API keys enable tenants to send emails, manage contacts, and access analytics from their applications without requiring user authentication.

### Purpose

**Problem:** Tenants need programmatic access to PenguinMails for integrations with their applications, but traditional username/password authentication is unsuitable for server-to-server communication.

**Solution:** Generate unique API keys per tenant with:
- Secure storage in HashiCorp Vault (bcrypt hashing)
- Fine-grained permission scopes (send_email, read_analytics, manage_contacts)
- Tier-based rate limiting (Starter: 60/min, Pro: 300/min, Enterprise: 1000/min)
- Usage tracking (requests, errors, last used timestamp)
- Self-service management UI (create, view, regenerate, revoke)

### Key Features

1. **Secure Key Generation** - Cryptographically secure API keys with format `pm_live_{32_random_chars}`
2. **Vault Storage** - Keys hashed with bcrypt (12 salt rounds) and stored in Vault
3. **Permission Scopes** - Granular permissions for different API operations
4. **Rate Limiting** - Tier-based rate limits prevent abuse
5. **Usage Tracking** - Monitor API key usage (requests, errors, last used)
6. **Self-Service UI** - Tenants manage keys without support intervention
7. **Audit Trail** - All key operations logged for security compliance


---

## User Workflows

### 1. Create API Key

**Actor:** Tenant User (Developer, Admin)

**Preconditions:**
- User is authenticated and has API key management permissions
- Tenant has active subscription

**Steps:**
1. Navigate to `/dashboard/settings/developers/api-keys`
2. Click "Create API Key" button
3. Enter API key name (e.g., "Production Server", "Staging Environment")
4. Select permission scopes:
   - `send_email` - Send emails via API
   - `read_analytics` - Read campaign and email analytics
   - `manage_contacts` - Create, update, delete contacts
   - `manage_campaigns` - Create, update, delete campaigns
5. Review rate limit for current subscription tier
6. Click "Generate Key"
7. **CRITICAL:** Copy API key immediately (shown only once)
8. Store API key securely in application environment variables
9. Test API key with sample request

**Postconditions:**
- API key created and stored in Vault (hashed)
- API key displayed once in UI (never shown again)
- Audit log entry created
- User can authenticate API requests with new key


### 2. View API Keys

**Actor:** Tenant User

**Steps:**
1. Navigate to `/dashboard/settings/developers/api-keys`
2. View list of all API keys with:
   - Key name
   - Masked key value (`pm_live_abc...xyz`)
   - Permission scopes (badges)
   - Created date
   - Last used timestamp
   - Request count
   - Error count
   - Status (Active, Revoked)
3. Click "Copy" to copy masked key (for reference only)
4. Click key row to view detailed usage statistics

**Postconditions:**
- User can see all API keys and their usage
- Cannot view full API key value (security)

### 3. Regenerate API Key

**Actor:** Tenant User

**Preconditions:**
- API key exists and is active
- User suspects key compromise or needs rotation

**Steps:**
1. Navigate to API key list
2. Click "Regenerate" button for specific key
3. Confirm regeneration (warning: old key will be revoked immediately)
4. New API key generated and displayed once
5. Copy new API key immediately
6. Update application with new key
7. Old key revoked (cannot be used for authentication)

**Postconditions:**
- New API key created with same permissions
- Old API key revoked and marked inactive
- Audit log entry created
- Application must use new key


### 4. Revoke API Key

**Actor:** Tenant User

**Preconditions:**
- API key exists
- User wants to permanently disable key

**Steps:**
1. Navigate to API key list
2. Click "Revoke" button for specific key
3. Confirm revocation (warning: cannot be undone)
4. API key marked as revoked
5. All subsequent API requests with this key return 401 Unauthorized

**Postconditions:**
- API key revoked and cannot be used
- Audit log entry created
- Key remains visible in UI (for audit purposes) but marked as "Revoked"

### 5. Monitor API Key Usage

**Actor:** Tenant User

**Steps:**
1. Navigate to API key list
2. View usage metrics for each key:
   - Total requests (lifetime)
   - Error count (4xx, 5xx responses)
   - Last used timestamp
   - Rate limit status (requests remaining this minute)
3. Click key row to view detailed usage chart:
   - Requests per day (last 30 days)
   - Error rate trend
   - Most common endpoints accessed
   - Geographic distribution of requests

**Postconditions:**
- User understands API key usage patterns
- Can identify anomalies or abuse


---

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
```
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

## API Endpoints

### 1. Create API Key

**Endpoint:** `POST /api/v1/platform/api-keys`

**Authentication:** Bearer token (user session)

**Request Body:**
```json
{
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"]
}
```

**Response (201 Created):**
```json
{
  "api_key": "pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "created_at": "2025-11-26T10:00:00Z",
  "warning": "Store this key securely. It will not be shown again."
}
```

**Error Responses:**
- `400 Bad Request` - Invalid permissions or missing name
- `401 Unauthorized` - Invalid or missing bearer token
- `403 Forbidden` - User lacks API key management permission
- `429 Too Many Requests` - Rate limit exceeded for key creation


### 2. List API Keys

**Endpoint:** `GET /api/v1/platform/api-keys`

**Authentication:** Bearer token (user session)

**Response (200 OK):**
```json
{
  "api_keys": [
    {
      "key_id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Production Server",
      "masked_key": "pm_live_a1b...o5p6",
      "permissions": ["send_email", "read_analytics"],
      "rate_limit": 300,
      "status": "active",
      "created_at": "2025-11-26T10:00:00Z",
      "last_used": "2025-11-26T15:30:00Z",
      "request_count": 15234,
      "error_count": 42
    },
    {
      "key_id": "660e8400-e29b-41d4-a716-446655440001",
      "name": "Staging Environment",
      "masked_key": "pm_live_b2c...p6q7",
      "permissions": ["send_email"],
      "rate_limit": 60,
      "status": "revoked",
      "created_at": "2025-11-20T08:00:00Z",
      "last_used": "2025-11-25T12:00:00Z",
      "request_count": 5432,
      "error_count": 12
    }
  ],
  "total": 2
}
```

### 3. Get API Key Details

**Endpoint:** `GET /api/v1/platform/api-keys/{key_id}`

**Authentication:** Bearer token (user session)

**Response (200 OK):**
```json
{
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "masked_key": "pm_live_a1b...o5p6",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "status": "active",
  "created_at": "2025-11-26T10:00:00Z",
  "last_used": "2025-11-26T15:30:00Z",
  "request_count": 15234,
  "error_count": 42,
  "usage_by_day": [
    { "date": "2025-11-26", "requests": 1234, "errors": 5 },
    { "date": "2025-11-25", "requests": 2345, "errors": 8 }
  ],
  "top_endpoints": [
    { "endpoint": "/api/v1/emails/send", "count": 12000 },
    { "endpoint": "/api/v1/analytics/campaigns", "count": 3234 }
  ]
}
```


### 4. Regenerate API Key

**Endpoint:** `POST /api/v1/platform/api-keys/{key_id}/regenerate`

**Authentication:** Bearer token (user session)

**Response (200 OK):**
```json
{
  "api_key": "pm_live_c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Production Server",
  "permissions": ["send_email", "read_analytics", "manage_contacts"],
  "rate_limit": 300,
  "created_at": "2025-11-26T16:00:00Z",
  "warning": "Old key has been revoked. Update your application immediately."
}
```

### 5. Revoke API Key

**Endpoint:** `DELETE /api/v1/platform/api-keys/{key_id}`

**Authentication:** Bearer token (user session)

**Response (200 OK):**
```json
{
  "message": "API key revoked successfully",
  "key_id": "550e8400-e29b-41d4-a716-446655440000",
  "revoked_at": "2025-11-26T16:30:00Z"
}
```

### 6. Authenticate with API Key

**Endpoint:** Any API endpoint

**Authentication:** `Authorization: Bearer {api_key}`

**Example Request:**
```bash
curl -X POST https://api.penguinmails.com/api/v1/emails/send \
  -H "Authorization: Bearer pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "recipient@example.com",
    "subject": "Test Email",
    "body": "Hello from PenguinMails API"
  }'
```

**Error Responses:**
- `401 Unauthorized` - Invalid or missing API key
- `403 Forbidden` - API key lacks required permission scope
- `429 Too Many Requests` - Rate limit exceeded


---

## Frontend UI Specification

### Route: `/dashboard/settings/developers/api-keys`

**Page Title:** API Keys

**Layout:** Settings page with sidebar navigation

**Components:**

#### 1. API Key List Table

**Columns:**
- Name (user-provided)
- Key (masked: `pm_live_abc...xyz`)
- Permissions (badges)
- Rate Limit (requests/min)
- Status (Active, Revoked)
- Last Used (relative time: "2 hours ago")
- Actions (Copy, Regenerate, Revoke)

**Actions:**
- **Copy:** Copy masked key to clipboard (for reference)
- **Regenerate:** Open confirmation modal, generate new key
- **Revoke:** Open confirmation modal, revoke key

#### 2. Create API Key Button

**Location:** Top right of page

**Action:** Open "Create API Key" modal

**Modal Fields:**
- Name (text input, required)
- Permissions (multi-select checkboxes)
- Rate Limit (display only, based on subscription tier)

**Modal Actions:**
- Cancel (close modal)
- Generate Key (create key, display once)

#### 3. API Key Details Modal

**Trigger:** Click on API key row

**Content:**
- Key name
- Masked key value
- Permissions list
- Rate limit
- Created date
- Last used timestamp
- Usage chart (requests per day, last 30 days)
- Error rate chart
- Top endpoints table
- Geographic distribution map


#### 4. API Key Created Success Modal

**Trigger:** After successful key generation

**Content:**
- ⚠️ Warning: "Store this key securely. It will not be shown again."
- API key value (full, copyable)
- Copy button
- Download as .env file button
- Code examples (curl, Node.js, Python)

**Actions:**
- Copy Key (copy to clipboard)
- Download .env (download as file)
- Close (close modal, cannot reopen to view key)

**Example Code Snippets:**

**cURL:**
```bash
curl -X POST https://api.penguinmails.com/api/v1/emails/send \
  -H "Authorization: Bearer pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6" \
  -H "Content-Type: application/json" \
  -d '{"to": "user@example.com", "subject": "Test", "body": "Hello"}'
```

**Node.js:**
```javascript
const axios = require('axios');

const apiKey = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6';

axios.post('https://api.penguinmails.com/api/v1/emails/send', {
  to: 'user@example.com',
  subject: 'Test',
  body: 'Hello'
}, {
  headers: {
    'Authorization': `Bearer ${apiKey}`
  }
});
```

**Python:**
```python
import requests

api_key = 'pm_live_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6'

response = requests.post(
  'https://api.penguinmails.com/api/v1/emails/send',
  headers={'Authorization': f'Bearer {api_key}'},
  json={'to': 'user@example.com', 'subject': 'Test', 'body': 'Hello'}
)
```


---

## Security Considerations

### 1. API Key Storage

**Problem:** Storing API keys in plaintext exposes them if database is compromised.

**Solution:** Hash API keys with bcrypt before storing in Vault.

**Implementation:**
- Generate API key: `pm_live_{32_random_chars}`
- Hash with bcrypt (salt rounds: 12)
- Store hash in Vault, not plaintext key
- Display plaintext key once to user
- Verify API key by comparing hash on each request

**Security Benefits:**
- Database compromise doesn't expose API keys
- Brute force attacks infeasible (bcrypt is slow)
- Keys cannot be recovered from hash

### 2. API Key Transmission

**Problem:** API keys transmitted over HTTP can be intercepted.

**Solution:** Enforce HTTPS for all API requests.

**Implementation:**
- Redirect HTTP to HTTPS
- Use HSTS header to enforce HTTPS
- Reject API requests over HTTP

### 3. API Key Rotation

**Problem:** Long-lived API keys increase risk if compromised.

**Solution:** Enable self-service key regeneration.

**Implementation:**
- User can regenerate key at any time
- Old key immediately revoked
- New key generated and displayed once
- Audit log tracks all regenerations

**Best Practice:** Rotate API keys every 90 days (recommended, not enforced)


### 4. Rate Limiting

**Problem:** Unlimited API requests enable abuse and DDoS attacks.

**Solution:** Tier-based rate limiting with token bucket algorithm.

**Implementation:**
- Starter: 60 requests/min
- Pro: 300 requests/min
- Enterprise: 1000 requests/min
- Return 429 Too Many Requests when limit exceeded
- Include rate limit headers in all responses

**Security Benefits:**
- Prevents API abuse
- Protects infrastructure from overload
- Encourages efficient API usage

### 5. Permission Scopes

**Problem:** Single API key with full access increases risk if compromised.

**Solution:** Fine-grained permission scopes.

**Implementation:**
- User selects required scopes during key creation
- Each API endpoint checks required scope
- Returns 403 Forbidden if scope missing
- Principle of least privilege

**Example Use Cases:**
- **Send-only key:** Only `send_email` scope (for application sending emails)
- **Read-only key:** Only `read_analytics` scope (for dashboard integrations)
- **Full access key:** All scopes (for admin automation)

### 6. Audit Logging

**Problem:** No visibility into API key usage enables undetected abuse.

**Solution:** Comprehensive audit logging.

**Logged Events:**
- API key creation (who, when, permissions)
- API key regeneration (who, when)
- API key revocation (who, when)
- API key authentication attempts (success, failure)
- API requests (endpoint, status, response time)

**Audit Log Retention:** 90 days (configurable)


---

## API Key Best Practices

### For Developers

**1. Store Keys Securely**
- ✅ Store in environment variables (`.env` file)
- ✅ Use secret management tools (AWS Secrets Manager, Vault)
- ❌ Never commit keys to version control
- ❌ Never hardcode keys in source code
- ❌ Never share keys via email or chat

**2. Use Minimal Permissions**
- ✅ Create separate keys for different applications
- ✅ Grant only required permission scopes
- ❌ Don't use full-access keys for single-purpose applications

**3. Rotate Keys Regularly**
- ✅ Rotate keys every 90 days (recommended)
- ✅ Rotate immediately if key compromised
- ✅ Test new key before revoking old key

**4. Monitor Usage**
- ✅ Review API key usage regularly
- ✅ Set up alerts for unusual activity
- ✅ Investigate unexpected errors

**5. Handle Errors Gracefully**
- ✅ Implement exponential backoff for rate limit errors
- ✅ Log authentication failures
- ✅ Retry failed requests with backoff

### For PenguinMails Administrators

**1. Enforce Security Policies**
- ✅ Require HTTPS for all API requests
- ✅ Implement rate limiting per tier
- ✅ Monitor for suspicious activity

**2. Audit Regularly**
- ✅ Review audit logs weekly
- ✅ Investigate anomalies
- ✅ Revoke unused keys

**3. Educate Users**
- ✅ Provide security best practices documentation
- ✅ Send reminders for key rotation
- ✅ Offer security training


---

## Implementation Checklist

### Phase 1: Backend Infrastructure (Week 1)

- [ ] Implement API key generation function (`generateAPIKey()`)
- [ ] Implement bcrypt hashing (`hashAPIKey()`, `verifyAPIKey()`)
- [ ] Create Vault secret structure (`/api_keys/{tenant_id}/{key_id}`)
- [ ] Implement Vault write/read operations for API keys
- [ ] Create database schema for API key metadata
- [ ] Implement API key authentication middleware
- [ ] Implement permission scope validation middleware
- [ ] Implement rate limiting with Redis (token bucket algorithm)
- [ ] Create audit logging for API key operations

### Phase 2: API Endpoints (Week 1-2)

- [ ] `POST /api/v1/platform/api-keys` - Create API key
- [ ] `GET /api/v1/platform/api-keys` - List API keys
- [ ] `GET /api/v1/platform/api-keys/{key_id}` - Get API key details
- [ ] `POST /api/v1/platform/api-keys/{key_id}/regenerate` - Regenerate API key
- [ ] `DELETE /api/v1/platform/api-keys/{key_id}` - Revoke API key
- [ ] Add API key authentication to all existing API endpoints
- [ ] Add rate limit headers to all API responses
- [ ] Implement usage tracking (requests, errors, last used)

### Phase 3: Frontend UI (Week 2)

- [ ] Create `/dashboard/settings/developers/api-keys` route
- [ ] Implement API key list table component
- [ ] Implement "Create API Key" modal
- [ ] Implement "API Key Created" success modal with code examples
- [ ] Implement "Regenerate API Key" confirmation modal
- [ ] Implement "Revoke API Key" confirmation modal
- [ ] Implement API key details modal with usage charts
- [ ] Add copy-to-clipboard functionality
- [ ] Add download as .env file functionality
- [ ] Implement usage charts (requests per day, error rate)


### Phase 4: Testing & Documentation (Week 2)

- [ ] Unit tests for API key generation and hashing
- [ ] Unit tests for permission scope validation
- [ ] Unit tests for rate limiting logic
- [ ] Integration tests for API key CRUD operations
- [ ] Integration tests for API key authentication
- [ ] Load tests for rate limiting under high traffic
- [ ] Security tests for API key storage and transmission
- [ ] Create API documentation with code examples
- [ ] Create security best practices guide
- [ ] Create troubleshooting guide

### Phase 5: Monitoring & Alerting (Week 2)

- [ ] Set up monitoring for API key usage
- [ ] Set up alerts for unusual activity (spike in errors, rate limit violations)
- [ ] Set up alerts for authentication failures
- [ ] Create dashboard for API key metrics
- [ ] Implement automated key rotation reminders (90-day email)

---

## Compliance & Certifications

### SOC 2 Type II

**Vault Integration Supports:**
- **Security (CC6.1)** - API keys hashed with bcrypt, stored in Vault
- **Security (CC6.6)** - Rate limiting prevents abuse
- **Security (CC6.7)** - Audit logging tracks all API key operations
- **Confidentiality (CC7.2)** - API keys transmitted over HTTPS only

### ISO 27001

**Vault Integration Supports:**
- **A.9.4.2 - Secure log-on procedures** - API key authentication
- **A.9.4.3 - Password management system** - bcrypt hashing, Vault storage
- **A.12.4.1 - Event logging** - Comprehensive audit trail
- **A.14.2.5 - Secure system engineering principles** - Least privilege, rate limiting

### GDPR

**Vault Integration Supports:**
- **Article 32 - Security of Processing** - Encryption (HTTPS), access control (scopes)
- **Article 25 - Data Protection by Design** - Secure by default (HTTPS, hashing, rate limiting)


---

## Roadmap

### MVP (Current)

**Status:** PLANNED - P0 Critical

**Features:**
- ✅ API key generation with bcrypt hashing
- ✅ Vault storage for API keys
- ✅ Permission scopes (send_email, read_analytics, manage_contacts)
- ✅ Tier-based rate limiting (60/300/1000 req/min)
- ✅ Frontend UI for key management
- ✅ Usage tracking (requests, errors, last used)
- ✅ Audit logging
- ✅ API documentation with code examples

**Timeline:** 2 weeks

**Priority:** P0 - Critical (blocks all programmatic integrations)

### Post-MVP (Q1 2026)

**Features:**
- IP whitelisting (restrict API key usage to specific IPs)
- Webhook notifications for API key events (created, revoked, rate limit exceeded)
- Advanced usage analytics (geographic distribution, endpoint popularity)
- API key expiration dates (auto-revoke after X days)
- Team-level API keys (shared across team members)
- API key templates (pre-configured permission sets)

### Future (Q2 2026+)

**Features:**
- OAuth 2.0 support (alternative to API keys)
- API key rotation policies (auto-rotate every 90 days)
- API key usage quotas (max requests per month)
- API key cost tracking (charge per API request)
- API key analytics dashboard (real-time monitoring)
- API key security scanning (detect compromised keys)


---

## Related Documentation

### Route Specifications

- **[API Key Management Routes](/docs/design/routes/api-key-management)** - Complete UI route specifications
- **[API Access Routes](/docs/design/routes/api-access)** - API key management interface
- **[Settings Routes](/docs/design/routes/settings)** - General settings navigation

### Feature Documentation

- **[API Access](/docs/features/integrations/api-access)** - General API access overview
- **[Webhook System](/docs/features/integrations/webhook-system)** - Event notifications
- **[Vault SSH Management](/docs/features/infrastructure/vault-ssh-management)** - VPS SSH key management
- **[Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp-credentials)** - SMTP credentials storage

### API Documentation

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Platform-level API endpoints
- **[Tenant API](/docs/implementation-technical/api/tenant-api)** - Tenant-level API endpoints
- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

### Architecture & Security

- **[Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)** - Comprehensive Vault architecture
- **[Enterprise Security](/docs/compliance-security/enterprise/overview)** - Enterprise security features
- **[Security Monitoring](/docs/operations/security-monitoring)** - Security monitoring and alerting

### Planning & Review

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations.md)** - Integration completeness review
- **[Feature Completeness Review - Requirements](/.kiro/specs/feature-completeness-review/requirements.md)** - Requirements document
- **[Feature Completeness Review - Design](/.kiro/specs/feature-completeness-review/design.md)** - Design document

### Implementation Tasks

- **[Task 11.3 - Vault Integration Architecture](/.kiro/specs/feature-completeness-review/tasks.md#113-document-vault-integration-architecture)** - Architecture documentation
- **[Task 11.6 - Tenant API Key System](/.kiro/specs/feature-completeness-review/tasks.md#116-implement-tenant-api-key-system-with-vault)** - API key system implementation
- **[Epic 5: Infrastructure Management](/tasks/epic-5-infrastructure-management/)** - Infrastructure tasks

### External References

- **[HashiCorp Vault Documentation](https://www.vaultproject.io/docs)** - Official Vault docs
- **[bcrypt Documentation](https://github.com/kelektiv/node.bcrypt.js)** - Password hashing library
- **[Token Bucket Algorithm](https://en.wikipedia.org/wiki/Token_bucket)** - Rate limiting algorithm

---

**Last Updated:** November 26, 2025  
**Document Version:** 1.0  
**Status:** PLANNED  
**Priority:** P0 - Critical  
**Next Review:** December 26, 2025

*This feature documentation provides comprehensive guidance for implementing the Tenant API Key System with Vault integration. All implementation must reference the [Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md) for secret structure, access policies, and security requirements.*

