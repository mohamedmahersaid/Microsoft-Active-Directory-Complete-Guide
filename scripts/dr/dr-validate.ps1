<#
dr-validate.ps1
Lightweight disaster-recovery validation collector for Active Directory environments.
This script collects replication, SYSVOL, service, and event log information from one or more target DCs and packages them into a ZIP for evidence.

Usage:
  .\dr-validate.ps1 -Targets DC1,DC2 -OutputFolder .\dr-evidence

Notes:
- This script is read-only and non-destructive.
- Run from a management host with RSAT/ActiveDirectory module or on the DC directly.
#>

param(
  [Parameter(Mandatory=$false)]
  [string[]] $Targets = @('localhost'),
  [Parameter(Mandatory=$false)]
  [string] $OutputFolder = ".\dr-evidence"
)

function Ensure-Module {
  param($Name)
  if (-not (Get-Module -ListAvailable -Name $Name)) {
    Write-Host "Module $Name not found; attempting to import/notify"
    try {
      Import-Module $Name -ErrorAction Stop
    } catch {
      Write-Warning "Required module $Name not available. Some commands may fail."
    }
  }
}

Ensure-Module -Name ActiveDirectory

$timestamp = (Get-Date).ToString('yyyyMMddHHmmss')
$base = Join-Path -Path $OutputFolder -ChildPath $timestamp
New-Item -ItemType Directory -Path $base -Force | Out-Null

foreach ($t in $Targets) {
  $hostFolder = Join-Path $base $t
  New-Item -ItemType Directory -Path $hostFolder -Force | Out-Null

  Write-Host "Collecting replication summary for $t"
  try {
    $replSummary = & repadmin /replsummary 2>&1
    $replSummary | Out-File -FilePath (Join-Path $hostFolder 'repadmin-replsummary.txt') -Encoding utf8
  } catch {
    Write-Warning "repadmin failed for $t: $_"
  }

  Write-Host "Collecting showrepl for $t"
  try {
    $showRepl = & repadmin /showrepl $t 2>&1
    $showRepl | Out-File -FilePath (Join-Path $hostFolder 'repadmin-showrepl.txt') -Encoding utf8
  } catch {
    Write-Warning "repadmin showrepl failed for $t: $_"
  }

  Write-Host "Collecting AD replication failures (Get-ADReplicationFailure)"
  try {
    $failures = Get-ADReplicationFailure -Scope Server -Target $t -ErrorAction Stop
    $failures | Out-File -FilePath (Join-Path $hostFolder 'replication-failures.txt') -Encoding utf8
  } catch {
    Write-Warning "Get-ADReplicationFailure failed for $t: $_"
  }

  Write-Host "Checking SYSVOL and NETLOGON share"
  try {
    $shares = Get-WmiObject -Class Win32_Share -ComputerName $t -ErrorAction Stop
    $shares | Where-Object Name -in 'SYSVOL','NETLOGON' | Out-File -FilePath (Join-Path $hostFolder 'shares.txt') -Encoding utf8
  } catch {
    Write-Warning "Could not query shares on $t: $_"
  }

  Write-Host "Exporting relevant event logs (Directory Service, System, DFS Replication/Dfsr)"
  $events = @(
    @{Log='Directory Service'; File='DirectoryService.evtx'},
    @{Log='System'; File='System.evtx'},
    @{Log='DFS Replication'; File='DFSReplication.evtx'},
    @{Log='File Replication Service'; File='FileReplicationService.evtx'}
  )

  foreach ($ev in $events) {
    $outFile = Join-Path $hostFolder $ev.File
    try {
      wevtutil epl "$($ev.Log)" $outFile /ow:true
    } catch {
      Write-Warning "Failed to export $($ev.Log) from $t: $_"
    }
  }

  Write-Host "Collecting AD service status and systeminfo"
  try {
    $services = Get-Service -ComputerName $t -ErrorAction Stop | Where-Object Name -match 'NTDS|KDC|DFS'
    $services | Out-File -FilePath (Join-Path $hostFolder 'services.txt') -Encoding utf8
  } catch {
    Write-Warning "Service query failed for $t: $_"
  }

  try {
    $sys = systeminfo /S $t 2>&1
    $sys | Out-File -FilePath (Join-Path $hostFolder 'systeminfo.txt') -Encoding utf8
  } catch {
    # systeminfo remote may require admin rights; run locally if needed
  }
}

# Compress results
$zipPath = Join-Path $OutputFolder ("dr-evidence-$timestamp.zip")
Compress-Archive -Path $base\* -DestinationPath $zipPath -Force
Write-Host "DR validation evidence collected: $zipPath"