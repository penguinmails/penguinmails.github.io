---
title: "Reputation API"
description: "Detailed endpoint specifications for SMTP Reputation and Health Monitoring"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---

# Reputation API

**Parent API**: [Central SMTP API](/docs/implementation-technical/api/central-smtp)
**URL Prefix**: `/api/v1/smtp/admin`

---

## Endpoints

### IP Health Summary

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/ips/health-summary`  
**Purpose**: Aggregate health metrics across all IPs.

**Query Parameters**:

- `window`: e.g., `24h`

### Pool Reputation Overview

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/pools/reputation`  
**Purpose**: Aggregate reputation metrics per pool.

**Query Parameters**:

- `window`: e.g., `7d`
