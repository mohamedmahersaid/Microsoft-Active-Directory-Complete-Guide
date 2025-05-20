# Sites and Subnets

Define geographic layout for optimal replication.

1. Define new site.
2. Map subnet (CIDR format).
3. Move DC to correct site.
4. Test:
```powershell
nltest /dsgetsite
```