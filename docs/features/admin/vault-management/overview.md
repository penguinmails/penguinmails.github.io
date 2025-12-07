---
title: "Vault Secrets Management"
description: "Centralized secrets management for tenant SSH keys, SMTP credentials, API keys, and DKIM keys"
last_modified_date: "2025-12-04"
level: "2"
persona: "Platform Administrators, Security Team"
status: "ACTIVE"
category: "Admin"
---

# Vault Secrets Management

**Secure, centralized management of tenant secrets with automated rotation and comprehensive audit logging.**

---

## Overview

The Vault Secrets Management feature provides PenguinMails platform administrators with secure, centralized access to all tenant secrets including SSH keys, SMTP credentials, API keys, and DKIM keys. Monitor Vault health, manage secret rotation schedules, and maintain comprehensive audit trails for security compliance.

### Key Capabilities

- **Vault Health Monitoring**: Real-time Vault status and backup health
- **Tenant Secrets Overview**: Centralized view of all secrets across tenants
- **Automated Rotation**: Scheduled secret rotation with configurable grace periods
- **Secure Credential Access**: Time-limited, re-authenticated access to sensitive credentials
- **Comprehensive Auditing**: Complete audit trail of all secret operations

---

## User Stories

### Platform Admin (Vault Health)

> *"As a platform admin, I need to verify Vault is healthy and backups are current before the weekend."*
>
> **Workflow**:
>
> 1. Navigate to `/admin/secrets`
> 2. Check Vault Seal Status (should be "Unsealed" - Green)
> 3. Verify Last Backup timestamp (<24 hours)
> 4. Review Backup Health (should be "Healthy")
> 5. If all green, Vault is ready for weekend

### Security Engineer (Credential Rotation)

> *"I need to rotate all SSH keys that are overdue for rotation as part of our quarterly security review."*
>
> **Workflow**:
>
> 1. Navigate to Vault secrets overview
> 2. Filter by "Rotation Due": Overdue
> 3. Review list of tenants with expired keys
> 4. Click "Rotate Overdue Secrets" button
> 5. Confirm bulk rotation
> 6. Monitor rotation progress
> 7. Verify all secrets rotated successfully

### Support Engineer (Emergency Access)

> *"A tenant's automated email backup is failing. I need to access their SMTP credentials to test the connection manually."*
>
> **Workflow**:
>
> 1. Search for tenant by name
> 2. View tenant secret details
> 3. Navigate to SMTP Credentials section
> 4. Click "View Credentials" button
> 5. Re-authenticate with password + 2FA
> 6. View and copy SMTP credentials
> 7. Test connection manually
> 8. Credentials auto-hide after 15 minutes

---

## Feature Components

### Vault Health Dashboard

**Status Cards** (Traffic light system):

- **Vault Seal Status**: Unsealed (🟢) / Sealed (🔴)
- **Active Node**: Displays primary Vault node
- **Storage Backend**: PostgreSQL health status
- **Last Backup**: Timestamp with color coding
  - 🟢 Green: <24 hours ago
  - 🟡 Yellow: 24-48 hours ago
  - 🔴 Red: >48 hours ago
- **Backup Health**: Healthy / Warning / Critical

**Quick Actions**:

- **"Force Backup Now"**: Manually trigger Vault snapshot
- **"View Backup History"**: Last 30 backups with restore points

### Tenant Secrets Overview

**Search & Filter**:

- **Search Bar**: By tenant ID, tenant name, or VPS IP
- **Filters**:
  - Secret Type (All, SSH Keys, SMTP Credentials, API Keys, DKIM Keys)
  - Status (Active, Expired, Revoked)
  - Rotation Due (Next 7 days, Next 30 days, Overdue)

**Tenants Table**:

- Columns: Tenant ID, Tenant Name, VPS IP, SSH Status, SMTP Status, API Keys Count, DKIM Keys Count, Last Rotation, Actions
- **Color Coding**:
  - 🔴 Red: Expired secrets
  - 🟡 Yellow: Rotation due soon (<7 days)
  - 🟢 Green: Healthy

### Secret Details View

Expandable row showing detailed secret information for each tenant.

#### SSH Keys Section

- **Admin SSH Key**:
  - Status (Active/Expired)
  - Last Rotated timestamp
  - Next Rotation date
  - Key Fingerprint
- **Tenant SSH Key**:
  - Status, rotation info
  - Last Downloaded timestamp
- **Actions**: "Rotate Now", "View Rotation History"

#### SMTP Credentials Section

- **Admin Username**: Masked (e.g., `admin@*****.com`)
- **Webmail URL**: Full URL (e.g., `https://mail.example.com`)
- **Last Rotated**: Timestamp
- **Next Rotation**: 180 days from last rotation
- **Rotation Status**: Color-coded (🟢/🟡/🔴)
- **Actions**:
  - **"View Credentials"**: Opens secure time-limited modal (see below)
  - **"Rotate Now"**: Manual rotation with reason
  - **"Emergency Reset"**: For security incidents (requires incident ID)
  - **"View Audit Trail"**: All credential access events

#### API Keys Section

- **Table**: Key ID, Permissions, Rate Limit, Created, Last Used, Request Count, Status
- **Actions**: "Revoke Key", "View Usage Analytics"

#### DKIM Keys Section

- **Table**: Domain, Selector, Last Rotated, Next Rotation (365 days), Status
- **Actions**: "Rotate Now", "View DNS Records"

