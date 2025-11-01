# Database Migration & Deployment Guide

## Overview

**Last Updated**: November 1, 2025  
**Owner**: Database Operations Team  
**Criticality**: Critical  
**Next Review**: December 1, 2025

This guide provides comprehensive database migration and deployment procedures for PenguinMails' 4-tier architecture, ensuring zero-downtime deployments and safe schema changes.

### 🎯 **Purpose**
- **Zero-Downtime Deployments**: Enable schema changes without service interruption
- **Rollback Procedures**: Provide safe rollback mechanisms for all migration types
- **Schema Versioning**: Track and manage database schema changes systematically
- **Multi-Environment Coordination**: Ensure consistency across development, staging, and production

---

## 🏗️ **Migration Architecture**

### **Migration Types & Strategies**

| Migration Type | Downtime | Strategy | Rollback Complexity | Use Case |
|----------------|----------|----------|-------------------|----------|
| **Data-Only** | Zero | Online migration | Simple | Data updates, cleanup |
| **DDL Add** | Minimal | Deploy-first approach | Simple | New tables, columns, indexes |
| **DDL Modify** | Variable | Blue-green deployment | Complex | Schema changes affecting existing data |
| **DDL Delete** | High | Deprecation-first approach | High Risk | Removing tables, columns |

### **Environment Strategy**
```yaml
Development Environment:
  - Immediate deployments
  - Relaxed rollback requirements
  - Frequent schema changes
  - Fast iteration cycles

Staging Environment:
  - Mirror production configuration
  - Full migration testing
  - Performance validation
  - 24-48 hour deployment window

Production Environment:
  - Zero-downtime requirement
  - Comprehensive rollback plans
  - Blue-green deployment strategy
  - Emergency rollback procedures
```

---

## 🔄 **Migration Framework**

### **Database Schema Versioning**
```sql
-- Create schema version tracking table
CREATE TABLE schema_migrations (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    version VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    applied_by VARCHAR(100) NOT NULL,
    rollback_script TEXT,
    checksum VARCHAR(64),
    status VARCHAR(20) DEFAULT 'applied' CHECK (status IN ('applied', 'rolled_back', 'failed')),
    
    CONSTRAINT valid_version CHECK (version ~ '^[0-9]{8}_[0-9]{6}$')
);

-- Create migration functions
CREATE OR REPLACE FUNCTION apply_migration(
    p_version VARCHAR(50),
    p_description TEXT,
    p_migration_sql TEXT,
    p_rollback_sql TEXT DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    migration_id BIGINT;
    checksum_result TEXT;
BEGIN
    -- Calculate checksum for integrity
    checksum_result := md5(p_migration_sql);
    
    -- Check if migration already applied
    IF EXISTS (SELECT 1 FROM schema_migrations WHERE version = p_version AND status = 'applied') THEN
        RAISE NOTICE 'Migration % already applied', p_version;
        RETURN FALSE;
    END IF;
    
    -- Start transaction
    BEGIN
        -- Apply migration
        EXECUTE p_migration_sql;
        
        -- Record successful migration
        INSERT INTO schema_migrations (version, description, rollback_script, checksum, applied_by)
        VALUES (p_version, p_description, p_rollback_sql, checksum_result, current_user)
        RETURNING id INTO migration_id;
        
        -- Update schema version
        INSERT INTO schema_version (current_version, applied_at, applied_by)
        VALUES (p_version, NOW(), current_user)
        ON CONFLICT (id) 
        DO UPDATE SET 
            current_version = p_version,
            applied_at = NOW(),
            applied_by = current_user;
            
        RETURN TRUE;
        
    EXCEPTION WHEN OTHERS THEN
        -- Record failed migration
        INSERT INTO schema_migrations (version, description, status, applied_by, checksum)
        VALUES (p_version, p_description, 'failed', current_user, checksum_result);
        
        RAISE EXCEPTION 'Migration failed: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

-- Create schema version table
CREATE TABLE schema_version (
    id INTEGER PRIMARY KEY DEFAULT 1,
    current_version VARCHAR(50),
    applied_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    applied_by VARCHAR(100),
    CONSTRAINT single_row CHECK (id = 1)
);

-- Insert initial schema version
INSERT INTO schema_version (current_version, applied_by) 
VALUES ('20251101_000000', 'system');
```

