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

1. Sign Up â†’ 2. Workspace Setup â†’ 3. Domain Configuration â†’

4. Payment â†’ 5. First Email Account â†’ 6. First Campaign â†’ 7. Success!

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

Welcome to PenguinMails! ðŸ§

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

â˜ I have access to DNS settings for this domain

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

â—‹ Starter - $49/mo
  Up to 5,000 emails/month
  1 workspace

â— Professional - $99/mo  [RECOMMENDED]
  Up to 25,000 emails/month
  Unlimited workspaces
  Priority support

â—‹ Business - $249/mo
  Up to 100,000 emails/month
  Everything in Professional
  Dedicated infrastructure

[Start 14-Day Free Trial] No credit card required

```

**After trial started:**

```text

âœ“ Trial Started - 14 days remaining

You won't be charged until your trial ends.
Add payment method anytime in Settings.

[Continue to Infrastructure Setup]

```

#### Step 6: Provision Infrastructure (2-3 min)

```text

Step 6 of 6: Launch Your Email Infrastructure

We're setting up your professional email infrastructure:

âœ“ VPS server provisioning
â³ Installing SMTP server (2 min remaining)
â—‹ Configuring DNS records
â—‹ Installing SSL certificates
â—‹ Creating your first email account

[Watch Setup Video] while you wait

```

**Progress bar animates** showing real-time status.

**Complete:**

```text

ðŸŽ‰ Infrastructure Ready!

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

ðŸŽ‰ Congratulations! You're All Set

Your email infrastructure is ready to send.

Quick Actions:
â˜ Create your first campaign
â˜ Import your contact list
â˜ Set up email warmup (recommended)

[Go to Dashboard] [Take the Product Tour]

```

---

## Level 2: Advanced Onboarding Features

### Interactive Checklist

Persistent checklist in sidebar:

```text

Getting Started â”â”â”â”â”â”â”â”â—‹â—‹â—‹ 70%

âœ“ Create workspace
âœ“ Add domain
âœ“ Verify domain
âœ“ Create email account
â³ Import contacts (20/100)
â—‹ Create first campaign
â—‹ Send first email

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

ðŸŽŠ Milestone Unlocked: First Email Sent!

You've sent your first email through PenguinMails.
Keep going!

[View Campaign Analytics]

```

**Milestones:**

- âœ“ First workspace created

- âœ“ First domain verified

- âœ“ First email account created

- âœ“ First 10 contacts imported

- âœ“ First campaign created

- âœ“ First email sent

- âœ“ First email opened

- âœ“ First link clicked

### Personalized Recommendations

Based on user behavior:

```text

ðŸ‘‹ We noticed you haven't set up email warmup yet.

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

âœ“ View campaigns
âœ“ Create and edit templates
â—‹ Can't: Modify billing or infrastructure

[View Permissions] [Explore Dashboard]

```

---

## Level 3: Technical Implementation

### Onboarding State Management

```typescript
interface OnboardingState {
  userId: string;
  tenantId: string;

  // Progress tracking
  currentStep: number;
  totalSteps: number;
  completedSteps: string[];
  startedAt: Date;
  completedAt?: Date;

  // Checklist
  checklistItems: OnboardingChecklistItem[];
  checklistProgress: number; // 0-100

  // User preferences
  skipTutorials: boolean;
  dismissedTooltips: string[];
  watchedVideos: string[];

  // Milestones
  unlockedMilestones: string[];

  // Metadata
  lastActiveStep: string;
  lastActivityAt: Date;
}

interface OnboardingChecklistItem {
  id: string;
  label: string;
  description: string;
  completed: boolean;
  required: boolean;
  order: number;
  actionUrl?: string;
  completedAt?: Date;
}

```

### Database Schema

```sql
CREATE TABLE user_onboarding (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id),
  tenant_id UUID NOT NULL REFERENCES tenants(id),

  -- Progress
  current_step INTEGER DEFAULT 1,
  completed_steps TEXT[] DEFAULT '{}',
  started_at TIMESTAMP DEFAULT NOW(),
  completed_at TIMESTAMP,

  -- Checklist
  checklist_progress INTEGER DEFAULT 0,
  checklist_items JSONB DEFAULT '[]',

  -- Preferences
  skip_tutorials BOOLEAN DEFAULT FALSE,
  dismissed_tooltips TEXT[] DEFAULT '{}',
  watched_videos TEXT[] DEFAULT '{}',

  -- Milestones
  unlocked_milestones TEXT[] DEFAULT '{}',

  -- Metadata
  last_active_step VARCHAR(100),
  last_activity_at TIMESTAMP DEFAULT NOW(),

  UNIQUE(user_id)
);

