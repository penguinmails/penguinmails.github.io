---
title: "Inbox Management Roadmap"
description: "Email inbox features and Stalwart integration"
last_modified_date: "2025-12-04"
level: "2"
persona: "Technical Operations"
keywords: "inbox, email management, stalwart, imap, smtp"
---

# Inbox Management Roadmap

## Feature Deep Dive: Inbox Management

### Overview

**Status:** Architecture Spike Required (Critical Blocker)
**Timeline:** Q4 2025 (Spike) → Q1 2026 (MVP) → Q2-Q3 2026 (AI & Analytics)
**Priority:** Critical (Foundation feature for response management)

### Current State: Architecture Investigation Required

## What's Documented

- ✅ Complete unified inbox architecture with database schemas

- ✅ AI intent detection system design (Gemini AI integration)

- ✅ Inbox rotation algorithm with health monitoring

- ✅ Route specifications for inbox UI (2 routes)

- ✅ API endpoint specifications (5 endpoints)

- ✅ Background job architecture (sync-worker, intent-analyzer, cleanup-worker)

## Critical Gap - Stalwart Integration

The current documentation proposes custom tables (`inbox_threads`, `inbox_messages`, `inbox_tags`, `inbox_notes`) without investigating how they integrate with Stalwart Mail Server's existing PostgreSQL schema.

## Required Investigation

- Can we extend Stalwart's schema with custom fields?

- Should inbox metadata live in OLTP, Content DB, or Stalwart's database?

- How does Stalwart store emails and can we add foreign keys?

**Impact:** This architectural decision blocks all inbox development. A 3-5 day spike is required to determine the correct approach.

### MVP Roadmap (Q4 2025 - Q1 2026)

### Q4 2025: Architecture Spike (B

- **[P0] Stalwart Mail Server Database Schema Investigation** (3-5 days)

  - Review Stalwart documentation and analyze email storage tables

  - Determine if we can extend Stalwart's schema with custom fields

  - Evaluate 4 architecture options (extend Stalwart, OLTP metadata, Content DB metadata, hybrid)

  - Create proof-of-concept to validate chosen approach

  - Update documentation with correct schema design

  - **Business Impact:** Unblocks all inbox development, foundational architecture decision

### Q1 2026: Core Inbox Features (

- **[P0] Email Threading Algorithm Implementation** (1-2 weeks)

  - Match replies using RFC 5322 headers (References, In-Reply-To)

  - Fallback to Subject + Contact matching

  - Handle edge cases (forwarded emails, subject changes)

  - Test threading accuracy with 100+ real-world samples

  - **Business Impact:** Foundation for conversation-based inbox management

- **[P0] Star/Favorite Feature** (2-3 days)

  - Add `is_starred` field to thread storage

  - Implement star/unstar API endpoint

  - Add star icon to thread list UI with toggle

  - Create "Starred" inbox view

  - **Business Impact:** Standard inbox feature, helps sales reps prioritize hot leads

