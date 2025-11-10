---
title: Component Library
nav_order: 16
has_children: false
description: "Complete catalog of reusable UI components for PenguinMails"
---

# Component Library

## Purpose

The Component Library is a comprehensive catalog of all reusable UI components available in PenguinMails. This document serves as the single source of truth for component specifications, usage patterns, and implementation details, ensuring consistent design and development practices across the platform.

## Library Structure

### Component Organization
```
📁 components/
├── 📁 primitives/          # Base components (Button, Input, etc.)
├── 📁 layout/             # Layout components (Grid, Container, etc.)
├── 📁 navigation/         # Navigation components (NavBar, Breadcrumbs, etc.)
├── 📁 forms/              # Form components (FormField, Select, etc.)
├── 📁 data-display/       # Data display (Table, Card, Chart, etc.)
├── 📁 feedback/           # Feedback components (Alert, Toast, Modal, etc.)
├── 📁 overlays/           # Overlay components (Tooltip, Popover, etc.)
└── 📁 utilities/          # Utility components (Loading, EmptyState, etc.)
```

### Component Maturity Levels
- **Technical Experimental**: New components under development
- **Completed Stable**: Production-ready components with full test coverage
- **🔒 Deprecated**: Components scheduled for removal (with migration guides)
- **🚫 Removed**: Components no longer available

## Primitives

### Button
```typescript
import { Button } from '@/components/primitives/Button';

interface ButtonProps {
  variant: 'primary' | 'secondary' | 'tertiary' | 'danger' | 'success';
  size: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  disabled?: boolean;
  loading?: boolean;
  fullWidth?: boolean;
  icon?: React.ComponentType<{ className?: string }>;
  iconPosition?: 'left' | 'right';
  children: React.ReactNode;
  onClick: () => void;
}

// Usage Examples
<Button variant="primary" size="md" onClick={handleSubmit}>
  Create Campaign
</Button>

<Button variant="secondary" icon={PlusIcon} iconPosition="left">
  Add Recipient
</Button>

<Button variant="danger" size="sm" loading={isDeleting}>
  Delete
</Button>
```

**Design Specifications:**
- Height: 32px (sm), 40px (md), 48px (lg)
- Border radius: 6px (sm/md), 8px (lg)
- Font weight: 500 (regular), 600 (bold for primary)
- Focus ring: 2px solid primary color, 2px offset

### Input
```typescript
import { Input } from '@/components/primitives/Input';

interface InputProps {
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url' | 'search';
  size?: 'sm' | 'md' | 'lg';
  variant?: 'default' | 'error' | 'success';
  disabled?: boolean;
  required?: boolean;
  readOnly?: boolean;
  placeholder?: string;
  value: string;
  onChange: (value: string) => void;
  onBlur?: () => void;
  onFocus?: () => void;
  leftIcon?: React.ComponentType;
  rightIcon?: React.ComponentType;
  helperText?: string;
  errorMessage?: string;
}

// Usage Example
<Input
  type="email"
  placeholder="Enter your email address"
  value={email}
  onChange={setEmail}
  onBlur={() => validateEmail(email)}
  errorMessage={emailError}
  leftIcon={MailIcon}
  required
/>
```

**Design Specifications:**
- Height: 32px (sm), 40px (md), 48px (lg)
- Border: 1px solid neutral-300 (default)
- Border radius: 6px
- Padding: 8px 12px (sm), 12px 16px (md), 16px 20px (lg)
- Font size: 14px (sm), 16px (md), 18px (lg)

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

## Form Components

### FormField
```typescript
import { FormField } from '@/components/forms/FormField';

interface FormFieldProps {
  label?: string;
  required?: boolean;
  helperText?: string;
  errorMessage?: string;
  disabled?: boolean;
  children: React.ReactNode;
}

// Usage Example
<FormField
  label="Campaign Name"
  required
  helperText="Choose a descriptive name for your campaign"
  errorMessage={errors.name}
>
  <Input
    value={campaignName}
    onChange={setCampaignName}
    placeholder="e.g., Summer Sale 2025"
  />
</FormField>
```

### Select
```typescript
import { Select } from '@/components/forms/Select';

interface SelectOption {
  value: string | number;
  label: string;
  disabled?: boolean;
  icon?: React.ComponentType;
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

// Usage Example
<Select
  options={[
    { value: 'draft', label: 'Draft', icon: EditIcon },
    { value: 'scheduled', label: 'Scheduled', icon: CalendarIcon },
    { value: 'sending', label: 'Sending', icon: SendIcon },
    { value: 'completed', label: 'Completed', icon: CheckIcon }
  ]}
  value={status}
  placeholder="Select campaign status"
  onChange={(value) => setStatus(value as string)}
/>
```

