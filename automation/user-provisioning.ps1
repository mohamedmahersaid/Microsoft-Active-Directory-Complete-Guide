# Bulk User Creation from CSV
$users = Import-Csv "C:\new_users.csv"
foreach ($u in $users) {
    New-ADUser -Name $u.Name -SamAccountName $u.SAM -AccountPassword (ConvertTo-SecureString $u.Password -AsPlainText -Force) -Enabled $true
}