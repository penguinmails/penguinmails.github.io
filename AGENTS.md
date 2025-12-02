
# AI Agent Guidelines for PenguinMails Repository

## Overview

This document outlines the rules and guidelines for AI agents interacting with the PenguinMails repository. These guidelines ensure consistent, high-quality contributions while maintaining the integrity of our documentation and codebase.

For detailed development setup and contribution procedures, please refer to our **[CONTRIBUTING.md](./CONTRIBUTING.md)** guide.

## 🤖 Agent Interaction Rules

### 1. Communication Standards

- **Direct and Technical**: Always respond in a direct, technical manner without conversational pleasantries

- **Markdown Compliance**: Use proper markdown formatting for all responses and file edits

- **Reference Linking**: Always use clickable markdown links for file references: [`filename.ext`](relative/path.ext:line)

- **No Pleasantries**: Start responses directly without "Great", "Certainly", "Okay", or similar conversational fillers

### 2. File Modification Guidelines

- **Surgical Edits**: Prefer targeted changes using search/replace over complete file rewrites

- **Preserve Content**: Never truncate or omit existing content when making changes

- **Maintain Structure**: Preserve file organization, headers, and formatting standards

- **Version Control**: All changes must be tracked and documented

- **Documentation Separation**: Keep README focused on platform overview; detailed development procedures belong in CONTRIBUTING.md

### 3. Documentation Standards

- **Jekyll & Just the Docs Theme**: Repository uses Jekyll static site generator with Just the Docs theme

- **Frontmatter Format**: Follow Jekyll frontmatter standards with proper YAML formatting and date accuracy

  - Standard format: `title`, `description`, `last_modified_date`, `level`, `persona`

  - Navigation format (5 files only): Add `nav_exclude` and `nav_order` (Just the Docs features)

  - Custom metadata: `level` (progressive disclosure), `persona` (target audience), `keywords` (SEO)

  - These custom fields are for devs/AI assistants, not rendered by Jekyll

  - Non-Jekyll files (README.md, CONTRIBUTING.md, tasks/, user-journeys/) do NOT require frontmatter

- **Keywords Migration**: Move `keywords` from document body to frontmatter for better organization

- **Link Formatting**: For docs pages, use site-absolute links starting with `/docs/` and drop `.md` extensions. For root files (e.g., `README.md`, `CONTRIBUTING.md`, `AGENTS.md`), use relative links like `./CONTRIBUTING.md` and `./AGENTS.md`.

- **Markdown Style**: Follow GitHub-flavored Markdown with inline reference links and footnotes

  ```markdown
  some text [^1]
  other text [sometext][my-link-ref]

  [^1]: https://some.address
  [my-link-ref]: https://someother.address
  ```

- **File Length Limits**: Maintain readable file lengths to avoid user fatigue (target 200-300 lines max)

- **Directory Structure**: Use nested folders to convey progressive disclosure reading levels

- **Content Separation**: Keep public-facing docs in docs/ folder clean of development artifacts, prompts, or completion reports

- **Emoji Usage**: Avoid emojis in titles and content for professional appearance

- **Level Classification**: All docs must have appropriate level classification (Level 1-3)

- **Target Audience**: Clearly define target audience and document purpose

- **Cross-References**: Use site-absolute links for all content under `/docs/` and relative links only for root files (e.g., `./CONTRIBUTING.md`, `./AGENTS.md`).

- **Structured Headers**: Maintain consistent header hierarchy and naming conventions

- **Date Accuracy**: Include accurate last_modified_date in frontmatter when possible

### 4. Tech Stack Compliance

## Repository Tech Stack Requirements

- **Language**: TypeScript (primary) or JavaScript for all code examples

- **ORM**: Drizzle ORM only (NO Prisma, TypeORM, Mongoose)

- **Database**: PostgreSQL with NileDB multi-tenancy (NO MySQL, MongoDB)

- **Queue**: PostgreSQL + Redis (NO BullMQ, RabbitMQ, Kafka)

- **Authentication**: NileDB SDK (NO NextAuth.js, Clerk, Auth0)

- **Framework**: Next.js 15 App Router (NO Pages Router, Remix)

## Compliance Verification

