# PKI / ADCS Guidance

Overview
This document covers on-prem PKI (Active Directory Certificate Services), CA hierarchy design, certificate templates, CRL/OCSP distribution, monitoring and renewal best practices.

Key considerations
- Use a two-tier PKI for most enterprises: an offline Root CA and one or more Online Issuing CAs.
- Protect private keys for Root CA in an HSM or offline storage.
- Plan CRL publication and ensure CDP/CRL URLs are highly available and accessible by relying parties.

Certificate templates and auto-enrollment
- Create templates with least privilege (Machine / User / Service templates).
- Use auto-enrollment for domain-joined machines where appropriate; consider approval workflows for high-privilege templates.

CRL/OCSP and revocation
- Publish CRLs frequently enough to balance revocation freshness and operational load (e.g., hourly delta CRLs for high churn; full CRL daily).
- Consider OCSP responders for faster revocation checking.

Monitoring and expiry management
- Inventory all certificates (domain, service, web, LDAP) and monitor expiry times.
- Create alerts for certificates expiring within a configurable window (30/60/90 days).
- Automate renewal where possible and test renewal processes in a lab.

Backup & recovery
- Backup CA database and private keys regularly and store backups securely (encrypted, offline copy).
- Document the restore procedure for the CA (include offline root restore steps).

Security controls
- Limit who can enroll for high-value templates.
- Use ACLs on CA objects and restrictive admin roles.
- Audit certificate issuance and CA admin actions.

References and templates
- Provide template JSON/PS scripts for CA creation, template creation, and auto-enrollment configuration in docs/pki/examples.