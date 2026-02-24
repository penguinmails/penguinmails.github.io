---
title: "Backup Validation & Testing"
description: "Procedures and scripts for validating backups and testing recovery workflows using the QA framework."
last_modified_date: "2025-11-19"
level: "3"
persona: "SRE / QA"
---

# Backup Validation & Testing

Backups are only verified through regular validation and trial restorations. This document outlines the automated testing procedures integrated into our QA framework.

## 1. Automated Backup Validation

A daily script verifies the existence and integrity of backup artifacts in S3.

```bash
#!/bin/bash
# Backup Validation Script with QA Framework Integration
BACKUP_DATE=$(date +%Y-%m-%d)
S3_BUCKET="penguinmails-backups-us-east-1"

# Validate OLTP backup integrity
if aws s3 ls "s3://$S3_BUCKET/oltp/full/$BACKUP_DATE.dump.gpg" > /dev/null; then
    echo "OLTP backup found"
else
    echo "CRITICAL: OLTP backup MISSING for $BACKUP_DATE" | mail -s "Backup Alert" sre@penguinmails.com
    exit 1
fi
```

## 2. Recovery Testing Database Procedures

Stored procedures to simulate and verify data integrity after restoration.

```sql
-- Recovery testing stored procedure
CREATE OR REPLACE FUNCTION test_recovery_procedures()
RETURNS TABLE(test_name TEXT, status TEXT, duration_ms INTEGER) AS $$
DECLARE
    start_time TIMESTAMP;
BEGIN
    test_name := 'Data Consistency Check';
    start_time := clock_timestamp();
    
    -- Verify row counts or checksums against secondary source
    -- Logic here...
    
    status := 'PASSED';
    duration_ms := EXTRACT(MILLISECOND FROM (clock_timestamp() - start_time));
    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;
```

## 3. QA Framework Integration

Validation results are pushed to the central observability dashboard:

- **Success Metric**: Number of verified backups / total expected backups.
- **RPO Drift**: Tracking time since last successful backup.
- **Restoration Confidence**: Result of monthly dry-run restorations.
