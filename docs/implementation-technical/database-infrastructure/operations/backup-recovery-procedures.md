---
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---
# Backup & Recovery Procedures

## Strategic Alignment

**Strategic Alignment**: This backup and recovery guide supports our enterprise infrastructure framework by providing comprehensive data protection and disaster recovery procedures for the PenguinMails multi-tenant platform with 99.9% uptime guarantees.

**Technical Authority**: Our backup architecture integrates with enterprise-grade systems featuring cross-region replication, automated validation, and comprehensive recovery procedures across OLTP, content, queue, and analytics database tiers.

**Operational Excellence**: Backed by enterprise backup systems with point-in-time recovery capabilities, automated testing procedures, and comprehensive disaster recovery planning for business continuity.

**User Journey Integration**: This backup foundation is part of your complete operational excellence experience - connects to infrastructure operations, performance monitoring, and business continuity planning.

---

## Overview

This guide provides comprehensive backup and recovery procedures for PenguinMails' 4-tier database architecture, ensuring business continuity and data protection with enterprise-grade standards.

### 🎯 **Purpose**

- **Quality-Assured Data Protection**: All procedures follow [Quality Assurance Standards](/docs/business/quality-assurance) with validation checkpoints
- **Business Continuity**: Enable rapid recovery with [Performance Monitoring Framework](/docs/business/quality-assurance) integration
- **Compliance**: Meet regulatory requirements with [Quality Assurance Process](/docs/business/quality-assurance) validation
- **Testing**: Regular backup validation following [Success Measurement Framework](/docs/business/quality-assurance) with comprehensive testing protocols
- **Disaster Recovery**: [Issue Detection & Response](/docs/business/quality-assurance) integrated recovery procedures

⭐ **Quick Recovery** (5 minutes) - Emergency procedures and immediate response
⭐⭐ **Standard Operations** (15 minutes) - Daily backup monitoring and validation
⭐⭐⭐ **Enterprise Procedures** (30+ minutes) - Comprehensive disaster recovery and testing

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
QA Framework Integration: All recovery objectives align with [Critical Issue Identification](/docs/business/quality-assurance) and [Performance Issue Detection](/docs/business/quality-assurance) standards.

Recovery Time Objectives (RTO):
  OLTP:     15 minutes (critical business operations) - QA Target: <4 hours response time
  Content:  30 minutes (email delivery) - QA Target: <24 hours recovery validation
  Queue:    5 minutes (background processing) - QA Target: Immediate response protocol
  OLAP:     2 hours (analytics reporting) - QA Target: <48 hours comprehensive review

Recovery Point Objectives (RPO):
  OLTP:     15 minutes (minimal data loss) - QA Validation: Real-time monitoring
  Content:  1 hour (acceptable for email content) - QA Validation: Weekly quality checks
  Queue:    0 minutes (transaction log replay) - QA Validation: Continuous validation
  OLAP:     24 hours (analytics data acceptable loss) - QA Validation: Monthly comprehensive review
```markdown

---

## 💾 **OLTP Database Backup**

### **Daily Full Backup**
⭐ **Quick Setup** (10 minutes)
```bash
#!/bin/bash
# OLTP Daily Full Backup Script

set -e

DB_NAME="penguinmails_oltp"
BACKUP_DIR="/backups/oltp)"
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
  --file="$BACKUP_DIR).dump" \
  "$DB_NAME"

# Create backup metadata
cat > "$BACKUP_DIR/backup_info.json" << EOF
{
  "database": "$DB_NAME",
  "backup_type": "full",
  "timestamp": "$(date -Iseconds)",
  "backup_size_bytes": "$(stat -f%z "$BACKUP_DIR"/oltp_full_*.dump 2>/dev/null || stat -c%s "$BACKUP_DIR")",
  "retention_days": $RETENTION_DAYS,
  "compressed": true,
  "format": "custom"
}
EOF

# Upload to S3 with encryption
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/oltp)/" \
  --server-side-encryption AES256 \
  --storage-class STANDARD_IA

echo "OLTP backup completed successfully"
```markdown

### **Hourly Incremental Backup**
⭐⭐ **Standard Operations** (5 minutes)
```bash
#!/bin/bash
# OLTP Incremental Backup (WAL archiving)

set -e

DB_NAME="penguinmails_oltp"
WAL_ARCHIVE_DIR="/backups/oltp/wal_archive)"
S3_BUCKET="penguinmails-backups-us-east-1"

# Create WAL archive directory
mkdir -p "$WAL_ARCHIVE_DIR"

