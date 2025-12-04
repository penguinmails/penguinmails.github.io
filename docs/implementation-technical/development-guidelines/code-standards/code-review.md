---
title: "Code Review Checklist"
description: "Comprehensive code review criteria and quality gates"
last_modified_date: "2025-12-04"
level: "3"
persona: "Senior Developers"
keywords: "code review, quality assurance, checklist, peer review"
---

# Code Review Checklist

## Code Review Checklist

### Before Submitting PR

- [ ] Code follows style guidelines and passes linting

- [ ] All functions/classes have proper docstrings

- [ ] Complex logic includes inline comments

- [ ] No hardcoded values or magic numbers

- [ ] Error handling is comprehensive

- [ ] Input validation is implemented

- [ ] Security best practices followed

- [ ] Performance considerations addressed

- [ ] Tests are written and passing

- [ ] Documentation is updated

- [ ] No console.logs or debug statements

- [ ] Dead code removed

- [ ] Consistent naming conventions

- [ ] File size reasonable (<500 lines)

### Security Review Points

- [ ] User inputs are validated and sanitized

- [ ] Authentication and authorization implemented

- [ ] Sensitive data not logged or exposed

- [ ] SQL injection prevention

- [ ] XSS protection measures

- [ ] CSRF protection where applicable

- [ ] Rate limiting implemented

- [ ] Secure headers set

- [ ] Dependencies are up to date

- [ ] No hardcoded secrets or keys

### Performance Review Points

- [ ] Database queries are optimized

- [ ] N+1 query problems avoided

- [ ] Appropriate caching implemented

- [ ] Large datasets are paginated

- [ ] Image/media files are optimized

- [ ] Bundle sizes are reasonable

- [ ] Lazy loading where appropriate

- [ ] Memory usage is efficient

- [ ] API response times are acceptable

For comprehensive testing requirements, see [`testing-requirements.md`](/docs/implementation-technical/development-guidelines/testing-requirements).
For the contribution workflow, see [`code-contribution.md`](/docs/implementation-technical/development-guidelines/code-contribution).
