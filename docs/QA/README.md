Quality Assurance guide for repository maintainers

Purpose
This document describes QA tasks to validate contributions, test runbooks, and verify CI before merging.

Pre-merge QA
- Confirm linting: PSScriptAnalyzer passes or fixes are documented.
- Unit tests: Pester unit tests exist for new functions and pass locally.
- Integration tests: smoke-run in disposable lab; capture artifacts and attach to PR.

Runbook validation
- Any change to runbooks must be validated in the lab: run the steps end-to-end and capture evidence using scripts/dr/dr-validate.ps1.

Acceptance criteria for PRs touching scripts/runbooks or scripts/modules
- [ ] PSScriptAnalyzer issues addressed or justified
- [ ] Pester unit tests added/updated
- [ ] Integration smoke test added if behavior affects infrastructure
- [ ] Documentation updated (docs/README.md referenced)

Release QA
- Ensure CHANGELOG updated and release notes generated using scripts/release/release-notes-generator.ps1
- Ensure signing workflow has been exercised on artifacts in a test run prior to production signing