# Archived Validation Scripts

This directory contains validation scripts that have been archived because their functionality is now handled by `markdownlint` directly.

## Archived Scripts

### 1. `detect_whitespace_issues.sh.archived`
**Archived Date**: 2025-11-28  
**Reason**: Fully redundant with `markdownlint --fix`

**What it checked**:
- Trailing whitespace (MD009)

**Replacement**:
```bash
# Detection
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json 2>&1 | grep "MD009"

# Auto-fix
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json --fix
```

---

### 2. `detect_codefence_issues.sh.archived`
**Archived Date**: 2025-11-28  
**Reason**: Detection now handled by `markdownlint MD040`

**What it checked**:
- Missing language tags on code fences (MD040)

**Replacement**:
```bash
# Detection
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json 2>&1 | grep "MD040"
```

**Note**: The new `detect_formatting_issues.sh` now includes MD040 detection via markdownlint.

---

## Why Archive Instead of Delete?

These scripts are archived (not deleted) for:
1. **Historical reference** - Understanding previous validation approaches
2. **Custom logic preservation** - In case custom JSON format or intermediary files are needed
3. **Rollback capability** - If markdownlint approach proves insufficient

## Current Validation Approach

### Step 1: Auto-fix with markdownlint
```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json --fix
```

**Auto-fixes**:
- MD009: Trailing spaces
- MD022: Blank lines around headings
- MD032: Blank lines around lists
- And 15+ other rules

### Step 2: Detect remaining issues
```bash
# Run consolidated formatting detection (MD001, MD036, MD040)
bash validation/scripts/detect/detect_formatting_issues.sh docs

# Run project-specific detection scripts
bash validation/scripts/detect/detect_link_policy_violations.sh docs
bash validation/scripts/detect/detect_frontmatter_issues.sh docs
bash validation/scripts/detect/detect_tech_stack_violations.sh docs
bash validation/scripts/detect/detect_navigation_violations.sh docs
bash validation/scripts/detect/detect_content_quality_issues.sh docs
```

## Benefits of New Approach

1. **Industry Standard**: Uses widely-adopted markdownlint tool
2. **Accurate Detection**: Proven regex patterns and edge case handling
3. **Less Maintenance**: No custom awk/grep scripts to maintain
4. **Faster Execution**: Optimized C-based tool vs bash scripts
5. **Better Reporting**: Consistent file:line format across all checks

## Migration Notes

- Old JSON report format preserved in archived scripts
- New scripts use markdownlint output format (file:line rule/description)
- Intermediary files no longer generated (not needed with markdownlint)
- Fix scripts still work with markdownlint detection output

---

**Last Updated**: 2025-11-28  
**Archived By**: Validation pipeline optimization
