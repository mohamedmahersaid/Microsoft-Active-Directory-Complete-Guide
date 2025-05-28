Set-ADUser -Identity jdoe -Add @{ProxyAddresses="smtp:jdoe@newdomain.com"}
Set-ADUser -Identity jdoe -Remove @{ProxyAddresses="smtp:jdoe@olddomain.com"}