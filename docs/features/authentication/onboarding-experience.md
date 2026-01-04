---
title: "Onboarding Experience"
description: "Guided setup wizard, interactive tutorials, and feature discovery to help users get started quickly"
level: "2"
status: "PLANNED"
roadmap_timeline: "Q1 2026"
priority: "High"
related_features:

  - enterprise/user-management

  - infrastructure/email-infrastructure-setup

  - domains/domain-management

  - payments/subscription-management
related_tasks:

  - epic-2-user-authentication-profile

  - epic-3-tenant-company-management
---

# Onboarding Experience

**Quick Access**: Get new users productive in under 10 minutes with guided setup, interactive tutorials, and contextual help.

## Overview

The Onboarding Experience provides a structured, interactive journey for new users from signup to their first successful email campaign, reducing time-to-value and improving activation rates.

### Key Components

1. **Guided Setup Wizard**: Step-by-step infrastructure configuration

2. **Interactive Checklist**: Track progress toward first campaign

3. **Contextual Tooltips**: In-app guidance and feature discovery

4. **Video Tutorials**: Quick how-to videos at key moments

5. **Progress Tracking**: Visual progress indicators

6. **Achievement Milestones**: Celebrate user progress

---

## Level 1: Onboarding Flow Overview

### New User Journey

```text

1. Sign Up → 2. Workspace Setup → 3. Domain Configuration →

4. Payment → 5. First Email Account → 6. First Campaign → 7. Success!

```

**Time to Complete**: 8-10 minutes

### Step-by-Step Walkthrough

#### Step 1: Sign Up (1 min)

**Fields:**

- Email address

- Password

- Company name

- User name

**Welcome Screen:**

```text

Welcome to PenguinMails! 🐧

Let's get your professional email infrastructure

set up in under 10 minutes.

[Start Setup] [Skip Tour]

```

#### Step 2: Create Workspace (1 min)

```text

Create Your First Workspace

Workspaces help you organize campaigns by client,

project, or brand.

Workspace Name: [_______________]

Example: "Main Company" or "Client: Acme Corp"

[Continue]

```

**Tooltip:** "You can create unlimited workspaces. Start with one for now."

#### Step 3: Add Domain (2 min)

```text

Step 3 of 6: Add Your Sending Domain

This is the domain you'll send emails from

(e.g., yourdomain.com)

Domain: [_______________]

☐ I have access to DNS settings for this domain

[Continue] [Need help?]

```

**If "Need help?" clicked:**

- Show video: "What is a sending domain?"

- Link to: Domain setup guide

#### Step 4: Verify Domain (2 min)

```text

Step 4 of 6: Verify Domain Ownership

Add this DNS record to verify you own this domain:

TXT Record:

  Host: _penguinmails-verify

  Value: abc123xyz...

[Copy Record] [I've Added the Record]

OR

[Auto-Configure with Cloudflare] [Auto-Configure with Route53]

```

**Auto-detection:**

- System polls for DNS record every 10 seconds

- Shows "Verifying..." animation

- Auto-advances when verified

#### Step 5: Set Up Payment (1 min)

```text

Step 5 of 6: Choose Your Plan

○ Starter - $49/mo

  Up to 5,000 emails/month

  1 workspace

● Professional - $99/mo  [RECOMMENDED]

  Up to 25,000 emails/month

  Unlimited workspaces

  Priority support

○ Business - $249/mo

  Up to 100,000 emails/month

  Everything in Professional

  Dedicated infrastructure

[Start 14-Day Free Trial] No credit card required

```

**After trial started:**

```text

✓ Trial Started - 14 days remaining

You won't be charged until your trial ends.

Add payment method anytime in Settings.

[Continue to Infrastructure Setup]

```

#### Step 6: Provision Infrastructure (2-3 min)

```text

Step 6 of 6: Launch Your Email Infrastructure

We're setting up your professional email infrastructure:

✓ VPS server provisioning

⏳ Installing SMTP server (2 min remaining)

○ Configuring DNS records

○ Installing SSL certificates

○ Creating your first email account

[Watch Setup Video] while you wait

```

