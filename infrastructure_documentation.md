---
last_modified_date: "2025-10-27"
---

# Infrastructure Documentation

---

## Quick Navigation
- [🏠 **Main Overview**](README.md) | [Setup **Architecture**](architecture_overview.md) | [🔒 **Security**](security_documentation.md)

---

## Overview

This document provides detailed infrastructure diagrams and operational procedures for the PenguinMails multi-tenant SaaS platform. It serves as a reference for development, deployment, and troubleshooting.

### Architecture Summary
- **Multi-tenant SaaS**: Isolated tenant data with shared infrastructure
- **Email Infrastructure**: Hostwinds VPS provisioning with MailU SMTP orchestration and secondary IP management
- **Database**: NileDB (PostgreSQL + authentication) + Analytics (Postgres)
- **Real-time Analytics**: PostHog for live tracking and user behavior
- **Frontend**: Next.js dashboard and admin panel
- **Landing Page**: WordPress-based marketing site

**Technical Constraints:**
- Database scaling requirements (1K → 10K → 100K+ tenants)
- Performance requirements (< 2 second dashboard load time)
- Multi-tenant security (zero data leakage between tenants)
- Email deliverability challenges (< 5% bounce rate targets)
- Hostwinds infrastructure limits (no traditional IP pools, VPS resource constraints)
- Subscription-based resource allocation (infrastructure costs must align with revenue)

**For detailed technical analysis covering database architecture, performance constraints, and scaling requirements, see the roadmap technical implementation details.**

---

## System Architecture Diagrams

### Overall System Architecture

```mermaid
graph TB
    %% Frontend Layer
    subgraph "Frontend Layer"
        WP[WordPress Landing Page]
        DASH[Next.js Dashboard]
        ADMIN[Next.js Admin Panel]
    end

    %% API Gateway
    subgraph "API Layer"
        API[Central API Gateway]
        QUEUE[Redis Queue System]
    end

    %% Application Layer
    subgraph "Application Core"
        AUTH[NileDB Auth]
        TENANT[Tenant Management]
        BILL[Billing Engine]
        EMAIL[Email Service]
    end

    %% Infrastructure Layer
    subgraph "Infrastructure Layer"
        HOST[Hostwind VPS]
        SMTP[SMTP Service]
        DOMAIN[Domain Manager]
        WARMUP[Email Warm-up Engine]
    end

    %% External Services
    subgraph "External Services"
        STRIPE[Stripe Payments]
        LOOP[Loop Emails]
        DNS[DNS Provider]
    end

    %% Connections
    WP --> API
    DASH --> API
    ADMIN --> API
    
    API --> AUTH
    API --> TENANT
    API --> BILL
    API --> EMAIL
    
    EMAIL --> QUEUE
    QUEUE --> SMTP
    EMAIL --> WARMUP
    
    SMTP --> HOST
    DOMAIN --> HOST
    WARMUP --> HOST
    
    BILL --> STRIPE
    AUTH --> LOOP
    
    DOMAIN --> DNS

    %% Styling
    classDef frontend fill:#e1f5fe
    classDef api fill:#f3e5f5
    classDef app fill:#e8f5e8
    classDef infra fill:#fff3e0
    classDef external fill:#fce4ec

    class WP,DASH,ADMIN frontend
    class API,QUEUE api
    class AUTH,TENANT,BILL,EMAIL app
    class HOST,SMTP,DOMAIN,WARMUP infra
    class STRIPE,LOOP,DNS external
```

### Multi-Tenant Database Schema