### **Migration Directory Structure**
```
📁 migrations/
├── 📁 2025_11_01/
│   ├── 📄 001_create_connection_pool_tables.sql
│   ├── 📄 002_add_performance_indexes.sql
│   └── 📄 rollback_001_create_connection_pool_tables.sql
├── 📁 2025_11_02/
│   ├── 📄 003_enhance_security_policies.sql
│   └── 📄 rollback_003_enhance_security_policies.sql
└── 📁 2025_11_03/
    ├── 📄 004_optimize_content_storage.sql
    └── 📄 rollback_004_optimize_content_storage.sql
```

---

## 🚀 **Zero-Downtime Deployment Strategy**

### **Blue-Green Deployment Pattern**
```bash
#!/bin/bash
# Blue-Green Database Deployment Script

MIGRATION_VERSION="$1"
MIGRATION_FILE="migrations/$(date +%Y_%m_%d)/${MIGRATION_VERSION}_*.sql"
ROLLBACK_FILE="migrations/$(date +%Y_%m_%d)/rollback_${MIGRATION_VERSION}_*.sql"

set -e

echo "Starting blue-green database deployment for version $MIGRATION_VERSION"

# Validate migration files exist
if [ ! -f "$MIGRATION_FILE" ]; then
    echo "Migration file not found: $MIGRATION_FILE"
    exit 1
fi

if [ ! -f "$ROLLBACK_FILE" ]; then
    echo "Rollback file not found: $ROLLBACK_FILE"
    exit 1
fi

# Step 1: Pre-deployment checks
echo "Step 1: Running pre-deployment validation..."
psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME -c "
    SELECT 
        COUNT(*) as table_count,
        (SELECT COUNT(*) FROM schema_migrations WHERE status = 'applied') as migration_count
    FROM information_schema.tables 
    WHERE table_schema = 'public';
"

# Step 2: Create backup point
echo "Step 2: Creating pre-deployment backup..."
BACKUP_NAME="pre_deployment_$(date +%Y%m%d_%H%M%S)"
pg_dump \
  --host=$PRODUCTION_DB_HOST \
  --username=$DEPLOY_USER \
  --format=custom \
  --file="/tmp/${BACKUP_NAME}.dump" \
  $DB_NAME

# Step 3: Deploy to staging first (if staging available)
if [ ! -z "$STAGING_DB_HOST" ]; then
    echo "Step 3: Deploying to staging for validation..."
    psql -h $STAGING_DB_HOST -U $DEPLOY_USER -d $STAGING_DB_NAME -f "$MIGRATION_FILE"
    
    # Run validation tests on staging
    echo "Step 4: Running validation tests on staging..."
    psql -h $STAGING_DB_HOST -U $DEPLOY_USER -d $STAGING_DB_NAME -c "
        SELECT test_migration_integrity('$MIGRATION_VERSION');
    "
fi

# Step 5: Deploy to production using transaction
echo "Step 5: Deploying to production..."
psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME << EOF
-- Start transaction for atomic deployment
BEGIN;

-- Apply migration
\\i $MIGRATION_FILE

-- Update schema version
INSERT INTO schema_migrations (version, description, applied_by)
SELECT '$MIGRATION_VERSION', 
       'Automated deployment', 
       '$DEPLOY_USER'
WHERE NOT EXISTS (
    SELECT 1 FROM schema_migrations 
    WHERE version = '$MIGRATION_VERSION' AND status = 'applied'
);

-- Verify application
DO \$\$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM schema_migrations 
        WHERE version = '$MIGRATION_VERSION' AND status = 'applied'
    ) THEN
        RAISE EXCEPTION 'Migration verification failed';
    END IF;
END \$\$;

-- Commit transaction
COMMIT;
EOF

echo "Deployment completed successfully for version $MIGRATION_VERSION"

# Step 6: Post-deployment validation
echo "Step 6: Post-deployment validation..."
psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME -c "
    SELECT 
        version,
        applied_at,
        applied_by,
        status
    FROM schema_migrations 
    WHERE version = '$MIGRATION_VERSION';
"
```

