# Content Database Schema Guide - Heavy Content Storage

## Overview

The **Content Database** is PenguinMails' dedicated content storage system designed for heavy content, large objects, email bodies, attachments, and full message archives. This tier is optimized for efficient content storage, retrieval, and retention policies.

### 🎯 **Purpose & Characteristics**

- **Primary Focus**: Heavy content storage, large binary objects, full email archives
- **Performance**: Optimized for storage efficiency, content retrieval, retention management
- **Architecture**: Content-focused design with efficient binary storage
- **Retention**: Built-in expiration policies and content lifecycle management

### ⚡ **Performance Strategy**

- **Content Separation**: Heavy content separated from operational metadata
- **Efficient Storage**: Binary storage for attachments, compressed text storage
- **Retention Policies**: Automated cleanup based on business requirements
- **Content Deduplication**: Optional hashing for duplicate content detection

---

## 📧 **Email Content Storage**

### **content_objects** - Full Email Content Storage

```sql
CREATE TABLE content_objects (
    storage_key VARCHAR(500) PRIMARY KEY,
    tenant_id UUID NOT NULL,
    content_text TEXT,
    content_html TEXT,
    headers JSONB,
    raw_size_bytes INTEGER,
    compressed_size_bytes INTEGER,
    content_hash VARCHAR(64),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires TIMESTAMP WITH TIME ZONE,
    archived TIMESTAMP WITH TIME ZONE,
    retention_days INTEGER DEFAULT 2555, -- 7 years default
    is_archived BOOLEAN DEFAULT FALSE,
    compression_algorithm VARCHAR(20),
    last_accessed TIMESTAMP WITH TIME ZONE
);
```

**Key Features:**
- **Storage Key**: Matches `inbox_message_refs.content_storage_key` for cross-tier linking
- **Dual Content**: Both plain text and HTML versions stored
- **Headers Storage**: Complete email headers for compliance and debugging
- **Size Tracking**: Both raw and compressed sizes for storage analysis
- **Content Hash**: Optional deduplication support
- **Retention Management**: Built-in expiration and archiving
- **Compression**: Efficient storage with algorithm tracking

### **attachments** - Binary File Storage

```sql
CREATE TABLE attachments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    parent_storage_key VARCHAR(500) REFERENCES content_objects(storage_key) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    original_filename VARCHAR(255),
    mime_type VARCHAR(100) NOT NULL,
    size_bytes INTEGER NOT NULL,
    compressed_size_bytes INTEGER,
    content BYTEA NOT NULL,
    storage_disposition VARCHAR(50) CHECK (storage_disposition IN ('inline', 'attachment')),
    content_hash VARCHAR(64),
    compression_algorithm VARCHAR(20),
    is_scanned BOOLEAN DEFAULT FALSE,
    virus_scan_result VARCHAR(50),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    archived TIMESTAMP WITH TIME ZONE,
    expires TIMESTAMP WITH TIME ZONE
);
```

**Key Features:**
- **Binary Storage**: Direct BYTEA storage for file content
- **Metadata**: Filename, mime type, size for proper rendering
- **Security**: Virus scanning and content disposition tracking
- **Compression**: Efficient storage with size tracking
- **Archival**: Support for content lifecycle management

---

## 💌 **System Communication**

### **transactional_emails** - System-Generated Emails

```sql
CREATE TABLE transactional_emails (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    tenant_id UUID NOT NULL,
    type VARCHAR(100) NOT NULL,
    payload JSONB,
    template_variables JSONB,
    recipient_email VARCHAR(254),
    subject VARCHAR(500),
    content_storage_key VARCHAR(500),
    status VARCHAR(50) CHECK (status IN ('queued', 'sent', 'failed', 'delivered', 'bounced')),
    queued TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    sent TIMESTAMP WITH TIME ZONE,
    failed TIMESTAMP WITH TIME ZONE,
    delivered TIMESTAMP WITH TIME ZONE,
    bounced TIMESTAMP WITH TIME ZONE,
    last_error_message TEXT,
    retry_count INTEGER DEFAULT 0,
    job_id UUID,
    tracking_id VARCHAR(100),
    open_tracking_enabled BOOLEAN DEFAULT TRUE,
    click_tracking_enabled BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Email Types:**
- **WELCOME_EMAIL**: New user welcome messages
- **PASSWORD_RESET**: Password reset confirmations
- **INVOICE_READY**: Billing notifications
- **SECURITY_ALERT**: Security-related notifications
- **SYSTEM_MAINTENANCE**: System status updates
- **QUOTA_WARNING**: Usage limit notifications

### **notifications** - User Notifications

```sql
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID,
    tenant_id UUID NOT NULL,
    type VARCHAR(100) NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    channel VARCHAR(20) CHECK (channel IN ('in_app', 'email', 'push')),
    priority VARCHAR(20) DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
    is_read BOOLEAN DEFAULT FALSE,
    read TIMESTAMP WITH TIME ZONE,
    expires TIMESTAMP WITH TIME ZONE,
    action_url TEXT,
    action_text VARCHAR(100),
    metadata JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Notification Types:**
