Get-ADObject -Filter 'objectClass -eq "organizationalUnit"' -Properties nTSecurityDescriptor | ForEach-Object {
    $acl = $_.nTSecurityDescriptor
    foreach ($ace in $acl.Access) {
        try {
            $null = [System.Security.Principal.SecurityIdentifier]$ace.IdentityReference
            $null = $ace.IdentityReference.Translate([System.Security.Principal.NTAccount])
        } catch {
            Write-Warning "Orphaned SID: $($ace.IdentityReference) in $_.DistinguishedName"
        }
    }
}