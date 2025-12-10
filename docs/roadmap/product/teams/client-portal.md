---
title: "External User Collaboration (Client Portal)"
description: "Implement external user access allowing clients to access specific workspaces"
last_modified_date: "2025-12-09"
level: "3"
persona: "Product Managers"
parent: "/docs/roadmap/product/teams/README.md"
---

# External User Collaboration (Client Portal)

## Overview

**Priority**: P3 (Agency Feature)
**Timeline**: Q2 2027
**Effort**: Large

**Description**:
Implement external user access allowing clients to access specific workspaces with limited permissions without full tenant membership.

## Acceptance Criteria

- Implement external user authentication system separate from tenant authentication
- Create client-specific permission model with read-only access
- Build white-label client portal UI with agency branding
- Implement limited feature access for external users (view campaigns, reports only)
- Add client invitation and access management workflow
- Implement separate billing model for external users (optional)
- Document white-label configuration and branding options
- Add client portal analytics and usage tracking

## Dependencies

- Authentication system
- Workspace management system
- White-label infrastructure
