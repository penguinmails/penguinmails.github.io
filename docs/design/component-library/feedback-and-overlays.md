---
title: "Feedback and Overlay Components"
description: "Interactive feedback and messaging components: Alert, Toast, and Modal."
last_modified_date: "2026-02-24"
level: "3"
persona: "Documentation Users"
---

## Feedback Components

### Alert

{% raw %}

```jsx
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
    onClick: () => navigate('/settings')
  }}
  dismissible
/>

<Alert
  variant="success"
  message="Campaign sent successfully! Check your analytics for performance details."
/>
```

{% endraw %}

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
        onClick: () => navigate(`/campaigns/${campaignData.id}`)
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

```jsx
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
