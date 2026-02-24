---
title: "Audit Logging & Security Monitoring"
description: "Tracking system activity and detecting suspicious behavior in real-time."
last_modified_date: "2026-02-24"
level: "2"
persona: "Security Analysts, Compliance Officers"
---

# Audit Logging & Security Monitoring

PenguinMails provides comprehensive visibility into all security-relevant events occurring within your tenant.

## 1. Audit Logging

Every sensitive action taken by a user or an automated process is recorded in an immutable audit log.

### What gets logged

- **Authentication**: Successful logins, failed attempts, and logouts.
- **Access Control**: Role changes, user invitations, and deletions.
- **Sensitive Operations**: Password resets, API key creation/revocation, and data exports.
- **System Configuration**: Changes to domain settings or billing info.

### Log Structure

```typescript
interface AuditLog {
  id: string;
  timestamp: Date;
  actorId: string;    // Who did it
  tenantId: string;   // Where it happened
  eventType: string;  // What happened
  ipAddress: string;  // Where they were
  userAgent: string;  // What they used
  status: 'success' | 'failure';
}
```

## 2. Real-Time Monitoring

Our security engine monitors logs in real-time to detect and alert on suspicious patterns.

- **Brute Force Detection**: Monitoring for 5+ failed login attempts from a single IP.
- **Mass Action Alerts**: Alerting on mass deletion of contacts or campaigns.
- **Unusual Activity**: Detection of logins from new geographic locations or unusual times.

## 3. Log Retention

- **Free/Starter Tiers**: 30 days.
- **Pro Tier**: 90 days.
- **Enterprise Tier**: 1 year (Standard) or up to 7 years (Compliance Mode).

## 4. SIEM Integration

Enterprise customers can stream their audit logs in real-time to external Security Information and Event Management (SIEM) tools like Splunk, Datadog, or ELK Stack via our Webhooks system.
