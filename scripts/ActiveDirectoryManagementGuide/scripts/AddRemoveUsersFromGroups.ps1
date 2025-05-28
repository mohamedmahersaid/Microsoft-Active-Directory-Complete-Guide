$groups = "HR", "IT"
$users = Get-Content ../templates/users.txt
foreach ($user in $users) {
    foreach ($group in $groups) {
        Add-ADGroupMember -Identity $group -Members $user
        # To remove: Remove-ADGroupMember -Identity $group -Members $user -Confirm:$false
    }
}