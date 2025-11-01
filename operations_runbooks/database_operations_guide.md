# Database Operations Guide - Central Hub

## Overview

**Last Updated**: November 1, 2025  
**Owner**: Database Operations Team  
**Criticality**: Critical  
**Next Review**: December 1, 2025

This guide serves as the central operational hub for all PenguinMails database operations. It provides quick access to critical procedures, emergency response protocols, and cross-tier operational knowledge.

### 🎯 **Purpose**
- **Emergency Response**: Step-by-step procedures for database incidents
- **Daily Operations**: Routine maintenance and monitoring procedures  
- **Cross-Tier Coordination**: Unified procedures across OLTP, Content, Queue, and OLAP tiers
- **Knowledge Base**: Quick reference for database operations team

---

## 🚨 **Emergency Response Quick Reference**

### **Critical Incident Types & Immediate Actions**

| Incident Type | Response Time | Immediate Actions | Escalation |
|---------------|---------------|------------------|------------|
| **Database Outage** | < 5 minutes | Check PostHog alerts → Verify service status → Execute failover | Database Lead → CTO |
| **Connection Pool Exhaustion** | < 10 minutes | Monitor pools → Adjust configurations → Restart services if needed | Database Lead |
| **Data Integrity Issues** | < 15 minutes | Identify scope → Quarantine affected data → Begin recovery procedures | Database Lead → Product Owner |
| **Performance Degradation** | < 30 minutes | Check queries → Optimize indexes → Scale resources | Database Lead |
| **Security Breach** | < 5 minutes | Contain → Investigate → Document → Notify stakeholders | Security Team → Legal |

### **Emergency Contact Information**
```yaml
Database Operations Team:
- Lead: Database Operations Manager - +1-555-DB-LEAD - dbops@penguinmails.com
- On-Call Engineer: +1-555-DB-ONCALL - oncall@penguinmails.com (24/7)
- Backup Engineer: +1-555-DB-BACKUP - backup@penguinmails.com

Escalation Path:
- Database Lead → Engineering Manager → CTO → CEO
- Response Time SLA: <15 minutes for critical issues

External Support:
- Database Vendor: https://support.postgresql.org (PostgreSQL Community)
- Cloud Provider: https://console.aws.amazon.com/support
- Security Incident: security@penguinmails.com +1-555-SEC-HELP
```

### **🔧 **First Response Procedures**

#### 1. Database Service Outage
```bash
# 1. Check service status
curl -f http://admin-panel/status || echo "Admin panel down"

# 2. Check PostHog for alerts
# Login: https://app.posthog.com/[YOUR_PROJECT_ID]
# Navigate: Dashboard → Database Performance
# Configure alerts for: query_time > 5s, connection_pool > 90%

# 3. Check database connectivity
psql -h db-host -U app_user -d penguinmails_oltp -c "SELECT 1;"

# 4. Check connection pools
# OLTP: Primary (5-50 connections)
# Content: Content (3-25 connections)  
# Queue: Queue (5-40 connections)
# OLAP: Analytics (3-15 connections)

# 5. Execute failover if needed
# See: backup_recovery_procedures.md
```

#### 2. Performance Degradation
```sql
-- Check active queries
SELECT pid, usename, client_addr, state, query_start, 
       EXTRACT(EPOCH FROM (now() - query_start)) as duration_seconds,
       left(query, 100) as query_preview
FROM pg_stat_activity 
WHERE state = 'active' 
ORDER BY query_start;

-- Check connection pool metrics
SELECT tier, pool_name, active_connections, idle_connections, 
       connection_usage_rate, pending_acquires
FROM connection_pool_metrics cpm
JOIN connection_pool_config cpc ON cpm.pool_config_id = cpc.id
WHERE cpm.collected_at >= NOW() - INTERVAL '5 minutes'
ORDER BY cpm.collected_at DESC;
```

---

## 📊 **Daily Operations Checklist**

### **Morning Health Check (9:00 AM)**
- [ ] **PostHog Dashboard Review** - Check database performance metrics
- [ ] **Connection Pool Status** - Verify pool health across all tiers
- [ ] **Backup Verification** - Confirm last successful backups for all databases
- [ ] **Error Log Review** - Check for new errors or warnings
- [ ] **Queue Health** - Verify queue processing rates and backlog
- [ ] **Storage Usage** - Check storage consumption and growth trends

### **Midday Performance Review (1:00 PM)**
- [ ] **Query Performance** - Review slow queries and optimization opportunities
- [ ] **Index Usage** - Check index effectiveness and maintenance needs
- [ ] **Resource Utilization** - Monitor CPU, memory, and disk usage
- [ ] **Security Events** - Review security alerts and access patterns

### **End-of-Day Review (5:00 PM)**
- [ ] **Daily Reports** - Generate and review performance reports
- [ ] **Maintenance Tasks** - Complete scheduled maintenance activities
- [ ] **Alert Review** - Address any outstanding alerts or warnings
- [ ] **Tomorrow's Preparation** - Prepare for scheduled maintenance or deployments

