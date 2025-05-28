# Active Directory Architecture Overview

This document outlines the architectural design and core components of an enterprise-grade Active Directory (AD) environment.

## 1. Core Components
- **Domain Controller (DC):** Hosts AD DS and handles authentication.
- **Global Catalog:** Partial replica of all objects for faster searches.
- **FSMO Roles:** Key roles like Schema Master, PDC Emulator.
- **Sites/Subnets:** Logical layout for replication control.
- **OUs:** Containers for grouping users/devices and applying GPOs.

## 2. Logical Structure
- Forests, Domains, Trees, OUs — full hierarchy explanation.

## 3. Physical Structure
- Sites based on IP subnet mapping and site links.

## 4. FSMO Roles
```powershell
netdom query fsmo
```

## 5. DNS Integration
AD-integrated zones recommended for secure, fast replication.

## 6. Security Design
- Tiered model, least privilege, secure delegation.

## 7. References
- [MS FSMO Roles](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/operations-master-roles)