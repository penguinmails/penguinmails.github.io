---
title: "[LEADS-3.1] Build Contact List UI"
description: ""
last_modified_date: "2026-02-24"
level: "2"
---

# [LEADS-3.1] Build Contact List UI

## Description

Create the frontend page for listing contacts with search, filtering, and pagination.

## Acceptance Criteria

- [ ] Page created at `/dashboard/contacts`
- [ ] Data table displaying Email, Name, Status, Created At
- [ ] Search bar filtering by email or name
- [ ] Pagination controls (Next/Prev)
- [ ] "Add Contact" button opening a modal/drawer

## Technical Details

- Use TanStack Table (React Table)
- Server-side pagination via API parameters
- Tailwind CSS for styling

---

## Cross-References

- **Routes**: [tenant-leads.md](/docs/design/routes/tenant-leads)
- **API**: [tenant-api/](/docs/implementation-technical/api/tenant-api/)
