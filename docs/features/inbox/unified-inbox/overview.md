---
title: "Unified Inbox"
description: "Centralized command center for managing responses across all email accounts with AI categorization and real-time sync"
level: "2"
status: "AVAILABLE"
roadmap_timeline: "Q1 2026"
priority: "Critical"
related_features:


  - inbox/inbox-rotation


  - campaigns/campaign-management/overview


  - leads/lead-scoring


  - integrations/crm-integration/overview
related_tasks:


  - epic-8-inbox-management
---


# Unified Inbox

**Quick Access**: Manage all prospect interactions from a single dashboard with AI-powered categorization, real-time synchronization, and team collaboration tools.

## Overview

The Unified Inbox consolidates emails from thousands of sender accounts into a single, organized interface. Instead of logging into multiple Gmail or Outlook accounts, your team manages all replies in one place. With AI-driven intent detection, it automatically categorizes responses (Interested, Not Interested, OOO) so you can focus on closing deals.

### Key Capabilities

- **Universal Aggregation**: Sync emails from Gmail, Outlook, SMTP/IMAP, and custom domains

- **AI Intent Detection**: Automatically tag responses as Interested, Meeting Booked, Not Interested, etc.

- **Thread Management**: View full conversation history across multiple sending accounts

- **Real-Time Sync**: Bi-directional synchronization with provider mailboxes

- **Team Collaboration**: Assign threads, add internal notes, and track response times

- **CRM Sync**: Automatically push positive responses to your CRM

---

## Level 1: Quick Start Guide

### Manage Your First Responses

#### Step 1: Access the Inbox

```

Dashboard → Inbox

Views:
┌─────────────────────────────────────────────────────┐
│ 📥 All Open (12)                                    │
│ 🔥 Interested (3)                                   │
│ 📅 Meeting Booked (1)                               │
│ ✋ Not Interested (5)                               │
│ 🤖 OOO / Auto-reply (3)                             │
└─────────────────────────────────────────────────────┘


```

#### Step 2: Handle a Response

**Scenario**: A prospect replies "Sounds interesting, send more info."

1. **Click the thread**: Opens the conversation view.

2. **Review Context**:

    - **Prospect**: John Doe (CEO at Acme Corp)

    - **Campaign**: "SaaS Outreach Q1"

    - **Sending Account**: `sarah@outreach-domain.com`

3. **Reply**:

    - Type your response in the editor.

    - (Optional) Use a "More Info" template.

    - Click **Send**.

4. **Update Status**:

    - AI may have auto-tagged as "Interested".

    - Change status to "Information Sent".

#### Step 3: Assign to Team

**Scenario**: A technical question requires engineering input.

1. **Internal Note**: Click "Add Note" tab.

2. **Mention**: "@mike can you answer this technical question?"

3. **Assign**: Change owner from "Sarah" to "Mike".

4. **Result**: Mike gets a notification and the thread appears in his "Assigned to Me" view.

#### Step 4: Bulk Actions

**Scenario**: Clear out 50 Out-of-Office replies.

1. Select "OOO / Auto-reply" view.

2. Click "Select All".

3. Click "Archive".

4. **Result**: Inbox zero for OOO messages.

---

## Level 2: Advanced Configuration

### AI Categorization Rules

Configure how the AI interprets and tags incoming messages.

```yaml
ai_categorization:
  enabled: true
  confidence_threshold: 0.85
  
  categories:


    - name: "Interested"
      keywords: ["interested", "send more", "pricing", "demo", "call"]
      action: "mark_priority_high"
      


    - name: "Meeting Request"
      keywords: ["calendar", "schedule", "time to chat", "tuesday"]
      action: "trigger_webhook:meeting_intent"
      


    - name: "Not Interested"
      keywords: ["unsubscribe", "remove me", "stop", "not interested"]
      action: "unsubscribe_contact"
      


    - name: "Out of Office"
      keywords: ["out of office", "vacation", "limited access"]
      action: "snooze:3_days"


```

### Inbox Filtering & Views

Create custom views for different workflows.

**"High Value Leads" View:**

```json
{
  "name": "High Value Leads",
  "filters": {
    "lead_score": { "gt": 80 },
    "status": ["open", "replied"],
    "tags": ["Interested", "Meeting Request"],
    "last_activity": { "lt": "2 days ago" }
  },
  "columns": ["contact_name", "company", "lead_score", "last_reply", "status"],
  "sort": { "field": "lead_score", "direction": "desc" }
}


```

