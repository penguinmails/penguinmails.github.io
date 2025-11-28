# Validation Pipeline Integration Instructions

**Created**: 2025-11-28  
**Purpose**: Step-by-step guide to integrate the validation pipeline into the documentation workflow

## Overview

The validation pipeline in `/validation/` provides comprehensive documentation quality checks. This document outlines how to safely integrate it into the project workflow.

## Current Status

✅ **Completed**:

- 8 detection scripts (all tested with fixtures)
- 3 fix scripts (automated remediation)
- 17/17 automated tests passing
- 30+ test fixtures covering all rules

⚠️ **Next Steps** (this document):

1. Test detection scripts on actual `docs/` directory
2. Review and document findings
3. Update project documentation (README, CONTRIBUTING, etc.)
4. Integrate into GitHub Actions CI/CD

## Phase 1: Validate Against Real Documentation

### Step 1.1: Run All Detection Scripts on `docs/`

**Purpose**: Generate baseline report to understand current state

```bash
cd validation

# Create a baseline report directory
mkdir -p reports/baseline

# Run each detection script and save output
echo "Running baseline validation..."

bash scripts/detect/detect_frontmatter_issues.sh docs > reports/baseline/frontmatter.log 2>&1
bash scripts/detect/detect_link_policy_violations.sh docs > reports/baseline/links.log 2>&1
bash scripts/detect/detect_tech_stack_violations.sh docs > reports/baseline/tech_stack.log 2>&1
bash scripts/detect/detect_codefence_issues.sh docs > reports/baseline/codefence.log 2>&1
bash scripts/detect/detect_whitespace_issues.sh docs > reports/baseline/whitespace.log 2>&1
bash scripts/detect/detect_navigation_violations.sh docs > reports/baseline/navigation.log 2>&1
bash scripts/detect/detect_content_quality_issues.sh docs > reports/baseline/content_quality.log 2>&1
bash scripts/detect/detect_formatting_issues.sh docs > reports/baseline/formatting.log 2>&1

echo "Baseline validation complete!"
echo "Review reports in validation/reports/baseline/"
```

### Step 1.2: Review Baseline Reports

**Action Items**:

1. Review each `.log` file in `reports/baseline/`
2. Review JSON reports in `reports/` (timestamped)
3. Count total issues by category
4. Identify false positives (if any)
5. Document findings

**Template for Review**:

```markdown
## Baseline Validation Results

**Date**: [DATE]
**Target**: docs/

### Summary by Category

| Category | Issues Found | False Positives | Action Required |
|----------|--------------|-----------------|-----------------|
| Frontmatter | X | Y | [Yes/No] |
| Links | X | Y | [Yes/No] |
| Tech Stack | X | Y | [Yes/No] |
| Codefence | X | Y | [Yes/No] |
| Whitespace | X | Y | [Yes/No] |
| Navigation | X | Y | [Yes/No] |
| Content Quality | X | Y | [Yes/No] |
| Formatting | X | Y | [Yes/No] |

### Notes
- [Any observations]
- [Any script adjustments needed]
- [Any false positive patterns]
```

### Step 1.3: Test Fix Scripts (on copies)

**IMPORTANT**: Test on copies first, never on original `docs/`

```bash
# Create a test copy of docs
cp -r docs docs-test-backup

# Test automated fixes on the copy
cd validation

# Test link extension fix
bash scripts/fix/fix_link_extensions.sh ../docs-test-backup

# Test whitespace fix
bash scripts/fix/fix_whitespace.sh ../docs-test-backup

# Test codefence fix
bash scripts/fix/fix_codefences.sh ../docs-test-backup

# Re-run detection to verify fixes worked
bash scripts/detect/detect_link_policy_violations.sh ../docs-test-backup
bash scripts/detect/detect_whitespace_issues.sh ../docs-test-backup
bash scripts/detect/detect_codefence_issues.sh ../docs-test-backup

# Review changes
cd ..
diff -r docs docs-test-backup | less

# Clean up test copy
rm -rf docs-test-backup
```

## Phase 2: Update Project Documentation

### Step 2.1: Update README.md

Add a "Documentation Quality" section:

```markdown
## Documentation Quality

This project uses an automated validation pipeline to ensure documentation quality.

### Running Validation

```bash
cd validation
bash test_runner.sh  # Run all tests (should be 17/17 passing)

