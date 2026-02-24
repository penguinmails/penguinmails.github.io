---
title: "Recovery Implementation Procedures"
description: "Step-by-step restoration procedures for all database tiers, including PITR for OLTP."
last_modified_date: "2025-11-19"
level: "3"
persona: "SRE / Infrastructure"
---

# Recovery Implementation Procedures

Detailed workflows for restoring databases from backup artifacts in S3.

## 1. OLTP Database Recovery (PITR)

### Procedure: Full Restore from Latest Backup

1. Stop the database service.
2. Clear the existing data directory.
3. Download the latest full dump from S3.
4. Execute `pg_restore` with superuser privileges.

```bash
#!/bin/bash
set -e

DB_NAME="penguinmails_oltp"
S3_BUCKET="penguinmails-backups-us-east-1"
RECOVERY_DATE=$(date +%Y-%m-%d)

# Download from S3
aws s3 cp "s3://$S3_BUCKET/oltp/full/$RECOVERY_DATE.dump.gpg" /tmp/recovery.dump.gpg

# Restore
gpg -d /tmp/recovery.dump.gpg | pg_restore -d "$DB_NAME" --clean --if-exists
```

### Procedure: Point-In-Time-Recovery (WAL)

Restores to a specific timestamp by replaying WAL files after a full base restore.

```bash
# Example recovery.conf snippet
restore_command = 'cp /var/lib/postgresql/wal_archive/%f %p'
recovery_target_time = '2025-11-19 14:30:00'
```

## 2. Content Database Recovery

Workflow for multi-part blob restoration.

```bash
#!/bin/bash
RECOVERY_DIR="/tmp/recovery_content"

# Reassemble split files
cat "$RECOVERY_DIR/blobs.part_*" > "$RECOVERY_DIR/full_blobs.dump"

# Restore content
pg_restore -d penguinmails_content "$RECOVERY_DIR/full_blobs.dump"
```

## 3. Queue Restoration

Reloading Redis state from RDB snapshots.

1. Stop Redis service.
2. Replace `/var/lib/redis/dump.rdb` with the backup file.
3. Fix file permissions (`chown redis:redis`).
4. Start Redis service.

## 4. OLAP Restoration

Restoring frozen partitions in ClickHouse.

```bash
# Attach the detached partition
ALTER TABLE analytics_events ATTACH PARTITION 202511
```
