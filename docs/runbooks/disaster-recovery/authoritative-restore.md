# Authoritative Restore — Active Directory

This document describes a step-by-step authoritative restore procedure for Active Directory Domain Services. Use only in cases where a restored DC's directory partition must be authoritative (i.e., when data loss or corruption occurred and you must overwrite replication partners).

Prerequisites and warnings
- Perform these procedures in a maintenance window.
- Ensure you have a valid, tested backup of the System State for the target DC.
- Understand difference between authoritative and non-authoritative restore. Authoritative restore overwrites replication partners.
- Always test in a lab first.

Steps (high-level)
1. Boot the Domain Controller into Directory Services Restore Mode (DSRM)
   - Reboot and press F8 (or use msconfig /bcdedit to enable safe mode) and choose "Directory Services Restore Mode".
2. Log in with the DSRM password.
3. Stop AD-related services (if needed) or follow vendor backup restore tooling.
4. Restore System State from backup (Windows Server Backup or your backup software)
   - Example with Windows Server Backup: wbadmin start systemstaterestore -version:<VersionIdentifier> -backupTarget:<BackupLocation>
5. After successful system state restore, mark objects or partitions authoritative using ntdsutil:
   - Open an elevated command prompt and run: ntdsutil
   - Activate instance NTDS
   - Authoritative restore
   - Restore subtree <distinguishedName> (or use "restore database" for full)
   - If restoring entire domain partition, use "restore database" followed by authoritative commands as needed
6. Reboot the DC into normal mode.
7. Allow replication and monitor for expected converged state (use Get-ADReplicationFailure, repadmin /showrepl)

Post-restore checks
- Verify SYSVOL and NETLOGON shares are present and that GPOs are accessible.
- Check Event Viewer for Directory Service, File Replication Service / DFS Replication events.
- Validate replication using: repadmin /replsummary and Get-ADReplicationFailure.

Rollback and mitigation
- If authoritative restore had unintended impact, follow documented rollback steps (restore AD from a better backup or restore other DCs as authoritative in correct order). Contact vendor support for complex recovery.

References
- Microsoft Docs: Active Directory Domain Services restore procedures.