- **SUBSCRIPTION_EXPIRED**: Billing subscription expiry
- **NEW_MESSAGE**: New email received
- **CAMPAIGN_COMPLETED**: Campaign execution finished
- **DOMAIN_VERIFIED**: Domain verification success
- **SECURITY_LOGIN**: New login detected
- **QUOTA_NEARING**: Usage approaching limits

### **system_notifications** - System Alerts & Monitoring

```sql
CREATE TABLE system_notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category VARCHAR(100) NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    severity VARCHAR(20) CHECK (severity IN ('info', 'warning', 'error', 'critical')),
    source_type VARCHAR(50),
    source_id VARCHAR(255),
    tenant_id UUID,
    user_id UUID,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved TIMESTAMP WITH TIME ZONE,
    resolved_by UUID,
    resolution_notes TEXT,
    auto_resolve_after INTERVAL,
    alert_count INTEGER DEFAULT 1,
    first_occurrence TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_occurrence TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    metadata JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Alert Categories:**
- **infra_alert**: Infrastructure monitoring alerts
- **job_failure**: Background job failures
- **api_error**: API error rate alerts
- **quota_reached**: Resource quota violations
- **security_incident**: Security-related alerts
- **performance_degradation**: Performance monitoring alerts
- **billing_anomaly**: Billing system anomalies

---

## 📊 **Content Analytics & Tracking**

### **content_access_log** - Content Access Tracking

```sql
CREATE TABLE content_access_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_key VARCHAR(500) NOT NULL,
    user_id UUID,
    tenant_id UUID NOT NULL,
    access_type VARCHAR(50) CHECK (access_type IN ('read', 'download', 'preview', 'search')),
    ip_address INET,
    user_agent TEXT,
    referrer TEXT,
    access_duration_ms INTEGER,
    bytes_transferred INTEGER,
    success BOOLEAN DEFAULT TRUE,
    error_message TEXT,
    session_id VARCHAR(255),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **content_retention_stats** - Storage Usage Analytics

```sql
CREATE TABLE content_retention_stats (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    tenant_id UUID NOT NULL,
    date DATE NOT NULL,
    total_content_objects INTEGER DEFAULT 0,
    total_attachments INTEGER DEFAULT 0,
    total_size_bytes BIGINT DEFAULT 0,
    compressed_size_bytes BIGINT DEFAULT 0,
    archived_objects INTEGER DEFAULT 0,
    expired_objects INTEGER DEFAULT 0,
    unique_content_hash_count INTEGER DEFAULT 0,
    deduplication_savings_bytes BIGINT DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(tenant_id, date)
);
```

---

## 🔍 **Search & Indexing**

### **content_search_index** - Full-Text Search Support

```sql
CREATE TABLE content_search_index (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_key VARCHAR(500) NOT NULL,
    tenant_id UUID NOT NULL,
    content_type VARCHAR(50) CHECK (content_type IN ('email', 'attachment', 'notification')),
    searchable_text TEXT,
    keywords TEXT[],
    subject_line TEXT,
    sender_name TEXT,
    sender_email VARCHAR(254),
    recipient_name TEXT,
    recipient_email VARCHAR(254),
    date_range_start TIMESTAMP WITH TIME ZONE,
    date_range_end TIMESTAMP WITH TIME ZONE,
    attachment_count INTEGER DEFAULT 0,
    file_types TEXT[],
    size_category VARCHAR(20) CHECK (size_category IN ('small', 'medium', 'large', 'very_large')),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(storage_key)
);
```

---

## 📈 **Performance Indexes**

