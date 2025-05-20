$SourceOU = "OU=Test,DC=corp,DC=local"
$TargetOU = "OU=Staging,DC=corp,DC=lab"
Get-ADUser -SearchBase $SourceOU -Filter * | ForEach-Object {
    $newUser = $_ | Select-Object *
    $newUser.DistinguishedName = $newUser.DistinguishedName -replace [regex]::Escape($SourceOU), $TargetOU
    try {
        New-ADUser -SamAccountName $newUser.SamAccountName `
            -UserPrincipalName $newUser.UserPrincipalName `
            -Name $newUser.Name -Path $TargetOU `
            -AccountPassword (ConvertTo-SecureString "Staging123!" -AsPlainText -Force) `
            -Enabled $true
    } catch {
        Write-Warning "Failed to clone user $_.SamAccountName: $_"
    }
}