```mermaid
erDiagram
    %% Core Tenant Structure
    TENANTS {
        bigint id PK
        uuid tenant_id UK
        varchar name
        varchar domain
        jsonb settings
        timestamp created_at
        timestamp updated_at
    }

    %% User Management
    USERS {
        bigint id PK
        uuid user_id UK
        bigint tenant_id FK
        varchar email
        varchar password_hash
        varchar role
        timestamp created_at
        timestamp updated_at
    }

    TENANT_USERS {
        bigint id PK
        bigint tenant_id FK
        bigint user_id FK
        varchar permission_level
        timestamp joined_at
    }

    %% Staff Management
    STAFF_MEMBERS {
        bigint id PK
        bigint tenant_id FK
        varchar name
        varchar email
        varchar position
        boolean is_active
        timestamp created_at
    }

    STAFF_ROLES {
        bigint id PK
        bigint tenant_id FK
        varchar role_name
        jsonb permissions
        timestamp created_at
    }

    %% Infrastructure
    VPS_INSTANCES {
        bigint id PK
        bigint tenant_id FK
        varchar instance_id
        varchar ip_address
        varchar status
        jsonb configuration
        timestamp created_at
    }

    SMTP_IP_ADDRESSES {
        bigint id PK
        bigint tenant_id FK
        varchar ip_address
        varchar status
        integer reputation_score
        timestamp created_at
    }

    DOMAINS {
        bigint id PK
        bigint tenant_id FK
        varchar domain_name
        varchar verification_status
        jsonb dns_records
        timestamp created_at
    }

    %% Email Management
    EMAIL_ACCOUNTS {
        bigint id PK
        bigint tenant_id FK
        varchar email_address
        varchar password
        varchar status
        timestamp created_at
    }

    TEMPLATES {
        bigint id PK
        bigint tenant_id FK
        varchar template_name
        text content
        jsonb variables
        timestamp created_at
    }

    CAMPAIGNS {
        bigint id PK
        bigint tenant_id FK
        varchar campaign_name
        varchar status
        jsonb configuration
        timestamp created_at
    }

    LEADS {
        bigint id PK
        bigint tenant_id FK
        varchar email
        jsonb metadata
        timestamp imported_at
    }

    %% Business Logic
    PLANS {
        bigint id PK
        varchar plan_name
        decimal price
        jsonb features
        timestamp created_at
    }

    SUBSCRIPTIONS {
        bigint id PK
        bigint tenant_id FK
        bigint plan_id FK
        varchar status
        timestamp started_at
        timestamp expires_at
    }

    PAYMENTS {
        bigint id PK
        bigint tenant_id FK
        varchar stripe_payment_id
        decimal amount
        varchar status
        timestamp paid_at
    }

    %% Relationships
    TENANTS ||--o{ USERS : contains
    TENANTS ||--o{ TENANT_USERS : has
    USERS ||--o{ TENANT_USERS : assigned_to
    TENANTS ||--o{ STAFF_MEMBERS : employs
    TENANTS ||--o{ STAFF_ROLES : defines
    TENANTS ||--o{ VPS_INSTANCES : provisions
    TENANTS ||--o{ SMTP_IP_ADDRESSES : owns
    TENANTS ||--o{ DOMAINS : manages
    TENANTS ||--o{ EMAIL_ACCOUNTS : creates
    TENANTS ||--o{ TEMPLATES : owns
    TENANTS ||--o{ CAMPAIGNS : runs
    TENANTS ||--o{ LEADS : imports
    TENANTS ||--o{ SUBSCRIPTIONS : has
    PLANS ||--o{ SUBSCRIPTIONS : defines
    SUBSCRIPTIONS ||--o{ PAYMENTS : generates
```

### Email Infrastructure Flow

