# Database Performance Monitoring Guide

## Overview

**Last Updated**: November 1, 2025  
**Owner**: Database Operations Team  
**Criticality**: Critical  
**Next Review**: December 1, 2025

This guide provides comprehensive database performance monitoring procedures for PenguinMails' 4-tier database architecture, enabling proactive performance management and optimization.

### 🎯 **Purpose**
- **Real-time Monitoring**: Continuous performance tracking across all database tiers
- **Performance Analysis**: Query optimization and resource utilization analysis
- **Predictive Scaling**: Capacity planning and automated scaling triggers
- **Performance Alerting**: Proactive notification system for performance issues

---

## 🏗️ **Performance Monitoring Architecture**

### **4-Tier Monitoring Strategy**

| Database Tier | Key Metrics | Monitoring Frequency | Alert Thresholds | Retention Period |
|---------------|-------------|---------------------|------------------|------------------|
| **OLTP** | Query response time, connection pool usage, transaction throughput | 30 seconds | >5s response, >90% pool usage | 90 days |
| **Content** | Storage efficiency, compression ratio, retrieval latency | 2 minutes | >200ms retrieval, <50% compression | 180 days |
| **Queue** | Job processing rate, queue depth, worker utilization | 1 minute | >100 jobs backlog, <80% worker utilization | 30 days |
| **OLAP** | Query execution time, materialized view refresh, report generation | 5 minutes | >30s execution, <95% view freshness | 365 days |

---

## 📊 **Real-time Performance Metrics**

### **OLTP Performance Monitoring**
```sql
-- OLTP Real-time Performance Dashboard
CREATE OR REPLACE VIEW oltp_performance_realtime AS
SELECT 
    -- Connection Pool Metrics
    cpc.pool_name,
    cpc.min_connections,
    cpc.max_connections,
    cpm.active_connections,
    cpm.idle_connections,
    cpm.pending_acquires,
    ROUND(cpm.connection_usage_rate, 2) as usage_rate_percent,
    
    -- Query Performance Metrics
    ROUND(AVG(pg_stat_statements.mean_time), 2) as avg_query_time_ms,
    MAX(pg_stat_statements.max_time) as max_query_time_ms,
    COUNT(pg_stat_statements.calls) as total_queries,
    
    -- Transaction Metrics
    ROUND(AVG(pg_stat_database.xact_commit::DECIMAL / NULLIF(pg_stat_database.xact_commit + pg_stat_database.xact_rollback, 0) * 100), 2) as success_rate_percent,
    
    -- Database Health
    ROUND(100.0 * pg_stat_database.blks_hit / NULLIF(pg_stat_database.blks_hit + pg_stat_database.blks_read, 0), 2) as cache_hit_rate_percent,
    
    -- Timestamp
    NOW() as collected_at
    
FROM connection_pool_config cpc
JOIN connection_pool_metrics cpm ON cpc.id = cpm.pool_config_id
JOIN pg_stat_database ON pg_stat_database.datname = current_database()
LEFT JOIN pg_stat_statements ON pg_stat_statements.queryid IS NOT NULL
WHERE cpc.tier = 'oltp'
AND cpm.collected_at >= NOW() - INTERVAL '5 minutes'
GROUP BY cpc.id, cpc.pool_name, cpc.min_connections, cpc.max_connections, 
         cpm.active_connections, cpm.idle_connections, cpm.pending_acquires, 
         cpm.connection_usage_rate
ORDER BY cpm.collected_at DESC;
```

