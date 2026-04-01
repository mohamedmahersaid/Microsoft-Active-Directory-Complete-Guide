# IaC: Azure Bicep lab template

This directory contains a minimal Bicep template to deploy a disposable test lab (1 Windows VM intended for conversion to a Domain Controller, and a VNet).

Usage (example):
az group create -n ad-lab-rg -l eastus
az deployment group create -g ad-lab-rg --template-file main.bicep --parameters adminUsername='labadmin' adminPassword='<securePassword>'

Security notes:
- Do NOT use production credentials. Use temporary accounts and a disposable subscription.
- For automation, prefer managed identity or Key Vault for secrets (do not pass adminPassword in CLI history).