---
title: "Environment Configurations & Specs"
description: "Detailed specifications for development, staging, and production environments, including hardware and access controls."
last_modified_date: "2025-11-10"
level: "2"
persona: "Documentation Users"
---

# Environment Configurations & Specs

## Environment Hierarchy

```markdown
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Development   │    │     Staging     │    │   Production    │
│   (dev)         │───▶│     (staging)   │───▶│   (prod)        │
│                 │    │                 │    │                 │
│ • Feature dev   │    │ • Integration   │    │ • Live system   │
│ • Unit testing  │    │ • E2E testing   │    │ • User traffic   │
│ • Code review   │    │ • Load testing  │    │ • Real data     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Local Dev     │    │   QA/Testing    │    │  Disaster Rec   │
│   (localhost)   │    │   (qa)          │    │   (dr)          │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Environment Specifications

### Development Environment

```yaml
environment: development
purpose: Feature development and testing
infrastructure:
  - VPS: 2 vCPUs, 4GB RAM
  - Database: NileDB dev instance
  - Storage: Local file system
  - Networking: Internal only
data:
  - Source: Synthetic/anonymized data
  - Retention: 30 days
  - Backup: Daily snapshots
access:
  - Developers: Full access
  - QA: Read-only access
  - Security: Automated scanning
```

### Staging Environment

```yaml
environment: staging
purpose: Pre-production validation
infrastructure:
  - VPS: 4 vCPUs, 8GB RAM
  - Database: NileDB staging instance
  - Storage: Cloud storage with CDN
  - Networking: Restricted external access
data:
  - Source: Production-like data (anonymized)
  - Retention: 90 days
  - Backup: Hourly snapshots
access:
  - Developers: Limited access
  - QA: Full testing access
  - Product: Demo access
  - Security: Full monitoring
```

### Production Environment

```yaml
environment: production
purpose: Live user-facing system
infrastructure:
  - VPS: 8-16 vCPUs, 32-64GB RAM (auto-scaling)
  - Database: NileDB production cluster
  - Storage: Geo-redundant cloud storage
  - Networking: Global CDN with WAF
data:
  - Source: Live user data
  - Retention: Per data classification policy
  - Backup: Continuous replication
access:
  - Users: Application access
  - Support: Limited debugging access
  - Operations: Administrative access
  - Security: 24/7 monitoring
```

---

## Configuration Management

### Environment Configuration Interface

```typescript
interface EnvironmentConfig {
  environment: string;
  database: DatabaseConfig;
  cache: CacheConfig;
  storage: StorageConfig;
  email: EmailConfig;
  monitoring: MonitoringConfig;
  security: SecurityConfig;
  features: FeatureFlags;
}

interface DatabaseConfig {
  host: string;
  port: number;
  database: string;
  ssl: boolean;
  connectionPool: {
    min: number;
    max: number;
    idleTimeoutMillis: number;
  };
}
```

### Secrets Management

```yaml
# Secret management strategy
secrets:
  strategy: 'vault'  # HashiCorp Vault
  rotation:
    automatic: true
    frequency: '30d'
    grace_period: '7d'
  access:
    principle: 'role-based'
    audit: true
    encryption: 'AES-256-GCM'
```
