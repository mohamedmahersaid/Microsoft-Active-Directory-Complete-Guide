<#
Export-GpoSet.ps1
Exports GPO backups for selected GPOs or all GPOs in the domain.
Requires the GroupPolicy module (RSAT / GPMC).

Usage:
  .\export-gpo.ps1 -Path .\gpo-backups -All
  .\export-gpo.ps1 -Path .\gpo-backups -Name "CLT-Win10-Baseline-v2.1"
#>

param(
  [Parameter(Mandatory=$true)]
  [string] $Path,
  [string[]] $Name,
  [switch] $All
)

function Ensure-GroupPolicyModule {
  if (-not (Get-Module -ListAvailable -Name GroupPolicy)) {
    Write-Error "GroupPolicy module not available. Install RSAT/GPMC and retry."
    exit 1
  }
}

Ensure-GroupPolicyModule

if (-not (Test-Path $Path)) {
  New-Item -ItemType Directory -Path $Path -Force | Out-Null
}

if ($All) {
  $gpos = Get-GPO -All
} elseif ($Name) {
  $gpos = foreach ($n in $Name) { Get-GPO -Name $n -ErrorAction SilentlyContinue }
} else {
  Write-Error "Specify -All or -Name <GPOName>"
  exit 1
}

foreach ($g in $gpos) {
  if ($null -eq $g) { continue }
  $safeName = $g.DisplayName -replace '[^a-zA-Z0-9\-_\. ]','_'
  $target = Join-Path $Path "$($g.Id)_$safeName"
  Write-Host "Backing up GPO: $($g.DisplayName) -> $target"
  try {
    Backup-GPO -Guid $g.Id -Path $target -ErrorAction Stop
  } catch {
    Write-Warning "Failed to backup GPO $($g.DisplayName): $_"
  }
}
Write-Host "GPO backup completed. Files in: $Path"