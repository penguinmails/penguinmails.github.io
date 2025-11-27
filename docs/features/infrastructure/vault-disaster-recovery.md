---
title: "Vault Disaster Recovery Procedures"
description: "Comprehensive disaster recovery procedures for HashiCorp Vault including automated backups, VPS migration, secret recovery, and emergency response workflows"
last_modified_date: "2025-11-26"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "disaster recovery", "backup", "restore", "high availability", "failover", "incident response"]
---


# Vault Disaster Recovery Procedures


## Overview

This document provides comprehensive disaster recovery procedures for HashiCorp Vault, the centralized secrets management system for PenguinMails. It covers automated backup strategies, recovery workflows for various failure scenarios, high availability configuration, and monitoring/alerting for Vault health.


### Purpose

Vault stores all critical secrets for the PenguinMails platform:


- VPS SSH keys (admin and tenant access)


- SMTP credentials (MailU admin passwords)


- API keys (tenant programmatic access)


- DKIM private keys (email signing)

Loss of Vault data would be catastrophic, preventing:


- VPS access and management


- Email sending operations


- API authentication


- Infrastructure provisioning

This document ensures rapid recovery from any Vault failure scenario with minimal data loss and service disruption.


### Recovery Objectives

| Scenario | RTO (Recovery Time Objective) | RPO (Recovery Point Objective) | Impact |
|----------|-------------------------------|--------------------------------|--------|
| Vault Server Failure | 30 minutes | 0 (HA cluster) | None (automatic failover) |
| VPS Compromise | 1 hour | 0 (secrets in Vault) | Single tenant affected |
| Vault Compromise | 2-4 hours | 24 hours (daily backups) | All tenants (API keys revoked) |
| Complete Data Center Loss | 4-6 hours | 24 hours (daily backups) | All services affected |


## Automated Backup Strategy


### Backup Schedule

**Daily Backups:**


- **Frequency:** Every day at 02:00 UTC


- **Retention:** 30 daily backups (rolling window)


- **Storage:** Encrypted S3 bucket (or equivalent object storage)


- **Encryption:** AES-256-GCM with separate encryption key


- **Verification:** Automated integrity check after each backup

**Monthly Backups:**


- **Frequency:** First day of each month at 02:00 UTC


- **Retention:** 12 monthly backups (1 year)


- **Storage:** Same encrypted S3 bucket, separate prefix


- **Purpose:** Long-term recovery and compliance

**Backup Naming Convention:**


```

s3://penguinmails-vault-backups/
├── daily/
│   ├── 2025-11-26/vault-snapshot-20251126-020000.enc
│   ├── 2025-11-25/vault-snapshot-20251125-020000.enc
│   └── ...
└── monthly/
    ├── 2025-11/vault-snapshot-20251101-020000.enc
    ├── 2025-10/vault-snapshot-20251001-020000.enc
    └── ...


```


### Backup Process

**Automated Backup Workflow:**


```mermaid
sequenceDiagram
    participant Cron
    participant BackupService
    participant Vault
    participant S3
    participant Monitoring
    
    Cron->>BackupService: Trigger Backup (02:00 UTC)
    BackupService->>Vault: Take Snapshot
    Vault-->>BackupService: Return Snapshot Data
    BackupService->>BackupService: Encrypt Snapshot (AES-256-GCM)
    BackupService->>S3: Upload Encrypted Snapshot
    S3-->>BackupService: Confirm Upload
    BackupService->>BackupService: Verify Checksum
    BackupService->>BackupService: Delete Local Snapshot
    BackupService->>Monitoring: Log Backup Success
    BackupService->>Monitoring: Send Notification
    
    alt Backup Failure
        BackupService->>Monitoring: Alert Admins
        BackupService->>Monitoring: Log Error Details
    end


```

**Implementation:**


```typescript
// Automated backup service (runs daily at 02:00 UTC)
async function performVaultBackup(): Promise<void> {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backupDate = new Date().toISOString().split('T')[0];
  const isMonthly = new Date().getDate() === 1;
  
  try {
    // Take Vault snapshot
    console.log(`[${timestamp}] Starting Vault backup...`);
    const snapshot = await vaultClient.sys.snapshot();
    
    // Encrypt snapshot with AES-256-GCM
    const encryptedSnapshot = await encryptBackup(snapshot, backupEncryptionKey);
    
    // Generate checksum for integrity verification
    const checksum = crypto.createHash('sha256').update(encryptedSnapshot).digest('hex');
    
    // Determine backup path (daily or monthly)
    const backupPath = isMonthly
      ? `monthly/${backupDate}/vault-snapshot-${timestamp}.enc`
      : `daily/${backupDate}/vault-snapshot-${timestamp}.enc`;
    
    // Upload to S3
    await s3.putObject({
      Bucket: 'penguinmails-vault-backups',
      Key: backupPath,
      Body: encryptedSnapshot,
      Metadata: {
        checksum: checksum,
        timestamp: timestamp,
        vault_version: await vaultClient.sys.health().version
      }
    });
    
    // Verify upload integrity
    const uploadedObject = await s3.headObject({
      Bucket: 'penguinmails-vault-backups',
      Key: backupPath
    });
    
    if (uploadedObject.Metadata.checksum !== checksum) {
      throw new Error('Backup checksum mismatch after upload');
    }
    
    // Delete local snapshot file
    await fs.unlink(`/tmp/vault-snapshot-${timestamp}`);
    
    // Log backup success
    await auditLog.create({
      event: 'vault_backup_completed',
      timestamp: new Date().toISOString(),
      details: {
        backup_path: backupPath,
        checksum: checksum,
        size_bytes: encryptedSnapshot.length,
        backup_type: isMonthly ? 'monthly' : 'daily'
      }
    });
    
    // Send success notification
    await sendNotification({
      type: 'vault_backup_success',
      message: `Vault backup completed successfully: ${backupPath}`,
      timestamp: timestamp
    });
    
    console.log(`[${timestamp}] Vault backup completed: ${backupPath}`);
    
  } catch (error) {
    // Log backup failure
    await auditLog.create({
      event: 'vault_backup_failed',
      timestamp: new Date().toISOString(),
      severity: 'critical',
      details: {
        error: error.message,
        stack: error.stack
      }
    });
    
    // Alert admins immediately
    await sendAlert({
      type: 'vault_backup_failure',
      severity: 'critical',
      message: `Vault backup failed: ${error.message}`,
      timestamp: timestamp
    });
    
    throw error;
  }
}

// Encrypt backup with AES-256-GCM
async function encryptBackup(
  snapshot: Buffer,
  encryptionKey: Buffer
): Promise<Buffer> {
  // Generate random IV
  const iv = crypto.randomBytes(16);
  
  // Create cipher
  const cipher = crypto.createCipheriv('aes-256-gcm', encryptionKey, iv);
  
  // Encrypt snapshot
  const encrypted = Buffer.concat([
    cipher.update(snapshot),
    cipher.final()
  ]);
  
  // Get authentication tag
  const authTag = cipher.getAuthTag();
  
  // Return: IV + authTag + encrypted data
  return Buffer.concat([iv, authTag, encrypted]);
}


```


