# Emergency Runbook — Active Directory (Expanded)

Purpose
A concise checklist to follow during Active Directory emergencies (DC compromise, major replication failure, SYSVOL corruption, or domain-wide authentication outage). This is an action checklist — follow exactly and escalate when required.

Before you start
- Confirm you are authorized to execute the emergency runbook.
- Record times, actions, and communications for post‑incident review.
- Prefer dry‑run testing in a lab; for production, require two-person verification for destructive actions.

Initial triage (first 15 minutes)
1. Identify scope and impact
   - Which DCs are affected? (Get-ADDomainController or repadmin)
   - Which services are impacted? (Authentication, DNS, GPO processing)
2. Isolate if compromise suspected
   - If a DC is suspected compromised, isolate from network to stop lateral propagation.
   - Preserve disk snapshot and forensic image if compromise is suspected.
3. Notify stakeholders and escalate
   - Notify AD team lead, security/IR team, backup vendor support, and executive on-call per escalation tree.

Immediate diagnostics (15–60 minutes)
- Collect key artifacts from impacted DC(s):
  - Event logs: Directory Service, DNS Server, System, DFS Replication/File Replication Service
  - repadmin /showrepl and repadmin /replsummary
  - Get-ADReplicationFailure
  - SYSVOL and NETLOGON share status
  - Running processes and open network connections
- Use scripts/runbooks/collect-ad-logs.ps1 or scripts/monitoring/collect-ad-logs.ps1 to gather artifacts

Containment & recovery decision (60–120 minutes)
- If the issue is configuration/replication-related and not a compromise:
  - Attempt non‑authoritative restore on affected DCs (docs/runbooks/disaster-recovery/non-authoritative-restore.md)
  - Validate replication converges
- If the DC is corrupted or you need to preserve restored data as source of truth:
  - Prepare for authoritative restore (docs/runbooks/disaster-recovery/authoritative-restore.md)
  - Ensure backups are valid and tested; inform stakeholders of replication overwrite impact
- If compromise confirmed:
  - Do not immediately rejoin DC to domain. Follow incident response (isolate/forensic image/rotate credentials) and involve security team.
  - Consider rebuilding DCs from known-good images and restoring state as appropriate.

FSMO role guidance
- If a FSMO role holder is down and you must restore functionality fast, consider transfer first. Only seize roles as a last resort.
  - Use Move-ADDirectoryServerOperationMasterRole for transfers when possible.
  - For seizures: document reason, seize using ntdsutil, and plan remediation.

Short-term mitigation steps
- Remove problematic replication partners temporarily if they are causing corruption.
- Disable site links or adjust replication schedule to avoid propagating corrupted data.
- Block logon to affected domain controllers (if required) via DNS or firewall rules while diagnosing.

Validation & Post-recovery
- Confirm replication healthy: repadmin /replsummary and Get-ADReplicationFailure
- Verify SYSVOL and GPO availability across domain
- Validate authentication and services (test user logon workflows, Exchange/SQL connectivity)
- Rotate service account passwords and emergency credentials if compromise suspected
- Create incident report and post-mortem including timeline, root cause, and remediation steps

Contacts & escalation list
- AD Team Lead: [name/contact]
- Backup vendor: [vendor/support contact]
- Security/IR: [team contact]
- Executive on-call: [contact]

Appendix — safe check commands
- repadmin /replsummary
- repadmin /showrepl
- Get-ADReplicationFailure
- Get-EventLog -LogName 'Directory Service' -Newest 100
- net share (verify SYSVOL/NETLOGON)