---
title: "Email Warmups Roadmap"
timeline: "Q4 2025 - Q1 2026"
status: "planned"
priority: "high"
completion: "0%"
dependencies: ["free-mailbox-creation"]
blocks: ["campaign-management"]
---

# Email Warmups Roadmap

## Overview

Automated email warmup system that gradually increases sending volume to build mailbox reputation and improve deliverability. Essential for preventing new mailboxes from being flagged as spam.

**Business Value**: Protects sender reputation, improves email deliverability rates by 30-40%, enables safe scaling of email campaigns.

## Timeline

- **Target Quarter**: Q4 2025 - Q1 2026
- **Start Date**: 2025-12-01
- **Target Completion**: 2026-02-28
- **Current Status**: Planned
- **Next Milestone**: Requirements gathering

## Dependencies

### Required Before Starting

- 🔄 **[Free Mailbox Creation](./free-mailbox-creation.md)** - Must be complete (currently 80%)
- ⏳ SMTP sending infrastructure - In progress
- ⏳ Scheduling/queue system - Planned

### Blocks (Features Waiting on This)

- **[Campaign Management](./campaign-management.md)** - Campaigns require warmed mailboxes

## Milestones

- [ ] **M1: Research & Design** (Weeks 1-3)
  - [ ] Research warmup best practices
  - [ ] Define warmup schedules (aggressive, moderate, conservative)
  - [ ] Design warmup progression algorithm
  - [ ] UX flow for warmup configuration
  
- [ ] **M2: Core Implementation** (Weeks 4-8)
  - [ ] Backend warmup scheduling engine
  - [ ] Email generation for warmup messages
  - [ ] Warmup progression tracking
  - [ ] Frontend UI for warmup management
  
- [ ] **M3: Testing & Optimization** (Weeks 9-11)
  - [ ] Warmup effectiveness testing
  - [ ] Deliverability rate validation
  - [ ] Schedule optimization
  - [ ] Edge case handling
  
- [ ] **M4: Launch** (Week 12)
  - [ ] Documentation and best practices guide
  - [ ] Deployment
  - [ ] Customer onboarding materials
  - [ ] Monitoring dashboards

## Related Documentation

### Feature Specification

- **[Email Warmups Feature Spec](../../features/email-warmups.md)** - Detailed feature requirements

### Technical Specifications

- **[Frontend: Warmup Configuration](../../design/routes/dashboard-warmups.md)** - UI specification
- **[API: Warmup Endpoints](../../implementation-technical/api/tenant-api/warmups.md)** - Backend API
- **[Queue System](../../implementation-technical/api/queue/jobs.md)** - Job scheduling for warmups

### User Workflows

- **[Marketing Journey](../../user-journeys/marketing-journey.md)** - Warmup in campaign workflow

### Implementation Tasks

- **[Email Warmups Epic](../../../tasks/email-warmups/)** - Development tasks

## Technical Details

### Warmup Schedules

#### Conservative (45 days)

- Days 1-7: 10-20 emails/day
- Days 8-14: 30-50 emails/day
- Days 15-30: 75-150 emails/day
- Days 31-45: 200-500 emails/day

#### Moderate (30 days)

- Days 1-5: 20-40 emails/day
- Days 6-15: 75-150 emails/day
- Days 16-30: 200-750 emails/day

#### Aggressive (20 days)

- Days 1-5: 50-100 emails/day
- Days 6-10: 150-300 emails/day
- Days 11-20: 400-1000 emails/day

### Components

- **Backend**: Node.js warmup scheduler with queue system
- **Frontend**: Next.js 15 warmup configuration UI
- **Database**: PostgreSQL warmup tracking tables
- **Queue**: Hybrid PostgreSQL + Redis job queue

### Key Features

- Automated warmup email generation
- Gradual sending volume increase
- Multiple warmup schedule presets
- Warmup progress tracking
- Reputation score monitoring
- Automatic pause on deliverability issues

## Risks & Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Warmup too aggressive causes spam flags | High | Medium | Conservative defaults, monitoring, auto-pause |
| Warmup takes too long | Medium | Low | Provide multiple schedule options |
| Deliverability still poor after warmup | High | Low | Clear expectations, best practices guide |
| Queue system performance issues | Medium | Medium | Load testing, proper queue management |

## Success Criteria

- [ ] 95% of warmed mailboxes achieve good deliverability
- [ ] Warmup completion rate > 90%
- [ ] No spam flags during warmup process
- [ ] Users can configure custom warmup schedules
- [ ] Automatic pause works on deliverability drop

## Warmup Best Practices

> [!IMPORTANT]
> **Warmup Timeline Expectations**
>
> - Conservative: 45 days to full volume
> - Moderate: 30 days to full volume
> - Aggressive: 20 days to full volume (higher risk)

### Recommendations

- Start with conservative schedule for new domains
- Monitor deliverability metrics daily during warmup
- Pause campaigns if bounce rate > 5%
- Use peer-to-peer warmup (reciprocal sending)
- Avoid promotional content during warmup

## Metrics to Track

- Warmup completion rate
- Average time to completion
- Deliverability improvement (before/after)
- Bounce rate during warmup
- Spam complaint rate during warmup
- User satisfaction with warmup process

---

**Last Updated**: 2025-11-24  
**Owner**: Backend Engineering Team  
**Status**: Planned - Awaiting Free Mailbox Creation completion
