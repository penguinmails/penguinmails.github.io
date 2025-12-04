# Content Quality Maintenance Agent

## Mission
- Continuously reduce Markdown file overages flagged by `validation/detect/detect_content_quality_issues.sh`
- Maintain progressive disclosure structure while preserving business context

## Inputs
- Latest report in `validation/reports/` (JSON format)
- Source Markdown under `docs/` and `tasks/` referenced in the report
- Repository standards in [`AGENTS.md`](../../AGENTS.md) and [`CONTRIBUTING.md`](../../CONTRIBUTING.md)

## Tooling
- Windows PowerShell host with Git Bash for script execution
- Command to regenerate the report:
  ```powershell
  & "C:\Program Files\Git\bin\bash.exe" validation/detect/detect_content_quality_issues.sh --report docs
  ```
- Markdown linting via Docker workflow (see [`MARKDOWN_LINTING.md`](../../MARKDOWN_LINTING.md))

## Operational Loop
1. Regenerate the content-quality report and capture the timestamped JSON output path.
2. Parse the JSON, sorting targets by line count overage; maintain a local backlog of unresolved files.
3. For the top target:
   - Inspect structure and determine natural sub-topics for modularization.
   - Create a hub document plus child pages under an appropriate subdirectory (reuse existing structure when possible).
   - Move `keywords` into frontmatter; ensure Jekyll metadata (`title`, `description`, `last_modified_date`, `level`, `persona`).
   - Update internal links to use `/docs/...` form for docs pages and relative links for root files.
4. Rerun the detector; confirm the modified file no longer breaches limits and capture the new JSON report.
5. Commit focused changes with a message referencing the resolved file and report timestamp.
6. Iterate until backlog exhausted or session time capped; resume using latest JSON on next run.

## Quality Gates
- No broken links; run link-warning checker once a batch of splits completes.
- All new files must stay under the 200-300 line target and respect ASCII preference.
- Preserve business value and narrative context while extracting content.

## Escalation Criteria
- Detector script fails: document error, attempt rerun, escalate after two failures.
- Structural ambiguity: log open questions in `tasks/TASK_UPDATES.md` before proceeding.
- Conflicting edits detected in Git: pause and request human guidance.

## Logging Expectations
- Append session notes (timestamp, files touched, remaining backlog) to `validation/README.md`.
- Record newly generated reports in `validation/reports/` with brief summary of deltas.
