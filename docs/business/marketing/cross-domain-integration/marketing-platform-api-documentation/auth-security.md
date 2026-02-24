---
title: "Marketing Platform API - Authentication & Security"
description: "Security protocols, authentication headers, and best practices for secure API integration."
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Marketing Platform API - Authentication & Security

## Authentication and Security

### API Authentication

All requests to the Marketing Platform API require a valid API key or Bearer token.

#### HTTP Headers

Include the following headers with every request:

```http
Authorization: Bearer {your_api_token}
Content-Type: application/json
X-API-Version: v1
X-Request-ID: {uuid}
User-Agent: {integration_name}/{version}
```

### Security Best Practices

- **Token Rotation:** Rotate API tokens every 30-90 days.
- **Scope Limitation:** Use scoped tokens with minimum required permissions.
- **Encryption:** Use TLS 1.2+ for all API requests.
- **Audit Logging:** Logs all outgoing requests and incoming responses for security auditing.
