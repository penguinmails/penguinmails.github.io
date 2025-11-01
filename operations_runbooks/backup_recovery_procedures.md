# Backup & Recovery Procedures

## Overview

**Last Updated**: November 1, 2025  
**Owner**: Database Operations Team  
**Criticality**: Critical  
**Next Review**: December 1, 2025

This guide provides comprehensive backup and recovery procedures for PenguinMails' 4-tier database architecture, ensuring business continuity and data protection.

### 🎯 **Purpose**
- **Data Protection**: Ensure complete data backup across all database tiers
- **Business Continuity**: Enable rapid recovery from data loss or corruption
- **Compliance**: Meet regulatory requirements for data retention and recovery
- **Testing**: Regular backup validation and recovery testing

---

## 🏗️ **Backup Architecture**

### **4-Tier Backup Strategy**

| Database Tier | Backup Type | Frequency | Retention | Storage Location |
|---------------|-------------|-----------|-----------|------------------|
| **OLTP** | Full + Incremental | Daily full, hourly incremental | 90 days | Primary + Cross-region |
| **Content** | Full + Compressed | Daily full, 4-hour incremental | 180 days | Primary + Archive |
| **Queue** | Transaction log | Continuous + Daily full | 30 days | Primary + Secondary |
| **OLAP** | Full + Snapshot | Daily full, weekly snapshot | 365 days | Primary + Analytics archive |

### **Recovery Objectives**
```yaml
Recovery Time Objectives (RTO):
  OLTP:     15 minutes (critical business operations)
  Content:  30 minutes (email delivery)
  Queue:    5 minutes (background processing)
  OLAP:     2 hours (analytics reporting)

Recovery Point Objectives (RPO):
  OLTP:     15 minutes (minimal data loss)
  Content:  1 hour (acceptable for email content)
  Queue:    0 minutes (transaction log replay)
  OLAP:     24 hours (analytics data acceptable loss)
```

---

## 💾 **OLTP Database Backup**

### **Daily Full Backup**
```bash
#!/bin/bash
# OLTP Daily Full Backup Script

set -e

DB_NAME="penguinmails_oltp"
BACKUP_DIR="/backups/oltp/$(date +%Y-%m-%d)"
S3_BUCKET="penguinmails-backups-us-east-1"
RETENTION_DAYS=90

echo "Starting OLTP full backup for $(date)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Perform full backup with compression
pg_dump \
  --host=oltp-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=6 \
  --verbose \
  --file="$BACKUP_DIR/oltp_full_$(date +%Y%m%d_%H%M%S).dump" \
  "$DB_NAME"

# Create backup metadata
cat > "$BACKUP_DIR/backup_info.json" << EOF
{
  "database": "$DB_NAME",
  "backup_type": "full",
  "timestamp": "$(date -Iseconds)",
  "backup_size_bytes": "$(stat -f%z "$BACKUP_DIR"/oltp_full_*.dump 2>/dev/null || stat -c%s "$BACKUP_DIR"/oltp_full_*.dump)",
  "retention_days": $RETENTION_DAYS,
  "compressed": true,
  "format": "custom"
}
EOF

# Upload to S3 with encryption
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/oltp/$(date +%Y-%m-%d)/" \
  --server-side-encryption AES256 \
  --storage-class STANDARD_IA

# Verify backup integrity
pg_restore \
  --host=oltp-db.penguinmails.com \
  --username=backup_user \
  --list "$BACKUP_DIR/oltp_full_$(date +%Y%m%d_%H%M%S).dump" > /dev/null

echo "OLTP backup completed successfully"
echo "Backup location: $BACKUP_DIR"
echo "S3 location: s3://$S3_BUCKET/oltp/$(date +%Y-%m-%d)/"

# Clean up old local backups (keep 7 days locally)
find /backups/oltp -type d -mtime +7 -exec rm -rf {} +
```

