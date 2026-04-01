function Get-ADDomainControllerHealth {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true)]
    [string] $ServerName
  )

  if (-not $ServerName) { throw "ServerName is required." }

  try {
    Import-Module ActiveDirectory -ErrorAction Stop

    $dc = Get-ADDomainController -Identity $ServerName -ErrorAction Stop

    # sample checks (expand with real checks)
    $replication = Get-ADReplicationPartnerMetadata -Target $ServerName -ErrorAction SilentlyContinue

    [pscustomobject]@{
      Computer   = $ServerName
      Site       = $dc.Site
      IsGlobalCatalog = $dc.IsGlobalCatalog
      ReplicationPartnerCount = ($replication | Measure-Object).Count
      Timestamp  = (Get-Date).ToUniversalTime()
    }
  } catch {
    Throw
  }
}

Export-ModuleMember -Function Get-ADDomainControllerHealth