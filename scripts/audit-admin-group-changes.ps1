<#
.SYNOPSIS
  Monitor admin group membership changes
#>

$events = Get-WinEvent -LogName Security -FilterXPath "*[System[(EventID=4728 or EventID=4729 or EventID=4732 or EventID=4733 or EventID=4756 or EventID=4757)]]" -MaxEvents 50

$events | Select-Object TimeCreated, @{Name="Group";Expression={$_.Properties[0].Value}}, @{Name="User";Expression={$_.Properties[1].Value}}, @{Name="ChangedBy";Expression={$_.Properties[5].Value}} |
Export-Csv "C:\Reports\AdminGroupChanges.csv" -NoTypeInformation