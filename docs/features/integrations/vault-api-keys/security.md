---
title: "Security Considerations"
description: "Security best practices for API key management"
level: "3"
keywords: "security, best practices, threat model"
---

# Security Considerations

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

Logged events:

- API key creation (who, when, permissions)

- API key regeneration (who, when)

- API key revocation (who, when)

- API key authentication attempts (success, failure)

- API requests (endpoint, status, response time)

Audit log retention: 90 days (configurable)

---
