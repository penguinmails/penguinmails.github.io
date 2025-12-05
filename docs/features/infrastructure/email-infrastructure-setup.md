---
title: "Email Infrastructure Setup"
description: "Automated VPS provisioning, SMTP server setup, and DNS configuration for professional email infrastructure"
level: "1"
status: "ACTIVE"
roadmap_timeline: "Q4 2025"
priority: "Critical"
related_features:

  - infrastructure/hostwind-management

  - infrastructure/free-mailbox-creation

  - domains/domain-management

  - compliance/security-features
related_tasks:

  - epic-5-infrastructure-management
related_api:

  - implementation-technical/api/platform-api/infrastructure
---

# Email Infrastructure Setup

**Quick Access**: This feature enables automated provisioning and configuration of professional email infrastructure in under 5 minutes.

## Overview

Email Infrastructure Setup provides end-to-end automation for creating production-ready email sending infrastructure, including VPS provisioning, SMTP server installation, DNS configuration, and security hardening.

### Key Value Proposition

- **Speed**: Professional email infrastructure ready in < 5 minutes

- **Automation**: Zero manual server configuration required

- **Security**: Built-in SSL, SPF, DKIM, DMARC configuration

- **Compliance**: GDPR/CCPA-ready infrastructure from day one

- **Scale**: Support for multi-tenant architecture with workspace isolation

---

## Level 1: Quick Setup Guide

### What You Get

Professional email infrastructure includes:

1. **VPS Server**: Dedicated or shared virtual private server via Hostwind

2. **SMTP Server**: MailU SMTP server pre-configured and secured

3. **DNS Records**: Automated SPF, DKIM, DMARC record setup

4. **SSL Certificates**: Let's Encrypt SSL/TLS certificates auto-installed

5. **Email Accounts**: Initial mailbox creation with authentication

### 5-Minute Setup Process

#### Step 1: Domain Verification

```text

1. Add your domain to PenguinMails

2. System generates DNS verification record

3. Add TXT record to your DNS provider

4. Click "Verify Domain" (usually instant)

```

**Required Information:**

- Domain name (e.g., `yourdomain.com`)

- DNS provider access (for record creation)

#### Step 2: Infrastructure Provisioning

Once domain is verified, click **"Launch Infrastructure"**:

```text

[Automated Process - 2-3 minutes]
âœ“ VPS server provisioned via Hostwind API
âœ“ MailU SMTP server installed and configured
âœ“ SSL certificates generated (Let's Encrypt)
âœ“ Firewall rules configured
âœ“ Initial system hardening applied

```

**What Happens Behind the Scenes:**

- VPS created with Ubuntu LTS + optimized email settings

- MailU installed with production configuration

- Port 25, 465, 587, 993 opened and secured

- Fail2ban installed for brute-force protection

#### Step 3: DNS Configuration

System displays required DNS records:

```text

Add these records to your DNS provider:

MX Record:
  Host: @
  Value: mail.yourdomain.com
  Priority: 10

A Record:
  Host: mail
  Value: [Your VPS IP]

TXT Record (SPF):
  Host: @
  Value: v=spf1 ip4:[Your VPS IP] ~all

TXT Record (DKIM):
  Host: default._domainkey
  Value: [Generated DKIM public key]

TXT Record (DMARC):
  Host: _dmarc
  Value: v=DMARC1; p=quarantine; rua=mailto:postmaster@yourdomain.com

```

**Automation Option:** For supported DNS providers (Cloudflare, Route53, etc.), click **"Auto-Configure DNS"** to apply all records automatically.

#### Step 4: Create Email Account

```text

1. Click "Create Email Account"

2. Enter email address (e.g., sales@yourdomain.com)

3. Set secure password (or auto-generate)

4. Click "Create Account"

```

**Result:** Email account ready to send/receive in 30 seconds.

#### Step 5: Verification & Testing

System automatically runs verification:

```text

âœ“ SMTP connection test
âœ“ SPF record validation
âœ“ DKIM signature validation
âœ“ DMARC policy check
âœ“ SSL certificate validation
âœ“ Deliverability score (initial)

```

**Test Email:** Send test email to verify configuration.

### Success Criteria

Infrastructure setup is complete when:

- ✅ All DNS records validated

