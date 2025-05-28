Import-Csv ../templates/users.csv | ForEach-Object {
    Set-ADAccountPassword -Identity $_.SamAccountName -NewPassword (ConvertTo-SecureString "NewP@ssword123" -AsPlainText -Force)
}