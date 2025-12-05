---
title: "Navigation Components"
description: "Navigation components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "navigation, menu, routing"
---

# Navigation Components

## Navigation Components

### Breadcrumb Component

```typescript
interface BreadcrumbItem {
  label: string;
  href?: string;
  current?: boolean;
}

interface BreadcrumbProps {
  items: BreadcrumbItem[];
  separator?: React.ComponentType;
  maxItems?: number; // Show ellipsis for long paths
}

// Usage
<Breadcrumb
  items={[
    { label: 'Dashboard', href: '/dashboard' },
    { label: 'Campaigns', href: '/campaigns' },
    { label: 'Summer Sale 2025', current: true }
  ]}
/>


```

### Tab Component

```typescript
interface TabItem {
  id: string;
  label: string;
  icon?: React.ComponentType;
  badge?: string | number;
  disabled?: boolean;
}

interface TabsProps {
  tabs: TabItem[];
  activeTab: string;
  variant?: 'default' | 'pills' | 'underline';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  onChange: (tabId: string) => void;
}

// Usage
<Tabs
  tabs={[
    { id: 'overview', label: 'Overview', icon: DashboardIcon },
    { id: 'performance', label: 'Performance', badge: 'New' },
    { id: 'settings', label: 'Settings' }
  ]}
  activeTab={activeTab}
  onChange={setActiveTab}
/>


```
