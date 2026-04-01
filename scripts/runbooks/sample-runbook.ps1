<#
.SYNOPSIS
  Example runbook that performs a non-destructive check on a DC.
#>
[CmdletBinding(SupportsShouldProcess=$true)]
param(
  [Parameter(Mandatory)]
  [string] $TargetDC
)

if ($PSCmdlet.ShouldProcess("Check health for $TargetDC")) {
  Import-Module ../modules/NetADHelpers/NetADHelpers.psm1 -Force
  $result = Get-ADDomainControllerHealth -ServerName $TargetDC
  $result | Format-List
}