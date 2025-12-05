---
title: "Audit Logging"
description: "Audit trail and monitoring for credential access"
level: "3"
keywords: "audit logging, monitoring, compliance, security"
---

# Audit Logging

## Audit Logging

### Logged Events

All SMTP credential operations are logged in the audit trail:

**Event Types:**

- `smtp_credentials_stored` - Initial credential storage during VPS provisioning

- `smtp_credentials_accessed` - Admin retrieval for troubleshooting

- `smtp_credentials_rotated` - Automated or manual rotation

- `smtp_credentials_emergency_reset` - Emergency credential reset

- `smtp_credentials_viewed` - Credential viewing in UI

- `smtp_credentials_copied` - Copy to clipboard action

**Audit Log Schema:**

```typescript
interface SmtpCredentialAuditEvent {
  id: string;                    // UUID v4
  event: string;                 // Event type
  tenant_id: string;             // Tenant UUID
  user_id: string;               // Admin user ID or 'system'
  timestamp: string;             // ISO 8601 timestamp
  ip_address?: string;           // Client IP address
  user_agent?: string;           // Client user agent
  severity: 'info' | 'warning' | 'critical';
  details: {
    rotation_type?: 'automated' | 'manual';
    reason?: string;
    incident_id?: string;
    previous_rotation?: string;
  };
}

```

**Audit Log Query Examples:**

```typescript
// Get all credential access events for a tenant
const accessEvents = await auditLog.query({
  tenant_id: tenantId,
  event: 'smtp_credentials_accessed',
  order_by: 'timestamp DESC',
  limit: 50
});

// Get all emergency resets in the last 30 days
const emergencyResets = await auditLog.query({
  event: 'smtp_credentials_emergency_reset',
  timestamp_gte: new Date(Date.now() - 30 * 24 * 60 * 60 * 1000),
  order_by: 'timestamp DESC'
});

// Get all credential operations by a specific admin
const adminOperations = await auditLog.query({
  user_id: adminUserId,
  event_in: [
    'smtp_credentials_accessed',
    'smtp_credentials_rotated',
    'smtp_credentials_emergency_reset'
  ],
  order_by: 'timestamp DESC',
  limit: 100
});

```

### Audit Alerts

Configure alerts for suspicious activity:

**Alert Triggers:**

- Multiple credential access attempts (>5 in 1 hour)

- Credential access outside business hours (10pm-6am)

- Emergency reset without incident ID

- Failed authentication attempts (>3 in 5 minutes)

**Alert Implementation:**

```typescript
// Monitor audit log for suspicious activity
async function monitorSmtpCredentialAccess(): Promise<void> {
  // Check for multiple access attempts
  const recentAccess = await auditLog.query({
    event: 'smtp_credentials_accessed',
    timestamp_gte: new Date(Date.now() - 60 * 60 * 1000), // Last hour
    group_by: 'user_id'
  });

  for (const [userId, count] of Object.entries(recentAccess)) {
    if (count > 5) {
      await sendSecurityAlert({
        type: 'suspicious_credential_access',
        user_id: userId,
        access_count: count,
        time_window: '1 hour'
      });
    }
  }

  // Check for after-hours access
  const currentHour = new Date().getHours();
  if (currentHour >= 22 || currentHour <= 6) {
    const afterHoursAccess = await auditLog.query({
      event: 'smtp_credentials_accessed',
      timestamp_gte: new Date(Date.now() - 5 * 60 * 1000) // Last 5 minutes
    });

    if (afterHoursAccess.length > 0) {
      await sendSecurityAlert({
        type: 'after_hours_credential_access',
        events: afterHoursAccess
      });
    }
  }
}

```
