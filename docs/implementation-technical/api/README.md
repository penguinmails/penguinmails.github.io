---
title: "API Architecture Overview"
description: "Complete overview of PenguinMails API architecture: unified server, hub-and-spoke documentation, and integration patterns"
last_modified_date: "2025-11-21"
level: "1"
persona: "All Technical Stakeholders"
---

# API Architecture Overview

**For**: Developers, DevOps, Architects, Operations, Product Managers

**Purpose**: Understand the complete PenguinMails API landscape, including the unified server architecture, logical API separation, and documentation structure.

---

## 🏗️ Architecture: Unified Monolithic Server

For the MVP phase, PenguinMails uses a **monolithic API architecture**.

- **Single Server**: All APIs are served from a single **Express/Hapi** application.
- **Logical Separation**: APIs are organized by domain (Tenant, Platform, SMTP, Queue) but share the same runtime.
- **Shared Infrastructure**: Authentication, database connections, and queue clients are shared across all endpoints.
- **Deployment**: Deployed as a single unit for operational simplicity.

### Frontend Communication (BFF Pattern)

To comply with NileDB's requirement for the frontend and backend to share the same hostname, we use the **Backend-for-Frontend (BFF)** pattern:

1. **Next.js Server Actions**: Act as the BFF layer.
2. **Server-to-Server**: Server Actions communicate with the Central API Server.
3. **Security**: Authentication session is handled by NileDB SDK in the Server Actions.

```mermaid
graph TB
    subgraph "Frontend (Next.js)"
        UI[User Interface]
        SA[Server Actions (BFF)]
    end

    subgraph "Central API Server (Express/Hapi)"
        ROUTER[Main Router]
        TENANT[Tenant API<br/>/api/v1/tenant/*]
        PLATFORM[Platform API<br/>/api/v1/platform/*]
        SMTP[SMTP Admin API<br/>/api/v1/smtp/*]
        QUEUE[Queue API<br/>/api/v1/queue/*]
    end

    DB[(Database)]
    REDIS[(Redis/Queue)]

    UI --> SA
    SA -->|HTTP/Internal| ROUTER
    ROUTER --> TENANT
    ROUTER --> PLATFORM
    ROUTER --> SMTP
    ROUTER --> QUEUE

    TENANT --> DB
    PLATFORM --> DB
    SMTP --> DB
    QUEUE --> REDIS
```

---

## 📚 Documentation Structure (Hub-and-Spoke)

We use a **hub-and-spoke** pattern for documentation. Each major API domain has a "Hub" file that provides an overview and links to detailed "Spoke" files in a corresponding subdirectory.

### 1. [Tenant API](./tenant-api.md) (Hub)

**Prefix**: `/api/v1/tenant/*`
Customer-facing operations for the core application.

- [Campaigns](./tenant-api/campaigns.md)
- [Workspaces](./tenant-api/workspaces.md)
- [Templates](./tenant-api/templates.md)
- [Unified Inbox](./tenant-api/inbox.md)

### 2. [Platform API](./platform-api.md) (Hub)

**Prefix**: `/api/v1/platform/*`
Internal operations, analytics, and system administration.

- [Subscriptions & Billing](./platform-api/subscriptions.md)
- [System Analytics](./platform-api/analytics.md)
- [Admin Operations](./platform-api/admin.md)

### 3. [SMTP Admin API](./central-smtp.md) (Hub)

**Prefix**: `/api/v1/smtp/*`
Infrastructure management for email delivery.

- [IP Pools](./central-smtp/ip-pools.md)
- [Routing](./central-smtp/routing.md)
- [Warmup](./central-smtp/warmup.md)

### 4. [Queue API](./queue.md) (Hub)

**Prefix**: `/api/v1/queue/*`
Background job monitoring and event processing.

- [Events](./queue/events.md)
- [Notifications](./queue/notifications.md)
- [Job Management](./queue/jobs.md)

---

## 🔄 Post-MVP Evolution

While we start with a monolith, the logical separation allows us to evolve:

1. **Microservices**: Extracting a domain (e.g., `smtp-server`) into its own service if scaling requires it.
2. **Cloud Functions**: Moving specific heavy endpoints to serverless functions.
3. **Language Migration**: Rewriting performance-critical paths (e.g., Queue processing) in Go or Rust.

Decisions to split services will be driven by **performance metrics** and **operational needs**, not premature optimization.

---

## 🚀 Getting Started

### For Frontend Developers

1. Look up the endpoint in the relevant API Hub (e.g., `tenant-api.md`).
2. Create a **Server Action** in Next.js to consume the endpoint.
3. Use the shared API client to make the request.

### For Backend Developers

1. Identify the logical domain for your endpoint.
2. Add the route to the corresponding router module in the Express/Hapi app.
3. Document the endpoint in the appropriate "Spoke" file (create one if needed).

---

**Related Documentation**:

- [Database Schema](/docs/implementation-technical/database-infrastructure/oltp-database/schema-guide.md)
- [Queue System Implementation](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation.md)
