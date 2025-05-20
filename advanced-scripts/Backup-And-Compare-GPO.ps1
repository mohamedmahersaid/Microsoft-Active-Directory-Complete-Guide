$backupPath = "C:\GPOBackup\$(Get-Date -Format yyyyMMdd)"
Backup-GPO -All -Path $backupPath
Compare-GPO -BackupGpoName "GPO_Workstation" -Path $backupPath -ReferenceGpoName "GPO_Workstation" -ReferenceDomain "corp.local"