---
title: "Testing Strategy"
description: "Component testing strategy"
last_modified_date: "2025-12-04"
level: "3"
keywords: "testing, QA, validation"
---

# Testing Strategy

## Testing Strategy

### Component Testing

**Library**: **Vitest** + **React Testing Library**

**Requirements**:

- Test user interactions (click, type, submit)

- Test accessibility (ARIA, keyboard navigation)

- Test error states and loading states

- Mock API calls

### E2E Testing

**Library**: **Playwright**

**Critical Flows to Test**:

- User login/logout

- Campaign creation wizard

- Email sending flow

- Dashboard navigation

---

## Related Documents

- [Component Library](/docs/design/component-library) - Detailed component specifications

- [Design System](/docs/design/design-system) - Core design principles

- [Design Tokens](/docs/design/design-tokens) - Color, spacing, typography values

- [Accessibility Guidelines](/docs/design/accessibility-guidelines) - WCAG compliance standards

- [Analytics Views](/docs/design/analytics-views) - Dashboard and view specifications

---

**Keywords**: UI patterns, tech stack, Next.js 15, Tailwind CSS, shadcn/ui, react-hook-form, zod, lucide-react, design patterns, animation, responsive design, Framer Motion, testing

---

> **Note**: The detailed component implementation code above (Layout Components, Button Components, Form Components, etc.) is legacy content that will be moved to `component-library.md`. This document focuses on high-level patterns and tech stack decisions.
