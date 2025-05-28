function Get-NestedGroupMembers {
    param ([string]$GroupName)
    $visited = @{}
    function Expand-Group($Group) {
        if ($visited[$Group]) { return }
        $visited[$Group] = $true
        Get-ADGroupMember -Identity $Group | ForEach-Object {
            if ($_.objectClass -eq 'user') {
                $_
            } elseif ($_.objectClass -eq 'group') {
                Expand-Group $_.SamAccountName
            }
        }
    }
    Expand-Group $GroupName
}
Get-NestedGroupMembers -GroupName "IT-Security"