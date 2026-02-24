---
title: "Primitive Components"
description: "Foundational UI components: Button and Input."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

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
- Border radius: 6px (sm, md), 8px (lg)
- Font weight: 500 (regular), 600 (bold for primary)
- Focus ring: 2px solid primary color, 2px offset

### Input

```jsx
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
