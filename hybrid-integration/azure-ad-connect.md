# Azure AD Connect Setup

## Steps:
1. Download installer
2. Express or Custom
3. Filter OUs
4. Password hash sync or PTA

## Verify:
```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```