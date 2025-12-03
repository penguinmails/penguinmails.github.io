---
title: "Vault Secret Recovery Procedures"
description: "Quarterly disaster recovery drills and scripted recovery exercises for Vault-managed secrets"
last_modified_date: "2025-12-04"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "disaster recovery", "drills", "secrets", "resilience"]
---

# Secret Recovery Procedures

## Quarterly Disaster Recovery Drills

**Purpose:** Validate that operational teams retain muscle memory for Vault disaster recovery and that automation still satisfies recovery objectives.

**Schedule:** Execute in January, April, July, and October. Record results for compliance audits.

## Drill scenarios

1. **Vault server failure**
   - Simulate failure of the active Vault node
   - Confirm automatic failover activates a standby
   - Validate all services reconnect without manual intervention
   - Measure RTO (target: under 30 minutes)
2. **Complete Vault cluster loss**
   - Simulate loss of every Vault node
   - Restore the cluster from the most recent backup
   - Verify all secrets are accessible post-restore
   - Measure RTO (target: under 2 hours)
3. **VPS compromise**
   - Simulate a compromised tenant VPS
   - Execute the Vault-backed VPS migration workflow
   - Verify outbound email service works from the new VPS
   - Measure RTO (target: under 1 hour)
4. **Credential compromise**
   - Simulate leaked SMTP credentials
   - Execute the emergency credential rotation pipeline
   - Confirm zero downtime for tenants
   - Measure rotation time (target: under 5 minutes)

## Drill Execution Automation

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
