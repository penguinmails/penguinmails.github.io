---
title: "Database Security & Consent Management"
description: "Technical implementation details for encrypted data storage, multi-tenant isolation, and automated consent tracking systems."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# Database Security & Consent Management

## Database Security Enhancements

### Encrypted Personal Data Storage

Personal data is encrypted at rest using AES-256 encryption. The encryption keys are managed using a secure key management system (KMS), with keys rotated every 90 days.

```sql
-- Example of encrypted data storage
CREATE TABLE customer_personal_data (
    id UUID PRIMARY KEY,
    tenant_id UUID REFERENCES tenants(id),
    encrypted_email BYTEA NOT NULL,
    encrypted_name BYTEA,
    iv BYTEA NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);
```

### Row-Level Security (RLS) Policies

NileDB's native multi-tenancy capabilities are used to implement strict row-level security policies, ensuring that each tenant can only access their own data.

```sql
-- Example of RLS policy
ALTER TABLE customer_personal_data ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation_policy ON customer_personal_data
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
```

### Database Audit Logging

All access to personal data is logged for audit purposes, including the user, tenant, timestamp, and the specific data accessed.

```sql
-- Example of audit logging trigger
CREATE OR REPLACE FUNCTION log_personal_data_access()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO personal_data_access_logs (
        user_id, tenant_id, action, table_name, record_id, timestamp
    ) VALUES (
        current_setting('app.current_user_id')::UUID,
        current_setting('app.current_tenant_id')::UUID,
        TG_OP, TG_TABLE_NAME, NEW.id, CURRENT_TIMESTAMP
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

---

## Consent Management System

### Purpose & Scope

The Consent Management System (CMS) provides a centralized mechanism for capturing, storing, and managing user consent for marketing communications and data processing.

### Consent Data Model

Consent records include the user ID, tenant ID, consent type, status, timestamp, and the specific version of the privacy policy accepted.

```json
{
  "consent_record": {
    "user_id": "uuid",
    "tenant_id": "uuid",
    "consent_type": "marketing_email",
    "status": "granted",
    "timestamp": "iso8601",
    "policy_version": "v1.2",
    "ip_address": "string",
    "user_agent": "string"
  }
}
```

### Automated Consent Expiration

Consent is automatically expired after 12 months, requiring users to re-verify their consent for continued communications.

```javascript
// Example of consent expiration logic
function checkConsentExpiration(consentRecord) {
  const expirationPeriod = 365 * 24 * 60 * 60 * 1000; // 12 months
  const now = new Date();
  const consentDate = new Date(consentRecord.timestamp);
  
  if (now - consentDate > expirationPeriod) {
    return true; // Consent expired
  }
  return false;
}
```

### Integration with Marketing Tools

The CMS integrates with all marketing tools, ensuring that communications are only sent to users with active, valid consent.

- **Email Service Provider**: Syncs consent status to ensure compliance
- **Analytics Platforms**: Only tracks users who have provided analytics consent
- **Campaign Management**: Filters campaign recipients based on consent status