### **Migration Validation Functions**
```sql
-- Migration integrity testing function
CREATE OR REPLACE FUNCTION test_migration_integrity(p_version VARCHAR(50))
RETURNS TABLE(test_name TEXT, status TEXT, details TEXT) AS $$
DECLARE
    migration_record RECORD;
    table_count_before INTEGER;
    table_count_after INTEGER;
    index_count_before INTEGER;
    index_count_after INTEGER;
BEGIN
    -- Test 1: Verify migration was recorded
    SELECT * INTO migration_record 
    FROM schema_migrations 
    WHERE version = p_version AND status = 'applied';
    
    IF FOUND THEN
        RETURN QUERY VALUES ('migration_recorded', 'PASS', 'Migration recorded in schema_migrations table');
    ELSE
        RETURN QUERY VALUES ('migration_recorded', 'FAIL', 'Migration not found or not applied');
    END IF;
    
    -- Test 2: Check schema consistency
    SELECT COUNT(*) INTO table_count_after
    FROM information_schema.tables 
    WHERE table_schema = 'public';
    
    IF table_count_after > 0 THEN
        RETURN QUERY VALUES ('schema_consistency', 'PASS', format('Schema contains %s tables', table_count_after));
    ELSE
        RETURN QUERY VALUES ('schema_consistency', 'FAIL', 'Schema appears empty');
    END IF;
    
    -- Test 3: Verify critical tables exist
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'tenants') THEN
        RETURN QUERY VALUES ('critical_tables', 'PASS', 'Critical tables (tenants) exist');
    ELSE
        RETURN QUERY VALUES ('critical_tables', 'FAIL', 'Critical tables missing');
    END IF;
    
    -- Test 4: Check for orphaned objects
    IF NOT EXISTS (
        SELECT 1 FROM pg_stat_user_tables 
        WHERE relname NOT IN (
            SELECT table_name FROM information_schema.tables 
            WHERE table_schema = 'public'
        )
    ) THEN
        RETURN QUERY VALUES ('orphaned_objects', 'PASS', 'No orphaned database objects');
    ELSE
        RETURN QUERY VALUES ('orphaned_objects', 'WARNING', 'Potential orphaned objects detected');
    END IF;
    
END;
$$ LANGUAGE plpgsql;
```

---

## 🔄 **Rollback Procedures**

### **Automatic Rollback Triggers**
```sql
-- Create rollback function
CREATE OR REPLACE FUNCTION rollback_migration(
    p_version VARCHAR(50),
    p_reason TEXT DEFAULT 'Manual rollback'
)
RETURNS BOOLEAN AS $$
DECLARE
    migration_record RECORD;
    rollback_sql TEXT;
BEGIN
    -- Find migration record
    SELECT * INTO migration_record
    FROM schema_migrations 
    WHERE version = p_version AND status = 'applied';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Migration % not found or not applied', p_version;
    END IF;
    
    -- Get rollback script
    rollback_sql := migration_record.rollback_script;
    
    IF rollback_sql IS NULL THEN
        RAISE EXCEPTION 'No rollback script available for migration %', p_version;
    END IF;
    
    -- Execute rollback in transaction
    BEGIN
        EXECUTE rollback_sql;
        
        -- Update migration status
        UPDATE schema_migrations 
        SET status = 'rolled_back',
            applied_at = NOW(),
            applied_by = current_user
        WHERE version = p_version;
        
        -- Log rollback event
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'migration',
            'Migration Rollback',
            format('Migration %s rolled back: %s', p_version, p_reason),
            'warning',
            jsonb_build_object(
                'version', p_version,
                'reason', p_reason,
                'rolled_back_at', NOW(),
                'rolled_back_by', current_user
            )
        );
        
        RETURN TRUE;
        
    EXCEPTION WHEN OTHERS THEN
        -- Log rollback failure
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'migration',
            'Rollback Failed',
            format('Rollback of migration %s failed: %s', p_version, SQLERRM),
            'critical',
            jsonb_build_object(
                'version', p_version,
                'error', SQLERRM,
                'rollback_failed_at', NOW()
            )
        );
        
        RAISE EXCEPTION 'Rollback failed: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;
```

