---
title: "Design Tokens"
description: "Complete design token specifications for PenguinMails"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---

# Design Tokens

## Purpose

Design tokens are the fundamental building blocks of PenguinMails design system. They provide a single source of truth for design decisions, enabling consistent visual language across all platforms and ensuring scalable, maintainable design implementation.

## 🛠️ Implementation Reference

| Token Category | Implementation Location | Format |
|---|---|---|
| **Global Tokens** | `apps/web/app/globals.css` | CSS Variables (`:root`) |
| **Tailwind Config** | `apps/web/tailwind.config.ts` | Tailwind Theme Extension |
| **Type Definitions** | `packages/types/src/design-system.d.ts` | TypeScript Interfaces |

> **Note**: Changes to tokens in this document must be reflected in `globals.css` and `tailwind.config.ts` to take effect.

## Token Architecture

### Token Categories

- **Color**: Brand colors, semantic colors, and neutral palettes
- **Typography**: Font families, sizes, weights, and line heights
- **Spacing**: Consistent spacing scale for margins, padding, and layout
- **Sizing**: Component dimensions, icon sizes, and border radius
- **Shadow**: Depth and elevation system
- **Border**: Border widths, styles, and radius values
- **Animation**: Motion design tokens for interactions

### Token Naming Convention

```css
/* Pattern: --[category]-[property]-[variant]-[modifier] */
--color-primary-500          /* Primary color, base shade */
--color-semantic-success-600  /* Semantic color, success variant, darker shade */
--text-size-lg                /* Typography size, large */
--space-4                     /* Spacing scale, 4th step */
--shadow-lg                   /* Shadow, large depth */
--radius-md                   /* Border radius, medium */
```

## Color Tokens

### Brand Colors
```css
/* Primary Blue - Trust, Technology, Professionalism */
--color-brand-primary-50: #f0f9ff;
--color-brand-primary-100: #e0f2fe;
--color-brand-primary-200: #bae6fd;
--color-brand-primary-300: #7dd3fc;
--color-brand-primary-400: #38bdf8;
--color-brand-primary-500: #0ea5e9;  /* Primary brand color */
--color-brand-primary-600: #0284c7;
--color-brand-primary-700: #0369a1;
--color-brand-primary-800: #075985;
--color-brand-primary-900: #0c4a6e;

/* Secondary Colors */
--color-brand-secondary-50: #fdf4ff;
--color-brand-secondary-100: #fae8ff;
--color-brand-secondary-200: #f5d0fe;
--color-brand-secondary-300: #f0abfc;
--color-brand-secondary-400: #e879f9;
--color-brand-secondary-500: #d946ef;  /* Secondary accent */
--color-brand-secondary-600: #c026d3;
--color-brand-secondary-700: #a21caf;
--color-brand-secondary-800: #86198f;
--color-brand-secondary-900: #701a75;
```

### Semantic Colors
```css
/* Success States */
--color-semantic-success-50: #f0fdf4;
--color-semantic-success-100: #dcfce7;
--color-semantic-success-200: #bbf7d0;
--color-semantic-success-300: #86efac;
--color-semantic-success-400: #4ade80;
--color-semantic-success-500: #22c55e;  /* Success */
--color-semantic-success-600: #16a34a;
--color-semantic-success-700: #15803d;
--color-semantic-success-800: #166534;
--color-semantic-success-900: #14532d;

/* Warning States */
--color-semantic-warning-50: #fffbeb;
--color-semantic-warning-100: #fef3c7;
--color-semantic-warning-200: #fde68a;
--color-semantic-warning-300: #fcd34d;
--color-semantic-warning-400: #fbbf24;
--color-semantic-warning-500: #f59e0b;  /* Warning */
--color-semantic-warning-600: #d97706;
--color-semantic-warning-700: #b45309;
--color-semantic-warning-800: #92400e;
--color-semantic-warning-900: #78350f;

/* Error States */
--color-semantic-error-50: #fef2f2;
--color-semantic-error-100: #fee2e2;
--color-semantic-error-200: #fecaca;
--color-semantic-error-300: #fca5a5;
--color-semantic-error-400: #f87171;
--color-semantic-error-500: #ef4444;  /* Error */
--color-semantic-error-600: #dc2626;
--color-semantic-error-700: #b91c1c;
--color-semantic-error-800: #991b1b;
--color-semantic-error-900: #7f1d1d;

/* Info States */
--color-semantic-info-50: #eff6ff;
--color-semantic-info-100: #dbeafe;
--color-semantic-info-200: #bfdbfe;
--color-semantic-info-300: #93c5fd;
--color-semantic-info-400: #60a5fa;
--color-semantic-info-500: #3b82f6;  /* Info */
--color-semantic-info-600: #2563eb;
--color-semantic-info-700: #1d4ed8;
--color-semantic-info-800: #1e40af;
--color-semantic-info-900: #1e3a8a;
```

