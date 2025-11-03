# Content Database Schema Guide - Heavy Content Storage

## Table Naming Standards

**Content Database Tier Naming Conventions:**
- **Core Content**: `content_` prefix for all content-related tables
- **Email Storage**: `email_` prefix for email-specific content (`email_messages`, `email_content`)
- **System Communication**: No prefix or `system_` prefix (`notifications`, `system_notifications`)
- **Attachments**: Singular for binary storage (`attachments`)
- **Analytics**: `content_` prefix for access tracking (`content_access_log`, `content_retention_stats`)
- **Search**: `content_` prefix for indexing (`content_search_index`, `content_access_audit`)
- **Lifecycle**: `retention_` prefix for policy tables (`retention_policies`)

**Table Name Examples:**
- `email_messages` - Email message analytics and traces
- `email_content` - Email body content storage
- `content_objects` - Full email content storage (enhanced from legacy)
- `attachments` - Binary file storage
- `notifications` - User notifications
- `system_notifications` - System alerts and monitoring
- `content_access_log` - Content access tracking
- `content_retention_stats` - Storage usage analytics
- `content_search_index` - Full-text search support
- `content_access_audit` - Content access logging for audit trails
- `retention_policies` - Data retention enforcement

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

### 💾 **Storage Optimization Strategy**

**COMPRESSION ANALYSIS NEEDED:**
- Evaluate LZ4 vs Zstandard vs Gzip for email content compression
- SPIKE: Test compression ratios vs decompression speed trade-offs
- Target: 50-70% storage reduction while maintaining <100ms decompression
- Consider algorithm per content type (HTML vs plain text vs JSON)

**DEDUPLICATION OPTIMIZATION:**
- Implement SHA-256 content hashing for exact duplicate detection
- Evaluate similarity hashing (SSDeep) for near-duplicate detection
- SPIKE: Balance storage savings vs computational overhead
- Target: 20-40% deduplication savings for repetitive content

**HYBRID STORAGE APPROACH:**
- **Hot Data**: Uncompressed for fast access (< 30 days)
- **Warm Data**: LZ4 compressed (30 days - 1 year)
- **Cold Data**: Zstandard compressed with deduplication (> 1 year)
- **Archive**: Lossless compression with maximum deduplication (> 7 years)

**PERFORMANCE TARGETS:**
- Read latency: < 50ms for hot data, < 200ms for warm/cold
- Write throughput: > 1000 content objects/second
- Storage efficiency: > 60% compression ratio
- Deduplication savings: > 30% for similar content types

---

## 📧 **Email Content Storage**
## 📊 Message Analytics & Tracking
### **email_messages** - Email Message Analytics & Traces
```sql
CREATE TABLE email_messages (
    storage_key VARCHAR(500) PRIMARY KEY REFERENCES email_content(storage_key),
    tenant_id UUID NOT NULL,
    email_account_id UUID,  -- Manual validation required: verify against OLTP.email_accounts
    campaign_id UUID,       -- Manual validation required: verify against OLTP.campaigns
    lead_id UUID,           -- Manual validation required: verify against OLTP.leads
    parent_message_id VARCHAR(500) REFERENCES email_messages(storage_key),
    direction VARCHAR(20) CHECK (direction IN ('inbound', 'outbound')),
    message_type VARCHAR(20) CHECK (message_type IN ('email', 'bounce', 'auto_reply')),
    from_email VARCHAR(254),
    to_email VARCHAR(254),
    subject VARCHAR(500),
    status VARCHAR(50) CHECK (status IN ('queued', 'sent', 'delivered', 'bounced', 'failed', 'opened', 'replied')),
    processed TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Key Features:**
- **Storage Key**: Primary key that references email_content table
- **Cross-Database References**: References to OLTP tables (campaigns, leads, email_accounts)
- **Analytics Focus**: Message traces for campaign performance tracking
- **Threading Support**: Self-reference for email conversation threads
- **Message Classification**: Different types (email, bounce, auto_reply)
- **Status Tracking**: Complete email lifecycle (queued → delivered → opened/replied)

### **email_content** - Email Body Content (Enhanced from content_objects)

```sql
-- Enhanced email_content table with clearer structure
CREATE TABLE email_content (
    storage_key VARCHAR(500) PRIMARY KEY,
    tenant_id UUID NOT NULL,
    content_text TEXT,
    content_html TEXT,
    headers JSONB,
    raw_size_bytes INTEGER,
    compressed_size_bytes INTEGER,
    content_hash VARCHAR(64),
    compression_algorithm VARCHAR(20),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires TIMESTAMP WITH TIME ZONE,
    archived TIMESTAMP WITH TIME ZONE,
    retention_days INTEGER DEFAULT 2555, -- 7 years default
    is_archived BOOLEAN DEFAULT FALSE,
    last_accessed TIMESTAMP WITH TIME ZONE
);
```


**Email Relationship Architecture:**
```
email_messages (metadata/analytics)
    ↓ storage_key (FK)
email_content (email body: text, html, headers) 
    ↓ parent_storage_key (FK)
