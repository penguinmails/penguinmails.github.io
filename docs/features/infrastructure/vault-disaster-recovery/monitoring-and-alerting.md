---
title: "Vault Monitoring and Alerting"
description: "Comprehensive monitoring metrics, alert rules, and dashboards for Vault disaster recovery readiness"
last_modified_date: "2025-12-04"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "monitoring", "alerting", "grafana", "prometheus"]
---

# Monitoring and Alerting

## Vault Health Monitoring

Track seal status, leadership, replication lag, latency, storage consumption, and backup freshness to maintain recovery readiness.

```typescript
// Comprehensive Vault health monitoring
async function monitorVaultHealth(): Promise<VaultHealthStatus> {
  const health: VaultHealthStatus = {
    timestamp: new Date().toISOString(),
    overall_status: 'healthy',
    checks: []
  };

  try {
    // Check 1: Seal status
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

    // Check 2: Leader status
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

    // Check 3: Replication lag
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

    // Check 4: Request latency
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

    // Check 5: Storage usage
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

    // Check 6: Backup status
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

## Alert Configuration

| Severity | Response Time | Channels | Example |
| --- | --- | --- | --- |
| Critical | Immediate (< 5 min) | Email, Slack, PagerDuty | Vault sealed, cluster offline |
| High | 15 minutes | Email, Slack | Replication lag > 60 seconds |
| Medium | 1 hour | Email | Storage > 80%, latency > 100 ms |
| Low | 24 hours | Email | Routine maintenance follow-up |

```typescript
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
    message: 'Vault request latency exceeds 100 ms',
    action: 'Check Vault and PostgreSQL performance'
  }
];

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

## Grafana Dashboard Blueprint

Track seal status, leadership, request performance, storage growth, replication lag, and backup freshness in Grafana *(2026 Spike)*. Query Vault's Prometheus metrics endpoint and annotate incidents when alerts fire.

```yaml
# Vault metrics exposed at /v1/sys/metrics
- vault_core_unsealed
- vault_core_leader
- vault_runtime_alloc_bytes
- vault_runtime_sys_bytes
- vault_core_handle_request_count
- vault_core_handle_request_duration_seconds
- vault_replication_wal_last_wal
- vault_storage_backend_size_bytes
```
