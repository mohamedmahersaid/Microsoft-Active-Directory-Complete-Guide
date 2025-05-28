Import-Csv ../templates/update.csv | ForEach-Object {
    Set-ADUser -Identity $_.SamAccountName -Department $_.Department
}