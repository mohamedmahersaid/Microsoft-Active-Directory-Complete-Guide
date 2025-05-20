<#
.SYNOPSIS
  Export full OU structure in the domain
#>

Get-ADOrganizationalUnit -Filter * |
Select-Object Name, DistinguishedName |
Export-Csv "C:\Reports\OU_Structure.csv" -NoTypeInformation