# Restore Failed DC

## Remove Metadata:
```powershell
Remove-ADDomainController -Identity "DC01" -Force
```

## Seize Roles (if needed):
```powershell
Move-ADDirectoryServerOperationMasterRole -Identity "DC02" -OperationMasterRole 0,1,2,3,4
```

## Rebuild:
Reinstall → Join domain → Promote to DC