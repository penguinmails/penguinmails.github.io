---
title: UI Library
nav_order: 17
has_children: false
description: "Component usage guidelines and implementation patterns for PenguinMails"
---

# UI Library Guide

## Purpose

The UI Library provides a comprehensive catalog of reusable components, patterns, and guidelines for building consistent user interfaces across PenguinMails. This guide ensures design system implementation and maintains visual consistency while supporting scalable development.

## Component Architecture

### Component Categories
- **Layout Components**: Grid systems, containers, spacing utilities
- **Form Components**: Input fields, selectors, validation states
- **Navigation Components**: Menus, breadcrumbs, tabs, pagination
- **Feedback Components**: Alerts, toasts, progress indicators, modals
- **Data Display**: Tables, cards, badges, avatars, charts
- **Interactive Elements**: Buttons, links, dropdowns, tooltips

### Component Structure
```typescript
interface BaseComponentProps {
  className?: string;
  style?: React.CSSProperties;
  'data-testid'?: string; // Testing support
  children?: React.ReactNode;
}

// Consistent component pattern
interface ComponentProps extends BaseComponentProps {
  // Component-specific props
  variant?: 'primary' | 'secondary' | 'tertiary';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
}

// Usage example
<Button
  variant="primary"
  size="md"
  disabled={false}
  loading={false}
  onClick={handleClick}
  data-testid="submit-button"
>
  Submit Form
</Button>
```

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

## Button Components

### Button Variants
```typescript
type ButtonVariant = 'primary' | 'secondary' | 'tertiary' | 'danger' | 'success';
type ButtonSize = 'xs' | 'sm' | 'md' | 'lg' | 'xl';

interface ButtonProps {
  variant?: ButtonVariant;
  size?: ButtonSize;
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
  icon?: React.ComponentType;
  iconPosition?: 'left' | 'right';
  onClick: () => void;
  children: React.ReactNode;
}

// Component usage examples
<Button variant="primary" size="md" onClick={handleSubmit}>
  Create Campaign
</Button>

<Button variant="secondary" size="sm" icon={PlusIcon} onClick={handleAdd}>
  Add Item
</Button>

<Button variant="danger" size="md" loading={isDeleting} onClick={handleDelete}>
  Delete Account
</Button>
```

### Button Group Pattern
```typescript
interface ButtonGroupProps {
  variant?: 'segmented' | 'attached';
  size?: ButtonSize;
  disabled?: boolean;
  children: React.ReactElement<ButtonProps>[];
}

// Usage for mutually exclusive options
<ButtonGroup variant="segmented">
  <Button>Daily</Button>
  <Button active>Weekly</Button>
  <Button>Monthly</Button>
</ButtonGroup>
```

## Form Components

### Input Field Variants
```typescript
interface InputProps {
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url';
  size?: 'sm' | 'md' | 'lg';
  variant?: 'default' | 'error' | 'success';
  disabled?: boolean;
  required?: boolean;
  placeholder?: string;
  label?: string;
  helperText?: string;
  errorMessage?: string;
  leftIcon?: React.ComponentType;
  rightIcon?: React.ComponentType;
  onChange: (value: string) => void;
  onBlur?: () => void;
  onFocus?: () => void;
}
```

```jsx
// Usage with validation
const [email, setEmail] = useState('');
const [emailError, setEmailError] = useState('');

<Input
  type="email"
  label="Email Address"
  placeholder="Enter your email"
  value={email}
  onChange={setEmail}
  onBlur={() => validateEmail(email, setEmailError)}
  errorMessage={emailError}
  required
/>
```

