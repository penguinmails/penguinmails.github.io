# Spike: Stalwart Mail Server Database Schema Investigation

**Priority:** P0 (Blocks Unified Inbox MVP)  
**Timeline:** Q4 2025  
**Estimated Effort:** 3-5 days  
**Assignee:** Backend Developer  
**Status:** Not Started

---

## Context

PenguinMails uses **Stalwart Mail Server** for SMTP/IMAP operations. The unified inbox feature requires storing email metadata (threads, stars, categories, tags) but we don't know:

1. How Stalwart stores emails in PostgreSQL
2. Whether we can extend Stalwart's schema with custom fields
3. Where inbox metadata should live (OLTP, Content DB, or Stalwart's schema)

**Current Problem:** `docs/features/inbox/unified-inbox/overview.md` proposes custom tables (`inbox_threads`, `inbox_messages`) without investigating Stalwart integration.

**Blocking:** All unified inbox development is blocked until we understand Stalwart's database architecture.

---

## Spike Goals

1. **Understand Stalwart's PostgreSQL schema** for email storage
2. **Determine if we can extend Stalwart's schema** with custom fields
3. **Recommend the best architecture** for storing inbox metadata
4. **Create a proof-of-concept** to validate the chosen approach

---

## Tasks

### 1. Investigate Stalwart PostgreSQL Schema (2-3 days)

**Reference:** <https://stalw.art/docs/storage/backends/postgresql>

**Questions to Answer:**

- [ ] **Email Storage:**
  - How does Stalwart store emails in PostgreSQL?
  - What tables exist? (messages, threads, folders, etc.)
  - What fields are available? (message_id, subject, body, headers, etc.)
  - How are emails linked to mailboxes/accounts?

- [ ] **Threading:**
  - Does Stalwart support email threading?
  - How are threads identified? (In-Reply-To, References headers?)
  - Can we access thread information via SQL queries?

- [ ] **Folders/Labels:**
  - How does Stalwart handle folders (Inbox, Sent, Trash, etc.)?
  - Can we add custom folders or labels?
  - How are emails assigned to folders?

- [ ] **Schema Extensibility:**
  - Can we add custom fields to Stalwart's tables? (e.g., `is_starred`, `category`, `tenant_id`)
  - Can we add foreign keys from Stalwart tables to our OLTP tables?
  - Will custom fields survive Stalwart upgrades?
  - Are there any Stalwart APIs or hooks for custom metadata?

- [ ] **Performance:**
  - How does Stalwart index emails for fast retrieval?
  - Can we add custom indexes for our queries?
  - What's the performance impact of joining Stalwart tables with OLTP/Content DB?

**Deliverables:**

- [ ] Document Stalwart's PostgreSQL schema (tables, fields, indexes)
- [ ] Document Stalwart's threading and folder logic
- [ ] Document schema extensibility options and limitations
- [ ] Create ER diagram of Stalwart's database schema

---

### 2. Evaluate Architecture Options (1-2 days)

Based on Stalwart investigation, evaluate these architecture options:

#### Option A: Extend Stalwart's PostgreSQL Schema

**Approach:** Add custom fields directly to Stalwart's tables.

**Pros:**

- Single source of truth for email data
- No synchronization needed
- Simpler queries (no joins across databases)

**Cons:**

- Tight coupling to Stalwart
- May break on Stalwart upgrades
- Limited control over schema design
- May not support all required fields

**Feasibility:** TBD (depends on Stalwart extensibility)

---

#### Option B: Store Inbox Metadata in OLTP

**Approach:** Create `inbox_threads`, `inbox_messages` tables in OLTP. Link to Stalwart via `provider_message_id`.

**Pros:**

- Full control over schema design
- Decoupled from Stalwart (easier upgrades)
- Can add any fields we need (is_starred, category, tenant_id, campaign_id, contact_id)
- Consistent with OLTP design principles

**Cons:**

- Requires synchronization between Stalwart and OLTP
- More complex queries (joins across databases)
- Potential for data inconsistency

**Feasibility:** High (standard approach for email clients)

---

#### Option C: Store Inbox Metadata in Content DB

**Approach:** Create inbox metadata tables in Content DB. Link to Stalwart via `storage_key`.

**Pros:**

- Keeps email-related data together
- Decoupled from Stalwart
- Content DB already handles email bodies and attachments

**Cons:**

- Content DB is meant for heavy content, not operational metadata
- Violates Content DB design principles (no operational state)
- More complex queries (joins across databases)

**Feasibility:** Medium (violates Content DB design principles)

---

#### Option D: Hybrid Approach

**Approach:** Store some fields in Stalwart (if extensible), some in OLTP/Content DB.

**Pros:**

- Balances performance and flexibility
- Can leverage Stalwart's built-in features (threading, folders)
- Can add custom fields in OLTP for PenguinMails-specific metadata

**Cons:**

- Most complex approach
- Requires careful design to avoid confusion
- Synchronization challenges

**Feasibility:** Medium (depends on Stalwart extensibility)

---

**Deliverables:**

- [ ] Document pros/cons of each architecture option
- [ ] Recommend the best approach based on Stalwart investigation
- [ ] Create decision matrix (performance, maintainability, complexity, cost)

---

### 3. Create Proof-of-Concept (1 day)

**Goal:** Validate the recommended architecture with a working prototype.

**Tasks:**

- [ ] Set up Stalwart Mail Server with PostgreSQL backend
- [ ] Send test emails and inspect Stalwart's database
- [ ] Implement the recommended architecture (extend schema OR create OLTP tables)
- [ ] Test key operations:
  - Fetch emails from Stalwart
  - Add custom metadata (star, category, tags)
  - Query emails with filters (starred, category, date range)
  - Update metadata (mark as read, archive, delete)
- [ ] Measure performance (query latency, join overhead)

**Deliverables:**

- [ ] Working proof-of-concept code
- [ ] Performance benchmarks
- [ ] Documentation of any issues or limitations

---

### 4. Update Documentation (1 day)

**Tasks:**

- [ ] Update `docs/features/inbox/unified-inbox/overview.md` with correct schema approach
- [ ] Update `docs/implementation-technical/database-infrastructure/content-database/schema-guide.md` with Stalwart integration notes
- [ ] Update `docs/implementation-technical/database-infrastructure/oltp-database/schema-guide.md` if inbox metadata goes in OLTP
- [ ] Create detailed implementation tasks for unified inbox MVP (with accurate effort estimates)
- [ ] Add Stalwart schema documentation to `docs/implementation-technical/email-infrastructure/`

**Deliverables:**

- [ ] Updated documentation with Stalwart integration approach
- [ ] Implementation plan for unified inbox MVP
- [ ] Effort estimates for inbox features (threading, star/favorite, folders)

---

## Success Criteria

- [ ] Stalwart's PostgreSQL schema is fully documented
- [ ] Architecture decision is made and justified
- [ ] Proof-of-concept validates the chosen approach
- [ ] Documentation is updated with correct schema design
- [ ] Implementation plan is created with accurate effort estimates
- [ ] No blockers remain for unified inbox development

---

## Key Questions to Answer

1. **Can we extend Stalwart's schema?** If yes, what fields can we add?
2. **Where should inbox metadata live?** OLTP, Content DB, or Stalwart?
3. **How do we link Stalwart emails to campaigns/contacts?** Foreign keys? Message IDs?
4. **What's the performance impact?** Joins vs. denormalization?
5. **How do we handle Stalwart upgrades?** Will custom fields survive?

---

## References

- **Stalwart PostgreSQL Documentation:** <https://stalw.art/docs/storage/backends/postgresql>
- **Unified Inbox Feature Docs:** `docs/features/inbox/unified-inbox/overview.md`
- **Content DB Schema Guide:** `docs/implementation-technical/database-infrastructure/content-database/schema-guide.md`
- **OLTP Schema Guide:** `docs/implementation-technical/database-infrastructure/oltp-database/schema-guide.md`

---

## Notes

- This spike is **critical** for unified inbox development
- All inbox features (threading, star/favorite, folders, tags) depend on this architecture decision
- The spike should be completed **before** any inbox implementation work begins
- Budget 3-5 days for thorough investigation and proof-of-concept

---

**Last Updated:** November 26, 2025  
**Status:** Ready for Assignment  
**Priority:** P0 (Blocks MVP)
