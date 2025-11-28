---
title: "Tenant SMTP API - Overview"
description: "Hub for Tenant SMTP Configuration: Domains, Verification, and Health"
last_modified_date: "2025-11-21"
level: "2"
persona: "Backend Developers, Frontend Developers"
---


# Tenant SMTP API

**Server**: Central Monolithic Server
**URL Prefix**: `/api/v1/tenant/smtp/*`
**Purpose**: Tenant-scoped SMTP configuration and deliverability metrics.

---

## Overview

The Tenant SMTP API allows tenants to manage their sending domains and view their specific deliverability performance.

---

## Endpoint Categories

### 1. Domain Management

**Documentation**: [Domains API](/docs/implementation-technical/api/tenant-smtp/domains)

Manage sending domains and DNS verification.

**Key Endpoints**:

- `GET /api/v1/tenant/smtp/config` - View config

- `POST /api/v1/tenant/smtp/domains` - Add domain

### 2. Health & Metrics

**Documentation**: [Health API](/docs/implementation-technical/api/tenant-smtp/health)

View sending status and performance metrics.

**Key Endpoints**:

- `GET /api/v1/tenant/smtp/status` - Operational status

- `GET /api/v1/tenant/smtp/metrics` - Deliverability stats

---

## Authentication

**Scope**: Strictly tenant-scoped. Users can only access their own tenant's resources.
