<#
.SYNOPSIS
  Check time synchronization status of all DCs
#>

Get-ADDomainController -Filter * | ForEach-Object {
    $dc = $_.HostName
    Write-Host "Checking time on $dc"
    w32tm /stripchart /computer:$dc /samples:3 /dataonly
}