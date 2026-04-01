# Code signing for PowerShell scripts and modules

Why sign scripts
- Script signing provides authenticity and integrity guarantees; prevents tampered scripts from running in environments configured to require signed code.

Signing models
- Developer signing: used during development/testing; use ephemeral certs in lab.
- CI signing: production artifacts are signed in CI using a certificate stored securely (HSM, Azure Key Vault, or dedicated signing service).
- Verify on-host: enforce execution policies or verification steps that check signatures before running scripts in production.

How to sign locally (example)
1. Obtain code-signing certificate (PFX) installed in the Personal store.
2. Sign a script:
   - $cert = Get-ChildItem Cert:\\CurrentUser\\My\\<THUMBPRINT>
   - Set-AuthenticodeSignature -FilePath .\\deploy.ps1 -Certificate $cert
3. Verify:
   - Get-AuthenticodeSignature -FilePath .\\deploy.ps1

CI signing patterns
- Store code-signing certificate in a secure store (Azure Key Vault, HSM). Do NOT store PFX in repo.
- Use a CI job that retrieves the cert temporarily and performs signing, then removes the cert.
- Use Azure Key Vault sign APIs or HSM-backed keys and never expose private key material in runners.
- Example actions:
  - Retrieve cert via secure method
  - Import-PfxCertificate into Temp store or use signing API
  - Run Set-AuthenticodeSignature on artifacts
  - Verify signature post-sign

Enforce verification
- Use Get-AuthenticodeSignature in pre-deploy checks.
- Add PSScriptAnalyzer rule or CI gate to require a valid signature for files in /scripts/production or module manifests.
- Consider GPO-based enforcement for on-prem hosts (set execution policy and restrict script runs to signed scripts).

Rotation and policy
- Rotate signing keys periodically and maintain a key rollover plan.
- Document certificate thumbprints and issuing CA in docs/pki/README.md.
- Record the CI job and access control for signing operations in docs/release/README.md.

Security notes
- Never commit certificates or private keys to git.
- Limit which accounts / service principals can access the signing key.
- Log and monitor signing operations (who requested signing, when, and which artifacts).