### Neutral Colors
```css
/* Gray Scale */
--color-neutral-gray-50: #f9fafb;
--color-neutral-gray-100: #f3f4f6;
--color-neutral-gray-200: #e5e7eb;
--color-neutral-gray-300: #d1d5db;
--color-neutral-gray-400: #9ca3af;
--color-neutral-gray-500: #6b7280;  /* Base text */
--color-neutral-gray-600: #4b5563;
--color-neutral-gray-700: #374151;  /* Secondary text */
--color-neutral-gray-800: #1f2937;  /* Primary text */
--color-neutral-gray-900: #111827;  /* Headlines */

/* Warm Gray Scale */
--color-neutral-warm-50: #fafaf9;
--color-neutral-warm-100: #f5f5f4;
--color-neutral-warm-200: #e7e5e4;
--color-neutral-warm-300: #d6d3d1;
--color-neutral-warm-400: #a8a29e;
--color-neutral-warm-500: #78716c;
--color-neutral-warm-600: #57534e;
--color-neutral-warm-700: #44403c;
--color-neutral-warm-800: #292524;
--color-neutral-warm-900: #1c1917;
```

### Special Colors
```css
/* Background Colors */
--color-background-primary: #ffffff;
--color-background-secondary: #f9fafb;
--color-background-tertiary: #f3f4f6;
--color-background-overlay: rgba(0, 0, 0, 0.5);

/* Text Colors */
--color-text-primary: #111827;      /* Highest contrast */
--color-text-secondary: #374151;    /* Medium contrast */
--color-text-tertiary: #6b7280;     /* Low contrast */
--color-text-inverse: #ffffff;      /* On dark backgrounds */

/* Border Colors */
--color-border-subtle: #e5e7eb;
--color-border-default: #d1d5db;
--color-border-strong: #9ca3af;
--color-border-focus: #0ea5e9;
```

## Typography Tokens

### Font Families
```css
--font-family-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
--font-family-mono: 'JetBrains Mono', 'SF Mono', Monaco, 'Cascadia Code', 'Roboto Mono', monospace;
--font-family-display: 'Cal Sans', 'Inter', sans-serif;
```

### Font Sizes
```css
/* Display sizes */
--font-size-display-2xl: 4.5rem;    /* 72px - Hero headlines */
--font-size-display-xl: 3.75rem;    /* 60px - Section headers */
--font-size-display-lg: 3rem;       /* 48px - Page titles */
--font-size-display-md: 2.25rem;    /* 36px - Major headings */
--font-size-display-sm: 1.875rem;   /* 30px - Sub headings */

/* Text sizes */
--font-size-text-2xl: 1.5rem;       /* 24px - Large body text */
--font-size-text-xl: 1.25rem;       /* 20px - Small headings */
--font-size-text-lg: 1.125rem;      /* 18px - Body text */
--font-size-text-base: 1rem;        /* 16px - Base body text */
--font-size-text-sm: 0.875rem;      /* 14px - Small body text */
--font-size-text-xs: 0.75rem;       /* 12px - Captions */
--font-size-text-2xs: 0.625rem;     /* 10px - Micro text */
```

### Font Weights
```css
--font-weight-thin: 100;
--font-weight-light: 300;
--font-weight-regular: 400;
--font-weight-medium: 500;
--font-weight-semibold: 600;
--font-weight-bold: 700;
--font-weight-extrabold: 800;
--font-weight-black: 900;
```

### Line Heights
```css
--line-height-tight: 1.25;     /* Headlines */
--line-height-normal: 1.5;     /* Body text */
--line-height-relaxed: 1.625;  /* Spacious reading */
--line-height-loose: 2;        /* Form inputs */
```

