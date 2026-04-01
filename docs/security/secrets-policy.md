# Secrets & credential handling policy

- Never commit plaintext credentials, certificates, keys, or PFX files.
- Use Azure Key Vault, HashiCorp Vault, or GitHub Secrets for CI and automation.
- Prefer OIDC-based authentication for GitHub Actions -> Azure, rather than long-lived service principal secrets.
- Examples:
  - Retrieve secret from Key Vault in PowerShell:
    $secret = az keyvault secret show --name 'MySecret' --vault-name 'my-vault' --query value -o tsv
  - Use Managed Identity in Azure: use Invoke-RestMethod with token from MSI endpoint or AzAccount with -Identity.

If you find a secret committed accidentally:
- Rotate the secret immediately.
- Remove the secret from git history (use the GitHub guide and rotate creds).
- Notify maintainers and follow SECURITY.md.