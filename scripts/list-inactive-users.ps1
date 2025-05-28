Search-ADAccount -AccountInactive -UsersOnly -TimeSpan 90.00:00:00 | 
Select-Object Name, LastLogonDate | 
Export-Csv "C:\Reports\InactiveUsers.csv" -NoTypeInformation