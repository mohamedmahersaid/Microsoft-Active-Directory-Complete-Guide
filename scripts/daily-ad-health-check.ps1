Start-Transcript -Path "C:\Logs\AD-Health-Daily.txt"
dcdiag /v
repadmin /replsummary
netdom query fsmo
Stop-Transcript