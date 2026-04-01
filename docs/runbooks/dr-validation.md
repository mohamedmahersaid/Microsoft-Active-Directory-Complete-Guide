# Disaster Recovery Validation — Active Directory

Purpose
Procedures and acceptance criteria to validate AD backups and DR processes. Regular validation ensures that backups can be restored and that runbooks are accurate.

Validation cadence
- Quarterly: Full validation in a disposable lab environment.
- Monthly: Smoke validation of backups and replication replication health.
- After major changes: Run validation after schema changes, DC builds, or backup solution upgrades.

Validation tests and acceptance criteria

1. Backup integrity test (monthly)
- Test: Verify backup catalogs and that latest System State backup exists for all DCs.
- Acceptance: Backup job completed successfully in last 24–72 hours and catalog entries are valid.

2. Non‑authoritative restore smoke (monthly / quarterly in lab)
- Test: Restore a single DC System State into a lab VM and perform non‑authoritative restore.
- Acceptance: Restored DC boots in normal mode and replication converges within a defined window (e.g., 30 minutes).

3. Authoritative restore dry-run (quarterly in lab)
- Test: Simulate authoritative restore on lab domain (ensure you are not running these on production).
- Acceptance: Authoritative restore completes and replication behaves as documented.

4. SYSVOL & GPO validation (monthly)
- Test: Export and import sample GPOs, verify SYSVOL content for discrepancies.
- Acceptance: GPOs readable on all DCs and no SYSVOL replication errors.

5. Full DR test (annual)
- Test: Restore part of the domain (or entire domain in isolated lab) to validate end-to-end procedures.
- Acceptance: Services (authentication, DNS, GPO application) are restored in acceptable RTO for the test scope.

Validation evidence & reporting
- For each test, record:
  - Date/time, test operator, environment (lab/production)
  - Steps executed and results
  - Logs and artifacts (collected zip)
  - Post-test verdict (pass/fail) and remediation if failed

Automation & repeatability
- Use scripts/dr/dr-validate.ps1 to collect pre/post-validation telemetry.
- Use IaC (iac/) to spin up disposable environments for validation and tear them down automatically.

Runbook update triggers
- After any DR test, update runbooks if:
  - Steps changed or timing differs from expectation
  - New failure modes observed
  - New vendor changes require updated procedures