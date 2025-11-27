---
title: "Email Infrastructure Integration Flow"
description: "How Central SMTP, Frontend, Queue, and Tenant SMTP work together in the system architecture"
last_modified_date: "2025-11-17"
level: "2"
persona: "Documentation Users"
---


# Email Infrastructure Integration Flow

**Strategic Alignment**: This diagram demonstrates how our multi-tenant architecture seamlessly integrates central services with tenant-specific infrastructure to deliver scalable email services.

**Technical Authority**: Our infrastructure integration showcases enterprise-grade load balancing, queue management, and service mesh communication that ensures 99.9% uptime for all customers.

**User Journey Integration**: This integration flow is the foundation that enables your complete email infrastructure experience from [campaign creation](/docs/features) through [analytics tracking](/docs/features/analytics/core-analytics/overview) to [infrastructure management](/docs/features/warmup/email-warmups/overview).

---


## System Integration Overview

This diagram shows how PenguinMails architecture components interact to deliver email infrastructure services across multiple tenants while maintaining isolation and scalability.


## Central SMTP, Frontend, Queue, and Tenant SMTP Integration


```mermaid
graph TB
    %% Client Layer
    subgraph "Client Applications"
        WEB[Web Frontend<br/>React Dashboard]
        API[API Client<br/>Mobile/External]
    end

    %% Central Layer
    subgraph "Central Infrastructure"
        CENTRAL_FRONTEND[Central Frontend<br/>User Management]
        CENTRAL_API[Central API Gateway<br/>Authentication/Routing]
        CENTRAL_SMTP[Central SMTP Pool<br/>Route Management]
        CENTRAL_QUEUE[Central Queue System<br/>Redis + PostgreSQL]
    end

    %% Tenant Layer
    subgraph "Tenant Infrastructure (Per Customer)"
        TENANT_SMTP[Tenant SMTP Server<br/>MailU Stack]
        TENANT_DB[Tenant Database<br/>PostgreSQL Schema]
        TENANT_QUEUE[Tenant Queue<br/>Job Processing]
    end

    %% External Layer
    subgraph "External Services"
        MAILU[MailU SMTP Stack<br/>Postfix + Dovecot]
        HOSTWIND[Hostwind VPS<br/>Infrastructure Provisioning]
        DNS[DNS Providers<br/>SPF/DKIM/DMARC]
    end

    %% Client to Central Flow
    WEB --> CENTRAL_API
    API --> CENTRAL_API
    CENTRAL_API --> CENTRAL_FRONTEND

    %% Central Routing Logic
    CENTRAL_API --> CENTRAL_SMTP
    CENTRAL_SMTP --> CENTRAL_QUEUE
    CENTRAL_QUEUE --> TENANT_QUEUE

    %% Tenant Processing
    TENANT_QUEUE --> TENANT_SMTP
    TENANT_SMTP --> MAILU
    TENANT_SMTP --> TENANT_DB

    %% Infrastructure Provisioning
    CENTRAL_API --> HOSTWIND
    CENTRAL_SMTP --> DNS

    %% Data Flow
    TENANT_DB -.-> CENTRAL_QUEUE
    MAILU -.-> CENTRAL_QUEUE

    %% Load Balancing
    CENTRAL_SMTP -.->|Load Balance| TENANT_SMTP
    CENTRAL_QUEUE -.->|Route Jobs| TENANT_QUEUE

    classDef client fill:#e1f5fe
    classDef central fill:#f3e5f5
    classDef tenant fill:#e8f5e9
    classDef external fill:#fff3e0

    class WEB,API client
    class CENTRAL_FRONTEND,CENTRAL_API,CENTRAL_SMTP,CENTRAL_QUEUE central
    class TENANT_SMTP,TENANT_DB,TENANT_QUEUE tenant
    class MAILU,HOSTWIND,DNS external


```


## Integration Architecture Explanation


### **Client Layer**


- **Web Frontend**: React-based dashboard for campaign management and monitoring


- **API Client**: External integrations and mobile applications


### **Central Infrastructure**


- **Central Frontend**: User management and authentication services


- **Central API Gateway**: Routes requests, handles authentication, and manages rate limiting


- **Central SMTP Pool**: Manages SMTP connections and load balancing across tenants


- **Central Queue System**: Redis + PostgreSQL hybrid for job processing and state management


### **Tenant Infrastructure (Per Customer)**


- **Tenant SMTP Server**: MailU stack with Postfix, Dovecot, and SpamAssassin


- **Tenant Database**: PostgreSQL schema with row-level security for data isolation


- **Tenant Queue**: Dedicated job processing for tenant-specific operations


### **External Services**


- **MailU SMTP Stack**: Enterprise email delivery infrastructure


- **Hostwind VPS**: Automated VPS provisioning and management


- **DNS Providers**: SPF, DKIM, DMARC record management


## Key Integration Patterns


### 1. **Multi-Tenant Routing**

The Central API Gateway authenticates users and routes requests to their specific tenant infrastructure, ensuring complete data isolation while maintaining operational efficiency.


### 2. **Load Balancing Strategy**

The Central SMTP Pool intelligently distributes email sending across available tenant SMTP servers, optimizing for deliverability and avoiding overloading individual accounts.


### 3. **Queue Processing**

Central Queue System coordinates with Tenant Queues to process email jobs, ensuring scalable job distribution while maintaining tenant isolation.


### 4. **Infrastructure Automation**

Central services coordinate with external providers (Hostwind, DNS) to automatically provision and configure tenant-specific infrastructure.


### 5. **Data Flow Coordination**

Real-time data synchronization between tenant databases and central systems enables consistent analytics and monitoring across the platform.

---

**Keywords**: email infrastructure, multi-tenant architecture, SMTP integration, queue processing, load balancing, infrastructure automation