### Select Components
```typescript
interface SelectOption {
  value: string | number;
  label: string;
  disabled?: boolean;
  group?: string;
}

interface SelectProps {
  options: SelectOption[];
  value?: string | number;
  placeholder?: string;
  multiple?: boolean;
  searchable?: boolean;
  clearable?: boolean;
  loading?: boolean;
  disabled?: boolean;
  size?: 'sm' | 'md' | 'lg';
  onChange: (value: string | number | (string | number)[]) => void;
}

// Usage
<Select
  options={[
    { value: 'us', label: 'United States' },
    { value: 'ca', label: 'Canada' },
    { value: 'uk', label: 'United Kingdom' }
  ]}
  placeholder="Select country"
  onChange={(value) => setCountry(value)}
/>
```

### Form Validation Patterns
```typescript
interface ValidationRule {
  type: 'required' | 'email' | 'minLength' | 'maxLength' | 'pattern';
  value?: any;
  message: string;
}

interface FormFieldProps {
  name: string;
  rules?: ValidationRule[];
  children: (field: FieldProps) => React.ReactNode;
}

interface FieldProps {
  value: any;
  error?: string;
  touched: boolean;
  onChange: (value: any) => void;
  onBlur: () => void;
}

// Form field wrapper
const FormField = ({ name, rules, children }: FormFieldProps) => {
  const { register, errors, touchedFields } = useFormContext();

  const field = register(name, { rules });
  const error = errors[name]?.message;
  const touched = touchedFields[name];

  return children({
    ...field,
    error,
    touched: !!touched
  });
};
```

## Data Display Components

### Table Component
```typescript
interface TableColumn<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  filterable?: boolean;
  width?: string | number;
  render?: (value: any, row: T) => React.ReactNode;
}

interface TableProps<T> {
  data: T[];
  columns: TableColumn<T>[];
  loading?: boolean;
  selectable?: boolean;
  pagination?: boolean;
  pageSize?: number;
  onSort?: (key: keyof T, direction: 'asc' | 'desc') => void;
  onSelect?: (selectedRows: T[]) => void;
  onPageChange?: (page: number) => void;
}

// Usage
<Table
  data={campaigns}
  columns={[
    { key: 'name', header: 'Campaign Name', sortable: true },
    { key: 'status', header: 'Status', render: renderStatusBadge },
    { key: 'sent', header: 'Emails Sent', sortable: true },
    { key: 'openRate', header: 'Open Rate', sortable: true, render: formatPercentage }
  ]}
  pagination
  pageSize={25}
  selectable
  onSelect={handleSelection}
/>
```

### Card Component
```typescript
interface CardProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  size?: 'sm' | 'md' | 'lg';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  hoverable?: boolean;
  clickable?: boolean;
  fullWidth?: boolean;
  onClick?: () => void;
  header?: React.ReactNode;
  footer?: React.ReactNode;
  children: React.ReactNode;
}

// Usage
<Card variant="elevated" hoverable clickable onClick={handleCardClick}>
  <CardHeader>
    <Avatar src={user.avatar} />
    <div>
      <h3>{campaign.name}</h3>
      <p>{campaign.description}</p>
    </div>
  </CardHeader>
  <div className="card-metrics">
    <Metric label="Sent" value={campaign.sent} />
    <Metric label="Opens" value={campaign.opens} />
    <Metric label="Clicks" value={campaign.clicks} />
  </div>
</Card>
```

## Feedback Components

### Alert Component
```typescript
type AlertVariant = 'info' | 'success' | 'warning' | 'error';

interface AlertProps {
  variant: AlertVariant;
  title?: string;
  message: string;
  dismissible?: boolean;
  action?: {
    label: string;
    onClick: () => void;
  };
  icon?: React.ComponentType;
  onDismiss?: () => void;
}

// Usage
<Alert
  variant="warning"
  title="Action Required"
  message="Your Stripe account setup is incomplete."
  action={{
    label: "Complete Setup",
    onClick: () => navigate('/settings/billing')
  }}
  dismissible
/>
```