```mermaid
flowchart TB
    %% Campaign Creation
    subgraph "Campaign Management"
        CREATE[Create Campaign]
        SELECT[Select Template]
        UPLOAD[Upload Leads]
        SCHEDULE[Schedule Send]
    end

    %% Queue Processing
    subgraph "Queue System"
        QUEUE_ENGINE[Redis Queue Engine]
        PRIORITY[Priority Queue]
        RETRY[Retry Logic]
    end

    %% SMTP Infrastructure
    subgraph "SMTP Layer"
        SMTP_POOL[SMTP Connection Pool]
        ROUND_ROBIN[Round Robin Load Balancer]
        HEALTH_CHECK[Health Monitoring]
    end

    %% Email Sending
    subgraph "Sending Process"
        AUTH_SMTP[SMTP Authentication]
        SEND_EMAIL[Send Email]
        TRACK_OPEN[Track Opens]
        TRACK_CLICK[Track Clicks]
    end

    %% Warm-up System
    subgraph "Warm-up Engine"
        WARMUP_QUEUE[Warm-up Queue]
        REPUTATION[Reputation Monitor]
        VOLUME_CONTROL[Volume Control]
    end

    %% Feedback Loop
    subgraph "Feedback Processing"
        BOUNCE[Handle Bounces]
        COMPLAINT[Handle Complaints]
        BLACKLIST[Update Blacklists]
    end

    %% Data Flow
    CREATE --> SCHEDULE
    SELECT --> UPLOAD
    UPLOAD --> QUEUE_ENGINE
    SCHEDULE --> QUEUE_ENGINE
    
    QUEUE_ENGINE --> PRIORITY
    PRIORITY --> SMTP_POOL
    SMTP_POOL --> ROUND_ROBIN
    ROUND_ROBIN --> AUTH_SMTP
    
    AUTH_SMTP --> SEND_EMAIL
    SEND_EMAIL --> TRACK_OPEN
    SEND_EMAIL --> TRACK_CLICK
    
    WARMUP_QUEUE --> SMTP_POOL
    REPUTATION --> HEALTH_CHECK
    VOLUME_CONTROL --> PRIORITY
    
    SEND_EMAIL --> BOUNCE
    SEND_EMAIL --> COMPLAINT
    BOUNCE --> BLACKLIST
    COMPLAINT --> BLACKLIST

    %% Styling
    classDef campaign fill:#e3f2fd
    classDef queue fill:#f3e5f5
    classDef smtp fill:#e8f5e8
    classDef sending fill:#fff3e0
    classDef warmup fill:#fce4ec
    classDef feedback fill:#ffebee

    class CREATE,SELECT,UPLOAD,SCHEDULE campaign
    class QUEUE_ENGINE,PRIORITY,RETRY queue
    class SMTP_POOL,ROUND_ROBIN,HEALTH_CHECK smtp
    class AUTH_SMTP,SEND_EMAIL,TRACK_OPEN,TRACK_CLICK sending
    class WARMUP_QUEUE,REPUTATION,VOLUME_CONTROL warmup
    class BOUNCE,COMPLAINT,BLACKLIST feedback
```

### Deployment Pipeline

```mermaid
flowchart LR
    %% Development
    subgraph "Development"
        DEV_CODE[Code Changes]
        DEV_TEST[Local Testing]
        DEV_DB[Local Docker DB]
    end

    %% Staging
    subgraph "Staging"
        STAGING_DEPLOY[Staging Deploy]
        STAGING_TEST[Integration Testing]
        STAGING_DB[Staging DB]
        QA_TEST[QA Testing]
    end

    %% Production
    subgraph "Production"
        PROD_DEPLOY[Production Deploy]
        PROD_MONITOR[Production Monitoring]
        PROD_DB[Production DB]
    end

    %% Migration Process
    subgraph "Database Migration"
        MIGRATION_SCRIPT[Migration Script]
        BACKUP[Backup Creation]
        VALIDATE[Validation]
    end

    %% CI/CD Pipeline
    subgraph "CI/CD Pipeline"
        GITHUB[GitHub Push]
        BUILD[Build Process]
        TEST[Automated Tests]
        DEPLOY[Deploy Pipeline]
    end

    %% Flow
    DEV_CODE --> DEV_TEST
    DEV_TEST --> GITHUB
    GITHUB --> BUILD
    BUILD --> TEST
    TEST --> DEV_DB
    
    TEST --> STAGING_DEPLOY
    STAGING_DEPLOY --> STAGING_TEST
    STAGING_TEST --> STAGING_DB
    STAGING_TEST --> QA_TEST
    
    QA_TEST --> MIGRATION_SCRIPT
    MIGRATION_SCRIPT --> BACKUP
    BACKUP --> VALIDATE
    VALIDATE --> PROD_DEPLOY
    
    PROD_DEPLOY --> PROD_MONITOR
    PROD_MONITOR --> PROD_DB

    %% Authorization
    DEV_CODE -.->|Migration Access| MIGRATION_SCRIPT

    %% Styling
    classDef dev fill:#e8f5e8
    classDef staging fill:#fff3e0
    classDef prod fill:#ffebee
    classDef migration fill:#f3e5f5
    classDef cicd fill:#e1f5fe

    class DEV_CODE,DEV_TEST,DEV_DB dev
    class STAGING_DEPLOY,STAGING_TEST,STAGING_DB,QA_TEST staging
    class PROD_DEPLOY,PROD_MONITOR,PROD_DB prod
    class MIGRATION_SCRIPT,BACKUP,VALIDATE migration
    class GITHUB,BUILD,TEST,DEPLOY cicd
```

