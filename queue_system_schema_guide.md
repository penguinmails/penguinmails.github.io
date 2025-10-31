# Queue System Schema Guide - Job Processing & Reliability

## Overview

The **Queue System** is PenguinMails' job processing and reliability layer designed for asynchronous operations, retry logic, and system reliability. This tier provides a hybrid PostgreSQL + Redis architecture combining durability with high-performance job processing.

### 🎯 **Purpose & Characteristics**

- **Primary Focus**: Job state management, retry logic, processing reliability
- **Architecture**: Hybrid PostgreSQL + Redis for durability and performance
- **Reliability**: Comprehensive logging, retry mechanisms, dead letter queues
- **Scalability**: Redis for high-throughput operations, PostgreSQL for state tracking

### ⚡ **Performance Strategy**

- **Redis Lists**: Fast job queues for immediate processing
- **PostgreSQL State**: Durable job tracking and audit trails
- **Priority Queues**: Multiple priority levels for different job types
- **Retry Logic**: Exponential backoff and comprehensive error handling

---

## 🏗️ **Queue Infrastructure**

### **job_queues** - Queue Configuration

```sql
CREATE TABLE job_queues (
    name VARCHAR(100) PRIMARY KEY,
    default_priority INTEGER DEFAULT 100,
    max_concurrent_jobs INTEGER DEFAULT 10,
    timeout_seconds INTEGER DEFAULT 3600,
    retry_attempts INTEGER DEFAULT 3,
    backoff_multiplier INTEGER DEFAULT 2,
    is_active BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Queue Types:**
- **email-sending**: Email campaign delivery
- **analytics-processing**: OLAP analytics aggregation
- **content-archival**: Content database cleanup
- **infrastructure-monitoring**: System health checks
- **billing-sync**: Stripe payment synchronization
- **notification-delivery**: User notification processing

### **jobs** - Job State Management (PostgreSQL)

```sql
CREATE TABLE jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    queue_name VARCHAR(100) REFERENCES job_queues(name) ON DELETE CASCADE,
    job_type VARCHAR(100) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('queued', 'processing', 'completed', 'failed', 'cancelled', 'expired')) DEFAULT 'queued',
    priority INTEGER DEFAULT 100,
    payload JSONB NOT NULL,
    result JSONB,
    attempt_count INTEGER DEFAULT 0,
    max_attempts INTEGER DEFAULT 3,
    run TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    started TIMESTAMP WITH TIME ZONE,
    completed TIMESTAMP WITH TIME ZONE,
    failed TIMESTAMP WITH TIME ZONE,
    expires TIMESTAMP WITH TIME ZONE,
    last_error_message TEXT,
    error_details JSONB,
    progress_percentage INTEGER DEFAULT 0,
    progress_message TEXT,
    tenant_id UUID,
    user_id UUID,
    correlation_id VARCHAR(255),
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Job Status Flow:**
- **queued**: Waiting for processing
- **processing**: Currently being executed
- **completed**: Successfully finished
- **failed**: Failed after all retries
- **cancelled**: Manually cancelled
- **expired**: Past expiration time

### **job_logs** - Job Execution Logs

```sql
CREATE TABLE job_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    log_level VARCHAR(20) CHECK (log_level IN ('debug', 'info', 'warning', 'error', 'fatal')) DEFAULT 'info',
    message TEXT NOT NULL,
    context JSONB,
    attempt_number INTEGER NOT NULL,
    duration_ms INTEGER,
    memory_usage_mb INTEGER,
    started TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    finished TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## ⚡ **Redis Integration Patterns**

### **Redis Data Structures**

#### **Queue Lists** (Primary Job Queues)
```redis
# Queue naming convention
queue:email-sending
queue:analytics-processing
queue:content-archival
queue:infrastructure-monitoring

