Add-DnsServerPrimaryZone -Name "domain.local" -ReplicationScope "Forest"
Add-DnsServerResourceRecordA -Name "server1" -ZoneName "domain.local" -IPv4Address "192.168.1.10"
Get-DnsServerZone
