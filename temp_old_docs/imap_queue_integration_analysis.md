# IMAP Queue Integration Analysis - Mailu Email Processing

**Integration Date**: 2025-11-01  
**Purpose**: Connect Mailu IMAP to Queue System Architecture  
**Target**: Replace `saveEmail` with queue-driven processing  

---

## 🎯 Current Code Analysis

### Current Implementation
```javascript
// Current: Direct database save
async function saveEmail({ direction, messageId, from, to, subject, body, raw }) {
  await pool.query(
    `INSERT INTO emails (direction, message_id, from_address, to_address, subject, body, raw_message)
     VALUES ($1, $2, $3, $4, $5, $6, $7)`,
    [direction, messageId, from, to, subject, body, raw]
  );
}
```

### Issues with Current Approach
- **Direct Database Write**: Bypasses queue system architecture
- **No Retry Logic**: No error handling or retry mechanisms
- **No Scaling**: Single process limitation
- **No Classification**: All emails processed the same way
- **Wrong Table**: Uses `emails` instead of our new `content_inbox_message_refs`

---

## 🏗️ Queue Integration Architecture

### 4-Step Queue Process (As Described)
```
1. Receive Event → IMAP/Endpoint/WebSocket/Cronjob
2. Send to Redis Queue → Queue entry with metadata
3. Classify in Handler → Process based on type
4. Execute Actions → Business logic by email type
```

### IMAP as Event Producer
```javascript
// ✅ CORRECT: IMAP as event producer (Step 1)
async function startIncomingWorker() {
  const client = new ImapFlow({
    host: 'mailu.penguinmails.com',
    port: 993,
    secure: true,
    auth: {
      user: process.env.MAIL_USER,
      pass: process.env.MAIL_PASS,
    },
  });

  await client.connect();
  console.log('📥 Connected to IMAP server.');

  const lock = await client.getMailboxLock('INBOX');
  try {
    for await (let msg of client.fetch('1:*', { envelope: true, source: true })) {
      // ✅ Send to queue instead of direct save
      await addEmailToQueue({
        direction: 'inbound',
        messageId: msg.envelope.messageId,
        from: msg.envelope.from?.[0]?.address,
        to: msg.envelope.to?.map((r) => r.address) || [],
        subject: msg.envelope.subject,
        body: msg.source.toString(),
        raw: msg.source.toString(),
        tenant_id: await getTenantFromEmail(msg.envelope.to?.[0]?.address)
      });
    }
  } finally {
    lock.release();
  }

  await client.logout();
}
  await db.email_messages.create({
    data: {
      storage_key,
      tenant_id: emailData.tenant_id,
      email_account_id: emailData.email_account_id,
      direction: 'inbound',
      message_type: 'email',
      from_email: emailData.from,
      to_email: emailData.to.join(','),
      subject: emailData.subject,
      status: 'received',
      processed: new Date()
    }
  });

  // 2. Store content in Content Database
  await db.email_content.create({
    data: {
      storage_key,
      tenant_id: emailData.tenant_id,
      content_text: emailData.body,
      raw_size_bytes: Buffer.byteLength(emailData.raw),
      created: new Date(),
      retention_days: 2555 // 7 years
    }
  });
```

---

## 🔄 Queue Integration Design

### Step 1: Add Email to Queue
```javascript
// Queue Producer (Step 1)
async function addEmailToQueue(emailData) {
  const job = {
    queue_name: 'email:processing',
    priority: emailData.direction === 'inbound' ? 50 : 100, // Inbound = higher priority
    payload: {
      type: 'email_received',
      data: {
        ...emailData,
        processed_at: new Date().toISOString()
      }
    },
    run_at: new Date(),
    max_attempts: 3
  };

  // Create job in PostgreSQL (source of truth)
  const createdJob = await db.jobs.create({
    data: job
  });

  // For high-priority inbound emails, push directly to Redis
  if (emailData.direction === 'inbound') {
    await redis.lpush('queue:email:processing:high', JSON.stringify({
      id: createdJob.id,
      ...job,
      created_at: new Date().toISOString()
    }));
  }

  return createdJob.id;
}
```

