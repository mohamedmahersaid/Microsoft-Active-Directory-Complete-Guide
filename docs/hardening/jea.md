# Just Enough Administration (JEA) — Patterns and Examples

Why JEA
JEA reduces risks by giving operators specific capability endpoints that expose only the required cmdlets and functions — avoiding the need to grant broad administrative privileges.

High-level workflow
1. Identify common operational tasks (DR operations, replication diagnostics, GPO export, account unlock).
2. Create a role capability file listing allowed cmdlets and modules.
3. Create a session configuration file that references one or more role capability files.
4. Register the JEA endpoint on management hosts and restrict who can connect.

Example role capability file (MyJeaRole.psrc)
- AllowedCmdlets: Get-ADUser, Unlock-ADAccount, Get-ADDomainController, Get-ADReplicationFailure
- VisibleFunctions: Export-ADGpoReport

Example session configuration (MyJeaEndpoint.pssc)
- VisibleCmdlets: none (control via role capability)
- RoleDefinitions:
  - CONTOSO\ADOperators: @{ RoleCapabilityFiles = @('C:\\Program Files\\WindowsPowerShell\\Modules\\JEARoles\\MyJeaRole.psrc') }

Create and register endpoint (example)
- New-PSSessionConfigurationFile -Path .\MyJeaEndpoint.pssc -VisibleFunctions 'Out-GridView'
- Register-PSSessionConfiguration -Name MyJeaEndpoint -Path .\MyJeaEndpoint.pssc -Force

Consumption
- Administrators connect with:
  - Enter-PSSession -ComputerName dc01 -ConfigurationName MyJeaEndpoint -Credential (Get-Credential)
- Operations run under constrained capabilities defined in the role file.

Best practices
- Keep role capability files minimal — only required cmdlets and parameters.
- Audit commands run through JEA by enabling transcript logging for endpoints.
- Combine with Privileged Access workflows (PAM/PIM) to provide just-in-time elevation.
- Document expected outputs and error handling for each JEA operation to aid troubleshooting.