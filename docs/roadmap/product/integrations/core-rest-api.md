---
title: "Core REST API Endpoints"
description: "Implement core REST API endpoints for contacts, campaigns, emails, and analytics"
---

# Core REST API Endpoints

## Overview

**Priority**: P0 - Critical
**Complexity**: Large (2-3 weeks)
**Status**: Partially Documented, Implementation Pending
**Blocking**: Yes - Blocks programmatic integrations

Implement core REST API endpoints for contacts, campaigns, emails, and analytics with standard REST conventions.

## Acceptance Criteria

- [ ] **Contacts API**: GET /api/v1/contacts (list with pagination), POST /api/v1/contacts (create), GET /api/v1/contacts/:id (get), PUT /api/v1/contacts/:id (update), DELETE /api/v1/contacts/:id (delete)
- [ ] **Campaigns API**: GET /api/v1/campaigns (list), POST /api/v1/campaigns (create), GET /api/v1/campaigns/:id (get), PUT /api/v1/campaigns/:id (update), DELETE /api/v1/campaigns/:id (delete), POST /api/v1/campaigns/:id/start (start), POST /api/v1/campaigns/:id/pause (pause)
- [ ] **Emails API**: POST /api/v1/emails/send (send single email), GET /api/v1/emails (list sent emails), GET /api/v1/emails/:id (get email details)
- [ ] **Analytics API**: GET /api/v1/analytics/emails (email metrics), GET /api/v1/analytics/campaigns/:id (campaign metrics), GET /api/v1/analytics/contacts/:id (contact engagement)
- [ ] Standard REST conventions (GET, POST, PUT, DELETE verbs)
- [ ] JSON request/response format
- [ ] Standard HTTP status codes (200, 201, 400, 401, 403, 404, 500)
- [ ] Pagination support (limit, offset, cursor-based)
- [ ] Filtering support (query parameters)
- [ ] Sorting support (sort_by, order parameters)
- [ ] API versioning (/api/v1/)
- [ ] Comprehensive error responses with error codes and messages

## Dependencies

- API Key Management System (authentication)
- PostgreSQL database
- Campaign management system
- Email sending infrastructure

## References

- [Feature Documentation](/docs/features/integrations/api-access)
- [Integration Strategy](/.kiro/specs/feature-completeness-review/findings/integration-strategy)