### Reply Templates & Variables

Standardize responses with dynamic templates.

**Template: "Booking Request"**

```html
Hi {{firstName}},

Thanks for the quick reply! I'd love to show you how {{company}} can help with {{pain_point}}.

Are you free for a 15-min chat? You can book a time here:
{{calendar_link}}

Best,
{{sender_name}}


```

### Automation Rules

Trigger actions based on inbox events.

**Rule: "Auto-CRM Sync"**

```yaml
trigger:
  event: "thread_status_changed"
  new_status: "Interested"

actions:


  - type: "sync_to_crm"
    crm_provider: "hubspot"
    object: "deal"
    stage: "qualified_lead"
    


  - type: "notify_slack"
    channel: "#sales-wins"
    message: "🔥 New interested lead: {{contact.email}} from {{campaign.name}}"


```

---

## Level 3: Technical Implementation

### Database Schema

```sql
-- Inbox Threads (Conversations)
CREATE TABLE inbox_threads (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  workspace_id UUID REFERENCES workspaces(id),
  
  -- Context
  campaign_id UUID REFERENCES campaigns(id),
  contact_id UUID REFERENCES contacts(id),
  account_id UUID REFERENCES email_accounts(id), -- The sending account
  
  -- State
  subject VARCHAR(255),
  snippet TEXT,
  status VARCHAR(50) DEFAULT 'open', -- open, archived, snoozed, closed
  category VARCHAR(50), -- interested, not_interested, ooo, etc.
  ai_confidence DECIMAL(3,2),
  
  -- Assignment
  assigned_to UUID REFERENCES users(id),
  
  -- Timing
  last_message_at TIMESTAMP,
  snoozed_until TIMESTAMP,
  
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_inbox_threads_tenant ON inbox_threads(tenant_id);
CREATE INDEX idx_inbox_threads_status ON inbox_threads(status);
CREATE INDEX idx_inbox_threads_contact ON inbox_threads(contact_id);

-- Inbox Messages (Individual Emails)
CREATE TABLE inbox_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES inbox_threads(id) ON DELETE CASCADE,
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  
  -- Email Metadata
  provider_message_id VARCHAR(255), -- Gmail/Outlook ID
  direction VARCHAR(20), -- inbound, outbound
  
  -- Content
  from_email VARCHAR(255) NOT NULL,
  to_email VARCHAR(255) NOT NULL,
  cc_emails TEXT[],
  bcc_emails TEXT[],
  subject VARCHAR(255),
  body_text TEXT,
  body_html TEXT,
  
  -- Tracking
  is_read BOOLEAN DEFAULT FALSE,
  tracked_open BOOLEAN DEFAULT FALSE,
  tracked_click BOOLEAN DEFAULT FALSE,
  
  sent_at TIMESTAMP,
  received_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_inbox_messages_thread ON inbox_messages(thread_id);
CREATE INDEX idx_inbox_messages_provider_id ON inbox_messages(provider_message_id);

-- Inbox Tags/Labels
CREATE TABLE inbox_tags (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES inbox_threads(id) ON DELETE CASCADE,
  tag_name VARCHAR(50) NOT NULL,
  color VARCHAR(7),
  created_by UUID REFERENCES users(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Internal Notes
CREATE TABLE inbox_notes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  thread_id UUID NOT NULL REFERENCES inbox_threads(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);


```

### Message Aggregation Service

This service handles the ingestion and synchronization of emails from various providers.

