PSRule guidance and rulepack for Active Directory hardening

Overview
This directory contains PSRule guidance and a starter rulepack to validate repository policies and PowerShell artifacts against AD hardening recommendations.

How to run locally
1. Install PSRule:
   Install-Module -Name PSRule -Scope CurrentUser -Force

2. Run rules against the scripts directory:
   Invoke-PSRule -Path ./scripts -RulePath ./ps-rule/rules -Recurse

Starter rulepack
- ps-rule/rules/ contains templates and example rules. These are intentionally conservative and should be tuned for your environment before enabling as CI gates.

What to author
- Rules to consider:
  - Require PSScriptAnalyzerSettings.psd1 presence
  - Detect committed PFX/PEM files (ban)
  - Enforce -WhatIf/-Confirm presence or require explicit -Confirm switch for destructive functions
  - Ensure scripts in production folders are signed (or show warning)
  - Detect usage of plaintext credential assignment patterns

Tuning & CI
- Add rule exceptions for lab/test scripts if necessary.
- CI in .github/workflows/ci.yml runs Invoke-PSRule when a ps-rule directory exists.