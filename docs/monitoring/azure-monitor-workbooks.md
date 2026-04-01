# Azure Monitor: AD monitoring workbook guidance

This document describes recommended metrics, logs, and workbook components for monitoring Active Directory in Azure Monitor / Log Analytics.

Recommended data sources:
- Forward Windows Event Logs from domain controllers (Directory Service, DNS Server, DFS Replication, System)
- AD replication health (Use scheduled collectors to run Get-ADReplicationFailure and send results)
- Perf counters (CPU, memory, disk, network) and DC-specific counters (DS Directory Reads/sec, NTDS I/O)

Suggested workbook sections:
- Summary (replication health, critical events in last 24h)
- Per-DC health (replication partner status, GC availability)
- Alerts widget (open alerts and severity)
- Historical trends (replication failure rate, errors by event ID)

Example: schedule scripts/monitoring/collect-ad-logs.ps1 to run on a jump-box or Log Analytics agent to upload diagnostics to a workspace.