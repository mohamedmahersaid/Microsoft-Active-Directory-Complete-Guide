Install-WindowsFeature -Name 'DHCP' -IncludeManagementTools
Add-DhcpServerv4Scope -Name "MainScope" -StartRange 192.168.1.100 -EndRange 192.168.1.200 -SubnetMask 255.255.255.0
Get-DhcpServerv4Lease -ScopeId 192.168.1.0