### Checkbox & Radio
```typescript
import { Checkbox, Radio, RadioGroup } from '@/components/forms/Checkbox';

interface CheckboxProps {
  checked: boolean;
  disabled?: boolean;
  label?: string;
  helperText?: string;
  onChange: (checked: boolean) => void;
}

interface RadioGroupProps {
  value: string;
  onChange: (value: string) => void;
  disabled?: boolean;
  children: React.ReactNode;
}

// Usage Examples
<Checkbox
  checked={agreeToTerms}
  onChange={setAgreeToTerms}
  label="I agree to the Terms of Service"
  helperText="You must agree to continue"
/>

<RadioGroup value={planType} onChange={setPlanType}>
  <Radio value="starter" label="Starter Plan" />
  <Radio value="professional" label="Professional Plan" />
  <Radio value="enterprise" label="Enterprise Plan" />
</RadioGroup>
```

## Data Display Components

### Table
```typescript
import { Table } from '@/components/data-display/Table';

interface TableColumn<T> {
  key: keyof T;
  header: string;
  sortable?: boolean;
  filterable?: boolean;
  width?: string | number;
  align?: 'left' | 'center' | 'right';
  render?: (value: any, row: T) => React.ReactNode;
}

interface TableProps<T> {
  data: T[];
  columns: TableColumn<T>[];
  loading?: boolean;
  selectable?: boolean;
  pagination?: boolean;
  pageSize?: number;
  emptyState?: React.ReactNode;
  onSort?: (key: keyof T, direction: 'asc' | 'desc') => void;
  onSelect?: (selectedRows: T[]) => void;
  onRowClick?: (row: T) => void;
}

// Usage Example
<Table
  data={campaigns}
  columns={[
    {
      key: 'name',
      header: 'Campaign Name',
      sortable: true,
      render: (value, row) => (
        <Link to={`/campaigns/${row.id}`}>{value}</Link>
      )
    },
    {
      key: 'status',
      header: 'Status',
      filterable: true,
      render: (value) => <StatusBadge status={value} />
    },
    {
      key: 'sent',
      header: 'Sent',
      sortable: true,
      align: 'right'
    },
    {
      key: 'openRate',
      header: 'Open Rate',
      sortable: true,
      align: 'right',
      render: (value) => `${(value * 100).toFixed(1)}%`
    }
  ]}
  pagination
  pageSize={25}
  selectable
  onSelect={handleSelection}
  onRowClick={handleRowClick}
/>
```

### Card
```typescript
import { Card, CardHeader, CardContent, CardFooter } from '@/components/data-display/Card';

interface CardProps {
  variant?: 'default' | 'elevated' | 'outlined' | 'filled';
  size?: 'sm' | 'md' | 'lg';
  padding?: 'none' | 'sm' | 'md' | 'lg';
  hoverable?: boolean;
  clickable?: boolean;
  fullWidth?: boolean;
  onClick?: () => void;
  children: React.ReactNode;
}

// Usage Example
<Card variant="elevated" hoverable clickable onClick={handleCardClick}>
  <CardHeader>
    <Avatar src={campaign.creator.avatar} size="md" />
    <div>
      <h3 className="card-title">{campaign.name}</h3>
      <p className="card-subtitle">{campaign.description}</p>
    </div>
    <Badge variant={campaign.status.variant}>
      {campaign.status.label}
    </Badge>
  </CardHeader>

  <CardContent>
    <div className="metrics-grid">
      <Metric label="Recipients" value={campaign.recipientCount} />
      <Metric label="Open Rate" value={`${campaign.openRate}%`} />
      <Metric label="Click Rate" value={`${campaign.clickRate}%`} />
    </div>
  </CardContent>

  <CardFooter>
    <Button variant="secondary" size="sm">
      View Details
    </Button>
    <Button variant="primary" size="sm">
      Edit Campaign
    </Button>
  </CardFooter>
</Card>
```

## Feedback Components

### Alert
```typescript
import { Alert } from '@/components/feedback/Alert';

interface AlertProps {
  variant: 'info' | 'success' | 'warning' | 'error';
  title?: string;
  message: string;
  dismissible?: boolean;
  action?: {
    label: string;
    onClick: () => void;
    variant?: 'primary' | 'secondary';
  };
  icon?: React.ComponentType;
  onDismiss?: () => void;
}

// Usage Examples
<Alert
  variant="warning"
  title="Action Required"
  message="Your Stripe account setup is incomplete. Complete setup to start accepting payments."
  action={{
    label: "Complete Setup",
    onClick: () => navigate('/settings/billing')
  }}
  dismissible
/>

<Alert
  variant="success"
  message="Campaign sent successfully! Check your analytics for performance details."
/>
```

