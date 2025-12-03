---
title: "Vault Restoration from Backup"
description: "Manual and automated runbooks for restoring Vault from encrypted snapshot backups"
last_modified_date: "2025-12-04"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "restoration", "backup", "snapshot", "runbook"]
---

# Vault Restoration from Backup

## Step-by-Step Runbook

**Prerequisites**

- Access to the encrypted S3 backup bucket
- Backup encryption key material
- Vault unseal keys (3 of 5 required)
- Root token or administrator credentials

### Step 1: Provision New Vault Server

```bash
# Install Vault and configure systemd service
wget https://releases.hashicorp.com/vault/1.15.0/vault_1.15.0_linux_amd64.zip
unzip vault_1.15.0_linux_amd64.zip
sudo mv vault /usr/local/bin/

sudo mkdir -p /etc/vault
sudo tee /etc/vault/config.hcl >/dev/null <<'EOF'
storage "postgresql" {
  connection_url = "postgres://vault:password@localhost:5432/vault"
}

listener "tcp" {
  address        = "0.0.0.0:8200"
  tls_cert_file  = "/etc/vault/tls/vault.crt"
  tls_key_file   = "/etc/vault/tls/vault.key"
}

api_addr     = "https://vault.penguinmails.com:8200"
cluster_addr = "https://vault.penguinmails.com:8201"
ui           = true
EOF

sudo systemctl enable vault
sudo systemctl start vault
```

### Step 2: Download Latest Backup

```bash
BACKUP_DATE=$(date +%Y-%m-%d)
aws s3 cp \
  s3://penguinmails-vault-backups/daily/${BACKUP_DATE}/vault-snapshot-*.enc \
  /tmp/vault-backup.enc

if [ ! -f /tmp/vault-backup.enc ]; then
  echo "ERROR: Backup not found for date ${BACKUP_DATE}"
  exit 1
fi
```

### Step 3: Decrypt Backup

```bash
openssl enc -d -aes-256-gcm \
  -in /tmp/vault-backup.enc \
  -out /tmp/vault-backup.snap \
  -K ${BACKUP_ENCRYPTION_KEY} \
  -iv ${BACKUP_IV}

if [ ! -f /tmp/vault-backup.snap ]; then
  echo "ERROR: Backup decryption failed"
  exit 1
fi
```

### Step 4: Initialize Vault (fresh server only)

```bash
vault operator init -key-shares=5 -key-threshold=3
# Capture unseal keys and root token securely
```

### Step 5: Unseal Vault

```bash
vault operator unseal <unseal-key-1>
vault operator unseal <unseal-key-2>
vault operator unseal <unseal-key-3>

vault status # Expect "Sealed: false"
```

### Step 6: Restore Snapshot

```bash
vault login <root-token>
vault operator raft snapshot restore /tmp/vault-backup.snap
vault status
```

### Step 7: Verify Secrets

```bash
vault kv get vps/test-tenant-id/admin_ssh
vault kv get smtp/test-tenant-id/admin
vault kv get api_keys/test-tenant-id/test-key-id
```

### Step 8: Update DNS and Dependent Services

```bash
sudo systemctl restart penguinmails-backend
sudo systemctl restart penguinmails-rotation-service

curl -H "X-Vault-Token: ${VAULT_TOKEN}" \
  https://vault.penguinmails.com:8200/v1/sys/health
```

### Step 9: Cleanup

```bash
rm /tmp/vault-backup.enc
rm /tmp/vault-backup.snap
echo "Vault restored from backup: ${BACKUP_DATE}" >> /var/log/vault/restoration.log
```

## Automated Restoration Script

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
  const iv = encryptedData.slice(0, 16);
  const authTag = encryptedData.slice(16, 32);
  const encrypted = encryptedData.slice(32);

  const decipher = crypto.createDecipheriv('aes-256-gcm', encryptionKey, iv);
  decipher.setAuthTag(authTag);

  const decrypted = Buffer.concat([
    decipher.update(encrypted),
    decipher.final()
  ]);

  return decrypted;
}
```