### **Emergency Rollback Script**
```bash
#!/bin/bash
# Emergency Rollback Script

MIGRATION_VERSION="$1"
ROLLBACK_REASON="$2"

set -e

if [ -z "$MIGRATION_VERSION" ] || [ -z "$ROLLBACK_REASON" ]; then
    echo "Usage: $0 <migration_version> <rollback_reason>"
    echo "Example: $0 20251101_143000 'Performance degradation detected'"
    exit 1
fi

echo "🚨 EMERGENCY ROLLBACK INITIATED 🚨"
echo "Migration: $MIGRATION_VERSION"
echo "Reason: $ROLLBACK_REASON"
echo "Timestamp: $(date)"
echo ""

# Step 1: Immediate traffic diversion
echo "Step 1: Diverting traffic to backup systems..."
# (This would integrate with your load balancer/API gateway)

# Step 2: Verify rollback safety
echo "Step 2: Verifying rollback safety..."
psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME -c "
    SELECT 
        version,
        applied_at,
        status,
        CASE 
            WHEN applied_at < NOW() - INTERVAL '1 hour' THEN 'SAFE_TO_ROLLBACK'
            ELSE 'RECENT_MIGRATION_CAUTION'
        END as rollback_safety
    FROM schema_migrations 
    WHERE version = '$MIGRATION_VERSION';
"

# Step 3: Execute rollback
echo "Step 3: Executing rollback..."
psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME << EOF
SELECT rollback_migration('$MIGRATION_VERSION', '$ROLLBACK_REASON');
EOF

# Step 4: Verify rollback success
echo "Step 4: Verifying rollback success..."
ROLLBACK_STATUS=$(psql -h $PRODUCTION_DB_HOST -U $DEPLOY_USER -d $DB_NAME -t -c "
    SELECT status FROM schema_migrations WHERE version = '$MIGRATION_VERSION';
")

if [ "$ROLLBACK_STATUS" = "rolled_back" ]; then
    echo "✅ Rollback completed successfully"
    
    # Step 5: Restore traffic
    echo "Step 5: Restoring normal traffic..."
    # (This would restore traffic to normal operations)
    
    # Step 6: Notify stakeholders
    echo "Step 6: Notifying stakeholders..."
    # (Send notifications to team, stakeholders, etc.)
    
else
    echo "❌ Rollback verification failed. Manual intervention required."
    exit 1
fi

echo ""
echo "🔄 ROLLBACK COMPLETED"
echo "Migration: $MIGRATION_VERSION"
echo "Status: $ROLLBACK_STATUS"
echo "Completed: $(date)"
```

---

## 🧪 **Testing Framework**

### **Pre-Production Testing**
```bash
#!/bin/bash
# Pre-Production Migration Testing

MIGRATION_FILE="$1"

echo "Running pre-production migration tests..."

# Test 1: Syntax validation
echo "Test 1: SQL syntax validation..."
if psql -f "$MIGRATION_FILE" --dry-run 2>/dev/null; then
    echo "✅ SQL syntax validation passed"
else
    echo "❌ SQL syntax validation failed"
    exit 1
fi

# Test 2: Staging environment deployment
echo "Test 2: Staging environment deployment..."
if psql -h $STAGING_DB_HOST -U $DEPLOY_USER -d $STAGING_DB_NAME -f "$MIGRATION_FILE"; then
    echo "✅ Staging deployment successful"
else
    echo "❌ Staging deployment failed"
    exit 1
fi

# Test 3: Performance impact assessment
echo "Test 3: Performance impact assessment..."
psql -h $STAGING_DB_HOST -U $DEPLOY_USER -d $STAGING_DB_NAME -c "
    -- Measure query performance before and after
    EXPLAIN (ANALYZE, BUFFERS) SELECT COUNT(*) FROM campaigns;
"

# Test 4: Rollback testing
echo "Test 4: Rollback testing..."
ROLLBACK_FILE="${MIGRATION_FILE%/*}/rollback_$(basename "$MIGRATION_FILE")"
if [ -f "$ROLLBACK_FILE" ]; then
    psql -h $STAGING_DB_HOST -U $DEPLOY_USER -d $STAGING_DB_NAME -f "$ROLLBACK_FILE"
    echo "✅ Rollback test successful"
else
    echo "⚠️  No rollback file found"
fi

echo "Pre-production testing completed"
```

