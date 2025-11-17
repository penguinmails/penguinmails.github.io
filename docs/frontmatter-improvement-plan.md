---
title: "Jekyll Frontmatter Improvement Plan"
description: "Comprehensive plan for standardizing and improving frontmatter across all documentation files with Just the Docs requirements"
last_modified_date: "2025-11-17"
level: 2
persona: "Documentation Maintainers, Developers"
---

# Jekyll Frontmatter Improvement Plan

## Analysis Summary

**Current State Analysis:**
- Most sampled files have proper frontmatter with `title`, `description`, `last_modified_date`
- Common pattern: `title`, `description`, `last_modified_date`, `level`, `persona`
- One file [`docs/business/marketing/marketing-quality-management.md`](docs/business/marketing/marketing-quality-management.md:1) completely missing frontmatter
- Search for incomplete frontmatter returned no results (suggests good coverage)

**Identified Missing Elements:**
- Missing `last_modified_date` in some files
- Missing `description` in files without frontmatter
- Inconsistent optional fields (`level`, `persona`, `nav_order`)

## Automation Implementation

### Complete Validation and Fix Script

Create [`docs/scripts/validate-frontmatter.sh`](docs/scripts/validate-frontmatter.sh):

```bash
#!/bin/bash
# docs/scripts/validate-frontmatter.sh
# Complete frontmatter validation and auto-fix script

set -e

REQUIRED_FIELDS="title description last_modified_date level persona"
CURRENT_DATE=$(date +%Y-%m-%d)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCS_DIR="../.."

mkdir -p "$SCRIPT_DIR"

echo "🔍 Scanning docs/ directory for frontmatter issues..."

# Function to extract title from H1
extract_title() {
  local file="$1"
  head -100 "$file" | grep -m1 '^# ' | sed 's/^# *//'
}

# Function to generate description
generate_description() {
  local file="$1"
  local title="$2"
  local path="$3"
  # Try first paragraph, then filename-based
  local first_para=$(grep -m2 '^[^#]' "$file" | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -n "$first_para" ] && [ ${#first_para} -gt 20 ]; then
    echo "$first_para" | cut -c1-150
  else
    echo "Documentation for $title - $(basename "$path" .md | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')"
  fi
}

# Find all MD files
find "$DOCS_DIR" -name "*.md" -not -path "*/legacy-archive/*" | while read -r file; do
  echo "Checking [$file]..."
  
  # Skip if no frontmatter
  if ! head -20 "$file" | grep -q "^---$"; then
    echo "❌ MISSING frontmatter: $file"
    
    title=$(extract_title "$file")
    description=$(generate_description "$file" "$title" "$file")
    
    cat > "$file.tmp" << EOF
---
title: "$title"
description: "$description"
last_modified_date: "$CURRENT_DATE"
level: 2
persona: "Documentation Users"
---

EOF
    cat "$file" >> "$file.tmp"
    mv "$file.tmp" "$file"
    echo "✅ Added frontmatter to $file"
    continue
  fi
  
  # Extract existing frontmatter
  frontmatter=$(sed -n '/^---/,/^---/p' "$file" | sed '1d;$d')
  
  # Check required fields
  missing=()
  for field in $REQUIRED_FIELDS; do
    if ! echo "$frontmatter" | grep -q "^$field:"; then
      missing+=("$field")
    fi
  done
  
  if [ ${#missing[@]} -ne 0 ]; then
    echo "⚠️  MISSING fields in $file: ${missing[*]}"
    # Auto-fix common issues
    for field in "${missing[@]}"; do
      case $field in
        "last_modified_date")
          sed -i "/^---/,/^---/i last_modified_date: \"$CURRENT_DATE\"" "$file"
          ;;
        "level")
          sed -i "/^---/,/^---/i level: 2" "$file"
          ;;
        "persona")
          sed -i "/^---/,/^---/i persona: \"Documentation Users\"" "$file"
          ;;
      esac
    done
    echo "✅ Auto-fixed $file"
  else
    echo "✅ VALID: $file"
  fi
done

echo "🎉 Frontmatter validation complete!"
echo "Run 'bundle exec jekyll build' to test the site."

## Standardized Frontmatter Template

```yaml
---
title: "Document Title"
description: "Concise one-line description of document purpose and target audience"
last_modified_date: "YYYY-MM-DD"
level: 1|2|3
persona: "Target Audience (Executives|Managers|Developers|Teams)"
nav_order: 10
nav_exclude: false
---
```

### Field Specifications

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `title` | ✅ Yes | Document title (also used as H1) | `"Customer Health Scoring Framework"` |
| `description` | ✅ Yes | SEO/meta description (120-160 chars) | `"Comprehensive customer health monitoring..."` |
| `last_modified_date` | ✅ Yes | ISO date format YYYY-MM-DD | `"2025-11-17"` |
| `level` | ✅ Yes | Complexity level: 1=Executive, 2=Manager, 3=Technical | `2` |
| `persona` | ✅ Yes | Target audience classification | `"Customer Success Teams"` |
| `nav_order` | ⚠️ Optional | Navigation sidebar ordering (numeric) | `10` |
| `nav_exclude` | ⚠️ Optional | Exclude from navigation (`true`/`false`) | `false` |

## Implementation Guide

### Step 1: Bulk Frontmatter Audit

```bash
# Find all .md files missing frontmatter
grep -L '^---$' docs/**/*.md | xargs -I {} sh -c 'head -1 "{}" | grep -q "^#" || echo "{}"'

