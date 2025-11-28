---
title: "Mobile Responsiveness"
description: "Mobile design guidelines and responsive behavior"
last_modified_date: "2025-11-24"
type: "design"
status: "DRAFT"
---


# Mobile Responsiveness Guidelines

## Ensuring a seamless experience across all devices

---

## Core Principles

1. **Mobile-First**: Design for small screens, then enhance for desktop.

2. **Touch-Friendly**: Minimum touch target size of 44x44px.

3. **Content Prioritization**: Show most important data first on mobile.

---

## Breakpoints

We use Tailwind CSS standard breakpoints:

- **sm**: 640px (Mobile Landscape)

- **md**: 768px (Tablet)

- **lg**: 1024px (Laptop)

- **xl**: 1280px (Desktop)

---

## Component Behavior

### Navigation

- **Desktop**: Sidebar navigation.

- **Mobile**: Bottom tab bar (app-like) or Hamburger menu.

### Data Tables

- **Desktop**: Full table with all columns.

- **Mobile**: Card view or horizontally scrollable table with sticky first column.

- **Action**: "View Details" modal for full row data.

### Email Builder

- **Desktop**: Drag-and-drop canvas + sidebar.

- **Mobile**: Stacked block editing. No drag-and-drop (tap to move up/down).

### Charts

- **Desktop**: Detailed line/bar charts with tooltips.

- **Mobile**: Simplified sparklines or summary numbers.

---

## Testing Strategy

- **Devices**: iPhone 14, Pixel 7, iPad Air.

- **Browsers**: Safari (iOS), Chrome (Android).

- **Tools**: Chrome DevTools Device Mode.

---

**Last Updated:** November 24, 2025
**Status:** In Design
