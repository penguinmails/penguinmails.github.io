---
title: "Milestone 3: The Secure, Multi-Tenant Core"
description: "Documentation for Milestone 3: The Secure, Multi-Tenant Core - README"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# Milestone 3: The Secure, Multi-Tenant Core

**Goal:** To implement the core authentication and authorization layer, transforming the application into a true, multi-tenant SaaS platform.

## Tickets

- [CORE-3.1](./CORE-3.1-install-configure-niledb) - Install and Configure NileDB Server SDK
- [CORE-3.2](./CORE-3.2-implement-middleware) - Implement Next.js Middleware for Route Protection
- [CORE-3.3](./CORE-3.3-create-signup-endpoint) - Create Public API Endpoint for User Signup
- [CORE-3.4](./CORE-3.4-create-login-endpoint) - Create Public API Endpoint for User Login
- [CORE-3.5](./CORE-3.5-create-protected-endpoint) - Create a Protected Endpoint to Verify User Context

## Dependencies

- **Milestone 1** must be completed
- **Milestone 2** must be completed (database schemas)
- Requires NileDB account and configuration

## Success Criteria

- ✅ NileDB SDK installed and configured
- ✅ Middleware protecting API routes
- ✅ User signup and login endpoints working
- ✅ Protected endpoints verifying authentication
- ✅ Multi-tenant context extraction working

## Context

This milestone implements the authentication and authorization foundation that supports:

- **Multi-tenant isolation** as outlined in the [High-Level Architecture](../../docs/quick-access/high-level-architecture)
- **4-tier staff hierarchy** (super_admin, admin, support, qa) from [Team Workflow](../../docs/quick-access/team-workflow)
- **Security & compliance** requirements from [Compliance & Regulatory Standards](../../docs/quick-access/compliance-regulatory-standards)
