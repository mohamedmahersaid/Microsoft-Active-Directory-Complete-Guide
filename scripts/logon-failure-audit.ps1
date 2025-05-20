<#
.SYNOPSIS
  List recent failed logon attempts
#>

Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4625)]]" -MaxEvents 100 |
Select-Object TimeCreated, @{Name="Account";Expression={$_.Properties[5].Value}}, @{Name="Workstation";Expression={$_.Properties[11].Value}} |
Export-Csv "C:\Reports\FailedLogons.csv" -NoTypeInformation