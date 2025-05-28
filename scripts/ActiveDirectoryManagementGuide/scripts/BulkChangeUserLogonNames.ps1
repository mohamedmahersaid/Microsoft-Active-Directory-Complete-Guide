Import-Csv ../templates/upn_changes.csv | ForEach-Object {
    Set-ADUser -Identity $_.SamAccountName -UserPrincipalName $_.NewUPN
}