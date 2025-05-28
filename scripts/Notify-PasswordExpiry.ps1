$users = Get-ADUser -Filter * -Properties "msDS-UserPasswordExpiryTimeComputed"
$threshold = (Get-Date).AddDays(7)
foreach ($user in $users) {
    $expiry = [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed")
    if ($expiry -lt $threshold -and $expiry -gt (Get-Date)) {
        Write-Host "$($user.SamAccountName) expires on $expiry"
    }
}