### **Content Database Performance Monitoring**
```sql
-- Content Storage Performance Dashboard
CREATE OR REPLACE VIEW content_performance_realtime AS
SELECT 
    -- Storage Efficiency Metrics
    DATE_TRUNC('hour', created) as hour_bucket,
    COUNT(*) as total_objects,
    COUNT(*) FILTER (WHERE compression_algorithm IS NOT NULL) as compressed_objects,
    AVG(raw_size_bytes) as avg_raw_size,
    AVG(COALESCE(compressed_size_bytes, raw_size_bytes)) as avg_compressed_size,
    
    -- Compression Analysis
    ROUND(
        CASE 
            WHEN AVG(raw_size_bytes) > 0 THEN 
                ((AVG(raw_size_bytes) - AVG(COALESCE(compressed_size_bytes, raw_size_bytes)))::DECIMAL / AVG(raw_size_bytes)) * 100
            ELSE 0 
        END, 2
    ) as compression_ratio_percent,
    
    -- Access Patterns
    COUNT(*) FILTER (WHERE last_accessed >= NOW() - INTERVAL '24 hours') as accessed_24h,
    COUNT(*) FILTER (WHERE last_accessed >= NOW() - INTERVAL '7 days') as accessed_7d,
    
    -- Performance Indicators
    AVG(EXTRACT(EPOCH FROM (last_accessed - created))) as avg_age_hours,
    
    -- Tier Distribution
    COUNT(*) FILTER (WHERE created >= NOW() - INTERVAL '30 days') as hot_tier,
    COUNT(*) FILTER (WHERE created < NOW() - INTERVAL '30 days' AND created >= NOW() - INTERVAL '365 days') as warm_tier,
    COUNT(*) FILTER (WHERE created < NOW() - INTERVAL '365 days') as cold_tier
    
FROM email_content
WHERE created >= NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', created)
ORDER BY hour_bucket DESC;
```

### **Queue System Performance Monitoring**
```sql
-- Queue Performance Real-time Dashboard
CREATE OR REPLACE VIEW queue_performance_realtime AS
SELECT 
    q.queue_name,
    q.default_priority,
    q.max_concurrent_jobs,
    
    -- Job Queue Metrics
    COUNT(j.id) FILTER (WHERE j.status = 'queued') as queued_jobs,
    COUNT(j.id) FILTER (WHERE j.status = 'processing') as processing_jobs,
    COUNT(j.id) FILTER (WHERE j.status = 'completed' AND j.completed >= NOW() - INTERVAL '1 hour') as completed_1h,
    COUNT(j.id) FILTER (WHERE j.status = 'failed' AND j.failed >= NOW() - INTERVAL '1 hour') as failed_1h,
    
    -- Performance Metrics
    AVG(EXTRACT(EPOCH FROM (j.completed - j.started))) as avg_processing_time_seconds,
    MAX(EXTRACT(EPOCH FROM (j.completed - j.started))) as max_processing_time_seconds,
    
    -- Success Rate
    ROUND(
        COUNT(j.id) FILTER (WHERE j.status = 'completed')::DECIMAL / 
        NULLIF(COUNT(j.id) FILTER (WHERE j.status IN ('completed', 'failed')), 0) * 100, 
        2
    ) as success_rate_percent,
    
    -- Queue Health Indicators
    COUNT(j.id) FILTER (WHERE j.created <= NOW() - INTERVAL '4 hours' AND j.status = 'queued') as stale_jobs,
    
    -- Priority Distribution
    COUNT(j.id) FILTER (WHERE j.priority <= 25) as critical_priority,
    COUNT(j.id) FILTER (WHERE j.priority > 25 AND j.priority <= 50) as high_priority,
    COUNT(j.id) FILTER (WHERE j.priority > 50 AND j.priority <= 150) as normal_priority,
    COUNT(j.id) FILTER (WHERE j.priority > 150) as low_priority
    
FROM job_queues q
LEFT JOIN jobs j ON q.name = j.queue_name
WHERE j.created >= NOW() - INTERVAL '24 hours'
   OR j.id IS NULL
GROUP BY q.name, q.default_priority, q.max_concurrent_jobs
ORDER BY queued_jobs DESC, avg_processing_time_seconds DESC;
```

### **OLAP Analytics Performance Monitoring**
```sql
-- OLAP Analytics Performance Dashboard
CREATE OR REPLACE VIEW olap_performance_realtime AS
SELECT 
    -- Query Performance
    DATE_TRUNC('hour', updated) as hour_bucket,
    table_name,
    
    -- Performance Metrics
    AVG(query_duration_ms) as avg_query_duration_ms,
    MAX(query_duration_ms) as max_query_duration_ms,
    AVG(memory_usage_mb) as avg_memory_usage_mb,
    
    -- Query Volume
    COUNT(*) as total_queries,
    COUNT(*) FILTER (WHERE query_duration_ms > 30000) as slow_queries,
    COUNT(*) FILTER (WHERE query_duration_ms > 60000) as very_slow_queries,
    
    -- Cache Performance
    AVG(cache_hit_rate) as avg_cache_hit_rate,
    COUNT(*) FILTER (WHERE cache_hit_rate < 0.8) as poor_cache_performance,
    
    -- Resource Utilization
    AVG(parallel_workers_used) as avg_parallel_workers,
    AVG(temp_space_usage_mb) as avg_temp_space_mb
    
FROM admin_audit_log
WHERE performance_category IS NOT NULL
AND updated >= NOW() - INTERVAL '24 hours'
AND metadata->>'source' = 'analytics_query'
GROUP BY DATE_TRUNC('hour', updated), table_name
ORDER BY hour_bucket DESC, avg_query_duration_ms DESC;
```