**Progress bar animates** showing real-time status.

**Complete:**

```text

🎉 Infrastructure Ready!

Your email infrastructure is live at:

mail.yourdomain.com

Next: Create your first email account

[Create Email Account]

```

#### Step 7: Create First Email Account (1 min)

```text

Create Your First Sending Account

Email Address: [___]@yourdomain.com

Password: [Generate Secure Password]

[Create Account & Finish Setup]

```

#### Step 8: Success & Next Steps (30 sec)

```text

🎉 Congratulations! You're All Set

Your email infrastructure is ready to send.

Quick Actions:

☐ Create your first campaign

☐ Import your contact list

☐ Set up email warmup (recommended)

[Go to Dashboard] [Take the Product Tour]

```

---

## Level 2: Advanced Onboarding Features

### Interactive Checklist

Persistent checklist in sidebar:

```text

Getting Started ────────○○○ 70%

✓ Create workspace

✓ Add domain

✓ Verify domain

✓ Create email account

⏳ Import contacts (20/100)

○ Create first campaign

○ Send first email

[Collapse]

```

**Features:**

- Persists across sessions

- Click items to jump to relevant page

- Progress percentage updates in real-time

- Dismissible after completion

### Contextual Tooltips

**First-time visitor tooltips:**

```text

[i] Workspaces

    Organize your campaigns by client,

    brand, or project.

    [Got It] [Learn More]

```

**Smart triggering:**

- Show on first page visit only

- Don't show if user has interacted with feature

- Allow dismissal (never show again)

- Max 3 tooltips per page

### Interactive Tutorial Mode

**Activated by:** "Take the Product Tour" button

**Flow:**

1. Dim entire UI

2. Highlight specific element

3. Show explanation overlay

4. Guide through workflow

5. Allow skipping or pausing

**Example:**

```text

[Spotlight on "Create Campaign" button]

Step 1 of 5: Creating Your First Campaign

Click here to create a new email campaign.

[Next] [Skip Tour]

```

### Video Tutorials

**Embedded at key moments:**

- Domain setup: "How to add DNS records"

- Email warmup: "Why warmup matters"

- Campaign creation: "Your first campaign"

**Format:**

- 60-90 seconds each

- Skippable

- Closed captions

- Hosted on CDN for fast loading

### Progress Milestones

**Achievement notifications:**

```text

🎊 Milestone Unlocked: First Email Sent!

You've sent your first email through PenguinMails.

Keep going!

[View Campaign Analytics]

```

**Milestones:**

- ✓ First workspace created

- ✓ First domain verified

- ✓ First email account created

- ✓ First 10 contacts imported

- ✓ First campaign created

- ✓ First email sent

- ✓ First email opened

- ✓ First link clicked

### Personalized Recommendations

Based on user behavior:

```text

👋 We noticed you haven't set up email warmup yet.

Warmup helps build sender reputation and improves

deliverability. It only takes 2 minutes.

[Set Up Warmup Now] [Remind Me Later]

```

### Team Onboarding

For workspace invites:

```text

Welcome to [Workspace Name]!

You've been invited as a Workspace Member.

Here's what you can do:

✓ View campaigns

✓ Create and edit templates

○ Can't: Modify billing or infrastructure

[View Permissions] [Explore Dashboard]

```

---

## Level 3: Technical Implementation

### Onboarding State Management

