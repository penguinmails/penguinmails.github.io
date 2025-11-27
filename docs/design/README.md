---
title: "Design Documentation Overview"
description: "Guide to PenguinMails design documentation and its relationship to implementation"
last_modified_date: "2025-11-20"
level: "1"
persona: "Designers & Developers"
---


# Design Documentation Overview

**Purpose**: This directory contains the **planning foundation** for PenguinMails' user interface, including visual specifications, UX patterns, and design standards. These are **guidelines and requirements**, not explicit implementation code.

**Philosophy**: We define **what** to build (e.g., "DataTable with realtime + paginated variants") and **how** it should behave (using design tokens, mobile-first, accessible), using light pseudocode and general ideas rather than production code.

**Audience**: Product Designers, Frontend Developers, Product Managers, Freelancers implementing features.

---

## 📂 Directory Structure

| File | Purpose | Focus |
|------|---------|-------|
| **[Design System](/docs/design/design-system)** | Core principles, philosophy, and high-level standards. | Foundation for all design decisions. |
| **[Design Tokens](/docs/design/design-tokens)** | Primitive values (colors, spacing, typography). | Maps to CSS variables / Tailwind config. |
| **[UI Library](/docs/design/ui-library)** | **High-level patterns** and tech stack recommendations. | "Use shadcn + react-hook-form + zod", "DataTable needs realtime + paginated variants" |
| **[Component Library](/docs/design/component-library)** | **Detailed component specs** showing how components apply guidelines. | How components use tokens, ensure mobile support, implement theming. |
| **[Analytics UI Patterns](/docs/design/analytics-ui-patterns)** | **Visual patterns** for data display. | Data cards, charts, tables, and drill-down interaction patterns. |
| **[Accessibility](/docs/design/accessibility-guidelines)** | WCAG 2.1 AA standards and testing checklists. | Enforced via linting and testing. |

---

## 🔄 Design ↔ Implementation Mapping

We maintain a strict separation of concerns while ensuring tight integration:

### 1. Design Tokens → Code

* **Design**: Defined in `design-tokens.md` (e.g., `--color-primary-500`).

* **Implementation**: Implemented in Tailwind configuration and global CSS.

* **Location**: `apps/web/tailwind.config.ts` and `apps/web/app/globals.css`.

### 2. Components → Code

* **Design**: Specs in `component-library.md`.

* **Implementation**: React components using Tailwind.

* **Location**: `apps/web/components/primitives`, `apps/web/components/layout`, etc.

### 3. Views & Dashboards → Code

* **Design**: Architecture in `../features/analytics/views-architecture.md`, Patterns in `analytics-ui-patterns.md`.

* **Implementation**: Next.js App Router pages.

* **Location**: `apps/web/app/dashboard/...`

---

## 📝 Workflow Guidelines

1. **Design First**: Consult these documents *before* writing code.

2. **Update Together**: If implementation requires a design change, update these docs.

3. **Verify**: Use `accessibility-guidelines.md` checklists during PR review.

---

## 🔗 Related Documentation

* **[API Architecture](/docs/implementation-technical/api)**: Backend services supporting these views.

* **[Development Standards](/docs/implementation-technical/development-guidelines/development-standards)**: Coding standards for implementing these designs.
