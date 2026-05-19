---
title: "Product Documentation Hub"
description: "Comprehensive overview of PenguinMails infrastructure, capabilities, and roadmap."
last_modified_date: "YYYY-MM-DD"
---
# PenguinMails

> Cold emails that land in the inbox. Not spam.

PenguinMails is a cold email infrastructure and outreach platform built for founders, agencies, startups, and outbound sales teams that care about deliverability first.

Unlike traditional cold email tools that optimize for sending volume, PenguinMails focuses on infrastructure quality, sender reputation, and inbox placement.

---

## Table of Contents

- [Overview](#overview)
- [Core Value Proposition](#core-value-proposition)
- [Target Users](#target-users)
- [Competitive Positioning](#competitive-positioning)
- [Current Product Capabilities](#current-product-capabilities)
- [Dashboard Modules](#dashboard-modules)
- [Feature Availability Matrix](#feature-availability-matrix)
- [Gap Analysis](#gap-analysis)
- [Technology Stack](#technology-stack)
- [Architecture Overview](#architecture-overview)
- [Security & Deliverability](#security--deliverability)
- [Roadmap](#roadmap)
- [Known Limitations](#known-limitations)
- [Open Questions](#open-questions)
- [Contributing](#contributing)


# Overview

PenguinMails is an outbound email automation platform designed to help users safely scale cold email outreach while protecting domain reputation and maximizing inbox placement.

The platform combines:

- Private email infrastructure
- Campaign automation
- Domain warmup
- Multi-tenant workspace management
- Deliverability-focused tooling
- Outreach analytics

PenguinMails is being built using Flynet, Mautic, and NileDB with a strong focus on scalable outbound infrastructure.


# Core Value Proposition

Most cold email platforms optimize for volume.

PenguinMails optimizes for delivery.

## Problems We Solve

- Emails landing in spam regardless of copy quality
- Sender reputation degradation from aggressive sending
- Shared IP infrastructure affecting deliverability
- Poor campaign performance caused by infrastructure issues
- Complex DNS and mailbox setup for non-technical users

## What Makes PenguinMails Different

### Private Infrastructure

Each tenant operates on isolated VPS infrastructure with dedicated IPs instead of shared sending pools.

### Deliverability-First Architecture

SPF, DKIM, and DMARC are integrated directly into the onboarding and domain setup flow.

### Automated Warmup

Warmup workflows simulate human-like activity to gradually build sender trust with mailbox providers.

### Affordable Scaling

Unlimited warmups, unlimited sending accounts, and infrastructure-focused pricing starting from $35/month.

### Multi-Tenant Workspace Support

Designed for agencies and outbound teams managing multiple domains and clients.


# Target Users

## Agencies

Manage outreach for multiple clients from a single workspace with isolated infrastructure and role-based access.

## Freelancers

Run outbound campaigns without needing deep technical knowledge of DNS, deliverability, or email infrastructure.

## Outbound Sales Teams

Scale cold outreach safely with mailbox warmup and deliverability monitoring.

## Startups

Founder-led sales teams needing affordable outbound infrastructure without shared IP risk.


# Competitive Positioning

PenguinMails competes in the outbound infrastructure and cold email automation space alongside:

- [Instantly](https://instantly.ai)
- [Smartlead](https://www.smartlead.ai)
- [Salesforge](https://salesforge.ai)
- [SmartReach](https://smartreach.io)
- [ReachInbox](https://reachinbox.ai)
- [Woodpecker](https://woodpecker.co)
- [Saleshandy](https://www.saleshandy.com)

## PenguinMails Positioning

| Area | PenguinMails Focus |
|---|---|
| Infrastructure | Dedicated VPS per tenant |
| Deliverability | Inbox placement over sending volume |
| Warmup | Integrated automated warmup |
| Security | SPF/DKIM/DMARC built-in |
| Pricing | Affordable private infrastructure |
| Multi-Tenant | Native workspace architecture |
| Isolation | No shared sending pools |


# Current Product Capabilities

## Authentication

- User registration
- Login/logout
- Password reset
- Email verification
- Multi-session invalidation after password changes
- Cloudflare Turnstile protection

## Domain & Mailbox Management

- Domain validation
- DNS verification
- SPF/DKIM/DMARC setup
- Mailbox management
- Warmup status visibility

## Campaign Management

- Campaign creation
- Campaign automation via Mautic
- Multi-step campaign flows
- Email template management

## Lead Management

- Lead list creation
- CSV import
- Bulk delete
- Lead export

## Analytics

- Open rates
- Reply rates
- Active campaign counts
- Leads contacted
- Warmup monitoring
- Server health monitoring

## Team Management

- Team invites
- Role-based access
- Invite resend/cancel flows

## Infrastructure

- VPS provisioning
- Dedicated IP assignment
- Tenant isolation
- Infrastructure automation scripts


# Dashboard Modules

## Dashboard Overview

Current dashboard widgets include:

- Active Campaigns
- Leads Contacted
- Open Rate
- Reply Rate
- Warmup Status
- Server Health
- Recent Replies
- Quick Actions


## Outreach Hub

- Campaign creation
- Campaign management
- Email templates


## Lead Hub

- Lead lists
- CSV imports
- Lead exports
- Contact management


## Infrastructure Hub

- Domains
- Mailboxes
- DNS setup
- Warmup monitoring


## Analytics Hub

- Campaign performance metrics
- Deliverability overview
- Engagement tracking


## Settings

- Team management
- Password management
- Session controls
- Language preferences


# Feature Availability Matrix

| Feature | Status | Notes |
|---|---|---|
| Authentication | ✅ Ready | Production-ready |
| Domain Verification | ✅ Ready | DNS validation implemented |
| Campaign Sending | ✅ Ready | Powered by Mautic |
| Lead Management | ✅ Ready | CSV imports and exports supported |
| Basic Analytics | ✅ Ready | Dashboard metrics available |
| Email Templates | ✅ Ready | Template management available |
| Team Invites | 🚧 In Progress | Loop-powered invite flows |
| Role Management | 🚧 In Progress | Admin/member enforcement |
| Mailbox Creation | 🚧 In Progress | Self-serve provisioning flow |
| Billing & Subscriptions | 🚧 In Progress | Payment integration ongoing |
| Private VPS Provisioning | 🚧 In Progress | Automation scripts built |
| Unified Inbox | ❌ Not Built | Requires custom implementation |
| Inbox Rotation | ❌ Not Built | Post-MVP feature |
| Full Analytics Hub | ⚠️ Partial | Advanced reporting pending |
| 2FA Backend | ⚠️ Partial | UI completed, backend pending |
| Free Trial Flow | ❌ Not Built | Depends on billing system |
| Slack Community | ❌ Not Created | Planned post-launch |


# Gap Analysis

This section documents the current gaps between public-facing messaging and actual MVP functionality.

## Unified Inbox

### Advertised

Manage replies across all senders in one unified workspace.

### Reality

A true multi-inbox unified inbox is not yet implemented. Current support is limited to monitored inbox functionality through Mautic/IMAP.

### Risk

Critical.

### Recommendation

Mark as "Coming Soon" before launch.


## Inbox Rotation

### Advertised

Distribute sending volume across multiple inboxes safely.

### Reality

Not yet implemented. Requires custom infrastructure beyond native Mautic capabilities.

### Risk

Critical.

### Recommendation

Remove from launch messaging or clearly mark as roadmap functionality.


## Advanced Automated Sequences

### Advertised

Smart follow-up automation with advanced sequencing.

### Reality

Campaign automation exists through Mautic, but the dedicated PenguinMails sequence builder UI is incomplete.

### Risk

High.

### Recommendation

Clarify the current automation experience in marketing materials.


## Advanced Analytics

### Advertised

Detailed deliverability analytics and reporting.

### Reality

Basic metrics are available. Advanced reporting dashboards remain post-MVP.

### Risk

Medium.


# Technology Stack

## Backend

- Flynet
- Mautic
- NileDB
- PostgreSQL
- JWT Authentication

## Infrastructure

- Dedicated VPS per tenant
- Dedicated SMTP IPs
- Terraform (under evaluation)
- Vault credential storage

## Frontend

- Storybook
- Chromatic
- Component-driven architecture

## Email Infrastructure

- SPF
- DKIM
- DMARC
- Warmup automation
- Loop transactional email integration


# Architecture Overview

```text
Frontend UI
    ↓
API Layer
    ↓
NileDB Multi-Tenant System
    ↓
Flynet + Mautic Infrastructure
    ↓
Dedicated VPS + SMTP Infrastructure
```

# Security & Deliverability

## Security

- JWT-based authentication
- Session invalidation
- Role-based access enforcement
- Cloudflare Turnstile protection
- Rate limiting

## Deliverability

- Dedicated IP infrastructure
- Automated warmup
- DNS authentication enforcement
- Sender reputation monitoring


# Roadmap

## Phase 1 - MVP

- Authentication
- Campaign management
- Lead management
- Domain verification
- Mailbox provisioning
- Basic analytics
- Warmup infrastructure


## Phase 2

- Unified Inbox
- Inbox Rotation
- Advanced Analytics Hub
- Billing automation
- Full self-serve onboarding
- Improved automation UI


## Phase 3

- AI-powered deliverability recommendations
- AI campaign optimization
- Advanced sender reputation monitoring
- Workspace collaboration improvements
- API access
- Webhooks
- CRM integrations


# Known Limitations

- Unified Inbox is not production-ready
- Inbox Rotation is not implemented
- Advanced analytics remain incomplete
- Billing automation is still in development
- Full automation UI is pending

# Open Questions

- Should Unified Inbox remain publicly advertised before implementation?
- What mailbox creation limits exist on launch plans?
- Does Mautic Campaign Builder sufficiently satisfy sequence functionality expectations?
- What should be included in the initial free trial experience?
- Should advanced analytics be moved entirely to Phase 2 positioning?


# Contributing

This repository contains the official public-facing product documentation for PenguinMails.

Internal teams should:
- Keep roadmap updates current
- Document feature status accurately
- Update landing page alignment regularly
- Record infrastructure and architectural decisions


# Philosophy

PenguinMails is being built around one belief:

> Deliverability is infrastructure, not luck.
