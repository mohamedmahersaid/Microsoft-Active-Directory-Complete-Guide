$ou = "OU=HR,DC=contoso,DC=com"
Get-Acl "AD:\$ou" | Format-List