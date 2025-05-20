$groups = @("Domain Admins", "Enterprise Admins", "Schema Admins")
foreach ($group in $groups) {
    Get-ADGroupMember -Identity $group |
    Select-Object Name, SamAccountName, ObjectClass |
    Export-Csv "C:\Reports\${group.Replace(' ', '_')}_Members.csv" -NoTypeInformation
}