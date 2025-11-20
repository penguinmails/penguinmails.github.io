# Contributing to PenguinMails Documentation

We welcome contributions to improve our documentation! This guide provides detailed instructions for developers and contributors working on the PenguinMails documentation.

## Getting Started

### Prerequisites

- Docker installed on your system
- Git for version control
- Modern web browser for testing

### Local Development Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/penguinmails/penguinmails.github.io.git
   cd penguinmails.github.io
   ```

2. **Build and run the documentation:**

   ```bash
   # Build Docker image
   docker build -t penguinmails-docs .
   
   # Start development server
   docker run --rm -p 4000:4000 -v $(pwd):/srv/jekyll penguinmails-docs
   ```

3. **View the documentation:**
   Open [http://localhost:4000](http://localhost:4000) in your browser

### Development Commands

```bash
# Build documentation only
docker build -t penguinmails-docs .

# Clean rebuild (remove cache)
docker system prune -a && docker build -t penguinmails-docs .

# Live reload development
docker run --rm -p 4000:4000 -v $(pwd):/srv/jekyll penguinmails-docs

# Debug markdown lint issues using Docker-based markdownlint
docker run -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint README.md CONTRIBUTING.md AGENTS.md --config .markdownlint.json
```

## Content Standards

### Ways to Contribute

- **Fix typos or improve clarity**
- **Add missing documentation sections**
- **Update outdated information**
- **Improve navigation and structure**
- **Add examples or use cases**

### Content Guidelines

- Keep language clear and accessible
- Include practical examples when relevant
- Update related sections when making changes
- Test all links and navigation
- Follow existing markdown formatting
- Use customer-focused language throughout
- Maintain business value emphasis in technical content
- Use targeted surgical edits for linting fixes (see development approach below)

## Frontmatter Standards

### Standard Format

All documentation files must follow this frontmatter format:

```yaml
---
title: "Descriptive Page Title"
description: "Comprehensive description of page content and purpose"
last_modified_date: "YYYY-MM-DD"
---
```

### Navigation Files

Only 5 main files are allowed to have sidebar navigation fields:

- Business/Strategy: `docs/business/strategy/overview.md`
- Technical/Architecture: `docs/technical/architecture/overview.md`
- Compliance/Security: `docs/compliance-security/overview.md`
- Core Features: `docs/core-features/README.md`
- Implementation Technical: `docs/implementation-technical/README.md`

**Sidebar Navigation Format:**

```yaml
---
title: "Page Title"
description: "Page description"
nav_order: X
nav_exclude: false
last_modified_date: "2025-11-10"
---
```

### Rules

- Use `title`, `description`, and `last_modified_date` for all files
- Use `nav_order` and `nav_exclude` only for the 5 main sidebar files
- Field order: `title` → `description` → `nav_order` → `nav_exclude` → `last_modified_date`
- Date format: YYYY-MM-DD

### Quality Assurance

- **Field Completeness**: Ensure all three fields are present in every documentation file
- **Date Format**: Use ISO format (YYYY-MM-DD) for all dates
- **Link Validation**: Test all navigation links after making structural changes
- **Consistency Checks**: Verify internal document references when moving or renaming files

## Git Workflow

### Contribution Process

1. **Fork the repository**
2. **Create a feature branch:** `git checkout -b feature/your-improvement`
3. **Make your changes** following our style guidelines
4. **Test locally** using the Docker setup above
5. **Run linting checks** to ensure quality compliance
6. **Submit a pull request** with a clear description

### Commit Message Format

```markdown
docs: add installation troubleshooting guide

- Added common Docker setup issues and solutions
- Included Windows-specific troubleshooting steps
- Updated development setup section

