# Release Process

1. Update Module version:
   - Edit scripts/modules/NetADHelpers/NetADHelpers.psd1 ModuleVersion field.
2. Update CHANGELOG.md with release notes.
3. Create a tag: git tag -a vX.Y.Z -m "release vX.Y.Z"
4. Push tag: git push origin vX.Y.Z
   - The release workflow will run on tag push and publish to PSGallery (requires PSGALLERY_API_KEY secret).

Secrets required:
- PSGALLERY_API_KEY (PowerShell Gallery API key) — store in GitHub Actions secrets.
- If deploying IaC in CI: AZURE_CREDENTIALS or use OIDC (recommended).