### SMTP Credentials Viewing Modal

**Trigger**: Clicking "View Credentials" button

**Security Flow**:

1. **Re-authentication Step**:
   - Password input: "Enter your password to continue"
   - 2FA code input: "Enter your 2FA code"
   - "Verify" button validates credentials
   - Error handling for invalid attempts

2. **Credentials Display** (after successful re-auth):
   - **Header**: "SMTP Admin Credentials - Tenant: {tenant_name}"
   - **Expiration Timer**: "Credentials expire in 14:32" (countdown)
   - **Warning Banner**: "⚠️ These credentials provide full access to the tenant's email infrastructure. Handle with care."
   - **Credential Fields**:
     - Username: Plain text, copyable
     - Password: Masked by default with eye icon to reveal
     - Copy button with confirmation
     - Webmail URL: Clickable link (opens new tab)
   - **Metadata**: Created, Last Rotated, Next Rotation dates
   - **Actions**: Close, Rotate Now, Emergency Reset

3. **Auto-Hide Behavior**:
   - 15-minute time limit
   - Warning at 1 minute remaining
   - Auto-close after expiration

### Rotation Management

**Bulk Rotation Panel**:

- **"Rotate All SSH Keys"**: Triggers rotation for all tenants
- **"Rotate All SMTP Credentials"**: Bulk SMTP rotation
- **"Rotate Overdue Secrets"**: Only rotates secrets past rotation date

**Rotation Schedule Configuration**:

- **SSH Keys**: 90 days (default), Custom (30-365 days)
- **SMTP Credentials**: 180 days (default), Custom
- **DKIM Keys**: 365 days (default), Custom

**Grace Period Settings**:

- **SSH Keys**: 24 hours (both old and new keys valid)
- **DKIM Keys**: 48 hours (DNS propagation time)

### Audit Log Viewer

**Real-Time Audit Stream**:

- Columns: Timestamp, Action, Tenant, User, Secret Type, IP Address, Status
- Actions tracked: read, write, delete, rotate, download
- Auto-refresh every 5 seconds

**Filters**:

- Tenant (dropdown)
- Secret Type (SSH, SMTP, API Keys, DKIM)
- Action type
- Date range
- Admin user

**Suspicious Activity Alerts**:

- 🔴 5+ failed auth attempts in 5 minutes
- 🟡 Access during off-hours (2am-6am)
- 🟡 Bulk secret reads (>100 in 1 minute)
- 🔴 Secret deletion without approval

**Export**:

- CSV format
- JSON format for programmatic analysis

---

## Integration Architecture

### HashiCorp Vault

- **Storage**: KV v2 secrets engine
- **Backend**: PostgreSQL for HA (High Availability)
- **Access Control**: Role-based policies
  - Admin: Full access to all secrets
  - Tenant: Read-only access to own secrets
- **API**: All operations via Vault REST API

### Security

- **Encryption**: AES-256-GCM for all secrets
- **Transit at Rest**: TLS 1.3 for API communication
- **Audit Device**: File + Syslog for redundancy
- **Access Logging**: All operations logged with full context

### Backup System

- **Frequency**: Automated daily snapshots
- **Storage**: S3 with versioning enabled
- **Encryption**: AES-256-GCM
- **Retention**: 30 days of snapshots
- **Recovery**: Point-in-time restore capability

### Monitoring

- **Prometheus Metrics**: Vault health, seal status, request rate *(2026 Spike)*
- **Alerting**: PagerDuty for critical issues
  - Vault sealed unexpectedly
  - Backup failure >24 hours
  - High rate of failed authentications

---

## Technical Considerations

### Performance

- **Secret Retrieval**: <100ms for cached secrets
- **Rotation**: <5 minutes per tenant for full rotation
- **Audit Query**: <1s for most queries (Elasticsearch backend - 2026 Spike)

### Scalability

- **Tenant Capacity**: Supports 10,000+ tenants
- **Concurrent Access**: 100+ simultaneous admin operations
- **Audit Storage**: 7 years retention with compression

### Compliance

- **SOC 2**: Comprehensive audit trails for all access
- **PCI DSS**: Encryption at rest and in transit
- **ISO 27001**: Role-based access control and monitoring

---

## Related Documentation

### Route Specifications

- [Platform Admin Routes - Vault Management](/docs/design/routes/platform-admin#admin-secrets) - Detailed UI specification
- [Infrastructure SSH Access Routes](/docs/design/routes/infrastructure-ssh-access) - SSH access integration

### Features

- [Vault SSH Management](/docs/features/infrastructure/vault-ssh-management) - SSH key implementation details
- [Infrastructure Security](/docs/features/compliance/security-features) - Security best practices

### Operations

- [Incident Response](/docs/operations/incident-management/runbooks) - Security incident procedures
- [Security Compliance](/docs/business/compliance/soc2-requirements) - Audit requirements

### API Documentation

- [Vault API](/docs/implementation-technical/api/platform-api/vault) - Vault management endpoints (to be created)

---

## Future Enhancements

### Q2 2026

- **Automated Secret Discovery**: Scan for unrotated secrets
- **Certificate Management**: SSL/TLS certificate rotation
- **Multi-Vault Support**: Geographic distribution for latency

### Q3 2026

- **Zero-Knowledge Architecture**: Encrypt secrets with tenant-specific keys
- **Secret Sharing**: Secure sharing between teams
- **Compliance Automation**: Auto-generate SOC 2 secret access reports
