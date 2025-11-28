---
title: "Infrastructure SSH Access Routes"
description: "Route specifications for tenant SSH credential management and VPS access"
last_modified_date: "2025-11-26"
level: "3"
persona: "Developers"
status: "BACKLOG"
priority: "HIGH"
roadmap_milestone: "Q1_2026"
---


# Infrastructure SSH Access Routes

## Overview

This document specifies the frontend routes for tenant SSH credential management, enabling tenants to securely access their provisioned VPS infrastructure through Vault-managed SSH keys.

## Route Specifications

### Tenant SSH Access Settings

**Route:** `/dashboard/settings/infrastructure/ssh-access`

**Access Level:** Tenant Owner, Tenant Admin

**Purpose:** Display tenant SSH credentials for VPS access, enable SSH key download, and provide connection instructions.

**UI Components:**

1. **SSH Credentials Card**

   - VPS IP address

   - SSH username (tenant-specific)

   - SSH port (default: 22)

   - Key fingerprint (SHA256)

   - Last rotated timestamp

   - Next rotation date (90 days from last rotation)

2. **Download Private Key Section**

   - "Download Private Key" button

   - One-time download warning message

   - Security notice: "Store this key securely. It will not be shown again."

   - Download triggers audit log entry

3. **Connection Instructions**

   - Code block with SSH command:

     ```bash
     ssh -i /path/to/private-key.pem tenant-{tenant_id}@{vps_ip}
     ```

   - Link to detailed SSH setup guide

   - Troubleshooting tips

4. **Key Rotation Section**

   - "Rotate SSH Key" button (manual trigger)

   - Rotation confirmation modal

   - Grace period notice: "Old key remains valid for 24 hours"

   - Rotation history table (last 5 rotations)

5. **Revoke Access Section**

   - "Revoke SSH Access" button

   - Revocation confirmation modal

   - Warning: "This will immediately revoke SSH access. You can regenerate a new key."

**API Endpoints Used:**

- `GET /api/v1/tenant/infrastructure/ssh-credentials` - Retrieve SSH credentials

- `POST /api/v1/tenant/infrastructure/ssh-credentials/download` - Download private key (one-time)

- `POST /api/v1/tenant/infrastructure/ssh-credentials/rotate` - Trigger manual rotation

- `POST /api/v1/tenant/infrastructure/ssh-credentials/revoke` - Revoke SSH access

**State Management:**

```typescript
interface SSHCredentials {
  vpsIp: string;
  sshUsername: string;
  sshPort: number;
  keyFingerprint: string;
  lastRotated: string; // ISO 8601
  nextRotation: string; // ISO 8601
  rotationHistory: RotationEvent[];
}

interface RotationEvent {
  timestamp: string; // ISO 8601
  triggeredBy: 'automated' | 'manual';
  status: 'success' | 'failed';
}


```

**Security Considerations:**

- Private key download is one-time only

- Download triggers audit log entry

- Key rotation has 24-hour grace period

- Revocation is immediate (no grace period)

- All actions require re-authentication

### Admin Secrets Management Panel

**Route:** `/admin/secrets`

**Access Level:** PenguinMails Admin only

**Purpose:** Centralized secrets management for all tenants, Vault health monitoring, and audit log review.

**UI Components:**

1. **Vault Health Dashboard**

   - Vault seal status (sealed/unsealed)

   - Active node indicator

   - Storage backend status

   - Last backup timestamp

   - Backup health status

2. **Tenant Secrets Overview**

   - Searchable table of all tenants

   - Columns: Tenant ID, Tenant Name, VPS IP, SSH Key Status, SMTP Status, API Keys Count

   - Filter by secret type (SSH, SMTP, API Keys, DKIM)

   - Sort by last rotation date

3. **Secret Details View**

   - Click tenant row to expand details

   - SSH Keys: Admin key status, Tenant key status, Last rotation

   - SMTP Credentials: Admin username, Last rotation, "View Credentials" button (requires re-authentication)

     - See [SMTP Credentials Vault Storage](../../features/infrastructure/vault-smtp-credentials.md) for detailed credential viewing workflow

   - API Keys: Count, Last created, Rate limit tier

   - DKIM Keys: Domain count, Selector count

4. **Rotation Management**

   - "Rotate All SSH Keys" button (bulk operation)

   - "Rotate All SMTP Credentials" button

   - Rotation schedule configuration

   - Grace period settings

5. **Audit Log Viewer**

   - Real-time audit log stream

   - Filter by: Tenant, Secret type, Action (read/write/delete), Date range

   - Export audit logs (CSV, JSON)

   - Suspicious activity alerts

**API Endpoints Used:**

- `GET /api/v1/admin/vault/health` - Vault health status

- `GET /api/v1/admin/secrets/tenants` - List all tenant secrets

- `GET /api/v1/admin/secrets/tenant/{tenant_id}` - Tenant secret details

- `POST /api/v1/admin/secrets/rotate-all` - Bulk rotation

- `GET /api/v1/admin/vault/audit-logs` - Retrieve audit logs

**State Management:**

```typescript
interface VaultHealth {
  sealed: boolean;
  activeNode: string;
  storageStatus: 'healthy' | 'degraded' | 'offline';
  lastBackup: string; // ISO 8601
  backupHealth: 'healthy' | 'warning' | 'critical';
}

interface TenantSecretsSummary {
  tenantId: string;
  tenantName: string;
  vpsIp: string;
  sshKeyStatus: 'active' | 'expired' | 'revoked';
  smtpStatus: 'active' | 'expired';
  apiKeysCount: number;
  dkimKeysCount: number;
}


```

**Security Considerations:**

- Admin-only access (role-based)

- All actions logged in audit trail

- Bulk operations require confirmation

- Audit logs are immutable

- Export requires admin approval

## Navigation

**Tenant Access:**

- Settings → Infrastructure → SSH Access

**Admin Access:**

- Admin Panel → Secrets Management

## Related Documentation

### Planning

- [Vault Integration Architecture](../../.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md) - Comprehensive Vault architecture

- [Infrastructure Management Feature](../../features/infrastructure/vault-ssh-management.md) - SSH key management feature

- [SMTP Credentials Vault Storage](../../features/infrastructure/vault-smtp-credentials.md) - SMTP credentials management feature

### Implementation

- [Task 11.4 - VPS SSH Key Management](../../.kiro/specs/feature-completeness-review/tasks.md#114-implement-vps-ssh-key-management-with-vault)

- [Task 11.5 - SMTP Credentials Vault Storage](../../.kiro/specs/feature-completeness-review/tasks.md#115-implement-smtp-credentials-vault-storage)

- [Epic 5: Infrastructure Management](../../tasks/epic-5-infrastructure-management/)

### Reference

- [Infrastructure Routes](/docs/design/routes/infrastructure) - Other infrastructure routes

- [Settings Routes](/docs/design/routes/settings) - General settings routes

- [Admin Routes](/docs/design/routes/admin) - Admin panel routes

---

**Last Updated:** November 26, 2025
**Route Status:** BACKLOG
**Priority:** HIGH (MVP dependency)
**Estimated Effort:** Medium (5-7 days)

*SSH access management is critical for tenant VPS access and infrastructure troubleshooting. Vault integration ensures secure credential storage and rotation.*