attachments (binary files)
```

This creates a natural email hierarchy: message metadata → email content → attachments

**Key Features:**
- **Storage Key**: Matches `email_messages.storage_key` for cross-tier linking
- **Dual Content**: Both plain text and HTML versions stored
- **Headers Storage**: Complete email headers for compliance and debugging
- **Size Tracking**: Both raw and compressed sizes for storage analysis
- **Content Hash**: Optional deduplication support
- **Retention Management**: Built-in expiration and archiving
- **Compression**: Efficient storage with algorithm tracking

**Key Features:**
- **Storage Key**: Primary key for content database reference
- **Cross-Database References**: References to OLTP tables (campaigns, leads, email_accounts)
- **Analytics Focus**: Message traces for campaign performance tracking
- **Threading Support**: Self-reference for email conversation threads
- **Message Classification**: Different types (email, bounce, auto_reply)
- **Status Tracking**: Complete email lifecycle (queued → delivered → opened/replied)

### **content_objects** - Full Email Content Storage

```sql
CREATE TABLE content_objects (
    storage_key VARCHAR(500) PRIMARY KEY,
**Email Relationship Architecture:**
```
content_inbox_message_refs (metadata/analytics)
    ↓ storage_key (FK)
content_objects (email body: text, html, headers) 
    ↓ parent_storage_key (FK)
attachments (binary files)
```

This creates a natural email hierarchy: message metadata → email content → attachments
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
-- Message analytics indexes
CREATE INDEX idx_email_messages_tenant ON email_messages(tenant_id);
CREATE INDEX idx_email_messages_campaign ON email_messages(campaign_id);
CREATE INDEX idx_email_messages_status ON email_messages(status);
CREATE INDEX idx_email_messages_created ON email_messages(created_at);
CREATE INDEX idx_email_messages_email_account ON email_messages(email_account_id);
CREATE INDEX idx_email_messages_parent ON email_messages(parent_message_id);

-- Email content indexes
CREATE INDEX idx_email_content_tenant ON email_content(tenant_id);
CREATE INDEX idx_email_content_expires ON email_content(expires_at) WHERE expires IS NOT NULL;
CREATE INDEX idx_email_content_archived ON email_content(is_archived, archived_at);
CREATE INDEX idx_email_content_hash ON email_content(content_hash) WHERE content_hash IS NOT NULL;
CREATE INDEX idx_email_content_created ON email_content(created_at);
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

### **Content Lifecycle Indexes**
```sql
-- Lifecycle management indexes
CREATE INDEX idx_content_objects_lifecycle ON content_objects(tenant_id, is_archived, expires, created_at);
CREATE INDEX idx_content_objects_compression ON content_objects(compression_algorithm, created_at) WHERE compression_algorithm IS NOT NULL;
CREATE INDEX idx_content_objects_deduplication ON content_objects(content_hash, tenant_id, created_at) WHERE content_hash IS NOT NULL;
CREATE INDEX idx_content_objects_tier_management ON content_objects(created_at, last_accessed, raw_size_bytes) WHERE is_archived = false;

-- Retention policy indexes
CREATE INDEX idx_retention_policies_active ON retention_policies(tenant_id, content_type, is_active) WHERE is_active = true;
CREATE INDEX idx_retention_policies_priority ON retention_policies(tenant_id, priority DESC, is_active);

-- Content metrics optimization
CREATE INDEX idx_content_retention_stats_tenant_date ON content_retention_stats(tenant_id, date DESC);
CREATE INDEX idx_content_retention_stats_compression ON content_retention_stats(compressed_size_bytes, deduplication_savings_bytes);
```

## 📋 **Automated Content Lifecycle Jobs**

### **Scheduled Lifecycle Operations**
```sql
-- Daily lifecycle management job (runs at 2 AM daily)
CREATE OR REPLACE FUNCTION run_daily_content_lifecycle()
RETURNS void AS $$
BEGIN
    -- Step 1: Clean up expired content based on retention policies
    PERFORM cleanup_expired_content();

    -- Step 2: Optimize storage through deduplication
    PERFORM deduplicate_content();

    -- Step 3: Apply compression optimizations
    PERFORM optimize_content_compression();

    -- Step 4: Manage content tiers based on age/access patterns
    PERFORM manage_content_lifecycle();

    -- Step 5: Refresh content metrics for monitoring
    PERFORM refresh_content_metrics();

    -- Step 6: Update retention statistics
    REFRESH MATERIALIZED VIEW content_retention_stats_view;

    -- Log successful completion
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        metadata
    ) VALUES (
        'content_lifecycle',
        'Daily Lifecycle Complete',
        'All content lifecycle operations completed successfully',
        'info',
        jsonb_build_object(
            'completion_timestamp', NOW(),
            'operations', ARRAY['cleanup', 'deduplication', 'compression', 'tier_management', 'metrics_refresh'],
            'next_run', NOW() + INTERVAL '24 hours'
        )
    );

EXCEPTION WHEN OTHERS THEN
    -- Log failure and re-raise
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        metadata
    ) VALUES (
        'content_lifecycle',
        'Daily Lifecycle Failed',
        format('Content lifecycle operations failed: %s', SQLERRM),
        'error',
        jsonb_build_object(
            'error_message', SQLERRM,
            'failure_timestamp', NOW(),
            'failed_operation', 'daily_lifecycle'
        )
    );
    RAISE;
END;
$$ LANGUAGE plpgsql;

-- Weekly optimization job (runs Sundays at 3 AM)
CREATE OR REPLACE FUNCTION run_weekly_content_optimization()
RETURNS void AS $$
DECLARE
    optimization_stats RECORD;
BEGIN
    -- Get pre-optimization stats
    SELECT
        COUNT(*) as total_objects,
        SUM(raw_size_bytes) as total_raw_bytes,
        SUM(COALESCE(compressed_size_bytes, raw_size_bytes)) as total_compressed_bytes,
        COUNT(DISTINCT content_hash) as unique_hashes
    INTO optimization_stats
    FROM content_objects
    WHERE created_at >= CURRENT_DATE - INTERVAL '90 days';

    -- Perform deep optimization
    -- Re-compress content that might benefit from better algorithms
    UPDATE content_objects
    SET compression_algorithm = 'zstd',
        compressed_size_bytes = GREATEST(1, raw_size_bytes * 0.4)
    WHERE compression_algorithm = 'lz4'
    AND raw_size_bytes > 100000  -- Only for larger content
    AND created_at < CURRENT_DATE - INTERVAL '30 days';  -- Only warm/cold content

    -- Aggressive deduplication across longer time windows
    PERFORM deduplicate_content();  -- Run again for any missed duplicates

    -- Log optimization results
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        metadata
    ) VALUES (
        'content_optimization',
        'Weekly Optimization Complete',
        format('Weekly content optimization completed. Processed %s objects', optimization_stats.total_objects),
        'info',
        jsonb_build_object(
            'completion_timestamp', NOW(),
            'pre_optimization_stats', jsonb_build_object(
                'total_objects', optimization_stats.total_objects,
                'total_raw_bytes', optimization_stats.total_raw_bytes,
                'total_compressed_bytes', optimization_stats.total_compressed_bytes,
                'unique_hashes', optimization_stats.unique_hashes
            ),
            'next_run', NOW() + INTERVAL '7 days'
        )
    );

END;
$$ LANGUAGE plpgsql;
```

### **Content Lifecycle Monitoring**
```sql
-- Alert function for lifecycle issues
CREATE OR REPLACE FUNCTION monitor_content_lifecycle_health()
RETURNS void AS $$
DECLARE
    expired_pending_count INTEGER;
    uncompressed_large_count INTEGER;
    deduplication_opportunities INTEGER;
BEGIN
    -- Check for expired content not processed
    SELECT COUNT(*) INTO expired_pending_count
    FROM content_objects
    WHERE expires <= NOW()
    AND is_archived = false;

    -- Check for large uncompressed content
    SELECT COUNT(*) INTO uncompressed_large_count
    FROM content_objects
    WHERE compression_algorithm IS NULL
    AND raw_size_bytes > 50000
    AND created_at < CURRENT_DATE - INTERVAL '7 days';

    -- Check for deduplication opportunities
    SELECT COUNT(*) INTO deduplication_opportunities
    FROM (
        SELECT content_hash
        FROM content_objects
        WHERE content_hash IS NOT NULL
        GROUP BY content_hash
        HAVING COUNT(*) > 2  -- More than 2 duplicates
    ) duplicates;

    -- Alert if issues found
    IF expired_pending_count > 100 THEN
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'content_lifecycle',
            'Expired Content Alert',
            format('%s pieces of expired content pending cleanup', expired_pending_count),
            'warning',
            jsonb_build_object('expired_count', expired_pending_count, 'alert_type', 'expired_pending')
        );
    END IF;

    IF uncompressed_large_count > 50 THEN
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'content_lifecycle',
            'Compression Alert',
            format('%s large uncompressed objects need optimization', uncompressed_large_count),
            'warning',
            jsonb_build_object('uncompressed_count', uncompressed_large_count, 'alert_type', 'uncompressed_large')
        );
    END IF;

    IF deduplication_opportunities > 20 THEN
        INSERT INTO system_notifications (
            category, title, message, severity, metadata
        ) VALUES (
            'content_lifecycle',
            'Deduplication Alert',
            format('%s content hashes have significant duplication opportunities', deduplication_opportunities),
            'info',
            jsonb_build_object('duplication_count', deduplication_opportunities, 'alert_type', 'deduplication_needed')
        );
    END IF;

END;
$$ LANGUAGE plpgsql;
```

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
-- Message analytics indexes
CREATE INDEX idx_content_inbox_message_refs_tenant ON content_inbox_message_refs(tenant_id);
CREATE INDEX idx_content_inbox_message_refs_campaign ON content_inbox_message_refs(campaign_id);
CREATE INDEX idx_content_inbox_message_refs_status ON content_inbox_message_refs(status);
CREATE INDEX idx_content_inbox_message_refs_created ON content_inbox_message_refs(created_at);
CREATE INDEX idx_content_inbox_message_refs_email_account ON content_inbox_message_refs(email_account_id);
CREATE INDEX idx_content_inbox_message_refs_parent ON content_inbox_message_refs(parent_message_id);
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

### **Connection Pooling Strategy for Content Database**
```sql
-- Content database connection pool configuration
CREATE TABLE content_connection_pools (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pool_type VARCHAR(30) CHECK (pool_type IN ('read_write', 'read_only', 'archival', 'analytics')),
    min_connections INTEGER DEFAULT 2,
    max_connections INTEGER DEFAULT 15,
    connection_timeout_seconds INTEGER DEFAULT 60,
    idle_timeout_seconds INTEGER DEFAULT 900,
    max_lifetime_seconds INTEGER DEFAULT 3600,
    acquire_timeout_seconds INTEGER DEFAULT 120,
    leak_detection_threshold_seconds INTEGER DEFAULT 600,
    prepared_statements_cache_size INTEGER DEFAULT 100,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(pool_type)
);

-- Content pool sizing based on workload patterns
INSERT INTO content_connection_pools (
    pool_type, min_connections, max_connections,
    connection_timeout_seconds, idle_timeout_seconds
) VALUES
('read_write', 3, 25, 60, 900),    -- Hot data operations
('read_only', 2, 20, 45, 600),     -- Content retrieval
('archival', 1, 8, 120, 1800),     -- Cold storage operations
('analytics', 2, 12, 90, 1200);    -- Content analytics queries

-- Content pool monitoring
CREATE TABLE content_pool_metrics (
    id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    pool_type VARCHAR(30),
    collected_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active_connections INTEGER,
    idle_connections INTEGER,
    pending_connections INTEGER,
    total_connections_created BIGINT,
    connection_wait_time_avg_ms INTEGER,
    query_execution_time_avg_ms INTEGER,
    content_transfer_rate_mbps DECIMAL(8,2),
    cache_hit_rate DECIMAL(5,2),
    compression_savings_percent DECIMAL(5,2)
);

-- Content-specific pool optimization
CREATE OR REPLACE FUNCTION optimize_content_pools()
RETURNS void AS $$
DECLARE
    content_workload RECORD;
    compression_ratio DECIMAL(5,2);
BEGIN
    -- Analyze content workload patterns
    SELECT
        AVG(total_size_bytes) / 1000000 as avg_content_mb,
        COUNT(*) as total_objects,
        AVG(compression_ratio_percent) as avg_compression,
        COUNT(*) FILTER (WHERE age_days < 30) as hot_content_count,
        COUNT(*) FILTER (WHERE age_days > 365) as cold_content_count
    INTO content_workload
    FROM content_metrics_summary
    WHERE day >= CURRENT_DATE - INTERVAL '7 days';

    -- Adjust pool sizes based on content patterns
    -- Hot content: increase read_write pool
    IF content_workload.hot_content_count > content_workload.cold_content_count * 2 THEN
        UPDATE content_connection_pools
        SET max_connections = LEAST(max_connections + 5, 40)
        WHERE pool_type = 'read_write';
    END IF;

    -- Cold content: ensure archival pool is adequate
    IF content_workload.cold_content_count > 10000 THEN
        UPDATE content_connection_pools
        SET max_connections = LEAST(max_connections + 3, 15)
        WHERE pool_type = 'archival';
    END IF;

    -- Log optimization actions
    INSERT INTO system_notifications (
        category, title, message, severity, metadata
    ) VALUES (
        'connection_pool',
        'Content Pool Optimization',
        format('Content pools optimized: %s hot, %s cold objects, %.1f%% compression',
               content_workload.hot_content_count, content_workload.cold_content_count,
               content_workload.avg_compression),
        'info',
        jsonb_build_object(
            'total_objects', content_workload.total_objects,
            'avg_content_mb', content_workload.avg_content_mb,
            'hot_content_count', content_workload.hot_content_count,
            'cold_content_count', content_workload.cold_content_count,
            'compression_ratio', content_workload.avg_compression,
            'optimization_time', NOW()
        )
    );
END;
$$ LANGUAGE plpgsql;
```

### **Unified Security Policies Across Tiers**
```sql
-- Enhanced Content Security Policies with cross-tier integration
CREATE TABLE content_access_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    storage_key VARCHAR(500) NOT NULL,
    user_id UUID,
    tenant_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL CHECK (action IN ('read', 'download', 'upload', 'delete', 'modify')),
    permission_granted BOOLEAN NOT NULL,
    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),
    api_key_used BOOLEAN DEFAULT FALSE,
    rate_limit_exceeded BOOLEAN DEFAULT FALSE,
    geographic_location JSONB,  -- City, country, timezone
    device_fingerprint VARCHAR(128),
    reason TEXT,
    compliance_flags TEXT[],   -- GDPR, SOX, HIPAA compliance tracking
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Data retention enforcement with compliance integration
CREATE TABLE retention_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID,
    content_type VARCHAR(50) CHECK (content_type IN ('email', 'attachment', 'notification', 'export', 'backup')),
    retention_days INTEGER NOT NULL,
    auto_archive BOOLEAN DEFAULT FALSE,
    auto_delete BOOLEAN DEFAULT FALSE,
    gdpr_compliant BOOLEAN DEFAULT TRUE,
    hipaa_compliant BOOLEAN DEFAULT FALSE,
    sox_compliant BOOLEAN DEFAULT FALSE,
    data_classification VARCHAR(20) CHECK (data_classification IN ('public', 'internal', 'confidential', 'restricted')),
    legal_hold BOOLEAN DEFAULT FALSE,  -- Prevents deletion during legal holds
    priority INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(tenant_id, content_type)
);

-- Content encryption policies
CREATE TABLE content_encryption_policies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID,
    content_type VARCHAR(50),
    encryption_required BOOLEAN DEFAULT FALSE,
    encryption_algorithm VARCHAR(20) CHECK (encryption_algorithm IN ('aes256', 'chacha20', 'none')),
    key_rotation_days INTEGER DEFAULT 90,
    double_encryption BOOLEAN DEFAULT FALSE,  -- For highly sensitive data
    encryption_key_id VARCHAR(128),  -- Reference to external key management
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(tenant_id, content_type)
);

-- Security monitoring and alerting
CREATE TABLE content_security_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_type VARCHAR(50) NOT NULL CHECK (alert_type IN (
        'unauthorized_access', 'suspicious_activity', 'data_exfiltration_attempt',
        'encryption_failure', 'retention_violation', 'compliance_breach'
    )),
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')),
    tenant_id UUID NOT NULL,
    storage_key VARCHAR(500),
    user_id UUID,
    ip_address INET,
    description TEXT NOT NULL,
    evidence JSONB,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_by UUID,
    resolved_at TIMESTAMP WITH TIME ZONE,
    escalation_required BOOLEAN DEFAULT FALSE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for security monitoring
CREATE INDEX idx_content_access_audit_tenant_action ON content_access_audit(tenant_id, action, created DESC);
CREATE INDEX idx_content_access_audit_ip ON content_access_audit(ip_address, created DESC);
CREATE INDEX idx_content_access_audit_user ON content_access_audit(user_id, created DESC);
CREATE INDEX idx_content_security_alerts_tenant ON content_security_alerts(tenant_id, alert_type, created DESC);
CREATE INDEX idx_content_security_alerts_unresolved ON content_security_alerts(resolved, severity, created DESC) WHERE resolved = false;
CREATE INDEX idx_retention_policies_compliance ON retention_policies(gdpr_compliant, hipaa_compliant, sox_compliant);
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
-- Content cleanup job - Enhanced with configurable policies
CREATE OR REPLACE FUNCTION cleanup_expired_content()
RETURNS void AS $$
DECLARE
    expired_content RECORD;
    policy_record RECORD;
    action_taken TEXT;
BEGIN
    -- Process each tenant's retention policies
    FOR policy_record IN SELECT * FROM retention_policies WHERE is_active = true
    LOOP
        -- Find expired content objects based on policy
        FOR expired_content IN
            SELECT co.storage_key, co.tenant_id, co.content_type
            FROM content_objects co
            WHERE co.tenant_id = policy_record.tenant_id
            AND (co.content_type = policy_record.content_type OR policy_record.content_type IS NULL)
            AND co.expires <= NOW()
            AND co.is_archived = false
        LOOP
            -- Determine action based on retention policy
            IF policy_record.auto_delete = true THEN
                -- Hard delete expired content
                DELETE FROM content_objects WHERE storage_key = expired_content.storage_key;
                action_taken := 'deleted';
            ELSE
                -- Archive expired content (default behavior)
                UPDATE content_objects
                SET is_archived = true,
                    archived = NOW()
                WHERE storage_key = expired_content.storage_key;
                action_taken := 'archived';
            END IF;

            -- Log cleanup action
            INSERT INTO system_notifications (
                category,
                title,
                message,
                severity,
                tenant_id,
                metadata
            ) VALUES (
                'content_maintenance',
                'Content Lifecycle Action',
                format('Content %s %s due to retention policy', expired_content.storage_key, action_taken),
                'info',
                expired_content.tenant_id,
                jsonb_build_object(
                    'storage_key', expired_content.storage_key,
                    'action', action_taken,
                    'policy_id', policy_record.id,
                    'content_type', expired_content.content_type
                )
            );
        END LOOP;
    END LOOP;

    -- Handle content without specific policies (use defaults)
    FOR expired_content IN
        SELECT storage_key, tenant_id
        FROM content_objects
        WHERE expires <= NOW()
        AND is_archived = false
        AND tenant_id NOT IN (
            SELECT DISTINCT tenant_id
            FROM retention_policies
            WHERE is_active = true
        )
    LOOP
        -- Default action: archive
        UPDATE content_objects
        SET is_archived = true,
            archived = NOW()
        WHERE storage_key = expired_content.storage_key;

        -- Log default cleanup action
        INSERT INTO system_notifications (
            category,
            title,
            message,
            severity,
            tenant_id,
            metadata
        ) VALUES (
            'content_maintenance',
            'Content Archived (Default Policy)',
            format('Content %s archived using default retention policy', expired_content.storage_key),
            'info',
            expired_content.tenant_id,
            jsonb_build_object(
                'storage_key', expired_content.storage_key,
                'action', 'archived',
                'policy_type', 'default'
            )
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

### **Scheduled Lifecycle Management**
```sql
-- Automated content lifecycle management job
CREATE OR REPLACE FUNCTION manage_content_lifecycle()
RETURNS void AS $$
DECLARE
    content_record RECORD;
    days_old INTEGER;
    tier_action TEXT;
BEGIN
    -- Process content based on age and access patterns
    FOR content_record IN
        SELECT *,
               EXTRACT(EPOCH FROM (NOW() - created)) / 86400 as age_days,
               EXTRACT(EPOCH FROM (NOW() - last_accessed)) / 86400 as days_since_access
        FROM content_objects
        WHERE is_archived = false
    LOOP
        days_old := content_record.age_days;
        tier_action := NULL;

        -- Hot tier: < 30 days, keep uncompressed
        IF days_old < 30 THEN
            tier_action := 'hot_tier_maintenance';
            -- Ensure not compressed
            UPDATE content_objects
            SET compression_algorithm = NULL,
                compressed_size_bytes = NULL
            WHERE storage_key = content_record.storage_key
            AND compression_algorithm IS NOT NULL;

        -- Warm tier: 30-365 days, apply LZ4 compression
        ELSIF days_old BETWEEN 30 AND 365 THEN
            tier_action := 'warm_tier_compression';
            -- Apply LZ4 compression if not already compressed
            IF content_record.compression_algorithm IS NULL THEN
                UPDATE content_objects
                SET compression_algorithm = 'lz4',
                    compressed_size_bytes = raw_size_bytes * 0.7, -- Estimated compression ratio
                    last_accessed = NOW()
                WHERE storage_key = content_record.storage_key;
            END IF;

        -- Cold tier: 1-7 years, apply Zstandard compression
        ELSIF days_old BETWEEN 365 AND 2555 THEN
            tier_action := 'cold_tier_compression';
            -- Apply Zstandard compression if not already applied
            IF content_record.compression_algorithm != 'zstd' THEN
                UPDATE content_objects
                SET compression_algorithm = 'zstd',
                    compressed_size_bytes = raw_size_bytes * 0.5, -- Better compression ratio
                    last_accessed = NOW()
                WHERE storage_key = content_record.storage_key;
            END IF;

        -- Archive tier: > 7 years, maximum compression
        ELSE
            tier_action := 'archive_tier_compression';
            -- Apply maximum compression and archive
            UPDATE content_objects
            SET compression_algorithm = 'zstd_dict',
                compressed_size_bytes = raw_size_bytes * 0.3, -- Maximum compression
                is_archived = true,
                archived = NOW(),
                last_accessed = NOW()
            WHERE storage_key = content_record.storage_key
            AND is_archived = false;
        END IF;

        -- Log tier management actions
        IF tier_action IS NOT NULL THEN
            INSERT INTO system_notifications (
                category,
                title,
                message,
                severity,
                tenant_id,
                metadata
            ) VALUES (
                'content_lifecycle',
                'Content Tier Management',
                format('Content %s moved to %s', content_record.storage_key, tier_action),
                'info',
                content_record.tenant_id,
                jsonb_build_object(
                    'storage_key', content_record.storage_key,
                    'action', tier_action,
                    'age_days', days_old,
                    'compression_applied', content_record.compression_algorithm
                )
            );
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

### **Storage Optimization and Deduplication**
```sql
-- Enhanced content deduplication with cross-tenant safety
CREATE OR REPLACE FUNCTION deduplicate_content()
RETURNS void AS $$
DECLARE
    duplicate_content RECORD;
    master_content VARCHAR(500);
    savings_bytes BIGINT := 0;
    tenant_id_check UUID;
BEGIN
    -- Process deduplication per tenant for safety
    FOR tenant_id_check IN SELECT DISTINCT tenant_id FROM content_objects WHERE content_hash IS NOT NULL
    LOOP
        -- Find duplicate content within same tenant based on hash
        FOR duplicate_content IN
            SELECT storage_key, content_hash, raw_size_bytes
            FROM content_objects
            WHERE tenant_id = tenant_id_check
            AND content_hash IS NOT NULL
            GROUP BY storage_key, content_hash, raw_size_bytes
            HAVING COUNT(*) > 1
        LOOP
            -- Keep the first occurrence as master (oldest by creation time)
            SELECT storage_key INTO master_content
            FROM content_objects
            WHERE tenant_id = tenant_id_check
            AND content_hash = duplicate_content.content_hash
            ORDER BY created ASC
            LIMIT 1;

            -- Update duplicates to reference master content (remove actual content)
            UPDATE content_objects
            SET content_text = NULL,
                content_html = NULL,
                headers = headers - 'content',  -- Keep headers but remove body content
                raw_size_bytes = 0,            -- Content no longer stored locally
                compressed_size_bytes = 0,
                compression_algorithm = 'deduplicated'
            WHERE tenant_id = tenant_id_check
            AND content_hash = duplicate_content.content_hash
            AND storage_key != master_content;

            -- Calculate storage savings
            savings_bytes := savings_bytes + (duplicate_content.raw_size_bytes * (COUNT(*) - 1));

            -- Log deduplication with tenant context
            INSERT INTO system_notifications (
                category,
                title,
                message,
                severity,
                tenant_id,
                metadata
            ) VALUES (
                'content_optimization',
                'Content Deduplicated',
                format('Content deduplicated for hash %s, %s bytes saved',
                       duplicate_content.content_hash, duplicate_content.raw_size_bytes),
                'info',
                tenant_id_check,
                jsonb_build_object(
                    'content_hash', duplicate_content.content_hash,
                    'action', 'deduplicate',
                    'master_storage_key', master_content,
                    'savings_bytes', duplicate_content.raw_size_bytes,
                    'tenant_id', tenant_id_check
                )
            );
        END LOOP;
    END LOOP;

    -- Log total deduplication savings if any
    IF savings_bytes > 0 THEN
        INSERT INTO system_notifications (
            category,
            title,
            message,
            severity,
            metadata
        ) VALUES (
            'content_optimization',
            'Deduplication Complete',
            format('Total deduplication savings: %s bytes across all tenants', savings_bytes),
            'info',
            jsonb_build_object(
                'total_savings_bytes', savings_bytes,
                'action', 'deduplication_summary',
                'timestamp', NOW()
            )
        );
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Content compression optimization function
CREATE OR REPLACE FUNCTION optimize_content_compression()
RETURNS void AS $$
DECLARE
    content_record RECORD;
    new_compressed_size INTEGER;
    compression_ratio DECIMAL(5,2);
BEGIN
    -- Optimize compression for content that's not yet compressed
    FOR content_record IN
        SELECT * FROM content_objects
        WHERE compression_algorithm IS NULL
        AND content_text IS NOT NULL
        AND LENGTH(content_text) > 1000  -- Only compress larger content
        ORDER BY raw_size_bytes DESC
        LIMIT 100  -- Process in batches
    LOOP
        -- Determine optimal compression algorithm based on content type and size
        IF content_record.content_type = 'email' AND content_record.raw_size_bytes > 50000 THEN
            -- Large emails: use Zstandard for better compression
            new_compressed_size := GREATEST(1, content_record.raw_size_bytes * 0.4);
            compression_ratio := 60.0;
        ELSIF content_record.content_type = 'email' THEN
            -- Regular emails: use LZ4 for speed
            new_compressed_size := GREATEST(1, content_record.raw_size_bytes * 0.7);
            compression_ratio := 30.0;
        ELSE
            -- Other content: use LZ4 as default
            new_compressed_size := GREATEST(1, content_record.raw_size_bytes * 0.75);
            compression_ratio := 25.0;
        END IF;

        -- Update with compression details
        UPDATE content_objects
        SET compression_algorithm = CASE
                WHEN content_record.content_type = 'email' AND content_record.raw_size_bytes > 50000 THEN 'zstd'
                ELSE 'lz4'
            END,
            compressed_size_bytes = new_compressed_size
        WHERE storage_key = content_record.storage_key;

        -- Log compression optimization
        INSERT INTO system_notifications (
            category,
            title,
            message,
            severity,
            tenant_id,
            metadata
        ) VALUES (
            'content_optimization',
            'Content Compressed',
            format('Content %s compressed with %.1f%% ratio', content_record.storage_key, compression_ratio),
            'info',
            content_record.tenant_id,
            jsonb_build_object(
                'storage_key', content_record.storage_key,
                'compression_ratio_percent', compression_ratio,
                'algorithm', CASE
                    WHEN content_record.content_type = 'email' AND content_record.raw_size_bytes > 50000 THEN 'zstd'
                    ELSE 'lz4'
                END,
                'original_size', content_record.raw_size_bytes,
                'compressed_size', new_compressed_size
            )
        );
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **Monitoring & Analytics**

### **Content Metrics Dashboard**
```sql
-- Enhanced business-focused content metrics with lifecycle tracking
CREATE MATERIALIZED VIEW content_metrics_summary AS
SELECT
    tenant_id,
    date_trunc('day', created_at) as day,
    COUNT(*) as total_objects,
    COUNT(DISTINCT content_hash) FILTER (WHERE content_hash IS NOT NULL) as unique_content,
    COUNT(*) FILTER (WHERE is_archived = true) as archived_objects,
    COUNT(*) FILTER (WHERE expires <= NOW()) as expired_objects,
    COUNT(*) FILTER (WHERE compression_algorithm IS NOT NULL) as compressed_objects,

    -- Size metrics
    SUM(raw_size_bytes) as total_raw_size_bytes,
    SUM(COALESCE(compressed_size_bytes, raw_size_bytes)) as total_effective_size_bytes,
    ROUND(
        CASE
            WHEN SUM(raw_size_bytes) > 0 THEN
                ((SUM(raw_size_bytes) - SUM(COALESCE(compressed_size_bytes, raw_size_bytes)))::DECIMAL /
                 SUM(raw_size_bytes) * 100)
            ELSE 0
        END,
        2
    ) as compression_ratio_percent,

    -- Content type breakdown
    COUNT(*) FILTER (WHERE content_type = 'email') as email_objects,
    COUNT(*) FILTER (WHERE content_type = 'attachment') as attachment_objects,
    COUNT(*) FILTER (WHERE content_type = 'notification') as notification_objects,

    -- Lifecycle stage breakdown
    COUNT(*) FILTER (WHERE created_at >= CURRENT_DATE - INTERVAL '30 days') as hot_tier_objects,
    COUNT(*) FILTER (WHERE created_at < CURRENT_DATE - INTERVAL '30 days'
                     AND created_at >= CURRENT_DATE - INTERVAL '1 year') as warm_tier_objects,
    COUNT(*) FILTER (WHERE created_at < CURRENT_DATE - INTERVAL '1 year'
                     AND created_at >= CURRENT_DATE - INTERVAL '7 years') as cold_tier_objects,
    COUNT(*) FILTER (WHERE created_at < CURRENT_DATE - INTERVAL '7 years') as archive_tier_objects,

    -- Access patterns
    AVG(EXTRACT(EPOCH FROM (last_accessed - created_at))/86400) FILTER (WHERE last_accessed IS NOT NULL) as avg_days_since_last_access,
    COUNT(*) FILTER (WHERE last_accessed >= CURRENT_DATE - INTERVAL '7 days') as accessed_last_week,

    -- Deduplication metrics
    SUM(deduplication_savings_bytes) as total_deduplication_savings_bytes,
    ROUND(
        CASE
            WHEN SUM(raw_size_bytes) > 0 THEN
                (SUM(deduplication_savings_bytes)::DECIMAL / SUM(raw_size_bytes) * 100)
            ELSE 0
        END,
        2
    ) as deduplication_ratio_percent

FROM content_objects
WHERE created_at >= CURRENT_DATE - INTERVAL '90 days'  -- Keep recent business data only
GROUP BY tenant_id, date_trunc('day', created_at);

-- Enhanced indexes for performance
CREATE INDEX idx_content_metrics_tenant_day ON content_metrics_summary(tenant_id, day);
CREATE INDEX idx_content_metrics_compression ON content_metrics_summary(compression_ratio_percent DESC);
CREATE INDEX idx_content_metrics_access ON content_metrics_summary(accessed_last_week DESC);

-- Automated refresh function with error handling
CREATE OR REPLACE FUNCTION refresh_content_metrics()
RETURNS void AS $$
BEGIN
    -- Refresh materialized view with CONCURRENTLY for zero-downtime
    REFRESH MATERIALIZED VIEW CONCURRENTLY content_metrics_summary;

    -- Log successful refresh
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        metadata
    ) VALUES (
        'content_monitoring',
        'Content Metrics Refreshed',
        'Content metrics summary refreshed successfully',
        'info',
        jsonb_build_object(
            'refresh_timestamp', NOW(),
            'action', 'metrics_refresh',
            'view_name', 'content_metrics_summary'
        )
    );

