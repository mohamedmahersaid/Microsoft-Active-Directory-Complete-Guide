$groups = "Domain Admins", "Enterprise Admins", "Schema Admins"
$results = foreach ($group in $groups) {
    Get-ADGroupMember -Identity $group -Recursive | Select-Object Name, SamAccountName, @{Name="Group"; Expression={$group}}
}
$results | Export-Csv "C:\Reports\PrivilegedUsers.csv" -NoTypeInformation