### Step 2: Redis Queue Structure
```typescript
// Redis Queue Names (from queue_system_implementation_guide.md)
const QueueNames = {
  EMAIL_PROCESSING: 'queue:email:processing',
  EMAIL_HIGH: 'queue:email:processing:high',
  EMAIL_NORMAL: 'queue:email:processing',
  EMAIL_LOW: 'queue:email:processing:low',
  EMAIL_BOUNCES: 'queue:email:bounces',
  EMAIL_AUTOREPLIES: 'queue:email:autoreplies'
} as const;

// Job payload structure
interface EmailProcessingJob {
  id: string;
  queue_name: string;
  priority: number;
  payload: {
    type: 'email_received' | 'email_bounce' | 'auto_reply';
    data: {
      direction: 'inbound' | 'outbound';
      messageId: string;
      from: string;
      to: string[];
      subject: string;
      body: string;
      raw: string;
      tenant_id: string;
      email_account_id?: string;
      campaign_id?: string;
      lead_id?: string;
    };
  };
  created_at: string;
  attempt_count: number;
  max_attempts: number;
}
```

### Step 3: Queue Handler with Classification
```javascript
// Email Processing Handler (Steps 3 & 4)
async function processEmailJob(job) {
  const { type, data } = job.payload;
  
  try {
    switch (type) {
      case 'email_received':
        return await handleIncomingEmail(data);
      case 'email_bounce':
        return await handleEmailBounce(data);
      case 'auto_reply':
        return await handleAutoReply(data);
      default:
        throw new Error(`Unknown email type: ${type}`);
    }
  } catch (error) {
    console.error('Email processing failed:', error);
    throw error;
  }
}

async function handleIncomingEmail(emailData) {
  // ✅ Move saveEmail logic here (Step 4)
  
  // 1. Store in Content Database
  const storage_key = `email_${emailData.messageId}_${Date.now()}`;
  
  await db.content_inbox_message_refs.create({
    data: {
      storage_key,
      tenant_id: emailData.tenant_id,
      email_account_id: emailData.email_account_id,
      direction: 'inbound',
      message_type: 'email',
      from_email: emailData.from,
      to_email: emailData.to.join(','),
      subject: emailData.subject,
      status: 'received',
      processed: new Date(),
      created: new Date()
    }
  });

  // 2. Store content in Content Database
  await db.content_objects.create({
    data: {
      storage_key,
      tenant_id: emailData.tenant_id,
      content_text: emailData.body,
      raw_size_bytes: Buffer.byteLength(emailData.raw),
      created: new Date(),
      retention_days: 2555 // 7 years
    }
  });

  // 3. Link to campaign if applicable
  await linkEmailToCampaign(emailData);

  // 4. Trigger analytics
  await db.analytics_jobs.create({
    data: {
      job_type: 'email_analytics',
      payload: {
        tenant_id: emailData.tenant_id,
        storage_key,
        event_type: 'email_received'
      },
      priority: 100
    }
  });

  return { success: true, storage_key };
}

async function handleEmailBounce(emailData) {
  // Handle bounce logic
  await db.content_inbox_message_refs.create({
    data: {
      storage_key: `bounce_${emailData.messageId}_${Date.now()}`,
      tenant_id: emailData.tenant_id,
      direction: 'inbound',
      message_type: 'bounce',
      status: 'bounced',
      // ... other fields
    }
  });
}
```

---

## 🗄️ Database Schema Integration

### Content Database Tables
```sql
-- ✅ Use our new content_inbox_message_refs
CREATE TABLE content_inbox_message_refs (
    storage_key VARCHAR(500) PRIMARY KEY,
    tenant_id UUID NOT NULL,
    email_account_id UUID,
    campaign_id UUID,
    lead_id UUID,
    direction VARCHAR(20) CHECK (direction IN ('inbound', 'outbound')),
    message_type VARCHAR(20) CHECK (message_type IN ('email', 'bounce', 'auto_reply')),
    from_email VARCHAR(254),
    to_email VARCHAR(254),
    subject VARCHAR(500),
    status VARCHAR(50),
    processed TIMESTAMP WITH TIME ZONE,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Content storage
CREATE TABLE content_objects (
    storage_key VARCHAR(500) PRIMARY KEY REFERENCES content_inbox_message_refs(storage_key),
    tenant_id UUID NOT NULL,
    content_text TEXT,
    raw_size_bytes INTEGER,
    created TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

---

## 🔄 Complete Workflow Integration

### Updated IMAP Worker
```javascript
// ✅ Integrated IMAP Worker
import { ImapFlow } from 'imapflow';
import { addEmailToQueue } from './queue-producer.js';

