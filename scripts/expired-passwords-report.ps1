Get-ADUser -Filter * -Properties "Name", "PasswordExpired" |
Where-Object { $_.PasswordExpired -eq $true } |
Select-Object Name |
Export-Csv "C:\Reports\ExpiredPasswords.csv" -NoTypeInformation