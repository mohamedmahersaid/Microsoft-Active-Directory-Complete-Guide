# Installing Active Directory Domain Services (AD DS)

## 1. Prerequisites
- Static IP
- Renamed server (e.g., `DC01`)
- Strong local admin password

## 2. Install AD DS Role
```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
```

## 3. Promote to Domain Controller
```powershell
Install-ADDSForest -DomainName "corp.local" -DomainNetbiosName "CORP" `
 -SafeModeAdministratorPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force)
```

## 4. Validation
```powershell
dcdiag
repadmin /replsummary
```