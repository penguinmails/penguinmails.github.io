# Marketing Analytics Architecture: Real-Time Measurement Framework

## Overview

This document defines the technical architecture for the marketing analytics platform: ingestion, processing, storage, attribution, and dashboard delivery for all marketing channels.

**Document Level:** Level 4 - Technical Implementation  
**Target Audience:** Data Engineers, Analytics Engineers, Solution Architects  
**Scope:** Real-time events, cross-channel attribution, executive dashboards

Business context (no duplication, for traceability only):
- Strategy and epics: `docs/business/marketing/strategy/detailed.md`
- ROI model: `docs/business/marketing/roi/detailed.md`

---

## 1. Event and Data Model

### 1.1 Core Event Schema

All marketing data is normalized into a small set of event types:

- Campaign events (launch, optimize, terminate)
- Customer journey events (stage changes, touchpoints, conversions)
- Personalization events (triggered experiences)

Key properties:
- tenant_id (multi-tenant isolation)
- event_type (enum)
- timestamp (UTC, ISO-8601)
- source (channel / platform)
- performance_metrics (impressions, clicks, conversions, cost, revenue)
- metadata (extensible JSON, schema-validated)

Constraints:
- Schemas versioned and enforced at ingestion
- No PII beyond allowed fields; PII handling delegated to CDP and privacy layer

### 1.2 Identity and CDP Integration

- Deterministic IDs (user_id, email, account_id) plus probabilistic matching.
- Real-time sync with CDP (e.g. Segment/Posthog) using:
  - Event-driven ingestion
  - Schema validation and mapping
  - Consent-aware attribute enrichment

Result:
- Unified profile graph powering attribution and personalization.
- Strict GDPR/CCPA alignment (consent flags, right-to-be-forgotten routing).

---

## 2. Ingestion and Stream Processing

### 2.1 Ingestion Layer

- Transport: Kafka (or equivalent) topics:
  - marketing-events (all raw events)
  - analytics-signals (aggregated metrics and anomalies)
- Guarantees:
  - At-least-once at transport; exactly-once at processing.
  - 90+ days retention for replay and backfill.

### 2.2 Stream Processing Layer

Framework:
- Apache Flink or similar for:
  - Real-time validation, enrichment, normalization
  - Per-tenant partitioning
  - Sliding/tumbling windows for metrics
- Latency SLO:
  - <5s from event to derived metrics

Key responsibilities:
- Compute real-time KPIs (CTR, CVR, ROAS, etc.)
- Emit alerts to “analytics-alerts” stream when thresholds breached
- Feed attribution engine with ordered touchpoint sequences

---

## 3. Storage Architecture

### 3.1 Storage Tiers

- Raw store:
  - Object storage (e.g. S3) for immutable, partitioned event logs
- Operational analytics:
  - Columnar / search engine (e.g. ClickHouse, Elasticsearch) for real-time queries
- Serving DB:
  - Relational store (e.g. Postgres) for aggregates and dashboard views
- Warehouse:
  - Snowflake/BigQuery/Redshift for historical modeling and BI

Partitioning:
- By tenant_id, date, and event_type
- Ensures query isolation and cost visibility

---

## 4. Attribution and Measurement Engine

### 4.1 Attribution Models

Supported models (configurable per tenant):
- First-touch, last-touch, linear
- Time-decay, position-based
- Data-driven model (trained on historical conversions)

Implementation:
- Offline training jobs compute weights for data-driven model
- Online scorer:
  - Maintains per-user touchpoint sequences
  - Computes fractional credit at conversion time
- SLO:
  - Attribution updates visible in <30s post-conversion

### 4.2 Cross-Device and Journey Stitching

- Deterministic stitching via auth IDs
- Probabilistic stitching behind privacy-safe thresholds
- Device graph maintained per tenant
- GDPR/CCPA-compliant (configurable retention, opt-out respected)

---

## 5. Dashboard and API Integration

Dashboards are consumers of this architecture; all business-facing views are built on:

- Aggregated metrics tables and indices
- Real-time APIs for:
  - Campaign performance
  - Journey analytics
  - Attribution summaries

Backlink:
- Technical dashboard details: `docs/implementation-technical/marketing/marketing-dashboard-technical.md` (to be consolidated)

APIs:
- REST/GraphQL endpoints with:
  - Tenant-scoped authZ
  - Role-based access for CMO/Directors/Analysts
  - Pagination, filtering, and export for BI tools

---

## 6. Reliability, Quality, and Compliance

### 6.1 Observability

- Metrics:
  - Events processed/sec, pipeline latency, error rate, attribution coverage
- Tracing:
  - End-to-end from ingestion to dashboard queries
- Alerts:
  - SLA breaches, anomaly detection, data quality issues

### 6.2 Data Quality

- Schema enforcement at ingest
- Automated checks:
  - Non-negative metrics
  - clicks ≤ impressions, conversions ≤ clicks
  - Outlier detection with quarantine queues
- Daily quality reports and remediation jobs

### 6.3 Security and Privacy

- Encryption in transit (TLS) and at rest (AES-256)
- Tenant isolation at transport, storage, and query layers
- Fine-grained RBAC and row-level security for dashboards
- Compliance hooks:
  - Consent state propagated from CDP
  - Right-to-be-forgotten deletion propagation

---

## 7. Traceability to Business Outcomes

This architecture is intentionally business-agnostic in content, but traceable:

- Strategic drivers:
  - See `docs/business/marketing/strategy/detailed.md`
- Financial justification:
  - See `docs/business/marketing/roi/detailed.md`

All executive and ROI narratives live in business documentation; this file is strictly technical specification for implementing analytics capabilities required to support those outcomes.