---

## 🚨 **Performance Alerting System**

### **Alert Configuration**
```sql
-- Performance Alert Configuration
CREATE TABLE performance_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_name VARCHAR(100) NOT NULL UNIQUE,
    tier VARCHAR(20) CHECK (tier IN ('oltp', 'content', 'queue', 'olap')),
    metric_name VARCHAR(100) NOT NULL,
    comparison_operator VARCHAR(10) CHECK (comparison_operator IN ('>', '<', '>=', '<=', '=')),
    threshold_value NUMERIC NOT NULL,
    evaluation_period INTERVAL DEFAULT '5 minutes',
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    is_active BOOLEAN DEFAULT TRUE,
    notification_channels TEXT[],
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Default Alert Thresholds
INSERT INTO performance_alerts (alert_name, tier, metric_name, comparison_operator, threshold_value, severity) VALUES
('oltp_slow_queries', 'oltp', 'avg_query_time_ms', '>', 5000, 'high'),
('oltp_pool_exhaustion', 'oltp', 'usage_rate_percent', '>', 90, 'critical'),
('content_slow_retrieval', 'content', 'avg_retrieval_time_ms', '>', 200, 'medium'),
('content_poor_compression', 'content', 'compression_ratio_percent', '<', 50, 'low'),
('queue_backlog', 'queue', 'queued_jobs', '>', 100, 'high'),
('queue_worker_utilization', 'queue', 'worker_utilization_percent', '<', 80, 'medium'),
('olap_slow_queries', 'olap', 'avg_query_duration_ms', '>', 30000, 'medium'),
('olap_materialized_views_stale', 'olap', 'view_refresh_age_hours', '>', 24, 'high');
```

### **Automated Performance Alert Function**
```sql
-- Performance Alert Monitoring Function
CREATE OR REPLACE FUNCTION monitor_performance_alerts()
RETURNS void AS $$
DECLARE
    alert_record RECORD;
    metric_value NUMERIC;
    alert_triggered BOOLEAN := FALSE;
BEGIN
    -- Check each active performance alert
    FOR alert_record IN
        SELECT * FROM performance_alerts 
        WHERE is_active = true
    LOOP
        -- Evaluate metric based on alert configuration
        CASE alert_record.tier
            WHEN 'oltp' THEN
                SELECT AVG(connection_usage_rate) INTO metric_value
                FROM connection_pool_metrics cpm
                JOIN connection_pool_config cpc ON cpm.pool_config_id = cpc.id
                WHERE cpc.tier = 'oltp'
                AND cpm.collected_at >= NOW() - alert_record.evaluation_period;
                
            WHEN 'content' THEN
                SELECT AVG(
                    CASE 
                        WHEN raw_size_bytes > 0 THEN 
                            ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                        ELSE 0 
                    END
                ) INTO metric_value
                FROM email_content
                WHERE created >= NOW() - alert_record.evaluation_period;
                
            WHEN 'queue' THEN
                SELECT COUNT(*) INTO metric_value
                FROM jobs
                WHERE status = 'queued'
                AND created >= NOW() - alert_record.evaluation_period;
                
            WHEN 'olap' THEN
                SELECT AVG(query_duration_ms) INTO metric_value
                FROM admin_audit_log
                WHERE performance_category IS NOT NULL
                AND updated >= NOW() - alert_record.evaluation_period;
        END CASE;
        
        -- Check if alert threshold is exceeded
        IF (alert_record.comparison_operator = '>' AND metric_value > alert_record.threshold_value) OR
           (alert_record.comparison_operator = '<' AND metric_value < alert_record.threshold_value) OR
           (alert_record.comparison_operator = '>=' AND metric_value >= alert_record.threshold_value) OR
           (alert_record.comparison_operator = '<=' AND metric_value <= alert_record.threshold_value) OR
           (alert_record.comparison_operator = '=' AND metric_value = alert_record.threshold_value) THEN
            
            -- Trigger alert
            INSERT INTO system_notifications (
                category, title, message, severity, metadata
            ) VALUES (
                'performance_alert',
                format('Performance Alert: %s', alert_record.alert_name),
                format('%s %s threshold exceeded. Current value: %s (threshold: %s)',
                       alert_record.tier, alert_record.metric_name, metric_value, alert_record.threshold_value),
                alert_record.severity,
                jsonb_build_object(
                    'alert_name', alert_record.alert_name,
                    'tier', alert_record.tier,
                    'metric_name', alert_record.metric_name,
                    'current_value', metric_value,
                    'threshold_value', alert_record.threshold_value,
                    'evaluation_period', alert_record.evaluation_period,
                    'alert_time', NOW()
                )
            );
            
            alert_triggered := TRUE;
        END IF;
    END LOOP;
    
    -- Log alert check completion
    IF alert_triggered THEN
        INSERT INTO system_notifications (
            category, title, message, severity
        ) VALUES (
            'performance_monitoring',
            'Performance Alerts Processed',
            'Performance alerts have been evaluated and notifications sent where thresholds were exceeded',
            'info'
        );
    END IF;
END;
$$ LANGUAGE plpgsql;
```

