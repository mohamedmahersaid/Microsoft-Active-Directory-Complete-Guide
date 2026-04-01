<#
Sample integration smoke tests for AD environment. These are safe, read-only checks intended to run in a lab or test environment.

Checks:
- Resolve DCs
- Replication summary
- AD user lookup
#>

param(
  [string[]] $Targets = @('localhost')
)

foreach ($t in $Targets) {
  Write-Host "Running smoke checks for $t"

  try {
    $dc = Get-ADDomainController -Discover -ErrorAction Stop
    Write-Host "Discovered DC: $($dc.HostName)"
  } catch {
    Write-Warning "Get-ADDomainController failed: $_"
  }

  try {
    $repl = repadmin /replsummary 2>&1
    Write-Host "Repl Summary: (first 5 lines)"
    $repl | Select-Object -First 5 | ForEach-Object { Write-Host $_ }
  } catch {
    Write-Warning "repadmin failed: $_"
  }

  try {
    $sampleUser = Get-ADUser -Filter * -Properties Enabled -ResultSetSize 1
    Write-Host "Sample user: $($sampleUser.SamAccountName)"
  } catch {
    Write-Warning "Get-ADUser failed: $_"
  }
}