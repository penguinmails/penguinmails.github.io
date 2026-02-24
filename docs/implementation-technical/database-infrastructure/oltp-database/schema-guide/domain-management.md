---
title: "OLTP Schema - Domain Management"
description: "Email sending domains and email account configuration schema."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Domain Management

### **Domain Management**

#### **domains** - Email Sending Domains

```sql
CREATE TABLE domains (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    company_id UUID REFERENCES companies(id) ON DELETE CASCADE,
    domain VARCHAR(253) NOT NULL,
    verification_status VARCHAR(50) DEFAULT 'pending',
    dns_records JSONB,
    is_primary BOOLEAN DEFAULT FALSE,
    verified TIMESTAMP WITH TIME ZONE,

    -- DNS Operational Metadata (Added for DNS Storage Integration)
    mailu_domain TEXT,                           -- Mailu's canonical hostname
    dns_ttl_observed INTEGER,                    -- Observed DNS TTL in seconds
    dns_last_verified_at TIMESTAMP WITH TIME ZONE, -- Last successful DNS verification
    dns_verification_error TEXT,                 -- Human-friendly error messages
    dns_verification_attempts INTEGER DEFAULT 0, -- Verification retry counter

    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

#### **DNS Records JSON Structure** (dns_records JSONB)

The `dns_records` JSONB field stores per-record DNS configuration with lifecycle management:

```json
{
  "records": [
    {
      "record_type": "SPF",
      "name": "@",
      "value": "v=spf1 include:_spf.mailu.io include:_spf.sendgrid.net -all",
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    },
    {
      "record_type": "DKIM",
      "name": "default._domainkey",
      "selector": "default",
      "value": "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSI....",
      "public_key": "MIGfMA0GCSqGSI....",
      "managed_by": "platform",              -- "platform" or "mailu"
      "secret_ref": "vault://mail/dkim/domain.com/default", -- Vault reference
      "needs_deployment": false,             -- Flag for Mailu sync jobs
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "platform"
    },
    {
      "record_type": "DMARC",
      "name": "_dmarc",
      "value": "v=DMARC1; p=quarantine; rua=mailto:dmarc@domain.com",
      "policy": "quarantine",
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:32:00Z",
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    },
    {
      "record_type": "MX",
      "name": "@",
      "value": "mail.penguinmails.io.",
      "priority": 10,
      "ttl": 3600,
      "verification_status": "verified",
      "last_verified_at": "2025-10-20T14:40:00Z",
      "mx_hosts": ["203.0.113.5"],
      "verification_attempts": 1,
      "verification_error": null,
      "source": "ui"
    }
  ]
}
```

**DNS Record Field Meanings**:

- `record_type`: DNS record type (SPF, DKIM, DMARC, MX, A, AAAA, CNAME)
- `name`: DNS record name (@ for root, subdomain for others)
- `value`: Expected DNS record value
- `verification_status`: Current verification state (pending, verified, failed, error)
- `last_verified_at`: Timestamp of last successful verification
- `verification_attempts`: Number of verification attempts
- `verification_error`: Error message from last failed verification
- `managed_by`: Who manages the record ("platform" or "mailu")
- `secret_ref`: Vault reference for DKIM private keys (platform-managed only)
- `needs_deployment`: Flag for Mailu sync jobs to deploy DKIM keys
- `source`: Source of record creation ("ui", "platform", "api")

#### **email_accounts** - Email Account Configuration

```sql
CREATE TABLE email_accounts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
    email VARCHAR(255) NOT NULL,
    provider VARCHAR(50) DEFAULT 'mailu',
    vault_key_path VARCHAR(500),
    imap_settings JSONB,
    smtp_settings JSONB,
    status VARCHAR(50) DEFAULT 'active',
    last_warmed TIMESTAMP WITH TIME ZONE,
    daily_count INTEGER DEFAULT 0,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