- **[P0] Folder/View System** (3-5 days)

  - Implement All, Starred, Sent, Archived, Trash views

  - Add "Archive" and "Delete" actions with bulk support

  - Implement soft delete (trash folder, permanent delete after 30 days)

  - Add keyboard shortcuts (e: archive, #: delete)

  - **Business Impact:** Core inbox UX, expected by users from Gmail/Outlook

- **[P2] Attachment Support Documentation** (1-2 days)

  - Document integration with existing Content DB attachments table

  - Document file size limits (25 MB per attachment)

  - Document virus scanning approach (ClamAV or cloud service)

  - **Business Impact:** Clarifies existing infrastructure, minimal effort

- **[P2] Browser Notifications Integration** (1-2 days)

  - Integrate with existing Notifications Database

  - Request browser notification permission on first inbox visit

  - Create notification when new reply arrives

  - Allow users to configure notification preferences

  - **Business Impact:** Immediate awareness of hot lead replies, improves response time

**Total MVP Effort:** Unknown until Stalwart spike complete (estimated 2-4 weeks post-spike)

### Post-MVP Roadmap (Q2-Q3 2026)

### Q2 2026: AI Features & Analyti

- **[P1] Smart Reply Suggestions (Gemini AI)** (1-2 weeks)

  - Generate 3 reply options with different tones (direct, consultative, meeting-focused)

  - Pass message history and context files to Gemini AI

  - Allow one-click insertion with editing

  - Track usage metrics

  - **Business Impact:** Improves sales rep efficiency, competitive differentiator

  - **Cost:** Free tier (1,500 requests/day), then $37.50/month for 10,000 messages/day

- **[P1] Sentiment Analysis & Tone Detection** (3-5 days)

  - Detect sentiment (positive/neutral/negative) and tone (enthusiastic/skeptical/frustrated)

  - Display sentiment indicators in thread list

  - Provide tone-based reply suggestions

  - Track sentiment trends over time

  - **Business Impact:** Enables tailored responses based on prospect emotions

  - **Cost:** Shared with Smart Reply Suggestions (same Gemini AI usage)

- **[P1] Advanced Inbox Analytics & Reporting** (3-4 weeks)

  - Create OLAP analytics tables (`inbox_analytics`, `inbox_rep_analytics`, `inbox_category_analytics`)

  - Build reporting dashboard with 10+ key metrics (response time, conversion rate, rep performance)

  - Add custom report builder and export to CSV/PDF

  - Add scheduled report emails (daily/weekly digests)

  - **Business Impact:** Data-driven optimization, rep performance tracking, manager visibility

- **[P2] Performance Benchmarks & Load Testing** (1 week)

  - Establish baseline metrics (<2s sync latency, <1s load time)

  - Create load testing suite (JMeter or k6)

  - Test concurrent users (100, 500, 1,000 simultaneous users)

  - **Business Impact:** Validates scalability for agency customers with 5,000+ accounts

- **[P2] Scheduled Sending** (3-5 days)

  - Enable scheduling replies to send at specific date/time

  - Add UI for scheduling (date/time picker, timezone selector)

  - Allow editing/canceling scheduled messages

  - **Business Impact:** Professional communication timing, avoid appearing desperate

- **[P2] Lead Context Sidebar** (2-3 weeks)

  - Display contact information, lead score, previous campaigns, CRM data

  - Add quick actions (update lead score, add to campaign, sync to CRM)

  - Make sidebar collapsible

  - **Business Impact:** Personalized responses based on prospect history

**Total Q2 2026 Effort:** 7-10 weeks

### Q3 2026: International Expansi

- **[P3] Offline Support (IndexedDB)** (3-5 days)

  - Cache recent threads (last 100) in IndexedDB

  - Allow drafting replies offline

  - Sync drafts to server when reconnected

  - **Business Impact:** Mobile/travel use case, improves UX in low-connectivity scenarios

- **[P2] Multi-Language Support & Translation** (1-2 weeks)

  - Integrate translation API (Google Translate or DeepL)

  - Display original + translated text in UI

  - Support 10+ major languages

  - **Business Impact:** Enables global outreach without multilingual sales teams

  - **Cost:** $20-50/month (estimated)

- **[P2] AI Enhancements Research Spike** (1-2 weeks)

  - Conduct user interviews to identify top inbox pain points

  - Prototype 2-3 AI features with Gemini AI

  - Measure impact on key metrics

  - **Business Impact:** Validates future AI features before committing to implementation

**Total Q3 2026 Effort:** 3-4 weeks

### Total Post-MVP Effort

**Effort:** 10-14 weeks spread across Q2-Q3 2026
**Priority Distribution:** 3 P1 features, 4 P2 features, 1 P3 feature

### Key Dependencies

## Stalwart Integration

- All inbox development blocked by Stalwart spike (Q4 2025)

- Architecture decision determines database schema approach

- Proof-of-concept validates chosen approach

## Infrastructure

- Content Database (attachments) - Already exists

- Notifications Database (browser notifications) - Already exists

- OLAP Analytics Database - Needs inbox-specific tables (Q2 2026)

- Gemini AI API - Required for AI features (Q2 2026)

## Features

- Lead Scoring - Required for lead context sidebar (Q2 2026)

- CRM Integration - Required for lead context sidebar (Q2 2026)

### Success Metrics

## Technical

- Email threading accuracy > 95%

- Inbox sync latency < 2 seconds

- Inbox load time < 1 second (10,000 threads)

- Concurrent users supported: 1,000+

- AI reply suggestion accuracy > 80%

- Sentiment analysis accuracy > 85%

## Business

- Inbox adoption > 90% of active users

- Average response time reduced by 30%

- AI reply suggestions used in 40%+ of replies

- Sentiment-based optimization improves conversion by 15%

- Rep performance visibility improves manager satisfaction

- Agency customers can manage 5,000+ accounts without lag

### Cost Estimates

**MVP (Q1 2026):** $0/month (no external dependencies)

## Post-MVP (Q2-Q3 2026)

- Gemini AI: $0-37.50/month (free tier covers early usage)

- Translation APIs: $20-50/month (estimated)

- **Total:** $20-87.50/month

## Long-term Optimization

- Train custom intent classification model (Q1 2027) to reduce AI costs by 80-90%

**Detailed Roadmap:** [Inbox Management Roadmap](/docs/features/inbox/roadmap)

---
