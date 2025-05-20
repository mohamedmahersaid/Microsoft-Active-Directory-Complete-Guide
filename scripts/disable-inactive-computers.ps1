<#
.SYNOPSIS
  Disable AD computer accounts inactive for 90+ days
#>

Search-ADAccount -AccountInactive -ComputersOnly -TimeSpan 90.00:00:00 | 
Disable-ADAccount