---
title: "Email & Application Security"
description: "Email authentication (SPF/DKIM/DMARC), warm-up reputation security, and app-level protections like XSS/SQLi prevention."
last_modified_date: "2025-10-27"
level: "2"
persona: "Documentation Users"
---

# Email & Application Security

## Email Infrastructure Security

### Domain Authentication

We enforce strict email authentication via DNS records:

- **SPF**: Authorized relay inclusion.
- **DKIM**: 2048-bit RSA signatures for all outgoing mail.
- **DMARC**: Strict policy (p=quarantine) with RUA reporting.

### Warm-up Security

Automated warm-up algorithms protect sender reputation:

- **Volume Scaling**: Starts at 10 emails/day, scaling based on reputation score.
- **Bounce Control**: Automatic pausing if bounce rates exceed 10%.

## Application Layer Security

### Injection Prevention

- **Parameterized Queries**: All database interactions use placeholders to prevent SQL Injection.
- **Query Builder**: ORM-based queries provide inherent validation.

### XSS & Input Sanitization

- **Input Sanitization**: Removal of dangerous characters (`<`, `>`, `'`, `"`) from user inputs.
- **Output Encoding**: Context-aware escaping of HTML before rendering.

### Rate Limiting

- **API Protection**: Redis-based sliding window rate limiter.
- **Identification**: Limits per IP and User ID (e.g., 100 requests/hour for standard APIs).

```javascript
// Rate Limit Headers
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 99
```
