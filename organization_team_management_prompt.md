# Organization & Team Management Analysis Instructions

## Context
We've successfully updated the PenguinMails documentation based on a comprehensive database schema review. The schema now properly supports multi-tenant user relationships with NileDB-managed authentication, role-based access control via `tenant_users.roles` field, and GDPR-compliant soft deletes with PII anonymization.

## Available Documentation
The following documentation files are available for reference and updates:

**Core Documentation:**
- `README.md` - Main project overview and navigation
- `database_schema_guide.md` - Complete database schema with tables, relationships, and indexes

**User Journey Documentation:**
- `user_journeys.md` - All user domains with table of contents
- `user_journeys_onboarding.md` - User setup and activation flow
- `user_journeys_authentication.md` - Login, registration, and access control
- `user_journeys_organization.md` - Company and team management flows

**Business & Product Documentation:**
- `business_model.md` - Revenue model and unit economics
- `product_strategy.md` - Strategic positioning and competitive analysis
- `roadmap.md` - Feature development timeline and priorities

**Technical Documentation:**
- `api_reference.md` - API endpoints and integration guides
- `architecture_overview.md` - System architecture and constraints
- `infrastructure_documentation.md` - Infrastructure setup and management

**Compliance & Security:**
- `compliance_procedures.md` - Regulatory compliance requirements
- `security_documentation.md` - Security practices and protocols
- `data_privacy_policy.md` - Privacy policies and procedures

## Established Rules & Guidelines

### Schema Management Rules
- **🔒 NileDB-Managed Tables**: `users`, `tenants`, `tenant_users` are fully managed by NileDB
  - Use consistent timestamp naming: `created`, `updated`, `deleted`
  - Field types must use TEXT instead of VARCHAR for flexibility
  - Cannot be altered without NileDB platform updates

- **🏗️ Application-Managed Tables**:
  - Use consistent timestamp naming: `created`, `updated`, `deleted`
  - FK constraints use REFERENCES (not CASCADE unless required)
  - UUID primary keys for new tables
  - JSONB for flexible data structures

### Implementation Patterns
- **User Status Tracking**: Via `tenant_users.roles` field
  - `roles: []` or `roles: null` = pending invitation/onboarding
  - `roles: ['user', 'admin']` = active user with specific permissions

- **Multi-Tenant Security**: Row-Level Security (RLS) policies for tenant isolation
- **Soft Delete**: PII anonymization using `anonymize_user()` function
- **Invitation System**: NileDB native invitation system with automatic token management

### Documentation Standards
- Use Markdown with proper heading hierarchy
- Include Mermaid diagrams for complex workflows
- Reference related documents for cross-linking
- Maintain consistent terminology and naming conventions

## Current Schema Status
- ✅ Multi-tenant authentication with NileDB
- ✅ User onboarding via `tenant_users.roles`
- ✅ PII anonymization and soft delete functions
- ✅ Comprehensive performance indexes
- ✅ GDPR compliance measures implemented

## Next Focus: Organization & Team Management

### Analysis Areas to Cover

#### Database Schema Analysis
- Review existing organization-related tables:
  - `tenants` - NileDB managed tenant records
  - `tenant_users` - User-tenant associations with roles
  - `companies` - Company information within tenants
  - `staff_members` - Staff role assignments
  - `staff_roles` - Role definitions with permissions

- Identify gaps for organization/team management:
  - Team hierarchy and structure
  - Department/division management
  - Team permissions and access control
  - Organization-wide settings and policies

#### User Journey Updates
- `user_journeys_organization.md` - Company setup and team management flows
- Organization creation and configuration
- Team member invitation and management
- Role assignment and permission management
- Organization switching and context management

#### API and Integration Points
- Organization management endpoints
- Team member CRUD operations
- Role and permission APIs
- Organization settings management

#### Security and Compliance
- Multi-organization access controls
- Data isolation between organizations
- Audit logging for organization changes
- Compliance with team management regulations

### Questions to Address

1. **Organization Structure**: How should organizations be structured within the multi-tenant architecture?

2. **Team Management**: What team management features are needed for different organization sizes?

3. **Permission System**: How should the role-based permission system work across organizations?

4. **User Experience**: What is the optimal user experience for managing multiple organizations?

5. **Scalability**: How will the system scale as organizations grow from small teams to large enterprises?

### Database Analysis Space

[Continue database analysis here - examine existing tables, identify gaps, propose new tables if needed, and ensure alignment with established rules and patterns]

### Implementation Planning

[Plan implementation approach, identify dependencies, and create actionable tasks for organization & team management features]