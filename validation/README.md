# Documentation Validation Pipeline

Three-tier validation system for ensuring documentation quality and consistency.

## Architecture

```
validation/
├── fixtures/          # Test fixtures (good/bad examples)
│   ├── frontmatter/
│   ├── links/
│   ├── tech/
│   ├── codefence/
│   └── whitespace/
├── scripts/
│   ├── detect/        # Detection scripts (CI-ready)
│   └── fix/           # Fix scripts (automated/AI-assisted)
└── reports/           # JSON reports with timestamps
    └── instances/     # Intermediary files for complex fixes
```

## Quick Start

### Run Detection Scripts

```bash
# Frontmatter validation (on docs/)
bash validation/scripts/detect/detect_frontmatter_issues.sh

# Test on fixtures
bash validation/scripts/detect/detect_frontmatter_issues.sh validation/fixtures/frontmatter/bad
```

### View Reports

```bash
# Latest frontmatter report
cat validation/reports/frontmatter_issues_*.json | jq
```

## Fixtures

Each validation rule has good/bad example fixtures for testing:

### Frontmatter (✅ Complete)

- **Good**: `complete_frontmatter.md`
- **Bad**:
  - `missing_title.md`
  - `missing_description.md`
  - `missing_level.md`
  - `missing_persona.md`
  - `missing_date.md`
  - `keywords_in_body_bold.md`
  - `incomplete_frontmatter.md`

### Link Policy (✅ Complete)

- **Good**: `site_absolute_links.md`
- **Bad**:
  - `relative_tasks_link.md`
  - `relative_journeys_link.md`
  - `contributing_link.md`
  - `md_extension_site_absolute.md`
  - `relative_md_links.md`

### Tech Stack (✅ Partial)

- **Good**: `approved_stack.md`
- **Bad**:
  - `python_block.md`
  - `ruby_block.md`
  - `prisma_mention.md`
  - `bullmq_mention.md`
  - 🚧 TODO: `mysql_mention.md`, `php_block.md`, `csharp_block.md`

### Codefence (✅ Complete)

- **Good**: `proper_language_tags.md`
- **Bad**:
  - `missing_opening_lang.md`
  - `closing_fence_with_lang.md`

### Whitespace (⚠️ Partial)

- **Good**: `clean_formatting.md`
- **Bad**:
  - `trailing_whitespace.md`
  - 🚧 TODO: `multiple_blank_lines.md`, `missing_final_newline.md`

## Detection Scripts

### Available Scripts

| Script | Status | Description |
|--------|--------|-------------|
| `detect_frontmatter_issues.sh` | ✅ Complete | Detects missing frontmatter fields and keywords in body |
| `detect_link_policy_violations.sh` | 🚧 TODO | Detects link policy violations |
| `detect_tech_stack_violations.sh` | 🚧 TODO | Detects forbidden tech mentions and code blocks |
| `detect_codefence_issues.sh` | 🚧 TODO | Parses markdownlint for codefence issues |
| `detect_whitespace_issues.sh` | 🚧 TODO | Parses markdownlint for whitespace issues |

### Script Signature

All detection scripts follow this pattern:

```bash
#!/bin/bash
# Usage: ./detect_*.sh [target_directory]
TARGET_ROOT="${1:-docs}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="validation/reports/*_issues_${TIMESTAMP}.json"

# ... detection logic ...

# Exit codes:
#   0 = No issues found
#   1 = Issues detected (fails CI)
exit $exit_code
```

### Output Format

JSON reports include:

```json
{
  "timestamp": "2025-11-28T04:13:35-05:00",
  "target_root": "docs/",
  "issues": {
    "missing_title": {
      "description": "Missing 'title' field",
      "count": 5,
      "files": ["docs/file1.md", "docs/file2.md"]
    }
  },
  "total_issues": 5
}
```

## Fix Scripts (Coming Soon)

### Automated Fixes (No AI)

- ✅ `fix_whitespace.sh` - Uses `markdownlint --fix`
- ✅ `fix_link_extensions.sh` - Removes `.md` from `/docs/` links
- ⚠️ `fix_relative_links.sh` - Converts relative to site-absolute

### Markdownlint-Assisted (Line-Specific)

- ⚠️ `fix_codefences.sh` - Parses markdownlint JSON for exact line numbers

### AI-Assisted (Manual Review Required)

- ⚠️ `fix_frontmatter.sh` - Generates missing fields
- ⚠️ `fix_tech_stack_mentions.sh` - Rewrites forbidden tech references

## CI/CD Integration (Planned)

`.github/workflows/validate-docs.yml` will:

