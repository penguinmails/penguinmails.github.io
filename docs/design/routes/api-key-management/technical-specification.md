---
title: "API Key Technical Specifications"
description: "State management, error handling, security considerations, and accessibility standards for API key routes."
last_modified_date: "2026-02-24"
level: "2"
---

# API Key Technical Specifications

## State Management

```typescript
interface APIKey {
  key_id: string;
  name: string;
  masked_key: string;
  permissions: string[];
  rate_limit: number;
  status: 'active' | 'revoked';
  created_at: string;
  last_used: string | null;
}
```

## Error Handling

| Error Code | UI Response |
|------------|-------------|
| **401 Unauthorized** | Redirect to login with session expired toast. |
| **403 Forbidden** | Show descriptive error; disable management buttons. |
| **429 Rate Limit** | Show "Too many requests" message; temporary lockout. |
| **500 Server Error** | Log to monitoring; show generic "Something went wrong" message. |

## Security Considerations

### 1. Key Exposure

- **Solution**: Never display the full key after the initial creation success modal.
- **UI Policy**: Use masked values (`pm_live_...xyz`) in all tables and detail views.

### 2. Clipboard Safety

- **Tool**: Use `navigator.clipboard` for copy actions.
- **Feedback**: Provide visual "Copied" toasts for user reassurance.

### 3. Accidental Revocation

- **Solution**: Mandatory centered confirmation modals for both Revoke and Regenerate actions.

## Accessibility (a11y) Standards

- **Keyboard**: Full tab navigation support; Escape to close modals.
- **Screen Readers**: Semantic HTML tables and ARIA labels for icon-only buttons.
- **Contrast**: WCAG AA compliant color schemes for status badges.
