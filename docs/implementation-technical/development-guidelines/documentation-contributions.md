---
title: "Documentation Contributions Guidelines"
description: "Guidelines for contributors to the PenguinMails documentation project"
last_modified_date: "2025-11-28"
level: "2"
persona: "Technical Writers"
---

# Documentation Contributions Guidelines

## For Freelancers and Technical Contributors

Welcome! This page provides essential information for contributing to the PenguinMails documentation project.

## Repository Standards and Guidelines

**All contributors must follow the guidelines established in our core repository files:**

### Essential Reading

- **[CONTRIBUTING.md](/CONTRIBUTING.md)** - Complete contribution guidelines including:
  - Development setup with Docker
  - Content standards and writing guidelines
  - Git workflow and commit standards
  - Testing and validation processes

- **[AGENTS.md](/AGENTS.md)** - AI agent interaction rules and documentation standards including:
  - Markdown formatting requirements
  - Frontmatter specifications
  - Code quality standards
  - Tech stack compliance rules

### Quick Reference

#### Key Requirements

1. **Docker-based development** - All local testing must use Docker setup
2. **Markdown linting** - Files must pass `.markdownlint.json` requirements
3. **Frontmatter format** - All docs require title, description, last_modified_date
4. **Jekyll compatibility** - Internal links without `.md` extensions
5. **TypeScript examples** - All code examples must use TypeScript or JavaScript

#### Tech Stack Compliance

- **Language**: TypeScript (primary) or JavaScript
- **ORM**: Drizzle ORM only
- **Database**: PostgreSQL with NileDB multi-tenancy  
- **Framework**: Next.js 15 App Router

#### File Organization

- **Progressive disclosure**: Organize content from basic to advanced
- **Cross-references**: Use site-absolute links for `/docs/` files
- **Length limits**: Target 200-300 lines for readability
- **Business focus**: Highlight customer value in technical content

## Getting Started

1. **Fork the repository** from GitHub
2. **Follow setup instructions** in [CONTRIBUTING.md](/CONTRIBUTING.md#development-setup)
3. **Review documentation standards** in [AGENTS.md](/AGENTS.md)
4. **Test locally** using Docker before submitting changes

## Support and Resources

- **Repository**: [GitHub Repository](https://github.com/penguinmails/penguinmails.github.io)
- **Issues**: [Report Problems](https://github.com/penguinmails/penguinmails.github.io/issues)
- **Live Docs**: [Production Documentation](https://penguinmails.github.io)

## Content Quality Standards

**All contributions must meet these criteria:**

- ✅ Zero syntax errors or broken references
- ✅ 100% compliance with repository standards  
- ✅ All automated validation checks pass
- ✅ Business value preserved in modifications
- ✅ Cross-references remain functional

For detailed implementation guidance, refer to the linked repository files above.
