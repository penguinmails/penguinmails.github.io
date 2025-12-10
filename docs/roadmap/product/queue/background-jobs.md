---
title: "Background Jobs System"
description: "System for asynchronous task processing"
last_modified_date: "2025-12-09"
level: "3"
persona: "Technical Teams"
parent: "/docs/roadmap/product/queue/README.md"
---

# Background Jobs System

## Overview

**Status**: ACTIVE (Production-Ready)

**Description**:
Robust background job system for campaign processing, data imports/exports, webhooks, and maintenance tasks.

## Job Types

- **email.send**: High concurrency email sending
- **campaign.process**: Campaign execution steps
- **import.contacts**: Bulk contact imports
- **export.data**: Analytics data exports
- **webhook.dispatch**: Webhook notifications
- **maintenance.cleanup**: Data cleanup tasks

## Capabilities

- Priority-based processing
- Graceful shutdown
- Stalled job detection
- Idempotent design
- Queue monitoring