### Letter Spacing
```css
--letter-spacing-tight: -0.025em;   /* Headlines */
--letter-spacing-normal: 0;         /* Body text */
--letter-spacing-wide: 0.025em;     /* Small caps, buttons */
--letter-spacing-wider: 0.05em;     /* All caps */
--letter-spacing-widest: 0.1em;     /* Special emphasis */
```

## Spacing Tokens

### Space Scale
```css
--space-0: 0;                    /* 0px */
--space-px: 1px;                 /* 1px */
--space-0-5: 0.125rem;           /* 2px */
--space-1: 0.25rem;              /* 4px */
--space-1-5: 0.375rem;           /* 6px */
--space-2: 0.5rem;               /* 8px */
--space-2-5: 0.625rem;           /* 10px */
--space-3: 0.75rem;              /* 12px */
--space-3-5: 0.875rem;           /* 14px */
--space-4: 1rem;                 /* 16px */
--space-5: 1.25rem;              /* 20px */
--space-6: 1.5rem;               /* 24px */
--space-7: 1.75rem;              /* 28px */
--space-8: 2rem;                 /* 32px */
--space-9: 2.25rem;              /* 36px */
--space-10: 2.5rem;              /* 40px */
--space-11: 2.75rem;             /* 44px */
--space-12: 3rem;                /* 48px */
--space-14: 3.5rem;              /* 56px */
--space-16: 4rem;                /* 64px */
--space-18: 4.5rem;              /* 72px */
--space-20: 5rem;                /* 80px */
--space-24: 6rem;                /* 96px */
--space-28: 7rem;                /* 112px */
--space-32: 8rem;                /* 128px */
--space-36: 9rem;                /* 144px */
--space-40: 10rem;               /* 160px */
--space-44: 11rem;               /* 176px */
--space-48: 12rem;               /* 192px */
--space-52: 13rem;               /* 208px */
--space-56: 14rem;               /* 224px */
--space-60: 15rem;               /* 240px */
--space-64: 16rem;               /* 256px */
--space-72: 18rem;               /* 288px */
--space-80: 20rem;               /* 320px */
--space-96: 24rem;               /* 384px */
```

### Spacing Usage Guidelines
- **space-1 to space-3**: Small gaps, borders, icon spacing
- **space-4 to space-6**: Component padding, form spacing
- **space-8 to space-12**: Section spacing, card padding
- **space-16+**: Large layouts, page sections

## Sizing Tokens

### Component Heights
```css
--size-height-xs: 1.5rem;        /* 24px - Small buttons */
--size-height-sm: 2rem;          /* 32px - Small inputs */
--size-height-md: 2.5rem;        /* 40px - Standard inputs/buttons */
--size-height-lg: 3rem;          /* 48px - Large buttons */
--size-height-xl: 3.5rem;        /* 56px - Extra large buttons */
```

### Icon Sizes
```css
--size-icon-xs: 0.75rem;         /* 12px */
--size-icon-sm: 1rem;            /* 16px */
--size-icon-md: 1.25rem;         /* 20px */
--size-icon-lg: 1.5rem;          /* 24px */
--size-icon-xl: 2rem;            /* 32px */
--size-icon-2xl: 2.5rem;         /* 40px */
```

### Border Radius
```css
--radius-none: 0;
--radius-xs: 0.125rem;           /* 2px */
--radius-sm: 0.25rem;            /* 4px */
--radius-md: 0.375rem;           /* 6px */
--radius-lg: 0.5rem;             /* 8px */
--radius-xl: 0.75rem;            /* 12px */
--radius-2xl: 1rem;              /* 16px */
--radius-3xl: 1.5rem;            /* 24px */
--radius-full: 9999px;           /* Fully rounded */
```

### Border Width
```css
--border-width-none: 0;
--border-width-thin: 1px;
--border-width-medium: 2px;
--border-width-thick: 4px;
--border-width-heavy: 8px;
```

## Shadow Tokens

