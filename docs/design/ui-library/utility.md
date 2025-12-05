---
title: "Utility Components"
description: "Utility and helper components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "utility, helpers, tools"
---

# Utility Components

## Utility Components

### Loading States

{% raw %}

```typescript
interface LoadingProps {
  size?: 'xs' | 'sm' | 'md' | 'lg';
  variant?: 'spinner' | 'dots' | 'pulse' | 'skeleton';
  color?: string;
  overlay?: boolean;
  text?: string;
}

// Usage variants
<Loading size="md" variant="spinner" />
<Loading variant="skeleton" />
<Loading variant="dots" text="Saving changes..." />


```

### Empty States

```jsx
interface EmptyStateProps {
  icon?: React.ComponentType;
  title: string;
  description?: string;
  action?: {
    label: string;
    onClick: () => void;
  };
  size?: 'sm' | 'md' | 'lg';
}

// Usage
<EmptyState
  icon={InboxIcon}
  title="No campaigns yet"
  description="Create your first email campaign to get started."
  action={{
    label: "Create Campaign",
    onClick: () => navigate('/campaigns)
  }}
/>
```

{% endraw %}

### Badge Component

```typescript
interface BadgeProps {
  variant?: 'default' | 'success' | 'warning' | 'error' | 'info';
  size?: 'sm' | 'md';
  rounded?: boolean;
  dot?: boolean; // Just show colored dot
  children: React.ReactNode;
}

// Usage
<Badge variant="success">Active</Badge>
<Badge variant="warning" size="sm">Pending</Badge>
<Badge variant="error" dot /> {/* Just colored dot */}


```
