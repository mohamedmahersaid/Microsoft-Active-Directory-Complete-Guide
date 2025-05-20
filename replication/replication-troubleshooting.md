# AD Replication Troubleshooting

## Commands:
```powershell
repadmin /replsummary
repadmin /showrepl
dcdiag /v
```

## Fix:
```powershell
repadmin /syncall /APeD
repadmin /kcc *
```