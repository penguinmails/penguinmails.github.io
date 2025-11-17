---
title: "Executive Tenant Summary Journey (BF-002, BF-006, CO-001, RP-001)"
description: "Documentation for Executive Tenant Summary Journey (BF-002, BF-006, CO-001, RP-001) - Executive Tenant Summary"
last_modified_date: "2025-11-17"
level: 2
persona: "Documentation Users"
---

# Executive Tenant Summary Journey (BF-002, BF-006, CO-001, RP-001)

Document Level: Implementation-Technical (UX Contract)  
Primary Personas: CFO, COO, VP Operations, Revenue/Success Leaders  
Related Stories: BF-002, BF-003, BF-004, BF-005, BF-006, CO-001, RP-001, RP-005  

## 1. Overview

This journey defines how an executive drills down from the high-level Executive Overview into a single tenant’s summary view.

The tenant summary must provide, in one place:

- Deliverability and reputation signals.
- Revenue and value signals (directional, not full finance system).
- Approximate infrastructure cost signals (internal only).
- Key open risks and alerts.

The goal is a clear, honest, cross-sourced snapshot of a tenant, aligned with the documented approximation and compliance constraints.

## 2. Persona & Preconditions

- Persona:
  - Executive or senior operator with tenant-level access:
    - CFO/Finance leadership
    - COO/Operations leadership
    - Head of Deliverability / Revenue Ops
- Preconditions:
  - Authenticated and authorized per BF-004 with correct scopes.
  - Tenant exists with:
    - Mail sending history and deliverability events.
    - Approximate infra cost fields populated per BF-001/BF-002 (where applicable).
    - Relevant PostHog / analytics events available per BF-003.
  - Executive Overview journey is functional; tenant summary is reached via approved navigation, not guessable deep links without auth.

## 3. Step-by-step Flow

1. From Executive Overview, user selects a specific tenant (e.g. via search, table row, or “View details” link).
2. System validates:
   - Executive has rights to view this tenant (RBAC, tenant scoping).
3. Tenant Summary page loads with key sections:
   - Identification:
     - Tenant name, ID, segment, status.
   - Deliverability & reputation:
     - High-level metrics (send volume, bounce/complaint rates, reputation flags).
   - Revenue & value (directional):
     - Consolidated indicators from analytics/BI (not full ledger).
   - Approximate infra cost signals:
     - VPS/IP approximate_cost-based indicators where applicable.
   - Alerts & issues:
     - Active critical/major alerts (from BF-005 foundation).
4. From here, executive can:
   - Navigate to more detailed views:
     - Revenue risk, cost optimization, configuration details, incident timelines.
   - Capture a snapshot view suitable for internal reporting.

## 4. Expected UX & Data Behavior

- The summary:
  - Must be concise and scannable:
    - Tiered layout: primary KPIs at top, supporting context below.
  - Must align with defined data contracts:
    - Deliverability and revenue-risk metrics from documented analytics/event specs.
    - Cost approximations only from approved approximate_cost and BI views.
- Labeling & messaging:
  - Approximate infra costs:
    - Clearly labeled as “Internal approximation / non-authoritative”.
    - Positioned as an internal signal, not a bill.
  - Risk/alerts:
    - Use consistent severity levels and language matching queue-events and alert docs.
- Navigation:
  - Clear path back to:
    - Executive Overview,
    - Other tenant summaries,
    - Detailed feature views (without losing context).

## 5. Constraints & Guardrails

- Must:
  - Respect BF-004 RBAC and tenant isolation.
  - Ensure no cross-tenant leakage in:
    - Metrics,
    - Exports,
    - URLs or UI hints.
- Must not:
  - Expose raw provider billing as if it were produced by this system.
  - Overstate precision or real-time guarantees beyond documented architecture.
- Performance expectations:
  - Should feel responsive and be optimized using the patterns defined in BF-006/OE-002 (exact SLOs defined in those stories).

## 6. Story & Documentation Mapping

- Backlog:
  - BF-002: Internal admin/exec views based on approximation fields.
  - BF-003: PostHog integration (events feeding tenant insights).
  - BF-004: Exec authentication and RBAC.
  - BF-005: Alert and notification foundation.
  - BF-006: Executive API abstractions for tenant metrics.
  - CO-001: Cost attribution for infra components.
  - RP-001 / RP-005: Revenue risk and deliverability incident context.
- Docs:
  - [`business-leaders-database-migration-guide.md`](docs/implementation-technical/database-infrastructure/business-leaders-database-migration-guide.md:1)
  - [`posthog-business-events-specification.md`](docs/implementation-technical/analytics-integration/posthog-business-events-specification.md:1)
  - [`executive-api.md`](docs/implementation-technical/api/executive-api.md:1)
  - [`queue-events-api.md`](docs/implementation-technical/api/queue-events-api.md:1)