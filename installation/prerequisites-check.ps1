# PowerShell script to verify prerequisites for AD DS installation
Get-NetIPConfiguration
(Get-ComputerInfo).WindowsVersion
Get-WindowsFeature AD-Domain-Services