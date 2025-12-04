---
title: "Vault Management API"
description: "HashiCorp Vault secrets management, rotation, and audit endpoints"
last_modified_date: "2025-12-04"
level: "3"
persona: "Backend Developers"
---

# Vault Management API

**Parent API**: [Platform API](/docs/implementation-technical/api/platform-api)  
**URL Prefix**: `/api/v1/admin`

---

## Overview

The Vault Management API provides endpoints for monitoring HashiCorp Vault health, managing tenant secrets (SSH keys, SMTP credentials, API keys, DKIM keys), and accessing comprehensive audit logs.

---

## Vault Health Endpoints

### Get Vault Health

**Method**: `GET`  
**URL**: `/api/v1/admin/vault/health`  
**Purpose**: Monitor Vault seal status and health

**Response**:

```json
{
  "success": true,
  "data": {
    "seal_status": "unsealed",
    "active_node": "vault-node-1",
    "storage_backend": {
      "type": "postgresql",
      "status": "healthy"
    },
    "last_backup": "2025-12-04T06:00:00Z",
    "backup_health": "healthy"
  }
}
```

**Seal Status Values**:

- `unsealed`: Normal operation (vault accessible)
- `sealed`: Emergency locked state (requires manual unseal)

**Backup Health Values**:

- `healthy`: <24 hours since last backup
- `warning`: 24-48 hours since last backup
- `critical`: >48 hours since last backup

---

### Get Backup Status

**Method**: `GET`  
**URL**: `/api/v1/admin/vault/backup-status`  
**Purpose**: View backup history and health

**Response**:

```json
{
  "success": true,
  "data": {
    "last_backup": {
      "timestamp": "2025-12-04T06:00:00Z",
      "size_gb": 2.5,
      "status": "completed",
      "s3_path": "s3://penguinmails-vault-backups/2025-12-04.snapshot"
    },
    "backup_history": [
      {
        "timestamp": "2025-12-03T06:00:00Z",
        "status": "completed"
      }
    ]
  }
}
```

---

### Force Vault Backup

**Method**: `POST`  
**URL**: `/api/v1/admin/vault/backup`  
**Purpose**: Manually trigger Vault snapshot

**Request**:

```json
{
  "reason": "Pre-maintenance backup"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "backup_id": "backup_abc123",
    "status": "in_progress",
    "started_at": "2025-12-04T12:00:00Z"
  }
}
```

---

## Tenant Secrets Endpoints

### List All Tenant Secrets

**Method**: `GET`  
**URL**: `/api/v1/admin/secrets/tenants`  
**Purpose**: Overview of secrets across all tenants

**Query Parameters**:

- `search` (optional): Search by tenant ID, name, or VPS IP
- `secret_type` (optional): `ssh` | `smtp` | `api_keys` | `dkim`
- `status` (optional): `active` | `expired` | `revoked`
- `rotation_due` (optional): `next_7_days` | `next_30_days` | `overdue`
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

**Response**:

```json
{
  "success": true,
  "data": {
    "tenants": [
      {
        "tenant_id": "tn_123",
        "tenant_name": "Acme Corp",
        "vps_ip": "192.168.1.100",
        "secrets": {
          "ssh_keys": {
            "status": "active",
            "last_rotated": "2025-10-15T10:00:00Z",
            "next_rotation": "2026-01-15T10:00:00Z"
          },
          "smtp": {
            "status": "active",
            "last_rotated": "2025-06-15T10:00:00Z",
            "next_rotation": "2025-12-15T10:00:00Z"
          },
          "api_keys_count": 3,
          "dkim_keys_count": 2
        }
      }
    ],
    "pagination": {
      "total": 156,
      "limit": 50,
      "offset": 0
    }
  }
}
```

---

### Get Tenant Secret Details

