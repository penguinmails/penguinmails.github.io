---
title: "Layout Components"
description: "Layout and structure components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "layout, grid, container, structure"
---

# Layout Components

## Layout Components

### Container System

```css
/* Container variants */
.container {
  width: 100%;
  max-width: var(--container-max-width);
  margin: 0 auto;
  padding: 0 var(--space-4);
}

.container-fluid {
  width: 100%;
  padding: 0;
}

.container-centered {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}


```

### Grid System

```typescript
interface GridProps {
  columns?: number; // 1-12 columns
  gap?: 'sm' | 'md' | 'lg' | 'xl';
  responsive?: boolean;
  children: React.ReactNode;
}

interface GridItemProps {
  span?: number; // 1-12 column span
  offset?: number; // 0-11 column offset
  order?: number;
  children: React.ReactNode;
}

// Usage
<Grid columns={12} gap="md" responsive>
  <GridItem span={8}>Main Content</GridItem>
  <GridItem span={4}>Sidebar</GridItem>
</Grid>


```

### Flexbox Utilities

```css
/* Flexbox utility classes */
.flex { display: flex; }
.flex-row { flex-direction: row; }
.flex-col { flex-direction: column; }
.flex-wrap { flex-wrap: wrap; }
.flex-nowrap { flex-wrap: nowrap; }

.items-start { align-items: flex-start; }
.items-center { align-items: center; }
.items-end { align-items: flex-end; }

.justify-start { justify-content: flex-start; }
.justify-center { justify-content: center; }
.justify-end { justify-content: flex-end; }
.justify-between { justify-content: space-between; }


```
