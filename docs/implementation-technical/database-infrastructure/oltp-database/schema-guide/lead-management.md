---
title: "OLTP Schema - Lead Management"
description: "Contact database schema for leads and contact management."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Lead Management

### **Lead Management**

#### **leads** - Contact Database

```sql
CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    email VARCHAR(255) NOT NULL,
    name VARCHAR(200),
    company VARCHAR(200),
    status VARCHAR(20) DEFAULT 'active',
    updated TIMESTAMP WITH TIME ZONE,

    UNIQUE(tenant_id, email)
);
```
