---
title: "Testing Guide - Overview & Strategy"
description: "Overview of the testing strategy, test directory structure, and quality assurance framework."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - Overview & Strategy

## Strategic Alignment

PenguinMails follows a comprehensive testing strategy that ensures reliability, security, and performance across all components of the email platform.

## Test Directory Structure

The codebase is organized with a clear separation of test types to facilitate targeted execution and maintenance.

```text
├── tests/
│   ├── unit/                     # Business logic and utility tests
│   │   ├── services/             # Core service unit tests
│   │   ├── utils/                # Utility function tests
│   │   └── models/               # Domain model tests
│   ├── integration/              # API and database integration tests
│   │   ├── api/                  # API endpoint integration
│   │   └── database/             # Persistence layer tests
│   ├── mock_services/            # Mock implementations for testing
│   │   ├── mail_server.py        # Mock SMTP server
│   │   └── test_external_services.py  # External API integration
│   ├── e2e/                      # End-to-end tests
│   │   ├── test_campaign_workflow.py  # User workflow tests
│   │   ├── test_analytics_dashboard.py# Dashboard tests
│   │   └── test_mobile_experience.py  # Mobile experience tests
│   ├── fixtures/                 # Test data
│   │   ├── sample_campaigns.json      # Sample campaign data
│   │   ├── user_profiles.json         # User profile data
│   │   └── email_templates.json       # Sample templates
```

## Quality Assurance Framework

- **Unit Testing**: Vitest/Jest for fast, isolated logic verification.
- **Integration Testing**: Supertest and mock databases for API verification.
- **E2E Testing**: Playwright for cross-browser user journey verification.
- **Performance Testing**: K6 for load testing and concurrency verification.
- **Security Testing**: Automated SAST and dependency vulnerability scanning.
