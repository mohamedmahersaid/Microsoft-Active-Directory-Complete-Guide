# AD Health Check

## Tools:
- dcdiag
- repadmin
- netlogon/SYSVOL

## Scripted:
```powershell
dcdiag /v /c > dcdiag.txt
repadmin /replsummary
```