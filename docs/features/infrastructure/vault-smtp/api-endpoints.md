---
title: "API Endpoints"
description: "API documentation for Vault SMTP credential operations"
level: "3"
keywords: "API, endpoints, REST API, integration"
---

# API Endpoints

## API Endpoints

### Platform Admin API

**Base URL:** `/api/v1/platform-admin`

#### Get SMTP Credentials

```http
GET /tenants/{tenant_id}/smtp-credentials
Authorization: Bearer {admin_token}
X-Reauth-Token: {reauth_token}

```

**Response:**

```json
{
  "username": "admin@example.com",
  "password": "encrypted_password_base64",
  "webmail_url": "https://mail.example.com",
  "created_at": "2025-01-15T10:00:00Z",
  "last_rotated": "2025-07-15T10:00:00Z",
  "next_rotation": "2026-01-15T10:00:00Z",
  "expires_at": "2025-11-26T10:15:00Z"
}

```

#### Rotate SMTP Credentials

```http
POST /tenants/{tenant_id}/smtp-credentials/rotate
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "reason": "Manual rotation for security audit"
}

```

**Response:**

```json
{
  "success": true,
  "rotated_at": "2025-11-26T10:00:00Z",
  "next_rotation": "2026-05-26T10:00:00Z"
}

```

#### Emergency Reset SMTP Credentials

```http
POST /tenants/{tenant_id}/smtp-credentials/emergency-reset
Authorization: Bearer {admin_token}
Content-Type: application/json

{
  "incident_id": "INC-2025-001",
  "reason": "Suspected credential compromise"
}

```

**Response:**

```json
{
  "success": true,
  "username": "admin@example.com",
  "password": "new_password_base64",
  "webmail_url": "https://mail.example.com",
  "expires_at": "2025-11-26T10:15:00Z",
  "incident_id": "INC-2025-001"
}

```

#### Get Audit Trail

```http
GET /tenants/{tenant_id}/smtp-credentials/audit
Authorization: Bearer {admin_token}

```

**Response:**

```json
{
  "events": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "event": "smtp_credentials_accessed",
      "user_id": "admin-123",
      "timestamp": "2025-11-26T10:00:00Z",
      "ip_address": "192.168.1.100",
      "severity": "info"
    },
    {
      "id": "660e8400-e29b-41d4-a716-446655440001",
      "event": "smtp_credentials_rotated",
      "user_id": "system",
      "timestamp": "2025-11-20T02:00:00Z",
      "severity": "info",
      "details": {
        "rotation_type": "automated"
      }
    }
  ],
  "total": 2,
  "page": 1,
  "per_page": 50
}

```

