
# [TICKET-ID]: [Full Task Title]

**Ticket ID:** [TICKET-ID]  
**Milestone:** [N] - [Milestone Name]  
**Priority:** 🔴 Critical | 🟠 High | 🟡 Medium | ⚪ Low  
**Status:** Not Started

## Description

[Provide a clear, concise description of what needs to be implemented. Include context about why this task is important and how it fits into the larger feature or milestone.]

## Context

[Explain the business or technical context. Reference relevant documentation, features, or user journeys. Link to related specifications and design documents.]

**Related Feature**: [Link to feature doc if applicable]  
**User Journey**: [Link to user journey if applicable]  
**Frontend Spec**: [Link to frontend route spec]

## Acceptance Criteria

1. ✅ [Specific, testable criterion 1]
2. ✅ [Specific, testable criterion 2]
3. ✅ [Specific, testable criterion 3]
4. ✅ [Specific, testable criterion 4]

## Technical Details

### Component Requirements

[Describe the React components, hooks, or utilities that need to be created or modified.]

- **Component Name**: `[ComponentName]`
  - Location: `components/[path]/[ComponentName].tsx`
  - Props: [List key props]
  - State: [List key state variables]
  - Behavior: [Describe key behaviors]

### Route/Page Requirements

[If this task involves creating or modifying a Next.js route]

- **Route Path**: `/[route-path]`
- **Access Control**: [Public | Authenticated | Role-based]
- **Layout**: [Describe layout structure]
- **Data Requirements**: [API endpoints, server actions, or data sources]

### State Management

[Describe any client state, server state, or context requirements]

- **Client State**: [React useState, useReducer, Zustand, etc.]
- **Server State**: [TanStack Query, SWR, server components]
- **Form State**: [React Hook Form, Zod validation]

### Styling Requirements

[Reference design system tokens and component styles]

- **Design Tokens**: [Colors, spacing, typography from design system]
- **Responsive Behavior**: [Mobile, tablet, desktop breakpoints]
- **Accessibility**: [ARIA labels, keyboard navigation, focus management]

### API Integration

[List API endpoints this component will consume]

- **Endpoint**: `[METHOD] /api/[path]`
  - Purpose: [What data is fetched/submitted]
  - Request: [Request payload structure]
  - Response: [Expected response structure]
  - Error Handling: [How to handle errors]

## Implementation Notes

- [Implementation tip or consideration #1]
- [Implementation tip or consideration #2]
- [Reference to similar components or patterns in the codebase]
- [Any edge cases to consider]

## Related Documentation

### Specifications

- [Frontend Spec](../../docs/design/routes/[spec-name].md) - View specification
- [API Spec](../../docs/implementation-technical/api/[spec-name].md) - Backend endpoints
- [Feature Spec](../../docs/features/[feature-name].md) - Feature overview

### Design & Patterns

- [Design System](../../docs/design/ui-library.md) - UI patterns and components
- [Component Library](../../docs/design/component-library.md) - Component specifications
- [Accessibility Guidelines](../../docs/design/accessibility.md) - Accessibility standards

### Implementation

- [Frontend Routing Map](../../docs/design/frontend-routing-map.md) - Application routes
- [Development Standards](../../docs/implementation-technical/development-guidelines/development-standards.md) - Code standards
- [Testing Guidelines](../../docs/implementation-technical/development-guidelines/testing-guidelines.md) - Testing standards

## Dependencies

- **[TICKET-ID]** - [Brief description of dependency]
- **[TICKET-ID]** - [Brief description of dependency]

## Testing

### Unit Tests

- [ ] [Test case 1: Component renders correctly with default props]
- [ ] [Test case 2: Component handles user interactions]
- [ ] [Test case 3: Component displays error states]
- [ ] [Test case 4: Component handles loading states]

### Integration Tests

- [ ] [Test case 1: Component integrates with API correctly]
- [ ] [Test case 2: Component updates based on data changes]
- [ ] [Test case 3: Component navigation works correctly]

### Manual Verification

- [ ] [Verify UI matches design spec on desktop]
- [ ] [Verify UI matches design spec on mobile]
- [ ] [Verify accessibility with screen reader]
- [ ] [Verify keyboard navigation works]
- [ ] [Verify error messages display correctly]

## Definition of Done

- [ ] All acceptance criteria met
- [ ] Component implemented and working
- [ ] Unit tests written and passing
- [ ] Integration tests passing
- [ ] Code reviewed and approved
- [ ] Accessibility verified (WCAG 2.1 AA)
- [ ] Responsive design verified (mobile, tablet, desktop)
- [ ] Error handling implemented
- [ ] Loading states implemented
- [ ] Documentation updated if needed
- [ ] Deployed to staging
- [ ] Product Owner approval received

---

**Estimated Effort:** [X] story points  
**Actual Effort:** [Y] story points (update after completion)
