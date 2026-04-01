# Running Integration Tests in CI

Guidance for running integration Pester tests in CI:
- These tests require a lab environment with accessible DCs or a provisioned temporary lab.
- Recommended CI pattern:
  - Job A: Provision lab using IaC (Bicep/Terraform) in a disposable subscription/resource group.
  - Job B: Run integration Pester tests (tests/integration/*.ps1).
  - Job C: Collect artifacts and tear down lab.
- Use AZURE_CREDENTIALS or OIDC to allow the runner to create and manage lab resources.
- Ensure tests run under an account with permissions to query AD (not necessarily Domain Admin).