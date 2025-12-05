---
title: "Feedback Components"
description: "User feedback components"
last_modified_date: "2025-12-04"
level: "3"
keywords: "feedback, notifications, alerts"
---

# Feedback Components

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
