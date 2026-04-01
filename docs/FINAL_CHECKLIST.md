Final repository and operational checklist before merging feature/larger-tasks to main

Repository settings
- [ ] Enable branch protection on main: require PR review and require status checks
- [ ] Set required checks: CI (PSScriptAnalyzer + Pester), PSRule (optional), CodeQL
- [ ] Enable Dependabot alerts and automatic security updates
- [ ] Enable secret scanning and code scanning (CodeQL) in Security settings

Secrets to add (Repository > Settings > Secrets > Actions)
- [ ] PSGALLERY_API_KEY
- [ ] AZURE_CREDENTIALS (or configure OIDC trust)
- [ ] Optional: KEYVAULT_SIGNING_PRINCIPAL or signing credential provisioning

CI & release
- [ ] Confirm CI runners can access ADSync/AD modules for integration jobs or gate integration tests to self-hosted runners
- [ ] Confirm PSGallery publish permissions are limited and audited
- [ ] Validate signing workflow with test artifacts in a secure test environment

Operational readiness
- [ ] Run full DR validation in a lab and record outputs (scripts/dr/dr-validate.ps1)
- [ ] Run integration Pester tests in a disposable lab (docs/tests/integration-ci.md)
- [ ] Validate monitoring detection tuning in Log Analytics / Sentinel and mark false positives

Documentation & governance
- [ ] Fill MAINTAINERS with actual contacts
- [ ] Populate runbook contact details and escalation phone numbers
- [ ] Confirm LICENSE and COPYRIGHT text are correct

After merge
- Tag a v0.1.0 release for the initial stable baseline.
- Publish modules to PowerShell Gallery using PSGALLERY_API_KEY in a protected run.