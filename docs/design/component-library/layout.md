---
title: "Layout Components"
description: "Structural UI components: Container, Grid, and GridItem."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

## Layout Components

### Container

```typescript
import { Container } from '@/components/layout/Container';

interface ContainerProps {
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  padding?: 'none' | 'sm' | 'md' | 'lg' | 'xl';
  centered?: boolean;
  children: React.ReactNode;
}

// Usage Examples
<Container size="lg" padding="md">
  <h1>Main Content</h1>
  <p>Container with large max-width and medium padding</p>
</Container>

<Container size="full" centered padding="none">
  <HeroSection />
</Container>
```

**Size Specifications:**

- sm: 640px max-width
- md: 768px max-width
- lg: 1024px max-width
- xl: 1280px max-width
- full: 100% width

### Grid & GridItem

```typescript
import { Grid, GridItem } from '@/components/layout/Grid';

interface GridProps {
  columns?: number; // 1-12
  gap?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  responsive?: boolean;
  children: React.ReactNode;
}

interface GridItemProps {
  span?: number; // 1-12 columns to span
  offset?: number; // 0-11 columns to offset
  order?: number;
  children: React.ReactNode;
}

// Usage Example
<Grid columns={12} gap="md" responsive>
  <GridItem span={8}>
    <MainContent />
  </GridItem>
  <GridItem span={4}>
    <Sidebar />
  </GridItem>
</Grid>
```

**Responsive Breakpoints:**

- Mobile: 1 column (span resets to 12)
- Tablet: 8 columns max
- Desktop: 12 columns max
