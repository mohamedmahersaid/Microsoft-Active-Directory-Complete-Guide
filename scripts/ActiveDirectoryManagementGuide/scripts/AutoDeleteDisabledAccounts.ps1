$threshold = (Get-Date).AddDays(-30)
Get-ADUser -Filter {Enabled -eq $false -and WhenChanged -lt $threshold} | ForEach-Object {
    Remove-ADUser -Identity $_.SamAccountName -Confirm:$false
}