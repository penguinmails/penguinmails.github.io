---
title: "Vault SSH Key Management"
description: "Secure SSH credential management for VPS infrastructure using HashiCorp Vault"
last_modified_date: "2025-11-26"
level: "2"
persona: "Technical Teams, Operations"
status: "BACKLOG"
priority: "HIGH"
roadmap_milestone: "Q1_2026"
keywords: ["vault", "ssh", "security", "infrastructure", "credentials", "rotation"]
---


# Vault SSH Key Management

## Overview

Vault SSH Key Management provides secure, centralized storage and automated rotation of SSH credentials for tenant VPS infrastructure. By storing SSH keys in HashiCorp Vault instead of ENV files on VPS instances, PenguinMails enables rapid disaster recovery and eliminates credential exposure risks from VPS compromise.

## Problem Statement

Traditional SSH key management approaches create security vulnerabilities:

- **ENV File Exposure**: SSH keys stored in ENV files on VPS are exposed if VPS is compromised

- **Manual Rotation**: Rotating SSH keys requires manual updates across multiple VPS instances

- **No Audit Trail**: Difficult to track who accessed SSH keys and when

- **Disaster Recovery**: VPS compromise requires manual credential recovery and rotation

- **Scattered Management**: SSH keys managed individually per VPS instead of centrally

## Solution

Vault SSH Key Management centralizes SSH credential storage and automates rotation:

1. **Centralized Storage**: All SSH keys stored in Vault, not on VPS

2. **Automated Rotation**: SSH keys automatically rotated every 90 days with 24-hour grace period

3. **Audit Logging**: All SSH key access logged with timestamp, user, and action

4. **Rapid Recovery**: VPS compromise doesn't expose secrets; abandon VPS and provision new one

5. **Tenant Access**: Tenants can download their SSH private key for VPS access

## Key Features

### 1. Dual SSH Key System

**Admin SSH Keys (PenguinMails Access):**

- Generated during VPS provisioning

- Stored in Vault at `/vps/{tenant_id}/admin_ssh`

- Used by PenguinMails for infrastructure management

- Never exposed to tenants

- Rotated every 90 days automatically

**Tenant SSH Keys (Customer Access):**

- Generated during VPS provisioning

- Stored in Vault at `/vps/{tenant_id}/tenant_ssh`

- Downloadable by tenant owner/admin

- Used for programmatic VPS access

- Rotated every 90 days automatically

### 2. Secure Key Download

**One-Time Download:**

- Tenant can download private key once from UI

- Download triggers audit log entry

- Warning message: "Store this key securely. It will not be shown again."

- Key never displayed in UI after initial download

**Download Process:**

```typescript
// User clicks "Download Private Key"
POST /api/v1/tenant/infrastructure/ssh-credentials/download

// Backend retrieves key from Vault
const privateKey = await vault.read(`vps/${tenantId}/tenant_ssh/private_key`);

// Log download event
await auditLog.create({
  action: 'ssh_key_download',
  tenantId,
  userId,
  timestamp: new Date(),
  ipAddress: req.ip
});

// Return key as downloadable file
res.download('tenant-ssh-key.pem', privateKey);


```

### 3. Automated Key Rotation

**Rotation Schedule:**

- SSH keys rotated every 90 days

- Cron job checks rotation policy daily

- Manual rotation trigger available in UI

**Rotation Workflow:**

```text

Cron job checks last_rotated timestamp
  ↓
If rotation due (current_date - last_rotated >= 90 days):
  ↓
Generate new RSA 4096-bit key pair
  ↓
Store new key in Vault with incremented version
  ↓
Add new public key to VPS authorized_keys
  ↓
Keep old key active for 24-hour grace period
  ↓
Remove old key from authorized_keys after grace period
  ↓
Send notification to tenant (email)
  ↓
Log rotation event in audit trail


```

**Grace Period:**

- 24-hour grace period prevents service disruption

- Both old and new keys valid during grace period

- Tenants notified to update their SSH clients

### 4. Key Revocation and Regeneration

**Revoke SSH Access:**

- Tenant can revoke SSH access immediately

- Removes public key from VPS authorized_keys

- Marks key as revoked in Vault

- No grace period (immediate revocation)

**Regenerate SSH Key:**

- Tenant can regenerate new SSH key after revocation

- Generates new RSA 4096-bit key pair

- Stores new key in Vault

- Adds new public key to VPS authorized_keys

- Tenant must download new private key

### 5. Connection Instructions

**UI Display:**

```bash


# SSH Connection Command

ssh -i /path/to/private-key.pem tenant-{tenant_id}@{vps_ip}


# Example

ssh -i ~/Downloads/tenant-ssh-key.pem tenant-550e8400@192.168.1.100


```

**Troubleshooting Tips:**

- Ensure private key has correct permissions: `chmod 600 private-key.pem`

- Verify VPS IP address is correct

- Check firewall allows SSH connections (port 22)

- Confirm SSH key hasn't been rotated (check UI for latest key)

### 6. Audit Logging

**Logged Events:**

- SSH key download (who, when, IP address)

- SSH key rotation (automated or manual)

