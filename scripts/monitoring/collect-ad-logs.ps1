<#
Collect AD-related logs and artifacts for diagnostics.

Outputs a ZIP file with Event Logs, AD replication status, and a basic system report.
#>

param(
  [Parameter(Mandatory = $false)]
  [string] $OutputFolder = ".\ad-diagnostics",
  [Parameter(Mandatory = $false)]
  [string[]] $Targets = @('localhost')
)

function Collect-FromHost {
  param($Host)

  $timestamp = (Get-Date).ToString('yyyyMMddHHmmss')
  $out = Join-Path -Path $OutputFolder -ChildPath "${Host}-${timestamp}"
  New-Item -ItemType Directory -Path $out -Force | Out-Null

  Write-Host "Collecting Event Logs from $Host"
  $events = @('Directory Service','DNS Server','System','File Replication Service','DFS Replication')
  foreach ($ev in $events) {
    $file = Join-Path $out "$($ev -replace ' ','_').evtx"
    try {
      wevtutil epl "$ev" "$file" /ow:true
    } catch {
      Write-Warning "Failed to export $ev from $Host: $_"
    }
  }

  Write-Host "Collecting AD replication metadata"
  try {
    $rep = Get-ADReplicationPartnerMetadata -Target $Host -ErrorAction Stop
    $rep | Out-File -FilePath (Join-Path $out "replication-metadata.txt")
  } catch {
    Write-Warning "Get-ADReplicationPartnerMetadata failed for $Host: $_"
  }

  Write-Host "Collecting system info"
  systeminfo | Out-File -FilePath (Join-Path $out "systeminfo.txt")

  Compress-Archive -Path $out -DestinationPath "${out}.zip" -Force
  Remove-Item -Path $out -Recurse -Force
  Write-Host "Collected diagnostics for $Host -> ${out}.zip"
}

# Main
New-Item -ItemType Directory -Path $OutputFolder -Force | Out-Null
foreach ($t in $Targets) {
  Collect-FromHost -Host $t
}