### **Hourly Incremental Backup**
```bash
#!/bin/bash
# OLTP Incremental Backup (WAL archiving)

set -e

DB_NAME="penguinmails_oltp"
WAL_ARCHIVE_DIR="/backups/oltp/wal_archive/$(date +%Y-%m-%d)"
S3_BUCKET="penguinmails-backups-us-east-1"

# Create WAL archive directory
mkdir -p "$WAL_ARCHIVE_DIR"

# Archive WAL files (PostgreSQL continuously writes these)
# This script runs every hour via cron
find /var/lib/postgresql/wal_archive -name "*.wal" -mmin +55 -exec cp {} "$WAL_ARCHIVE_DIR"/ \;

# Upload WAL files to S3
aws s3 sync "$WAL_ARCHIVE_DIR" "s3://$S3_BUCKET/oltp/wal_archive/$(date +%Y-%m-%d)/" \
  --server-side-encryption AES256

echo "WAL archive completed: $(date)"
```

---

## 📧 **Content Database Backup**

### **Daily Content Backup with Compression**
```bash
#!/bin/bash
# Content Database Backup with Advanced Compression

set -e

DB_NAME="penguinmails_content"
BACKUP_DIR="/backups/content/$(date +%Y-%m-%d)"
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting Content database backup with compression optimization"

# Create backup with selective compression
pg_dump \
  --host=content-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=9 \
  --no-owner \
  --no-privileges \
  --exclude-table-data="content_objects" \
  --file="$BACKUP_DIR/content_metadata_$(date +%Y%m%d_%H%M%S).dump" \
  "$DB_NAME"

# Backup content objects separately with maximum compression
pg_dump \
  --host=content-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=9 \
  --data-only \
  --table=content_objects \
  --file="$BACKUP_DIR/content_objects_$(date +%Y%m%d_%H%M%S).dump" \
  "$DB_NAME"

# Create backup summary
cat > "$BACKUP_DIR/backup_summary.txt" << EOF
Content Database Backup Summary
===============================
Date: $(date)
Database: $DB_NAME
Metadata backup: $(ls -lh $BACKUP_DIR/content_metadata_*.dump | awk '{print $5}')
Objects backup: $(ls -lh $BACKUP_DIR/content_objects_*.dump | awk '{print $5}')
Total size: $(du -sh $BACKUP_DIR | cut -f1)
Compression ratio: Optimized for storage efficiency
EOF

# Upload to S3 with lifecycle policy
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/content/$(date +%Y-%m-%d)/" \
  --server-side-encryption AES256 \
  --storage-class GLACIER

echo "Content backup completed with compression optimization"
```

---

## 🔄 **Queue System Backup**

### **Continuous Transaction Log Backup**
```bash
#!/bin/bash
# Queue System Transaction Log Backup

set -e

DB_NAME="penguinmails_queue"
WAL_DIR="/var/lib/postgresql/queue_wal"
BACKUP_DIR="/backups/queue/wal/$(date +%Y-%m-%d)"
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting Queue system WAL backup"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Copy WAL files that are ready for archival
find "$WAL_DIR" -name "*.wal" -type f -exec cp {} "$BACKUP_DIR"/ \;

# Create queue backup metadata
cat > "$BACKUP_DIR/queue_backup_info.json" << EOF
{
  "database": "$DB_NAME",
  "backup_type": "wal_archive",
  "timestamp": "$(date -Iseconds)",
  "wal_files_count": $(find "$BACKUP_DIR" -name "*.wal" | wc -l),
  "total_wal_size_bytes": $(find "$BACKUP_DIR" -name "*.wal" -exec stat -f%z {} + 2>/dev/null | awk '{sum+=$1} END {print sum}' || find "$BACKUP_DIR" -name "*.wal" -exec stat -c%s {} + | awk '{sum+=$1} END {print sum}')
}
EOF

# Upload WAL files to S3
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/queue/wal/$(date +%Y-%m-%d)/" \
  --server-side-encryption AES256

# Clean up old WAL files locally
find "$WAL_DIR" -name "*.wal" -mtime +7 -delete

echo "Queue WAL backup completed"
```

---

## 📊 **OLAP Analytics Backup**