async function startIncomingWorker() {
  const client = new ImapFlow({
    host: 'mailu.penguinmails.com',
    port: 993,
    secure: true,
    auth: {
      user: process.env.MAIL_USER,
      pass: process.env.MAIL_PASS,
    },
  });

  await client.connect();
  console.log('📥 Connected to IMAP server.');

  const lock = await client.getMailboxLock('INBOX');
  try {
    for await (let msg of client.fetch('1:*', { envelope: true, source: true })) {
      // ✅ Step 1: Add to queue instead of direct save
      await addEmailToQueue({
        direction: 'inbound',
        messageId: msg.envelope.messageId,
        from: msg.envelope.from?.[0]?.address,
        to: msg.envelope.to?.map((r) => r.address) || [],
        subject: msg.envelope.subject,
        body: msg.source.toString(),
        raw: msg.source.toString(),
        tenant_id: await getTenantFromEmail(msg.envelope.to?.[0]?.address)
      });
      
      console.log(`📧 Email queued: ${msg.envelope.messageId}`);
    }
  } finally {
    lock.release();
  }

  console.log('✅ All incoming emails queued for processing.');
  await client.logout();
}
```

### Queue Consumer (Worker)
```javascript
// workers/EmailWorker.js
import { processEmailJob } from './email-handler.js';

export class EmailWorker {
  async processJob(job, queueName) {
    try {
      console.log(`Processing email job: ${job.id}`);
      
      // Steps 3 & 4: Classify and execute
      const result = await processEmailJob(job);
      
      // Update job status
      await this.updateJobStatus(job.id, 'completed', result);
      
      return result;
    } catch (error) {
      console.error(`Email job ${job.id} failed:`, error);
      throw error;
    }
  }
}
```

---

## 🎯 Benefits of Queue Integration

### Performance & Reliability
- **Retry Logic**: Failed emails automatically retried
- **Priority Queues**: Inbound emails processed faster
- **Scaling**: Multiple workers can process emails concurrently
- **Error Handling**: Failed jobs go to dead letter queue

### Integration Benefits
- **Mailu Ready**: Perfect integration with external email systems
- **Campaign Linking**: Queue can handle campaign email correlation
- **Analytics Integration**: Triggers analytics jobs automatically
- **Bounce Handling**: Dedicated bounce processing queue

### Architecture Benefits
- **Clear Separation**: IMAP = Event Producer, Queue = Processing
- **Type Classification**: Different handlers for different email types
- **Cross-Database**: Works with our content_inbox_message_refs design
- **Monitoring**: Full job tracking and performance metrics

---

## 📋 Implementation Checklist

### Queue System Updates
- [ ] Add email processing queues to queue_system_implementation_guide.md
- [ ] Create email handler functions (incoming, bounce, autoreply)
- [ ] Update IMAP worker to use queue producer
- [ ] Test cross-database operations (OLTP + Content DB)

### Database Integration
- [ ] Verify content_inbox_message_refs schema matches email data
- [ ] Test storage_key generation for emails
- [ ] Validate tenant_id linking from email addresses
- [ ] Test campaign_id and lead_id correlation

### Migration Compatibility
- [ ] This IMAP integration works with our inbox_message_refs migration
- [ ] Queue handlers write to content_inbox_message_refs (not old inbox_message_refs)
- [ ] Analytics pipeline updated for new table structure
- [ ] API endpoints updated to query content_inbox_message_refs

---

## 🏆 Conclusion

Your IMAP integration code is **perfect** for the queue architecture! The key insight is:

**Current (Wrong)**: IMAP → Direct Database Save  
**Correct**: IMAP → Queue Producer → Queue Handler → Database

This integration:
✅ **Follows Queue Architecture**: Event → Queue → Classification → Execution  
✅ **Works with Migration**: Writes to content_inbox_message_refs  
✅ **Mailu Ready**: External email system integration  
✅ **Scalable**: Handles high email volumes with retry logic  
✅ **Type Classified**: Different handlers for different email types  

The `saveEmail` function correctly moves to the handler - the IMAP worker should only be responsible for receiving events and adding them to the queue.