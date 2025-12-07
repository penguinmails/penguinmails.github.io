---
title: "Design Patterns"
description: "UI design patterns"
last_modified_date: "2025-12-04"
level: "3"
keywords: "patterns, design, architecture"
---

# Design Patterns

## Design Patterns

### Responsive Design Strategy

### Mobile-First Approach

- Base styles target mobile (< 640px)

- Progressive enhancement for tablet (768px+) and desktop (1024px+)

- Touch-friendly targets: minimum 44px × 44px

**Breakpoints** (from design-tokens.md):

```typescript
const breakpoints = {
  sm: '640px',   // Small devices
  md: '768px',   // Tablets
  lg: '1024px',  // Desktops
  xl: '1280px',  // Large desktops
  '2xl': '1536px' // Extra large
};


```

### Theme Support

### Light/Dark Mode

- Use Tailwind's `dark:` variant

- Store preference in localStorage

- Respect system preference (`prefers-color-scheme`)

- Smooth transitions between themes

**Implementation Pattern**:

```typescript
// Use next-themes for theme management
import { ThemeProvider } from 'next-themes';

<ThemeProvider attribute="class" defaultTheme="system">
  {children}
</ThemeProvider>


```

### Animation Strategy

**Library**: **Framer Motion** (for complex animations) + **CSS Transitions** (for simple states)

**When to Use Framer Motion**:

- Page transitions

- Complex multi-step animations

- Gesture-based interactions (drag, swipe)

- Orchestrated animations (stagger effects)

**When to Use CSS Transitions**:

- Hover states

- Focus indicators

- Simple show/hide animations

- Color/opacity changes

**Performance Guidelines**:

- Respect `prefers-reduced-motion`

- Animate `transform` and `opacity` only (GPU-accelerated)

- Avoid animating `width`, `height`, `top`, `left`

- Keep animations under 300ms for UI feedback

**Example**:

{% raw %}

```jsx
// Framer Motion for page transitions
import { motion } from 'framer-motion';

<motion.div
  initial={{ opacity: 0, y: 20 }}
  animate={{ opacity: 1, y: 0 }}
  exit={{ opacity: 0, y: -20 }}
  transition={{ duration: 0.2 }}
>
  {content}
</motion.div>

// CSS for hover states
.button {
  transition: background-color 150ms ease-in-out;
}
.button:hover {
  background-color: var(--color-primary-600);
}
```

{% endraw %}

### Loading States

**Pattern**: Skeleton screens + Suspense boundaries

**Requirements**:

- Show skeleton UI while data loads

- Use React Suspense for async components

- Provide meaningful loading indicators

- Avoid full-page spinners (use progressive loading)

**Example**:

```typescript
import { Suspense } from 'react';
import { CampaignListSkeleton } from '@/components/skeletons';

<Suspense fallback={<CampaignListSkeleton />}>
  <CampaignList />
</Suspense>


```

### Error Handling

**Pattern**: Error boundaries + user-friendly messages

**Requirements**:

- Catch errors at component boundaries

- Show actionable error messages

- Provide retry mechanisms

- Log errors to monitoring service (Sentry) (Future/2026 Spike)

**Example**:

```typescript
<ErrorBoundary
  fallback={<ErrorFallback />}
  onError={(error) => logToSentry(error)}
>
  <CampaignEditor />
</ErrorBoundary>


```

---