- ✅ SMTP server responding on ports 25, 465, 587

- ✅ SSL certificate valid

- ✅ Test email delivered successfully

- ✅ Deliverability score > 80%

> **Important**: Infrastructure is just the first step. Perfect DNS records won't save you if your sending behavior is flagged. Read [Why SPF/DKIM Isn't Enough](/guides/deliverability-myths-debunked#myth-1-just-set-up-spfdkimdmarc-and-youre-good) to understand the full picture.

---

## Level 2: Advanced Configuration

### Infrastructure Customization

#### VPS Configuration Options

**Server Sizing:**

- **Starter**: 1 CPU, 2GB RAM (up to 5K emails/day)

- **Professional**: 2 CPU, 4GB RAM (up to 25K emails/day)

- **Business**: 4 CPU, 8GB RAM (up to 100K emails/day)

- **Enterprise**: Custom sizing for high-volume needs

**Server Location:**

- Choose geographic region for optimal deliverability

- Consider GDPR data residency requirements

- Multi-region deployment available (Enterprise)

#### SMTP Server Optimization

**Performance Tuning:**

```yaml

# Email sending limits

max_connections: 50
max_messages_per_connection: 100
connection_timeout: 300s
retry_attempts: 3
retry_delay: 60s

# Queue configuration

queue_lifetime: 5d
bounce_queue_lifetime: 5d
defer_transports: true

```

**Security Hardening:**

- TLS 1.2+ enforcement

- Strong cipher suite configuration

- SMTP authentication required

- IP-based access restrictions (optional)

- Rate limiting per account

#### DNS Best Practices

**SPF Configuration Strategies:**

```text

# Simple (single server)

v=spf1 ip4:123.45.67.89 ~all

# Multiple servers

v=spf1 ip4:123.45.67.89 ip4:123.45.67.90 ~all

# Include third-party (e.g., Postmark for transactional)

v=spf1 ip4:123.45.67.89 include:spf.postmarkapp.com ~all

```

**DKIM Key Rotation:**

- Rotate DKIM keys quarterly for security

- Support for multiple simultaneous keys

- Automated rotation available (Enterprise)

**DMARC Policy Progression:**

```text

# Phase 1: Monitor only

v=DMARC1; p=none; rua=mailto:dmarc@yourdomain.com

# Phase 2: Quarantine (after 30 days)

v=DMARC1; p=quarantine; pct=10; rua=mailto:dmarc@yourdomain.com

# Phase 3: Reject (after 90 days)

v=DMARC1; p=reject; rua=mailto:dmarc@yourdomain.com

```

### Multi-Workspace Infrastructure

For agencies managing multiple clients:

**Workspace Isolation Options:**

1. **Shared VPS** (Cost-effective):

   - Multiple domains on single VPS

   - Separate DKIM keys per domain

   - Shared IP reputation

   - Best for: Startups, small agencies

2. **Dedicated VPS per Workspace** (Recommended):

   - Complete isolation between clients

   - Independent IP reputation

   - Custom server configuration per workspace

   - Best for: Agencies, enterprise clients

3. **IP Pooling** (Enterprise):

   - Multiple IPs per VPS

   - Intelligent IP rotation

   - Dedicated IPs for high-volume senders

   - Best for: High-volume sending

### Monitoring & Maintenance

#### Health Checks

System performs automated monitoring:

```text

Every 5 minutes:
âœ“ SMTP service status
âœ“ Queue size and processing rate
âœ“ Disk space utilization
âœ“ CPU and memory usage

Every hour:
âœ“ DNS record validation
âœ“ SSL certificate expiration
âœ“ IP reputation score

Daily:
âœ“ Email deliverability test
âœ“ Spam trap detection
âœ“ Blacklist monitoring

```

#### Alerting

Automated alerts for:

- SMTP service downtime

- DNS record changes or failures

- SSL certificate expiration (30, 7, 1 day warnings)

- IP blacklisting

- Deliverability score drop > 10%

- Disk space > 80% full

---

## Level 3: Technical Implementation

### Architecture Overview

```text

┌─────────────────────────────────────────────────────────┐
│                     PenguinMails Platform               │
│                                                         │
│  ┌──────────────────┐      ┌──────────────────┐       │
│  │  Infrastructure  │──────│   Hostwind API   │       │
│  │  Provisioning    │      │    Integration   │       │
│  └──────────────────┘      └──────────────────┘       │
│           │                         │                   │
│           â–¼                         â–¼                   │
│  ┌──────────────────────────────────────────┐          │
│  │         VPS Management Service           │          │
│  │  - Server lifecycle management           │          │
│  │  - Configuration automation              │          │
│  │  - Health monitoring                     │          │
│  └──────────────────────────────────────────┘          │
│           │                                              │
│           â–¼                                              │
│  ┌──────────────────────────────────────────┐          │
│  │          DNS Automation Service          │          │
│  │  - Record generation                     │          │
│  │  - Validation and monitoring             │          │
│  └──────────────────────────────────────────┘          │
└─────────────────────────────────────────────────────────┘
                         │
                         â–¼
        ┌────────────────────────────────┐
        │      Hostwind VPS Instance     │
        │                                │
        │  ┌──────────────────────────┐ │
        │  │   MailU SMTP Server      │ │
        │  │   - Port 25, 465, 587    │ │
        │  │   - TLS/SSL enabled      │ │
        │  │   - Authentication       │ │
        │  └──────────────────────────┘ │
        │                                │
        │  ┌──────────────────────────┐ │
        │  │   Security Layer         │ │
        │  │   - Firewall (UFW)       │ │
        │  │   - Fail2ban             │ │
        │  │   - Let's Encrypt SSL    │ │
        │  └──────────────────────────┘ │
        └────────────────────────────────┘

```

### Database Schema

Infrastructure state tracking:

```sql
-- Infrastructure tracking
CREATE TABLE infrastructure (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),

  -- VPS details
  vps_id VARCHAR(255) UNIQUE NOT NULL, -- Hostwind VPS ID
  vps_ip VARCHAR(45) NOT NULL,
  vps_hostname VARCHAR(255),
  vps_region VARCHAR(50),
  vps_size VARCHAR(50),
  vps_status VARCHAR(50), -- active, suspended, terminated

  -- SMTP configuration
  smtp_host VARCHAR(255),
  smtp_port INTEGER DEFAULT 587,
  smtp_username VARCHAR(255),
  smtp_password_encrypted TEXT,

  -- SSL/TLS
  ssl_certificate_path TEXT,
  ssl_certificate_expires_at TIMESTAMP,

  -- Monitoring
  last_health_check TIMESTAMP,
  health_status VARCHAR(50), -- healthy, degraded, critical
  deliverability_score INTEGER, -- 0-100

  -- Metadata
  provisioned_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  metadata JSONB
);

-- DNS records tracking
CREATE TABLE dns_records (
  id UUID PRIMARY KEY,
  infrastructure_id UUID NOT NULL REFERENCES infrastructure(id),
  domain_id UUID NOT NULL REFERENCES domains(id),

  -- Record details
  record_type VARCHAR(10), -- MX, A, TXT, CNAME
  record_name VARCHAR(255),
  record_value TEXT,
  record_priority INTEGER,
  record_ttl INTEGER DEFAULT 3600,

  -- Validation
  is_validated BOOLEAN DEFAULT FALSE,
  validated_at TIMESTAMP,
  last_validation_check TIMESTAMP,
  validation_status VARCHAR(50), -- pending, valid, invalid, missing

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Email accounts on infrastructure
CREATE TABLE email_accounts (
  id UUID PRIMARY KEY,
  infrastructure_id UUID NOT NULL REFERENCES infrastructure(id),
  domain_id UUID NOT NULL REFERENCES domains(id),

  email_address VARCHAR(255) UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,

  -- Configuration
  quota_mb INTEGER DEFAULT 1024,
  max_send_per_day INTEGER DEFAULT 500,
  is_active BOOLEAN DEFAULT TRUE,

  -- Usage tracking
  emails_sent_today INTEGER DEFAULT 0,
  storage_used_mb INTEGER DEFAULT 0,
  last_login TIMESTAMP,

  -- Metadata
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

```

### API Endpoints

#### Infrastructure Provisioning

**POST** `/api/infrastructure/provision`

```typescript
interface ProvisionInfrastructureRequest {
  tenantId: string;
  workspaceId?: string;
  domainId: string;

  // VPS configuration
  vpsConfig: {
    size: 'starter' | 'professional' | 'business' | 'enterprise';
    region: string; // e.g., 'us-east', 'eu-west'
  };

  // SMTP configuration
  smtpConfig?: {
    maxConnectionsPerHour?: number;
    enableRateLimiting?: boolean;
  };

  // DNS automation
  autoConfigureDNS?: boolean;
  dnsProvider?: 'cloudflare' | 'route53' | 'manual';
  dnsCredentials?: object;
}

interface ProvisionInfrastructureResponse {
  infrastructureId: string;
  vpsId: string;
  vpsIp: string;
  smtpHost: string;

  status: 'provisioning' | 'active' | 'failed';
  estimatedCompletionTime: number; // seconds

  dnsRecords: DNSRecord[];
  nextSteps: string[];
}

```

**Implementation:**

```typescript
async function provisionInfrastructure(req: Request): Promise<Response> {
  // 1. Validate tenant and domain
  const tenant = await validateTenant(req.body.tenantId);
  const domain = await validateDomain(req.body.domainId);

  // 2. Provision VPS via Hostwind API
  const vps = await hostwindClient.createVPS({
    size: req.body.vpsConfig.size,
    region: req.body.vpsConfig.region,
    image: 'ubuntu-22.04-email-optimized',
  });

  // 3. Install and configure MailU SMTP
  await sshClient.connect(vps.ip);
  const smtpCredentials = await sshClient.exec('install-mailu.sh', {
    domain: domain.name,
    adminEmail: `admin@${domain.name}`,
  });

  // 3a. Store SMTP credentials in Vault (see task 11.5)
  // Reference: docs/features/infrastructure/vault-smtp-credentials.md
  await vaultClient.write(`smtp/${tenant.id}/admin`, {
    username: smtpCredentials.username,
    password: await encryptPassword(smtpCredentials.password, tenant.id),
    webmail_url: `https://mail.${domain.name}`,
    created_at: new Date().toISOString(),
    last_rotated: new Date().toISOString(),
    rotation_policy: '180_days'
  });

  // 4. Generate SSL certificates
  await sshClient.exec('certbot --nginx -d mail.${domain.name}');

  // 5. Generate DKIM keys
  const dkimKeys = await generateDKIMKeys(domain.name);

  // 6. Store infrastructure record
  const infrastructure = await db.infrastructure.create({
    tenantId: req.body.tenantId,
    workspaceId: req.body.workspaceId,
    vpsId: vps.id,
    vpsIp: vps.ip,
    smtpHost: `mail.${domain.name}`,
    // ... other fields
  });

  // 7. Generate DNS records
  const dnsRecords = generateDNSRecords(domain.name, vps.ip, dkimKeys);
  await db.dnsRecords.createMany(dnsRecords);

  // 8. Auto-configure DNS if requested
  if (req.body.autoConfigureDNS) {
    await configureDNSProvider(req.body.dnsProvider, req.body.dnsCredentials, dnsRecords);
  }

  return {
    infrastructureId: infrastructure.id,
    vpsId: vps.id,
    vpsIp: vps.ip,
    smtpHost: `mail.${domain.name}`,
    status: 'active',
    dnsRecords,
    nextSteps: req.body.autoConfigureDNS ?
      ['Verify DNS propagation', 'Create email accounts'] :
      ['Add DNS records to your provider', 'Verify DNS'],
  };
}