### Elevation Scale
```css
--shadow-none: none;
--shadow-xs: 0 1px 2px 0 rgb(0 0 0 );
--shadow-sm: 0 1px 3px 0 rgb(0 0 0 ), 0 1px 2px -1px rgb(0 0 0 );
--shadow-md: 0 4px 6px -1px rgb(0 0 0 ), 0 2px 4px -2px rgb(0 0 0 );
--shadow-lg: 0 10px 15px -3px rgb(0 0 0 ), 0 4px 6px -4px rgb(0 0 0 );
--shadow-xl: 0 20px 25px -5px rgb(0 0 0 ), 0 8px 10px -6px rgb(0 0 0 );
--shadow-2xl: 0 25px 50px -12px rgb(0 0 0 );
--shadow-inner: inset 0 2px 4px 0 rgb(0 0 0 );
```

### Colored Shadows
```css
--shadow-primary-xs: 0 1px 2px 0 rgb(14 165 233 );
--shadow-primary-sm: 0 1px 3px 0 rgb(14 165 233 ), 0 1px 2px -1px rgb(14 165 233 );
--shadow-primary-md: 0 4px 6px -1px rgb(14 165 233 ), 0 2px 4px -2px rgb(14 165 233 );

--shadow-success-xs: 0 1px 2px 0 rgb(34 197 94 );
--shadow-success-sm: 0 1px 3px 0 rgb(34 197 94 ), 0 1px 2px -1px rgb(34 197 94 );

--shadow-warning-xs: 0 1px 2px 0 rgb(245 158 11 );
--shadow-warning-sm: 0 1px 3px 0 rgb(245 158 11 ), 0 1px 2px -1px rgb(245 158 11 );

--shadow-error-xs: 0 1px 2px 0 rgb(239 68 68 );
--shadow-error-sm: 0 1px 3px 0 rgb(239 68 68 ), 0 1px 2px -1px rgb(239 68 68 );
```

## Animation Tokens

### Duration
```css
--duration-instant: 0ms;
--duration-fast: 150ms;
--duration-normal: 300ms;
--duration-slow: 500ms;
```

### Easing Functions
```css
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
```

### Animation Patterns
```css
--transition-fast: all 150ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-normal: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
--transition-slow: all 500ms cubic-bezier(0.4, 0, 0.2, 1);
```

## Breakpoint Tokens

### Responsive Breakpoints
```css
--breakpoint-xs: 475px;          /* Extra small devices */
--breakpoint-sm: 640px;          ) */
--breakpoint-md: 768px;          ) */
--breakpoint-lg: 1024px;         ) */
--breakpoint-xl: 1280px;         ) */
--breakpoint-2xl: 1536px;        ) */
--breakpoint-3xl: 1920px;        ) */
```

### Container Sizes
```css
--container-xs: 20rem;            /* 320px */
--container-sm: 24rem;            /* 384px */
--container-md: 28rem;            /* 448px */
--container-lg: 32rem;            /* 512px */
--container-xl: 36rem;            /* 576px */
--container-2xl: 42rem;           /* 672px */
--container-3xl: 48rem;           /* 768px */
--container-4xl: 56rem;           /* 896px */
--container-5xl: 64rem;           /* 1024px */
--container-6xl: 72rem;           /* 1152px */
--container-7xl: 80rem;           /* 1280px */
--container-full: 100%;           /* Full width */
```

## Implementation Guidelines

### Token Usage Priority
1. **Design Tokens**: Always use tokens instead of hard-coded values
2. **Semantic Naming**: Use meaningful names that convey purpose
3. **Platform Consistency**: Ensure tokens work across all platforms
4. **Accessibility**: Verify all token combinations meet accessibility standards

### Token Modification Process
1. **Impact Assessment**: Evaluate effects on existing components
2. **Platform Testing**: Test across all supported platforms
3. **Documentation Update**: Update design system documentation
4. **Migration Plan**: Plan rollout and deprecation strategy
5. **Communication**: Notify all stakeholders of changes

### Version Control
- **Semantic Versioning**: Major.Minor.Patch for token changes
- **Deprecation Notices**: Clear timeline for token removal
- **Migration Tools**: Automated migration assistance
- **Rollback Plan**: Ability to revert changes if needed

---

## Related Documents
- [Design System](design-system) - Complete design system overview
- [Component Library](component-library) - Reusable component catalog
- [Accessibility Guidelines](accessibility-guidelines) - Inclusive design standards
- [UI Library](component-library) - Component usage guidelines and patterns

**Keywords**: design tokens, design system, color palette, typography, spacing, shadows, breakpoints, responsive design, accessibility
---