# Run detection on docs/
bash scripts/detect/detect_frontmatter_issues.sh docs
bash scripts/detect/detect_link_policy_violations.sh docs
# ... (other scripts)
```

### Automated Fixes

Some issues can be fixed automatically:

```bash
cd validation
bash scripts/fix/fix_link_extensions.sh docs      # Remove .md from links
bash scripts/fix/fix_whitespace.sh docs           # Remove trailing whitespace
bash scripts/fix/fix_codefences.sh docs           # Fix closing fence languages
```

See `/validation/README.md` for complete documentation.

```

### Step 2.2: Update CONTRIBUTING.md

Add validation requirements:

```markdown
## Documentation Standards

All documentation must pass validation checks before merging.

### Before Submitting a PR

1. Run validation on your changes:
   ```bash
   cd validation
   bash scripts/detect/detect_frontmatter_issues.sh docs
   bash scripts/detect/detect_link_policy_violations.sh docs
   ```

2. Fix any issues found (automated fixes available for some):

   ```bash
   bash scripts/fix/fix_whitespace.sh docs
   bash scripts/fix/fix_link_extensions.sh docs
   ```

3. Verify fixes:

   ```bash
   bash test_runner.sh  # Should pass 17/17 tests
   ```

### Common Issues

- **Missing frontmatter fields**: Add title, description, level, persona, last_modified_date
- **Links with .md extension**: Use `/docs/path/file` not `/docs/path/file.md`
- **Trailing whitespace**: Run `fix_whitespace.sh` to auto-fix
- **Tech stack violations**: Use TypeScript/JavaScript, PostgreSQL, Drizzle (not Python, Ruby, Prisma, BullMQ)

See `/validation/README.md` for complete validation rules.

```

### Step 2.3: Create MARKDOWN_LINT.md

Document all validation rules:

```markdown
# Markdown Linting Rules

This document describes all validation rules enforced by the pipeline.

## Frontmatter Rules

All markdown files must have complete frontmatter:

```yaml
---
title: "Document Title"
description: "Brief description"
last_modified_date: "2025-11-28"
level: "1"  # 1=Overview, 2=Detailed, 3=Implementation
persona: "developer"  # or "business", "operations", etc.
---
```

**Detection**: `detect_frontmatter_issues.sh`  
**Fix**: Manual (AI-assisted fix planned)

## Link Policy Rules

1. Internal links must be site-absolute: `/docs/path/file`
2. No `.md` extensions in links
3. No relative links to `tasks/` or `user-journeys/`
4. No links to `CONTRIBUTING.md` or root `README.md`

**Detection**: `detect_link_policy_violations.sh`  
**Fix**: `fix_link_extensions.sh` (automated for .md removal)

## Tech Stack Rules

Approved technologies:

- Languages: TypeScript, JavaScript, SQL
- Database: PostgreSQL with Drizzle ORM
- Queue: Custom PostgreSQL + Redis (not BullMQ)

Forbidden:

- Python, Ruby, PHP, C# code blocks
- Prisma mentions (without Drizzle context)
- BullMQ mentions
- MySQL mentions (without PostgreSQL context)

**Detection**: `detect_tech_stack_violations.sh`  
**Fix**: Manual (context-dependent)

## Codefence Rules

1. Opening fences must have language: ` ```typescript `
2. Closing fences must be empty: ` ``` `

**Detection**: `detect_codefence_issues.sh`  
**Fix**: `fix_codefences.sh` (automated for closing fences)

## Whitespace Rules

1. No trailing whitespace on any line

**Detection**: `detect_whitespace_issues.sh`  
**Fix**: `fix_whitespace.sh` (automated)

## Navigation Rules

1. `nav_order` must be numeric (positive integer)

**Detection**: `detect_navigation_violations.sh`  
**Fix**: Manual

## Content Quality Rules

1. No emoji in titles
2. Files should not exceed 500 lines

**Detection**: `detect_content_quality_issues.sh`  
**Fix**: Manual (split large files)

## Formatting Rules

1. Blank lines before headings (except at file start)
2. Blank lines around lists
3. Don't use emphasis (`**text**`) as headings (use `## text`)

**Detection**: `detect_formatting_issues.sh`  
**Fix**: Planned (automated fix script)

```

### Step 2.4: Update AGENTS.md

Add validation guidelines for AI agents:

```markdown
## Documentation Validation

When creating or modifying documentation:

1. **Always run validation** before committing:
   ```bash
   cd validation
   bash scripts/detect/detect_frontmatter_issues.sh docs
   ```

