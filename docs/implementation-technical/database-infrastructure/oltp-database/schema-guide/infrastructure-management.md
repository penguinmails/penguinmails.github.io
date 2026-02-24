---
title: "OLTP Schema - Infrastructure Management"
description: "VPS instances, IP addresses, and domain-to-IP assignment schema."
last_modified_date: "2026-02-24"
level: "2"
persona: "Documentation Users"
---

# OLTP Schema - Infrastructure Management

## Infrastructure Management

### **VPS & IP Management**

#### **vps_instances** - VPS Server Instances

```sql
CREATE TABLE vps_instances (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    hostwinds_instance_id VARCHAR(255) UNIQUE,
    ip_address VARCHAR(45),
    region VARCHAR(50),
    status VARCHAR(50) CHECK (status IN ('active', 'provisioning', 'scheduled_decommission', 'decommissioned')),
    monthly_cost DECIMAL(10,2),
    approximate_cost DECIMAL(8,2), -- Business cost attribution for tenant cost analysis
    hostwinds_billing_day INTEGER,
    current_billing_period_start TIMESTAMP WITH TIME ZONE,
    current_billing_period_end TIMESTAMP WITH TIME ZONE,
    decommission_scheduled_for TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Business Justification**: The `approximate_cost` field enables business leaders to track infrastructure costs per tenant for cost optimization and profitability analysis, supporting executive decision-making for resource allocation and pricing strategy.

#### **smtp_ip_addresses** - SMTP IP Addresses

```sql
CREATE TABLE smtp_ip_addresses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vps_instance_id UUID REFERENCES vps_instances(id) ON DELETE CASCADE,
    ip_address VARCHAR(45) NOT NULL,
    status VARCHAR(50) CHECK (status IN ('available', 'assigned', 'warming', 'warmed', 'degraded', 'burned', 'quarantined')),
    reputation_state VARCHAR(50) CHECK (reputation_state IN ('good', 'fair', 'poor', 'critical')),
    approximate_cost DECIMAL(6,2), -- Email service cost per IP for business analysis
    last_reputation_check TIMESTAMP WITH TIME ZONE,
    assigned_count INTEGER DEFAULT 0,
    provider_blacklist_status JSONB,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

**Business Justification**: The `approximate_cost` field supports deliverability cost analysis and email service ROI calculations, enabling business leaders to optimize IP allocation and understand the true cost of email deliverability solutions.

#### **domain_ip_assignments** - Domain-to-IP Mappings

```sql
CREATE TABLE domain_ip_assignments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    domain_id UUID REFERENCES domains(id) ON DELETE CASCADE,
    smtp_ip_address_id UUID REFERENCES smtp_ip_addresses(id) ON DELETE CASCADE,
    status VARCHAR(50) CHECK (status IN ('active', 'warming', 'scheduled', 'expired')),
    assigned TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    expires TIMESTAMP WITH TIME ZONE,
    warmup_state VARCHAR(50) CHECK (warmup_state IN ('unwarmed', 'warming', 'warmed')),
    last_sent TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```