```

#### DNS Validation

**POST** `/api/infrastructure/{id}/validate-dns`

```typescript
async function validateDNS(infrastructureId: string): Promise<ValidationResult> {
  const infrastructure = await db.infrastructure.findById(infrastructureId);
  const dnsRecords = await db.dnsRecords.findByInfrastructure(infrastructureId);

  const validationResults = await Promise.all(
    dnsRecords.map(async (record) => {
      const actual = await dnsLookup(record.recordName, record.recordType);
      const isValid = compareRecordValues(actual, record.recordValue);

      await db.dnsRecords.update(record.id, {
        isValidated: isValid,
        validatedAt: isValid ? new Date() : null,
        validationStatus: isValid ? 'valid' : 'invalid',
        lastValidationCheck: new Date(),
      });

      return { record, isValid };
    })
  );

  const allValid = validationResults.every(r => r.isValid);

  if (allValid) {
    await db.infrastructure.update(infrastructureId, {
      healthStatus: 'healthy',
    });
  }

  return {
    isValid: allValid,
    records: validationResults,
  };
}

```

### Integration Points

#### Hostwind API Integration

```typescript
class HostwindClient {
  async createVPS(config: VPSConfig): Promise<VPS> {
    const response = await this.apiClient.post('/vps/create', {
      plan: this.mapSizeToPlan(config.size),
      location: config.region,
      os: 'ubuntu-22.04',
      hostname: `mail-${generateRandomId()}`,
    });

    // Wait for VPS to be ready
    await this.pollVPSStatus(response.vpsId, 'active', 300); // 5 min timeout

    return response;
  }

