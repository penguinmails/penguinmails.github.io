---
title: "Infrastructure Architecture"
description: "High-level architecture, database schema, and health monitoring for the email infrastructure system."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers, Systems Architects"
---

# Infrastructure Architecture

**Architectural blueprints and data models governing the email provisioning engine.**

---

## 1. System Architecture

```text
┌─────────────────────────────────┐      ┌─────────────┐
│      PenguinMails App           │      │ Hostwind API│
│  - Provisioning Service         │◄─────┤- VPS Control│
│  - DNS Automation               │      │- IP Mgmt    │
│  - Health Monitoring            │      └─────────────┘
└─────────────┬───────────────────┘
              │ (SSH / API)
              ▼
┌─────────────────────────────────┐
│      Hostwind VPS Instance      │
│  - MailU (SMTP/IMAP)            │
│  - Security (UFW/Fail2ban)      │
│  - Let's Encrypt                │
└─────────────────────────────────┘
```

---

## 2. Database Schema

Tables tracking the state of provisioned infrastructure.

```sql
-- Infrastructure container
CREATE TABLE infrastructure (
  id UUID PRIMARY KEY,
  tenant_id UUID NOT NULL,
  vps_ip VARCHAR(45) NOT NULL,
  vps_status VARCHAR(50), -- active, suspended, terminated
  smtp_host VARCHAR(255),
  health_status VARCHAR(50), -- healthy, degraded, critical
  deliverability_score INTEGER, -- 0-100
  provisioned_at TIMESTAMP DEFAULT NOW()
);

-- DNS Record tracking
CREATE TABLE dns_records (
  id UUID PRIMARY KEY,
  infrastructure_id UUID REFERENCES infrastructure(id),
  record_type VARCHAR(10),
  record_name VARCHAR(255),
  record_value TEXT,
  is_validated BOOLEAN DEFAULT FALSE,
  validation_status VARCHAR(50) -- pending, valid, invalid, missing
);
```

---

## 3. Health Monitoring

Automated checks performed by the PenguinMails platform:

### Recurring Checks

- **Every 5 Mins**: SMTP service status, Queue size, Disk usage.
- **Hourly**: DNS record validation, SSL expiration check.
- **Daily**: IP reputation monitoring and blacklist check.

### Alerting Triggers

- Service downtime (SMTP/Webmail).
- DNS record alteration.
- IP Blacklisting by major providers (Spamhaus, Barracuda).
- Deliverability score drop (>10%).
