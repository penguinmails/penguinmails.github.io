---
title: "Unified Analytics Views & Experience Design"
description: "High-level guide to analytics capabilities, referencing detailed route specifications"
last_modified_date: "2025-11-21"
level: "2"
persona: "Product Designers & Developers"
---

# Unified Analytics Views & Experience Design

**Purpose**: This document serves as the high-level guide to the analytics capabilities of PenguinMails. It bridges the gap between the routing structure and the detailed technical specifications.

> **Note**: For the complete routing map, see [Frontend Routing Map](../../../design/frontend-routing-map.md).
> For detailed technical implementation (RBAC, Stack), see [Technical Implementation](../../../implementation-technical/analytics-integration/technical-implementation.md).

---

## 1. View Categories & Specifications

The application's analytics views are divided into three primary categories based on the user persona.

### 1.1 Internal Command Center

*Restricted access for PenguinMails employees (Admin, Ops, Exec).*

* **Executive Dashboard ("The Pulse")**: High-level business health (MRR, Growth, Churn).
* **Operations Monitor ("The Watchtower")**: System reliability, queues, and infrastructure health.
* **Product Insights**: Feature adoption and user journey analysis.

👉 **[View Detailed Internal Specs](specs/internal-views.md)**

### 1.2 Customer Workspaces

*The core product experience for paying users (Tenants, Agencies).*

* **Campaign Performance**: Deep dive into email engagement (Sent, Opened, Clicked).
* **Agency Command Center**: Multi-tenant management for agencies.
* **Client Report Portal**: White-label views for agency clients.

👉 **[View Detailed Customer Specs](specs/customer-views.md)**

### 1.3 Stakeholder & Public

*Public or semi-public access.*

* **System Status Page**: Public transparency during outages.
* **Investor Briefing Room**: Secure, high-level metrics for board members.

👉 **[View Detailed Public Specs](specs/public-views.md)**

---

## 2. Integration with Routing Map

These analytics views are mapped directly to the frontend routing structure defined in `frontend-routing-map.md`.

| Analytics View | Route Path | Role |
|---|---|---|
| **Executive Pulse** | `/dashboard` | Super Admin |
| **Ops Watchtower** | `/dashboard` | Admin |
| **Campaign Stats** | `/dashboard/workspaces/[slug]/campaigns/[id]` | Tenant, Agency |
| **Agency Command** | `/dashboard/workspaces` | Agency |
| **Status Page** | `/status` | Public |

---

## 3. Design Philosophy

* **Single Application**: One Next.js application serves all user types.
* **Role-Based Rendering**: The `/dashboard` route is a smart traffic controller that renders the appropriate view based on the user's primary role.
* **Progressive Disclosure**: High-level metrics are shown first; deep dives are available via click-throughs.
