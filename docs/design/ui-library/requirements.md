---
title: "Component Requirements"
description: "Core component requirements"
last_modified_date: "2025-12-04"
level: "3"
keywords: "requirements, specifications, standards"
---

# Component Requirements

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

