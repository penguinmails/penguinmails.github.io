---
title: "Technical Implementation: Onboarding"
description: "Architecture, State Management, and Database Schema for the onboarding experience."
last_modified_date: "2026-02-24"
level: "3"
persona: "Developers"
---

## Level 3: Technical Implementation

### State Management

Onboarding state is managed via a combination of local Zod-validated forms and a global `OnboardingStore`.

```typescript
interface OnboardingState {
  workspaceId: string;
  tenantId: string;
  status: 'not_started' | 'in_progress' | 'completed' | 'skipped';
  currentStep: number;
  completedSteps: string[];
  lastUpdated: string;
}

const useOnboarding = create<OnboardingState>((set) => ({
  // Store implementation
}));
```

### Database Schema

Progress is persisted in the `workspace_settings` table to allow for cross-device continuity.

```sql
ALTER TABLE workspaces
ADD COLUMN onboarding_progress JSONB DEFAULT '{
  "status": "not_started",
  "current_step": 1,
  "completed_steps": [],
  "metadata": {}
}'::jsonb;

-- Function to check milestone completion
CREATE OR REPLACE FUNCTION is_onboarding_completed(workspace_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN (
    EXISTS(SELECT 1 FROM domains d WHERE d.company_id = workspace_id AND d.verification_status = 'verified')
    AND EXISTS(SELECT 1 FROM email_accounts ea JOIN domains d ON ea.domain_id = d.id WHERE d.company_id = workspace_id)
    AND EXISTS(SELECT 1 FROM leads l WHERE l.company_id = workspace_id)
    AND EXISTS(SELECT 1 FROM campaigns c WHERE c.company_id = workspace_id)
  );
END;
$$ LANGUAGE plpgsql;
```

### Components & Services

The onboarding system uses dedicated layouts and services to isolate it from the main application logic.

- **`OnboardingLayout`**: Clean, focused layout without standard navigation sidebars.
- **`StepperComponent`**: Horizontal progress indicator with validation logic.
- **`StepLoader`**: Dynamic component loader for each onboarding step.
- **`MilestoneService`**: Backend listener that updates `onboarding_progress` based on system events.

### Frontend Flow Control (Next.js)

We use middleware to redirect users to onboarding if they haven't completed it.

```typescript
// middleware.ts example
export async function middleware(req: NextRequest) {
  const { workspace } = await getContext(req);

  if (workspace && !workspace.onboarding_completed && !req.nextUrl.pathname.startsWith('/onboarding')) {
    return NextResponse.redirect(new URL('/onboarding', req.url));
  }

  return NextResponse.next();
}
```

---

## Release Planning

- **Closed Beta (Q4 2025):** Core flow with manual verification.
- **Public Beta (Q1 2026):** Full automated flow with interactive checklist.
- **General Availability (Q2 2026):** AI-powered onboarding assistance and predictive setup.