---

## 📈 **Performance Analysis and Optimization**

### **Weekly Performance Analysis Report**
```sql
-- Weekly Performance Analysis Function
CREATE OR REPLACE FUNCTION generate_weekly_performance_report()
RETURNS TABLE(
    tier_name TEXT,
    metric_category TEXT,
    metric_name TEXT,
    current_value NUMERIC,
    previous_value NUMERIC,
    percent_change NUMERIC,
    trend_direction TEXT,
    recommendations TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH performance_comparison AS (
        SELECT 
            'oltp' as tier_name,
            'connection_pool' as metric_category,
            'avg_usage_rate' as metric_name,
            AVG(connection_usage_rate) as current_value,
            LAG(AVG(connection_usage_rate)) OVER (ORDER BY date_trunc('week', collected_at)) as previous_value
        FROM connection_pool_metrics cpm
        JOIN connection_pool_config cpc ON cpm.pool_config_id = cpc.id
        WHERE cpc.tier = 'oltp'
        AND cpm.collected_at >= NOW() - INTERVAL '14 days'
        GROUP BY date_trunc('week', cpm.collected_at)
        
        UNION ALL
        
        SELECT 
            'content' as tier_name,
            'storage_efficiency' as metric_category,
            'avg_compression_ratio' as metric_name,
            AVG(
                CASE 
                    WHEN raw_size_bytes > 0 THEN 
                        ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                    ELSE 0 
                END
            ) as current_value,
            LAG(AVG(
                CASE 
                    WHEN raw_size_bytes > 0 THEN 
                        ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                    ELSE 0 
                END
            )) OVER (ORDER BY date_trunc('week', created)) as previous_value
        FROM email_content
        WHERE created >= NOW() - INTERVAL '14 days'
        GROUP BY date_trunc('week', created)
        
        UNION ALL
        
        SELECT 
            'queue' as tier_name,
            'processing_efficiency' as metric_category,
            'avg_processing_time' as metric_name,
            AVG(EXTRACT(EPOCH FROM (completed - started))) as current_value,
            LAG(AVG(EXTRACT(EPOCH FROM (completed - started)))) OVER (ORDER BY date_trunc('week', created)) as previous_value
        FROM jobs
        WHERE status = 'completed'
        AND completed >= NOW() - INTERVAL '14 days'
        GROUP BY date_trunc('week', created)
        
        UNION ALL
        
        SELECT 
            'olap' as tier_name,
            'query_performance' as metric_category,
            'avg_query_duration' as metric_name,
            AVG(query_duration_ms) as current_value,
            LAG(AVG(query_duration_ms)) OVER (ORDER BY date_trunc('week', updated)) as previous_value
        FROM admin_audit_log
        WHERE performance_category IS NOT NULL
        AND updated >= NOW() - INTERVAL '14 days'
        GROUP BY date_trunc('week', updated)
    )
    SELECT 
        pc.tier_name,
        pc.metric_category,
        pc.metric_name,
        pc.current_value,
        pc.previous_value,
        CASE 
            WHEN pc.previous_value IS NOT NULL AND pc.previous_value != 0 THEN
                ROUND(((pc.current_value - pc.previous_value) / pc.previous_value) * 100, 2)
            ELSE NULL 
        END as percent_change,
        CASE 
            WHEN pc.previous_value IS NULL THEN 'insufficient_data'
            WHEN pc.current_value > pc.previous_value THEN 'degrading'
            WHEN pc.current_value < pc.previous_value THEN 'improving'
            ELSE 'stable'
        END as trend_direction,
        CASE 
            WHEN pc.tier_name = 'oltp' AND pc.current_value > 80 THEN 'Consider increasing connection pool max_connections'
            WHEN pc.tier_name = 'content' AND pc.current_value < 60 THEN 'Optimize compression algorithms for better storage efficiency'
            WHEN pc.tier_name = 'queue' AND pc.current_value > 300 THEN 'Investigate slow job processing and optimize worker performance'
            WHEN pc.tier_name = 'olap' AND pc.current_value > 60000 THEN 'Review complex queries and consider additional indexing'
            ELSE 'Performance metrics within acceptable range'
        END as recommendations
    FROM performance_comparison pc
    ORDER BY pc.tier_name, pc.metric_category, pc.metric_name;
END;
$$ LANGUAGE plpgsql;
```

