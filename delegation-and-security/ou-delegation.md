# OU Delegation Guide

## Why Delegate?
- Least privilege
- Role separation

## How:
1. ADUC → Right-click OU → Delegate Control
2. Select tasks (Reset password, etc.)

## PowerShell:
```powershell
$ou = "OU=Helpdesk,DC=corp,DC=local"
$account = "corp\helpdesk1"
# Delegate GenericWrite access
```