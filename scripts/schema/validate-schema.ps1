<#
validate-schema.ps1
Lightweight script to collect schema version and schema master FSMO info and check replication status for schema partition.

Usage:
  .\validate-schema.ps1 -OutputPath .\schema-check.json
#>

param(
  [string] $OutputPath = ".\schema-check.json"
)

$report = [ordered]@{
  Timestamp = (Get-Date).ToUniversalTime().ToString("o")
  Host = $env:COMPUTERNAME
  Schema = @{}
  Replication = @()
}

try {
  $root = Get-ADRootDSE -ErrorAction Stop
  $schemaNamingContext = $root.SchemaNamingContext
  $schemaRoleOwner = (Get-ADDomainController -Filter { OperationMasterRoles -contains 'SchemaMaster' } | Select-Object -First 1).Name
  $schemaVersion = $root.SchemaVersion
  $report.Schema.SchemaNamingContext = $schemaNamingContext
  $report.Schema.SchemaMaster = $schemaRoleOwner
  $report.Schema.SchemaVersion = $schemaVersion
} catch {
  $report.Schema.Error = $_.Exception.Message
}

try {
  $repl = repadmin /showrepl * /csv 2>&1
  $report.Replication.RawShowRepl = $repl
} catch {
  $report.Replication.Error = $_.Exception.Message
}

$report | ConvertTo-Json -Depth 6 | Out-File -FilePath $OutputPath -Encoding UTF8
Write-Host "Schema verification written to $OutputPath"