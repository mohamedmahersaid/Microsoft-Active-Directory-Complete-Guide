<#
.SYNOPSIS
  Identify GPOs not linked to any OU
#>

Get-GPO -All | Where-Object { -not ($_ | Get-GPOLink) } |
Select-Object DisplayName, Id |
Export-Csv "C:\Reports\UnlinkedGPOs.csv" -NoTypeInformation