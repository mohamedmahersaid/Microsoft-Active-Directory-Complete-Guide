<#
Generate simple release notes from git commits between tags.
Usage:
  .\release-notes-generator.ps1 -FromTag v1.2.0 -ToTag v1.3.0 -Output .\RELEASE-1.3.0.md
#>

param(
  [Parameter(Mandatory=$true)]
  [string] $FromTag,
  [Parameter(Mandatory=$true)]
  [string] $ToTag,
  [Parameter(Mandatory=$true)]
  [string] $Output
)

$commits = git log --pretty=format:'%h %s (%an)' $FromTag..$ToTag
$header = "# Release notes for $ToTag`n`n"
$body = $commits -join "`n"
$notes = $header + $body
$notes | Out-File -FilePath $Output -Encoding UTF8
Write-Host "Release notes generated: $Output"