### Toast
```typescript
import { useToast } from '@/components/feedback/Toast';

interface ToastOptions {
  variant?: 'info' | 'success' | 'warning' | 'error';
  title?: string;
  message: string;
  duration?: number;
  persistent?: boolean;
  action?: {
    label: string;
    onClick: () => void;
  };
}

// Usage with Hook
const toast = useToast();

const handleSave = async () => {
  try {
    await saveCampaign(campaignData);
    toast.success({
      title: "Campaign Saved",
      message: "Your campaign has been saved successfully.",
      action: {
        label: "View Campaign",
        onClick: () => navigate(`/campaigns/${campaignId}`)
      }
    });
  } catch (error) {
    toast.error({
      title: "Save Failed",
      message: "Unable to save campaign. Please try again.",
      persistent: true
    });
  }
};
```

### Modal
```typescript
import { Modal } from '@/components/feedback/Modal';

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title?: string;
  description?: string;
  size?: 'sm' | 'md' | 'lg' | 'xl' | 'full';
  closable?: boolean;
  closeOnOverlayClick?: boolean;
  closeOnEscape?: boolean;
  footer?: React.ReactNode;
  children: React.ReactNode;
}

// Usage Example
<Modal
  isOpen={showDeleteModal}
  onClose={() => setShowDeleteModal(false)}
  title="Delete Campaign"
  description="This action cannot be undone. All campaign data will be permanently removed."
  size="md"
  footer={
    <div className="modal-footer-actions">
      <Button variant="secondary" onClick={() => setShowDeleteModal(false)}>
        Cancel
      </Button>
      <Button variant="danger" onClick={handleDelete} loading={isDeleting}>
        Delete Campaign
      </Button>
    </div>
  }
>
  <div className="delete-confirmation">
    <p>Are you sure you want to delete <strong>"{campaignName}"</strong>?</p>
    <ul className="delete-consequences">
      <li>All email data will be permanently removed</li>
      <li>Analytics and reports will be deleted</li>
      <li>Recipients will no longer receive campaign emails</li>
    </ul>
  </div>
</Modal>
```

## Navigation Components

### Breadcrumb
```typescript
import { Breadcrumb } from '@/components/navigation/Breadcrumb';

interface BreadcrumbItem {
  label: string;
  href?: string;
  icon?: React.ComponentType;
  current?: boolean;
}

interface BreadcrumbProps {
  items: BreadcrumbItem[];
  separator?: React.ComponentType;
  maxItems?: number;
  collapsible?: boolean;
}

// Usage Example
<Breadcrumb
  items={[
    { label: 'Dashboard', href: '/dashboard', icon: HomeIcon },
    { label: 'Campaigns', href: '/campaigns' },
    { label: 'Summer Sale 2025', current: true }
  ]}
  maxItems={5}
/>
```

### Tabs
```typescript
import { Tabs } from '@/components/navigation/Tabs';

interface TabItem {
  id: string;
  label: string;
  icon?: React.ComponentType;
  badge?: string | number;
  disabled?: boolean;
  content?: React.ReactNode;
}

interface TabsProps {
  tabs: TabItem[];
  activeTab: string;
  variant?: 'default' | 'pills' | 'underline' | 'buttons';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  lazy?: boolean; // Load tab content only when activated
  onChange: (tabId: string) => void;
}

// Usage Example
<Tabs
  tabs={[
    {
      id: 'overview',
      label: 'Overview',
      icon: DashboardIcon,
      content: <CampaignOverview campaign={campaign} />
    },
    {
      id: 'performance',
      label: 'Performance',
      badge: 'New',
      content: <CampaignPerformance campaign={campaign} />
    },
    {
      id: 'recipients',
      label: 'Recipients',
      content: <CampaignRecipients campaign={campaign} />
    },
    {
      id: 'settings',
      label: 'Settings',
      icon: SettingsIcon,
      content: <CampaignSettings campaign={campaign} />
    }
  ]}
  activeTab={activeTab}
  variant="underline"
  onChange={setActiveTab}
/>
```

## Utility Components

### Loading
```typescript
import { Loading, Skeleton } from '@/components/utilities/Loading';

interface LoadingProps {
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl';
  variant?: 'spinner' | 'dots' | 'pulse' | 'bars';
  color?: string;
  overlay?: boolean;
  text?: string;
  showText?: boolean;
}

interface SkeletonProps {
  variant?: 'text' | 'rectangular' | 'circular';
  width?: string | number;
  height?: string | number;
  animation?: 'pulse' | 'wave' | false;
}

// Usage Examples
<Loading size="md" variant="spinner" text="Saving changes..." />

<Skeleton variant="rectangular" width="100%" height={200} />
<Skeleton variant="text" width="60%" />
<Skeleton variant="circular" width={40} height={40} />
```