1. Run all detection scripts on PR
2. Fail build if issues found
3. Post report as PR comment

## Testing

Test detection scripts against fixtures:

```bash
# Should detect 6 issues and exit 1
bash validation/scripts/detect/detect_frontmatter_issues.sh validation/fixtures/frontmatter/bad

# Should pass with exit 0
bash validation/scripts/detect/detect_frontmatter_issues.sh validation/fixtures/frontmatter/good
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

Forbidden:

- **Code blocks**: `python`, `ruby`, `php`, `csharp`
- **Tech mentions**: Prisma, BullMQ, MySQL (without approved context)

## Progress

- ✅ Phase 1: Test fixtures (80% complete)
- 🚧 Phase 2: Detection scripts (20% complete)
- ⚠️ Phase 3: Fix scripts (not started)
- ⚠️ Phase 4: CI/CD integration (planned)
- ⚠️ Phase 5: Testing infrastructure (not started)

## Next Steps

1. Complete remaining fixtures (mysql, csharp, php, whitespace variants)
2. Build link policy detection script
3. Build tech stack detection script
4. Create unit tests for detection scripts
5. Build automated fix scripts
6. Integrate with GitHub Actions

## Related Files

- Implementation plan: `.gemini/antigravity/brain/.../implementation_plan.md`
- Task tracker: `.gemini/antigravity/brain/.../task.md`
- Existing validator: `scripts/verify-docs.sh`


## Improved Workflow (Post-Task 4)

### Quick Validation Status

```bash
# Get current status across all categories
bash validation/scripts/validation_summary.sh docs
```

### Safe Testing Workflow

```bash
# 1. Create test copy
cp -r docs docs-test-backup

# 2. Run validation workflow on copy
bash validation/scripts/run_validation_workflow.sh docs-test-backup

# 3. Review changes
git diff docs docs-test-backup

# 4. Apply to production if satisfied
bash validation/scripts/run_validation_workflow.sh docs

# 5. Clean up
rm -rf docs-test-backup
```

## Key Improvements Applied

### 1. Markdownlint Integration
- Uses Docker-based markdownlint for standard checks (MD040, MD001, MD036, etc.)
- Runs `markdownlint --fix` first for auto-fixable issues
- Custom scripts only for non-standard validations

### 2. File-by-File Processing
- Processes files individually to avoid overwriting changes
- Uses awk instead of sed for complex multi-line operations
- Generates intermediary files with line numbers for precise fixes

### 3. Test-First Approach
- Always test on `docs-test-backup` before production
- Workflow script enforces safe testing
- Clear diff review before applying changes

### 4. Precise Targeting
- MD040 fix: Only adds language to opening fences, not closing
- Link fix: Only removes `.md` from site-absolute `/docs/` links
- Uses line-specific targeting from markdownlint output

## Auto-Fixable Issues

| Issue | Detection | Fix Script | Status |
|-------|-----------|------------|--------|
| MD040 (code fence language) | markdownlint | `fix_codefences_md040_v2.sh` | ✅ Working |
| Link `.md` extensions | `detect_link_policy_violations.sh` | `fix_link_extensions.sh` | ✅ Working |
| Trailing whitespace (MD009) | markdownlint --fix | Built-in | ✅ Working |
| Blank lines (MD022, MD032) | markdownlint --fix | Built-in | ✅ Working |

## Manual Fix Categories

| Category | Count | Priority | Notes |
|----------|-------|----------|-------|
| MD001 (heading hierarchy) | 229 | Medium | Structural changes needed |
| MD036 (emphasis as heading) | 235 | Low | Cosmetic improvements |
| Frontmatter issues | 496 | High | Missing required fields |
| Tech stack violations | TBD | High | Forbidden languages/tech |
| Navigation violations | TBD | Medium | Invalid nav_order values |
| Content quality | 193 | Low | File length, emoji in titles |

## Lessons Learned

### What Worked Well
1. **Markdownlint integration** - Reliable, battle-tested, Docker-based
2. **Intermediary files** - Line-specific targeting prevents errors
3. **Test copies** - Safe experimentation without risk
4. **Awk over sed** - Better for multi-line operations

### Edge Cases Handled
1. **Opening vs closing fences** - Only tag opening fences with language
2. **Anchor links** - Handle both `/docs/file.md` and `/docs/file.md#anchor`
3. **File path issues** - Use awk to avoid sed escaping problems

### Future Improvements
1. Add progress bars for long-running operations
2. Parallel processing for faster detection
3. Interactive mode for manual fix guidance
4. Integration with CI/CD pipeline
