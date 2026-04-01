# Monitoring & Detection Recipes (KQL examples)

This file contains example KQL rules to detect common AD threats or issues. Use them as starting points and tune thresholds to your environment.

Kerberoasting (abnormal service ticket requests)
SecurityEvent
| where EventID == 4769
| where ServiceName has_any ('$') // service SPNs typically include $ in name or review ServiceName field
| summarize Count = count() by TargetUserName, bin(TimeGenerated, 1h)
| where Count > 10

Suspicious DCSync-like behavior (sensitive replication or DS operations)
SecurityEvent
| where EventID in (4662, 4663) // monitor relevant AD access events; tune based on your logging
| where ObjectName contains 'NTDS' or ObjectName contains 'DC='
| summarize Count = count() by Account, bin(TimeGenerated, 1h)
| where Count > 50

Account lockout spikes
SecurityEvent
| where EventID == 4740
| summarize Count = count() by TargetUserName, bin(TimeGenerated, 1h)
| where Count > 20

Replication failure spike (custom logs forwarded or use scheduled collector output)
Workspace
| where Source == 'ad-collector' and Message contains 'replication'
| summarize Count = count() by bin(TimeGenerated, 1h), Host
| where Count > 5