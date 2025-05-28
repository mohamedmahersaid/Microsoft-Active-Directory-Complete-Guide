# Domain Trusts Guide

## Create:
- Open `Domains and Trusts`
- New Trust Wizard

## PowerShell:
```powershell
New-ADTrust -Name "child.corp.local" -Direction Bidirectional
```