### Backup Retention Policy

**Automated Cleanup:**


```typescript
// Clean up old backups (runs daily after backup)
async function cleanupOldBackups(): Promise<void> {
  const now = new Date();
  
  // Clean up daily backups older than 30 days
  const dailyBackups = await s3.listObjectsV2({
    Bucket: 'penguinmails-vault-backups',
    Prefix: 'daily/'
  });
  
  for (const backup of dailyBackups.Contents) {
    const backupDate = new Date(backup.LastModified);
    const ageInDays = (now.getTime() - backupDate.getTime()) / (1000 * 60 * 60 * 24);
    
    if (ageInDays > 30) {
      await s3.deleteObject({
        Bucket: 'penguinmails-vault-backups',
        Key: backup.Key
      });
      
      console.log(`Deleted old daily backup: ${backup.Key}`);
    }
  }
  
  // Clean up monthly backups older than 12 months
  const monthlyBackups = await s3.listObjectsV2({
    Bucket: 'penguinmails-vault-backups',
    Prefix: 'monthly/'
  });
  
  for (const backup of monthlyBackups.Contents) {
    const backupDate = new Date(backup.LastModified);
    const ageInMonths = (now.getTime() - backupDate.getTime()) / (1000 * 60 * 60 * 24 * 30);
    
    if (ageInMonths > 12) {
      await s3.deleteObject({
        Bucket: 'penguinmails-vault-backups',
        Key: backup.Key
      });
      
      console.log(`Deleted old monthly backup: ${backup.Key}`);
    }
  }
}


```


### Backup Verification

**Weekly Restore Test:**


```typescript
// Test backup restoration to staging environment (runs weekly)
async function testBackupRestoration(): Promise<void> {
  try {
    // Get latest daily backup
    const latestBackup = await getLatestBackup('daily');
    
    // Download encrypted backup
    const encryptedBackup = await s3.getObject({
      Bucket: 'penguinmails-vault-backups',
      Key: latestBackup.Key
    });
    
    // Decrypt backup
    const decryptedBackup = await decryptBackup(
      encryptedBackup.Body,
      backupEncryptionKey
    );
    
    // Restore to staging Vault instance
    await stagingVaultClient.sys.restore(decryptedBackup);
    
    // Verify secrets are accessible
    const testTenantId = 'test-tenant-id';
    const testSecret = await stagingVaultClient.read(`smtp/${testTenantId}/admin`);
    
    if (!testSecret) {
      throw new Error('Test secret not found after restoration');
    }
    
    // Log successful test
    await auditLog.create({
      event: 'vault_backup_test_success',
      timestamp: new Date().toISOString(),
      details: {
        backup_tested: latestBackup.Key,
        staging_vault: 'vault-staging.penguinmails.com'
      }
    });
    
    console.log('Backup restoration test successful');
    
  } catch (error) {
    // Alert admins of test failure
    await sendAlert({
      type: 'vault_backup_test_failure',
      severity: 'high',
      message: `Backup restoration test failed: ${error.message}`
    });
    
    throw error;
  }
}


```


## VPS Migration Workflow


### Scenario: Compromised or Failed VPS

When a VPS is compromised or fails, secrets can be rapidly recovered from Vault to a new VPS without data loss.

**Migration Process:**


```mermaid
sequenceDiagram
    participant Admin
    participant Backend
    participant Vault
    participant OldVPS
    participant NewVPS
    participant DNS
    
    Admin->>Backend: Report VPS Compromise
    Backend->>Backend: Provision New VPS
    Backend->>Vault: Retrieve All Secrets
    Vault-->>Backend: SSH Keys, SMTP Creds, DKIM Keys
    Backend->>NewVPS: Configure SSH Access
    Backend->>NewVPS: Install MailU
    Backend->>NewVPS: Configure SMTP Credentials
    Backend->>NewVPS: Install DKIM Keys
    Backend->>DNS: Update A Records
    Backend->>OldVPS: Wipe Disk (if accessible)
    Backend->>OldVPS: Destroy Instance
    Backend-->>Admin: Migration Complete
    Note over Admin,Backend: RTO: 1 hour, RPO: 0


```

**Implementation:**


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
      subject: 'VPS Migration Completed',
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


### SMTP Credential Recovery

**Specific SMTP Recovery Workflow:**

When recovering SMTP credentials during VPS migration, follow these steps:


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

**Reference:** See [SMTP Credentials Vault Storage](vault-smtp-credentials.md) for detailed SMTP disaster recovery scenarios including:


- VPS failure recovery


- Vault restoration


- Credential compromise response


## Secret Recovery Procedures


### Quarterly Disaster Recovery Drills

**Purpose:** Validate that all disaster recovery procedures work correctly and teams are prepared for actual incidents.

**Schedule:** Every quarter (January, April, July, October)

**Drill Scenarios:**


1. **Scenario 1: Vault Server Failure**


   - Simulate Vault server crash


   - Test automatic failover to standby node


   - Verify all services reconnect successfully


   - Measure actual RTO (target: < 30 minutes)


2. **Scenario 2: Complete Vault Cluster Loss**


   - Simulate loss of all Vault nodes


   - Restore Vault from latest backup


   - Verify all secrets accessible


   - Measure actual RTO (target: < 2 hours)


3. **Scenario 3: VPS Compromise**


   - Simulate VPS compromise for test tenant


   - Migrate to new VPS using Vault secrets


   - Verify email sending works


   - Measure actual RTO (target: < 1 hour)


4. **Scenario 4: Credential Compromise**


   - Simulate SMTP credential leak


   - Execute emergency rotation workflow


   - Verify zero downtime


   - Measure rotation time (target: < 5 minutes)

