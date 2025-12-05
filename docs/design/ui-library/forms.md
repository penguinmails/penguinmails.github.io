---
title: "Form Components"
description: "Form inputs and controls"
last_modified_date: "2025-12-04"
level: "3"
keywords: "forms, inputs, validation"
---

# Form Components

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
