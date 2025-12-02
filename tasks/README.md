
# PenguinMails Development Tasks

This directory contains all development tasks, tickets, and epics for the PenguinMails project.

## Structure

```txt
tasks/
├── README.md (this file)
└── epic-1-project-foundation/
    ├── README.md (Epic overview)
    ├── milestone-1-project-initialization/
    ├── milestone-2-database-connectivity/
    ├── milestone-3-multi-tenant-core/
    └── milestone-4-services-layer/
```

## Current Epics

### [Epic 1: Project Foundation & Core Services](./epic-1-project-foundation/)

**Status:** In Progress  
**Last Updated:** October 27, 2025

Establish a complete, secure, and scalable foundation for the PenguinMails application. This epic involves initializing the project, configuring all core technologies (Next.js, Drizzle, NileDB, Redis), and establishing the essential patterns for authentication, database interaction, and data validation.

**Milestones:**

1. **Project Initialization & Code Quality** (5 tickets)
2. **Database Connectivity & Data Integrity** (6 tickets)
3. **The Secure, Multi-Tenant Core** (5 tickets)
4. **High-Performance Services Layer** (3 tickets)

**Total Tickets:** 19

### [Epic 2: User Authentication & Profile Management](./epic-2-user-authentication-profile/)

**Status:** Not Started  
**Last Updated:** October 27, 2025

Build all backend services and API endpoints required for a user to manage their personal identity within the PenguinMails application. This includes handling the complete authentication lifecycle, managing profile information, and configuring personal preferences.

**Milestones:**

1. **Foundational User Profile API** (5 tickets)
2. **Enhanced Authentication and Security** (4 tickets)

**Total Tickets:** 9

**Prerequisites:** Epic 1 must be fully completed

### [Epic 3: Tenant & Company (Workspace) Management](./epic-3-tenant-company-management/)

**Status:** Not Started  
**Last Updated:** October 27, 2025

Build the complete set of backend services and API endpoints for creating, managing, and interacting with Tenants and Companies (Workspaces). This epic establishes the core multi-tenancy logic, allowing users to create their own isolated environments, invite team members, and manage their workspaces.

**Milestones:**

1. **Tenant and Company Creation** (4 tickets)
2. **Viewing and Managing Workspaces** (4 tickets)
3. **Tenant User Management** (3 tickets)

**Total Tickets:** 11

**Prerequisites:** Epic 1 & 2 must be fully completed

### [Epic 4: Billing, Plans, & Subscriptions](./epic-4-billing-plans-subscriptions/)

**Status:** Not Started  
**Last Updated:** October 27, 2025

Integrate Stripe as our payment processor to manage the entire billing lifecycle. This includes defining subscription plans, allowing tenants to subscribe to a plan, handling payments, and reflecting the subscription status and features within our application.

**Milestones:**

1. **Plans and Subscriptions Schema Setup** (4 tickets)
2. **Stripe Checkout Integration** (3 tickets)
3. **Subscription State Synchronization with Webhooks** (4 tickets)

**Total Tickets:** 11

**Prerequisites:** Epic 1, 2, & 3 must be fully completed

## Ticket Naming Convention

Tickets follow the format: `[EPIC-ID].[MILESTONE-ID].[TICKET-NUMBER]`

Example: `CORE-1.1` = Epic 1, Milestone 1, Ticket 1

## Ticket Status

Each ticket includes:

- **Ticket ID** - Unique identifier
- **Priority** - Critical, High, Medium, Low
- **Status** - Not Started, In Progress, In Review, Completed, Blocked
- **Description** - What needs to be done
- **Acceptance Criteria** - How to verify completion
- **Technical Details** - Implementation guidance
- **Dependencies** - Related tickets that must be completed first
- **Testing** - Test cases to verify completion

### Task Status Workflow

Following PenguinMails SOP, all tasks follow this standardized status progression:

- **Backlog** – Idea or future task
- **Selected for Development** – Approved for the current sprint
- **In Progress** – Developer actively working on it
- **Ready for Testing** – Implementation complete and pending validation
- **Blocked** – Stuck due to dependencies or missing inputs
- **Done** – Fully reviewed and accepted

**Note:** A task is considered done only if it meets acceptance criteria and has been verified by the Product Owner.

## How to Use

1. **Start with the Epic README** - Read the epic overview to understand the big picture
2. **Review Milestone READMEs** - Understand each milestone's goals and dependencies
3. **Read Individual Tickets** - Each ticket contains detailed implementation guidance
4. **Follow Dependencies** - Complete tickets in order based on dependencies
5. **Update Status** - Update ticket status as work progresses

## Related Documentation

- [Roadmap & Development Priorities](../docs/quick-access/roadmap-development-priorities) - Overall project roadmap
- [High-Level Architecture](../docs/quick-access/high-level-architecture) - System architecture
- [Team Workflow](../docs/quick-access/team-workflow) - Development processes

## Contributing

When working on tickets:

1. Read the ticket thoroughly before starting
2. Check dependencies are completed
3. Follow the acceptance criteria
4. Update ticket status as you progress
5. Add implementation notes if you discover important details
6. Mark ticket as complete when all acceptance criteria are met

## Task Completion Standards

### Definition of Done (DoD)

All tasks must meet these completion criteria before final approval and payment:

#### General Task Completion

A task is **Done** when:

- ✅ All acceptance criteria are met
- ✅ Work is reviewed, tested, and approved by the lead
- ✅ Jira status is updated with all links or screenshots
- ✅ No blockers or pending dependencies remain
- ✅ Work is verified on staging

#### Development Tasks

For development work, **Done** means:

- ✅ Code is committed, reviewed, and merged into the right branch
- ✅ Follows linting and naming standards
- ✅ Tested manually or with unit tests
- ✅ Documentation or .env.sample updated if needed
- ✅ Successfully deployed to staging

#### Bug Fixes

For bug fixes, **Done** means:

- ✅ The issue is replicated and the root cause found
- ✅ Fix verified in staging with before/after proof
- ✅ Related areas regression-tested

#### Research Spikes

For research tasks, **Done** means:

- ✅ Research completed and documented (Google Doc link in Jira)
- ✅ Includes clear findings or recommendations
- ✅ Reviewed by Anthony or team lead before closing

### Story Points Guide

Story points measure the relative effort to complete a task, considering complexity, uncertainty, and dependencies—not just time.

#### Effort Estimation Guidelines

| Story Points | Meaning | Typical Effort |
| :----- | :----- | :---- |
| 1 point | Very small task | Quick config, text change, or minor UI fix, simple investigation or quick validation |
| 2 points | Small task | One function, small component, or bug fix |
| 3 points | Medium task | New feature with some logic or API use, Research + short proof of concept |
| 5 points | Large task | Multi-step logic, backend + frontend integration, deep research spike with multiple dependencies |
| 8 points | Complex feature | Multiple systems involved, requires testing + review |
| 13 points | Very complex | Requires research or touches critical flows (may split) |

**Important**: When providing effort estimates for tasks, always include your story point estimate in your proposal or initial ticket discussion.

---

*For questions about tasks or to propose new tickets, contact the Product Owner or Tech Lead.*