# Priority queues
queue:email-sending:high    # priority 1-50
queue:email-sending:normal  # priority 51-150
queue:email-sending:low     # priority 151+
```

#### **Job Hashes** (Job Metadata)
```redis
# Job metadata storage
job:uuid-123 {
  status: "processing",
  queue_name: "email-sending",
  payload: '{"campaign_id": "abc", "recipients": 1000}',
  attempt_count: "1",
  max_attempts: "3",
  started_at: "2025-10-30T19:00:00Z",
  worker_id: "worker-1",
  priority: "100"
}
```

#### **Worker Management**
```redis
# Active workers
workers:active ["worker-1", "worker-2", "worker-3"]

# Worker load balancing
worker:worker-1:current_jobs 5
worker:worker-1:processed_total 1250
worker:worker-1:last_heartbeat 1701286794
```

---

## 🔄 **Job Processing Workflow**

### **Job Creation & Queuing**
```sql
-- Create job in PostgreSQL
INSERT INTO jobs (
    queue_name, job_type, payload, priority, run_at, tenant_id, correlation_id
) VALUES (
    'email-sending', 'send_campaign', 
    '{"campaign_id": "123", "recipients": 1000}',
    100, NOW(), 'tenant-456', 'campaign-123-send-001'
);

-- Push to Redis queue
LPUSH queue:email-sending '{"jobId": "uuid-789", "priority": 100}';
```

### **Worker Processing Pattern**
```typescript
// Worker processing loop
async function processQueue(workerId: string, queueName: string) {
  const job = await redis.brpop(`queue:${queueName}`, 0);
  
  if (job) {
    const jobData = JSON.parse(job[1]);
    await startJobProcessing(workerId, jobData);
  }
}

async function startJobProcessing(workerId: string, jobData: any) {
  const jobId = jobData.jobId;
  
  // Update job status in PostgreSQL
  await updateJobStatus(jobId, 'processing', {
    worker_id: workerId,
    started_at: new Date()
  });
  
  // Execute job
  try {
    const result = await executeJob(jobData.payload);
    await completeJob(jobId, result);
  } catch (error) {
    await failJob(jobId, error);
  }
}
```

### **Retry Logic Implementation**
```sql
-- Retry policy function
CREATE OR REPLACE FUNCTION calculate_next_run(
    attempt_count INTEGER,
    backoff_multiplier INTEGER DEFAULT 2,
    base_delay_seconds INTEGER DEFAULT 60
)
RETURNS TIMESTAMP WITH TIME ZONE AS $$
BEGIN
    RETURN NOW() + (base_delay_seconds * (backoff_multiplier ^ attempt_count)) * INTERVAL '1 second';
END;
$$ LANGUAGE plpgsql;

-- Update failed job for retry
CREATE OR REPLACE FUNCTION retry_failed_job(job_id_param UUID)
RETURNS VOID AS $$
DECLARE
    job_record RECORD;
    next_run TIMESTAMP;
BEGIN
    -- Get job details
    SELECT * INTO job_record FROM jobs WHERE id = job_id_param;
    
    -- Calculate next run time with exponential backoff
    next_run := calculate_next_run(job_record.attempt_count);
    
    -- Update job for retry
    UPDATE jobs 
    SET 
        status = 'queued',
        attempt_count = attempt_count + 1,
        run = next_run,
        failed = NULL,
        started = NULL,
        last_error_message = NULL,
        error_details = NULL,
        updated = NOW()
    WHERE id = job_id_param;
    
    -- Queue for retry
    PERFORM redis.lpush(
        `queue:${job_record.queue_name}`,
        json_build_object('jobId', job_id_param, 'priority', job_record.priority)::text
    );
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **Job Monitoring & Analytics**

### **job_metrics** - Performance Analytics

```sql
CREATE TABLE job_metrics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    date DATE NOT NULL,
    queue_name VARCHAR(100) NOT NULL,
    job_type VARCHAR(100) NOT NULL,
    total_jobs INTEGER DEFAULT 0,
    completed_jobs INTEGER DEFAULT 0,
    failed_jobs INTEGER DEFAULT 0,
    avg_duration_ms INTEGER DEFAULT 0,
    p95_duration_ms INTEGER DEFAULT 0,
    p99_duration_ms INTEGER DEFAULT 0,
    throughput_per_hour INTEGER DEFAULT 0,
    error_rate_percent DECIMAL(5,2) DEFAULT 0,
    retry_count INTEGER DEFAULT 0,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(date, queue_name, job_type)
);
```

