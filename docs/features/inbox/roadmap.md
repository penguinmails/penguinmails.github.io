---
title: "Inbox Management Roadmap"
description: "Development roadmap for inbox management features including MVP gaps, Post-MVP enhancements, and AI-powered capabilities"
last_modified_date: "2025-11-26"
level: "2"
persona: "Product Managers, Engineering Teams"
---


# Inbox Management Roadmap

This document outlines the development roadmap for inbox management features, including MVP gaps, Post-MVP enhancements, and future AI-powered capabilities.

## Current Status

**Unified Inbox**: Available (Q1 2026) - Core functionality documented with comprehensive database schemas and API specifications.

**Inbox Rotation**: Available (Q1 2026) - Smart load balancing with health monitoring and auto-recovery workflows.

**Critical Blocker**: Stalwart Mail Server database schema investigation required before MVP implementation can proceed.

## Roadmap Overview

### MVP Timeline (Q4 2025 - Q1 2026)

**Q4 2025**: Architecture spike to investigate Stalwart integration (3-5 days)

**Q1 2026**: Core inbox features implementation (2-4 weeks post-spike)

- Email threading algorithm

- Star/favorite functionality

- Folder/view system (All, Starred, Sent, Archived, Trash)

- Attachment support documentation

- Browser notifications integration

### Post-MVP Timeline (Q2 2026 - Q1 2027)

**Q2 2026**: AI features and analytics (7-10 weeks)

- Smart reply suggestions (Gemini AI)

- Sentiment analysis and tone detection

- Advanced inbox analytics and reporting

- Performance benchmarks and load testing

- Scheduled sending

- Lead context sidebar

**Q3 2026**: International expansion and optimization (3-4 weeks)

- Offline support (IndexedDB)

- Multi-language support and translation

- AI enhancements research spike

## MVP Roadmap Items

### 🚨 Critical Blocker

#### 1. Stalwart Mail Server Database Schema Investigation

**Priority**: P0 (Critical Blocker)
**Timeline**: Q4 2025
**Effort**: 3-5 days (spike)

**Problem**: The current inbox documentation proposes custom tables without investigating how they integrate with Stalwart Mail Server's existing PostgreSQL schema.

**Spike Goals**:

- Review Stalwart documentation and analyze email storage tables

- Determine if we can extend Stalwart's schema with custom fields

- Evaluate 4 architecture options (extend Stalwart, OLTP metadata, Content DB metadata, hybrid)

- Create proof-of-concept to validate chosen approach

- Update documentation with correct schema design

**Blocks**: All inbox development (threading, star/favorite, folders)

**Related Documentation**:

- `tasks/spike-stalwart-database-schema-investigation.md`

- [Unified Inbox Overview](/docs/features/inbox/unified-inbox/overview)

---

### Core Inbox Features (Post-Spike)

#### 2. Email Threading Algorithm Implementation

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 1-2 weeks (depends on Stalwart spike)

**Description**: Implement email threading to correctly associate replies with original outbound messages and campaigns using RFC 5322 headers (References, In-Reply-To) with fallback logic.

**Acceptance Criteria**:

- Match replies using standard email headers

- Fallback to Subject + Contact matching

- Handle edge cases (forwarded emails, subject changes)

- Create database schema based on spike architecture decision

- Test threading accuracy with 100+ real-world samples

**Dependencies**: Stalwart Database Schema Investigation (Task 1)

---

#### 3. Star/Favorite Feature

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 2-3 days (depends on Stalwart spike)

**Description**: Enable users to star/favorite important threads for quick access, helping sales reps prioritize hot leads and urgent follow-ups.

**Acceptance Criteria**:

- Add `is_starred` field to thread storage

- Implement star/unstar API endpoint

- Add star icon to thread list UI with toggle

- Create "Starred" inbox view

- Add keyboard shortcut (e.g., "s" key)

- Persist star state across sessions

**Dependencies**: Stalwart Investigation (Task 1), Email Threading (Task 2)

---

#### 4. Folder/View System

**Priority**: P0 (MVP Critical)
**Timeline**: Q1 2026
**Effort**: 3-5 days (depends on Stalwart spike)

**Description**: Implement standard inbox folder/view system (All, Starred, Sent, Archived, Trash) to organize threads like Gmail and Outlook.

**Acceptance Criteria**:

- Add `folder` field to thread storage

- Implement folder navigation in inbox sidebar

- Create API endpoints for moving threads between folders

