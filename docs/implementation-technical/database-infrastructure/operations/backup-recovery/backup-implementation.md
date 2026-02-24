---
title: "Backup Implementation Scripts"
description: "Technical implementation of backup scripts for OLTP, Content, Queue, and OLAP databases."
last_modified_date: "2025-11-19"
level: "3"
persona: "SRE / Infrastructure"
---

# Backup Implementation Scripts

Technical specifications and scripts for daily and incremental backups across the multi-tier architecture.

## 1. OLTP Database Backup (PostgreSQL)

### Daily Full Backup

Executes a compressed dump of the primary transactional database and uploads to S3.

```bash
#!/bin/bash
set -e

DB_NAME="penguinmails_oltp"
BACKUP_DIR="/backups/oltp"
S3_BUCKET="penguinmails-backups-us-east-1"
RETENTION_DAYS=90

# Perform full backup with compression
pg_dump -U postgres -d "$DB_NAME" -Fc | gpg -e -r infrastructure@penguinmails.com > "$BACKUP_DIR/$(date +%Y-%m-%d).dump.gpg"

# Upload to S3
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/oltp/full/" --sse AES256
```

### Hourly Incremental (WAL)

Continuous archiving of Write-Ahead Logs (WAL) for Point-In-Time-Recovery (PITR).

```bash
#!/bin/bash
set -e

DB_NAME="penguinmails_oltp"
WAL_DIR="/var/lib/postgresql/wal_archive"
S3_BUCKET="penguinmails-backups-us-east-1"

# Upload WAL files to S3
aws s3 sync "$WAL_DIR" "s3://$S3_BUCKET/oltp/wal_archive/" --sse AES256
```

## 2. Content Database Backup

Specialized backup focusing on large objects and content blobs.

```bash
#!/bin/bash
set -e

DB_NAME="penguinmails_content"
BACKUP_DIR="/backups/content"

# Metadata-only backup for faster recovery
pg_dump -n content_schema --schema-only "$DB_NAME" > "$BACKUP_DIR/schema.sql"

# Data-only compressed dump for blobs
pg_dump -t content_objects --data-only "$DB_NAME" | split -b 2G - "$BACKUP_DIR/blobs.part_"
```

## 3. Queue & Event Backup (Redis/NATS)

Focuses on transaction logs and state persistence.

```bash
#!/bin/bash
# Snapshotting Redis state
redis-cli SAVE
cp /var/lib/redis/dump.rdb /backups/queue/$(date +%Y-%m-%d).rdb
```

## 4. OLAP Analytics Backup (ClickHouse)

Incremental snapshots for analytical data.

```bash
#!/bin/bash
# Snapshotting analytical partitions
clickhouse-client --query "ALTER TABLE analytics_events FREEZE PARTITION 202511"
tar -czvf /backups/olap/snapshot_202511.tar.gz /var/lib/clickhouse/shadow/
```