```typescript
// Simplified workspace-level onboarding state
interface OnboardingState {
  workspaceId: string;
  tenantId: string;
  
  // Status tracking (minimal footprint)
  status: 'not_started' | 'in_progress' | 'completed' | 'skipped';
  startedAt?: Date;
  completedAt?: Date;
  hideOnboarding: boolean;
}

// Status inference logic
function getOnboardingStatus(workspace: {
  onboarding_started_at?: Date;
  onboarding_completed_at?: Date;
  hide_onboarding: boolean;
}): OnboardingState['status'] {
  if (workspace.hide_onboarding) return 'skipped';
  if (workspace.onboarding_completed_at) return 'completed';
  if (workspace.onboarding_started_at) return 'in_progress';
  return 'not_started';
}

// Onboarding steps for analytics and completion detection
type OnboardingStep = 
  | 'domain_added'    // Domain added and verified
  | 'mailbox_created' // Email account created
  | 'warmup_started'  // Email warmup initiated
  | 'leads_added'     // Contact list started
  | 'campaign_created'; // First campaign created

// Completion detection based on workspace data
interface OnboardingCompletionCheck {
  domainAdded: boolean;
  mailboxCreated: boolean;
  warmupStarted: boolean;
  leadsAdded: boolean;
  campaignCreated: boolean;
  allCompleted: boolean;
}
```

### Database Schema

```sql
-- Workspace-level onboarding tracking (minimal footprint)
ALTER TABLE companies ADD COLUMN onboarding_started_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE companies ADD COLUMN onboarding_completed_at TIMESTAMP WITH TIME ZONE;
ALTER TABLE companies ADD COLUMN hide_onboarding BOOLEAN DEFAULT FALSE;

-- Onboarding completion detection function
CREATE OR REPLACE FUNCTION is_onboarding_completed(workspace_id UUID)
RETURNS BOOLEAN AS $
BEGIN
  RETURN (
    EXISTS(SELECT 1 FROM domains d WHERE d.company_id = workspace_id AND d.verification_status = 'verified')
    AND EXISTS(SELECT 1 FROM email_accounts ea JOIN domains d ON ea.domain_id = d.id WHERE d.company_id = workspace_id)
    AND EXISTS(SELECT 1 FROM leads l WHERE l.company_id = workspace_id)
    AND EXISTS(SELECT 1 FROM campaigns c WHERE c.company_id = workspace_id)
  );
END;
$ LANGUAGE plpgsql;

-- Auto-complete onboarding when all steps are done
CREATE OR REPLACE FUNCTION auto_complete_onboarding()
RETURNS TRIGGER AS $
BEGIN
  -- Check if workspace should be marked as onboarding completed
  IF NEW.onboarding_completed_at IS NULL AND is_onboarding_completed(NEW.id) = TRUE THEN
    NEW.onboarding_completed_at = NOW();
  END IF;
  
  RETURN NEW;
END;
$ LANGUAGE plpgsql;

CREATE TRIGGER companies_onboarding_auto_complete
  BEFORE UPDATE ON companies
  FOR EACH ROW
  EXECUTE FUNCTION auto_complete_onboarding();

```

### Onboarding Service

