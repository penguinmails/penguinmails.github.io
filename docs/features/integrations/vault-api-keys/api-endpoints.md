---
title: "API Endpoints"
description: "API documentation for key management"
level: "3"
keywords: "API, endpoints, REST"
---

# API Endpoints

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