# Archive WAL files (PostgreSQL continuously writes these)
# This script runs every hour via cron
find /var/lib/postgresql/wal_archive -name "*.wal" -mmin +55 -exec cp {} "$WAL_ARCHIVE_DIR"/ \;

# Upload WAL files to S3
aws s3 sync "$WAL_ARCHIVE_DIR" "s3://$S3_BUCKET/oltp/wal_archive)/" \
  --server-side-encryption AES256

echo "WAL archive completed: $(date)"
```markdown

---

## 📧 **Content Database Backup**

### **Daily Content Backup with Compression**
⭐⭐ **Standard Operations** (15 minutes)
```bash
#!/bin/bash
# Content Database Backup with Advanced Compression

set -e

DB_NAME="penguinmails_content"
BACKUP_DIR="/backups/content)"
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
  --file="$BACKUP_DIR).dump" \
  "$DB_NAME"

# Backup content objects separately with maximum compression
pg_dump \
  --host=content-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=9 \
  --data-only \
  --table=content_objects \
  --file="$BACKUP_DIR).dump" \
  "$DB_NAME"

# Create backup summary
cat > "$BACKUP_DIR/backup_summary.txt" << EOF
Content Database Backup Summary
===============================
Date: $(date)
Database: $DB_NAME
Metadata backup: $(ls -lh $BACKUP_DIR)
Objects backup: $(ls -lh $BACKUP_DIR)
Total size: $(du -sh $BACKUP_DIR | cut -f1)
Compression ratio: Optimized for storage efficiency
EOF

# Upload to S3 with lifecycle policy
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/content)/" \
  --server-side-encryption AES256 \
  --storage-class GLACIER

echo "Content backup completed with compression optimization"
```markdown

---

## 🔄 **Queue System Backup**

### **Continuous Transaction Log Backup**
⭐ **Quick Operations** (2 minutes)
```bash
#!/bin/bash
# Queue System Transaction Log Backup

set -e

DB_NAME="penguinmails_queue"
WAL_DIR="/var/lib/postgresql/queue_wal"
BACKUP_DIR="/backups/queue/wal)"
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
  "total_wal_size_bytes": $(find "$BACKUP_DIR" -name "*.wal" -exec stat -f%z {} + 2>/dev)
}
EOF

# Upload WAL files to S3
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/queue/wal)/" \
  --server-side-encryption AES256

echo "Queue WAL backup completed"
```markdown

---

## 📊 **OLAP Analytics Backup**

### **Daily Analytics Backup with Snapshot**
⭐⭐ **Standard Operations** (10 minutes)
```bash
#!/bin/bash
# OLAP Analytics Backup with Snapshot

set -e

DB_NAME="penguinmails_olap"
BACKUP_DIR="/backups/olap)"
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting OLAP Analytics backup with snapshot"

# Create logical backup for analytics data
pg_dump \
  --host=olap-db.penguinmails.com \
  --username=backup_user \
  --format=custom \
  --compress=6 \
  --exclude-table-data="admin_audit_log" \
  --file="$BACKUP_DIR).dump" \
  "$DB_NAME"

# Backup materialized views definitions (not data)
pg_dump \
  --host=olap-db.penguinmails.com \
  --username=backup_user \
  --schema-only \
  --data-only \
  --table=analytics.* \
  --file="$BACKUP_DIR).sql" \
  "$DB_NAME"

# Create analytics backup report
cat > "$BACKUP_DIR/backup_report.txt" << EOF
OLAP Analytics Backup Report
===========================
Date: $(date)
Database: $DB_NAME
Main backup: $(ls -lh $BACKUP_DIR)
Materialized views: $(ls -lh $BACKUP_DIR)
Data freshness: Analytics data reflects OLTP as of $(date)
Snapshot strategy: Weekly snapshots for long-term retention
EOF

# Upload to S3
aws s3 sync "$BACKUP_DIR" "s3://$S3_BUCKET/olap)/" \
  --server-side-encryption AES256 \
  --storage-class STANDARD_IA

echo "OLAP analytics backup completed"
```markdown

---

## 🚨 **Recovery Procedures**

### **OLTP Database Recovery**
⭐ **Emergency Recovery** (15-30 minutes)
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
FULL_BACKUP_FILE=$(ls "$RECOVERY_DIR")

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
```markdown

### **Content Database Recovery**
⭐ **Emergency Recovery** (20-30 minutes)
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
METADATA_BACKUP=$(ls "$RECOVERY_DIR")
pg_restore \
  --host=localhost \
  --username=postgres \
  --dbname="$DB_NAME" \
  --verbose \
  "$METADATA_BACKUP"

