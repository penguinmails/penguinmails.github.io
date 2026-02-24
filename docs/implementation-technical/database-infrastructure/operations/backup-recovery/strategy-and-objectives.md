---
title: "Backup Strategy & Recovery Objectives"
description: "High-level strategy, retention policies, and RPO/RTO objectives for PenguinMails' database architecture."
last_modified_date: "2025-11-19"
level: "2"
persona: "Infrastructure Team"
---

# Backup Strategy & Recovery Objectives

This document outlines the strategic approach to data protection for PenguinMails' 4-tier database architecture.

## Strategic Alignment

Our backup procedures are designed to meet enterprise-grade compliance and operational excellence standards, ensuring 99.99% data durability.

## Backup Matrix

| Tier | Type | Frequency | Retention | Location |
|------|------|-----------|-----------|----------|
| **OLTP** | Full + Incremental | Daily full, hourly incremental | 90 days | Primary + Cross-region |
| **Content** | Full + Compressed | Daily full, 4-hour incremental | 180 days | Primary + Archive |
| **Queue** | Transaction log | Continuous + Daily full | 30 days | Primary + Secondary |
| **OLAP** | Full + Snapshot | Daily full, weekly snapshot | 365 days | Primary + Analytics archive |

## Recovery Objectives (RPO/RTO)

```yaml
RecoveryTimeObjectives:
  OLTP: < 15 minutes
  Content: < 30 minutes
  Queue: < 5 minutes
  OLAP: < 2 hours

RecoveryPointObjectives:
  OLTP: < 1 hour (WAL-based)
  Content: < 4 hours
  Queue: Near real-time
  OLAP: < 24 hours
```

## Core Principles

1. **Automation First**: All backups must be triggered by automated schedules with zero manual intervention.
2. **Encrypted at Rest**: Every backup artifact is encrypted using AES-256 before being uploaded to S3.
3. **Validated Regularly**: Backups are only as good as their last successful restoration test.
4. **Geo-Redundant**: Storage spans multiple AWS regions to protect against regional outages.