### **worker_performance** - Worker Analytics

```sql
CREATE TABLE worker_performance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    worker_id VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    jobs_processed INTEGER DEFAULT 0,
    jobs_successful INTEGER DEFAULT 0,
    jobs_failed INTEGER DEFAULT 0,
    avg_processing_time_ms INTEGER DEFAULT 0,
    uptime_minutes INTEGER DEFAULT 0,
    error_count INTEGER DEFAULT 0,
    last_heartbeat TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(worker_id, date)
);
```

### **queue_health** - System Health Monitoring

```sql
CREATE TABLE queue_health (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    queue_name VARCHAR(100) NOT NULL,
    pending_jobs INTEGER DEFAULT 0,
    processing_jobs INTEGER DEFAULT 0,
    failed_jobs_24h INTEGER DEFAULT 0,
    oldest_pending_job_age_minutes INTEGER DEFAULT 0,
    avg_processing_time_minutes INTEGER DEFAULT 0,
    error_rate_percent DECIMAL(5,2) DEFAULT 0,
    health_status VARCHAR(20) CHECK (health_status IN ('healthy', 'degraded', 'critical')) DEFAULT 'healthy',
    alerts_generated INTEGER DEFAULT 0,
    metadata JSONB
);
```

---

## 🛠️ **Job Type Specifications**