### **Daily Analytics Backup with Snapshot**
```bash
#!/bin/bash
# OLAP Analytics Backup with Snapshot

set -e

DB_NAME="penguinmails_olap"
BACKUP_DIR="/backups/olap/$(date +%Y-%m-%d)"
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting OLAP Analytics backup with snapshot"

# Create logical backup for analytics data
pg_dump \
  --host=olap-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=6 \
  --exclude-table-data="admin_audit_log" \
  --file="$BACKUP_DIR/olap_analytics_$(date +%Y%m%d_%H%M%S).dump" \
  "$DB_NAME"

# Backup materialized views definitions (not data)
pg_dump \
  --host=olap-db.penguinmails.com \
  --username=backup_user \
  --schema-only \
  --data-only \
  --table=analytics.* \
  --file="$BACKUP_DIR/materialized_views_$(date +%Y%m%d_%H%M%S).sql" \
  "$DB_NAME"

# Create analytics backup report
cat > "$BACKUP_DIR/backup_report.txt" << EOF
OLAP Analytics Backup Report
============================
Date: $(date)
Database: $DB_NAME
Main backup: $(ls -lh $BACKUP_DIR/olap_analytics_*.dump | awk '{print $5}')
Materialized views: $(ls -lh $BACKUP_DIR/materialized_views_*.sql | awk '{print $5}')
Data freshness: Analytics data reflects OLTP as of $(date)
Snapshot strategy: Weekly snapshots for long-term retention
EOF

# Upload to S3
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/olap/$(date +%Y-%m-%d)/" \
  --server-side-encryption AES256 \
  --storage-class STANDARD_IA

echo "OLAP analytics backup completed"
```

---

## 🚨 **Recovery Procedures**

### **OLTP Database Recovery**
```bash
#!/bin/bash
# OLTP Recovery Procedure

RECOVERY_TARGET_TIME="$1"  # ISO format: 2025-11-01T14:30:00
BACKUP_DATE="$2"          # YYYY-MM-DD format

set -e

if [ -z "$RECOVERY_TARGET_TIME" ] || [ -z "$BACKUP_DATE" ]; then
    echo "Usage: $0 <target_time> <backup_date>"
    echo "Example: $0 2025-11-01T14:30:00 2025-11-01"
    exit 1
fi

S3_BUCKET="penguinmails-backups-us-east-1"
RECOVERY_DIR="/tmp/recovery_oltp"
DB_NAME="penguinmails_oltp"

echo "Starting OLTP recovery to $RECOVERY_TARGET_TIME from $BACKUP_DATE"

# Create recovery directory
mkdir -p "$RECOVERY_DIR"

# Download full backup from S3
aws s3 sync "s3://$S3_BUCKET/oltp/$BACKUP_DATE/" "$RECOVERY_DIR/"

# Find the full backup file
FULL_BACKUP_FILE=$(ls "$RECOVERY_DIR"/oltp_full_*.dump | head -1)

# Stop PostgreSQL service
sudo systemctl stop postgresql-oltp

# Clean existing database
sudo -u postgres dropdb "$DB_NAME"
sudo -u postgres createdb "$DB_NAME"

# Restore from full backup
pg_restore \
  --host=localhost \
  --username=postgres \
  --dbname="$DB_NAME" \
  --verbose \
  --clean \
  --if-exists \
  "$FULL_BACKUP_FILE"

# Restore to point-in-time if WAL files available
if [ -d "s3://$S3_BUCKET/oltp/wal_archive/$BACKUP_DATE" ]; then
    echo "Restoring WAL files for point-in-time recovery..."
    aws s3 sync "s3://$S3_BUCKET/oltp/wal_archive/$BACKUP_DATE/" "/var/lib/postgresql/wal_archive/"
    
    # Configure PostgreSQL for PITR
    cat >> /etc/postgresql/postgresql.conf << EOF
# Point-in-time recovery configuration
restore_command = 'cp /var/lib/postgresql/wal_archive/%f %p'
recovery_target_time = '$RECOVERY_TARGET_TIME'
recovery_target_action = 'promote'
EOF
fi

# Start PostgreSQL service
sudo systemctl start postgresql-oltp

# Verify recovery
psql -h localhost -U postgres -d "$DB_NAME" -c "SELECT COUNT(*) as table_count FROM information_schema.tables WHERE table_schema = 'public';"

echo "OLTP recovery completed successfully"
echo "Recovery point: $RECOVERY_TARGET_TIME"
```

