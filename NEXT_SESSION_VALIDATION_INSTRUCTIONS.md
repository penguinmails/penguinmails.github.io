# Next Session: Validation Verification Instructions

This repository now includes unit-style tests for our documentation validation commands. Continue in the next chat by following this guide.


## Overview

We are validating each grep/awk-based rule with small, controlled fixtures before running the rules across the full `docs/` tree. This TDD-like approach ensures our regexes are accurate and minimize false positives/negatives.

Project link policy reminder:


- Use site-absolute links beginning with `/docs/`.


- Avoid relative Markdown links inside `docs/` (no `./` or `../`).


- Drop `.md` extensions when linking to routable docs.


## What’s Already Implemented


- Frontmatter validations


  - Fixtures: `.kiro/tests/validation-fixtures/frontmatter/`


    - `good.md`, `missing_title.md`, `missing_description.md`, `missing_last_modified_date.md`, `missing_level.md`, `missing_persona.md`, `keywords_in_body_bold.md`, `keywords_in_body_plain.md`, `incomplete_frontmatter.md`


  - Runner: `.kiro/tests/test_frontmatter_validations.sh`


  - Verified rules:


    - Missing fields: `^title:`, `^description:`, `^last_modified_date:`, `^level:`, `^persona:`


    - Keywords in body: `^**Keywords**:` and `^Keywords:`


    - Incomplete frontmatter: odd number of `---` via `awk` per file


- Link validations


  - Fixtures: `.kiro/tests/validation-fixtures/links/`


    - `tasks_link_relative.md`, `tasks_link_absolute.md`


    - `user_journeys_link_relative.md`, `user_journeys_link_absolute.md`


    - `contributing_link.md`, `readme_link_parent.md`, `readme_link_root_abs.md`


    - `md_extension_site_absolute.md`, `relative_links.md`


  - Runner: `.kiro/tests/test_link_validations.sh`


  - Verified rules:


    - Links to `tasks/` and `user-journeys/` (relative and absolute)


    - Links to `CONTRIBUTING` and root `README` (relative and absolute)


    - Site-absolute internal `.md` links: `](/docs/.*\.md)`


    - Relative `.md` links: `](\..*/.*\.md)`


    - Relative links using `./` or `../`: use `grep -E` with pattern `"\]\((\./|\.\./)"`

All implemented tests currently pass.


## How to Run Existing Test Suites


```bash


# Frontmatter

bash .kiro/tests/test_frontmatter_validations.sh


# Link validations

bash .kiro/tests/test_link_validations.sh


```sql


## Next Tasks: Add Tests for Remaining Categories

Follow the same fixture+runner pattern for each category below. Place new fixtures under a category-specific directory within `.kiro/tests/validation-fixtures/`, and add a `test_*.sh` script under `.kiro/tests/`.

1) Tech Stack Compliance


- Greps to verify:


  - Forbidden code blocks: `^```python`, `^```ruby`, `^```php`, `^```csharp`


  - Forbidden tech mentions (case-insensitive):


    - `grep -ri "prisma" ... | grep -vi "drizzle"`


    - `grep -ri "bullmq" ...`


    - `grep -ri "mysql" ... | grep -vi "postgresql"`


- Add: `.kiro/tests/validation-fixtures/tech/` and `.kiro/tests/test_tech_stack_validations.sh`

2) Navigation Structure


- Greps to verify:


  - `^nav_order:`


  - `^nav_exclude:`


- Ensure only the intended 5 files (final site) will use these fields.


- Add: `.kiro/tests/validation-fixtures/navigation/` and `.kiro/tests/test_navigation_validations.sh`

3) Content Quality


- Greps/commands:


  - Emojis in titles (best-effort): `^title:.*[😀-🙏🚀-🛿]`


  - Potential broken anchor links: `](#[^)]*)`


  - Overlong files (>300 lines): `find ... -exec wc -l {} \; | awk '$1 > 300 {print $1, $2}'`


- Add: `.kiro/tests/validation-fixtures/content/` and `.kiro/tests/test_content_quality_validations.sh`

4) Progressive Disclosure


- Greps:


  - `^level: "1"`, `^level: "2"`, `^level: "3"`


  - Missing level: `grep -L "^level:" ...`


- Add: `.kiro/tests/validation-fixtures/progressive/` and `.kiro/tests/test_progressive_disclosure_validations.sh`

5) Cross-Reference Integrity


- Greps:


  - Incomplete relative link patterns: `](\..)` and `](\../)$`


  - Missing section text: `grep -L "Related Documentation" ...`


- Add: `.kiro/tests/validation-fixtures/crossref/` and `.kiro/tests/test_cross_reference_validations.sh`

6) Root Files Checks (README/AGENTS/CONTRIBUTING/MARKDOWN_LINTING)


- Commands:


  - README: `grep -n "^## Quick Start" README.md`; `grep -n "CONTRIBUTING.md" README.md`; `grep -n "AGENTS.md" README.md`


  - AGENTS: `grep -n "site-absolute links starting with /docs/" AGENTS.md`


  - CONTRIBUTING: `grep -n "AGENTS.md" CONTRIBUTING.md`; confirm no `Validation Commands:` with `grep -n "Validation Commands:" CONTRIBUTING.md`


  - Enforce link policy in root files:


    - `grep -nE "]\(/docs/.+\.md(#|\))" README.md CONTRIBUTING.md AGENTS.md || echo "No .md in /docs links ✓"`


- Add: `.kiro/tests/test_root_files_validations.sh`


## Test Runner Pattern (Reference)

Each `test_*.sh` script should:


- Create a local set of expected hits (basenames only)


- Execute the exact grep/awk command(s) but scoped to the fixtures directory


- Normalize results to basenames and compare sets