### **Email Sending Jobs**
```sql
-- Email campaign sending job
CREATE TABLE email_sending_jobs (
    job_id UUID PRIMARY KEY REFERENCES jobs(id) ON DELETE CASCADE,
    campaign_id UUID NOT NULL,
    template_id UUID,
    recipient_count INTEGER NOT NULL,
    batch_size INTEGER DEFAULT 100,
    rate_limit_per_hour INTEGER,
    email_account_id UUID,
    sending_window_start TIMESTAMP WITH TIME ZONE,
    sending_window_end TIMESTAMP WITH TIME ZONE,
    tracking_enabled BOOLEAN DEFAULT TRUE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Analytics Processing Jobs**
```sql
-- Analytics aggregation job
CREATE TABLE analytics_jobs (
    job_id UUID PRIMARY KEY REFERENCES jobs(id) ON DELETE CASCADE,
    aggregation_type VARCHAR(50) CHECK (aggregation_type IN ('daily', 'weekly', 'monthly')),
    target_date DATE NOT NULL,
    tenant_id UUID,
    campaign_id UUID,
    data_source VARCHAR(100),
    processing_mode VARCHAR(50) DEFAULT 'full',
    output_tables TEXT[],
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Content Management Jobs**
```sql
-- Content archival job
CREATE TABLE content_jobs (
    job_id UUID PRIMARY KEY REFERENCES jobs(id) ON DELETE CASCADE,
    operation_type VARCHAR(50) CHECK (operation_type IN ('archive', 'cleanup', 'deduplicate')),
    tenant_id UUID,
    content_type VARCHAR(50),
    retention_days INTEGER,
    max_items_per_batch INTEGER DEFAULT 1000,
    dry_run BOOLEAN DEFAULT FALSE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 📈 **Performance Indexes**

### **Critical Queue Indexes**
```sql
-- Job status and priority indexing
CREATE INDEX idx_jobs_queue_status ON jobs(queue_name, status, priority DESC);
CREATE INDEX idx_jobs_run ON jobs(run_at) WHERE status = 'queued';
CREATE INDEX idx_jobs_tenant ON jobs(tenant_id, created DESC);
CREATE INDEX idx_jobs_correlation ON jobs(correlation_id) WHERE correlation_id IS NOT NULL;

-- Job timing and performance
CREATE INDEX idx_jobs_started ON jobs(started_at);
CREATE INDEX idx_jobs_completed ON jobs(completed_at) WHERE completed IS NOT NULL;
CREATE INDEX idx_jobs_failed ON jobs(failed_at) WHERE failed IS NOT NULL;

-- Retry and failure analysis
CREATE INDEX idx_jobs_failed_recently ON jobs(failed DESC) WHERE failed > NOW() - INTERVAL '24 hours';

-- Job logging
CREATE INDEX idx_job_logs_job ON job_logs(job_id, created DESC);
CREATE INDEX idx_job_logs_level ON job_logs(log_level, created DESC);

-- Metrics and analytics
CREATE INDEX idx_job_metrics_date_queue ON job_metrics(date, queue_name);
CREATE INDEX idx_worker_performance_worker_date ON worker_performance(worker_id, date);
CREATE INDEX idx_queue_health_queue ON queue_health(queue_name, timestamp DESC);
```

---

## 🔐 **Security & Access Control**

### **Job Access Policies**
```sql
-- Multi-tenant job isolation
CREATE POLICY jobs_tenant_isolation ON jobs
    FOR ALL USING (tenant_id = current_setting('app.current_tenant_id')::uuid);

CREATE POLICY job_logs_tenant_isolation ON job_logs
    FOR ALL USING (
        job_id IN (
            SELECT id FROM jobs 
            WHERE tenant_id = current_setting('app.current_tenant_id')::uuid
        )
    );
```

### **Job Auditing**
```sql
-- Job audit trail
CREATE TABLE job_audit (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    job_id UUID REFERENCES jobs(id) ON DELETE CASCADE,
    action VARCHAR(50) NOT NULL,
    performed_by UUID,
    old_values JSONB,
    new_values JSONB,
    reason TEXT,
    ip_address INET,
    user_agent TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit trigger function
CREATE OR REPLACE FUNCTION audit_job_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'UPDATE' AND OLD.status != NEW.status THEN
        INSERT INTO job_audit (
            job_id, action, old_values, new_values, performed_by
        ) VALUES (
            NEW.id, 
            'status_change',
            jsonb_build_object('status', OLD.status),
            jsonb_build_object('status', NEW.status),
            current_setting('app.current_user_id', true)::uuid
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER job_audit_trigger
    AFTER UPDATE ON jobs
    FOR EACH ROW EXECUTE FUNCTION audit_job_changes();
```

---

## 🚨 **Dead Letter Queue System**

### **dead_letter_jobs** - Failed Jobs Archive

```sql
CREATE TABLE dead_letter_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    original_job_id UUID NOT NULL,
    queue_name VARCHAR(100) NOT NULL,
    job_type VARCHAR(100) NOT NULL,
    final_attempt INTEGER NOT NULL,
    failure_reason TEXT NOT NULL,
    error_details JSONB,
    payload JSONB NOT NULL,
    failure_timestamp TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_retry TIMESTAMP WITH TIME ZONE,
    retry_count INTEGER DEFAULT 0,
    is_resolved BOOLEAN DEFAULT FALSE,
    resolved TIMESTAMP WITH TIME ZONE,
    resolved_by UUID,
    resolution_notes TEXT,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Dead letter job index
CREATE INDEX idx_dead_letter_jobs_queue ON dead_letter_jobs(queue_name, failure_timestamp DESC);
CREATE INDEX idx_dead_letter_jobs_unresolved ON dead_letter_jobs(is_resolved, failure_timestamp DESC) WHERE is_resolved = false;
```

### **Dead Letter Processing**
```sql
-- Move failed job to dead letter queue
CREATE OR REPLACE FUNCTION move_to_dead_letter_queue(job_id_param UUID)
RETURNS VOID AS $$
DECLARE
    job_record RECORD;
BEGIN
    -- Get job details
    SELECT * INTO job_record FROM jobs WHERE id = job_id_param;
    
    -- Insert into dead letter queue
    INSERT INTO dead_letter_jobs (
        original_job_id, queue_name, job_type, final_attempt,
        failure_reason, error_details, payload, last_retry_at
    ) VALUES (
        job_id_param, job_record.queue_name, job_record.job_type,
        job_record.attempt_count, job_record.last_error_message,
        job_record.error_details, job_record.payload, job_record.failed_at
    );
    
    -- Mark original job as expired
    UPDATE jobs 
    SET status = 'expired', updated = NOW()
    WHERE id = job_id_param;
    
    -- Log the movement
    INSERT INTO job_logs (job_id, log_level, message)
    VALUES (job_id_param, 'warning', 'Job moved to dead letter queue');
END;
$$ LANGUAGE plpgsql;
```

---

## 📊 **Monitoring & Alerting**

### **Queue Health Alerts**
```sql
-- Alert configuration
CREATE TABLE queue_alerts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    queue_name VARCHAR(100) NOT NULL,
    alert_type VARCHAR(50) CHECK (alert_type IN (
        'high_pending_jobs', 'slow_processing', 'high_error_rate', 
        'worker_offline', 'queue_backlog'
    )),
    threshold_value INTEGER,
    time_window_minutes INTEGER DEFAULT 5,
    severity VARCHAR(20) CHECK (severity IN ('low', 'medium', 'high', 'critical')) DEFAULT 'medium',
    is_active BOOLEAN DEFAULT TRUE,
    notification_channels TEXT[],
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    UNIQUE(queue_name, alert_type)
);

-- Alert history
CREATE TABLE queue_alert_history (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    alert_id UUID REFERENCES queue_alerts(id),
    triggered TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    resolved TIMESTAMP WITH TIME ZONE,
    metric_value INTEGER,
    alert_message TEXT,
    notification_sent BOOLEAN DEFAULT FALSE,
    acknowledged_by UUID,
    acknowledged TIMESTAMP WITH TIME ZONE
);
```

---

## 🔄 **Job Scheduling & Recurring Jobs**

### **scheduled_jobs** - Recurring Job Management

```sql
CREATE TABLE scheduled_jobs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL UNIQUE,
    queue_name VARCHAR(100) NOT NULL,
    job_type VARCHAR(100) NOT NULL,
    payload JSONB NOT NULL,
    cron_expression VARCHAR(100) NOT NULL,
    timezone VARCHAR(50) DEFAULT 'UTC',
    is_active BOOLEAN DEFAULT TRUE,
    last_run TIMESTAMP WITH TIME ZONE,
    next_run TIMESTAMP WITH TIME ZONE,
    max_runs INTEGER,
    run_count INTEGER DEFAULT 0,
    created_by UUID,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Scheduled job trigger function
CREATE OR REPLACE FUNCTION schedule_recurring_jobs()
RETURNS void AS $$
DECLARE
    scheduled_job RECORD;
    next_run_time TIMESTAMP;
BEGIN
    FOR scheduled_job IN 
        SELECT * FROM scheduled_jobs 
        WHERE is_active = true 
        AND (next_run IS NULL OR next_run <= NOW())
    LOOP
        -- Create new job instance
        INSERT INTO jobs (
            queue_name, job_type, payload, run_at, 
            correlation_id, tenant_id
        ) VALUES (
            scheduled_job.queue_name,
            scheduled_job.job_type,
            scheduled_job.payload,
            NOW(),
            'scheduled_' || scheduled_job.id,
            (scheduled_job.payload->>'tenant_id')::uuid
        );
        
        -- Update schedule
        next_run_time := calculate_next_cron_run(scheduled_job.cron_expression, scheduled_job.timezone);
        
        UPDATE scheduled_jobs 
        SET 
            last_run = NOW(),
            next_run = next_run_time,
            run_count = run_count + 1
        WHERE id = scheduled_job.id;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
```

---

## 📚 **Related Documentation**

- **[Database Schema Guide](database_schema_guide.md)** - 4-tier architecture overview
- **[OLTP Schema Guide](oltp_schema_guide.md)** - Operational database
- **[Content Database Schema Guide](content_database_schema_guide.md)** - Heavy content storage
- **[OLAP Analytics Schema Guide](olap_analytics_schema_guide.md)** - Business intelligence
- **[Queue System Implementation Guide](queue_system_implementation_guide.md)** - Implementation details
- **[Analytics Architecture](analytics_architecture.md)** - Queue-driven analytics pipeline

**Keywords**: queue system, job processing, Redis, PostgreSQL, retry logic, dead letter queue, job scheduling, worker management, queue health monitoring, job reliability