---

## 🔧 **Database Tier Operations**

### **OLTP Database (Primary Operations)**

#### **Connection Pool Management**
```sql
-- Check OLTP pool status
SELECT 
    pool_name,
    min_connections,
    max_connections,
    active_connections,
    idle_connections,
    connection_usage_rate,
    pending_acquires
FROM connection_pool_config cpc
JOIN connection_pool_metrics cpm ON cpc.id = cpm.pool_config_id
WHERE cpc.tier = 'oltp' 
AND cpm.collected_at >= NOW() - INTERVAL '5 minutes';
```

### **Content Database (Email Management)**

#### **Content Lifecycle Operations**
```sql
-- Check content retention status
SELECT 
    DATE(created) as content_date,
    COUNT(*) as total_messages,
    AVG(LENGTH(content)) as avg_content_size,
    MIN(created) as earliest,
    MAX(created) as latest
FROM email_messages 
WHERE created >= NOW() - INTERVAL '30 days'
GROUP BY DATE(created)
ORDER BY content_date DESC;
```

### **Queue System (Background Processing)**

#### **Queue Health Monitoring**
```sql
-- Check queue performance by priority
SELECT 
    priority,
    COUNT(*) as job_count,
    AVG(EXTRACT(EPOCH FROM (completed - created))) as avg_processing_time_seconds,
    MIN(created) as oldest_job
FROM jobs 
WHERE status = 'completed'
AND created >= NOW() - INTERVAL '1 hour'
GROUP BY priority
ORDER BY 
    CASE priority 
        WHEN 'critical' THEN 1 
        WHEN 'high' THEN 2 
        WHEN 'normal' THEN 3 
        WHEN 'low' THEN 4 
        ELSE 5 
    END;
```

---

## 📈 **Performance Monitoring Integration**

### **PostHog Dashboard Access**
```yaml
Dashboard URL: https://app.posthog.com/[PROJECT_ID]
Key Metrics:
  - Database Query Performance
  - Connection Pool Utilization
  - Queue Processing Rates
  - Content Storage Efficiency
  - Analytics Data Freshness

Alert Setup:
  - Query response time > 5 seconds
  - Connection pool usage > 90%
  - Queue backlog > 100 jobs
  - Storage growth > 10% daily

Configuration Notes:
  - Replace [PROJECT_ID] with actual PostHog project ID
  - Configure custom events for database performance tracking
  - Set up alerting rules for critical performance thresholds
```

---

## 📞 **Escalation Procedures**

### **Severity Levels & Response Times**

| Severity | Description | Response Time | Escalation |
|----------|-------------|---------------|------------|
| **Critical** | Complete service outage | < 5 minutes | Immediate |
| **High** | Major functionality impaired | < 15 minutes | Within 30 minutes |
| **Medium** | Minor functionality issues | < 1 hour | Within 4 hours |
| **Low** | Performance degradation | < 4 hours | Next business day |

### **Escalation Contacts**
```yaml
Level 1 - Database Operations Team:
  - Primary: Database Operations Lead
  - Secondary: On-Call Engineer
  - Response: Immediate

Level 2 - Engineering Management:
  - Primary: Engineering Manager  
  - Secondary: Senior Engineer
  - Response: Within 30 minutes

Level 3 - Executive Leadership:
  - Primary: CTO
  - Secondary: CEO
  - Response: Within 1 hour

External Support:
  - Database Vendor Support: [portal-url]
  - Cloud Provider Support: [portal-url]
  - Security Team: [contact-info]
```

---

## 📋 **Related Documentation**

### **Operational Runbooks**
- **[Connection Pooling Strategy](connection_pooling_strategy.md)** - Pool configuration and optimization
- **[Backup & Recovery Procedures](backup_recovery_procedures.md)** - Data protection and restoration
- **[Migration & Deployment Guide](migration_deployment_guide.md)** - Schema changes and deployments

### **Technical References**
- **[OLTP Schema Guide](oltp_schema_guide.md)** - Operational database structure
- **[Content Database Schema Guide](content_database_schema_guide.md)** - Email content management
- **[Queue System Schema Guide](queue_system_schema_guide.md)** - Background processing
- **[OLAP Analytics Schema Guide](olap_analytics_schema_guide.md)** - Business intelligence

---

## 🔄 **Update History**

| Date | Change | Author |
|------|--------|--------|
| 2025-11-01 | Initial version - Central hub creation | Database Ops Team |
| [Next Review] | [Scheduled monthly review] | Database Ops Team |

**Document Classification**: Operational Runbook  
**Review Cycle**: Monthly  
**Last Tested**: [To be scheduled]  
**Training Required**: All database operations team members

This guide provides immediate operational value while serving as the central hub for all database operations procedures. Regular updates ensure accuracy and relevance for production database management.