- Print PASS/FAIL per check and exit non-zero if any fail

Use the existing scripts as templates:


- `.kiro/tests/test_frontmatter_validations.sh`


- `.kiro/tests/test_link_validations.sh`


## Current Progress in `scripts/`

In addition to the `.kiro/tests`-based unit-style tests, we now have a lightweight, script-focused test harness under `scripts/`:

- `scripts/verify-docs.sh`

  - Updated to accept an optional target root directory:

    - `TARGET_ROOT="${1:-docs}"`

  - All `find`/`grep` calls now operate on `"$TARGET_ROOT"` instead of hardcoded `docs/`.

  - Behavior is unchanged when run without arguments:

    - `bash scripts/verify-docs.sh` → scans the real `docs/` tree.

- `scripts/test-docs/` (fixture tree for `verify-docs.sh`)

  - `scripts/test-docs/good/frontmatter_ok.md`

    - Fully valid frontmatter (`title`, `description`, `last_modified_date`, `level`, `persona`).

    - No keywords-in-body, no invalid links, no forbidden code blocks.

  - `scripts/test-docs/violations/missing_title.md`

    - Frontmatter intentionally missing the `title:` field.

  - `scripts/test-docs/violations/keyword_in_body.md`

    - Valid frontmatter.

    - Body contains a `**Keywords**:` line that should be caught by the keywords-in-body rule.

  - `scripts/test-docs/violations/tasks_link_relative.md`

    - Valid frontmatter.

    - Body contains a relative `tasks/` link (for the `Links to tasks/ folder` check).

  - `scripts/test-docs/violations/forbidden_python_block.md`

    - Valid frontmatter.

    - Body contains a top-level ```python fenced code block (for the forbidden language block check).

All five fixtures currently use `level: "2"` and have complete frontmatter fields except for the intentional `title:` omission in `missing_title.md`.


### How to Run the Script-Level Fixtures

To run the verification script against the `scripts/test-docs` fixtures instead of the full `docs/` tree:

```bash

bash scripts/verify-docs.sh scripts/test-docs

```

Expected behavior with the current fixtures:

- Frontmatter verification

  - `Missing 'title' field` → 1 (only `missing_title.md`).

  - `Missing 'description' field` → 0.

  - `Missing 'level' field` → 0.

  - `Missing 'persona' field` → 0.

  - `Missing 'last_modified_date' field` → 0.

- Keywords in body

  - `Keywords in body` → 1 (only `keyword_in_body.md`).

- Invalid external links

  - `Links to tasks/ folder` → 1 (only `tasks_link_relative.md`).

  - `Links to user-journeys/ folder` → 0.

  - `Links to CONTRIBUTING.md` → 0.

  - `Links to root README.md` → 0.

- Jekyll-incompatible links

  - `Internal links with .md extension` → 0 (no `/docs/... .md` links in fixtures yet).

- Navigation structure

  - `Files with nav_order` → 0 (fixtures do not contain `nav_order:` yet).

- Tech stack compliance

  - `Python code blocks (forbidden)` → 1 (only `forbidden_python_block.md`).

  - `Ruby code blocks (forbidden)` → 0.

  - `PHP code blocks (forbidden)` → 0.

  - `Forbidden tech mentions` → 0 (no `prisma`/`bullmq` yet).

- Progressive disclosure levels

  - Level 1 → 0.

  - Level 2 → 5 (all fixtures use `level: "2"`).

  - Level 3 → 0.

- Orphaned documents (with `scripts/test-docs` as root)

  - `Directories missing README.md hub pages` → 2 (`good/` and `violations/` have no `README.md`).


## Next Session: How to Continue

In the next chat/session, continue from this setup by:

1) Expanding `scripts/test-docs` fixtures

- Add small, focused `.md` files that exercise the remaining `verify-docs.sh` rules:

  - A fixture with `nav_order:` (and later multiple fixtures to simulate the "exactly 5" constraint).

  - Fixtures that include `/docs/... .md` links to trigger the `.md`-extension rule.

  - Fixtures with `prisma`, `bullmq`, and other tech stack violations, including negative cases that mention `drizzle` or `postgresql` to confirm the exclusion logic.

2) Align script behavior with `.kiro/tests` unit tests

- For each rule that already has a `.kiro/tests` fixture + `test_*.sh` script, ensure `scripts/verify-docs.sh` reports counts consistent with those rules when pointed at an equivalent `scripts/test-docs` subset.

3) Plan migration from `scripts/verify-docs.sh` to `.kiro/tests` coverage

- For any logic still only present in `scripts/verify-docs.sh` (e.g., orphaned README checks), design `.kiro/tests` fixtures and `test_*.sh` runners following the same pattern:

  - Basename-based expected sets.

  - Grep/find pipelines scoped to a fixtures directory.

  - PASS/FAIL output with non-zero exit on mismatch.

4) Only after all script-level fixtures pass

- Re-run `bash scripts/verify-docs.sh` (no arguments) against the real `docs/` tree.

- Use the result as a high-level report, then rely on the `.kiro/tests` suites for precise rule-by-rule validation and regression protection.


## After All Tests Pass

1) Run the validated commands across `docs/` to generate a real report.
2) Propose targeted, automated fixes (backup first), such as removing `.md` from site-absolute `/docs/...` links.
3) With approval, run Docker-based markdownlint:


```

docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest \
  markdownlint docs/ --config .markdownlint.json --quiet


```

4) Re-run tests to ensure no regressions.


## Acceptance Criteria


- Every test script passes (0 failures).


- Regexes match the intended fixture files and avoid false positives.


- Full-docs checks (after tests) align with our link policy and formatting rules.


- Optional markdownlint produces either zero issues or a clear, actionable list.