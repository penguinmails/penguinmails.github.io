---
title: "Queue API - Overview"
description: "Hub for Queue and Event API endpoints: System Events, Notifications, and Job Management"
last_modified_date: "2025-11-21"
level: "2"
persona: "Backend Developers, Frontend Developers"
---

# Queue API

**Server**: Central Monolithic Server  
**URL Prefix**: `/api/v1/queue/*`  
**Purpose**: System event processing, notification feeds, and background job monitoring.

---

## Overview

The Queue API handles asynchronous system events and provides notification feeds for operational monitoring. It aligns with the [Queue System Implementation](/docs/implementation-technical/architecture/detailed-technical/queue-system-implementation.md).

---

## Endpoint Categories

### 1. Event Processing

**Documentation**: [Events API](./queue/events.md)

Publish system events for processing and notification generation.

**Key Endpoints**:

- `POST /api/v1/queue/events` - Publish system event

### 2. Notifications

**Documentation**: [Notifications API](./queue/notifications.md)

Retrieve and manage system notifications.

**Key Endpoints**:

- `GET /api/v1/queue/notifications` - Notification feed
- `POST /api/v1/queue/notifications/{id}/reviewed` - Mark reviewed

### 3. Job Management

**Documentation**: [Jobs API](./queue/jobs.md)

Monitor and manage background jobs (Hybrid PostgreSQL + Redis).

---

## Authentication

**Headers**:

- `Authorization`: Bearer token

**Roles**:

- Event Producers: `system:publish` scope
- Notification Consumers: All user roles (scoped to their access level)