**Drill Execution:**


```typescript
// Execute quarterly disaster recovery drill
async function executeDrDrill(
  scenario: 'vault_failure' | 'cluster_loss' | 'vps_compromise' | 'credential_compromise'
): Promise<DrillResult> {
  const startTime = Date.now();
  const drillId = `DR-${new Date().toISOString().split('T')[0]}-${scenario}`;
  
  console.log(`[${drillId}] Starting disaster recovery drill: ${scenario}`);
  
  try {
    let result: DrillResult;
    
    switch (scenario) {
      case 'vault_failure':
        result = await drillVaultFailure();
        break;
      case 'cluster_loss':
        result = await drillClusterLoss();
        break;
      case 'vps_compromise':
        result = await drillVpsCompromise();
        break;
      case 'credential_compromise':
        result = await drillCredentialCompromise();
        break;
    }
    
    const duration = Date.now() - startTime;
    
    // Log drill results
    await auditLog.create({
      event: 'dr_drill_completed',
      timestamp: new Date().toISOString(),
      details: {
        drill_id: drillId,
        scenario: scenario,
        duration_ms: duration,
        success: result.success,
        rto_met: result.rto_met,
        issues: result.issues
      }
    });
    
    // Generate drill report
    await generateDrillReport(drillId, scenario, result, duration);
    
    console.log(`[${drillId}] Drill completed in ${duration}ms`);
    
    return result;
    
  } catch (error) {
    // Log drill failure
    await auditLog.create({
      event: 'dr_drill_failed',
      timestamp: new Date().toISOString(),
      severity: 'high',
      details: {
        drill_id: drillId,
        scenario: scenario,
        error: error.message
      }
    });
    
    throw error;
  }
}

// Drill: Vault server failure with automatic failover
async function drillVaultFailure(): Promise<DrillResult> {
  const startTime = Date.now();
  
  // Simulate Vault server failure (stop active node)
  await stopVaultNode('vault-node-1');
  
  // Wait for automatic failover
  await waitForFailover(30000); // 30 second timeout
  
  // Verify standby node became active
  const activeNode = await getActiveVaultNode();
  if (activeNode !== 'vault-node-2' && activeNode !== 'vault-node-3') {
    throw new Error('Failover did not occur');
  }
  
  // Verify secrets are accessible
  const testSecret = await vaultClient.read('smtp/test-tenant/admin');
  if (!testSecret) {
    throw new Error('Secrets not accessible after failover');
  }
  
  // Restart failed node
  await startVaultNode('vault-node-1');
  
  const duration = Date.now() - startTime;
  const rtoMet = duration < 30 * 60 * 1000; // 30 minutes
  
  return {
    success: true,
    rto_met: rtoMet,
    duration_ms: duration,
    issues: []
  };
}


```


## Vault Restoration from Backup


### Step-by-Step Runbook

**Prerequisites:**


- Access to S3 backup bucket


- Backup encryption key


- Vault unseal keys (3 of 5 required)


- Root token or admin credentials

**Restoration Steps:**


#### Step 1: Provision New Vault Server


```bash


# Provision new server (if needed)


# Install Vault

wget https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip
unzip vault_1.15.0_linux_amd64.zip
sudo mv vault /usr/local/bin/


# Create Vault configuration

sudo mkdir -p /etc/vault
sudo cat > /etc/vault/config.hcl <<EOF
storage "postgresql" {
  connection_url = "postgres://vault:password@localhost:5432/vault"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/tls/vault.crt"
  tls_key_file  = "/etc/vault/tls/vault.key"
}

api_addr = "https://vault.penguinmails.com:8200"
cluster_addr = "https://vault.penguinmails.com:8201"
ui = true
EOF


# Start Vault service

sudo systemctl enable vault
sudo systemctl start vault


```


#### Step 2: Download Latest Backup


```bash


# Set backup date (or use latest)

BACKUP_DATE=$(date +%Y-%m-%d)


# Download encrypted backup from S3

aws s3 cp \
  s3://penguinmails-vault-backups/daily/${BACKUP_DATE}/vault-snapshot-*.enc \
  /tmp/vault-backup.enc


# Verify backup exists

if [ ! -f /tmp/vault-backup.enc ]; then
  echo "ERROR: Backup not found for date ${BACKUP_DATE}"
  exit 1
fi

echo "Backup downloaded: /tmp/vault-backup.enc"


```


#### Step 3: Decrypt Backup


```bash


# Decrypt backup with encryption key


# (Encryption key should be stored securely, separate from backups)


# Using OpenSSL

openssl enc -d -aes-256-gcm \
  -in /tmp/vault-backup.enc \
  -out /tmp/vault-backup.snap \
  -K ${BACKUP_ENCRYPTION_KEY} \
  -iv ${BACKUP_IV}


# Verify decryption succeeded

if [ ! -f /tmp/vault-backup.snap ]; then
  echo "ERROR: Backup decryption failed"
  exit 1
fi

echo "Backup decrypted: /tmp/vault-backup.snap"


```


#### Step 4: Initialize Vault


```bash


# Initialize Vault (if new server)

vault operator init -key-shares=5 -key-threshold=3


# IMPORTANT: Save unseal keys and root token securely!


# Example output:


# Unseal Key 1: abc123...


# Unseal Key 2: def456...


# Unseal Key 3: ghi789...


# Unseal Key 4: jkl012...


# Unseal Key 5: mno345...


# Initial Root Token: s.xyz789...


```


#### Step 5: Unseal Vault


```bash


# Unseal Vault with 3 of 5 keys

vault operator unseal <unseal-key-1>
vault operator unseal <unseal-key-2>
vault operator unseal <unseal-key-3>


# Verify Vault is unsealed

vault status


# Output should show: Sealed: false


```


#### Step 6: Restore Snapshot


```bash


# Login with root token

vault login <root-token>


# Restore snapshot

vault operator raft snapshot restore /tmp/vault-backup.snap


# Verify restoration

vault status


```


#### Step 7: Verify Secrets


```bash


# Test secret retrieval

vault kv get vps/test-tenant-id/admin_ssh
vault kv get smtp/test-tenant-id/admin
vault kv get api_keys/test-tenant-id/test-key-id


# If secrets are accessible, restoration succeeded

echo "Vault restoration completed successfully"


```


#### Step 8: Update DNS and Services