---

## Infrastructure Components

### 1. VPS Management (Hostwinds)

#### Hostwinds Architecture Constraints
- **No Traditional IP Pools**: Hostwinds does not offer traditional IP pools - IPs are acquired as secondary IPs assigned to specific VPS instances
- **IP Allocation Tied to VPS**: Each IP purchase is independent with individual confirmation timelines and tied to VPS resource limits
- **Geographic Constraints**: IP allocation considers VPS instance geographic location and resource availability

#### Provisioning Process
1. **Request Initiation**: API call to Hostwinds API for VPS creation
2. **Resource Allocation**: CPU, RAM, storage assignment based on subscription tier requirements
3. **Configuration**: Operating system, Docker, and base software installation
4. **Network Setup**: Primary IP assignment, firewall configuration, and security groups
5. **MailU Setup**: SMTP container orchestration and multi-IP configuration
6. **Monitoring Integration**: Infrastructure health checks and performance monitoring

#### Management Operations
- **Scaling**: Vertical scaling within Hostwinds limits, horizontal scaling through additional VPS instances
- **IP Management**: Secondary IP acquisition, assignment, and reputation monitoring
- **Resource Monitoring**: CPU, memory, disk usage with subscription-based thresholds
- **Backups**: Automated daily backups with retention policies
- **Security**: Firewall rules, access controls, and incident response procedures
- **Cost Tracking**: Infrastructure cost monitoring against subscription revenue

#### Subscription-Based Resource Allocation
- **Tier Mapping**: Different subscription plans require different VPS specifications and IP allocations
- **Cost Control**: Infrastructure costs must not exceed subscription revenue
- **Grace Period Management**: Handle unpaid subscriptions without immediate service disruption
- **Scalability**: Support growing customer base without proportional cost increases

### 2. SMTP Infrastructure (Mailu)

#### Configuration
```yaml
# Mailu Configuration Example
mailu_1_7:
  version: "1.7"
  services:
    - front
    - nginx
    - admin
    - imap
    - pop3
    - smtp
    - antispam
    - antivirus
  hostnames:
    - mail.penguinmails.com
  maildir_path: /mail
  lets_encrypt: true
  tls_enabled: true
  dkim_selector: mailu
  default_language: en
```

#### SMTP Features
- **Authentication**: User authentication and session management
- **Queuing**: Outgoing email queue management
- **Anti-spam**: Built-in spam filtering and blacklisting
- **Anti-virus**: Virus scanning for incoming/outgoing emails
- **Relay Control**: SMTP relay permissions and restrictions

### 3. Database Layer (NileDB)

#### Connection Management
```javascript
// Database Connection Example
const db = new NileDB({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: 5432,
  ssl: process.env.NODE_ENV === 'production'
});
```

#### Multi-Tenant Data Isolation
- **Schema per Tenant**: Each tenant maintains isolated data schemas
- **Row Level Security**: Database-level access controls
- **Connection Pooling**: Optimized database connection management
- **Query Optimization**: Indexed queries for multi-tenant performance

### 4. Queue System (Redis)

#### Queue Configuration (Hybrid PostgreSQL + Redis)
```javascript
// Redis Queue Setup (Fast Processing Layer)
const queue = new Queue('emailQueue', {
  redis: {
    host: 'redis.penguinmails.com',
    port: 6379,
    password: process.env.REDIS_PASSWORD
  },
  defaultJobOptions: {
    removeOnComplete: 100,
    removeOnFail: 50,
    attempts: 3,
    backoff: {
      type: 'exponential',
      delay: 2000
    }
  }
});

// PostgreSQL Job Management (Durable State)
const jobManager = new JobManager({
  database: {
    host: 'postgres.penguinmails.com',
    port: 5432,
    database: 'penguinmails',
    user: 'job_user',
    password: process.env.DB_PASSWORD
  }
});
```

