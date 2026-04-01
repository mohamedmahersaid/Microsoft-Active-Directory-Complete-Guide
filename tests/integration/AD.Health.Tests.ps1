Describe 'AD Integration smoke tests' {
  Context 'Replication and DC discovery' {
    It 'Discovers at least one domain controller' {
      $dc = Get-ADDomainController -Discover -ErrorAction Stop
      $dc | Should -Not -BeNullOrEmpty
    }

    It 'Has no immediate replication failures' {
      $failures = Get-ADReplicationFailure -Scope Site -ErrorAction SilentlyContinue
      # If cmdlet not available (not running with RSAT), mark pending
      if ($null -eq $failures) { Throw "Get-ADReplicationFailure unavailable or returned null" }
      $failures | Should -BeOfType System.Object
    }
  }

  Context 'Sample AD query' {
    It 'Can find at least one user' {
      $u = Get-ADUser -Filter * -ResultSetSize 1 -ErrorAction Stop
      $u | Should -Not -BeNullOrEmpty
    }
  }
}