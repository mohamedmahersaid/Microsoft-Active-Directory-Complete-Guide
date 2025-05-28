$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$dcs = $domain.DomainControllers
$results = foreach ($user in Get-ADUser -Filter * -Properties LastLogon) {
    $lastLogon = 0
    foreach ($dc in $dcs) {
        $ll = (Get-ADUser $user.DistinguishedName -Server $dc.Name -Properties LastLogon).LastLogon
        if ($ll -gt $lastLogon) { $lastLogon = $ll }
    }
    $realDate = [DateTime]::FromFileTime($lastLogon)
    if ($realDate -lt (Get-Date).AddDays(-90)) {
        [PSCustomObject]@{ User = $user.SamAccountName; LastLogon = $realDate }
    }
}
$results | Export-Csv "C:\Reports\InactiveUsers.csv" -NoTypeInformation