#### Hybrid Queue Architecture

**A. Producer Pattern (Next.js API):**
```javascript
// API creates job in PostgreSQL
const job = await db.jobs.create({
  data: {
    queue_name: 'email-sending',
    payload: { campaign_id, lead_id, email_data },
    priority: 100,
    run_at: new Date()
  }
});

// Optional: Immediate push to Redis for urgent jobs
if (job.priority < 50) {
  await redis.lpush('queue:email-sending:high', JSON.stringify({
    id: job.id,
    payload: job.payload,
    priority: job.priority
  }));
}
```

**B. Queuer Process (Migration Service):**
```javascript
// Separate service that migrates PostgreSQL jobs to Redis
class JobMigrator {
  async migrateReadyJobs() {
    const jobs = await db.jobs.findMany({
      where: {
        status: 'queued',
        run_at: { lte: new Date() }
      },
      orderBy: [
        { priority: 'asc' },
        { created_at: 'asc' }
      ],
      take: 100 // Batch process
    });

    for (const job of jobs) {
      const queueName = this.getQueueName(job);
      const redisPayload = {
        id: job.id,
        queue_name: job.queue_name,
        priority: job.priority,
        payload: job.payload
      };
      
      // Push to Redis with priority routing
      await redis.lpush(queueName, JSON.stringify(redisPayload));
      
      // Update PostgreSQL status
      await db.jobs.update({
        where: { id: job.id },
        data: { status: 'migrated_to_redis' }
      });
    }
  }
  
  getQueueName(job) {
    if (job.priority <= 50) return 'queue:email-sending:high';
    if (job.priority <= 150) return 'queue:email-sending';
    return 'queue:email-sending:low';
  }
}
```

**C. Consumer Pattern (Worker Servers):**
```javascript
// Worker server listens only to Redis
class Worker {
  constructor() {
    this.redis = new Redis(process.env.REDIS_URL);
  }
  
  async start() {
    // Listen to all priority queues
    const queues = [
      'queue:email-sending:high',
      'queue:email-sending',
      'queue:email-sending:low'
    ];
    
    while (true) {
      try {
        // Blocking pop with priority ordering
        const result = await this.redis.brpop(queues, 0);
        const [queueName, jobData] = result;
        
        await this.processJob(JSON.parse(jobData), queueName);
      } catch (error) {
        console.error('Worker error:', error);
        await this.delay(1000);
      }
    }
  }
  
  async processJob(jobData, queueName) {
    const { id, payload, priority } = jobData;
    
    try {
      // Update PostgreSQL status
      await db.jobs.update({
        where: { id },
        data: {
          status: 'running',
          started_at: new Date(),
          updated_at: new Date()
        }
      });
      
      // Update Redis hash for real-time tracking
      await this.redis.hset(`job:${id}`, {
        status: 'processing',
        worker_id: process.env.WORKER_ID,
        started_at: new Date().toISOString()
      });
      
      // Execute the job
      await this.executeEmailJob(payload);
      
      // Update completion status
      await db.jobs.update({
        where: { id },
        data: {
          status: 'completed',
          completed_at: new Date(),
          updated_at: new Date()
        }
      });
      
      await this.redis.hset(`job:${id}`, {
        status: 'completed',
        completed_at: new Date().toISOString()
      });
      
    } catch (error) {
      // Handle failure
      await this.handleJobFailure(id, error);
    }
  }
}
```

#### Queue Processing Benefits
- **Performance**: Redis provides microsecond job retrieval vs millisecond PostgreSQL queries
- **Reliability**: PostgreSQL ensures no job loss if workers or Redis crash
- **Scalability**: Multiple worker servers can consume from same Redis queues
- **Monitoring**: Redis provides real-time queue depth metrics
- **Priority Queues**: Separate Redis lists for high/normal/low priority jobs
- **Retry Logic**: Automatic retry with exponential backoff via Redis delayed jobs