```bash


# Update DNS to point to new Vault server


# Update all services to use new Vault URL


# Restart services to reconnect to Vault

sudo systemctl restart penguinmails-backend
sudo systemctl restart penguinmails-rotation-service


# Verify services can access Vault

curl -H "X-Vault-Token: ${VAULT_TOKEN}" \
  https://vault.penguinmails.com:8200/v1/sys/health


```


#### Step 9: Cleanup


```bash


# Delete local backup files

rm /tmp/vault-backup.enc
rm /tmp/vault-backup.snap


# Log restoration event

echo "Vault restored from backup: ${BACKUP_DATE}" >> /var/log/vault/restoration.log


```


### Automated Restoration Script


```typescript
// Automated Vault restoration from backup
async function restoreVaultFromBackup(
  backupDate?: string
): Promise<void> {
  const date = backupDate || new Date().toISOString().split('T')[0];
  
  try {
    console.log(`Starting Vault restoration from backup: ${date}`);
    
    // Step 1: Download encrypted backup from S3
    const backupKey = `daily/${date}/vault-snapshot-${date}.enc`;
    const encryptedBackup = await s3.getObject({
      Bucket: 'penguinmails-vault-backups',
      Key: backupKey
    });
    
    if (!encryptedBackup.Body) {
      throw new Error(`Backup not found for date: ${date}`);
    }
    
    // Step 2: Decrypt backup
    const decryptedBackup = await decryptBackup(
      encryptedBackup.Body,
      backupEncryptionKey
    );
    
    // Step 3: Verify checksum
    const checksum = crypto.createHash('sha256').update(decryptedBackup).digest('hex');
    if (checksum !== encryptedBackup.Metadata.checksum) {
      throw new Error('Backup checksum mismatch');
    }
    
    // Step 4: Restore Vault snapshot
    await vaultClient.sys.restore(decryptedBackup);
    
    // Step 5: Verify secrets are accessible
    const testTenantId = 'test-tenant-id';
    const testSecret = await vaultClient.read(`smtp/${testTenantId}/admin`);
    
    if (!testSecret) {
      throw new Error('Test secret not found after restoration');
    }
    
    // Step 6: Log restoration event
    await auditLog.create({
      event: 'vault_restored_from_backup',
      timestamp: new Date().toISOString(),
      details: {
        backup_date: date,
        backup_key: backupKey,
        checksum: checksum
      }
    });
    
    // Step 7: Notify admins
    await sendNotification({
      type: 'vault_restoration_success',
      message: `Vault restored successfully from backup: ${date}`,
      timestamp: new Date().toISOString()
    });
    
    console.log(`Vault restoration completed successfully from backup: ${date}`);
    
  } catch (error) {
    // Log restoration failure
    await auditLog.create({
      event: 'vault_restoration_failed',
      timestamp: new Date().toISOString(),
      severity: 'critical',
      details: {
        backup_date: date,
        error: error.message
      }
    });
    
    // Alert admins
    await sendAlert({
      type: 'vault_restoration_failure',
      severity: 'critical',
      message: `Vault restoration failed: ${error.message}`,
      backup_date: date
    });
    
    throw error;
  }
}

// Decrypt backup
async function decryptBackup(
  encryptedData: Buffer,
  encryptionKey: Buffer
): Promise<Buffer> {
  // Extract IV, auth tag, and encrypted data
  const iv = encryptedData.slice(0, 16);
  const authTag = encryptedData.slice(16, 32);
  const encrypted = encryptedData.slice(32);
  
  // Create decipher
  const decipher = crypto.createDecipheriv('aes-256-gcm', encryptionKey, iv);
  decipher.setAuthTag(authTag);
  
  // Decrypt data
  const decrypted = Buffer.concat([
    decipher.update(encrypted),
    decipher.final()
  ]);
  
  return decrypted;
}


```


## High Availability Setup


### 3-Node Vault Cluster

**Architecture:**


```mermaid
graph TB
    subgraph "Load Balancer"
        LB[HAProxy / Nginx<br/>vault.penguinmails.com]
    end
    
    subgraph "Vault Cluster"
        V1[Vault Node 1<br/>Active<br/>10.0.1.10]
        V2[Vault Node 2<br/>Standby<br/>10.0.1.11]
        V3[Vault Node 3<br/>Standby<br/>10.0.1.12]
    end
    
    subgraph "Storage Backend"
        PG[(PostgreSQL<br/>Primary<br/>10.0.2.10)]
        PG_R1[(PostgreSQL<br/>Replica 1<br/>10.0.2.11)]
        PG_R2[(PostgreSQL<br/>Replica 2<br/>10.0.2.12)]
    end
    
    subgraph "Backup Storage"
        S3[S3 Bucket<br/>Encrypted Backups]
    end
    
    LB --> V1
    LB --> V2
    LB --> V3
    
    V1 --> PG
    V2 --> PG
    V3 --> PG
    
    PG --> PG_R1
    PG --> PG_R2
    
    V1 -.Daily Backup.-> S3
    
    style V1 fill:#99ff99
    style V2 fill:#ffff99
    style V3 fill:#ffff99
    style PG fill:#99ccff
    style S3 fill:#ff9999


```


### Cluster Configuration

**Vault Node Configuration:**


```hcl


# /etc/vault/config.hcl (Node 1)

storage "postgresql" {
  connection_url = "postgres://vault:password@10.0.2.10:5432/vault"
  ha_enabled = "true"
}

listener "tcp" {
  address     = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/tls/vault.crt"
  tls_key_file  = "/etc/vault/tls/vault.key"
}

api_addr = "https://10.0.1.10:8200"
cluster_addr = "https://10.0.1.10:8201"


# Raft storage for HA

storage "raft" {
  path = "/opt/vault/data"
  node_id = "vault-node-1"
  
  retry_join {
    leader_api_addr = "https://10.0.1.10:8200"
  }
  retry_join {
    leader_api_addr = "https://10.0.1.11:8200"
  }
  retry_join {
    leader_api_addr = "https://10.0.1.12:8200"
  }
}

ui = true


```

**Load Balancer Configuration (HAProxy):**


```haproxy


# /etc/haproxy/haproxy.cfg

global
    log /dev/log local0
    maxconn 4096
    
defaults
    log global
    mode http
    option httplog
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend vault_frontend
    bind *:8200 ssl crt /etc/haproxy/certs/vault.pem
    default_backend vault_backend

backend vault_backend
    balance roundrobin
    option httpchk GET /v1/sys/health
    http-check expect status 200
    
    server vault-node-1 10.0.1.10:8200 check ssl verify none
    server vault-node-2 10.0.1.11:8200 check ssl verify none backup
    server vault-node-3 10.0.1.12:8200 check ssl verify none backup


```


