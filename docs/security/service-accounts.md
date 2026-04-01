# Service Accounts, gMSA, and Managed Identity Guidance

Overview
This document describes recommended patterns for service accounts in Active Directory: group Managed Service Accounts (gMSA), managed identities for cloud resources, and best practices for replacing static service accounts.

Why gMSA / managed identities
- gMSA: provide automatic password management for services running on domain-joined computers; suitable for on-prem Windows services and clustered workloads.
- Managed identities (Azure): avoid managing credentials entirely for cloud resources; prefer when running automation from Azure (Functions, VMs, Automation Accounts).
- Both reduce credential exposure, rotation burden, and operational risk.

gMSA quick-start (high-level)
1. Ensure KDS root key exists (one-time, on a DC):
   - Add-KdsRootKey -EffectiveImmediately
   - Note: in production consider time-offset to avoid replication/timing issues.
2. Create a gMSA in AD:
   - New-ADServiceAccount -Name 'svc_gmsa_app' -DNSHostName 'domain.local' -PrincipalsAllowedToRetrieveManagedPassword 'CN=WebServers,OU=ServiceAccounts,DC=domain,DC=local'
3. Install & test on host:
   - Install-ADServiceAccount -Identity svc_gmsa_app
   - Test-ADServiceAccount -Identity svc_gmsa_app
4. Configure the service (Windows Service, IIS App Pool, SQL service) to run as the gMSA using the account name in the form: domain\svc_gmsa_app$ (no password entry required).

Managed Identity (Azure) usage
- Prefer system-assigned or user-assigned managed identities for Azure-hosted automation.
- Configure roles with least privilege for managed identities; grant Key Vault GET/list only as required.
- Use Azure AD tokens (Az CLI / Az PowerShell / SDK) instead of static secrets.

Rotation & lifecycle
- gMSA passwords are rotated automatically by the KDS; for non-gMSA service accounts enforce scheduled rotation policies.
- For service accounts that cannot be replaced immediately, implement forced rotation and monitoring.
- Deprovisioning: follow documented process to remove account from ACLs, services, and disable before deletion.

Least privilege & delegation
- Use constrained principals allowed to retrieve gMSA password rather than broad groups.
- Use JEA endpoints (see docs/hardening/jea.md) for admins that need to run AD tasks without granting full domain admin rights.

Storing service credentials and secrets
- Do NOT store secrets in the repo.
- Use Azure Key Vault, HashiCorp Vault, or an on-prem vault for any required secrets.
- For CI/automation, use OIDC or short-lived tokens rather than long-lived application secrets.

Fallbacks & legacy accounts
- Document all legacy privileged accounts and create a migration plan to gMSA or managed identities.
- Use LAPS for local administrator passwords on workstations/servers where appropriate.

Audit & monitoring
- Monitor use of service accounts and unusual authentication patterns (failed logons, logons from unexpected hosts).
- Keep an inventory of service accounts, ACL usage, and required delegation.