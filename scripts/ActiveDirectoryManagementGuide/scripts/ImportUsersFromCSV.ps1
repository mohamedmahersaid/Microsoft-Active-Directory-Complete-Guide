Import-Csv ../templates/users.csv | ForEach-Object {
    New-ADUser -Name $_.Name -GivenName $_.GivenName -Surname $_.Surname `
    -UserPrincipalName $_.UserPrincipalName -SamAccountName $_.SamAccountName `
    -Department $_.Department -AccountPassword (ConvertTo-SecureString "DefaultP@ss!" -AsPlainText -Force) `
    -Enabled $true
}