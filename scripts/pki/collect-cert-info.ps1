<#
collect-cert-info.ps1
Collect certificate inventory and expiry information from local machine or remote hosts.
Outputs CSV with certificate subject, thumbprint, issuer, notbefore, notafter and intended purpose.

Usage:
  .\collect-cert-info.ps1 -Targets localhost,DC1 -Output .\cert-inventory.csv
#>

param(
  [string[]] $Targets = @('localhost'),
  [string] $Output = '.\cert-inventory.csv'
)

$results = @()

foreach ($t in $Targets) {
  Write-Host "Collecting certificates from $t"
  try {
    $store = [System.Security.Cryptography.X509Certificates.StoreName]::My
    $location = [System.Security.Cryptography.X509Certificates.StoreLocation]::LocalMachine
    $session = $null
    if ($t -ne 'localhost') {
      $certs = Invoke-Command -ComputerName $t -ScriptBlock {
        param($s,$l)
        Get-ChildItem -Path Cert:\LocalMachine\My | Select-Object Subject,Thumbprint,Issuer,NotBefore,NotAfter,EnhancedKeyUsageList
      } -ArgumentList $store,$location -ErrorAction Stop
    } else {
      $certs = Get-ChildItem -Path Cert:\LocalMachine\My
    }

    foreach ($c in $certs) {
      $eku = ($c.EnhancedKeyUsageList | ForEach-Object { $_.FriendlyName }) -join ';'
      $results += [PSCustomObject]@{
        Host = $t
        Subject = $c.Subject
        Thumbprint = $c.Thumbprint
        Issuer = $c.Issuer
        NotBefore = $c.NotBefore
        NotAfter = $c.NotAfter
        EKU = $eku
      }
    }
  } catch {
    Write-Warning "Failed to collect certs from $t: $_"
  }
}

$results | Sort-Object Host,NotAfter | Export-Csv -Path $Output -NoTypeInformation -Encoding UTF8
Write-Host "Certificate inventory exported to $Output"