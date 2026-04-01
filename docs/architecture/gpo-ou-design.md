# GPO and OU Design Guidance

Purpose
This document provides recommended OU (Organizational Unit) layout, GPO naming conventions, delegation patterns, and operational guidance to safely manage Group Policy at scale.

Design principles
- Keep delegation predictable: separate administrative boundaries (service accounts, admins, helpdesk) from objects managed by automated systems.
- Use least privilege and RBAC: delegate only what is necessary at the OU level.
- Prefer split of concerns: separate computer and user OUs, and separate production, pre-prod, and lab environments.

Recommended OU layout (example)
- OU=Corp (root for company)
  - OU=ServiceAccounts
  - OU=Workstations
    - OU=Windows10
    - OU=Windows2016 (legacy)
  - OU=Servers
    - OU=DomainControllers
    - OU=Database
  - OU=Users
    - OU=Admins
    - OU=StandardUsers
  - OU=ServicePrincipals
  - OU=Computers (workloads)

GPO naming convention
- Use a clear, searchable prefix and description:
  - [Scope]-[Category]-[ShortDescription]-[Version]
  - Examples:
    - DC-SEC-Hardening-v1.0
    - CLT-Win10-Baseline-v2.1
    - SRV-SQL-Performance-v1.0

Delegation matrix (template)
- Maintain a CSV or document tracking:
  - OU, Role, AllowedTasks (create/delete objects, modify GPO link, apply GPO), Review cadence
- Example row:
  - OU=DomainControllers, Role=DC Admins, AllowedTasks=Manage DC servers, FullControl, Review=Quarterly

GPO lifecycle and backups
- Use central store for ADMX files (SYSVOL\\Policies\\PolicyDefinitions).
- Backup GPOs regularly:
  - Use Backup-GPO and store backups outside SYSVOL (regularly push to secure file share or storage account).
- Test GPO changes in a lab OU before production deployment.

Apply/Linking strategy
- Link GPOs at the most specific OU possible and use Security Filtering/GPO WMI filtering sparingly.
- Avoid linking a large number of GPOs at the domain root; prefer logical OU-level linking.

Operational practices
- Require Change Request for GPO changes and document the expected impact.
- Use descriptive comments on GPOs to include author, purpose, and rollback steps.
- Use a staged rollout: link to test OU, validate, then link to production OU.

Troubleshooting and validation
- Use Group Policy Results (gpresult /h report.html) and Get-GPResultantSetOfPolicy for scriptable checks.
- Monitor SYSVOL/DFS replication for GPO-related replication errors.

Automation examples
- Export a GPO: Backup-GPO -Guid <GUID> -Path "\\fileshare\gpo-backups\"
- Restore GPO: Restore-GPO -Path "\\fileshare\gpo-backups\<backup>" -TargetName "GPO-Name"

References
- Microsoft Group Policy documentation and best practices.