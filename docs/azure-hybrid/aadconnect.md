# Azure AD Connect — Guidance, Staging, Filtering, and Recovery

Purpose
This document outlines recommended architecture and operational practices for Azure AD Connect (AAD Connect) in hybrid identity environments. It includes staging-mode usage, filtering, upgrade/rollback guidance, and health monitoring.

Architecture and deployment patterns
- Use at least one active AAD Connect server and one server in Staging Mode for high availability.
- Staging Mode: deploy a separate server configured identically but not actively exporting to Azure AD. Use it to validate upgrades or configuration changes.
- Use an express installation only for simple lab environments; prefer custom install for production (sync rules, OU filtering, SQL options).

Filtering and scoping
- Choose filtering method appropriate for scale:
  - OU-based filtering: easiest to manage when you have tidy OU layout.
  - Attribute-based filtering: flexible for complex environments (e.g., extensionAttribute).
  - Domain/forest filtering: limited usage when managing multiple forests.
- Always validate filters in Staging Mode before applying to the active server.

Staging, change validation, and cutover
1. Configure change on the Staging server first.
2. Run a full import and sync in Staging; review connector logs and preview exports.
3. When validated, switch staging to active:
   - Disable sync on active server, enable on staging, or use Microsoft guidance for failover.
4. Keep both servers updated and patched; regular test failovers are recommended.

Sync rules and transforms
- Document each custom sync rule (naming, precedence, transform logic).
- Avoid overly complex transformations; document use-cases and rollback steps.
- Use connector space views and PowerShell (ADSync module) to preview rule evaluation.

Upgrades and rollback
- Upgrade Staging server first and validate; then upgrade the production appliance.
- For rollback: restore AAD Connect configuration from exported configuration or roll back to the previous Staging server which you validated pre-upgrade.
- Keep exported configuration backups: Export-ADSyncServerConfiguration and store securely.

Health and monitoring
- Monitor these health signals:
  - Sync cycle success/failure
  - Connector errors (adds, updates, deletes)
  - Password sync errors
  - Service account authentication failures
- Use Azure AD Connect Health agent and review alerts in Azure Portal or via API.
- Schedule a job to run scripts/integration/aadconnect-verify.ps1 to produce a daily health summary.

Incident response and recovery
- If sync causes mass deletes in Azure AD, disable export on the AAD Connect server immediately and engage rollback plan.
- If connector config is corrupted, restore from a recent exported configuration or switch to the validated Staging instance.
- For schema/attribute issues: pause sync, identify offending rules, fix and validate in Staging, then resume.

Security considerations
- Service account: use least-privilege account for the AD Connector (delegation limited to required OUs and attributes).
- Protect AAD Connect server credentials and exported configuration files. Store exports securely (Key Vault).
- Keep AAD Connect patched and limit RDP/management access to a secured jump host.

References
- Microsoft Docs: Azure AD Connect sync and staging mode guidance.