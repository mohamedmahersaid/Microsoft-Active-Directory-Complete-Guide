<#
.SYNOPSIS
  Find all currently locked user accounts
#>

Search-ADAccount -LockedOut | 
Select-Object Name, SamAccountName, LockedOut, LastLogonDate |
Export-Csv "C:\Reports\LockedAccounts.csv" -NoTypeInformation