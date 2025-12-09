---
title: "Project Management for Technical Tasks"
description: "Guide for organizing technical work using epics and milestones"
---

# Project Management for Technical Tasks

For complex technical work, we use **epics and milestones** as organizing structures. These are managed in our **external project management tool** (e.g., Jira, Linear), but this guide provides examples and proposals for structuring technical work.

> [!NOTE]
> This is guidance, not prescription. Adapt the structure to your team's needs.

---

## Epic Structure (Example)

An epic groups related technical work with a clear objective:

```markdown
# Epic: [Name]

**Objective:** Clear goal statement
**Status:** Not Started | In Progress | Complete

## Milestones
1. [Milestone 1 Name] - Description
2. [Milestone 2 Name] - Description

## Key Technologies
- Technology 1
- Technology 2

## Success Criteria
- ✅ Criterion 1
- ✅ Criterion 2
```

---

## Milestone Structure (Example)

Milestones group related tickets with dependencies:

```markdown
# Milestone: [Name]

**Goal:** What this milestone achieves
**Tickets:** 5 tasks
**Dependencies:** Previous milestone or external

## Tickets
| ID | Title | Priority | Dependencies |
|----|-------|----------|--------------|
| TASK-1 | Task name | High | None |
| TASK-2 | Task name | Medium | TASK-1 |
```

---

## Ticket Structure (Example)

Each ticket is a discrete unit of work:

```markdown
# TASK-ID: Task Title

**Priority:** 🔴 Critical | 🟠 High | 🟡 Medium | 🟢 Low
**Status:** Not Started | In Progress | Done

## Description
What needs to be done.

## Acceptance Criteria
1. ✅ Criterion 1
2. ✅ Criterion 2

## Technical Details
Implementation guidance.

## Dependencies
- Previous task IDs

## Testing
- [ ] Test case 1
- [ ] Test case 2
```

---

## Story Points Guide

| Points | Meaning | Typical Effort |
|--------|---------|----------------|
| 1 | Very small | Quick config, text change |
| 2 | Small | One function, bug fix |
| 3 | Medium | Feature with logic |
| 5 | Large | Multi-step integration |
| 8 | Complex | Multiple systems |
| 13 | Very complex | Research or critical flows |

---

## Related Documentation

- **Feature Tasks**: Tasks live in `docs/features/*/tasks/` directories
- **Routes**: [docs/design/routes/](/docs/design/routes/)
- **API**: [docs/implementation-technical/api/](/docs/implementation-technical/api/)