---

## Environment Configuration

### Development Environment
```yaml
# docker-compose.yml
version: '3.8'
services:
  database:
    image: postgres:13
    environment:
      POSTGRES_DB: penguinmails_dev
      POSTGRES_USER: dev_user
      POSTGRES_PASSWORD: dev_password
    ports:
      - "5432:5432"
  
  redis:
    image: redis:6-alpine
    ports:
      - "6379:6379"
  
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      NODE_ENV: development
      DATABASE_URL: postgresql://dev_user:dev_password@database:5432/penguinmails_dev
    depends_on:
      - database
      - redis
```

### Production Environment Variables
```bash
# Production Environment
NODE_ENV=production
DATABASE_URL=postgresql://prod_user:${DB_PASSWORD}@prod-db.penguinmails.com:5432/penguinmails
REDIS_URL=redis://prod-redis.penguinmails.com:6379
HOSTWIND_API_KEY=${HOSTWIND_API_KEY}
STRIPE_SECRET_KEY=${STRIPE_SECRET_KEY}
STRIPE_WEBHOOK_SECRET=${STRIPE_WEBHOOK_SECRET}
LOOP_API_KEY=${LOOP_API_KEY}
```

---

## Monitoring and Alerts

### Health Check Endpoints
- **Application Health**: `/health` - Basic application status
- **Database Health**: `/health/db` - Database connectivity check
- **Queue Health**: `/health/queue` - Redis and queue system status
- **Email Infrastructure**: `/health/email` - SMTP service connectivity

### Key Metrics
- **System Performance**: CPU, memory, disk usage
- **Database Performance**: Query execution time, connection count
- **Email Delivery**: Send rates, bounce rates, complaint rates
- **Queue Status**: Processing time, failure rates, queue depth

### Alert Conditions
- **High Error Rate**: >5% error rate over 5 minutes
- **Queue Backlog**: >1000 jobs waiting for >10 minutes
- **Database Performance**: Query time >2 seconds
- **Email Delivery**: Bounce rate >15%

---

## Troubleshooting Guide

### Common Issues

#### Database Connection Issues
1. **Check connection string**: Verify environment variables
2. **Test connectivity**: Use database client to test connection
3. **Check SSL requirements**: Ensure SSL is properly configured
4. **Review connection pool**: Monitor pool exhaustion

#### Email Delivery Issues
1. **Check SMTP credentials**: Verify username and password
2. **Review DNS settings**: Ensure SPF, DKIM, DMARC records
3. **Monitor IP reputation**: Check sender score and blacklists
4. **Test warm-up status**: Verify email warm-up progress

#### Queue Processing Issues
1. **Check Redis connectivity**: Verify connection to Redis server
2. **Monitor worker processes**: Ensure workers are running
3. **Review job processing**: Check for stuck or failed jobs
4. **Scale workers**: Increase worker count if needed

---

## Maintenance Procedures

### Regular Maintenance
- **Daily**: Health checks, error log review, queue monitoring
- **Weekly**: Performance metrics review, capacity planning
- **Monthly**: Security updates, dependency updates, backup verification
- **Quarterly**: Infrastructure review, cost optimization, disaster recovery testing

### Emergency Procedures
- **System Outage**: Activate incident response team, implement rollback, assess infrastructure impact
- **Data Breach**: Immediate containment, user notification, forensics, infrastructure security review
- **Performance Degradation**: Scale resources, optimize queries, cache tuning, infrastructure capacity review
- **Security Incident**: Block affected systems, update security measures, infrastructure compromise assessment
- **VPS Compromise**: Immediate isolation, IP reputation assessment, migration to clean infrastructure
- **IP Reputation Crisis**: Emergency IP migration, reputation recovery procedures, customer communication
- **Infrastructure Failure**: Backup system activation, failover procedures, service restoration protocols

---

*For technical support or infrastructure questions, contact the designated infrastructure team members.*