2. **Use automated fixes** when available:

   ```bash
   bash scripts/fix/fix_whitespace.sh docs
   bash scripts/fix/fix_link_extensions.sh docs
   ```

3. **Follow validation rules** (see `/validation/README.md`):
   - Complete frontmatter required
   - Site-absolute links without .md
   - Approved tech stack only
   - Proper code fence syntax
   - No trailing whitespace

4. **Test your changes**:

   ```bash
   bash test_runner.sh  # 17/17 tests should pass
   ```

```

## Phase 3: GitHub Actions Integration

### Step 3.1: Create Workflow File

**File**: `.github/workflows/validate-docs.yml`

```yaml
name: Documentation Validation

on:
  pull_request:
    paths:
      - 'docs/**/*.md'
  push:
    branches:
      - main
    paths:
      - 'docs/**/*.md'

jobs:
  validate:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v3
      
      - name: Run Frontmatter Validation
        run: bash validation/scripts/detect/detect_frontmatter_issues.sh docs
        
      - name: Run Link Policy Validation
        run: bash validation/scripts/detect/detect_link_policy_violations.sh docs
        
      - name: Run Tech Stack Validation
        run: bash validation/scripts/detect/detect_tech_stack_violations.sh docs
        
      - name: Run Codefence Validation
        run: bash validation/scripts/detect/detect_codefence_issues.sh docs
        
      - name: Run Whitespace Validation
        run: bash validation/scripts/detect/detect_whitespace_issues.sh docs
        
      - name: Run Navigation Validation
        run: bash validation/scripts/detect/detect_navigation_violations.sh docs
        
      - name: Run Content Quality Validation
        run: bash validation/scripts/detect/detect_content_quality_issues.sh docs
        
      - name: Run Formatting Validation
        run: bash validation/scripts/detect/detect_formatting_issues.sh docs
      
      - name: Upload validation reports
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: validation-reports
          path: validation/reports/*.json
```

### Step 3.2: Test GitHub Actions Locally

Use `act` to test the workflow locally before pushing:

```bash
# Install act (if not already installed)
# https://github.com/nektos/act

# Test the workflow
act pull_request -W .github/workflows/validate-docs.yml
```

## Phase 4: Rollout Plan

### Week 1: Testing & Refinement

- [ ] Run baseline validation on `docs/`
- [ ] Review all findings
- [ ] Adjust detection scripts if false positives found
- [ ] Test fix scripts on copies
- [ ] Document any edge cases

### Week 2: Documentation Updates

- [ ] Update README.md
- [ ] Update CONTRIBUTING.md
- [ ] Create MARKDOWN_LINT.md
- [ ] Update AGENTS.md
- [ ] Add validation section to docs/index.md

### Week 3: Apply Automated Fixes

- [ ] Backup `docs/` directory
- [ ] Run automated fix scripts
- [ ] Verify changes with git diff
- [ ] Re-run detection to confirm fixes
- [ ] Commit fixes with detailed message

### Week 4: CI/CD Integration

- [ ] Create GitHub Actions workflow
- [ ] Test workflow on feature branch
- [ ] Monitor first few PRs
- [ ] Adjust workflow if needed
- [ ] Document workflow in README

## Success Criteria

✅ All detection scripts run successfully on `docs/`  
✅ Baseline report generated and reviewed  
✅ Fix scripts tested and verified  
✅ Project documentation updated  
✅ GitHub Actions workflow created and tested  
✅ First PR with validation passes CI  

## Rollback Plan

If issues arise:

1. **Detection issues**: Adjust script logic, re-test on fixtures
2. **Fix script issues**: Restore from backup, fix script, re-test
3. **CI/CD issues**: Disable workflow, fix locally, re-enable
4. **False positives**: Add exceptions to detection scripts

## Support

For questions or issues:

- Review `/validation/README.md`
- Check test fixtures in `/validation/fixtures/`
- Run `bash validation/test_runner.sh` to verify pipeline health
- Review JSON reports in `/validation/reports/`

## Next Session Checklist

Before starting integration in a new chat session:

1. [ ] Review this document completely
2. [ ] Run Phase 1 baseline validation
3. [ ] Document findings in a new artifact
4. [ ] Decide which fixes to apply first
5. [ ] Test one detection script at a time
6. [ ] Verify each fix script on copies before applying
7. [ ] Update documentation incrementally
8. [ ] Test GitHub Actions workflow last

**Remember**: Safety first! Always test on copies, review changes carefully, and integrate incrementally.
