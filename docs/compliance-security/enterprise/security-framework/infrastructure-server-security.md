---
title: "Infrastructure & Server Security"
description: "Network security, firewall rules, VPS hardening, and data encryption standards."
last_modified_date: "2025-10-27"
level: "2"
persona: "Documentation Users"
---

# Infrastructure & Server Security

## Network Security

### Firewall Configuration (UFW)

We maintain strict firewall rules to protect internal services.

- **SSH**: Limited to specific infrastructure IP ranges.
- **Web**: Global access for 80/tcp and 443/tcp.
- **Internal**: App ports (3000, 5432, 6379) restricted to the internal network (10.0.0.0/8).

### VPN Protocols

- **Team Access**: Private network required for infrastructure management.
- **Database**: Production databases only accessible via VPN.
- **Monitoring**: Observability dashboards restricted to VPN.

## Server Security & Hardening

### VPS Security

1. **Disable Root Login**: `PermitRootLogin no` in SSH config.
2. **Key-Based Auth**: Password authentication is disabled.
3. **Fail2Ban**: Automated blocking of brute-force attempts.
4. **Regular Updates**: Automated patch management for system packages.

### SSL/TLS Configuration

All traffic is encrypted using TLS 1.2/1.3 with high-strength ciphers.

- **HSTS**: Forced HTTPS with long-duration max-age.
- **Security Headers**: X-Frame-Options: DENY, X-Content-Type-Options: nosniff.

## Data Security & Encryption

### Multi-Tenant Isolation

- **Context Middleware**: Verifies tenant access before setting database context.
- **Isolation Enforcement**: Every query is scoped to the verified `tenantId`.

### Encryption Standards

- **At Rest**: PostgreSQL Transparent Data Encryption (TDE) and encrypted backups.
- **In Transit**: Mandatory HTTPS enforcement for all API and web traffic.
- **API Keys**: Keys are hashed (SHA-256) and sensitive data is encrypted with AES-256-GCM.