```typescript
class OnboardingService {
  // Initialize onboarding tracking for a workspace
  async initializeOnboarding(workspaceId: string): Promise<OnboardingState> {
    const workspace = await db.companies.findById(workspaceId);
    
    // Only set started_at if not already set
    if (!workspace.onboarding_started_at) {
      await db.companies.update(workspaceId, {
        onboarding_started_at: new Date()
      });
    }

    // Track analytics event
    await this.trackEvent('onboarding_started', {
      workspace_id: workspaceId,
      timestamp: new Date().toISOString()
    });

    return this.getOnboardingState(workspaceId);
  }

  // Get current onboarding state for a workspace
  async getOnboardingState(workspaceId: string): Promise<OnboardingState> {
    const workspace = await db.companies.findById(workspaceId);
    
    return {
      workspaceId: workspace.id,
      tenantId: workspace.tenant_id,
      status: getOnboardingStatus(workspace),
      startedAt: workspace.onboarding_started_at,
      completedAt: workspace.onboarding_completed_at,
      hideOnboarding: workspace.hide_onboarding
    };
  }

  // Check if workspace should show onboarding
  async shouldShowOnboarding(workspaceId: string): Promise<boolean> {
    const state = await this.getOnboardingState(workspaceId);
    
    // Don't show if explicitly hidden
    if (state.hideOnboarding) return false;
    
    // Don't show if completed
    if (state.status === 'completed') return false;
    
    return true;
  }

  // Hide onboarding for a workspace (manual override)
  async hideOnboarding(workspaceId: string, hidden: boolean = true): Promise<void> {
    await db.companies.update(workspaceId, {
      hide_onboarding: hidden
    });

    await this.trackEvent('onboarding_hidden', {
      workspace_id: workspaceId,
      hidden,
      timestamp: new Date().toISOString()
    });
  }

  // Track onboarding analytics events
  private async trackEvent(eventType: string, eventData: Record<string, any>): Promise<void> {
    // Send to Posthog for analytics
    if (typeof posthog !== 'undefined') {
      posthog.capture(eventType, eventData);
    }
    
    // Could also send to internal analytics service
    console.log(`Onboarding Event: ${eventType}`, eventData);
  }

  // Get completion status based on actual workspace data
  async getCompletionStatus(workspaceId: string): Promise<OnboardingCompletionCheck> {
    const result = await db.query(`
      SELECT 
        -- Domain added and verified
        EXISTS(SELECT 1 FROM domains d WHERE d.company_id = $1 AND d.verification_status = 'verified') as domain_added,
        
        -- Email account created
        EXISTS(SELECT 1 FROM email_accounts ea 
               JOIN domains d ON ea.domain_id = d.id 
               WHERE d.company_id = $1) as mailbox_created,
        
        -- Warmup started (has last_warmed timestamp)
        EXISTS(SELECT 1 FROM email_accounts ea 
               JOIN domains d ON ea.domain_id = d.id 
               WHERE d.company_id = $1 AND ea.last_warmed IS NOT NULL) as warmup_started,
        
        -- Leads added
        EXISTS(SELECT 1 FROM leads l WHERE l.company_id = $1) as leads_added,
        
        -- Campaign created
        EXISTS(SELECT 1 FROM campaigns c WHERE c.company_id = $1) as campaign_created
    `, [workspaceId]);

    const row = result.rows[0];
    return {
      domainAdded: row.domain_added,
      mailboxCreated: row.mailbox_created,
      warmupStarted: row.warmup_started,
      leadsAdded: row.leads_added,
      campaignCreated: row.campaign_created,
      allCompleted: row.domain_added && row.mailbox_created && row.leads_added && row.campaign_created
    };
  }
}

```

### Frontend Components

