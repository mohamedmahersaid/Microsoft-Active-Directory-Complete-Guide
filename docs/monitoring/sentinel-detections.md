# Sentinel detections: example queries and playbooks

Example KQL query — AD account lockout spikes:
SecurityEvent
| where EventID == 4740
| summarize Count = count() by TargetUserName, bin(TimeGenerated, 1h)
| where Count > 10

Example KQL query — suspicious Kerberos service ticket requests (Kerberoasting indicators):
SecurityEvent
| where EventID == 4769
| where AccountType == "User"
| summarize Count = count() by ServiceName, AccountName, bin(TimeGenerated, 1h)
| where Count > 5

Playbook recommendation:
- On detection, trigger a runbook to collect diagnostics from relevant DCs and create a high-priority incident in your ITSM system. Use automation account or Logic Apps with runbook that runs scripts/monitoring/collect-ad-logs.ps1.