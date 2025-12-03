---
title: "Vault High Availability Setup"
description: "Three-node Vault cluster topology, configuration, and automatic failover routines"
last_modified_date: "2025-12-04"
level: "3"
persona: "Infrastructure Teams, Security Teams, Operations Teams"
keywords: ["vault", "high availability", "failover", "cluster", "haproxy"]
---

# High Availability Setup

## 3-Node Vault Cluster Architecture

```mermaid
graph TB
    subgraph "Load Balancer"
        LB[HAProxy / Nginx\n vault.penguinmails.com]
    end

    subgraph "Vault Cluster"
        V1[Vault Node 1\n Active\n 10.0.1.10]
        V2[Vault Node 2\n Standby\n 10.0.1.11]
        V3[Vault Node 3\n Standby\n 10.0.1.12]
    end

    subgraph "Storage Backend"
        PG[(PostgreSQL\n Primary\n 10.0.2.10)]
        PG_R1[(PostgreSQL\n Replica 1\n 10.0.2.11)]
        PG_R2[(PostgreSQL\n Replica 2\n 10.0.2.12)]
    end

    subgraph "Backup Storage"
        S3[S3 Bucket\n Encrypted Backups]
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
```

## Cluster Configuration

```hcl
# /etc/vault/config.hcl (Node 1)
storage "postgresql" {
  connection_url = "postgres://vault:password@10.0.2.10:5432/vault"
  ha_enabled     = "true"
}

listener "tcp" {
  address        = "0.0.0.0:8200"
  tls_cert_file  = "/etc/vault/tls/vault.crt"
  tls_key_file   = "/etc/vault/tls/vault.key"
}

api_addr     = "https://10.0.1.10:8200"
cluster_addr = "https://10.0.1.10:8201"

storage "raft" {
  path    = "/opt/vault/data"
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

**Load balancer (HAProxy) routing**

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

## Automatic Failover

```mermaid
sequenceDiagram
    participant Client
    participant LB as Load Balancer
    participant V1 as Vault Node 1 (Active)
    participant V2 as Vault Node 2 (Standby)
    participant V3 as Vault Node 3 (Standby)

    Client->>LB: Request secret
    LB->>V1: Forward request
    V1--xLB: Node failure detected
    LB->>LB: Health check fails
    LB->>V2: Promote to active
    V2->>V2: Become leader
    LB->>V2: Forward request
    V2-->>LB: Return secret
    LB-->>Client: Return secret
    Note over Client,V3: Failover target < 30 seconds
```

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

      if (health.data.sealed) {
        await sendAlert({
          type: 'vault_node_sealed',
          severity: 'high',
          node_id: node.id,
          message: `Vault node ${node.id} is sealed`
        });
      }
    } catch (error) {
      await auditLog.create({
        event: 'vault_node_unreachable',
        timestamp: new Date().toISOString(),
        severity: 'high',
        details: {
          node_id: node.id,
          error: error.message
        }
      });

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
