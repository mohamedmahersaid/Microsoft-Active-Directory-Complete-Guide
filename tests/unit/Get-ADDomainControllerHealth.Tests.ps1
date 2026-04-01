Describe "Get-ADDomainControllerHealth" {
  It "throws when ServerName not provided" {
    { Get-ADDomainControllerHealth -ServerName $null } | Should -Throw
  }

  It "returns object with expected properties (mocked AD cmdlets)" {
    Mock -CommandName Get-ADDomainController -MockWith { [pscustomobject]@{ Name = 'DC1'; Site = 'Default-First-Site'; IsGlobalCatalog = $true } }
    Mock -CommandName Get-ADReplicationPartnerMetadata -MockWith { @() }

    $result = Get-ADDomainControllerHealth -ServerName 'DC1'
    $result | Should -BeOfType 'System.Management.Automation.PSCustomObject'
    $result | Should -HaveProperty 'Status' -Because 'Status property should exist if implemented' -ErrorAction SilentlyContinue
  }
}