- Add "Archive" and "Delete" actions with bulk support

- Implement soft delete (trash folder, permanent delete after 30 days)

- Add keyboard shortcuts (e: archive, #: delete)

- Add "Undo" functionality

**Dependencies**: Stalwart Investigation (Task 1), Email Threading (Task 2)

---

#### 5. Attachment Support Documentation

**Priority**: P2 (MVP Nice-to-Have)
**Timeline**: Q1 2026
**Effort**: 1-2 days (documentation only)

**Description**: Document how inbox attachments integrate with the existing Content Database schema.

**Current State**: Content Database has complete `attachments` table schema, but inbox feature docs don't reference it.

**Acceptance Criteria**:

- Update inbox docs to reference Content DB attachments table

- Document file size limits (recommend 25 MB per attachment)

- Document virus scanning approach (ClamAV or cloud service)

- Add file upload UI specifications to route docs

- Add attachment display specifications to conversation view

**Dependencies**: None (Content DB schema already exists)

---

#### 6. Browser Notifications Integration

**Priority**: P2 (MVP Nice-to-Have)
**Timeline**: Q1 2026
**Effort**: 1-2 days (integration only)

**Description**: Integrate inbox messages with the existing Notifications Database to enable browser notifications for new replies.

**Current State**: Notifications Database has complete schema, but inbox messages don't trigger browser notifications.

**Acceptance Criteria**:

- Request browser notification permission on first inbox visit

- Create notification when new reply arrives (sender, subject, preview)

- Link notification click to specific thread

- Allow users to configure notification preferences

- Respect "Do Not Disturb" hours (user-configurable)

- Reuse existing `notifications` table

**Dependencies**: None (Notifications DB schema already exists)

---

## Post-MVP Roadmap Items

### AI-Powered Features (Q2 2026)

#### 7. Smart Reply Suggestions (Gemini AI)

**Priority**: P1 (High Value)
**Timeline**: Q2 2026
**Effort**: 1-2 weeks

**Description**: Integrate Google Gemini AI to generate smart reply suggestions based on message content and conversation history.

**Use Case**: When a prospect asks "What's your pricing for 10,000 contacts?", the system generates 3 reply options with different tones (direct, consultative, meeting-focused).

**Acceptance Criteria**:

- Integrate Google Gemini AI API

- Pass message history and context files to AI

- Generate 3 reply suggestions with different tones

- Add "Smart Reply" button to conversation view

- Allow one-click insertion with editing

- Track usage metrics

**Cost**: Free tier (1,500 requests/day), then $0.00025 per 1K tokens (~$37.50/month for 10,000 messages/day)

**Dependencies**: Unified Inbox MVP completion

---

#### 8. Sentiment Analysis & Tone Detection

**Priority**: P1 (High Value)
**Timeline**: Q2 2026
**Effort**: 3-5 days

**Description**: Use Google Gemini AI to analyze message sentiment and tone, enabling sales reps to tailor responses based on prospect emotions.

**Use Case**: Detect if a prospect is Frustrated, Enthusiastic, or Skeptical and provide tone-based reply suggestions.

**Acceptance Criteria**:

- Pass message content to Gemini AI for sentiment analysis

- Add `sentiment` and `tone` fields to message storage

- Display sentiment indicators in thread list and conversation view

- Provide tone-based reply suggestions

- Add sentiment filtering

- Track sentiment trends over time

**Cost**: Shared with Smart Reply Suggestions (same Gemini AI usage)

**Dependencies**: Unified Inbox MVP completion

---

### Analytics & Performance (Q2 2026)

#### 9. Advanced Inbox Analytics & Reporting

**Priority**: P1 (High Value)
**Timeline**: Q2 2026
**Effort**: 3-4 weeks

**Description**: Build advanced analytics dashboard for inbox performance metrics, extending the existing OLAP Analytics Database with inbox-specific tables.

**Current State**: OLAP database has analytics for billing, campaigns, mailboxes, leads, warmups, and sequence steps, but no dedicated inbox analytics tables.

**Gap**: No tables for response time, rep performance, or category-based conversion metrics.

**Acceptance Criteria**:

- **Create OLAP analytics tables**:

  - `inbox_analytics` - Daily aggregated inbox metrics

  - `inbox_rep_analytics` - Per-rep performance metrics

  - `inbox_category_analytics` - Per-category conversion metrics

  - Link to existing `billing_analytics` via foreign key

- **Create ETL jobs** to populate OLAP tables from OLTP data

- **Build reporting dashboard** with 10+ key metrics:

  - Average response time (overall, by rep, by campaign)

  - Conversion rate by AI category

  - Time-to-close analysis

  - Rep performance leaderboard

  - Category distribution

  - Thread volume trends

- Add custom report builder and export to CSV/PDF

- Add scheduled report emails (daily/weekly digests)

- Update OLAP documentation with new tables

**Dependencies**: Unified Inbox MVP, Sentiment Analysis (for category-based analytics)

**Related Documentation**:

- [OLAP Analytics Schema Guide](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide)

- [OLAP Database Overview](/docs/implementation-technical/database-infrastructure/olap-database/README)

---

#### 10. Performance Benchmarks & Load Testing

**Priority**: P2 (Optimization)
**Timeline**: Q2 2026
**Effort**: 1 week (spike + ongoing monitoring)

**Description**: Conduct performance spike to establish baseline metrics for inbox message aggregation at scale.

**Use Case**: Validate that the system can handle 5,000 email accounts with real-time synchronization without lag.

**Acceptance Criteria**:

- Establish baseline metrics (<2s sync latency, <1s load time)

- Add performance monitoring to aggregation service

- Create load testing suite (JMeter or k6)

- Test concurrent users (100, 500, 1,000 simultaneous users)

- Measure message throughput (messages/second)

- Set up alerts for performance degradation

**Dependencies**: Unified Inbox MVP completion

---

### Convenience Features (Q2 2026)

#### 11. Scheduled Sending

**Priority**: P2 (Nice-to-Have)
**Timeline**: Q2 2026
**Effort**: 3-5 days

**Description**: Enable users to schedule replies to send at a specific date/time, allowing sales reps to draft messages outside business hours.

**Use Case**: Draft a reply at 11 PM but schedule it to send at 9 AM the next day during business hours.

**Acceptance Criteria**:

- Add `scheduled_send_at` field to message storage

- Create background job to process scheduled sends

- Add UI for scheduling (date/time picker, timezone selector)

- Allow editing/canceling scheduled messages

- Handle account unavailability gracefully

- Send confirmation notification when message is sent

**Dependencies**: Unified Inbox MVP completion

---

#### 12. Lead Context Sidebar

**Priority**: P2 (High Value, Requires Spike)
**Timeline**: Q2 2026
**Effort**: 2-3 weeks (1 week spike + 1-2 weeks implementation)

**Description**: Display lead context in a sidebar when viewing a thread, showing contact information, lead score, previous campaigns, and CRM data.

**Use Case**: When replying to a prospect, see their company size, industry, previous interactions, and lead score for personalized responses.

**Acceptance Criteria**:

- Conduct user research spike to identify most valuable context data

- Display contact information (name, email, company, title)

- Show lead score and scoring factors

- List previous campaigns and interactions

- Show CRM data (if integrated)

- Add quick actions (update lead score, add to campaign, sync to CRM)

- Make sidebar collapsible

**Dependencies**: Unified Inbox MVP, Lead Scoring feature

---

### International Expansion (Q3 2026)

#### 13. Offline Support (IndexedDB)

**Priority**: P3 (Low Priority)
**Timeline**: Q3 2026
**Effort**: 3-5 days

**Description**: Enable offline inbox access by caching recent threads and messages in IndexedDB.

**Use Case**: Sales rep on a flight can read messages and draft replies offline, which sync automatically when reconnected.

**Acceptance Criteria**:

- Cache recent threads (last 100) in IndexedDB

- Cache messages for open threads

- Allow drafting replies offline

- Sync drafts to server when reconnected

- Show "Offline Mode" indicator in UI

- Handle conflicts (e.g., thread archived while offline)

**Dependencies**: Unified Inbox MVP completion

---

#### 14. Multi-Language Support & Translation

**Priority**: P2 (Global Expansion)
**Timeline**: Q3 2026
**Effort**: 1-2 weeks

**Description**: Integrate translation API (Google Translate or DeepL) to automatically detect and translate non-English emails.

**Use Case**: A German prospect replies in German. The system detects language and shows English translation below the original message.

**Acceptance Criteria**:

- Integrate translation API (Google Translate or DeepL)

- Add `detected_language` field to message storage

- Display original + translated text in UI

- Support 10+ major languages

- Add language filter to inbox views

**Cost**:

- Google Translate: $20 per 1M characters

- DeepL: $5.49-24.99 per 1M characters (higher quality)

**Dependencies**: Unified Inbox MVP completion

---

#### 15. AI Enhancements Research Spike

**Priority**: P2 (Exploration)
**Timeline**: Q3 2026
**Effort**: 1-2 weeks (research only)

**Description**: Conduct time-boxed research spike to explore additional AI-powered inbox features (smart prioritization, advanced automation, engagement optimization).

**Acceptance Criteria**:

- Conduct user interviews to identify top inbox pain points (10-15 users)

- Prototype 2-3 AI features with Gemini AI

- Measure impact on key metrics (response time, conversion rate)

- Document findings with go/no-go recommendations

- Create roadmap for validated features

**Dependencies**: Smart Reply Suggestions, Sentiment Analysis

---

## Roadmap Summary

### Timeline Overview

| Quarter | Focus Area | Key Deliverables | Estimated Effort |
|---------|-----------|------------------|------------------|
| **Q4 2025** | Architecture | Stalwart Database Schema Investigation | 3-5 days |
| **Q1 2026** | MVP Core | Threading, Star/Favorite, Folders, Attachments, Notifications | 2-4 weeks |
| **Q2 2026** | AI & Analytics | Smart Replies, Sentiment, Analytics, Performance, Scheduled Sending, Lead Context | 7-10 weeks |
| **Q3 2026** | International | Offline Support, Multi-Language, AI Research Spike | 3-4 weeks |

### Priority Breakdown

**P0 (Critical Blockers)**:

- Stalwart Database Schema Investigation

- Email Threading Algorithm

- Star/Favorite Feature

- Folder/View System

**P1 (High Value)**:

- Smart Reply Suggestions

- Sentiment Analysis

- Advanced Analytics

**P2 (Nice-to-Have)**:

- Attachment Support Docs

- Browser Notifications

- Performance Benchmarks

- Scheduled Sending

- Lead Context Sidebar

- Multi-Language Support

- AI Research Spike

**P3 (Low Priority)**:

- Offline Support

### Critical Path

1. **Stalwart Database Schema Investigation (Q4 2025)** - BLOCKS ALL INBOX DEVELOPMENT

2. **Email Threading Algorithm (Q1 2026)** - Foundation for all inbox features

3. **Star/Favorite + Folder/View System (Q1 2026)** - Core inbox UX

4. **AI Features (Q2 2026)** - Competitive differentiation

5. **Analytics & Performance (Q2 2026)** - Optimization and insights

### Key Dependencies

- All inbox development blocked by Stalwart spike (Task 1)

- AI features require MVP completion (Tasks 1-4)

- Analytics requires sentiment analysis for category-based metrics

- Lead context sidebar requires lead scoring feature

### Cost Estimates

**MVP (Q1 2026)**: $0/month (no external dependencies)

**Post-MVP (Q2-Q3 2026)**:

- Gemini AI: $0-37.50/month (free tier covers early usage)

- Translation APIs: $20-50/month (estimated)

- **Total**: $20-87.50/month

**Long-term Optimization**:

- Train custom intent classification model (Q1 2027) to reduce AI costs by 80-90%

---

## Related Documentation

### Feature Documentation

- [Unified Inbox Overview](/docs/features/inbox/unified-inbox/overview)

- [Inbox Rotation Overview](/docs/features/inbox/inbox-rotation/overview)

### Technical Documentation

- [Tenant Inbox Routes](/docs/design/routes/tenant-inbox)

- [OLAP Analytics Schema Guide](/docs/implementation-technical/database-infrastructure/olap-database/schema-guide)

- [Content Database Schema Guide](/docs/implementation-technical/database-infrastructure/content-database/schema-guide)

- [Notifications Database Schema Guide](/docs/implementation-technical/database-infrastructure/notifications-database/schema-guide)

### Related Features

- [Campaign Management](/docs/features/campaigns/campaign-management/overview)

- [Lead Scoring](/docs/features/leads/lead-scoring)

- [Reputation Monitoring](/docs/features/warmup/reputation-monitoring)

- [CRM Integration](/docs/features/integrations/crm-integration/overview)

### Implementation Tasks

- `tasks/spike-stalwart-database-schema-investigation.md`

- Epic 8: Inbox Management

---

**Last Updated**: November 26, 2025
**Status**: Roadmap defined, awaiting Stalwart spike completion
**Next Review**: After Stalwart spike (Q4 2025)

