# Large Files Remediation Prompt

Use this prompt to drive a focused remediation project for docs files over 500 lines.

## Context

The repository currently fails `validation/detect/detect_content_quality_issues.sh docs` because many markdown files exceed 500 lines. Other core checks (markdown linting, frontmatter validation, tech stack compliance) can pass, so this work should target file length without regressing existing quality.

## Objective

Reduce all markdown files in `docs/` to 500 lines or fewer while preserving:

- content accuracy
- link integrity
- frontmatter correctness
- progressive disclosure structure
- existing navigation intent

## Mandatory Checks

Run these checks before, during, and after remediation:

1. `bash validation/detect/detect_content_quality_issues.sh docs`
2. `bash validation/detect/detect_frontmatter_issues.sh docs`
3. `bash validation/detect/detect_link_policy_violations.sh docs`
4. `bash validation/detect/detect_link_warnings.sh docs`
5. `bash validation/detect/detect_tech_stack_violations.sh docs`
6. `bash validation/detect/detect_navigation_violations.sh docs`
7. `docker run --rm -v $PWD:/md -w /md peterdavehello/markdownlint:latest markdownlint README.md CONTRIBUTING.md AGENTS.md docs/**/*.md index.md --config .markdownlint.json`

## Constraints

- Do not delete meaningful content.
- Prefer splitting over aggressive shortening.
- Keep long-file exceptions explicit and minimal in `validation/config/large_file_exceptions.txt`.
- Keep docs links site-absolute (`/docs/...`) and without `.md` extension.
- Preserve root-file link rules (`./CONTRIBUTING.md`, etc.) where required.
- Keep frontmatter present and valid in each resulting docs page.

## Required Discussion in Separate Chat: Exceptions Policy Deep Dive

Before broad remediation, run a dedicated planning chat focused only on long-file exceptions.

Topics that must be decided explicitly:

1. Purpose of exceptions

- What qualifies as a valid long-file exception (for example: canonical reference, generated schema map, operational runbook)?
- Which cases are not valid and must be split?

1. Governance model

- Who can add/remove entries in `validation/config/large_file_exceptions.txt`?
- What review/approval is required?
- What is the review cadence (for example monthly)?

1. Hard limits

- Maximum allowed exception count.
- Optional absolute max line cap even for exceptions (for example 1200).
- Whether exceptions expire unless re-approved.

1. Required metadata per exception

- Owning team/person.
- Justification note.
- Date added and next review date.
- Link to tracking issue.

1. Enforcement behavior

- Should CI fail if exception list grows beyond threshold?
- Should CI fail if an exception is missing metadata?
- Should CI warn when non-exception files exceed 500 lines by large margins?

1. Exit strategy

- For each exception, define a target split plan and milestone.
- Confirm whether exceptions are temporary vs permanent.

Deliverable from that separate chat:

- A finalized exceptions policy and maintenance workflow.
- A decision on whether to keep plain text list format or migrate to structured YAML/JSON with metadata.

## Brainstorm: Attack Plan Options

Consider and compare these strategies before implementation.

### Option A: Top-Down Domain Splitting

- Start with largest files first (for example >900 lines).
- Split by major H2 sections into child pages.
- Convert parent page into concise hub/overview linking to children.

Pros: Fast reduction in violation count, clear hierarchy.
Cons: Requires careful cross-link updates.

### Option B: Horizontal Pattern Splitting

- Split repeated section patterns across many files (examples, FAQ, implementation details, appendices).
- Standardize recurring child page names such as `overview`, `implementation`, `examples`, `faq`.

Pros: Reusable approach, consistent information architecture.
Cons: Requires global coordination across directories.

### Option C: Two-Pass Hybrid (Recommended)

- Pass 1: Split extreme files (>800 lines) to rapidly reduce risk.
- Pass 2: Normalize 501-800 line files with targeted section extraction.
- Pass 3: Editorial polish and link cleanup.

Pros: Balanced speed and quality control.
Cons: Requires strict tracking and batching discipline.

## Recommended Execution Plan

1. Inventory and Prioritize

- Generate sorted list of overlong files with line counts.
- Group by directory and size band (`>1000`, `801-1000`, `501-800`).
- Review `validation/config/large_file_exceptions.txt` and confirm each exception is still justified.

1. Define Split Templates

- Standard child-page templates:
  - `overview.md`
  - `implementation.md`
  - `operations.md`
  - `examples.md`
  - `reference.md`
- Define what content moves to each template.

1. Batch Remediation

- Work in small batches (5-10 files per batch).
- After each batch, run mandatory checks.
- Fix links and frontmatter immediately before moving to next batch.

1. Navigation and Cross-References

- Ensure each parent page links to all new child pages.
- Ensure child pages link back to parent hub when useful.
- Validate no orphaned pages and no broken internal links.

1. Stabilization

- Full check pass across all mandatory checks.
- Final review of readability and progressive disclosure.

## Progress Status (as of Feb 24, 2026)

- **Batches 1-6**: COMPLETED.
- **Files Modularized**: 14 major overlong files (including `lead-scoring.md`, `import-export/technical.md`, `email-infrastructure-setup.md`, etc.).
- **Remaining Overlong Files**: ~62 files still exceed the 500-line limit.

## Next Batch Inventory (Batch 7 Priority)

| Lines | File Path |
|-------|-----------|
| 741 | `docs/operations/analytics/team-performance/team-performance-operations-framework.md` |
| 741 | `docs/operations/analytics/operations-management/organization-analytics-team-management.md` |
| 739 | `docs/features/infrastructure/free-mailbox-creation/overview.md` |
| 737 | `docs/business/performance/performance-benchmarks.md` |
| 736 | `docs/business/customer-success/analytics/analytics-dashboard/predictive-analytics.md` |
| 735 | `docs/implementation-technical/architecture-system/architecture-overview.md` |
| 719 | `docs/business/marketing/cross-domain-integration/marketing-systems-integration-map.md` |
| 711 | `docs/compliance-security/international/technical-implementation.md` |
| 708 | `docs/design/routes/esp-integration.md` |
| 700 | `docs/business/strategy/overview.md` |

## Hand-off: Next Session Instructions

1. **Resume from Batch 7**: Start by modularizing the first 5 files in the table above.
2. **Strategy**: Continue using the "Hub and Spoke" model (rewriting the parent as a hub and extracting detailed sections to a sub-directory).
3. **Link Policy**: Ensure all new links are site-absolute (`/docs/...`) and avoid `.md` extensions for internal links.
4. **Verification**: Run `detect_content_quality_issues.sh` after each batch to confirm zero violations and no frontmatter regressions.

---

## Suggested Command Snippets

Find overlong files quickly:

```bash
find docs -name "*.md" -exec wc -l {} + | awk '$1 > 500 && $2 != "total" {print $1 "\t" $2}' | sort -nr
```

Count remaining overlong files:

```bash
find docs -name "*.md" -exec wc -l {} + | awk '$1 > 500 && $2 != "total" {c++} END {print c+0}'
```

## Definition of Done

- `detect_content_quality_issues.sh` reports zero overlong files.
- All other mandatory checks pass.
- New file structure is coherent and navigable.
- No placeholder or broken links introduced.
- No frontmatter regressions introduced.
