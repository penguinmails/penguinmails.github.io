---
title: "Testing Guide - Running Tests"
description: "Instructions for running tests locally and in CI/CD environments."
last_modified_date: "2026-02-24"
level: "2"
persona: "Quality Assurance"
---

# Testing Guide - Running Tests

### Command Line Interface

Various npm scripts are provided to run different types of tests and generate reports.

```bash
# Run all tests
npm test

# Run unit tests only
npm run test:unit

# Run integration tests only
npm run test:integration

# Run E2E tests only
npm run test:e2e

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm test -- --grep "test_send_email_success"

# Run tests in watch mode
npm run test:watch

# Run E2E tests with UI
npm run test:e2e:ui

# Run tests on CI
npm run test:ci
```

### Automation and Quality Standards

#### **Continuous Integration**

All tests are executed automatically on every pull request. A passing test suite is a hard requirement for merging.

#### **Performance Monitoring**

E2E tests include performance markers to detect regressions in critical user journey latency.

#### **Security Scanning**

Automated security tests run weekly to identify dependency vulnerabilities and infrastructure misconfigurations.

### Related Documentation

For documentation testing requirements, see [`documentation-contributions.md`](/docs/implementation-technical/development-guidelines/documentation-contributions)
---
