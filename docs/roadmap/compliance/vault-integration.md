---
title: "Vault Integration"
description: "Critical security dependency for secret management"
last_modified_date: "2025-12-09"
level: "2"
parent: "Compliance Roadmap"
persona: "DevOps"
---

# Vault Integration (Critical Dependency)

**Status**: In Progress (MVP Blocker)
**Timeline**: Q4 2025
**Feature Specification**: [Infrastructure Features](/docs/features/infrastructure/README)

## Details

- **Vault Architecture**: Centralized secret management
- **Secret Storage**: VPS SSH keys, SMTP credentials, Tenant API keys
- **Disaster Recovery**: Procedures for secret recovery

### Why Critical

- All secrets stored in Vault (not ENV files)
- Enables rapid VPS migration without secret exposure
- Compliance-ready secret management (SOC2, ISO 27001)
