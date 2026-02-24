---
title: "Marketing Platform API - Governance & Monitoring"
description: "Rate limits, error codes, sandbox environments, and monitoring protocols."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Marketing Platform API - Governance & Monitoring

## Rate Limiting and Quotas

### Rate Limit Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 995
X-RateLimit-Reset: 1705324800
X-RateLimit-Window: 3600
```

### Rate Limit Tiers

| Tier | Requests/Hour | Burst Limit |
|------|---------------|-------------|
| Free | 1,000 | 10 |
| Professional | 10,000 | 50 |
| Enterprise | 100,000 | Unlimited |

## Error Handling

### Error Response Format

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": {
      "field": "company_size",
      "expected": "Valid company size range (1-100000)",
      "received": "150-abc"
    },
    "request_id": "req_789xyz",
    "timestamp": "2025-01-15T10:30:00Z"
  }
}
```

### Common Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `AUTHENTICATION_ERROR` | 401 | Invalid or missing authentication |
| `AUTHORIZATION_ERROR` | 403 | Insufficient permissions |
| `VALIDATION_ERROR` | 400 | Invalid request data |
| `RATE_LIMIT_EXCEEDED` | 429 | Too many requests |

## Testing and Sandbox

### Sandbox Environment

**Base URL:** `https://api-sandbox.marketingplatform.com`

**Sandbox Features:**

- Test data and simulated responses
- No actual email delivery
- Lower rate limits for testing

## Monitoring and Support

### API Monitoring

```json
{
  "alert_conditions": {
    "response_time_p95": ">500ms",
    "error_rate": ">5%",
    "rate_limit_usage": ">90%"
  },
  "notification_channels": [
    "email: api-team@company.com",
    "slack: #api-alerts"
  ]
}
```

**Support Status:** [https://status.marketingplatform.com](https://status.marketingplatform.com)