**Method**: `GET`  
**URL**: `/api/v1/admin/secrets/tenant/{tenant_id}`  
**Purpose**: Detailed secret information for a specific tenant

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "tenant_name": "Acme Corp",
    "vps_ip": "192.168.1.100",
    "ssh_keys": {
      "admin_key": {
        "status": "active",
        "fingerprint": "SHA256:abc123...",
        "last_rotated": "2025-10-15T10:00:00Z",
        "next_rotation": "2026-01-15T10:00:00Z"
      },
      "tenant_key": {
        "status": "active",
        "fingerprint": "SHA256:def456...",
        "last_downloaded": "2025-11-20T15:30:00Z"
      }
    },
    "smtp": {
      "username_masked": "admin@*****.com",
      "webmail_url": "https://mail.acmecorp.com",
      "last_rotated": "2025-06-15T10:00:00Z",
      "next_rotation": "2025-12-15T10:00:00Z",
      "rotation_status": "due_soon"
    },
    "api_keys": [
      {
        "key_id": "key_abc",
        "permissions": "read_write",
        "rate_limit": 1000,
        "created": "2025-01-15T10:00:00Z",
        "last_used": "2025-12-04T11:00:00Z",
        "request_count": 12345,
        "status": "active"
      }
    ],
    "dkim_keys": [
      {
        "domain": "acmecorp.com",
        "selector": "default",
        "last_rotated": "2025-01-15T10:00:00Z",
        "next_rotation": "2026-01-15T10:00:00Z",
        "status": "active"
      }
    ]
  }
}
```

---

### View SMTP Credentials

**Method**: `GET`  
**URL**: `/api/v1/admin/secrets/tenant/{tenant_id}/smtp-credentials`  
**Purpose**: Retrieve actual SMTP credentials (requires re-authentication)

**Headers**:

- `X-Reauth-Token`: Token from re-authentication flow

**Response**:

```json
{
  "success": true,
  "data": {
    "username": "admin@acmecorp.com",
    "password": "securepassword123",
    "webmail_url": "https://mail.acmecorp.com",
    "created_at": "2025-01-15T10:00:00Z",
    "last_rotated": "2025-06-15T10:00:00Z",
    "next_rotation": "2025-12-15T10:00:00Z",
    "expires_in_seconds": 900
  }
}
```

> [!IMPORTANT]
> This endpoint requires re-authentication via password + 2FA. The response is time-limited (15 minutes) and all access is logged.

---

### Rotate Tenant Secret

**Method**: `POST`  
**URL**: `/api/v1/admin/secrets/tenant/{tenant_id}/rotate/{secret_type}`  
**Purpose**: Manually rotate a specific secret

**Path Parameters**:

- `secret_type`: `ssh` | `smtp` | `dkim`

**Request**:

```json
{
  "reason": "Quarterly security review"
}
```

**Response**:

```json
{
  "success": true,
  "data": {
    "rotation_id": "rot_abc123",
    "secret_type": "ssh",
    "status": "in_progress",
    "grace_period_hours": 24,
    "old_key_expires": "2025-12-05T12:00:00Z"
  }
}
```

---

### Bulk Rotate Secrets

**Method**: `POST`  
**URL**: `/api/v1/admin/secrets/rotate-all`  
**Purpose**: Rotate all secrets of a specific type across tenants

**Request**:

```json
{
  "secret_type": "ssh",
  "filter": "overdue",
  "reason": "Automated quarterly rotation"
}
```

**Filter Values**:

- `all`: Rotate all secrets of this type
- `overdue`: Only rotate expired secrets
- `due_soon`: Rotate secrets due in next 7 days

**Response**:

```json
{
  "success": true,
  "data": {
    "bulk_rotation_id": "bulk_rot_xyz",
    "secret_type": "ssh",
    "tenant_count": 45,
    "status": "in_progress",
    "estimated_duration_minutes": 30
  }
}
```

---

## Audit Log Endpoints

### Get Vault Audit Logs

**Method**: `GET`  
**URL**: `/api/v1/admin/vault/audit-logs`  
**Purpose**: Retrieve comprehensive audit trail

**Query Parameters**:

- `tenant_id` (optional): Filter by specific tenant
- `secret_type` (optional): `ssh` | `smtp` | `api_keys` | `dkim`
- `action` (optional): `read` | `write` | `delete` | `rotate` | `download`
- `user` (optional): Filter by admin user ID
- `start_time`: ISO 8601 timestamp
- `end_time`: ISO 8601 timestamp
- `limit` (optional): Max results (default: 50, max: 100)
- `offset` (optional): Pagination offset

**Response**:

```json
{
  "success": true,
  "data": {
    "audit_logs": [
      {
        "id": "audit_123",
        "timestamp": "2025-12-04T12:15:00Z",
        "action": "read",
        "tenant_id": "tn_123",
        "tenant_name": "Acme Corp",
        "secret_type": "smtp",
        "user_id": "admin_xyz",
        "user_email": "admin@penguinmails.com",
        "ip_address": "192.168.1.1",
        "status": "success"
      }
    ],
    "pagination": {
      "total": 1234,
      "limit": 50,
      "offset": 0
    }
  }
}
```

---

### Export Audit Logs

**Method**: `GET`  
**URL**: `/api/v1/admin/vault/audit-logs/export`  
**Purpose**: Download audit logs for compliance

**Query Parameters**: Same as Get Audit Logs, plus:

- `format`: `csv` | `json`

**Response** (Async job):

```json
{
  "success": true,
  "data": {
    "export_id": "export_audit_abc",
    "status": "processing",
    "download_url": null
  }
}
```

---

## Error Handling

- `400 Bad Request`: Invalid parameters
- `401 Unauthorized`: Missing or invalid token
- `403 Forbidden`: User does not have Super Admin role
- `404 Not Found`: Tenant or secret not found
- `423 Locked`: Vault is sealed (emergency state)
- `429 Too Many Requests`: Rate limit exceeded

---

## Related Documentation

- [Vault Management Feature](/docs/features/admin/vault-management/) - Feature overview
- [Platform Admin Routes - Vault](/docs/design/routes/platform-admin#admin-secrets) - UI specification
- [Security Compliance](/docs/features/compliance/security-features) - Security best practices
- [Incident Response](/docs/operations/incident-management/runbooks) - Security incident procedures