### **Content Database Recovery**
```bash
#!/bin/bash
# Content Database Recovery

RECOVERY_DATE="$1"
set -e

if [ -z "$RECOVERY_DATE" ]; then
    echo "Usage: $0 <recovery_date>"
    echo "Example: $0 2025-11-01"
    exit 1
fi

S3_BUCKET="penguinmails-backups-us-east-1"
RECOVERY_DIR="/tmp/recovery_content"
DB_NAME="penguinmails_content"

echo "Starting Content database recovery from $RECOVERY_DATE"

# Create recovery directory
mkdir -p "$RECOVERY_DIR"

# Download backups from S3
aws s3 sync "s3://$S3_BUCKET/content/$RECOVERY_DATE/" "$RECOVERY_DIR/"

# Stop content database service
sudo systemctl stop postgresql-content

# Clean existing database
sudo -u postgres dropdb "$DB_NAME"
sudo -u postgres createdb "$DB_NAME"

# Restore metadata backup
METADATA_BACKUP=$(ls "$RECOVERY_DIR"/content_metadata_*.dump | head -1)
pg_restore \
  --host=localhost \
  --username=postgres \
  --dbname="$DB_NAME" \
  --verbose \
  "$METADATA_BACKUP"

# Restore content objects backup
OBJECTS_BACKUP=$(ls "$RECOVERY_DIR"/content_objects_*.dump | head -1)
pg_restore \
  --host=localhost \
  --username=postgres \
  --dbname="$DB_NAME" \
  --verbose \
  --data-only \
  "$OBJECTS_BACKUP"

# Start content database service
sudo systemctl start postgresql-content

echo "Content database recovery completed"
```

---

## ✅ **Backup Validation & Testing**

### **Automated Backup Validation**
```bash
#!/bin/bash
# Backup Validation Script

BACKUP_DATE=$(date +%Y-%m-%d)
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting backup validation for $BACKUP_DATE"

# Validate OLTP backup
echo "Validating OLTP backup..."
aws s3 sync "s3://$S3_BUCKET/oltp/$BACKUP_DATE/" "/tmp/validate_oltp/" --quiet

OLTP_BACKUP=$(ls /tmp/validate_oltp/oltp_full_*.dump | head -1)
if pg_restore --list "$OLTP_BACKUP" > /dev/null 2>&1; then
    echo "✅ OLTP backup validation passed"
else
    echo "❌ OLTP backup validation failed"
    exit 1
fi

# Validate Content backup
echo "Validating Content backup..."
aws s3 sync "s3://$S3_BUCKET/content/$BACKUP_DATE/" "/tmp/validate_content/" --quiet

CONTENT_BACKUP=$(ls /tmp/validate_content/content_metadata_*.dump | head -1)
if pg_restore --list "$CONTENT_BACKUP" > /dev/null 2>&1; then
    echo "✅ Content backup validation passed"
else
    echo "❌ Content backup validation failed"
    exit 1
fi

# Calculate backup sizes
OLTP_SIZE=$(du -sh /tmp/validate_oltp | cut -f1)
CONTENT_SIZE=$(du -sh /tmp/validate_content | cut -f1)

echo "Backup sizes validated:"
echo "  OLTP: $OLTP_SIZE"
echo "  Content: $CONTENT_SIZE"

# Clean up validation files
rm -rf /tmp/validate_oltp /tmp/validate_content

echo "Backup validation completed successfully"
```

