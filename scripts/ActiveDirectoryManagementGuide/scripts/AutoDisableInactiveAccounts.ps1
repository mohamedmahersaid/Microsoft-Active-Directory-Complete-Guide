$daysInactive = 90
$time = (Get-Date).AddDays(-$daysInactive)
Get-ADUser -Filter {LastLogonDate -lt $time -and Enabled -eq $true} | ForEach-Object {
    Disable-ADAccount -Identity $_.SamAccountName
}