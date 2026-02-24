---
title: "Session & Token Security"
description: "JWT implementation, session tracking, and security protocols for user access."
last_modified_date: "2026-02-24"
level: "2"
persona: "Security Team / Developers"
---

# Session & Token Security

PenguinMails leverages industry-standard JWT protocols combined with server-side session tracking for maximum security.

## 1. JWT Tokens

Authentication uses JWT (JSON Web Tokens).

**Token Types:**

- **Access Token**: Short-lived (1 hour), used for API requests.
- **Refresh Token**: Long-lived (30 days), stored in an `HttpOnly`, `Secure`, `SameSite=Strict` cookie.

**Token Refresh Flow:**

```javascript
POST /api/v1/auth/refresh
{
  "refresh_token": "eyJhbGciOiJI..."
}

Response:
{
  "access_token": "eyJhbGciOiJI...",
  "expires_in": 3600
}
```

## 2. Session Controls

Advanced features to protect user accounts:

1. **Automatic Logout**: Invalidation after 30 minutes of inactivity.
2. **Refresh Rotation**: New refresh token issued on each refresh attempt to prevent replay attacks.
3. **Revocation**: Tokens can be revoked server-side to immediately kill active sessions.
4. **IP Tracking**: Logging IP addresses for security behavior analysis.

## 3. Session Management API

Administrators and users can monitor active sessions.

**List Active Sessions:**
`GET /api/v1/auth/sessions`

**Revoke Session:**
`DELETE /api/v1/auth/sessions/{session_id}`

## 4. Resource Protection

All sensitive operations require a valid JWT with appropriate RBAC claims (`owner`, `admin`, `member`) as defined in [User Management Hub](/docs/features/authentication/user-management).
