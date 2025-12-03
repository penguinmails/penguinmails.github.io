---
title: "Vault-Governed VPS Migration Workflow"
description: "Tenant VPS migration runbook leveraging Vault-stored secrets and automated remediation scripts"
last_modified_date: "2025-12-04"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "vps", "migration", "secrets management", "mailu"]
---

# VPS Migration Workflow

## Scenario: Compromised or Failed VPS

When a tenant VPS fails or becomes compromised, this workflow provisions a replacement node, rehydrates required secrets from Vault, and validates service continuity within the one-hour RTO target.

```mermaid
sequenceDiagram
    participant Admin
    participant Backend
    participant Vault
    participant OldVPS
    participant NewVPS
    participant DNS

    Admin->>Backend: Report VPS compromise
    Backend->>Backend: Provision new VPS
    Backend->>Vault: Retrieve stored secrets
    Vault-->>Backend: SSH keys, SMTP credentials, DKIM keys
    Backend->>NewVPS: Configure SSH access
    Backend->>NewVPS: Install MailU
    Backend->>NewVPS: Configure SMTP credentials
    Backend->>NewVPS: Install DKIM keys
    Backend->>DNS: Update A records
    Backend->>OldVPS: Wipe disk (if accessible)
    Backend->>OldVPS: Destroy instance
    Backend-->>Admin: Migration complete
    Note over Admin,Backend: RTO target 1 hour; RPO target 0 hours
```

## Implementation

```typescript
// Migrate tenant to new VPS after compromise
async function migrateToNewVps(
  tenantId: string,
  reason: 'compromise' | 'failure' | 'upgrade'
): Promise<void> {
  const tenant = await getTenant(tenantId);
  const oldVpsIp = tenant.vps_ip;

  try {
    // Step 1: Provision new VPS from Hostwind
    console.log(`[${tenantId}] Provisioning new VPS...`);
    const newVps = await hostwindClient.provisionVps({
      plan: tenant.plan,
      region: tenant.region
    });

    // Step 2: Retrieve all secrets from Vault
    console.log(`[${tenantId}] Retrieving secrets from Vault...`);
    const adminSshKey = await vaultClient.read(`vps/${tenantId}/admin_ssh`);
    const tenantSshKey = await vaultClient.read(`vps/${tenantId}/tenant_ssh`);
    const smtpCreds = await vaultClient.read(`smtp/${tenantId}/admin`);
    const dkimKeys = await vaultClient.list(`dkim/${tenant.domain}`);

    // Step 3: Configure SSH access on new VPS
    console.log(`[${tenantId}] Configuring SSH access...`);
    await configureSshAccess(newVps.ip, [
      adminSshKey.public_key,
      tenantSshKey.public_key
    ]);

    // Step 4: Install and configure MailU
    console.log(`[${tenantId}] Installing MailU...`);
    const decryptedPassword = await decryptPassword(smtpCreds.password, tenantId);
    await installMailU(newVps.ip, {
      domain: tenant.domain,
      adminUsername: smtpCreds.username,
      adminPassword: decryptedPassword
    });

    // Step 5: Install DKIM keys
    console.log(`[${tenantId}] Installing DKIM keys...`);
    for (const selector of dkimKeys) {
      const dkimKey = await vaultClient.read(`dkim/${tenant.domain}/${selector}`);
      await installDkimKey(newVps.ip, tenant.domain, selector, dkimKey.private_key);
    }

    // Step 6: Update DNS records
    console.log(`[${tenantId}] Updating DNS records...`);
    await updateDnsRecords(tenant.domain, {
      A: newVps.ip,
      MX: `mail.${tenant.domain}`
    });

    // Step 7: Verify email sending works
    console.log(`[${tenantId}] Verifying email functionality...`);
    const testResult = await sendTestEmail(newVps.ip, tenant.domain);
    if (!testResult.success) {
      throw new Error(`Email test failed: ${testResult.error}`);
    }

    // Step 8: Update tenant record
    await updateTenant(tenantId, {
      vps_ip: newVps.ip,
      vps_id: newVps.id,
      migrated_at: new Date().toISOString(),
      migration_reason: reason
    });

    // Step 9: Destroy old VPS (if accessible)
    if (reason === 'compromise') {
      console.log(`[${tenantId}] Wiping and destroying old VPS...`);
      try {
        await wipeVpsDisk(oldVpsIp, adminSshKey.private_key);
      } catch (error) {
        console.warn(`Failed to wipe old VPS: ${error.message}`);
      }
      await hostwindClient.destroyVps(tenant.old_vps_id);
    }

    // Step 10: Log migration event
    await auditLog.create({
      event: 'vps_migration_completed',
      tenant_id: tenantId,
      timestamp: new Date().toISOString(),
      details: {
        old_vps_ip: oldVpsIp,
        new_vps_ip: newVps.ip,
        reason: reason,
        secrets_recovered: ['ssh_keys', 'smtp_creds', 'dkim_keys']
      }
    });

    // Step 11: Notify tenant
    await sendTenantNotification(tenantId, {
      type: 'vps_migration_complete',
      subject: 'VPS migration completed',
      message: `Your VPS has been migrated to a new server. New IP: ${newVps.ip}. All secrets recovered from Vault.`
    });

    console.log(`[${tenantId}] VPS migration completed successfully`);
  } catch (error) {
    // Log migration failure
    await auditLog.create({
      event: 'vps_migration_failed',
      tenant_id: tenantId,
      timestamp: new Date().toISOString(),
      severity: 'critical',
      details: {
        error: error.message,
        old_vps_ip: oldVpsIp
      }
    });

    // Alert admins
    await sendAlert({
      type: 'vps_migration_failure',
      severity: 'critical',
      tenant_id: tenantId,
      message: `VPS migration failed: ${error.message}`
    });

    throw error;
  }
}
```

## SMTP Credential Recovery

```typescript
// Recover SMTP credentials to new VPS
async function recoverSmtpCredentialsToNewVps(
  tenantId: string,
  newVpsIp: string
): Promise<void> {
  // Retrieve SMTP credentials from Vault
  const smtpCreds = await vaultClient.read(`smtp/${tenantId}/admin`);

  // Decrypt password
  const decryptedPassword = await decryptPassword(smtpCreds.password, tenantId);

  // Configure MailU on new VPS with recovered credentials
  await configureMailU(newVpsIp, {
    username: smtpCreds.username,
    password: decryptedPassword,
    webmail_url: smtpCreds.webmail_url
  });

  // Verify MailU is accessible
  const isAccessible = await verifyMailUAccess(
    smtpCreds.webmail_url,
    smtpCreds.username,
    decryptedPassword
  );

  if (!isAccessible) {
    throw new Error('Failed to verify MailU access after recovery');
  }

  // Log recovery event
  await auditLog.create({
    event: 'smtp_credentials_recovered',
    tenant_id: tenantId,
    timestamp: new Date().toISOString(),
    details: {
      new_vps_ip: newVpsIp,
      recovery_type: 'vps_migration'
    }
  });
}
```

**Reference:** Review [Vault SMTP Credential Storage](/docs/features/infrastructure/vault-smtp-credentials) for additional recovery actions covering cluster restoration and credential compromise investigations.