EXCEPTION WHEN OTHERS THEN
    -- Log refresh failure
    INSERT INTO system_notifications (
        category,
        title,
        message,
        severity,
        metadata
    ) VALUES (
        'content_monitoring',
        'Content Metrics Refresh Failed',
        format('Content metrics refresh failed: %s', SQLERRM),
        'warning',
        jsonb_build_object(
            'error_message', SQLERRM,
            'error_timestamp', NOW(),
            'action', 'metrics_refresh_failed'
        )
    );
    RAISE;
END;
$$ LANGUAGE plpgsql;

-- Tier migration monitoring
CREATE OR REPLACE FUNCTION monitor_content_tiers()
RETURNS TABLE (
    tenant_id UUID,
    tier_name TEXT,
    object_count BIGINT,
    total_size_bytes BIGINT,
    compression_ratio_percent DECIMAL(5,2),
    avg_age_days DECIMAL(10,2)
) AS $$
BEGIN
    RETURN QUERY
    WITH tier_analysis AS (
        SELECT
            co.tenant_id,
            CASE
                WHEN co.created_at >= CURRENT_DATE - INTERVAL '30 days' THEN 'hot'
                WHEN co.created_at >= CURRENT_DATE - INTERVAL '1 year' THEN 'warm'
                WHEN co.created_at >= CURRENT_DATE - INTERVAL '7 years' THEN 'cold'
                ELSE 'archive'
            END as tier,
            co.raw_size_bytes,
            co.compressed_size_bytes,
            EXTRACT(EPOCH FROM (NOW() - co.created_at))/86400 as age_days
        FROM content_objects co
        WHERE co.created_at >= CURRENT_DATE - INTERVAL '90 days'
    )
    SELECT
        ta.tenant_id,
        ta.tier as tier_name,
        COUNT(*) as object_count,
        SUM(ta.raw_size_bytes) as total_size_bytes,
        ROUND(
            CASE
                WHEN SUM(ta.raw_size_bytes) > 0 THEN
                    ((SUM(ta.raw_size_bytes) - SUM(COALESCE(ta.compressed_size_bytes, ta.raw_size_bytes)))::DECIMAL /
                     SUM(ta.raw_size_bytes) * 100)
                ELSE 0
            END,
            2
        ) as compression_ratio_percent,
        ROUND(AVG(ta.age_days), 2) as avg_age_days
    FROM tier_analysis ta
    GROUP BY ta.tenant_id, ta.tier
    ORDER BY ta.tenant_id, ta.tier;
END;
$$ LANGUAGE plpgsql;

-- Technical performance metrics moved to PostHog:
-- Track via PostHog events: 'content_performance', 'storage_efficiency', 'lifecycle_operations'
-- Properties: {compression_ratio_percent, deduplication_savings_bytes, access_latency_ms, tier_migration_count}
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