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

    $status = 'OK'

    # If replication metadata is missing or empty, mark status as Warning
    if (-not $replication) {
      $status = 'Warning'
    }

    return [pscustomobject]@{
      Computer   = $ServerName
      Site       = $dc.Site
      IsGlobalCatalog = $dc.IsGlobalCatalog
      ReplicationPartnerCount = ($replication | Measure-Object).Count
      Status     = $status
      Timestamp  = (Get-Date).ToUniversalTime()
    }
  } catch {
    # Return a structured object with error status for callers to consume
    return [pscustomobject]@{
      Computer = $ServerName
      Site = ''
      IsGlobalCatalog = $false
      ReplicationPartnerCount = 0
      Status = 'Error'
      ErrorMessage = $_.Exception.Message
      Timestamp = (Get-Date).ToUniversalTime()
    }
  }
}

Export-ModuleMember -Function Get-ADDomainControllerHealth
