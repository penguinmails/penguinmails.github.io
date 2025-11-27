# Markdown Linting Guide

This guide consolidates all markdown linting procedures, surgical methodologies, tools, Docker commands, link validation, tech stack compliance verification, quality assurance checklists, progress tracking templates, and troubleshooting for the PenguinMails documentation repository. It achieved 97.7% error reduction across 517 files using a proven five-phase surgical approach.

## Configuration

The [.markdownlint.json](.markdownlint.json) file configures markdownlint with these settings:

```json
{
  "MD025": {
    "front_matter_title": ""
  },
  "MD041": {
    "front_matter_title": "^\\s*title\\s*[:=]"
  },
  "MD013": false,
  "MD036": {
    "punctuation": ".,;:!?"
  },
  "MD060": false,
  "MD003": false,
  "MD024": false,
  "MD033": false
}

```

Key rules addressed:

- MD022: Blank lines around headings

- MD032: Blank lines around lists

- MD031: Blank lines around fenced code blocks

- MD036: Emphasis used instead of headings

- MD040: Fenced code block language specification

- MD012: Multiple consecutive blank lines

## Five-Phase Surgical Framework

### Phase 1: Automated Bulk Fixes

Run auto-fixable issues first:

```bash
npx markdownlint-cli2 docs/**/*.{md,markdown} --fix

```

**Coverage:** ~900+ issues (MD012, MD022 partial, MD032 partial, MD031 partial).

Validate progress:

```bash
npx markdownlint-cli2 docs/**/*.{md,markdown}

```

### Phase 2: Targeted Line-Based Fixes (MD040)

Extract line numbers from linting output, use [`fix_md040_language_fences.py`](fix_md040_language_fences.py).

**Coverage:** 8 MD040 issues.

### Phase 3: Priority Surgical Fixes (MD036 Round 1)

Extract issues:

```bash
python3 [`extract_md036_issues.py`](extract_md036_issues.py)

```

Apply priority fixes:

```bash
python3 [`fix_md036_priority_fixes.py`](fix_md036_priority_fixes.py)

```

**Patterns:** Stage/Phase (18), Quarters (33), Sections (37). **Coverage:** 88 issues, 20 files.

### Phase 4: Secondary Pattern Fixes (MD036 Round 2)

```bash
python3 [`fix_remaining_md036.py`](fix_remaining_md036.py)

```

**Patterns:** Finance/Product integration. **Coverage:** 23 issues, 5 files.

### Phase 5: Final Pattern Resolution (MD036 Italics)

```bash
python3 [`fix_final_md036.py`](fix_final_md036.py)

```

**Coverage:** 5 italic instances.

## Bulk Fix Script

Use [`fix_linting.py`](fix_linting.py) for reliable bulk fixes (MD022, MD032, MD031):

```bash
python3 [`fix_linting.py`](fix_linting.py)

```

Key functions:

[`fix_linting.py`](fix_linting.py:15)

```python
def fix_heading_blank_lines(content):
    """Fix MD022: Add blank lines around headings"""
    content = re.sub(r'(?<!\n\n)(\n#{1,6}\s+)', r'\n\1', content)
    content = re.sub(r'(\n#{1,6}\s+.*?)(?=\n[^\n#])', r'\1\n', content)
    return content

```

Similar for lists and code fences.

## Docker Linting Commands

### Basic Linting

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config [.markdownlint.json](.markdownlint.json)

```

### Auto-Fix

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/ --config [.markdownlint.json](.markdownlint.json) --fix

```

### Specific Directory

```bash
docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint docs/business/**/*.md --config [.markdownlint.json](.markdownlint.json)

```

## Link Validation Commands

```bash

# No .md extensions in internal links

grep -r "\[.*\](\([^)]*\)[^)]*\.md[^)]*)" docs/ --include="*.md"


# No file:// URLs

grep -r "file://" docs/ --include="*.md"


# Malformed relative links

grep -r "]\(\.\.\)" docs/ --include="*.md"

```

Jekyll rules: Internal links use `/docs/path` without `.md`; relative `./file`.

## Tech Stack Compliance Verification

```bash

# Forbidden tech

grep -ri "prisma\|bullmq\|mysql\|kafka\|auth0\|nextauth" docs/ --include="*.md"


# Approved tech count

grep -r "```typescript\|```javascript" docs/ --include="*.md" | wc -l
grep -ri "drizzle\|niledb\|postgresql\|redis" docs/ --include="*.md" | wc -l

```

**Rules:** TypeScript/JS only; Drizzle ORM; PostgreSQL+NileDB; PostgreSQL+Redis queue.

## Surgical Decision Framework

**Convert to Headings:**

- `**Stage 1:**` → `## Stage 1:`

- `**Q1 2026:**` → `### Q1 2026:`

- `**Database Integration**` → `### Database Integration`

- `*Screen: Name*` → `#### Screen: Name`

**Preserve:**

- `**Note:**` intentional emphasis

- `*Italic context*` guidance

## Quality Assurance Checklist

### Before Scripts

- [ ] Backup or branch

- [ ] Review [.markdownlint.json](.markdownlint.json)

- [ ] Test on 5-10 files

### During Execution

- [ ] Monitor errors

- [ ] Verify samples

- [ ] Check unintended changes

### After Each Phase

- [ ] Run linting

- [ ] Review remaining

- [ ] Update tracking

## Progress Tracking Template

| Phase | Method | Issues Fixed | Files Modified | Success Rate |
|-------|--------|--------------|----------------|--------------|
| Phase 1 | Automated bulk | ~900+ | 517 | 99% |
| Phase 2 | Line-based | 8 | 3 | 100% |
| Phase 3 | Priority surgical | 88 | 20 | 100% |
| Phase 4 | Secondary patterns | 23 | 5 | 100% |
| Phase 5 | Final resolution | 5 | 1 | 100% |
| **Total** | Multi-phase | **1024+** | **517** | **97.7%** |

**Before:** 1000+ errors, 509+ files. **After:** 23 errors, ~15 files.

## Troubleshooting

- **Regex errors:** Switch to line-based

- **Collateral damage:** Test samples first

- **Mixed emphasis:** Separate bold/italic scripts

- **Docker permissions:** `sudo usermod -aG docker $USER`

## Success Criteria

- **Minimum:** 80% error reduction

- **Target:** 90%+

- **Exceptional:** 95%+ with professional formatting

**Maintenance:** Monthly linting; CI integration.

For CONTRIBUTING.md updates, see [`CONTRIBUTING.md`](CONTRIBUTING.md#markdown-linting).
