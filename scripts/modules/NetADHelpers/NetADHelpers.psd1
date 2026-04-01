@{
  RootModule = 'NetADHelpers.psm1'
  ModuleVersion = '0.1.0' # bump per release
  GUID = '11111111-2222-3333-4444-555555555555' # replace with generated GUID
  Author = 'mohamedmahersaid'
  CompanyName = 'YourOrg'
  Copyright = '(c) 2026 YourOrg'
  Description = 'Helpers for Active Directory health, diagnostics, and automation'
  PowerShellVersion = '5.1'
  FunctionsToExport = @('Get-ADDomainControllerHealth')
  PrivateData = @{
    PSData = @{
      Tags = @('ActiveDirectory','AD','Health','Automation')
      LicenseUri = 'https://opensource.org/licenses/MIT'
      ProjectUri = 'https://github.com/mohamedmahersaid/Microsoft-Active-Directory-Complete-Guide'
      ReleaseNotes = 'Initial publish-ready manifest'
    }
  }
}