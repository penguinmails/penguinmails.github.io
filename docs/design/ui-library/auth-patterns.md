---
title: "Authentication & Authorization Patterns"
description: "Auth UI patterns"
last_modified_date: "2025-12-04"
level: "3"
keywords: "authentication, authorization, security"
---

# Authentication & Authorization Patterns

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

