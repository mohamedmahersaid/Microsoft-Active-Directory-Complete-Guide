# PowerShell GPO Management Script
Import-Module GroupPolicy
New-GPO -Name "GPO_Workstation_Baseline"
New-GPLink -Name "GPO_Workstation_Baseline" -Target "OU=Workstations,DC=corp,DC=local"