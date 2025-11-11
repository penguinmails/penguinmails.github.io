# Epic 3: Tenant & Company (Workspace) Management

**Last Updated:** October 27, 2025  
**Status:** Not Started  
**Epic ID:** TEN-EPIC-3

## Overview

### Objective
To build the complete set of backend services and API endpoints for creating, managing, and interacting with Tenants and Companies (Workspaces). This epic establishes the core multi-tenancy logic, allowing users to create their own isolated environments, invite team members, and manage their workspaces.

### Description
This epic is where the application truly becomes a multi-tenant SaaS platform. While Epic 2 focused on the individual user, Epic 3 focuses on the tenant—the container for all of a customer's data, users, and resources. We will implement the API routes that allow a user to create their first tenant and company, view their workspaces, and manage the users within their tenant. This work relies heavily on the NileDB SDK for tenant creation and user membership management, and on Drizzle for managing the companies and other tenant-specific data in our database.

### Prerequisites
**Epic 1 & 2 must be fully completed.** This includes:
- ✅ A fully functional and secure user authentication system
- ✅ The ability for a user to sign up, log in, and manage their own profile
- ✅ The NileDB middleware must be correctly providing `userId` and `tenantId` in the session context for all protected routes

## Milestones

1. **[Milestone 1: Tenant and Company Creation](./milestone-1-tenant-company-creation/)** - Enable a new user to create their first Tenant and an associated Company (Workspace)
2. **[Milestone 2: Viewing and Managing Workspaces](./milestone-2-viewing-managing-workspaces/)** - Provide users with the ability to see and manage the Companies (Workspaces) within their tenant
3. **[Milestone 3: Tenant User Management](./milestone-3-tenant-user-management/)** - Implement functionality for inviting and managing users within a tenant

## Context & Alignment

This epic implements the core multi-tenant functionality that aligns with:

- **Multi-Tenant Architecture:** As outlined in the [High-Level Architecture](../docs/quick-access/high-level-architecture.md), PenguinMails uses complete tenant isolation with row-level security
- **Team Collaboration:** The [Team Workflow](../docs/quick-access/team-workflow.md) document outlines the 4-tier staff hierarchy and team management features
- **Agency-Focused Features:** From [Features & Capabilities](../docs/features-capabilities/index.md), multi-client management and team collaboration are core features
- **Implementation Roadmap:** This epic supports the Q4 2025 MVP Launch phase from [Roadmap & Development Priorities](../docs/quick-access/roadmap-development-priorities.md)

## Success Criteria

- ✅ Users can create their first tenant and company
- ✅ Users can view all companies in their tenant
- ✅ Users can update company information
- ✅ Users can invite team members to their tenant
- ✅ Users can manage tenant membership
- ✅ All endpoints properly enforce tenant isolation
- ✅ All operations are scoped to the authenticated user's tenant

---

*For detailed ticket information, navigate to the individual milestone folders above.*