-- Onboarding analytics
CREATE TABLE onboarding_events (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL,
  event_type VARCHAR(100),
  event_data JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_onboarding_events_user ON onboarding_events(user_id, created_at);

```

### Onboarding Service

```typescript
class OnboardingService {
  async initializeOnboarding(userId: string, tenantId: string): Promise<OnboardingState> {
    const checklist = this.generateChecklist(userId, tenantId);

    const onboarding = await db.userOnboarding.create({
      userId,
      tenantId,
      currentStep: 1,
      checklistItems: checklist,
      checklistProgress: 0,
    });

    await this.trackEvent(userId, 'onboarding_started');

    return onboarding;
  }

  async completeStep(userId: string, step: string): Promise<void> {
    const onboarding = await db.userOnboarding.findByUser(userId);

    await db.userOnboarding.update(userId, {
      completedSteps: [...onboarding.completedSteps, step],
      lastActiveStep: step,
      lastActivityAt: new Date(),
    });

    await this.trackEvent(userId, 'onboarding_step_completed', { step });

    // Check for milestone unlocks
    await this.checkMilestones(userId, step);

    // Update checklist if applicable
    await this.updateChecklist(userId, step);
  }

  async updateChecklist(userId: string, action: string): Promise<void> {
    const onboarding = await db.userOnboarding.findByUser(userId);
    const checklist = onboarding.checklistItems;

    // Find matching checklist item
    const item = checklist.find(i => i.id === action);
    if (item && !item.completed) {
      item.completed = true;
      item.completedAt = new Date();

      const progress = this.calculateProgress(checklist);

      await db.userOnboarding.update(userId, {
        checklistItems: checklist,
        checklistProgress: progress,
      });

      // Check if onboarding complete
      if (progress === 100) {
        await this.completeOnboarding(userId);
      }
    }
  }

  private calculateProgress(checklist: OnboardingChecklistItem[]): number {
    const total = checklist.filter(i => i.required).length;
    const completed = checklist.filter(i => i.required && i.completed).length;
    return Math.round((completed / total) * 100);
  }

  async checkMilestones(userId: string, event: string): Promise<void> {
    const milestones = {
      'workspace_created': 'first_workspace',
      'domain_verified': 'first_domain',
      'email_sent': 'first_email',
      'email_opened': 'first_open',
    };

    const milestone = milestones[event];
    if (milestone) {
      await this.unlockMilestone(userId, milestone);
    }
  }

  async unlockMilestone(userId: string, milestone: string): Promise<void> {
    await db.userOnboarding.update(userId, {
      unlockedMilestones: db.raw('array_append(unlocked_milestones, ?)', [milestone]),
    });

    await this.trackEvent(userId, 'milestone_unlocked', { milestone });

    // Send notification
    await notificationService.send({
      userId,
      type: 'milestone_unlocked',
      data: { milestone },
    });
  }
}

```

### Frontend Components

```tsx
// Onboarding wizard
function OnboardingWizard() {
  const { onboarding, completeStep } = useOnboarding();

  const steps = [
    { id: 'workspace', component: WorkspaceSetup },
    { id: 'domain', component: DomainSetup },
    { id: 'payment', component: PaymentSetup },
    { id: 'infrastructure', component: InfrastructureSetup },
    { id: 'email-account', component: EmailAccountSetup },
    { id: 'complete', component: OnboardingComplete },
  ];

  const currentStepComponent = steps[onboarding.currentStep - 1]?.component;

  return (
    <div className="onboarding-wizard">
      <ProgressBar
        current={onboarding.currentStep}
        total={steps.length}
      />

      {currentStepComponent && React.createElement(currentStepComponent, {
        onComplete: () => completeStep(steps[onboarding.currentStep - 1].id),
      })}
    </div>
  );
}

// Persistent checklist
function OnboardingChecklist() {
  const { checklist, progress } = useOnboarding();
  const [collapsed, setCollapsed] = useState(false);

  if (progress === 100) return null; // Hide when complete

  return (
    <aside className="onboarding-checklist">
      <header onClick={() => setCollapsed(!collapsed)}>
        <h3>Getting Started</h3>
        <ProgressBar value={progress} />
        <span>{progress}%</span>
      </header>

      {!collapsed && (
        <ul>
          {checklist.map(item => (
            <li key={item.id} className={item.completed ? 'completed' : ''}>
              {item.completed ? 'âœ“' : 'â—‹'} {item.label}
            </li>
          ))}
        </ul>
      )}
    </aside>
  );
}

```

---

## Related Documentation

- **[User Management](/docs/features/enterprise/user-management)** - Authentication and registration

- **[Email Infrastructure Setup](/docs/features/infrastructure/email-infrastructure-setup)** - Infrastructure provisioning

- **[Domain Management](/docs/features/domains/domain-management)** - Domain configuration

- **[Subscription Management](/docs/features/payments/subscription-management)** - Payment and trials

---

**Last Updated:** November 25, 2025
**Status:** Planned - MVP Feature (Level 2)
**Target Release:** Q1 2026
**Owner:** Product Team


