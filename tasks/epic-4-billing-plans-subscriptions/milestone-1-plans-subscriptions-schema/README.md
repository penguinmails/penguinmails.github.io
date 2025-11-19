---
title: "Milestone 1: Plans and Subscriptions Schema Setup"
description: "Documentation for Milestone 1: Plans and Subscriptions Schema Setup - README"
last_modified_date: "2025-11-19"
level: 2
persona: "Documentation Users"
---

# Milestone 1: Plans and Subscriptions Schema Setup

**Goal:** To prepare our database to store all necessary billing-related information. This involves creating the tables for subscription plans, current subscriptions, and tenant-specific billing configurations.

## Tickets

- [BILL-1.1](./BILL-1.1-define-billing-schemas) - Define Drizzle Schemas for Billing
- [BILL-1.2](./BILL-1.2-generate-apply-billing-migrations) - Generate and Apply Billing Migrations
- [BILL-1.3](./BILL-1.3-seed-plans-table) - Seed the plans Table
- [BILL-1.4](./BILL-1.4-list-plans-endpoint) - Create API Endpoint to List Plans (GET /api/plans)

## Dependencies

- **Epic 1** must be fully completed
- **Epic 2** must be fully completed
- **Epic 3** must be fully completed
- Requires database connection and Drizzle ORM configured

## Success Criteria

- ✅ Plans, subscriptions, and tenant_config tables created
- ✅ Migrations applied successfully
- ✅ Plans table seeded with initial subscription tiers
- ✅ Public endpoint to list plans working
- ✅ All schemas properly linked with foreign keys

## Context

This milestone establishes the billing data foundation. According to the [Implementation & Getting Started](../../docs/implementation-getting-started/index), PenguinMails offers multiple subscription tiers (Starter, Professional, Enterprise) that need to be stored and managed in the database.
