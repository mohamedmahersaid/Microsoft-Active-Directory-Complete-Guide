# Integration Tests — Guide

Purpose
This document explains how to run integration smoke tests for Active Directory in a disposable lab or test subscription.

Preconditions
- Test environment with at least 2 DCs and a management host with RSAT/AD modules.
- If running tests in Azure, ensure AZURE_CREDENTIALS or OIDC is configured for runners to deploy or manage resources.
- Tests are intended to be non-destructive; review each script before running in production.

How to run
- From a management host:
  pwsh .\tests\integration\sample-smoke.ps1 -Targets DC1,DC2

- As part of CI:
  - Provision lab via IaC (iac/), run sample-smoke.ps1, gather output artifacts, then tear down resources.

Artifacts
- Tests produce JSON/text evidence files which should be uploaded as CI artifacts for troubleshooting and audit.

Extending tests
- Add Pester tests to tests/integration/ to define pass/fail criteria and allow CI gating.