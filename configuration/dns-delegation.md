# DNS Delegation Setup

Used when creating child domains or integrating new DNS zones.

## Steps:
1. Open DNS Manager.
2. Right-click parent zone → New Delegation.
3. Add name + DNS servers.

## PowerShell:
```powershell
Add-DnsServerDelegation -Name "child" -ParentZoneName "corp.local" -NameServers "child-dns.corp.local"
```