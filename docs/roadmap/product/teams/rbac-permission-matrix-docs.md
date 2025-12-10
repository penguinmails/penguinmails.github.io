---
title: "RBAC Permission Matrix Documentation"
description: "Create comprehensive documentation of role-based access control permissions"
last_modified_date: "2025-12-09"
level: "3"
persona: "Developers"
parent: "/docs/roadmap/product/teams/README.md"
---

# RBAC Permission Matrix Documentation

## Overview

**Priority**: P1 (High)
**Timeline**: Q1 2026 (2-3 days)
**Effort**: Small

**Description**:
Create comprehensive documentation of role-based access control permissions with detailed permission matrix for Owner, Admin, and Member roles.

## Acceptance Criteria

- Create permission matrix table showing all features and role access
- Document Owner role permissions (full access, billing, team management)
- Document Admin role permissions (team management, workspace management, no billing)
- Document Member role permissions (campaign creation, limited settings)
- Document workspace-level roles (Admin, Member, Viewer)
- Clarify distinction between tenant-level and workspace-level roles
- Document role inheritance and permission scoping
- Include examples of common permission scenarios
- Document permission checking behavior throughout application

## Dependencies

- User management documentation
- Multi-tenant architecture documentation
