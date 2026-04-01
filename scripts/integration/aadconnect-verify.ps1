<#
aadconnect-verify.ps1
Checks basic health of Azure AD Connect on the local AAD Connect server.

Requirements:
- Run on the AAD Connect server (or a server with ADSync PowerShell module available).
- Requires administrative privileges.

This script performs a non-destructive set of checks and emits a summary JSON suitable for ingestion by monitoring or a runbook.
#>

param(
  [string] $OutputPath = ".\aadconnect-health.json"
)

$summary = [ordered]@{
  Timestamp = (Get-Date).ToUniversalTime().ToString("o")
  Host = $env:COMPUTERNAME
  Checks = @()
}

function Add-Check {
  param($Name, $Status, $Details)
  $summary.Checks += [ordered]@{ Name = $Name; Status = $Status; Details = $Details }
}

# Check: ADSync service status
try {
  $svc = Get-Service -Name ADSync -ErrorAction Stop
  Add-Check -Name 'ADSync Service' -Status ($svc.Status) -Details "DisplayName: $($svc.DisplayName)"
} catch {
  Add-Check -Name 'ADSync Service' -Status 'NotFound' -Details $_.Exception.Message
}

# Check: ADSync scheduler (if module available)
try {
  Import-Module ADSync -ErrorAction Stop
  $scheduler = Get-ADSyncScheduler
  Add-Check -Name 'ADSync Scheduler' -Status 'OK' -Details @{ SyncCycleEnabled = $scheduler.SyncCycleEnabled; Schedule = $scheduler.SyncCycleIntervalInMinutes }
} catch {
  Add-Check -Name 'ADSync Scheduler' -Status 'MissingModuleOrError' -Details $_.Exception.Message
}

# Check: Recent export/import errors (scan Event Log)
try {
  $events = Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='ADSync'} -MaxEvents 50 -ErrorAction Stop
  $errors = $events | Where-Object { $_.LevelDisplayName -in 'Error','Critical' }
  $count = $errors.Count
  Add-Check -Name 'Recent ADSync Errors' -Status (if ($count -gt 0) { 'ErrorsFound' } else { 'None' }) -Details @{ Count = $count; Recent = $errors | Select-Object TimeCreated, Id, Message -First 5 }
} catch {
  Add-Check -Name 'ADSync Event Scan' -Status 'Error' -Details $_.Exception.Message
}

# Check: Connector space statistics (best-effort; may require ADSync module)
try {
  $connectors = Get-ADSyncConnector 2>$null
  if ($connectors) {
    $connSummaries = $connectors | ForEach-Object { @{ Name = $_.Name; ConnectedPartitions = $_.ConnectedPartitions.Count } }
    Add-Check -Name 'Connectors' -Status 'OK' -Details $connSummaries
  } else {
    Add-Check -Name 'Connectors' -Status 'Unavailable' -Details 'Get-ADSyncConnector returned null or command not available'
  }
} catch {
  Add-Check -Name 'Connectors' -Status 'Error' -Details $_.Exception.Message
}

# Serialize output
$summary | ConvertTo-Json -Depth 6 | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "AD Connect health summary written to $OutputPath"