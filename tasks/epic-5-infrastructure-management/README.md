# Epic 5: Infrastructure Management & Virtualization (Hostwind)

**Last Updated:** November 11, 2025  
**Status:** Not Started  
**Epic ID:** INFRA-EPIC-5

## Overview

### Objective
To build backend services that communicate with the Hostwind API to monitor VPS and IP state. This epic focuses on visibility: creating a secure API client, database schemas and migrations, a scheduled sync job to maintain a local representation of infrastructure, and tenant-aware internal APIs to surface the data.

### Description
Establish a reliable connection to Hostwind to fetch VPS and IP metadata on a recurring basis. This epic emphasizes read/visibility (no provisioning/deprovisioning). Deliverables include database schemas, a Hostwind client, a synchronization service and cron route, and tenant-aware internal API endpoints for the frontend and operations tooling.

### Prerequisites
- Epic 1 completed (Next.js app, Drizzle ORM, environment variables configured)
- A Hostwind account with API access and a generated API key
- At least one VPS manually provisioned in Hostwind for initial test data

## Milestones

1. **[Milestone 1: Database Schema and Hostwind API Client](./milestone-1-database-schema-and-hostwind-api-client/)**
2. **[Milestone 2: Infrastructure State Synchronization](./milestone-2-infrastructure-state-synchronization/)**
3. **[Milestone 3: Internal API for Infrastructure Visibility](./milestone-3-internal-api-for-infrastructure-visibility/)**

## Context & Alignment

This epic provides the infrastructure visibility layer required by the platform's operations and frontend dashboards. It aligns with the technical architecture documents describing Hostwind VPS usage and the operations runbook that requires a local, queryable view of infrastructure state.

## Success Criteria

- Database schemas and migrations for infrastructure tables are created and applied
- A reusable Hostwind API client exists and is tested (stubs/mocks acceptable)
- A scheduled sync job exists and updates local tables reliably
- Tenant-aware internal APIs return assigned IPs and sync status

---

*For detailed ticket information, navigate to the individual milestone folders above.*

## Related documentation

Refer to the project-level documentation for implementation guidelines, architecture, and operations runbooks that apply to this epic:

- [Technical Architecture — Overview](../docs/technical/architecture/overview.md)
- [Development Standards (coding, linting, CI)](../docs/implementation-technical/development-guidelines/development-standards.md)
- [Operations: Infrastructure Operations Management](../docs/operations-analytics/operations-management/infrastructure-operations-management.md)
- [Security & Compliance Framework](../docs/compliance-security/enterprise/security-framework.md)
- [Quick Setup / Getting Started](../docs/quick-setup.md)
