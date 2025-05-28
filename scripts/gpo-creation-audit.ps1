<#
.SYNOPSIS
  Audit recent GPO creation or changes
#>

Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4739)]]" -MaxEvents 20 |
Select-Object TimeCreated, @{Name="GPO Changed";Expression={$_.Properties[0].Value}}, @{Name="ChangedBy";Expression={$_.Properties[1].Value}} |
Export-Csv "C:\Reports\GPOChanges.csv" -NoTypeInformation