  async monitorVPS(vpsId: string): Promise<VPSStatus> {
    const response = await this.apiClient.get(`/vps/${vpsId}/status`);
    return response;
  }

  async deleteVPS(vpsId: string): Promise<void> {
    await this.apiClient.delete(`/vps/${vpsId}`);
  }
}

```

#### DNS Provider Integration

Support for automated DNS configuration:

```typescript
interface DNSProviderAdapter {
  createRecord(domain: string, record: DNSRecord): Promise<void>;
  validateRecord(domain: string, record: DNSRecord): Promise<boolean>;
  deleteRecord(domain: string, recordId: string): Promise<void>;
}

class CloudflareDNSAdapter implements DNSProviderAdapter {
  // Implementation for Cloudflare API
}

class Route53DNSAdapter implements DNSProviderAdapter {
  // Implementation for AWS Route53
}

```

### Background Jobs

```typescript
// Scheduled job: Health monitoring
cron.schedule('*/5 * * * *', async () => {
  const infrastructures = await db.infrastructure.findAllActive();

  for (const infra of infrastructures) {
    const health = await checkInfrastructureHealth(infra);
    await db.infrastructure.update(infra.id, {
      lastHealthCheck: new Date(),
      healthStatus: health.status,
    });

    if (health.status === 'critical') {
      await sendAlert(infra.tenantId, 'infrastructure-critical', health);
    }
  }
});