For tech stack compliance verification commands, see [MARKDOWN_LINTING.md](./MARKDOWN_LINTING.md#tech-stack-compliance-verification).

## Code Example Standards

For detailed code example templates and conversion patterns, see [CONTRIBUTING.md](./CONTRIBUTING.md#code-example-templates).

### 5. Code Quality Requirements

- **Linting Compliance**: All code changes must pass linting requirements (.markdownlint.json)

- **Markdown Linting**: Use Docker-based markdown linting as documented in [MARKDOWN_LINTING.md](./MARKDOWN_LINTING.md)

- **Formatting Standards**: Follow established formatting rules (Prettier configuration)

- **Error Prevention**: Never introduce syntax errors or broken references

- **Testing Validation**: Changes must not break existing functionality

## 📋 Operational Protocols

### Task Management

- **Todo Lists**: Create and maintain todo lists for complex multi-step tasks

- **Status Tracking**: Regularly update task status (Pending → In Progress → Completed)

- **Completion Confirmation**: Always confirm successful tool use before proceeding

- **Error Handling**: Address linting errors or validation issues immediately

### Tool Usage

- **One Tool Per Message**: Execute only one tool per response

- **Wait for Confirmation**: Wait for user confirmation of tool success before continuing

- **Appropriate Tool Selection**: Choose the most efficient tool for each task

- **Command Safety**: Use only safe, read-only commands unless explicitly authorized

### Development Workflow

- **Local Testing**: Always test changes locally using Docker setup (see CONTRIBUTING.md)

- **Automated Linting**: Run markdown linting to ensure quality compliance

- **Cross-Reference Validation**: Verify all links and references after structural changes

- **Progressive Disclosure**: Maintain information hierarchy from basic to advanced concepts

- **Customer Focus**: Transform technical content to highlight business value

### Quality Assurance

- **Validation Checks**: Run appropriate validation checks after changes

- **Cross-Reference Verification**: Ensure all links and references remain valid

- **Content Preservation**: Verify that business value and technical accuracy are maintained

- **Stakeholder Alignment**: Ensure changes align with organizational objectives

## 🔒 Security and Compliance

### Data Protection

- **No Sensitive Data**: Never expose or modify sensitive configuration data

- **Access Boundaries**: Respect file access restrictions and permissions

- **Privacy Compliance**: Maintain compliance with data protection regulations

### Repository Integrity

- **No Unauthorized Changes**: Only modify files through approved processes

- **Backup Preservation**: Maintain integrity of legacy-archive/ and existing content

- **Version History**: Preserve meaningful commit history and change tracking

## 📊 Performance Standards

### Efficiency Metrics

- **Response Time**: Provide timely responses without unnecessary delays

- **Accuracy Rate**: Maintain 100% accuracy in file modifications and references

- **Completion Rate**: Successfully complete all assigned tasks

- **Quality Score**: Maintain high-quality outputs that require no corrections

### Productivity Goals

- **Task Completion**: Complete tasks efficiently with minimal back-and-forth

- **Resource Optimization**: Use repository resources efficiently

- **Knowledge Application**: Apply accumulated knowledge to improve future interactions

- **Continuous Learning**: Learn from interactions to improve performance

## 🚨 Emergency Protocols

### Issue Handling

- **Critical Errors**: Immediately halt operations if critical errors are detected

- **Data Loss Prevention**: Prevent any data loss through careful modification procedures

- **Rollback Capability**: Ensure all changes can be rolled back if necessary

- **Escalation Procedures**: Escalate issues to human operators when appropriate

### Recovery Procedures

- **Error Recovery**: Implement proper error recovery and retry mechanisms

- **State Preservation**: Maintain task state during interruptions

- **Communication**: Clearly communicate issues and required actions

## 📈 Continuous Improvement

### Learning Requirements

- **Pattern Recognition**: Learn from successful patterns and apply to future tasks

- **Feedback Integration**: Incorporate user feedback to improve performance

- **Best Practice Adoption**: Adopt and follow established best practices

- **Knowledge Updates**: Stay current with repository structure and requirements

### Adaptation Guidelines

- **Process Evolution**: Adapt to changing repository requirements and processes

- **Technology Updates**: Keep current with tool capabilities and limitations

- **Collaboration Enhancement**: Improve cross-agent and human-agent collaboration

- **Innovation Integration**: Incorporate approved innovations while maintaining stability

## ✅ Success Criteria

### Operational Excellence

- Zero syntax errors or broken references in modifications

- 100% successful task completion rate

- Full compliance with repository standards and guidelines

- Positive impact on repository quality and maintainability

### Quality Metrics

- All changes pass validation checks

- Documentation remains accurate and current

- Cross-references remain functional

- Business value is preserved in all modifications

---

**Repository Classification:** Core Infrastructure Guidelines
**Last Updated:** Current Session
**Approval Status:** Required for all agent interactions
**Review Cycle:** Monthly guideline validation and quarterly framework enhancement

These guidelines ensure AI agents contribute effectively to the PenguinMails repository while maintaining the highest standards of quality, security, and operational excellence.

---

## 📚 **Additional Repository Guidelines**

### **Documentation Standards**

- **Progressive Disclosure Structure**: All documentation follows progressive disclosure principles, organizing information from strategic overview to detailed implementation

- **Level Classification**: Documentation is classified into Level 1-3 based on technical complexity and target audience

- **Cross-Reference Integration**: Comprehensive internal linking using site-absolute links for docs (`/docs/...`) and relative links only for root files; maintain proper reference formatting

- **Business-Focused Language**: Technical content transformed to highlight business value and customer benefits

- **Cleanup Procedures**: Regular review and cleanup of process documentation to maintain production-ready state

### **Directory Structure**

- **docs/**: Production-ready documentation only (no process development references)

- **legacy-archive/**: Archived process documentation and historical materials

- **tasks/**: Project management and user story frameworks

- **Root Files**: Core repository configuration and guidelines

### **Quality Assurance**

- **Markdown Linting**: All documentation must pass `.markdownlint.json` requirements

- **Link Validation**: Automated checking of internal and external reference integrity

- **Content Consistency**: Standardized formatting and terminology across all documents

- **Version Control**: Meaningful commit messages and proper version history preservation

**Repository Classification:** Core Infrastructure Guidelines
**Documentation Standards:** Level 1 - Repository Standards and Best Practices
**Implementation Access:** All Contributors and AI Agents
**Review Cycle:** Monthly repository standards validation and quarterly guideline updates
