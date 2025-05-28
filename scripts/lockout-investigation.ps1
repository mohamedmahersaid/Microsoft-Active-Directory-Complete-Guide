<#
.SYNOPSIS
  Investigate recent account lockouts
#>

Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4740)]]" -MaxEvents 50 | 
Select-Object TimeCreated, @{Name="User";Expression={$_.Properties[0].Value}}, @{Name="Caller";Expression={$_.Properties[1].Value}} |
Export-Csv "C:\Reports\RecentLockouts.csv" -NoTypeInformation