### **Content Retrieval Indexes**
```sql
-- Content object access
CREATE INDEX idx_content_objects_tenant ON content_objects(tenant_id);
CREATE INDEX idx_content_objects_expires ON content_objects(expires_at) WHERE expires IS NOT NULL;
CREATE INDEX idx_content_objects_archived ON content_objects(is_archived, archived_at);
CREATE INDEX idx_content_objects_hash ON content_objects(content_hash) WHERE content_hash IS NOT NULL;
CREATE INDEX idx_content_objects_created ON content_objects(created_at);

-- Attachment storage
CREATE INDEX idx_attachments_parent ON attachments(parent_storage_key);
CREATE INDEX idx_attachments_tenant ON attachments(parent_storage_key, created_at);
CREATE INDEX idx_attachments_mime ON attachments(mime_type);
CREATE INDEX idx_attachments_size ON attachments(size_bytes);
CREATE INDEX idx_attachments_expires ON attachments(expires_at) WHERE expires IS NOT NULL;

-- Transactional emails
CREATE INDEX idx_transactional_emails_user_tenant ON transactional_emails(user_id, tenant_id);
CREATE INDEX idx_transactional_emails_type ON transactional_emails(type);
CREATE INDEX idx_transactional_emails_status ON transactional_emails(status);
CREATE INDEX idx_transactional_emails_queued ON transactional_emails(queued_at);
CREATE INDEX idx_transactional_emails_tracking ON transactional_emails(tracking_id) WHERE tracking_id IS NOT NULL;

-- User notifications
CREATE INDEX idx_notifications_user_tenant ON notifications(user_id, tenant_id);
CREATE INDEX idx_notifications_unread ON notifications(user_id, is_read, created DESC) WHERE is_read = false;
CREATE INDEX idx_notifications_expires ON notifications(expires_at) WHERE expires IS NOT NULL;

-- System notifications
CREATE INDEX idx_system_notifications_category ON system_notifications(category, created DESC);
CREATE INDEX idx_system_notifications_unresolved ON system_notifications(is_resolved, created DESC) WHERE is_resolved = false;
CREATE INDEX idx_system_notifications_tenant ON system_notifications(tenant_id, created DESC) WHERE tenant_id IS NOT NULL;
CREATE INDEX idx_system_notifications_severity ON system_notifications(severity, created DESC);

-- Content access tracking
CREATE INDEX idx_content_access_tenant ON content_access_log(tenant_id, created DESC);
CREATE INDEX idx_content_access_storage ON content_access_log(storage_key, created DESC);
CREATE INDEX idx_content_access_user ON content_access_log(user_id, created DESC);

-- Search indexing
CREATE INDEX idx_content_search_tenant ON content_search_index(tenant_id);
CREATE INDEX idx_content_search_text ON content_search_index USING gin(to_tsvector('english', searchable_text));
CREATE INDEX idx_content_search_keywords ON content_search_index USING gin(keywords);
CREATE INDEX idx_content_search_sender ON content_search_index(sender_email);
CREATE INDEX idx_content_search_recipient ON content_search_index(recipient_email);
```

---

## 🛡️ **Security & Data Protection**

### **Content Security Policies**
```sql
-- Content access logging for audit trails
CREATE TABLE content_access_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_key VARCHAR(500) NOT NULL,
    user_id UUID,
    tenant_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL,
    permission_granted BOOLEAN NOT NULL,
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),
    reason TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Data retention enforcement
CREATE TABLE retention_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID,
    content_type VARCHAR(50),
    retention_days INTEGER NOT NULL,
    auto_archive BOOLEAN DEFAULT FALSE,
    auto_delete BOOLEAN DEFAULT FALSE,
    priority INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(tenant_id, content_type)
);
```

### **GDPR Compliance & Data Anonymization**
```sql
-- Content anonymization for GDPR compliance
CREATE OR REPLACE FUNCTION anonymize_content_data(tenant_id_param UUID)
RETURNS VOID AS $$
BEGIN
    -- Anonymize content objects while preserving structure
    UPDATE content_objects 
    SET 
        content_text = 'ANONYMIZED_CONTENT',
        content_html = 'ANONYMIZED_CONTENT',
        headers = headers - 'from' - 'to' - 'subject',
        expires = NOW() - INTERVAL '1 day'  -- Force immediate cleanup
    WHERE tenant_id = tenant_id_param;
    
    -- Log anonymization for audit
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        tenant_id,
        metadata
    ) VALUES (
        'compliance_action',
        'Content Data Anonymized',
        'Content data anonymized for GDPR compliance',
        'info',
        tenant_id_param,
        jsonb_build_object('action', 'anonymize_content', 'timestamp', NOW())
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
```

