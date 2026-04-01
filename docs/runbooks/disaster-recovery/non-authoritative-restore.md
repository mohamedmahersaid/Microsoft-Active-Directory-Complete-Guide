# Non‑Authoritative Restore — Active Directory

Use a non‑authoritative restore when a Domain Controller (DC) has failed or been rebuilt but the directory data on other DCs is authoritative and should overwrite the restored DC during replication.

Important notes
- Non‑authoritative restores are the safe default for bringing a repaired DC back online so it receives replicated updates from partners.
- Always test restores in a lab before applying to production.
- Ensure you have a valid System State backup for the target DC.

Prerequisites
- Valid System State backup for the DC being restored.
- Administrative credentials and DSRM password.
- Maintenance window and communications to stakeholders.

High‑level steps
1. Boot the DC into Directory Services Restore Mode (DSRM)
   - Use F8 during boot or bcdedit to enter DSRM. Log in with the DSRM account/password.

2. Restore the System State
   - Use Windows Server Backup, the vendor backup agent, or wbadmin:
     wbadmin start systemstaterestore -version:<VersionIdentifier> -backupTarget:<BackupLocation>
   - Follow vendor instructions for restore; ensure restore completes without errors.

3. Restart the DC into normal mode
   - Reboot the server out of DSRM into normal boot so AD DS starts.

4. Allow replication to converge
   - Once the DC is online, it will request updates from replication partners; monitor replication.

Verification and checks
- Run repadmin /replsummary and repadmin /showrepl to ensure inbound replication is successful.
- Run Get-ADReplicationFailure (PowerShell) and check for zero critical failures.
- Verify SYSVOL and NETLOGON shares are present and that GPOs are readable.
- Validate client authentication against the restored DC (test logons, Kerberos issuance).

Common issues and troubleshooting
- Missing SYSVOL: check DFSR/FRS state and event logs (File Replication Service or DFS Replication).
- Replication errors: check network/DNS, credentials for AD replication, and replication topology.
- Time skew: ensure correct time synchronization (w32time) before performing operations.

When NOT to use non‑authoritative restore
- When you must preserve the restored DC's AD data and overwrite other DCs (then use authoritative restore).
- If you intend to use a restored copy as the single source of truth for recovery — follow the authoritative restore procedure.

References
- Microsoft documentation: AD DS restore procedures and repadmin guidance.