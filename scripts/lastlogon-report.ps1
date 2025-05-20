<#
.SYNOPSIS
  Generate report of last logon times for all users
#>

Get-ADUser -Filter * -Properties LastLogonDate | 
Select-Object Name, SamAccountName, Enabled, LastLogonDate |
Export-Csv "C:\Reports\ADUserLastLogon.csv" -NoTypeInformation