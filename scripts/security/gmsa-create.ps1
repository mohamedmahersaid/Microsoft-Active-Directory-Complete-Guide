<#
gmsa-create.ps1
Helper script to create a group Managed Service Account (gMSA) in AD and optionally install/test it on a target host.

This script is intended for lab and controlled environments. Use -WhatIf to validate AD changes.
#>

param(
  [Parameter(Mandatory=$true)]
  [string] $Name,
  [Parameter(Mandatory=$true)]
  [string] $PrincipalsAllowedToRetrieve, # e.g. 'CN=WebServers,OU=ServiceAccounts,DC=domain,DC=local' or 'CONTOSO\\WebServers$'
  [Parameter(Mandatory=$false)]
  [string] $DNSHostName = '',
  [switch] $InstallOnHost,
  [string] $TargetHost = $env:COMPUTERNAME
)

function Ensure-ActiveDirectoryModule {
  if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Host "ActiveDirectory module not found. Attempting to import..."
    try { Import-Module ActiveDirectory -ErrorAction Stop } catch { Write-Error "ActiveDirectory module is required. Install RSAT/AD Tools and retry."; exit 1 }
  }
}

Ensure-ActiveDirectoryModule

if (-not $DNSHostName) {
  $DNSHostName = "$(Get-ADDomain).DNSRoot"
}

Write-Host "Creating gMSA: $Name (PrincipalsAllowedToRetrieve: $PrincipalsAllowedToRetrieve) - Use -WhatIf to preview changes"

try {
  New-ADServiceAccount -Name $Name -DNSHostName $DNSHostName -PrincipalsAllowedToRetrieveManagedPassword $PrincipalsAllowedToRetrieve -KerberosEncryptionType AES256,AES128 -WhatIf:$false
  Write-Host "gMSA creation command submitted. Verify with Get-ADServiceAccount -Identity $Name"
} catch {
  Write-Warning "gMSA creation may have failed or returned a warning: $_"
}

if ($InstallOnHost) {
  Write-Host "Attempting to install and test gMSA on host: $TargetHost"
  try {
    if ($TargetHost -eq $env:COMPUTERNAME) {
      Install-ADServiceAccount -Identity $Name -ErrorAction Stop
      if (Test-ADServiceAccount -Identity $Name) {
        Write-Host "gMSA installed and validated on local host."
      } else {
        Write-Warning "gMSA installation test failed on local host."
      }
    } else {
      Invoke-Command -ComputerName $TargetHost -ScriptBlock {
        param($n)
        Import-Module ActiveDirectory
        Install-ADServiceAccount -Identity $n
        Test-ADServiceAccount -Identity $n
      } -ArgumentList $Name -ErrorAction Stop
      Write-Host "gMSA installed and validated on remote host $TargetHost."
    }
  } catch {
    Write-Warning "Failed to install/test gMSA on host $TargetHost: $_"
  }
}

Write-Host "Completed gMSA helper run. Run Get-ADServiceAccount -Identity $Name to inspect."