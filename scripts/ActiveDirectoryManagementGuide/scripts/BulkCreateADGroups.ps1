Import-Csv ../templates/groups.csv | ForEach-Object {
    New-ADGroup -Name $_.Name -GroupScope Global -Description $_.Description
}