---
title: "High-Level Architecture Overview"
nav_order: 1
nav_exclude: false
description: "System design and technical overview for decision makers"
---

# High-Level Architecture Overview

## Executive Summary

PenguinMails is built on a modern **multi-tenant, microservices architecture** designed specifically for cold email infrastructure management. The system combines automated infrastructure provisioning, real-time deliverability monitoring, and intelligent campaign management in a unified platform.

### Key Architectural Decisions
- **Multi-tenant by design**: Each customer (tenant) gets complete data isolation while sharing efficient infrastructure
- **Email infrastructure specialization**: Built specifically for cold email deliverability, not general email marketing
- **Automation-first approach**: Minimize manual operations through intelligent automation
- **Compliance built-in**: GDPR, CAN-SPAM, and international compliance as core architecture features
- **Real-time monitoring**: Continuous monitoring of deliverability, performance, and system health

---

## Core System Components

### 1. Infrastructure Layer
**Email Infrastructure Specialization:**
- **VPS Management**: Automated provisioning via Hostwind API
- **SMTP Server Stack**: MailU Postfix with Dovecot, SpamAssassin integration
- **DNS Configuration**: Automated SPF, DKIM, DMARC records with validation

### 2. Database Architecture
**Primary Database (PostgreSQL)**
- **User Data**: Authentication, profiles, preferences
- **Tenant Data**: Multi-tenant isolation and configuration
- **Campaign Data**: Email campaigns, contacts, analytics
- **Infrastructure Data**: VPS instances, SMTP configurations
- **Compliance Data**: Audit logs, consent records, unsubscribe lists

**Cache Layer (Redis)**
- **Session Storage**: User sessions and authentication tokens
- **Real-time Data**: Current campaign status, deliverability metrics
- **Rate Limiting**: API rate limiting and abuse prevention
- **Queue Processing**: Fast job queues for email processing and analytics aggregation

### 3. Multi-Tenant Architecture
**Tenant Isolation Strategy**
- **Data Isolation**: Each tenant has dedicated database schemas with row-level security
- **Infrastructure Isolation**: Dedicated SMTP servers per tenant (enterprise tier)
- **Security Isolation**: Tenant-specific authentication domains and API keys

---

## System Architecture Diagram

```
                    ┌─────────────────────────────────────────────────────────────┐
                    │                    PENGUINMAILS PLATFORM                    │
                    └─────────────────────────────────────────────────────────────┘
                                             │
                    ┌────────────────────────┼────────────────────────┐
                    │                        │                        │
         ┌──────────▼──────────┐  ┌──────────▼──────────┐  ┌────────▼────────┐
         │   USER INTERFACE    │  │    API GATEWAY      │  │  EXTERNAL       │
         │                     │  │                     │  │  SERVICES       │
         │ • Landing Page      │  │ • Authentication    │  │                 │
         │ • User Dashboard    │  │ • Rate Limiting     │  │ • Hostwind VPS  │
         │ • Admin Panel       │  │ • Load Balancing    │  │ • MailU SMTP    │
         │ • Knowledge Base    │  │ • Request Routing   │  │ • Stripe        │
         │                     │  │                     │  │ • NileDB        │
         └──────────┬──────────┘  └──────────┬──────────┘  └────────┬────────┘
                    │                        │                      │
                    └─────────────┬──────────┼──────────────────────┘
                                  │          │
                    ┌─────────────▼───────────▼─────────────────┐
                    │               CORE SERVICES                │
                    │                                             │
                    │ • User Management        • Campaign Engine │
                    │ • Tenant Management      • Email Processor │
                    │ • Infrastructure Mgmt    • Analytics       │
                    │ • Billing & Subscriptions• Notifications    │
                    │                                             │
                    └─────────────┬─────────────────────────────┘
                                  │
                    ┌─────────────▼─────────────────────────────┐
                    │           INFRASTRUCTURE LAYER            │
                    │                                             │
                    │ • VPS Management      • DNS Configuration │
                    │ • SMTP Servers       • IP Pool Management │
                    │ • Database (PostgreSQL) • Monitoring     │
                    │ • Cache (Redis)      • Backup Systems    │
                    │                                             │
                    └─────────────────────────────────────────────┘
```

---

## Performance & Scalability

### Performance Targets
- **API Response Time**: <200ms for 95% of requests
- **Dashboard Load Time**: <3 seconds for initial load
- **Infrastructure Provisioning**: <30 minutes for complete setup
- **Email Delivery**: <1 minute for 95% of emails
- **System Uptime**: 99.9% availability target

### Scalability Approach
**Horizontal Scaling**
- Microservices architecture supports independent scaling
- Database read replicas for high-traffic queries
- Load balancing across multiple instances

**Vertical Scaling**
- VPS instances scale CPU, memory, and storage
- Database scaling with read/write separation
- Caching layers reduce database load

---

## Security Architecture

### Security Layers
**1. Authentication & Authorization**
- Multi-factor authentication support
- JWT-based session management
- Role-based access control (RBAC)

**2. Data Protection**
- Encryption at rest (AES-256)
- Encryption in transit (TLS 1.3)
- PII data anonymization and masking

**3. Email Security**
- DKIM signing for email integrity
- SPF records for sending authorization
- DMARC policies for anti-spoofing

### Compliance Framework
**GDPR Compliance**
- Data minimization and purpose limitation
- Right to be forgotten implementation
- Consent management and audit trails

**CAN-SPAM Compliance**
- Automatic unsubscribe link inclusion
- Accurate header information
- Honor unsubscribe requests within 10 days

---

## Technology Stack

### Frontend Technologies
- **React.js**: Component-based UI framework with TypeScript
- **Tailwind CSS**: Utility-first CSS framework for rapid development
- **Chart.js**: Data visualization and analytics charts

### Backend Technologies
- **Node.js**: JavaScript runtime for API development
- **Express.js**: Web application framework
- **PostgreSQL**: Primary database for data persistence
- **Redis**: Caching and session storage

### Email Infrastructure
- **Postfix**: SMTP server for reliable email delivery
- **Dovecot**: IMAP/POP3 server for email storage
- **SpamAssassin**: Spam filtering and reputation management

---

*This architecture overview is designed to provide both strategic context and technical detail. For questions about specific architectural decisions or to propose changes, please contact the Engineering Lead.*