---

## 🔄 **Content Lifecycle Management**

### **Automated Retention Policies**
```sql
-- Content cleanup job
CREATE OR REPLACE FUNCTION cleanup_expired_content()
RETURNS void AS $$
DECLARE
    expired_content RECORD;
BEGIN
    -- Find expired content objects
    FOR expired_content IN 
        SELECT storage_key FROM content_objects 
        WHERE expires <= NOW() 
        AND is_archived = false
    LOOP
        -- Archive or delete based on retention policy
        UPDATE content_objects 
        SET is_archived = true, 
            archived = NOW()
        WHERE storage_key = expired_content.storage_key;
        
        -- Log cleanup action
        INSERT INTO system_notifications (
            category,
            title,
            message,
            severity,
            metadata
        ) VALUES (
            'content_maintenance',
            'Content Archived',
            format('Content %s archived due to expiration', expired_content.storage_key),
            'info',
            jsonb_build_object('storage_key', expired_content.storage_key, 'action', 'archive')
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

### **Storage Optimization**
```sql
-- Content deduplication
CREATE OR REPLACE FUNCTION deduplicate_content()
RETURNS void AS $$
DECLARE
    duplicate_content RECORD;
    master_content VARCHAR(500);
BEGIN
    -- Find duplicate content based on hash
    FOR duplicate_content IN 
        SELECT storage_key, content_hash
        FROM content_objects 
        WHERE content_hash IS NOT NULL
        GROUP BY storage_key, content_hash
        HAVING COUNT(*) > 1
    LOOP
        -- Keep the first occurrence as master
        SELECT storage_key INTO master_content
        FROM content_objects 
        WHERE content_hash = duplicate_content.content_hash
        ORDER BY created ASC
        LIMIT 1;
        
        -- Update duplicates to reference master content
        UPDATE content_objects 
        SET content_text = NULL,
            content_html = NULL,
            headers = headers - 'content'  -- Keep headers but remove content
        WHERE content_hash = duplicate_content.content_hash
        AND storage_key != master_content;
        
        -- Log deduplication
        INSERT INTO system_notifications (
            category,
            title,
            message,
            severity,
            metadata
        ) VALUES (
            'content_maintenance',
            'Content Deduplicated',
            format('Content deduplicated for hash %s', duplicate_content.content_hash),
            'info',
            jsonb_build_object('content_hash', duplicate_content.content_hash, 'action', 'deduplicate')
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **Monitoring & Analytics**

### **Content Metrics Dashboard**
```sql
-- Real-time content metrics
CREATE MATERIALIZED VIEW content_metrics_summary AS
SELECT 
    tenant_id,
    date_trunc('day', created_at) as day,
    COUNT(*) as total_objects,
    COUNT(DISTINCT content_hash) as unique_content,
    SUM(raw_size_bytes) as total_raw_size,
    SUM(compressed_size_bytes) as total_compressed_size,
    ROUND(
        (SUM(raw_size_bytes) - SUM(compressed_size_bytes))::DECIMAL / 
        NULLIF(SUM(raw_size_bytes), 0) * 100, 
        2
    ) as compression_ratio_percent,
    COUNT(*) FILTER (WHERE expires <= NOW()) as expired_objects,
    COUNT(*) FILTER (WHERE is_archived = true) as archived_objects
FROM content_objects
GROUP BY tenant_id, date_trunc('day', created_at);

-- Refresh strategy
CREATE INDEX idx_content_metrics_tenant_day ON content_metrics_summary(tenant_id, day);
```

---

## 📚 **Related Documentation**

- **[Database Schema Guide](database_schema_guide.md)** - 4-tier architecture overview
- **[OLTP Schema Guide](oltp_schema_guide.md)** - Operational database
- **[OLAP Analytics Schema Guide](olap_analytics_schema_guide.md)** - Business intelligence
- **[Queue System Schema Guide](queue_system_schema_guide.md)** - Job processing
- **[Analytics Architecture](analytics_architecture.md)** - Content analytics strategy
- **[Performance Dashboard](performance_dashboard.md)** - Content storage metrics

**Keywords**: content database, email storage, attachment storage, content retention, binary storage, message archives, content deduplication, GDPR compliance, content lifecycle management