---
title: "Technical Implementation: Import & Export"
description: "Developer guide for the contact ingestion and extraction engine."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

# Technical Implementation: Import & Export

**Specifications for handling batch contact operations, file parsing, and S3-based delivery.**

The PenguinMails Import/Export engine is designed for high-concurrency, memory-efficient processing of contact data in CSV, Excel, and JSON formats.

---

## Core Modules

Explore the following modules for technical specifications:

### 1. [Import Service](/docs/features/leads/import-export/technical/import-service)

Row-by-row parsing, duplicate strategies, validation logic, and automated tagging.

### 2. [Export Service](/docs/features/leads/import-export/technical/export-service)

Background generation pipeline, S3 storage integration, and signed URL delivery.

### 3. [Batch Schema & Events](/docs/features/leads/import-export/technical/batch-schema)

Detailed SQL table definitions for jobs, results tracking, and 1-click rollback history.

---

## Related Documentation

- **[Leads Management](/docs/features/leads/leads-management)** - Contact database and management.
- **[Contact Segmentation](/docs/features/leads/contact-segmentation)** - Create segments from imported contacts.
- **[Lead Scoring](/docs/features/leads/lead-scoring/hub)** - Score imported contacts automatically.
- **[Campaign Management](/docs/features/campaigns/campaign-management/hub)** - Using imported data in outreach.

---

**Status:** Planned - High Priority (Level 2)
**Target Release:** Q1 2026
**Owner:** Leads Team