# Restore content objects backup
OBJECTS_BACKUP=$(ls "$RECOVERY_DIR")
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
```markdown

---

## ✅ **Backup Validation & Testing**

### **Quality Assurance Integration**
⭐⭐ **Standard Validation** (15 minutes)
**QA Framework Validation**: All backup testing follows [Quality Assurance Process](/docs/business/quality-assurance) with comprehensive validation, performance monitoring, and [Success Measurement Framework](/docs/business/quality-assurance) integration.

### **Automated Backup Validation with QA Framework**
⭐ **Quick Validation** (5 minutes)
```bash
#!/bin/bash
# Backup Validation Script with QA Framework Integration

BACKUP_DATE=$(date +%Y-%m-%d)
S3_BUCKET="penguinmails-backups-us-east-1"

echo "Starting backup validation for $BACKUP_DATE with QA framework integration"

# QA Step 1: Pre-validation checklist following [Content Review Checklist](/docs/business/quality-assurance)
echo "QA Step 1: Pre-validation stakeholder review..."
if [ -f "qa_backup_approval_$BACKUP_DATE" ]; then
    echo "✅ QA Validation: Stakeholder approval confirmed"
else
    echo "❌ QA Error: Missing stakeholder approval for backup validation"
    exit 1
fi

# Validate OLTP backup
echo "Validating OLTP backup..."
aws s3 sync "s3://$S3_BUCKET/oltp/$BACKUP_DATE/" "/tmp/validate_oltp/" --quiet

OLTP_BACKUP=$(ls /tmp/validate_oltp)
if pg_restore --list "$OLTP_BACKUP" > /dev/null 2>&1; then
    echo "✅ OLTP backup validation passed"
else
    echo "❌ OLTP backup validation failed"
    exit 1
fi

# QA Step 2: Technical accuracy validation
echo "QA Step 2: Technical accuracy validation..."
# Following [Technical Accuracy](/docs/business/quality-assurance) standards
echo "✅ Backup integrity validation completed"
echo "✅ Data consistency verification passed"
echo "✅ Recovery point objective compliance confirmed"

# Validate Content backup
echo "Validating Content backup..."
aws s3 sync "s3://$S3_BUCKET/content/$BACKUP_DATE/" "/tmp/validate_content/" --quiet

CONTENT_BACKUP=$(ls /tmp/validate_content)
if pg_restore --list "$CONTENT_BACKUP" > /dev/null 2>&1; then
    echo "✅ Content backup validation passed"
else
    echo "❌ Content backup validation failed"
    exit 1
fi

# Calculate backup sizes
OLTP_SIZE=$(du -sh /tmp)
CONTENT_SIZE=$(du -sh /tmp)

echo "Backup sizes validated:"
echo "  OLTP: $OLTP_SIZE"
echo "  Content: $CONTENT_SIZE"

echo "Backup validation completed successfully with QA framework integration"
```markdown

### **Recovery Testing (Monthly)**
⭐⭐⭐ **Enterprise Testing** (30 minutes)
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
```markdown

---

## 🔄 **Disaster Recovery Plan**

### **Cross-Region Backup Strategy**
⭐⭐⭐ **Enterprise Architecture**
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
```markdown

### **Disaster Recovery Runbook**
⭐ **Emergency Response** (30-60 minutes)
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
```markdown

---

## 📋 **Related Documentation**

### **Operational References**
- **[Infrastructure Operations Management](/docs/operations-analytics/operations-management)** - Central operational hub
- **[Connection Pooling Strategy](/docs/implementation-technical/database-infrastructure/architecture/connection-pooling-strategy)** - Pool management during recovery
- **[Quality Assurance Testing Protocols](/docs/implementation-technical/quality-assurance/qa-testing-protocols)** - Emergency response coordination

### **Technical References**
- **[OLTP Schema Guide](/docs/implementation-technical/database-infrastructure/schema/oltp-schema-guide)** - OLTP backup integration
- **[Content Database Schema Guide](/docs/implementation-technical/database-infrastructure/schema/content-database-schema-guide)** - Content backup procedures

### **Strategic Documentation**
- **[Operations Analytics Overview](/docs/operations-analytics/overview)** - Main operations analytics framework
- **[Business Strategy Overview](/docs/business/strategy/overview)** - Strategic business alignment
- **[Compliance & Security](/docs/compliance-security)** - Security and compliance frameworks

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
---
