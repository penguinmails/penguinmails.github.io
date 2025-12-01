# Task Templates

This directory contains standardized templates for creating new development tasks. Each template includes frontmatter with status fields, specification links, and comprehensive sections to ensure consistency and traceability across all tasks.

## Available Templates

### 1. Frontend Task Template

**File**: `frontend-task-template.md`

Use this template for tasks involving:

- React components and hooks
- Next.js pages and layouts
- Client-side state management
- UI/UX implementation
- Frontend routing
- Form handling and validation
- Styling and responsive design

**Key Sections**:

- Component requirements
- Route/page requirements
- State management
- API integration
- Accessibility requirements

### 2. Backend Task Template

**File**: `backend-task-template.md`

Use this template for tasks involving:

- API endpoints and routes
- Server-side logic
- Database operations
- Authentication and authorization
- Business logic implementation
- Service layer development
- Data validation

**Key Sections**:

- API endpoint specifications
- Request/response schemas
- Database schema references
- Multi-tenancy considerations
- Authentication & authorization

### 3. Infrastructure Task Template

**File**: `infrastructure-task-template.md`

Use this template for tasks involving:

- Database setup and configuration
- External service integration
- CI/CD pipeline configuration
- Environment setup
- Deployment procedures
- Monitoring and logging
- Security configuration

**Key Sections**:

- Infrastructure component details
- Configuration requirements
- Installation & setup procedures
- Monitoring & health checks
- Security considerations
- Backup & recovery

## How to Use Templates

### 1. Copy the Template

```bash
# Copy the appropriate template to your epic/milestone directory
cp tasks/templates/[template-name].md tasks/epic-[n]-[name]/milestone-[n]-[name]/[TICKET-ID]-[brief-name].md
```

### 2. Fill in Frontmatter

Update the frontmatter with task-specific information:

```yaml
---
title: "AUTH-1.1: Create Login Component"
description: "Implement user login component with email/password authentication"
last_modified_date: "2025-11-24"
level: 2
persona: "Documentation Users"

# Task Status & Assignment
status: "IN_PROGRESS"
assignee: "john-doe"
priority: "HIGH"
sprint: "SPRINT-24"
story_points: 5

# Specification Links
feature: "docs/features/authentication.md"
frontend_spec: "docs/design/routes/public-auth.md"
api_spec: "docs/implementation-technical/api/auth/login.md"
user_journey: "docs/user-journeys/customer-onboarding.md"
---
```

### 3. Complete All Sections

Fill in all relevant sections with specific details for your task:

- Description (what needs to be done)
- Context (why it's important)
- Acceptance criteria (how to verify completion)
- Technical details (implementation specifics)
- Related documentation (links to specs)
- Dependencies (prerequisite tasks)
- Testing (test cases and verification)

### 4. Link to Specifications

**Critical**: Always link tasks to their related specifications:

- **feature**: Link to the feature document in `docs/features/`
- **frontend_spec**: Link to the frontend route spec in `docs/design/routes/`
- **api_spec**: Link to the API specification in `docs/implementation-technical/api/`
- **user_journey**: Link to relevant user journey in `docs/user-journeys/`

This creates a complete traceability chain:

```txt
Roadmap → Feature → Frontend Spec + API Spec → Task → Implementation
                          ↑
                    User Journey
```

## Frontmatter Status Fields

### Status Values

- **NOT_STARTED**: Task is in backlog, not yet started
- **IN_PROGRESS**: Developer actively working on it
- **READY_FOR_TESTING**: Implementation complete, pending validation
- **BLOCKED**: Stuck due to dependencies or missing inputs
- **DONE**: Fully reviewed, tested, and accepted

### Priority Levels

- **CRITICAL** 🔴: Blocking issue, must be completed ASAP
- **HIGH** 🟠: Important, should be completed soon
- **MEDIUM** 🟡: Normal priority
- **LOW** ⚪: Nice to have, can be deferred

### Story Points Guide

| Story Points | Meaning | Typical Effort |
|--------------|---------|----------------|
| 1 point | Very small task | Quick config, text change, or minor UI fix |
| 2 points | Small task | One function, small component, or bug fix |
| 3 points | Medium task | New feature with some logic or API use |
| 5 points | Large task | Multi-step logic, backend + frontend integration |
| 8 points | Complex feature | Multiple systems involved, requires testing + review |
| 13 points | Very complex | Requires research or touches critical flows (may split) |

## Best Practices

### 1. Be Specific in Acceptance Criteria

❌ Bad: "Create login page"  
✅ Good: "Login page displays email and password fields with validation, submit button triggers authentication API, and shows error messages for invalid credentials"

### 2. Link All Related Documentation

Always provide links to:

- Feature specifications
- Frontend route specifications
- API documentation
- User journeys
- Design system guidelines

### 3. Include Testing Details

Specify:

- Unit test cases
- Integration test scenarios
- Manual verification steps
- Accessibility testing requirements

### 4. Document Dependencies

List all prerequisite tasks that must be completed before this task can be started.

### 5. Update Status Regularly

Keep the `status` field up-to-date as work progresses. This helps with project tracking and visibility.

## Template Customization

Templates are meant to be comprehensive starting points. You can:

- Remove sections that aren't relevant
- Add sections specific to your task
- Adjust the level of detail based on task complexity

However, **always keep**:

- Frontmatter with status fields
- Specification links
- Acceptance criteria
- Testing section
- Definition of Done

## Related Documentation

- [Tasks README](../README.md) - Overview of task structure
- [Feature Specifications](/docs/features/README.md) - Feature approval workflow
- [Frontend Routing Map](/docs/design/frontend-routing-map.md) - All UI views
- [API Documentation](/docs/implementation-technical/api/README.md) - Backend endpoints
- [Development Guidelines](/docs/implementation-technical/development-guidelines/development-standards.md) - Code standards

---

**Questions?** Contact the Product Owner or Tech Lead for guidance on using these templates.