### EmptyState
```typescript
import { EmptyState } from '@/components/utilities/EmptyState';

interface EmptyStateProps {
  icon?: React.ComponentType;
  title: string;
  description?: string;
  size?: 'sm' | 'md' | 'lg';
  action?: {
    label: string;
    onClick: () => void;
    variant?: 'primary' | 'secondary';
    icon?: React.ComponentType;
  };
  secondaryAction?: {
    label: string;
    onClick: () => void;
  };
}

// Usage Example
<EmptyState
  icon={InboxIcon}
  title="No campaigns yet"
  description="Create your first email campaign to get started with automated outreach."
  action={{
    label: "Create Campaign",
    variant: "primary",
    icon: PlusIcon,
    onClick: () => navigate('/campaigns/new')
  }}
  secondaryAction={{
    label: "Learn More",
    onClick: () => openTutorial('creating-campaigns')
  }}
/>
```

### Badge
```typescript
import { Badge } from '@/components/utilities/Badge';

interface BadgeProps {
  variant?: 'default' | 'success' | 'warning' | 'error' | 'info' | 'neutral';
  size?: 'xs' | 'sm' | 'md';
  rounded?: boolean;
  dot?: boolean;
  icon?: React.ComponentType;
  children: React.ReactNode;
}

// Usage Examples
<Badge variant="success">Active</Badge>
<Badge variant="warning" size="sm">Pending</Badge>
<Badge variant="error" dot /> {/* Status dot only */}
<Badge variant="info" icon={InfoIcon}>New Feature</Badge>
```

## Component Status and Roadmap

### Current Component Status

| Component | Status | Version | Last Updated |
|-----------|--------|---------|--------------|
| Button | Completed Stable | 2.1.0 | Oct 2025 |
| Input | Completed Stable | 2.0.3 | Oct 2025 |
| Select | Completed Stable | 1.8.2 | Oct 2025 |
| Table | Completed Stable | 2.2.1 | Oct 2025 |
| Modal | Completed Stable | 1.9.0 | Oct 2025 |
| Card | Completed Stable | 1.7.1 | Sep 2025 |
| Alert | Completed Stable | 1.6.0 | Sep 2025 |
| Tabs | Completed Stable | 1.5.2 | Aug 2025 |
| Tooltip | Completed Stable | 1.4.1 | Jul 2025 |

### Upcoming Components
- **DatePicker**: Advanced date selection with calendar
- **TimePicker**: Time selection with timezone support
- **ColorPicker**: Color selection for email templates
- **FileUpload**: Drag-and-drop file upload with progress
- **Stepper**: Multi-step process indicator
- **Accordion**: Collapsible content sections

### Component Deprecations
- **LegacyButton**: Deprecated in favor of new Button component
- **OldModal**: Deprecated, migrate to new Modal component by Dec 2025
- **BasicTable**: Deprecated, use enhanced Table component

## Implementation Guidelines

### Import Patterns
```typescript
// Preferred: Import specific components
import { Button, Input, Modal } from '@/components';

// Alternative: Import with alias for complex components
import { Table as DataTable } from '@/components/data-display/Table';
import { Chart as AnalyticsChart } from '@/components/data-display/Chart';
```

### Component Composition
```typescript
// Good: Compose components logically
<Card>
  <CardHeader>
    <Avatar src={user.avatar} />
    <div>
      <h3>{user.name}</h3>
      <p>{user.role}</p>
    </div>
  </CardHeader>
  <CardContent>
    <p>{user.bio}</p>
  </CardContent>
  <CardFooter>
    <Button variant="secondary">View Profile</Button>
    <Button variant="primary">Send Message</Button>
  </CardFooter>
</Card>

// Avoid: Over-composition
<div className="custom-wrapper">
  <Card>
    <div className="custom-header">
      <CardHeader>...</CardHeader>
    </div>
    ...
  </Card>
</div>
```

### Styling Guidelines
- Use design tokens for all spacing, colors, and typography
- Avoid inline styles except for dynamic values
- Use CSS custom properties for themeable values
- Follow BEM naming convention for custom styles

---

## Related Documents
- [UI Library](ui-library.md) - Component usage guidelines and patterns
- [Design System](design-system.md) - Complete design system overview
- [Design Tokens](design-tokens.md) - Design token specifications
- [Accessibility Guidelines](accessibility-guidelines.md) - Inclusive design standards

**Keywords**: component library, reusable components, UI components, design system, React components, component catalog, component specifications