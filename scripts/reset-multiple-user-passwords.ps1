Import-Csv "C:\Scripts\users.csv" | ForEach-Object {
    $securePwd = ConvertTo-SecureString $_.Password -AsPlainText -Force
    Set-ADAccountPassword -Identity $_.Username -NewPassword $securePwd -Reset
    Enable-ADAccount -Identity $_.Username
}