```typescript
interface EmailProvider {
  syncMessages(accountId: string, since: Date): Promise<EmailMessage[]>;
  sendMessage(accountId: string, message: OutboundMessage): Promise<string>;
}

class MessageAggregationService {
  
  /**


   * Main sync loop for an account
   */
  async syncAccount(accountId: string) {
    const account = await db.emailAccounts.findById(accountId);
    const provider = this.getProvider(account.provider); // Gmail, Outlook, IMAP
    
    // 1. Fetch new messages
    const lastSync = account.last_sync_at || new Date(0);
    const messages = await provider.syncMessages(accountId, lastSync);
    
    for (const msg of messages) {
      await this.ingestMessage(account, msg);
    }
    
    // 2. Update sync status
    await db.emailAccounts.update(accountId, { last_sync_at: new Date() });
  }

  /**


   * Process a single incoming message
   */
  async ingestMessage(account: EmailAccount, msg: EmailMessage) {
    // 1. Find or create contact
    const contact = await db.contacts.findByEmail(msg.from);
    
    // 2. Find or create thread
    // Logic: Match by References/In-Reply-To headers, or Subject + Contact
    let thread = await this.findThread(msg, contact);
    
    if (!thread) {
      thread = await db.inboxThreads.create({
        tenant_id: account.tenant_id,
        account_id: account.id,
        contact_id: contact?.id,
        subject: msg.subject,
        status: 'open',
        last_message_at: msg.date
      });
    } else {
      // Re-open archived threads on new reply
      await db.inboxThreads.update(thread.id, {
        status: 'open',
        last_message_at: msg.date
      });
    }

    // 3. Save message
    const savedMsg = await db.inboxMessages.create({
      thread_id: thread.id,
      provider_message_id: msg.id,
      direction: 'inbound',
      body_text: msg.text,
      // ... other fields
    });

    // 4. Trigger AI Analysis (Async)
    await queue.add('analyze-email-intent', { messageId: savedMsg.id });
    
    // 5. Notify Frontend (WebSocket)
    await pubsub.publish(`tenant:${account.tenant_id}:inbox`, {
      type: 'NEW_MESSAGE',
      threadId: thread.id,
      message: savedMsg
    });
  }
}


```

### Real-Time Sync Engine

Uses WebSockets to push updates to the frontend without polling.

```typescript
// WebSocket Handler
io.on('connection', (socket) => {
  const { tenantId, userId } = socket.handshake.auth;
  
  // Join tenant room
  socket.join(`tenant:${tenantId}:inbox`);
  
  // Listen for updates
  socket.on('subscribe_thread', (threadId) => {
    socket.join(`thread:${threadId}`);
  });
});

// Event Publisher
const notifyNewMessage = (tenantId, message) => {
  io.to(`tenant:${tenantId}:inbox`).emit('inbox_update', {
    type: 'MESSAGE_RECEIVED',
    payload: message
  });
};


```

### API Endpoints

```typescript
// Get Threads (with pagination & filtering)
router.get('/api/inbox/threads', async (req, res) => {
  const { status, category, assignedTo, page = 1 } = req.query;
  
  const threads = await db.inboxThreads.find({
    where: {
      tenant_id: req.user.tenantId,
      status: status || 'open',
      ...(category && { category }),
      ...(assignedTo && { assigned_to: assignedTo })
    },
    include: ['contact', 'last_message'],
    order: { last_message_at: 'DESC' },
    skip: (page - 1) * 20,
    take: 20
  });
  
  res.json(threads);
});

// Get Messages in Thread
router.get('/api/inbox/threads/:id/messages', async (req, res) => {
  const messages = await db.inboxMessages.find({
    where: { thread_id: req.params.id },
    order: { sent_at: 'ASC' }
  });
  res.json(messages);
});

// Send Reply
router.post('/api/inbox/threads/:id/reply', async (req, res) => {
  const { body, attachments } = req.body;
  const thread = await db.inboxThreads.findById(req.params.id);
  
  // 1. Send via Provider (Gmail/Outlook/SMTP)
  const providerId = await emailService.sendReply(thread.account_id, {
    to: thread.contact.email,
    subject: `Re: ${thread.subject}`,
    body
  });
  
  // 2. Save to DB
  const message = await db.inboxMessages.create({
    thread_id: thread.id,
    direction: 'outbound',
    body_text: body,
    provider_message_id: providerId
  });
  
  res.json(message);
});

// Update Thread Status/Category
router.patch('/api/inbox/threads/:id', async (req, res) => {
  const { status, category, assignedTo } = req.body;
  const updated = await db.inboxThreads.update(req.params.id, {
    status, category, assigned_to: assignedTo
  });
  res.json(updated);
});


```

### Background Jobs

1. **`sync-worker`**: Polls email providers for accounts that don't support webhooks (e.g., standard IMAP).

2. **`intent-analyzer`**: Processes new inbound messages with an LLM to determine category (Interested, OOO, etc.) and sentiment.

3. **`cleanup-worker`**: Archives old threads or deletes spam based on retention policies.

---

**Last Updated:** November 25, 2025
**Status:** Available - Core Feature
**Target Release:** Q1 2026
**Owner:** Inbox Team
