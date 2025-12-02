# Documentation Validation

Clean, focused validation system for CI/CD and local development.

## Quick Start

### Run Main Validation (CI Script)

The CI pipeline runs these scripts individually:

1. **Critical Checks** (Fails Build):

   ```bash
   bash validation/detect/detect_link_policy_violations.sh
   ```

2. **Warning Checks** (Non-Blocking):

   ```bash
   bash validation/detect/detect_link_warnings.sh
   bash validation/detect/detect_frontmatter_issues.sh
   bash validation/detect/detect_tech_stack_violations.sh
   bash validation/detect/detect_formatting_issues.sh
   bash validation/detect/detect_navigation_violations.sh
   bash validation/detect/detect_content_quality_issues.sh
   ```

### Run Detection Scripts

```bash
# Detect specific issues
bash validation/detect/detect_frontmatter_issues.sh
bash validation/detect/detect_link_policy_violations.sh # Critical only
bash validation/detect/detect_link_warnings.sh          # Warnings only
bash validation/detect/detect_tech_stack_violations.sh
bash validation/detect/detect_formatting_issues.sh
```

### Run Fix Scripts

```bash
# Fix common issues automatically
bash validation/fix/fix_link_extensions.sh        # Remove .md from /docs/ links
bash validation/fix/fix_codefences.sh              # Fix code fence formatting
bash validation/fix/fix_whitespace.sh              # Fix whitespace issues
```

## Structure

```bash
validation/
├── README.md           # This file
├── detect/             # Detection scripts (identify issues)
│   ├── detect_frontmatter_issues.sh
│   ├── detect_link_policy_violations.sh
│   ├── detect_link_warnings.sh
│   ├── detect_tech_stack_violations.sh
│   ├── detect_formatting_issues.sh
│   ├── detect_navigation_violations.sh
│   └── detect_content_quality_issues.sh
└── fix/                # Fix scripts (resolve issues)
    ├── fix_link_extensions.sh
    ├── fix_codefences.sh
    └── fix_whitespace.sh
```

## Link Policy

Internal documentation links must follow Jekyll conventions:

✅ **Correct**:

- Site-absolute: `/docs/features/analytics`
- With anchor: `/docs/implementation-technical/architecture#database`

❌ **Incorrect**:

- Relative: `./overview.md`, `../README.md`
- With extension: `/docs/features/README.md`
- To non-Jekyll files: `../tasks/task-01.md`

## Tech Stack Policy

Approved technologies:

- **Languages**: TypeScript, JavaScript, SQL, Bash
- **Database ORM**: Drizzle (NileDB SDK)
- **Database**: PostgreSQL (NileDB)
- **Queue**: Hybrid PostgreSQL + Redis

Forbidden code blocks: `python`, `ruby`, `php`, `csharp`

## CI/CD Integration

The `.github/workflows/validate-docs.yml` workflow has two jobs:

1. **Critical Link Validation**:
   - Runs `detect_link_policy_violations.sh`
   - Fails the build if critical issues are found

2. **Documentation Warnings**:
   - Runs all other detection scripts
   - Reports issues as warnings but does not fail the build

## Archived Files

Legacy artifacts, test fixtures, and reports have been moved to `.roo/legacy-archive/validation/` for reference.

## Related Files

- CI workflow: `.github/workflows/validate-docs.yml`
- Main validation script: `test-validation.sh`
