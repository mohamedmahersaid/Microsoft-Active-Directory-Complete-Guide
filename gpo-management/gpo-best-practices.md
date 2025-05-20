# Group Policy Best Practices

## Key Guidelines
- Use clear naming: `GPO_Workstation_Baseline`
- Avoid mixing user and computer settings
- Link GPOs to OUs, not domains
- Use WMI filtering only when necessary
- Backup regularly

## Audit:
```powershell
gpresult /h report.html
Get-GPO -All | Sort DisplayName
```