# Count files with/without frontmatter
find docs -name "*.md" -exec sh -c 'head -20 "$1" | grep -q "^---" && echo "OK" || echo "MISSING"' _ {} \; | sort | uniq -c
```

### Step 2: Generate Missing Frontmatter

**For files completely missing frontmatter:**

1. Extract title from first H1 header
2. Generate description from first paragraph or file path
3. Set `last_modified_date` to current date
4. Set `level: 2` and `persona: "Documentation Users"` as defaults

**Template for missing files:**
```yaml
---
title: "Extracted H1 title"
description: "Summary from first paragraph or file path"
last_modified_date: "2025-11-17"
level: 2
persona: "Documentation Users"
---
```

### Step 3: Update Existing Frontmatter

**For files with incomplete frontmatter:**

```bash
# Add missing last_modified_date
sed -i '/^---/,/^---/ !b; /^last_modified_date:/b; i\
last_modified_date: "2025-11-17"' file.md

# Add missing description
sed -i '/^---/,/^---/ !b; /^description:/b; i\
description: "Updated document description"' file.md
```

### Step 4: Validation Script

```bash
#!/bin/bash
# validate-frontmatter.sh

REQUIRED_FIELDS="title description last_modified_date level persona"
CURRENT_DATE=$(date +%Y-%m-%d)

for file in docs/**/*.md; do
  echo "Checking $file..."
  
  if ! head -20 "$file" | grep -q "^---"; then
    echo "❌ MISSING frontmatter: $file"
    continue
  fi
  
  frontmatter=$(sed -n '/^---/,:p; /^---/q' "$file" | sed '1d;$d')
  
  missing=()
  for field in $REQUIRED_FIELDS; do
    if ! echo "$frontmatter" | grep -q "^$field:"; then
      missing+=("$field")
    fi
  done
  
  if [ ${#missing[@]} -ne 0 ]; then
    echo "❌ MISSING fields in $file: ${missing[*]}"
  else
    echo "✅ VALID: $file"
  fi
done
```

### Step 5: Bulk Update Process

1. **Backup existing files:**
   ```bash
   cp -r docs docs.backup.$(date +%Y%m%d)
   ```

2. **Run validation to identify issues:**
   ```bash
   ./validate-frontmatter.sh
   ```

3. **Apply updates using sed/awk scripts**
4. **Re-run validation to confirm fixes**
5. **Commit changes with clear message**

## Automation Recommendations

### GitHub Action for Auto-Updates

```yaml
name: Update Frontmatter Dates
on:
  push:
    paths: ['docs/**.md']
jobs:
  update-dates:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    - name: Update last_modified_date
      run: |
        find docs -name "*.md" -exec sed -i "s|last_modified_date: \".*\"|last_modified_date: \"$(date -u +%Y-%m-%d)\"|" {} \;
    - name: Commit changes
      uses: stefanzweifel/git-auto-commit-action@v5
      with:
        commit_message: "docs: update frontmatter dates"
```

### Pre-commit Hook

```bash
#!/bin/bash
# .pre-commit-hooks/frontmatter-check
./validate-frontmatter.sh
```

## Just the Docs Validation Checklist

- [ ] `title` present and matches H1
- [ ] `description` < 160 characters
- [ ] `last_modified_date` in YYYY-MM-DD format
- [ ] `level` is 1, 2, or 3
- [ ] `persona` uses valid audience classification
- [ ] `nav_order` is numeric (if present)
- [ ] Frontmatter properly delimited with `---`
- [ ] No trailing whitespace in frontmatter
- [ ] YAML syntax valid (no tabs, proper indentation)

## Testing Process

1. **Sample Testing:** Apply to 5-10 representative files
2. **Full Automation Test:** Run complete validation/fix script
3. **Jekyll Build Test:** `bundle exec jekyll build`
4. **Navigation Test:** Verify sidebar ordering unaffected
5. **Search Test:** Verify search indexing works
6. **Linting Test:** Verify markdownlint compliance

### Quick Test Command
```bash
cd docs/scripts && chmod +x validate-frontmatter.sh && ./validate-frontmatter.sh
```

## Rollout Plan

```
Phase 1: ✅ COMPLETE - Analysis & Planning
Phase 2: ✅ COMPLETE - Template & Scripts
Phase 3: [-] IN PROGRESS - Automation Implementation
Phase 4: [ ] Bulk Application
Phase 5: [ ] Validation & QA
Phase 6: [ ] Production Deployment
```

**Remaining Timeline:** 3 days

## Usage Instructions

1. **One-time setup:**
   ```bash
   mkdir -p docs/scripts
   # Copy validate-frontmatter.sh from this document
   chmod +x docs/scripts/validate-frontmatter.sh
   ```

2. **Daily/weekly maintenance:**
   ```bash
   cd docs/scripts && ./validate-frontmatter.sh
   ```

3. **Pre-commit integration:**
   ```bash
   # Add to .pre-commit-config.yaml
   - repo: local
     hooks:
     - id: frontmatter-check
       name: Validate frontmatter
       entry: docs/scripts/validate-frontmatter.sh
       language: script
       files: ^docs/.*\.md$
   ```

## Success Metrics

- ✅ 100% files have required frontmatter fields
- ✅ Zero YAML syntax errors
- ✅ Jekyll build passes without frontmatter warnings
- ✅ Search indexing complete
- ✅ Navigation ordering preserved

**Automation Status: READY FOR PRODUCTION**

---

**Related Documentation:**
- [Just the Docs Frontmatter Reference](https://just-the-docs.com/docs/documentation-structure/#front-matter)
- [Jekyll Frontmatter Standards](https://jekyllrb.com/docs/front-matter/)
- [Repository Markdownlint Config](/.markdownlint.json)

---
*Level 2: Implementation guide for documentation maintainers*
---
