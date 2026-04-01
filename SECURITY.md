# Security policy

Report security issues privately to the repository maintainer: mohamedmahersaid (GitHub account) or email: [REDACTED_CONTACT].

Responsible disclosure timeline:
- Acknowledge within 3 business days.
- Provide a plan/ETA for fix within 10 business days when possible.

Do NOT open security issues in the public issue tracker. For sensitive data found in this repo, create an issue referencing SECURITY.md only after contacting the maintainer privately.

Secrets and credentials
- This repository must never contain plaintext credentials, certificates, or PFX files.
- Use Azure Key Vault, HashiCorp Vault, or GitHub Secrets for CI/automation.