### Automatic Failover

**Failover Process:**


```mermaid
sequenceDiagram
    participant Client
    participant LB as Load Balancer
    participant V1 as Vault Node 1 (Active)
    participant V2 as Vault Node 2 (Standby)
    participant V3 as Vault Node 3 (Standby)
    
    Client->>LB: Request Secret
    LB->>V1: Forward Request
    V1--xLB: Node Failure
    LB->>LB: Health Check Failed
    LB->>V2: Promote to Active
    V2->>V2: Become Leader
    LB->>V2: Forward Request
    V2-->>LB: Return Secret
    LB-->>Client: Return Secret
    Note over Client,V3: Failover completed in < 30 seconds


```

**Failover Implementation:**


```typescript
// Monitor Vault cluster health
async function monitorVaultClusterHealth(): Promise<void> {
  const nodes = [
    { id: 'vault-node-1', url: 'https://10.0.1.10:8200' },
    { id: 'vault-node-2', url: 'https://10.0.1.11:8200' },
    { id: 'vault-node-3', url: 'https://10.0.1.12:8200' }
  ];
  
  for (const node of nodes) {
    try {
      const health = await axios.get(`${node.url}/v1/sys/health`);
      
      // Log node status
      await auditLog.create({
        event: 'vault_node_health_check',
        timestamp: new Date().toISOString(),
        details: {
          node_id: node.id,
          status: health.data.initialized ? 'healthy' : 'unhealthy',
          sealed: health.data.sealed,
          standby: health.data.standby
        }
      });
      
      // Alert if node is sealed
      if (health.data.sealed) {
        await sendAlert({
          type: 'vault_node_sealed',
          severity: 'high',
          node_id: node.id,
          message: `Vault node ${node.id} is sealed`
        });
      }
      
    } catch (error) {
      // Node is unreachable
      await auditLog.create({
        event: 'vault_node_unreachable',
        timestamp: new Date().toISOString(),
        severity: 'high',
        details: {
          node_id: node.id,
          error: error.message
        }
      });
      
      // Alert admins
      await sendAlert({
        type: 'vault_node_failure',
        severity: 'critical',
        node_id: node.id,
        message: `Vault node ${node.id} is unreachable`
      });
    }
  }
}


```


## Monitoring and Alerting


### Vault Health Monitoring

**Metrics to Monitor:**


1. **Seal Status** - Vault must be unsealed to serve requests


2. **Leader Status** - One node must be active leader


3. **Replication Lag** - Standby nodes must stay in sync


4. **Request Latency** - Secret retrieval should be < 100ms


5. **Error Rate** - Failed requests should be < 0.1%


6. **Storage Usage** - PostgreSQL disk usage


7. **Backup Status** - Daily backups must succeed

**Monitoring Implementation:**


```typescript
// Comprehensive Vault health monitoring
async function monitorVaultHealth(): Promise<VaultHealthStatus> {
  const health: VaultHealthStatus = {
    timestamp: new Date().toISOString(),
    overall_status: 'healthy',
    checks: []
  };
  
  try {
    // Check 1: Seal Status
    const sealStatus = await vaultClient.sys.sealStatus();
    health.checks.push({
      name: 'seal_status',
      status: sealStatus.sealed ? 'unhealthy' : 'healthy',
      details: {
        sealed: sealStatus.sealed,
        threshold: sealStatus.t,
        shares: sealStatus.n
      }
    });
    
    if (sealStatus.sealed) {
      health.overall_status = 'unhealthy';
      await sendAlert({
        type: 'vault_sealed',
        severity: 'critical',
        message: 'Vault is sealed and cannot serve requests'
      });
    }
    
    // Check 2: Leader Status
    const leaderStatus = await vaultClient.sys.leader();
    health.checks.push({
      name: 'leader_status',
      status: leaderStatus.ha_enabled ? 'healthy' : 'warning',
      details: {
        ha_enabled: leaderStatus.ha_enabled,
        is_self: leaderStatus.is_self,
        leader_address: leaderStatus.leader_address
      }
    });
    
    // Check 3: Replication Lag
    const replicationStatus = await vaultClient.sys.replicationStatus();
    const replicationLag = replicationStatus.data?.secondaries?.[0]?.last_wal || 0;
    health.checks.push({
      name: 'replication_lag',
      status: replicationLag < 10 ? 'healthy' : 'warning',
      details: {
        lag_seconds: replicationLag
      }
    });
    
    if (replicationLag > 60) {
      await sendAlert({
        type: 'vault_replication_lag',
        severity: 'high',
        message: `Vault replication lag is ${replicationLag} seconds`
      });
    }
    
    // Check 4: Request Latency
    const latencyStart = Date.now();
    await vaultClient.read('sys/health');
    const latency = Date.now() - latencyStart;
    health.checks.push({
      name: 'request_latency',
      status: latency < 100 ? 'healthy' : 'warning',
      details: {
        latency_ms: latency
      }
    });
    
    // Check 5: Storage Usage
    const storageUsage = await getPostgresStorageUsage();
    health.checks.push({
      name: 'storage_usage',
      status: storageUsage.percent < 80 ? 'healthy' : 'warning',
      details: {
        used_gb: storageUsage.used_gb,
        total_gb: storageUsage.total_gb,
        percent: storageUsage.percent
      }
    });
    
    if (storageUsage.percent > 90) {
      await sendAlert({
        type: 'vault_storage_full',
        severity: 'high',
        message: `Vault storage is ${storageUsage.percent}% full`
      });
    }
    
    // Check 6: Backup Status
    const lastBackup = await getLastBackupStatus();
    const hoursSinceBackup = (Date.now() - lastBackup.timestamp) / (1000 * 60 * 60);
    health.checks.push({
      name: 'backup_status',
      status: hoursSinceBackup < 25 ? 'healthy' : 'unhealthy',
      details: {
        last_backup: lastBackup.timestamp,
        hours_since_backup: hoursSinceBackup,
        backup_success: lastBackup.success
      }
    });
    
    if (hoursSinceBackup > 25) {
      await sendAlert({
        type: 'vault_backup_overdue',
        severity: 'high',
        message: `Vault backup is ${hoursSinceBackup} hours overdue`
      });
    }
    
    // Log health status
    await auditLog.create({
      event: 'vault_health_check',
      timestamp: health.timestamp,
      details: health
    });
    
    return health;
    
  } catch (error) {
    health.overall_status = 'unhealthy';
    health.checks.push({
      name: 'health_check_error',
      status: 'unhealthy',
      details: {
        error: error.message
      }
    });
    
    await sendAlert({
      type: 'vault_health_check_failed',
      severity: 'critical',
      message: `Vault health check failed: ${error.message}`
    });
    
    return health;
  }
}


```


