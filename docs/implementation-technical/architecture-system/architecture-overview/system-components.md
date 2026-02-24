---
title: "System Components & Infrastructure"
description: "Detailed breakdown of PenguinMails architecture layers including UI, API, Infrastructure, and Database components."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

# System Components & Infrastructure

## Core System Components

### 1. User Interface Layer

#### Landing Page & Marketing Site

**Purpose**: Customer acquisition and information
**Technology**: Static site with dynamic content
**Key Features**:

- SEO-optimized content for each target segment
- Interactive pricing calculator
- Customer testimonials and case studies
- Blog and resource center

#### User Application Dashboard

**Purpose**: Primary customer interface
**Technology**: React.js with TypeScript
**Key Features**:

- Real-time infrastructure monitoring
- Campaign management and analytics
- Team and tenant management
- Billing and subscription management

#### Admin Panel

**Purpose**: Platform management and monitoring
**Technology**: React.js with administrative interface
**Key Features**:

- System health monitoring
- Customer management
- Infrastructure oversight
- Compliance reporting

### 2. API Gateway & Services

#### API Gateway

**Purpose**: Single entry point for all API requests
**Responsibilities**:

- Authentication and authorization
- Rate limiting and throttling
- Request routing to appropriate services
- Response caching and optimization
- Request/response logging and monitoring

#### Core Services Architecture

##### User Management Service

- User registration and authentication
- Profile management
- Password reset and security features
- Session management

##### Tenant Management Service

- Multi-tenant data isolation
- Tenant configuration and settings
- Resource allocation and limits
- Billing integration

##### Infrastructure Management Service

- VPS provisioning and configuration
- SMTP server setup and management
- DNS record automation
- IP pool management and routing

##### Campaign Management Service

- Email campaign creation and editing
- Contact management and segmentation
- A/B testing framework
- Performance tracking and analytics

##### Email Processing Service

- Email sending and delivery
- Bounce and complaint handling
- Unsubscribe processing
- Reply processing and threading

### 3. Infrastructure Layer

#### Email Infrastructure Specialization

##### VPS Management

```markdown
Customer Request → VPS Provisioning → SMTP Setup → DNS Configuration → Warm-up → Ready for Campaigns
      │                │                 │             │              │           │
   5 minutes        10 minutes        15 minutes    10 minutes    48 hours   Active
```

##### SMTP Server Stack

- **MailU Postfix**: Reliable email sending with anti-spam features
- **Dovecot**: Secure email storage and retrieval
- **Roundcube Webmail**: Web-based email access (optional)
- **SpamAssassin**: Advanced spam filtering and reputation management

### DNS Configuration Automation

- **SPF Records**: Email sending authorization
- **DKIM Signatures**: Email integrity verification
- **DMARC Policies**: Anti-spoofing protection
- **MX Records**: Mail server routing

#### Database Architecture

##### Primary Database (PostgreSQL)

- **User Data**: Authentication, profiles, preferences
- **Tenant Data**: Multi-tenant isolation and configuration
- **Campaign Data**: Email campaigns, contacts, analytics
- **Infrastructure Data**: VPS instances, SMTP configurations
- **Compliance Data**: Audit logs, consent records, unsubscribe lists

##### Cache Layer (Redis)

- **Session Storage**: User sessions and authentication tokens
- **Real-time Data**: Current campaign status, deliverability metrics
- **Rate Limiting**: API rate limiting and abuse prevention
- **Queue Processing**: Fast job queues for email processing and analytics aggregation
- **Temporary Data**: Processing queues, temporary calculations

### Hybrid Queue System (PostgreSQL + Redis)

- **PostgreSQL**: Durable record of truth for job state and audit trail
- **Redis**: Fast ephemeral queue processing for high-performance job execution
- **Queuer Process**: Separate service that migrates ready jobs from PostgreSQL to Redis
- **Worker Servers**: Horizontal scaling with Redis-based job consumption
- **Priority Queues**: Separate queues for high/normal/low priority jobs
- **Analytics Pipeline**: Queue-driven analytics aggregation with OLAP schema integration

### 4. External Service Integration

#### VPS Provider Integration (Hostwind)

##### Purpose

Automated VPS provisioning and management

##### Integration Method

REST API with webhooks

##### Key Features

- Geographic IP distribution for optimal deliverability
- Automatic scaling based on usage
- Dedicated IP pools per customer segment
- Real-time health monitoring and alerts

#### SMTP Provider Integration (MailU)

##### Purpose

Specialized email infrastructure

##### Integration Method

API and configuration automation

##### Key Features

- Postfix SMTP server configuration
- Dovecot IMAP/POP3 server setup
- SpamAssassin integration for deliverability
- Mail queue management and monitoring

#### Payment Processing (Stripe)

##### Purpose

Subscription billing and payment processing

##### Integration Method

Stripe API with webhooks

##### Key Features

- Flexible subscription management
- Automatic billing and dunning
- Invoice generation and management
- PCI compliance and security

#### Authentication & Database (NileDB)

##### Purpose

User authentication and data persistence

##### Integration Method

Built-in NileDB services

##### Key Features

- Secure user authentication with JWT tokens
- PostgreSQL database with automatic backups
- Row-level security for multi-tenant isolation
- Automatic scaling and high availability