// Scheduled job: DNS validation
cron.schedule('0 * * * *', async () => {
  const infrastructures = await db.infrastructure.findAllActive();

  for (const infra of infrastructures) {
    await validateDNS(infra.id);
  }
});

// Scheduled job: SSL certificate renewal
cron.schedule('0 0 * * *', async () => {
  const infrastructures = await db.infrastructure.findExpiringCertificates(30); // 30 days

  for (const infra of infrastructures) {
    await renewSSLCertificate(infra);
  }
});

```

---

## Related Documentation

### Planning & Product

- **[Product Roadmap](/docs/operations/roadmap/product-roadmap/overview)** - Infrastructure timeline (Q4 2025)

- **[Technical Roadmap](/docs/operations/roadmap/technical-roadmap)** - Infrastructure considerations

- **[Feature Taxonomy](/docs/business/feature-taxonomy-and-roadmap)** - Level 1 core feature

### Related Features

- **[Hostwind Management](/docs/features/infrastructure/hostwind-management)** - VPS monitoring and operations

- **[Free Mailbox Creation](/docs/features/infrastructure/free-mailbox-creation/overview)** - Email account provisioning

- **[Domain Management](/docs/features/domains/domain-management)** - DNS and domain configuration

- **[Security Features](/docs/features/compliance/security-features)** - SSL, SPF, DKIM, DMARC details

- **[Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture)** - Isolation and workspace management

- **[Vault SSH Management](/docs/features/infrastructure/vault-ssh-management)** - SSH key storage and rotation in Vault

- **[SMTP Credentials Vault Storage](/docs/features/infrastructure/vault-smtp/overview)** - Secure SMTP credential management

### Technical Specifications

- **[Infrastructure API](/docs/implementation-technical/api/platform-api/infrastructure)** - API endpoints

- **[Architecture Overview](/docs/technical/architecture/overview)** - System architecture

### Implementation

- **Epic 5: Infrastructure Management** - Internal task reference for implementation tasks

---

**Last Updated:** November 25, 2025
**Status:** Active - Core Feature (Level 1)
**Owner:** Infrastructure Team