### Alert Configuration

**Alert Severity Levels:**

| Severity | Response Time | Notification Channels | Example |
|----------|--------------|----------------------|---------|
| **Critical** | Immediate (< 5 min) | Email, Slack, PagerDuty | Vault sealed, cluster down |
| **High** | 15 minutes | Email, Slack | Replication lag > 60s, backup failed |
| **Medium** | 1 hour | Email | Storage > 80%, latency > 100ms |
| **Low** | 24 hours | Email | Routine maintenance needed |

**Alert Rules:**


```typescript
// Alert configuration
const alertRules = [
  {
    name: 'vault_sealed',
    condition: (health) => health.checks.find(c => c.name === 'seal_status')?.details.sealed,
    severity: 'critical',
    message: 'Vault is sealed and cannot serve requests',
    action: 'Unseal Vault immediately with unseal keys'
  },
  {
    name: 'vault_node_failure',
    condition: (health) => health.checks.find(c => c.name === 'leader_status')?.status === 'unhealthy',
    severity: 'critical',
    message: 'Vault cluster has no active leader',
    action: 'Check cluster status and restart failed nodes'
  },
  {
    name: 'replication_lag_high',
    condition: (health) => health.checks.find(c => c.name === 'replication_lag')?.details.lag_seconds > 60,
    severity: 'high',
    message: 'Vault replication lag exceeds 60 seconds',
    action: 'Check network connectivity between nodes'
  },
  {
    name: 'backup_overdue',
    condition: (health) => health.checks.find(c => c.name === 'backup_status')?.details.hours_since_backup > 25,
    severity: 'high',
    message: 'Vault backup is overdue',
    action: 'Check backup service and manually trigger backup'
  },
  {
    name: 'storage_full',
    condition: (health) => health.checks.find(c => c.name === 'storage_usage')?.details.percent > 90,
    severity: 'high',
    message: 'Vault storage is over 90% full',
    action: 'Expand PostgreSQL storage or clean up old data'
  },
  {
    name: 'high_latency',
    condition: (health) => health.checks.find(c => c.name === 'request_latency')?.details.latency_ms > 100,
    severity: 'medium',
    message: 'Vault request latency exceeds 100ms',
    action: 'Check Vault and PostgreSQL performance'
  }
];

// Evaluate alert rules
async function evaluateAlertRules(health: VaultHealthStatus): Promise<void> {
  for (const rule of alertRules) {
    if (rule.condition(health)) {
      await sendAlert({
        type: rule.name,
        severity: rule.severity,
        message: rule.message,
        action: rule.action,
        timestamp: new Date().toISOString()
      });
    }
  }
}


```


### Grafana Dashboard

**Metrics to Display:**


1. **Vault Status Panel**


   - Seal status (sealed/unsealed)


   - Leader status (active/standby)


   - Cluster size (3 nodes)


2. **Performance Metrics**


   - Request rate (requests/second)


   - Request latency (p50, p95, p99)


   - Error rate (%)


3. **Storage Metrics**


   - PostgreSQL disk usage (GB)


   - Secret count by path


   - Backup size (GB)


4. **Replication Metrics**


   - Replication lag (seconds)


   - Standby node status


   - Last successful sync


5. **Backup Metrics**


   - Last backup timestamp


   - Backup success rate (%)


   - Backup size trend

**Prometheus Metrics:**


```yaml


# Vault metrics exposed at /v1/sys/metrics


- vault_core_unsealed (gauge)


- vault_core_leader (gauge)


- vault_runtime_alloc_bytes (gauge)


- vault_runtime_sys_bytes (gauge)


- vault_core_handle_request_count (counter)


- vault_core_handle_request_duration_seconds (histogram)


- vault_replication_wal_last_wal (gauge)


- vault_storage_backend_size_bytes (gauge)


```


## Emergency Procedures for Vault Compromise


### Scenario: Vault Security Breach

If Vault is compromised (unauthorized access detected), immediate action is required to protect all secrets.

**Emergency Response Workflow:**


```mermaid
sequenceDiagram
    participant Security
    participant Vault
    participant Backend
    participant Tenants
    participant Monitoring
    
    Security->>Vault: Detect Breach
    Security->>Vault: Seal Vault Immediately
    Vault-->>Security: Sealed
    Security->>Security: Rotate Unseal Keys
    Security->>Backend: Initiate Secret Rotation
    Backend->>Backend: Generate New SSH Keys
    Backend->>Backend: Generate New SMTP Passwords
    Backend->>Backend: Revoke All API Keys
    Backend->>Vault: Store New Secrets
    Backend->>Tenants: Notify of API Key Revocation
    Backend->>Monitoring: Log Incident
    Security->>Vault: Unseal with New Keys
    Note over Security,Tenants: RTO: 2-4 hours


```

**Emergency Response Steps:**


#### Step 1: Immediate Containment (< 5 minutes)


```bash


# Seal Vault immediately to prevent further access

vault operator seal


# Verify Vault is sealed

vault status


# Output: Sealed: true


# Disable all authentication methods temporarily

vault auth disable approle
vault auth disable jwt


# Revoke all active tokens

vault token revoke -mode=path auth/


```


#### Step 2: Incident Assessment (5-15 minutes)


