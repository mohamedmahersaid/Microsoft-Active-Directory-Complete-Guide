# Lab Playbook

Use this to build a disposable test lab (Hyper-V / Azure / VMware) to validate scripts and runbooks.

Minimum topology:
- 2 Domain Controllers (DC1, DC2)
- 1 Read-only Domain Controller (optional)
- 1 management workstation with RSAT/AD tools
- Test clients as needed

Provisioning options:
- Use Bicep/ARM/Terraform in Azure (example templates can be added under /iac/)
- Use local Hyper-V with evaluation ISOs

Test checklist:
- Replication health
- Backup & authoritative restore test
- Schema extension dry-run in lab
- Script runbooks in -WhatIf mode