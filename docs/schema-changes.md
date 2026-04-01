# AD Schema Change Management — Process, Checks, and Rollback

Purpose
Schema changes are irreversible and can have forest-wide impact. This document defines a controlled process for proposing, testing, and applying schema changes in Active Directory, including rollback and validation steps.

Key principles
- Never apply schema changes directly in production without prior testing and approvals.
- Keep schema changes minimal and documented (reason, attributes added, extensions).
- Maintain a dedicated schema change board or approval workflow for any schema modification.

Pre-change checklist
- Produce a Change Request with: purpose, exact LDIF/command, expected impact, required downtime, rollback plan, test plan.
- Create a lab environment that mirrors production (or use a disposable environment via IaC).
- Export current schema and backup:
  - Use ntdsutil or LDIFDE: ldifde -f schema-backup.ldf -d CN=Schema,CN=Configuration,DC=...
- Confirm schema master FSMO reachability and that replication is healthy.

Testing
- Apply the schema change in lab and validate:
  - New attribute/class appears in schema
  - Replication behaves correctly
  - No unexpected SB (schema partition) replication errors
- Run tests including:
  - Application-level tests that depend on extension attributes
  - Replication health checks and monitoring ingest

Change window and execution
- Schedule maintenance window with stakeholder notification.
- On schema master (or process owner), apply change using supported tool (schmmgmt.msc, LDIFDE, or vendor installer).
- Monitor schema master events and replication.

Rollback and recovery
- True rollback is not always possible; plan for reversion strategies (remove references/attributes at application layer or migrate to new schema object).
- If change causes critical problems:
  - Isolate affected DCs
  - Restore from pre-change backup in an isolated lab and analyze fix approach
  - Engage Microsoft support for complex recovery

Validation after change
- Confirm schema object presence:
  - Use Get-ADObject -SearchBase (SchemaNamingContext) -Filter { name -like '*' } -Properties *
- Confirm replication across all DCs (repadmin /showrepl and Get-ADReplicationFailure).
- Run application functional tests.

Documentation and auditing
- Record change steps, operator, timestamp, results, and artifacts in change log.
- Store exported configuration and any LDIF files securely (Key Vault or secure file share).