```typescript
// Analyze audit logs to determine breach scope
async function assessVaultBreach(): Promise<BreachAssessment> {
  // Get all audit events in last 24 hours
  const auditEvents = await auditLog.query({
    timestamp_gte: new Date(Date.now() - 24 * 60 * 60 * 1000),
    order_by: 'timestamp DESC'
  });
  
  // Identify suspicious activity
  const suspiciousEvents = auditEvents.filter(event => 
    event.event.includes('unauthorized') ||
    event.severity === 'critical' ||
    event.details?.error?.includes('permission denied')
  );
  
  // Determine which secrets were accessed
  const accessedSecrets = auditEvents
    .filter(event => event.event === 'secret_read')
    .map(event => event.request.path);
  
  // Identify affected tenants
  const affectedTenants = new Set(
    accessedSecrets
      .map(path => path.split('/')[1]) // Extract tenant_id from path
      .filter(id => id !== 'test-tenant-id')
  );
  
  return {
    breach_detected_at: new Date().toISOString(),
    suspicious_events: suspiciousEvents.length,
    accessed_secrets: accessedSecrets.length,
    affected_tenants: Array.from(affectedTenants),
    breach_scope: affectedTenants.size > 10 ? 'widespread' : 'limited'
  };
}


```


#### Step 3: Rotate Unseal Keys (15-30 minutes)


```bash


# Generate new unseal keys

vault operator rekey -init -key-shares=5 -key-threshold=3


# Complete rekey process with existing unseal keys

vault operator rekey -target=recovery <old-unseal-key-1>
vault operator rekey -target=recovery <old-unseal-key-2>
vault operator rekey -target=recovery <old-unseal-key-3>


# New unseal keys generated


# IMPORTANT: Store new keys securely in separate locations


```


#### Step 4: Rotate All Secrets (30 minutes - 2 hours)


```typescript
// Emergency rotation of all secrets
async function emergencyRotateAllSecrets(
  incidentId: string
): Promise<void> {
  console.log(`[${incidentId}] Starting emergency secret rotation...`);
  
  // Get all tenants
  const tenants = await getAllTenants();
  
  for (const tenant of tenants) {
    try {
      // Rotate SSH keys
      await rotateSSHKeys(tenant.id, 'emergency', incidentId);
      
      // Rotate SMTP credentials
      await rotateSMTPCredentials(tenant.id, 'emergency', incidentId);
      
      // Revoke all API keys (tenants must regenerate)
      await revokeAllApiKeys(tenant.id, incidentId);
      
      // Rotate DKIM keys
      await rotateDKIMKeys(tenant.domain, 'emergency', incidentId);
      
      console.log(`[${incidentId}] Rotated secrets for tenant: ${tenant.id}`);
      
    } catch (error) {
      console.error(`[${incidentId}] Failed to rotate secrets for tenant ${tenant.id}: ${error.message}`);
    }
  }
  
  console.log(`[${incidentId}] Emergency secret rotation completed`);
}

// Revoke all API keys for a tenant
async function revokeAllApiKeys(
  tenantId: string,
  incidentId: string
): Promise<void> {
  // List all API keys for tenant
  const apiKeys = await vaultClient.list(`api_keys/${tenantId}`);
  
  // Revoke each key
  for (const keyId of apiKeys) {
    await vaultClient.delete(`api_keys/${tenantId}/${keyId}`);
  }
  
  // Log revocation
  await auditLog.create({
    event: 'api_keys_revoked_emergency',
    tenant_id: tenantId,
    timestamp: new Date().toISOString(),
    severity: 'critical',
    details: {
      incident_id: incidentId,
      keys_revoked: apiKeys.length
    }
  });
}


```


#### Step 5: Notify Tenants (Immediate)


```typescript
// Notify all affected tenants
async function notifyTenantsOfBreach(
  affectedTenants: string[],
  incidentId: string
): Promise<void> {
  for (const tenantId of affectedTenants) {
    await sendTenantNotification(tenantId, {
      type: 'security_incident',
      severity: 'critical',
      subject: 'URGENT: Security Incident - API Keys Revoked',
      message: `
        We have detected a security incident affecting our secrets management system.
        
        As a precautionary measure, we have:


        - Rotated all SSH keys


        - Rotated all SMTP credentials


        - Revoked all API keys
        
        ACTION REQUIRED:


        - Regenerate your API keys in the dashboard


        - Update any applications using the old API keys
        
        Your email sending infrastructure is unaffected and continues to operate normally.
        
        Incident ID: ${incidentId}
        
        We apologize for any inconvenience. Your security is our top priority.
      `
    });
  }
}


```


#### Step 6: Unseal Vault with New Keys (30-60 minutes)


```bash


# Unseal Vault with new unseal keys

vault operator unseal <new-unseal-key-1>
vault operator unseal <new-unseal-key-2>
vault operator unseal <new-unseal-key-3>


# Verify Vault is unsealed

vault status


# Output: Sealed: false


# Re-enable authentication methods

vault auth enable approle
vault auth enable jwt


# Verify services can reconnect

vault token lookup


```


#### Step 7: Post-Incident Review (1-2 days)


```typescript
// Conduct post-incident review
async function conductPostIncidentReview(
  incidentId: string
): Promise<IncidentReport> {
  // Gather all incident data
  const assessment = await assessVaultBreach();
  const auditEvents = await getIncidentAuditEvents(incidentId);
  const affectedTenants = assessment.affected_tenants;
  
  // Generate incident report
  const report: IncidentReport = {
    incident_id: incidentId,
    detected_at: assessment.breach_detected_at,
    resolved_at: new Date().toISOString(),
    breach_scope: assessment.breach_scope,
    affected_tenants: affectedTenants.length,
    actions_taken: [
      'Sealed Vault immediately',
      'Rotated unseal keys',
      'Rotated all SSH keys',
      'Rotated all SMTP credentials',
      'Revoked all API keys',
      'Rotated all DKIM keys',
      'Notified affected tenants'
    ],
    root_cause: 'TBD - Under investigation',
    lessons_learned: [],
    preventive_measures: []
  };
  
  // Store incident report
  await storeIncidentReport(report);
  
  return report;
}


```


## Implementation Checklist


### Phase 1: Automated Backup System (Week 1)


- [ ] Configure S3 bucket for encrypted backups


- [ ] Generate and securely store backup encryption key


- [ ] Implement automated backup script (daily at 02:00 UTC)


- [ ] Implement backup encryption (AES-256-GCM)


- [ ] Implement backup verification (checksum validation)


- [ ] Configure backup retention policy (30 daily, 12 monthly)


- [ ] Test backup creation and upload to S3


- [ ] Configure backup failure alerts


### Phase 2: Backup Restoration (Week 2)


- [ ] Document step-by-step restoration runbook


- [ ] Implement automated restoration script


- [ ] Test backup decryption


- [ ] Test Vault snapshot restoration


- [ ] Verify secrets accessible after restoration


- [ ] Conduct weekly restore test to staging