```tsx
// React hook for onboarding state
function useOnboarding(workspaceId: string) {
  const [onboardingState, setOnboardingState] = useState<OnboardingState | null>(null);
  const [completionStatus, setCompletionStatus] = useState<OnboardingCompletionCheck | null>(null);

  // Load onboarding state
  useEffect(() => {
    const loadState = async () => {
      const state = await onboardingService.getOnboardingState(workspaceId);
      const completion = await onboardingService.getCompletionStatus(workspaceId);
      setOnboardingState(state);
      setCompletionStatus(completion);
    };
    loadState();
  }, [workspaceId]);

  return {
    onboardingState,
    completionStatus,
    shouldShowOnboarding: onboardingState?.status !== 'completed' && !onboardingState?.hideOnboarding
  };
}

// Onboarding container component
function OnboardingContainer({ workspaceId }: { workspaceId: string }) {
  const { onboardingState, shouldShowOnboarding } = useOnboarding(workspaceId);

  if (!shouldShowOnboarding) {
    return null; // Don't render onboarding UI
  }

  return (
    <div className="onboarding-container">
      <OnboardingProgress workspaceId={workspaceId} />
      <OnboardingSteps workspaceId={workspaceId} />
    </div>
  );
}

// Progress indicator based on workspace data
function OnboardingProgress({ workspaceId }: { workspaceId: string }) {
  const { completionStatus } = useOnboarding(workspaceId);

  if (!completionStatus) return null;

  const steps = [
    { id: 'domain_added', label: 'Add Domain', completed: completionStatus.domainAdded },
    { id: 'mailbox_created', label: 'Create Mailbox', completed: completionStatus.mailboxCreated },
    { id: 'warmup_started', label: 'Start Warmup', completed: completionStatus.warmupStarted },
    { id: 'leads_added', label: 'Add Contacts', completed: completionStatus.leadsAdded },
    { id: 'campaign_created', label: 'Create Campaign', completed: completionStatus.campaignCreated }
  ];

  const completedSteps = steps.filter(step => step.completed).length;
  const progressPercent = (completedSteps / steps.length) * 100;

  return (
    <div className="onboarding-progress">
      <div className="progress-header">
        <h3>Getting Started</h3>
        <span>{completedSteps}/{steps.length} completed</span>
      </div>
      
      <div className="progress-bar">
        <div 
          className="progress-fill" 
          style={{ width: `${progressPercent}%` }}
        />
      </div>
      
      <ul className="steps-list">
        {steps.map(step => (
          <li key={step.id} className={step.completed ? 'completed' : ''}>
            {step.completed ? '✓' : '○'} {step.label}
          </li>
        ))}
      </ul>
    </div>
  );
}

// Quick action buttons for onboarding steps
function OnboardingSteps({ workspaceId }: { workspaceId: string }) {
  const { completionStatus } = useOnboarding(workspaceId);

  if (!completionStatus) return null;

  const quickActions = [
    {
      id: 'domain',
      title: 'Add Your Domain',
      description: 'Set up your sending domain to start email campaigns',
      completed: completionStatus.domainAdded,
      action: () => navigate('/domains/new')
    },
    {
      id: 'mailbox',
      title: 'Create Email Account',
      description: 'Set up your first sending email address',
      completed: completionStatus.mailboxCreated,
      action: () => navigate('/email-accounts/new')
    },
    {
      id: 'leads',
      title: 'Import Contacts',
      description: 'Add your first contacts to start emailing',
      completed: completionStatus.leadsAdded,
      action: () => navigate('/leads/import')
    },
    {
      id: 'campaign',
      title: 'Create Campaign',
      description: 'Build your first email campaign',
      completed: completionStatus.campaignCreated,
      action: () => navigate('/campaigns/new')
    }
  ];

  return (
    <div className="onboarding-steps">
      <h3>Complete Your Setup</h3>
      <div className="steps-grid">
        {quickActions.map(action => (
          <div 
            key={action.id} 
            className={`step-card ${action.completed ? 'completed' : ''}`}
            onClick={action.action}
          >
            <div className="step-icon">
              {action.completed ? '✓' : '○'}
            </div>
            <h4>{action.title}</h4>
            <p>{action.description}</p>
            {!action.completed && (
              <button className="btn-primary">Get Started</button>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

// Hide onboarding toggle (for power users)
function OnboardingToggle({ workspaceId }: { workspaceId: string }) {
  const { onboardingState } = useOnboarding(workspaceId);
  
  const handleToggle = async () => {
    await onboardingService.hideOnboarding(
      workspaceId, 
      !onboardingState?.hideOnboarding
    );
  };

  return (
    <div className="onboarding-toggle">
      <label>
        <input
          type="checkbox"
          checked={onboardingState?.hideOnboarding || false}
          onChange={handleToggle}
        />
        Hide onboarding guide for this workspace
      </label>
    </div>
  );
}

```

---

## Related Documentation

- **[User Management](/docs/features/authentication/user-management)** - Authentication and registration

- **[Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)** - Infrastructure provisioning

- **[Domain Management](/docs/features/domains/domain-management)** - Domain configuration

- **[Subscription Management](/docs/features/payments/subscription-management)** - Payment and trials

---

**Last Updated:** January 4, 2026

**Status:** Planned - MVP Feature (Level 2)

**Target Release:** Q1 2026

**Owner:** Product Team
