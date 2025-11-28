---
title: "Domains API"
description: "Detailed endpoint specifications for Tenant Domain Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# Domains API

**Parent API**: [Tenant SMTP API](/docs/implementation-technical/api/tenant-smtp)
**URL Prefix**: `/api/v1/tenant/smtp`

---

## Endpoints

### Get Tenant SMTP Configuration

**Method**: `GET`
**URL**: `/api/v1/tenant/smtp/config`
**Purpose**: Retrieve effective SMTP configuration and domain verification status.

**Response**:

```json
{
  "success": true,
  "data": {
    "tenant_id": "tn_123",
    "from_domains": [
      {
        "domain": "example.com",
        "dkim_status": "verified",
        "spf_status": "verified",
        "dmarc_status": "configured"
      }
    ],
    "rate_limits": {
      "max_per_hour": 20000
    }
  }
}


```

### Add Domain

**Method**: `POST`
**URL**: `/api/v1/tenant/smtp/domains`
**Purpose**: Register a new sending domain.

**Request**:

```json
{
  "domain": "marketing.example.com"
}


```

### Get DNS Records

**Method**: `GET`
**URL**: `/api/v1/tenant/smtp/domains/{domain}/dns`
**Purpose**: Retrieve required DNS records for verification.
