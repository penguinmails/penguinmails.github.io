# Contributing to PenguinMails Documentation

We welcome contributions to improve our documentation! This guide provides everything you need to get started with contributing to the PenguinMails documentation project.

## Quick Start

## For immediate contributions

1. Fork this repository

2. Create a feature branch: `git checkout -b feature/your-improvement`

3. Make your changes

4. Test locally (see setup below)

5. Submit a pull request

**Need help?** Check our [Support section](#support) or [open an issue](https://github.com/penguinmails/penguinmails.github.io/issues).

## Table of Contents

- [Quick Start](#quick-start)

- [Development Setup](#development-setup)

- [Content Standards](#content-standards)

- [Frontmatter Requirements](#frontmatter-requirements)

- [Git Workflow](#git-workflow)

- [Quality Assurance](#quality-assurance)

- [Testing & Validation](#testing--validation)

- [Support](#support)

- [Resources](#resources)

## Development Setup

### Prerequisites

- **Docker** - Required for consistent development environment

- **Git** - For version control

- **Modern web browser** - For testing documentation

### Local Development

1. **Clone the repository:**

```bash
git clone https://github.com/penguinmails/penguinmails.github.io.git
cd penguinmails.github.io

```

1. **Start development server:**

```bash

# Build Docker image (one-time setup)

   docker build -t penguinmails-docs .

# Build static files (useful for CI/CD or testing built output)

   docker run --rm -v $PWD:/srv/jekyll -w /srv/jekyll penguinmails-docs jekyll build

# Development server with live reload (recommended for local editing)

   docker run --rm -p 4000:4000 -v $PWD:/srv/jekyll penguinmails-docs

```

   **Note:** The `jekyll build` command generates static files in `_site/`. Use `jekyll serve` for development with auto-reload at [http://localhost:4000](http://localhost:4000).

1. **View the documentation:**
   Open [http://localhost:4000](http://localhost:4000)

### Common Commands
```bash
# Rebuild without cache
docker system prune -a && docker build -t penguinmails-docs .

# Run linting checks

docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint README.md CONTRIBUTING.md AGENTS.md --config .markdownlint.json
```

## Content Standards

### Ways to Contribute

- **Fix typos or improve clarity** - Quick wins that help readability

- **Add missing documentation sections** - Fill gaps in coverage

- **Update outdated information** - Keep content current

- **Improve navigation and structure** - Better user experience

- **Add examples or use cases** - Practical guidance

### Writing Guidelines

- **Clear and accessible language** - Avoid jargon when possible

- **Include practical examples** - Show, don't just tell

- **Update related sections** - Maintain consistency

- **Test all links and navigation** - Ensure nothing breaks

- **Follow existing markdown formatting** - Keep consistency

- **Use customer-focused language** - Highlight business value

- **Target surgical edits for linting** - Fix specific issues

### Content Quality

- **File length**: Target 200-300 lines max for readability

- **Progressive disclosure**: Organize from basic to advanced

- **Cross-references**: Use proper internal linking

- **Business value**: Emphasize customer benefits in technical content

## Frontmatter Requirements

### Standard Format

All documentation files must include this frontmatter:

```yaml

---

title: "Descriptive Page Title"
description: "Comprehensive description of page content and purpose"
last_modified_date: "YYYY-MM-DD"
---

```

### Navigation Files (5 main files only)

Only these files may have sidebar navigation fields:

- `docs/business/strategy/overview.md`

- `docs/technical/architecture/overview.md`

- `docs/compliance-security/overview.md`

- `docs/core-features/README.md`

- `docs/implementation-technical/README.md`

## Navigation frontmatter format

```yaml

---

title: "Page Title"
description: "Page description"
nav_order: X
nav_exclude: false
last_modified_date: "2025-11-26"
---

```

### Rules & Quality Checks

- **Required fields**: `title`, `description`, `last_modified_date` for all files

- **Navigation fields**: Only for the 5 main files listed above

- **Field order**: `title`  `description`  `nav_order`  `nav_exclude`  `last_modified_date`

- **Date format**: ISO format (YYYY-MM-DD)

- **Validation**: Test navigation links after structural changes

## Git Workflow

### Contribution Process

1. **Fork the repository** from GitHub

2. **Create a feature branch:** `git checkout -b feature/your-improvement`

3. **Make your changes** following style guidelines

4. **Test locally** using Docker setup

5. **Run linting checks** to ensure quality

6. **Submit a pull request** with clear description

### Commit Message Format

```bash

docs: add installation troubleshooting guide

- Added common Docker setup issues and solutions

- Included Windows-specific troubleshooting steps  

- Updated development setup section

Fixes #123

```

### Branch Naming

- `feature/your-feature-name` - New features

- `fix/issue-description` - Bug fixes

- `docs/content-update` - Documentation updates

- `refactor/area-description` - Code refactoring

## Quality Assurance

### Definition of Done (DoD)

A task is **Done** when:

- All acceptance criteria are met

- Reviewed, tested, and approved by the lead

- Jira status updated with all links/screenshots

- No blockers or pending dependencies remain

- Verified on staging environment

### Development Tasks DoD

For development work:

- Code committed, reviewed, and merged to right branch

- Follows linting and naming standards

- Tested manually or with unit tests

- Documentation updated if needed

- Deployed successfully to staging

### Markdown Linting

## Docker-based linting approach

```bash

# Check specific files

docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint README.md CONTRIBUTING.md AGENTS.md --config .markdownlint.json

# Auto-fix common issues

docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json --fix

```

## Common issues

- **MD022**: Headings need blank lines around them

- **MD032**: Lists need blank lines around them

- **MD036**: Use proper headings instead of bold emphasis

- **MD047**: Files must end with single newline

For comprehensive linting guide, see [MARKDOWN_LINTING.md](./MARKDOWN_LINTING.md).

## Testing & Validation

### Before Submitting

1. **Local Testing**: Verify changes render correctly at <http://localhost:4000>

2. **Link Validation**: Ensure all internal and external links work

3. **Linting Compliance**: Run Docker-based markdown linting

4. **Content Review**: Verify business value and technical accuracy

### Quality Standards

- **Zero syntax errors** or broken references

- **100% compliance** with repository standards

- **Automated validation** checks pass

- **Cross-references remain** functional

- **Business value preserved** in all modifications

### Best Practices

- **Progressive disclosure**: Organize from basic to advanced

- **File organization**: Use nested folders for reading levels

- **Link management**: Use Jekyll-compatible relative links

- **Content consistency**: Maintain professional appearance

- **Regular testing**: Validate changes before committing

## Support

### Getting Help

- **Documentation questions**: Check main sections first

- **Technical issues**: Review development guidelines above

- **Contributing help**: See contribution guidelines

- **Quick questions**: Check [FAQ](#frequently-asked-questions)

### Reporting Problems

- **Documentation issues**: [Open an issue](https://github.com/penguinmails/penguinmails.github.io/issues)

- **Content requests**: Submit a pull request with suggestions

- **Bug reports**: Include steps to reproduce and expected behavior

### Frequently Asked Questions

## Q: How do I fix Docker permission issues?

A: Ensure Docker is running and you have proper volume mount permissions. Try using absolute paths if $(pwd) doesn't work.

## Q: Why does my link not work in the built site?

A: Internal links should not include .md extensions. Use `[text](path/to/file)` instead of `[text](path/to/file.md)`.

## Q: How do I add a new page to the navigation?

A: Only the 5 main navigation files can have `nav_order` fields. Other pages are discovered automatically through links.

## Resources

- **Live documentation**: [https://penguinmails.github.io](https://penguinmails.github.io)

- **Repository**: [https://github.com/penguinmails/penguinmails.github.io](https://github.com/penguinmails/penguinmails.github.io)

- **Issues**: [GitHub Issues](https://github.com/penguinmails/penguinmails.github.io/issues)

- **Markdown linting**: [MARKDOWN_LINTING.md](./MARKDOWN_LINTING.md)

- **AI agent guidelines**: [AGENTS.md](./AGENTS.md)

---

**Thank you for contributing to PenguinMails documentation!** Your help maintaining high-quality, comprehensive documentation is invaluable to our users and community.

**Last updated**: 2025-11-26
