---
title: "Button Components"
description: "Button variants and usage"
last_modified_date: "2025-12-04"
level: "3"
keywords: "buttons, actions, interactions"
---

# Button Components

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