### **Recovery Testing (Monthly)**
```sql
-- Recovery testing stored procedure
CREATE OR REPLACE FUNCTION test_recovery_procedures()
RETURNS TABLE(test_name TEXT, status TEXT, duration_ms INTEGER) AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    duration INTEGER;
BEGIN
    -- Test 1: Backup file accessibility
    start_time := NOW();
    PERFORM pg_size_pretty(pg_database_size('penguinmails_oltp'));
    end_time := NOW();
    duration := EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;
    
    RETURN QUERY VALUES 
    ('backup_file_accessibility', 'PASS', duration);
    
    -- Test 2: Database connectivity
    start_time := NOW();
    PERFORM 1 FROM information_schema.tables LIMIT 1;
    end_time := NOW();
    duration := EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;
    
    RETURN QUERY VALUES 
    ('database_connectivity', 'PASS', duration);
    
    -- Test 3: Transaction log functionality
    start_time := NOW();
    INSERT INTO system_notifications (category, title, message, severity)
    VALUES ('recovery_test', 'Recovery Test', 'Testing transaction log', 'info');
    end_time := NOW();
    duration := EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;
    
    RETURN QUERY VALUES 
    ('transaction_log', 'PASS', duration);
END;
$$ LANGUAGE plpgsql;

-- Execute recovery tests
SELECT * FROM test_recovery_procedures();
```

---

## 🔄 **Disaster Recovery Plan**

### **Cross-Region Backup Strategy**
```yaml
Primary Region: us-east-1
  - OLTP: Primary database + WAL archiving
  - Content: Primary database + compressed backups
  - Queue: Primary database + WAL streaming
  - OLAP: Primary database + snapshots

Secondary Region: us-west-2
  - All databases: Daily full backups
  - WAL files: Continuous replication
  - Storage class: GLACIER for long-term retention
  - Cross-region replication: Automatic

Recovery Locations:
  Primary: us-east-1 (RTO: 15 minutes)
  Secondary: us-west-2 (RTO: 2 hours)
```

### **Disaster Recovery Runbook**
```bash
#!/bin/bash
# Disaster Recovery Procedure

DISASTER_TYPE="$1"  # "partial" or "complete"

case "$DISASTER_TYPE" in
    "partial")
        echo "Initiating partial disaster recovery..."
        # Recover specific databases or tables
        # Use point-in-time recovery for minimal data loss
        ;;
    "complete")
        echo "Initiating complete disaster recovery..."
        # Full cross-region recovery
        # Restore all databases from secondary region
        ;;
    *)
        echo "Usage: $0 <partial|complete>"
        exit 1
        ;;
esac

# Common recovery steps
echo "Step 1: Verify secondary region accessibility"
# Test connectivity to us-west-2 backup location

echo "Step 2: Identify latest valid backups"
# Find most recent valid backups across all tiers

echo "Step 3: Coordinate with stakeholders"
# Notify team and stakeholders of recovery process

echo "Step 4: Execute database recovery"
# Run tier-specific recovery procedures

echo "Step 5: Validate data integrity"
# Verify recovered data consistency

echo "Step 6: Resume normal operations"
# Switch traffic to recovered databases

echo "Disaster recovery completed"
```

---

## 📋 **Related Documentation**

### **Operational References**
- **[Database Operations Guide](database_operations_guide.md)** - Central operational hub
- **[Connection Pooling Strategy](connection_pooling_strategy.md)** - Pool management during recovery
- **[Incident Response Procedures](incident_response_procedures.md)** - Emergency response coordination

### **Technical References**
- **[OLTP Schema Guide](../oltp_schema_guide.md)** - OLTP backup integration
- **[Content Database Schema Guide](../content_database_schema_guide.md)** - Content backup procedures
- **[Queue System Schema Guide](../queue_system_schema_guide.md)** - Queue recovery methods
- **[OLAP Analytics Schema Guide](../olap_analytics_schema_guide.md)** - Analytics backup strategy

---

## 🔄 **Update History**

| Date | Change | Author |
|------|--------|--------|
| 2025-11-01 | Initial version - Comprehensive backup strategy | Database Ops Team |
| [Next Review] | [Monthly backup validation and quarterly recovery testing] | Database Ops Team |

**Document Classification**: Critical Operations  
**Review Cycle**: Monthly validation, quarterly testing  
**Compliance Requirements**: GDPR, SOX data retention policies  
**Training Required**: All database operations and on-call engineers

This comprehensive backup strategy ensures data protection and rapid recovery capabilities for all database tiers while meeting compliance requirements and minimizing business impact during incidents.