### Toast Notifications
```typescript
interface ToastProps {
  id: string;
  variant: AlertVariant;
  title?: string;
  message: string;
  duration?: number; // Auto-hide duration in ms
  persistent?: boolean; // Requires manual dismissal
  action?: {
    label: string;
    onClick: () => void;
  };
}

interface ToastContainerProps {
  position?: 'top-right' | 'top-left' | 'bottom-right' | 'bottom-left' | 'top-center';
  maxToasts?: number;
}

// Toast manager usage
const toast = useToast();

toast.success({
  title: "Campaign Created",
  message: "Your campaign has been successfully created and scheduled.",
  action: {
    label: "View Campaign",
    onClick: () => navigate(`/campaigns/${campaignId}`)
  }
});
```

### Modal Component
```typescript
interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  description?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  closable?: boolean;
  footer?: React.ReactNode;
  children: React.ReactNode;
}
```

```javascript
// Usage
<Modal
  isOpen={showDeleteModal}
  onClose={() => setShowDeleteModal(false)}
  title="Delete Campaign"
  description="This action cannot be undone."
  footer={
    <>
      <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>
        Cancel
      </Button>
      <Button variant="danger" onClick={handleDelete}>
        Delete Campaign
      </Button>
    </>
  }
>
  <p>Are you sure you want to delete "{campaignName}"? This will permanently remove all associated data.</p>
</Modal>
```

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

## Utility Components

### Loading States
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
```typescript
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
    onClick: () => navigate('/campaigns/new')
  }}
/>
```

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

## Component Development Guidelines

### Component Structure
```typescript
// components/Button/Button.tsx
import React from 'react';
import { cn } from '@/lib/utils';
import './Button.css';

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'tertiary';
  size?: 'sm' | 'md' | 'lg';
  loading?: boolean;
  fullWidth?: boolean;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(({
  className,
  variant = 'primary',
  size = 'md',
  loading = false,
  fullWidth = false,
  disabled,
  children,
  ...props
}, ref) => {
  return (
    <button
      ref={ref}
      className={cn(
        'button',
        `button--${variant}`,
        `button--${size}`,
        {
          'button--loading': loading,
          'button--full-width': fullWidth,
          'button--disabled': disabled || loading
        },
        className
      )}
      disabled={disabled || loading}
      {...props}
    >
      {loading && <Spinner size="sm" />}
      <span className="button__content">{children}</span>
    </button>
  );
});

Button.displayName = 'Button';
```

### Component Testing
```typescript
// components/Button/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders with default props', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument();
  });

  it('handles click events', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me</Button>);

    fireEvent.click(screen.getByRole('button', { name: /click me/i }));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button loading>Submit</Button>);
    expect(screen.getByRole('button')).toBeDisabled();
    expect(screen.getByTestId('spinner')).toBeInTheDocument();
  });
});
```

### Component Documentation
```typescript
// components/Button/Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Components/Button',
  component: Button,
  parameters: {
    docs: {
      description: {
        component: 'A versatile button component with multiple variants and states.'
      }
    }
  },
  argTypes: {
    variant: {
      control: { type: 'select' },
      options: ['primary', 'secondary', 'tertiary'],
      description: 'The visual style of the button'
    },
    size: {
      control: { type: 'select' },
      options: ['sm', 'md', 'lg'],
      description: 'The size of the button'
    },
    loading: {
      control: 'boolean',
      description: 'Shows a loading spinner and disables the button'
    }
  }
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    variant: 'primary',
    children: 'Primary Button'
  }
};

export const Loading: Story = {
  args: {
    variant: 'primary',
    loading: true,
    children: 'Loading...'
  }
};
```

---

## Related Documents
- [Component Library](component-library.md) - Reusable component catalog
- [Design System](design-system.md) - Complete design system overview
- [Design Tokens](design-tokens.md) - Design token specifications
- [Accessibility Guidelines](accessibility-guidelines.md) - Inclusive design standards

**Keywords**: UI library, component library, design system, reusable components, React components, component patterns, design tokens, accessibility