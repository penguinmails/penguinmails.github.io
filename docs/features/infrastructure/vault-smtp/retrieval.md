---
title: "Credential Retrieval"
description: "Mechanisms for retrieving SMTP credentials from Vault"
level: "3"
keywords: "retrieval, credential access, Vault API"
---

# Credential Retrieval

## Credential Retrieval

### Admin Troubleshooting Access

PenguinMails administrators can retrieve SMTP credentials for troubleshooting purposes with strict security controls:

**Access Requirements:**

- Admin role with `support-team` Vault policy

- Re-authentication required (password + 2FA)

- Time-limited access (15-minute session)

- All access logged in audit trail

**Retrieval Workflow:**

```mermaid
sequenceDiagram
    participant Admin
    participant UI
    participant Backend
    participant Vault
    participant AuditLog

    Admin->>UI: Request SMTP Credentials
    UI->>Backend: Verify Admin Role
    Backend-->>UI: Require Re-authentication
    Admin->>UI: Enter Password + 2FA Code
    UI->>Backend: Authenticate
    Backend->>Backend: Verify Credentials
    Backend->>Vault: Request SMTP Credentials
    Vault->>Vault: Check Access Policy
    Vault-->>Backend: Return Encrypted Credentials
    Backend->>Backend: Decrypt Password
    Backend->>AuditLog: Log Credential Access
    Backend-->>UI: Return Credentials (masked)
    UI->>Admin: Display Credentials (15-min timeout)
    Note over UI,Admin: Credentials auto-hidden after 15 minutes

```

**Implementation:**

```typescript
// API endpoint for admin credential retrieval
async function retrieveSmtpCredentials(
  tenantId: string,
  adminUserId: string,
  reauthToken: string
): Promise<SmtpCredentials> {
  // Verify admin role
  const admin = await verifyAdminRole(adminUserId);
  if (!admin.hasRole('support-team')) {
    throw new Error('Insufficient permissions');
  }

  // Verify re-authentication token
  const isValid = await verifyReauthToken(reauthToken, adminUserId);
  if (!isValid) {
    throw new Error('Re-authentication required');
  }

  // Retrieve credentials from Vault
  const vaultData = await vaultClient.read(`smtp/${tenantId}/admin`);

  // Decrypt password
  const decryptedPassword = await decryptPassword(
    vaultData.password,
    tenantId
  );

  // Log credential access
  await auditLog.create({
    event: 'smtp_credentials_accessed',
    tenant_id: tenantId,
    user_id: adminUserId,
    timestamp: new Date().toISOString(),
    ip_address: req.ip,
    user_agent: req.headers['user-agent']
  });

  // Return credentials with time-limited access
  return {
    username: vaultData.username,
    password: decryptedPassword,
    webmail_url: vaultData.webmail_url,
    expires_at: new Date(Date.now() + 15 * 60 * 1000) // 15 minutes
  };
}

```
