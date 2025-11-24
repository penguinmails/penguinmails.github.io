---
title: "Inbox Rotation Roadmap"
timeline: "Q1-Q2 2026"
status: "planned"
priority: "medium"
completion: "0%"
dependencies: ["free-mailbox-creation", "unified-inbox"]
blocks: []
---

# Inbox Rotation Roadmap

## Overview

Intelligent inbox rotation system that distributes email sending across multiple mailboxes to improve deliverability and avoid rate limiting. Automatically selects the best mailbox for each send based on reputation, usage, and domain.

**Business Value**: Increases deliverability by 25%, prevents mailbox burnout, enables high-volume sending without spam flags.

## Timeline

- **Target Quarter**: Q1-Q2 2026
- **Start Date**: 2026-02-01
- **Target Completion**: 2026-04-30
- **Current Status**: Planned
- **Next Milestone**: Requirements phase

## Dependencies

### Required Before Starting

- 🔄 **[Free Mailbox Creation](./free-mailbox-creation.md)** - Must be complete (currently 80%)
- ⏳ **[Unified Inbox](./unified-inbox.md)** - Mailbox infrastructure needed
- ⏳ Reputation tracking system - Planned

### Blocks (Features Waiting on This)

- None (standalone optimization feature)

## Milestones

- [ ] **M1: Research & Algorithm Design** (Weeks 1-3)
  - [ ] Rotation algorithm research
  - [ ] Mailbox selection criteria definition
  - [ ] Load balancing strategy
  - [ ] Reputation scoring model
  
- [ ] **M2: Core Implementation** (Weeks 4-8)
  - [ ] Rotation engine backend
  - [ ] Mailbox health scoring
  - [ ] Smart selection algorithm
  - [ ] Rate limiting per mailbox
  - [ ] Rotation rules engine
  
- [ ] **M3: Configuration UI** (Weeks 9-11)
  - [ ] Rotation strategy configuration
  - [ ] Mailbox pool management
  - [ ] Rotation analytics dashboard
  - [ ] Manual override controls
  
- [ ] **M4: Testing & Optimization** (Weeks 12-13)
  - [ ] A/B testing rotation strategies
  - [ ] Performance optimization
  - [ ] Edge case handling
  - [ ] Launch preparation

## Related Documentation

### Feature Specification

- **[Inbox Rotation Feature Spec](../../features/inbox-rotation.md)** - Detailed feature requirements

### Technical Specifications

- **[Frontend: Rotation Config](../../design/routes/dashboard-rotation.md)** - UI specification
- **[API: Rotation Engine](../../implementation-technical/api/tenant-api/rotation.md)** - Backend API
- **[Load Balancing Architecture](../../technical/architecture/load-balancing.md)** - System design

### User Workflows

- **[Marketing Journey](../../user-journeys/marketing-journey.md)** - Rotation in campaign sending

### Implementation Tasks

- **[Inbox Rotation Epic](../../../tasks/inbox-rotation/)** - Development tasks

## Technical Details

### Rotation Strategies

#### Round Robin

- Distribute sends evenly across all mailboxes
- Simple, predictable
- Best for: Equal mailbox quality

#### Weighted Distribution

- Distribute based on mailbox reputation score
- Better mailboxes get more volume
- Best for: Mixed mailbox quality

#### Reputation-Based

- Only use mailboxes above reputation threshold
- Pause low-reputation mailboxes automatically
- Best for: Deliverability optimization

#### Domain-Based

- Match mailbox domain to recipient domain
- Improves trust signals
- Best for: Enterprise sending

### Mailbox Health Scoring

Factors (weighted):

- **Bounce rate** (30%): Lower is better
- **Spam complaint rate** (25%): Lower is better
- **Delivery success rate** (20%): Higher is better
- **Engagement rate** (15%): Higher is better
- **Sending volume** (10%): Prevents overuse

Score: 0-100 (70+ = healthy, 50-69 = caution, <50 = pause)

### Components

- **Backend**: Node.js rotation engine with Redis caching
- **Frontend**: Next.js 15 rotation configuration UI
- **Database**: PostgreSQL for mailbox health history
- **Cache**: Redis for real-time mailbox selection

### Key Features

- **Automatic Rotation**: Smart mailbox selection per send
- **Health Monitoring**: Track mailbox reputation in real-time
- **Configurable Strategies**: Choose rotation algorithm
- **Manual Override**: Force specific mailbox for testing
- **Auto-Pause**: Disable unhealthy mailboxes automatically
- **Analytics**: Rotation effectiveness reporting

## Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Algorithm selects wrong mailbox | High | Medium | Extensive testing, manual override option |
| Performance bottleneck at scale | Medium | Medium | Redis caching, efficient scoring algorithm |
| Mailbox pool exhaustion | Medium | Low | Alert when < 3 healthy mailboxes available |
| Over-reliance on single mailbox | Medium | Low | Enforce maximum usage per mailbox |

## Success Criteria

- [ ] Mailbox selection time < 50ms
- [ ] 25% deliverability improvement vs single mailbox
- [ ] Support 50+ mailboxes in rotation pool
- [ ] Auto-pause works within 5 minutes of health drop
- [ ] 80% user satisfaction with rotation logic

## Configuration Options

### User Controls

- **Rotation Strategy**: Round robin, weighted, reputation-based, domain-based
- **Min Reputation Score**: Don't use mailboxes below threshold (default: 70)
- **Max Sends Per Mailbox**: Daily limit per mailbox (default: 500)
- **Cooldown Period**: Rest time after max sends (default: 24 hours)
- **Auto-Pause**: Enable/disable automatic pausing
- **Manual Exclusions**: Exclude specific mailboxes from rotation

## Metrics to Track

- Mailbox selection latency (target: < 50ms)
- Deliverability rate improvement (target: +25%)
- Mailbox utilization distribution
- Auto-pause frequency and reasons
- User configuration adoption rate

---

**Last Updated**: 2025-11-24  
**Owner**: Backend Engineering Team  
**Status**: Planned - Q1-Q2 2026 timeline
