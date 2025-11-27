---
title: "UI Library"
description: "Component usage guidelines and implementation patterns for PenguinMails"
last_modified_date: "2025-11-19"
level: "2"
persona: "Documentation Users"
---


# UI Library Guide

## Purpose

The UI Library defines **high-level patterns**, **tech stack recommendations**, and **component requirements** for building PenguinMails. This is a planning document that specifies **what** we need and **how** it should work, using general ideas rather than explicit implementation code.

> **Note**: For detailed component specifications (props, token usage, accessibility), see [Component Library](/docs/design/component-library).

---

## Tech Stack

### Frontend Framework

**Next.js 15** (App Router)

- Server Components by default

- Server Actions for MVP (BFF pattern)

- Progressive migration to REST API calls post-MVP

- File-based routing in `app/` directory

### Styling & Design System

**Tailwind CSS v4** + **shadcn/ui**

- Utility-first CSS framework (v4)

- shadcn/ui for pre-built accessible components

- Custom design tokens in `tailwind.config.ts`

- Global styles in `app/globals.css`

### Form Management

**react-hook-form** + **zod**

- Type-safe form validation

- Schema-based validation with Zod

- Minimal re-renders

- Built-in error handling

**Example Pattern**:

```typescript
// Define schema
const campaignSchema = z.object({
  name: z.string().min(1, "Campaign name required"),
  subject: z.string().min(1, "Subject required"),
  recipients: z.array(z.string().email()).min(1)
});

// Use in form
const form = useForm({
  resolver: zodResolver(campaignSchema)
});


```

### Icons

### lucide-react

- Consistent icon library

- Tree-shakeable

- TypeScript support

- Example: `import { Mail, Send, Users } from 'lucide-react'`

### Animation & Motion

**tw-animate-css** + **CSS Transitions**

- Use `tw-animate-css` for standard animations (fade, slide, bounce)

- Use standard CSS transitions for hover states and micro-interactions

- Avoid heavy JS animation libraries like Framer Motion unless absolutely necessary for complex gestures

### Dark Mode

**Tailwind Dark Mode** (`selector` strategy)

- Use `darkMode: 'selector'` in Tailwind config

- Toggle class `dark` on the `<html>` element

- Use `dark:` prefix for dark mode styles (e.g., `bg-white dark:bg-slate-900`)

### State Management

**React Context** (for simple global state)

- Theme preferences

- User session

- Feature flags

**Zustand** (for complex state, if needed)

- Campaign editor state

- Multi-step form state

### Data Fetching

**MVP**: Server Actions (Next.js 15)

```typescript
'use server';
export async function getCampaigns() {
  const data = await db.campaigns.findMany();
  return data;
}


```

**Post-MVP**: REST API with fetch/axios

```typescript
const campaigns = await fetch('/api/v1/campaigns').then(r => r.json());


```

---

## Component Requirements

### Data Tables

**Requirement**: Two variants needed

1. **Realtime DataTable**

   - Live updates via WebSocket/Server-Sent Events

   - Use case: Campaign sending status, live analytics

   - Features: Auto-refresh, optimistic updates

2. **Paginated DataTable**

   - Server-side pagination

   - Use case: Campaign history, recipient lists

   - Features: Sorting, filtering, search

**Recommended Library**: `@tanstack/react-table` (headless, flexible)

### Forms

**Pattern**: shadcn/ui + react-hook-form + zod

**Requirements**:

- All forms must use Zod schemas for validation

- Error messages must be user-friendly

- Support for multi-step forms (campaign creation wizard)

- Auto-save drafts for long forms

**Example Structure**:

```typescript
// 1. Define schema
const schema = z.object({ /* ... */ });

// 2. Create form
const form = useForm({ resolver: zodResolver(schema) });

// 3. Use shadcn Form components
<Form {...form}>
  <FormField name="email" />
</Form>


```

### Modals & Dialogs

**Pattern**: shadcn/ui Dialog component

**Requirements**:

- Accessible (ARIA, keyboard navigation)

- Backdrop click to close (configurable)

- Escape key to close

- Focus trap within modal

- Sizes: sm, md, lg, xl, full

**Use Cases**:

- Confirmation dialogs (delete campaign)

- Multi-step wizards (campaign setup)

- Detail views (recipient details)

### Notifications

**Pattern**: shadcn/ui Toast (using sonner)

**Requirements**:

- Position: top-right (default)

- Auto-dismiss: 3s (success), 5s (error), manual (warning)

- Action buttons for undo/retry

- Stack multiple toasts

**Example**:

```typescript
import { toast } from 'sonner';

toast.success('Campaign sent!', {
  action: { label: 'View', onClick: () => navigate('/campaigns/123') }
});


```

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

{% raw %}

```jsx
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
    onClick: () => navigate('/settings)
  }}
  dismissible
/>
```

{% endraw %}

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
    onClick: () => navigate(`/campaigns)
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
    render(<Button>Click me<);
    expect(screen.getByRole('button', { name: /click me)).toBeInTheDocument();
  });

  it('handles click events', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click me<);

    fireEvent.click(screen.getByRole('button', { name: /click me));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(<Button loading>Submit<);
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

- Log errors to monitoring service (Sentry)

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

## Authentication & Authorization Patterns

### Protected Routes

**Pattern**: Middleware-based route protection

**Requirements**:

- Check authentication in Next.js middleware

- Redirect to login if unauthenticated

- Check role permissions for restricted routes

- Store session in httpOnly cookies

### Role-Based UI Rendering

**Pattern**: Conditional rendering based on user roles

**Example**:

```typescript
import { useSession } from '@/lib/auth';

function Dashboard() {
  const { user } = useSession();
  
  return (
    <>
      {user.roles.includes('admin') && <AdminPanel />}
      {user.roles.includes('customer') && <CampaignDashboard />}
      {user.roles.includes('agency') && <AgencyCommandCenter />}
    </>
  );
}


```

---

## Data Visualization

### Charts & Graphs

**Recommended Library**: **Recharts** (React-friendly, declarative)

**Requirements**:

- Responsive charts (adapt to container width)

- Accessible (ARIA labels, keyboard navigation)

- Consistent color palette (use design tokens)

- Interactive tooltips

**Chart Types Needed**:

- Line charts: Campaign performance over time

- Bar charts: Comparative metrics

- Pie/Donut charts: Distribution (open rate, click rate)

- Area charts: Cumulative metrics

### Real-time Updates

**Pattern**: Server-Sent Events (SSE) or WebSockets

**Use Cases**:

- Live campaign sending status

- Real-time analytics updates

- Notification feed

**Implementation**:

```typescript
// Server-Sent Events for one-way updates
const eventSource = new EventSource('/api/campaigns/123/live');
eventSource.onmessage = (event) => {
  const data = JSON.parse(event.data);
  updateCampaignMetrics(data);
};


```

---

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