- SSH key revocation

- SSH key regeneration

- Failed SSH authentication attempts (from VPS logs)

**Audit Log Format:**

```json
{
  "timestamp": "2025-11-26T10:30:00.000Z",
  "action": "ssh_key_download",
  "tenantId": "550e8400-e29b-41d4-a716-446655440000",
  "userId": "user-123",
  "ipAddress": "203.0.113.42",
  "userAgent": "Mozilla/5.0...",
  "status": "success"
}


```

## User Workflows

### Tenant: Download SSH Key

1. Navigate to Settings → Infrastructure → SSH Access

2. View SSH credentials (VPS IP, username, port)

3. Click "Download Private Key" button

4. Read security warning

5. Confirm download

6. Save private key file securely

7. Follow connection instructions to connect to VPS

### Tenant: Rotate SSH Key Manually

1. Navigate to Settings → Infrastructure → SSH Access

2. Click "Rotate SSH Key" button

3. Read grace period notice (24 hours)

4. Confirm rotation

5. Wait for rotation to complete (30 seconds)

6. Download new private key

7. Update SSH clients with new key

8. Old key remains valid for 24 hours

### Tenant: Revoke and Regenerate SSH Key

1. Navigate to Settings → Infrastructure → SSH Access

2. Click "Revoke SSH Access" button

3. Confirm revocation (immediate, no grace period)

4. SSH access revoked

5. Click "Regenerate SSH Key" button

6. New key generated and stored in Vault

7. Download new private key

8. Connect to VPS with new key

### Admin: Monitor SSH Key Health

1. Navigate to Admin Panel → Secrets Management

2. View Vault health dashboard

3. Search for tenant by ID or name

4. View SSH key status (active, expired, revoked)

5. Check last rotation date

6. Review audit logs for suspicious activity

7. Trigger bulk rotation if needed

## Technical Architecture

### Vault Secret Structure

```text

vault/vps/{tenant_id}/
├── admin_ssh/
│   ├── private_key       # RSA 4096-bit private key
│   ├── public_key        # RSA 4096-bit public key
│   ├── created_at        # ISO 8601 timestamp
│   ├── last_rotated      # ISO 8601 timestamp
│   └── rotation_policy   # "90_days"
└── tenant_ssh/
    ├── private_key       # RSA 4096-bit private key
    ├── public_key        # RSA 4096-bit public key
    ├── created_at        # ISO 8601 timestamp
    ├── last_rotated      # ISO 8601 timestamp
    └── rotation_policy   # "90_days"


```

### API Endpoints

**Tenant Endpoints:**

```typescript
// Retrieve SSH credentials (public info only)
GET /api/v1/tenant/infrastructure/ssh-credentials
Response: {
  vpsIp: string;
  sshUsername: string;
  sshPort: number;
  keyFingerprint: string;
  lastRotated: string;
  nextRotation: string;
}

// Download private key (one-time)
POST /api/v1/tenant/infrastructure/ssh-credentials/download
Response: File download (tenant-ssh-key.pem)

// Rotate SSH key manually
POST /api/v1/tenant/infrastructure/ssh-credentials/rotate
Response: {
  status: 'success';
  message: 'SSH key rotated. Old key valid for 24 hours.';
  newKeyFingerprint: string;
}

// Revoke SSH access
POST /api/v1/tenant/infrastructure/ssh-credentials/revoke
Response: {
  status: 'success';
  message: 'SSH access revoked immediately.';
}

// Regenerate SSH key
POST /api/v1/tenant/infrastructure/ssh-credentials/regenerate
Response: {
  status: 'success';
  message: 'New SSH key generated. Download private key.';
  newKeyFingerprint: string;
}


```

**Admin Endpoints:**

```typescript
// Get Vault health status
GET /api/v1/admin/vault/health
Response: {
  sealed: boolean;
  activeNode: string;
  storageStatus: 'healthy' | 'degraded' | 'offline';
  lastBackup: string;
}

// List all tenant secrets
GET /api/v1/admin/secrets/tenants
Response: TenantSecretsSummary[]

// Get tenant secret details
GET /api/v1/admin/secrets/tenant/{tenant_id}
Response: {
  sshKeys: { admin: KeyStatus; tenant: KeyStatus };
  smtpCredentials: CredentialStatus;
  apiKeys: ApiKeyStatus[];
}

// Trigger bulk SSH key rotation
POST /api/v1/admin/secrets/rotate-all
Body: { secretType: 'ssh' | 'smtp' | 'dkim' }
Response: {
  status: 'success';
  rotatedCount: number;
  failedCount: number;
}


```

### Access Control

**Vault Policies:**

```hcl


# Tenant read-only access to own SSH keys

path "vps/{{identity.entity.metadata.tenant_id}}/tenant_ssh/*" {
  capabilities = ["read"]
}


# Admin full access to all SSH keys

path "vps/*/admin_ssh/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "vps/*/tenant_ssh/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}


# Automation service update access for rotation

path "vps/*/admin_ssh/*" {
  capabilities = ["read", "update"]
}

path "vps/*/tenant_ssh/*" {
  capabilities = ["read", "update"]
}


```