### **Performance Optimization Recommendations**
```sql
-- Performance Optimization Analysis
CREATE OR REPLACE FUNCTION analyze_performance_optimization_opportunities()
RETURNS TABLE(
    optimization_type TEXT,
    target_tier TEXT,
    current_metric_value NUMERIC,
    optimization_potential TEXT,
    implementation_effort TEXT,
    expected_improvement_percent NUMERIC,
    recommendation_details TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH performance_metrics AS (
        -- Connection Pool Analysis
        SELECT 
            'connection_pool_optimization' as optimization_type,
            'oltp' as target_tier,
            AVG(connection_usage_rate) as current_metric_value,
            CASE 
                WHEN AVG(connection_usage_rate) > 85 THEN 'high'
                WHEN AVG(connection_usage_rate) > 70 THEN 'medium'
                ELSE 'low'
            END as optimization_potential,
            CASE 
                WHEN AVG(connection_usage_rate) > 85 THEN 'medium'
                ELSE 'low'
            END as implementation_effort,
            CASE 
                WHEN AVG(connection_usage_rate) > 85 THEN 20.0
                WHEN AVG(connection_usage_rate) > 70 THEN 10.0
                ELSE 5.0
            END as expected_improvement_percent,
            'Optimize connection pool sizing and implement auto-scaling based on usage patterns' as recommendation_details
        FROM connection_pool_metrics cpm
        JOIN connection_pool_config cpc ON cpm.pool_config_id = cpc.id
        WHERE cpc.tier = 'oltp'
        AND cpm.collected_at >= NOW() - INTERVAL '7 days'
        
        UNION ALL
        
        -- Content Compression Analysis
        SELECT 
            'storage_optimization' as optimization_type,
            'content' as target_tier,
            AVG(
                CASE 
                    WHEN raw_size_bytes > 0 THEN 
                        ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                    ELSE 0 
                END
            ) as current_metric_value,
            CASE 
                WHEN AVG(
                    CASE 
                        WHEN raw_size_bytes > 0 THEN 
                            ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                        ELSE 0 
                    END
                ) < 50 THEN 'high'
                WHEN AVG(
                    CASE 
                        WHEN raw_size_bytes > 0 THEN 
                            ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                        ELSE 0 
                    END
                ) < 65 THEN 'medium'
                ELSE 'low'
            END as optimization_potential,
            'medium' as implementation_effort,
            CASE 
                WHEN AVG(
                    CASE 
                        WHEN raw_size_bytes > 0 THEN 
                            ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                        ELSE 0 
                    END
                ) < 50 THEN 40.0
                WHEN AVG(
                    CASE 
                        WHEN raw_size_bytes > 0 THEN 
                            ((raw_size_bytes - COALESCE(compressed_size_bytes, raw_size_bytes))::DECIMAL / raw_size_bytes) * 100
                        ELSE 0 
                    END
                ) < 65 THEN 20.0
                ELSE 10.0
            END as expected_improvement_percent,
            'Implement advanced compression algorithms and optimize content deduplication' as recommendation_details
        FROM email_content
        WHERE created >= NOW() - INTERVAL '7 days'
        
        UNION ALL
        
        -- Queue Processing Optimization
        SELECT 
            'queue_optimization' as optimization_type,
            'queue' as target_tier,
            AVG(EXTRACT(EPOCH FROM (completed - started))) as current_metric_value,
            CASE 
                WHEN AVG(EXTRACT(EPOCH FROM (completed - started))) > 300 THEN 'high'
                WHEN AVG(EXTRACT(EPOCH FROM (completed - started))) > 120 THEN 'medium'
                ELSE 'low'
            END as optimization_potential,
            'high' as implementation_effort,
            CASE 
                WHEN AVG(EXTRACT(EPOCH FROM (completed - started))) > 300 THEN 50.0
                WHEN AVG(EXTRACT(EPOCH FROM (completed - started))) > 120 THEN 25.0
                ELSE 10.0
            END as expected_improvement_percent,
            'Optimize job processing algorithms and implement worker auto-scaling' as recommendation_details
        FROM jobs
        WHERE status = 'completed'
        AND completed >= NOW() - INTERVAL '7 days'
        
        UNION ALL
        
        -- OLAP Query Optimization
        SELECT 
            'analytics_optimization' as optimization_type,
            'olap' as target_tier,
            AVG(query_duration_ms) as current_metric_value,
            CASE 
                WHEN AVG(query_duration_ms) > 60000 THEN 'high'
                WHEN AVG(query_duration_ms) > 30000 THEN 'medium'
                ELSE 'low'
            END as optimization_potential,
            'medium' as implementation_effort,
            CASE 
                WHEN AVG(query_duration_ms) > 60000 THEN 40.0
                WHEN AVG(query_duration_ms) > 30000 THEN 20.0
                ELSE 10.0
            END as expected_improvement_percent,
            'Optimize materialized view refresh strategies and implement query result caching' as recommendation_details
        FROM admin_audit_log
        WHERE performance_category IS NOT NULL
        AND updated >= NOW() - INTERVAL '7 days'
    )
    SELECT 
        pm.optimization_type,
        pm.target_tier,
        ROUND(pm.current_metric_value, 2),
        pm.optimization_potential,
        pm.implementation_effort,
        pm.expected_improvement_percent,
        pm.recommendation_details
    FROM performance_metrics pm
    ORDER BY 
        CASE pm.optimization_potential
            WHEN 'high' THEN 1
            WHEN 'medium' THEN 2
            ELSE 3
        END,
        pm.target_tier;
END;
$$ LANGUAGE plpgsql;
```

