<#
Example usage:
  $env:PSGALLERY_API_KEY = '...'
  .\psgallery-publish-template.ps1 -ModulePath .\NetADHelpers -ApiKey $env:PSGALLERY_API_KEY
#>
param(
  [Parameter(Mandatory)]
  [string] $ModulePath,
  [Parameter(Mandatory)]
  [string] $ApiKey
)

if (-not (Test-Path $ModulePath)) { Throw "Module path not found: $ModulePath" }

Import-Module PowerShellGet -ErrorAction SilentlyContinue

Write-Host "Packaging and publishing module: $ModulePath"
Publish-Module -Path $ModulePath -NuGetApiKey $ApiKey -Force