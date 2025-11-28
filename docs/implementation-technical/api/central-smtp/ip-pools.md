---
title: "IP & Pools API"
description: "Detailed endpoint specifications for SMTP IP Inventory and Pool Management"
last_modified_date: "2025-11-21"
level: "3"
persona: "Backend Developers"
---


# IP & Pools API

**Parent API**: [Central SMTP API](/docs/implementation-technical/api/central-smtp)
**URL Prefix**: `/api/v1/smtp/admin`

---

## Endpoints

### List SMTP IPs

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/ips`  
**Purpose**: List all IPs in the inventory with status and pool assignment.

**Query Parameters**:

- `status`: `active|warming|blocked|retired`

- `pool`: pool identifier

- `reputation_band`: `excellent|good|watch|bad`

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "ip_id": "ip_123",
      "ip_address": "198.51.100.10",
      "status": "active",
      "pool": "shared_default",
      "reputation_band": "good",
      "capacity_score": 0.8
    }
  ]
}


```

### Get Single IP

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/ips/{ipId}`  
**Purpose**: Detailed IP information.

### Update IP Metadata

**Method**: `PATCH`  
**URL**: `/api/v1/smtp/admin/ips/{ipId}`  
**Purpose**: Update IP status or pool assignment. **Restricted**.

**Request**:

```json
{
  "status": "warming",
  "pool": "dedicated_high_volume"
}


```

### List Pools

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/pools`  
**Purpose**: List all IP pools.

**Response**:

```json
{
  "success": true,
  "data": [
    {
      "pool_id": "pool_shared_default",
      "name": "Shared Default",
      "ip_count": 12,
      "status": "active",
      "current_load_factor": 0.72
    }
  ]
}


```

### Get Pool Details

**Method**: `GET`  
**URL**: `/api/v1/smtp/admin/pools/{poolId}`  
**Purpose**: Detailed pool configuration and metrics.

### Update Pool Configuration

**Method**: `PATCH`  
**URL**: `/api/v1/smtp/admin/pools/{poolId}`  
**Purpose**: Update pool settings. **Restricted**.