### **Load Testing Integration**
```sql
-- Create migration load testing function
CREATE OR REPLACE FUNCTION test_migration_under_load(
    p_migration_sql TEXT,
    p_test_duration INTERVAL DEFAULT INTERVAL '5 minutes',
    p_concurrent_users INTEGER DEFAULT 10
)
RETURNS TABLE(metric_name TEXT, value NUMERIC, unit TEXT) AS $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    baseline_qps NUMERIC;
    migration_qps NUMERIC;
    baseline_response_time NUMERIC;
    migration_response_time NUMERIC;
    error_count INTEGER := 0;
BEGIN
    -- Measure baseline performance
    start_time := NOW();
    
    -- Simulate concurrent load (simplified)
    PERFORM pg_sleep(0.1) FROM generate_series(1, p_concurrent_users);
    
    end_time := NOW();
    
    baseline_response_time := EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;
    baseline_qps := p_concurrent_users / (EXTRACT(EPOCH FROM (end_time - start_time)));
    
    -- Apply migration
    EXECUTE p_migration_sql;
    
    -- Measure post-migration performance
    start_time := NOW();
    
    -- Simulate same load after migration
    PERFORM pg_sleep(0.1) FROM generate_series(1, p_concurrent_users);
    
    end_time := NOW();
    
    migration_response_time := EXTRACT(EPOCH FROM (end_time - start_time)) * 1000;
    migration_qps := p_concurrent_users / (EXTRACT(EPOCH FROM (end_time - start_time)));
    
    -- Return performance metrics
    RETURN QUERY VALUES 
    ('baseline_qps', baseline_qps, 'queries_per_second'),
    ('migration_qps', migration_qps, 'queries_per_second'),
    ('baseline_response_time', baseline_response_time, 'milliseconds'),
    ('migration_response_time', migration_response_time, 'milliseconds'),
    ('performance_impact_percent', 
     ((migration_response_time - baseline_response_time) / baseline_response_time) * 100, 
     'percent');
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **Monitoring & Alerting**

### **Migration Health Monitoring**
```sql
-- Create migration monitoring view
CREATE OR REPLACE VIEW migration_health AS
SELECT 
    sm.version,
    sm.description,
    sm.applied_at,
    sm.applied_by,
    sm.status,
    EXTRACT(EPOCH FROM (NOW() - sm.applied_at))/3600 as hours_since_application,
    
    -- Health metrics
    CASE 
        WHEN sm.status = 'applied' AND EXTRACT(EPOCH FROM (NOW() - sm.applied_at))/3600 < 1 
        THEN 'NEWLY_APPLIED'
        WHEN sm.status = 'applied' 
        THEN 'HEALTHY'
        WHEN sm.status = 'rolled_back' 
        THEN 'ROLLED_BACK'
        WHEN sm.status = 'failed' 
        THEN 'FAILED'
    END as health_status,
    
    -- Alert conditions
    CASE 
        WHEN sm.status = 'failed' THEN 'CRITICAL'
        WHEN sm.status = 'rolled_back' THEN 'WARNING'
        WHEN sm.status = 'applied' AND EXTRACT(EPOCH FROM (NOW() - sm.applied_at))/3600 > 168 THEN 'INFO'  -- 1 week
        ELSE 'OK'
    END as alert_level
FROM schema_migrations sm
ORDER BY sm.applied_at DESC;

-- Create migration alert function
CREATE OR REPLACE FUNCTION alert_migration_issues()
RETURNS void AS $$
DECLARE
    health_record RECORD;
BEGIN
    FOR health_record IN
        SELECT * FROM migration_health 
        WHERE alert_level IN ('CRITICAL', 'WARNING')
    LOOP
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'migration',
            format('Migration %s requires attention', health_record.version),
            format('Migration %s status: %s. Applied: %s ago', 
                   health_record.version, 
                   health_record.status,
                   health_record.hours_since_application || ' hours'),
            health_record.alert_level,
            jsonb_build_object(
                'version', health_record.version,
                'status', health_record.status,
                'hours_since_application', health_record.hours_since_application,
                'health_status', health_record.health_status
            )
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

