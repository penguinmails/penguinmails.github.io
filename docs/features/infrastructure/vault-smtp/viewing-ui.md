---
title: "Secure Credential Viewing UI"
description: "Web interface for secure credential viewing"
level: "3"
keywords: "UI, web interface, credential viewing, security"
---

# Secure Credential Viewing UI

## Secure Credential Viewing UI

### Admin Dashboard Route

**Route:** `/platform-admin/tenants/{tenant_id}/smtp-credentials`

**Access Control:**

- Requires `platform-admin` role

- Requires re-authentication (password + 2FA)

- Session expires after 15 minutes of inactivity

**UI Components:**

1. **Re-authentication Modal**

   ```typescript
   interface ReauthModalProps {
     onSuccess: (token: string) => void;
     onCancel: () => void;
   }

   // Display modal requiring password + 2FA
   // Generate time-limited re-auth token on success
   ```

2. **Credential Display Component**

   ```typescript
   interface SmtpCredentialsViewProps {
     tenantId: string;
     credentials: SmtpCredentials;
     expiresAt: Date;
   }

   // Display credentials with:
   // - Masked password (click to reveal)
   // - Copy to clipboard button
   // - Countdown timer (15 minutes)
   // - Auto-hide after expiration
   ```

3. **Audit Trail Display**

   ```typescript
   interface AuditTrailProps {
     tenantId: string;
     events: AuditEvent[];
   }

   // Display recent credential access events:
   // - Timestamp
   // - Admin user
   // - IP address
   // - Action (viewed, rotated, reset)
   ```

**Security Features:**

- Password initially masked (click to reveal)

- Copy to clipboard with confirmation

- Auto-hide credentials after 15 minutes

- Warning banner: "Credentials expire in X minutes"

- Audit trail visible to all admins