---

## 🔧 **Monitoring Automation Setup**

### **Automated Performance Monitoring Schedule**
```sql
-- Schedule performance monitoring tasks
SELECT cron.schedule(
    'oltp-performance-monitoring',
    '*/1 * * * *',  -- Every minute
    $$SELECT monitor_performance_alerts();$$
);

SELECT cron.schedule(
    'content-performance-analysis',
    '*/5 * * * *',  -- Every 5 minutes
    $$SELECT analyze_performance_optimization_opportunities();$$
);

SELECT cron.schedule(
    'weekly-performance-report',
    '0 9 * * 1',  -- Every Monday at 9 AM
    $$SELECT generate_weekly_performance_report();$$
);
```

---

## 📋 **Related Documentation**

### **Operational References**
- **[Database Operations Guide](database_operations_guide.md)** - Central operational hub
- **[Connection Pooling Strategy](connection_pooling_strategy.md)** - Pool configuration and optimization
- **[Backup & Recovery Procedures](backup_recovery_procedures.md)** - Data protection during incidents

### **Technical References**
- **[OLTP Schema Guide](../oltp_schema_guide.md)** - OLTP performance monitoring integration
- **[Content Database Schema Guide](../content_database_schema_guide.md)** - Content performance optimization
- **[Queue System Schema Guide](../queue_system_schema_guide.md)** - Queue performance monitoring
- **[OLAP Analytics Schema Guide](../olap_analytics_schema_guide.md)** - Analytics performance tracking

---

## 🔄 **Update History**

| Date | Change | Author |
|------|--------|--------|
| 2025-11-01 | Initial version - Comprehensive performance monitoring guide | Database Ops Team |
| [Next Review] | [Monthly performance review and optimization] | Database Ops Team |

**Document Classification**: Critical Operations  
**Review Cycle**: Monthly for performance trends, quarterly for methodology updates  
**Integration Required**: PostHog for dashboard visualization  
**Team Training**: All database operations and performance engineering teams  

This performance monitoring guide provides comprehensive visibility into database performance across all tiers, enabling proactive optimization and maintaining optimal system performance.