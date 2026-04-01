param(
  [Parameter(Mandatory)]
  [string] $ModulePath,
  [Parameter(Mandatory)]
  [string] $ApiKey
)

# Publishes a PowerShell module directory to the PowerShell Gallery.
# Pre-req: PSGallery API key stored in $ApiKey (set via GitHub secret PSGALLERY_API_KEY).

if (-not (Test-Path $ModulePath)) {
  Throw "Module path not found: $ModulePath"
}

Push-Location $ModulePath

# Pack module (Create .nupkg using Publish-Module or Package-Module)
try {
  Write-Host "Publishing module from $ModulePath to PSGallery..."
  Publish-Module -Path $ModulePath -NuGetApiKey $ApiKey -Repository PSGallery -Force -ErrorAction Stop
  Write-Host "Publish completed."
} catch {
  Write-Error "Publish failed: $_"
  exit 1
} finally {
  Pop-Location
}