## Security Considerations

### Threat Mitigation

1. **VPS Compromise**: SSH keys not stored on VPS; can abandon and reprovision

2. **Credential Theft**: Private key download logged; one-time download only

3. **Unauthorized Access**: Vault access control enforces tenant isolation

4. **Key Exposure**: Automated rotation limits exposure window to 90 days

5. **Insider Threats**: Audit trail tracks all SSH key access

### Best Practices

1. **Store Private Keys Securely**: Use password manager or encrypted storage

2. **Rotate Keys Regularly**: Don't disable automated rotation

3. **Monitor Audit Logs**: Review SSH key access logs monthly

4. **Revoke Compromised Keys**: Immediately revoke if key is exposed

5. **Use Strong Passphrases**: Encrypt private key with passphrase (optional)

## Compliance

### SOC 2 Type II

- **Security**: Access control, encryption, audit logging

- **Availability**: High availability Vault cluster, disaster recovery

- **Confidentiality**: Encryption at rest and in transit

### ISO 27001

- **A.9 Access Control**: Role-based access control

- **A.10 Cryptography**: RSA 4096-bit encryption

- **A.12 Operations Security**: Automated rotation, backup

### GDPR

- **Article 32 - Security of Processing**: Encryption, access control

- **Article 33 - Breach Notification**: Audit trail, monitoring

## Roadmap

### MVP (Q1 2026)

- [ ] Vault integration for SSH key storage

- [ ] Dual SSH key system (admin + tenant)

- [ ] Tenant SSH key download UI

- [ ] Automated 90-day rotation

- [ ] Audit logging for all SSH key operations

- [ ] Connection instructions in UI

### Post-MVP (Q2 2026)

- [ ] SSH key passphrase encryption

- [ ] Multi-factor authentication for key download

- [ ] SSH session recording (audit trail)

- [ ] Custom rotation policies per tenant

- [ ] SSH key usage analytics

- [ ] Automated key revocation on suspicious activity

### Future (Q3 2026+)

- [ ] SSH certificate authority (short-lived certificates)

- [ ] Just-in-time SSH access (temporary keys)

- [ ] SSH bastion host integration

- [ ] Hardware security module (HSM) integration

- [ ] FIDO2/WebAuthn for SSH authentication

## Related Documentation

### Route Specifications

- **[Infrastructure SSH Access Routes](/docs/design/routes/infrastructure-ssh-access)** - Complete SSH UI routes

- **[Settings Routes](/docs/design/routes/settings)** - General settings navigation

- **[Admin Routes](/docs/design/routes/admin)** - Admin secrets management panel

### Feature Documentation

- **[Vault API Keys](/docs/features/integrations/vault-api-keys)** - Tenant API key system

- **[Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp-credentials)** - SMTP credentials storage

- **[Vault Disaster Recovery](/docs/features/infrastructure/vault-disaster-recovery)** - Backup and recovery

- **[Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)** - Infrastructure provisioning

- **[Hostwind Management](/docs/features/infrastructure/hostwind-management)** - VPS management

### API Documentation

- **[Platform API](/docs/implementation-technical/api/platform-api)** - Platform-level endpoints

- **[Hostwinds API](/docs/implementation-technical/api/hostwinds/overview)** - VPS provisioning API

- **[API Reference](/docs/implementation-technical/api/README)** - Complete API documentation

### Architecture & Security

- **[Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture)** - Comprehensive Vault architecture

- **[Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture)** - Tenant isolation

- **[Enterprise Security](/docs/compliance-security/enterprise/overview)** - Security features

- **[Security Monitoring](/docs/operations/security-monitoring)** - Monitoring and alerting

### Planning & Review

- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations)** - Integration completeness review

- **[Infrastructure Management Roadmap](/docs/roadmap/technical-roadmap)** - Infrastructure features roadmap

- **[Technical Roadmap](/docs/roadmap/technical-roadmap)** - Overall technical roadmap

### Implementation Tasks

- **[Task 11.4 - VPS SSH Key Management](/.kiro/specs/feature-completeness-review/tasks#114-implement-vps-ssh-key-management-with-vault)** - SSH key implementation

- **[Task 11.3 - Vault Integration Architecture](/.kiro/specs/feature-completeness-review/tasks#113-document-vault-integration-architecture)** - Architecture documentation

- **[Epic 5: Infrastructure Management](/tasks/epic-5-infrastructure-management/)** - Infrastructure tasks

### External References

- **[HashiCorp Vault Documentation](https://www.vaultproject.io/docs)** - Official Vault docs

- **[SSH Best Practices](https://www.ssh.com/academy/ssh/best-practices)** - SSH security guide

- **[OpenSSH Documentation](https://www.openssh.com/manual.html)** - SSH protocol reference

---

**Last Updated:** November 26, 2025
**Feature Status:** BACKLOG
**Priority:** HIGH (MVP dependency)
**Estimated Effort:** Large (10-15 days)

*Vault SSH Key Management is a foundational security feature that enables secure VPS access and rapid disaster recovery. This feature must be implemented before infrastructure provisioning can be considered production-ready.*