- [ ] Measure actual RTO/RPO


### Phase 3: VPS Migration Workflow (Week 3)


- [ ] Implement VPS migration script


- [ ] Test secret recovery from Vault


- [ ] Test SSH key installation on new VPS


- [ ] Test SMTP credential recovery


- [ ] Test DKIM key installation


- [ ] Verify email sending after migration


- [ ] Document VPS migration procedures


- [ ] Conduct VPS migration drill


### Phase 4: High Availability Setup (Week 4-5)


- [ ] Provision 3 Vault servers


- [ ] Configure Raft consensus protocol


- [ ] Set up PostgreSQL replication (primary + 2 replicas)


- [ ] Configure load balancer (HAProxy/Nginx)


- [ ] Test automatic failover


- [ ] Configure health checks (every 5 seconds)


- [ ] Verify audit logs replicate correctly


- [ ] Measure failover time (target: < 30 seconds)


### Phase 5: Monitoring and Alerting (Week 5)


- [ ] Implement Vault health monitoring script


- [ ] Configure Prometheus metrics collection


- [ ] Create Grafana dashboards


- [ ] Configure alert rules (seal status, replication lag, backup status)


- [ ] Set up alert notifications (email, Slack, PagerDuty)


- [ ] Test alert delivery for each severity level


- [ ] Document monitoring procedures


### Phase 6: Disaster Recovery Drills (Week 6)


- [ ] Schedule quarterly DR drills


- [ ] Document drill scenarios (vault failure, cluster loss, VPS compromise, credential compromise)


- [ ] Implement drill execution scripts


- [ ] Conduct first DR drill (vault server failure)


- [ ] Generate drill report


- [ ] Identify and fix issues found during drill


- [ ] Update DR procedures based on lessons learned


### Phase 7: Emergency Response Procedures (Week 6)


- [ ] Document Vault compromise response workflow


- [ ] Implement emergency secret rotation script


- [ ] Create tenant notification templates


- [ ] Test emergency seal and unseal procedures


- [ ] Test unseal key rotation


- [ ] Document post-incident review process


- [ ] Train team on emergency procedures


### Phase 8: SMTP Credential Recovery Integration (Week 7)


- [ ] Integrate SMTP credential recovery into VPS migration workflow


- [ ] Test SMTP credential decryption


- [ ] Test MailU configuration with recovered credentials


- [ ] Verify webmail access after recovery


- [ ] Document SMTP-specific recovery procedures


- [ ] Reference SMTP disaster recovery documentation


- [ ] Conduct end-to-end SMTP recovery drill


## Related Documentation


### Route Specifications


- **[Infrastructure SSH Access Routes](/docs/design/routes/infrastructure-ssh-access)** - SSH and secrets management UI


- **[Admin Routes](/docs/design/routes/admin)** - Admin secrets management panel


### Feature Documentation


- **[Vault SSH Management](/docs/features/infrastructure/vault-ssh-management)** - SSH key storage and rotation


- **[Vault SMTP Credentials](/docs/features/infrastructure/vault-smtp-credentials)** - SMTP-specific disaster recovery


- **[Vault API Keys](/docs/features/integrations/vault-api-keys)** - API key storage and rotation


- **[Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)** - MailU configuration


- **[Hostwind Management](/docs/features/infrastructure/hostwind-management)** - VPS provisioning workflow


### Operations Documentation


- **[Incident Response](/docs/operations/incident-response)** - Security incident procedures


- **[Security Monitoring](/docs/operations/security-monitoring)** - Monitoring and alerting


- **[Operational Runbooks](/docs/operations/operational-runbooks)** - Operational procedures


### Architecture & Security


- **[Vault Integration Architecture](/.kiro/specs/feature-completeness-review/findings/vault-integration-architecture.md)** - Complete Vault architecture


- **[Multi-Tenant Architecture](/docs/features/infrastructure/multi-tenant-architecture)** - Tenant isolation


- **[Enterprise Security](/docs/compliance-security/enterprise/overview)** - Security features


### Planning & Review


- **[Integrations Review](/.kiro/specs/feature-completeness-review/findings/integrations.md)** - Integration completeness review


- **[Feature Completeness Review Requirements](/.kiro/specs/feature-completeness-review/requirements.md)** - Review requirements


- **[Technical Roadmap](/docs/roadmap/technical-roadmap)** - Infrastructure roadmap


### Implementation Tasks


- **[Task 11.7 - Vault Disaster Recovery](/.kiro/specs/feature-completeness-review/tasks.md#117-implement-vault-disaster-recovery-procedures)** - Disaster recovery implementation


- **[Task 11.3 - Vault Integration Architecture](/.kiro/specs/feature-completeness-review/tasks.md#113-document-vault-integration-architecture)** - Architecture documentation


- **[Task 11.4 - VPS SSH Key Management](/.kiro/specs/feature-completeness-review/tasks.md#114-implement-vps-ssh-key-management-with-vault)** - SSH key storage


- **[Task 11.5 - SMTP Credentials Vault Storage](/.kiro/specs/feature-completeness-review/tasks.md#115-implement-smtp-credentials-vault-storage)** - SMTP credential management


- **[Task 11.6 - Tenant API Key System](/.kiro/specs/feature-completeness-review/tasks.md#116-implement-tenant-api-key-system-with-vault)** - API key storage


- **[Epic 5: Infrastructure Management](/tasks/epic-5-infrastructure-management/)** - Infrastructure tasks


### External Resources


- **[HashiCorp Vault Documentation](https://www.vaultproject.io/docs)** - Official Vault docs


- **[Vault Disaster Recovery](https://learn.hashicorp.com/tutorials/vault/disaster-recovery)** - DR tutorial


- **[Vault High Availability](https://learn.hashicorp.com/tutorials/vault/ha-with-consul)** - HA setup


- **[Vault Backup and Restore](https://www.vaultproject.io/docs/commands/operator/raft/snapshot)** - Backup commands


- **[Vault Monitoring](https://www.vaultproject.io/docs/internals/telemetry)** - Monitoring guide

---

**Last Updated:** November 26, 2025  
**Document Version:** 1.0  
**Status:** APPROVED  
**Next Review:** December 26, 2025

*This document provides comprehensive disaster recovery procedures for HashiCorp Vault, ensuring rapid recovery from any failure scenario with minimal data loss and service disruption. All Vault-dependent features must reference this document for disaster recovery planning.*