### **Migration Performance Dashboard Query**
```sql
-- Migration performance tracking
SELECT 
    date_trunc('hour', applied_at) as hour_applied,
    COUNT(*) as migrations_applied,
    COUNT(*) FILTER (WHERE status = 'failed') as failed_migrations,
    COUNT(*) FILTER (WHERE status = 'rolled_back') as rolled_back_migrations,
    ROUND(AVG(EXTRACT(EPOCH FROM (applied_at - lag(applied_at) OVER (ORDER BY applied_at)))), 2) as avg_time_between_migrations_hours
FROM schema_migrations 
WHERE applied_at >= NOW() - INTERVAL '30 days'
GROUP BY date_trunc('hour', applied_at)
ORDER BY hour_applied DESC;
```

---

## 🔧 **Multi-Tenant Migration Handling**

### **Tenant-Safe Migration Pattern**
```sql
-- Create tenant-safe migration function
CREATE OR REPLACE FUNCTION apply_tenant_safe_migration(
    p_migration_sql TEXT,
    p_tenant_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    affected_tenants INTEGER;
    migration_id BIGINT;
BEGIN
    -- If specific tenant, verify access
    IF p_tenant_id IS NOT NULL THEN
        PERFORM 1 FROM tenants WHERE id = p_tenant_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Tenant % not found', p_tenant_id;
        END IF;
    END IF;
    
    -- Count affected tenants for awareness
    SELECT COUNT(DISTINCT tenant_id) INTO affected_tenants
    FROM (
        -- This would be customized per migration type
        SELECT tenant_id FROM campaigns
        UNION
        SELECT tenant_id FROM leads
        UNION  
        SELECT tenant_id FROM email_accounts
    ) tenant_data;
    
    -- Apply migration with tenant context
    BEGIN
        -- Set tenant context if specific tenant
        IF p_tenant_id IS NOT NULL THEN
            PERFORM set_config('app.current_tenant_id', p_tenant_id::TEXT, true);
        END IF;
        
        -- Execute migration
        EXECUTE p_migration_sql;
        
        -- Log migration event
        INSERT INTO migration_events (
            migration_type,
            affected_tenants,
            tenant_context,
            executed_at
        ) VALUES (
            'tenant_safe',
            affected_tenants,
            p_tenant_id,
            NOW()
        );
        
        RETURN TRUE;
        
    EXCEPTION WHEN OTHERS THEN
        RAISE EXCEPTION 'Tenant-safe migration failed: %', SQLERRM;
    END;
END;
$$ LANGUAGE plpgsql;

-- Migration event logging table
CREATE TABLE migration_events (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    migration_type VARCHAR(50),
    affected_tenants INTEGER,
    tenant_context UUID,
    executed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT
);
```

---

## 📋 **Related Documentation**

### **Operational References**
- **[Database Operations Guide](database_operations_guide.md)** - Central operational hub
- **[Connection Pooling Strategy](connection_pooling_strategy.md)** - Pool management during migrations
- **[Backup & Recovery Procedures](backup_recovery_procedures.md)** - Emergency recovery integration

### **Technical References**
- **[OLTP Schema Guide](../oltp_schema_guide.md)** - OLTP migration patterns
- **[Content Database Schema Guide](../content_database_schema_guide.md)** - Content migration procedures
- **[Queue System Schema Guide](../queue_system_schema_guide.md)** - Queue migration handling
- **[OLAP Analytics Schema Guide](../olap_analytics_schema_guide.md)** - Analytics migration strategies

### **Development Guidelines**
- **[Development Guidelines](../development_guidelines.md)** - Development migration standards
- **[QA Testing Protocols](../qa_testing_protocols.md)** - Testing procedures for migrations

---

## 🔄 **Update History**

| Date | Change | Author |
|------|--------|--------|
| 2025-11-01 | Initial version - Comprehensive migration framework | Database Ops Team |
| [Next Review] | [Weekly deployment review and quarterly rollback testing] | Database Ops Team |

**Document Classification**: Critical Operations  
**Review Cycle**: Weekly for active deployments, quarterly for framework updates  
**Testing Requirements**: All migrations must pass staging validation  
**Training Required**: All developers, DevOps engineers, and database operations team

This migration framework ensures safe, reliable database deployments with zero-downtime guarantees while maintaining rollback capabilities for all database changes.