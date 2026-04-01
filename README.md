# Microsoft Active Directory — Complete Guide

A complete, production-grade Active Directory guide including architecture diagrams, PowerShell scripts, automation, security hardening, disaster recovery, hybrid Azure AD integration, and troubleshooting resources for enterprise environments.

IMPORTANT: Read SECURITY.md before running any scripts against production systems.

Quickstart
1. Test scripts in a disposable lab environment first (see docs/runbooks/lab-playbook.md).
2. Install prerequisites: PowerShell 7.x (recommended) or Windows PowerShell 5.1 where required. Install RSAT/ActiveDirectory modules on hosts that must manage AD.
3. Use -WhatIf/-Confirm and dry-run options before destructive changes. Prefer Managed Identity or secure secrets (Azure Key Vault / GitHub Secrets) for credentials.

Repository layout
- /docs/             — architecture, hardening, DR, runbooks, diagrams
- /scripts/          — PowerShell modules and runbooks
- /tests/            — Pester unit and integration tests
- /.github/          — CI workflows, issue/PR templates, community files

Contributing
See CONTRIBUTING.md for contribution process, testing expectations, and code style.

License
This project is licensed under the MIT License — see LICENSE.

Maintainers
- @mohamedmahersaid