Fixes #123
```

## Definition of Done (DoD)

### General Completion Criteria

A task is **Done** when:

- ✅ All acceptance criteria are met
- ✅ It's reviewed, tested, and approved by the lead
- ✅ Jira status is updated with all links or screenshots
- ✅ No blockers or pending dependencies remain
- ✅ It's verified on staging

### Development Tasks

For development work, **Done** means:

- ✅ Code is committed, reviewed, and merged into the right branch
- ✅ Follows linting and naming standards
- ✅ Tested manually or with unit tests
- ✅ Docs or .env.sample updated if needed
- ✅ Deployed successfully to staging

### Bug Fixes

For bug fixes, **Done** means:

- ✅ The issue is replicated and the root cause found
- ✅ Fix verified in staging with before/after proof
- ✅ Related areas regression-tested

### Research Spikes

For research spikes, **Done** means:

- ✅ Research completed and documented (Google Doc link in Jira)
- ✅ Includes clear findings or recommendations
- ✅ Reviewed by Anthony or team lead before closing

### Summary

**"Done"** means built, tested, reviewed, documented, deployed to staging, and approved with no loose ends.

This Definition of Done ensures consistent quality standards across all contributions and provides clear expectations for both contributors and reviewers.

## Markdown Linting

### Docker-Based Linting Approach

Our repository uses a Docker-based markdown linting approach for consistency and ease of setup:

- **Containerized**: Uses `peterdavehello/markdownlint:latest` Docker image
- **Consistent Environment**: Same linting results across all development environments
- **No Dependencies**: Eliminates need for Node.js/npm installation
- **CI/CD Ready**: Easily integrated into continuous integration pipelines
- **Latest Version**: Uses the most recent markdownlint version for best compatibility

### Linting Command

```bash
# Check focused markdown files (avoids noise from other directories)
docker run -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint README.md CONTRIBUTING.md AGENTS.md --config .markdownlint.json
```

### Development Approach

Our repository emphasizes targeted surgical edits over bulk automation:

- **Lint Check**: Run Docker-based linting to identify specific issues
- **Surgical Fixes**: Use targeted search/replace edits to fix individual problems
- **Historical Reference**: Legacy automation scripts are archived in `.roo/legacy-archive/development-automation/`

For comprehensive markdown linting documentation, including troubleshooting and CI/CD integration, see [MARKDOWN_LINTING.md](./MARKDOWN_LINTING.md).

### Common Issues and Solutions

- **MD001**: Heading levels should only increment by one level at a time
- **MD022**: Headings should be surrounded by blank lines
- **MD032**: Lists should be surrounded by blank lines
- **MD036**: Emphasis should not be used in place of strong
- **MD041**: First line in file should be a top-level heading
- **MD047**: Files should end with a single newline character

## Development Best Practices

### File Organization

- Maintain progressive disclosure structure
- Use nested folders to convey reading levels
- Keep public-facing docs in `docs/` folder clean of development artifacts
- Avoid emojis in titles and content for professional appearance

### Documentation Quality

- Maintain readable file lengths (target 200-300 lines max)
- Use proper internal linking with relative paths
- Follow GitHub-flavored Markdown with inline reference links
- Include accurate `last_modified_date` in frontmatter when possible

### Cross-Reference Management

- Use Jekyll-compatible relative links without .md extensions
- Maintain consistent header hierarchy and naming conventions
- Test all navigation links after structural changes
- Preserve meaningful cross-reference relationships

## Testing and Validation

### Before Submitting

1. **Local Testing**: Verify changes render correctly in local development server
2. **Link Validation**: Ensure all internal and external links work properly
3. **Linting Compliance**: Run Docker-based markdown linting to catch formatting issues
4. **Content Review**: Verify business value and technical accuracy are maintained

### Quality Standards

- Zero syntax errors or broken references
- 100% compliance with repository standards
- All changes pass automated validation checks
- Cross-references remain functional
- Business value is preserved in all modifications

## Support

### Getting Help

- **Documentation Issues:** Check the main sections first
- **Technical Questions:** Review the development guidelines
- **Contributing Help:** See the contribution guidelines above

### Reporting Problems

- **Documentation Issues:** [Open an issue](https://github.com/penguinmails/penguinmails.github.io/issues)
- **Content Requests:** Submit a pull request with your suggestions
- **Bug Reports:** Include steps to reproduce and expected behavior

### Resources

- **Repository:** [https://github.com/penguinmails/penguinmails.github.io](https://github.com/penguinmails/penguinmails.github.io)
- **Issues:** [GitHub Issues](https://github.com/penguinmails/penguinmails.github.io/issues)
- **Live Documentation:** [https://penguinmails.github.io](https://penguinmails.github.io)

---

**Thank you for contributing to PenguinMails documentation!** Your help in maintaining high-quality, comprehensive documentation is invaluable to our users and community.
