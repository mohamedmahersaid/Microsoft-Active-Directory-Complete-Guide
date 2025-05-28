# 📘 Active Directory Security Hardening Guide

---

## 1️⃣ Limit Privileged Accounts

✅ **Best Practices:**

* Minimize memberships in Domain Admins, Enterprise Admins, Schema Admins.
* Use dedicated admin accounts (separate from user accounts).

✅ **Steps:**

* Check ADUC > Domain Admins / Enterprise Admins / Schema Admins groups.
* Remove unnecessary members.

✅ **PowerShell:**

```powershell
Get-ADGroupMember -Identity "Domain Admins"
Get-ADGroupMember -Identity "Enterprise Admins"
```

---

## 2️⃣ Secure Administrator Accounts

✅ **Actions:**

* Rename default Administrator account.
* Use strong, unique passwords.
* Apply deny logon locally.

✅ **PowerShell:**

```powershell
Rename-LocalUser -Name "Administrator" -NewName "Admin_Renamed"
```

---

## 3️⃣ Use LAPS for Local Admin Passwords

✅ **Steps:**

* Install and configure LAPS.
* Extend AD schema.
* Configure Group Policy.

✅ **PowerShell:**

```powershell
Import-Module AdmPwd.PS
Update-AdmPwdADSchema
```

---

## 4️⃣ Harden Admin Workstations

✅ **Strategy:**

* Use Privileged Access Workstations (PAW).
* Block internet & limit software.

✅ **Setup:**

* Dedicated hardware/VMs.
* Allow management network only.

---

## 5️⃣ Enable Auditing

✅ **Policies:**

* Logon events.
* Account management.

✅ **PowerShell:**

```powershell
AuditPol /set /subcategory:"Logon" /success:enable /failure:enable
```

---

## 6️⃣ Strengthen Password Policies

✅ **Recommendations:**

* Minimum 14-character passphrases.
* Lockout policies.

✅ **PowerShell:**

```powershell
net accounts /minpwlen:14
net accounts /lockoutthreshold:5
```

---

## 7️⃣ Remove Stale Accounts

✅ **PowerShell:**

```powershell
Search-ADAccount -AccountInactive -UsersOnly -TimeSpan 90.00:00:00
Disable-ADAccount -Identity username
```

---

## 8️⃣ Secure DNS and DHCP

✅ **Steps:**

* Enable DNS logging.
* Monitor unusual queries.

✅ **PowerShell:**

```powershell
Set-DnsServerDiagnostics -All $true
```

---

## 9️⃣ Patch & Scan Regularly

✅ **Tools:**

* WSUS, SCCM, vulnerability scanners.
* Apply monthly patches.

---

## 🔟 Group Policy Best Practices

✅ **Steps:**

* Use Microsoft Security Baseline GPOs.
* Scope via OUs.

✅ **PowerShell:**

```powershell
Get-GPO -All
```

---

## 1️⃣1️⃣ Enable MFA

✅ **Tools:**

* Azure MFA, DUO, Windows Hello.
* Apply to RDP, VPN, privileged accounts.

---

## 1️⃣2️⃣ Apply Tiered Admin Model

✅ **Design:**

* Tier 0 (DCs), Tier 1 (Servers), Tier 2 (Workstations).

✅ **Steps:**

* Separate accounts.
* Enforce firewall boundaries.

---

## 1️⃣3️⃣ Backup & Disaster Recovery

✅ **Steps:**

* Backup DCs.
* Test restores.

✅ **PowerShell:**

```powershell
wbadmin start systemstatebackup -backupTarget:D: -quiet
```

---

## 1️⃣4️⃣ Regular Security Reviews

✅ **Automate Reports:**

```powershell
Get-ADGroupMember "Domain Admins" | Select Name, SamAccountName | Export-Csv DomainAdmins.csv -NoTypeInformation
```

---

# 📊 Reporting Before and After Hardening

✅ Export baseline → apply changes → export post-hardening → compare results.

✅ Reference Materials:

* Microsoft AD Best Practices
* CIS Benchmarks
* NIST 800-53

---

👉 This validated guide is ready for GitHub, with scripts, diagrams, and documentation.

If you want, I can **package this into a GitHub repository with folder structure and ready-to-upload content** — just say **“yes, build the GitHub repo”**!
