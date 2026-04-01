# Publishing modules and releases

Overview
- Use semantic versioning (MAJOR.MINOR.PATCH). Tag releases with `vMAJOR.MINOR.PATCH`.
- Ensure tests pass and PSScriptAnalyzer/PSRule gates are green prior to tagging.

Publishing to PowerShell Gallery (high-level)
1. Create a release tag: git tag -a vX.Y.Z -m "Release vX.Y.Z"
2. Push tag: git push origin vX.Y.Z
3. The release workflow will publish to PSGallery using PSGALLERY_API_KEY secret.

Changelog & release notes
- Update CHANGELOG.md and generate detailed release notes using scripts/release/release-notes-generator.ps1.
- Attach release notes to the GitHub Release.

Rollback & hotfix guidance
- For critical hotfixes, branch from the last release tag, apply fix, increment patch number, and publish a patch release.