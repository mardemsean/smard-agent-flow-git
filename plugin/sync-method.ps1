<#
.SYNOPSIS
  Refreshes (or checks) the method documents bundled inside the plugin at smard-agent-flow\method.
.DESCRIPTION
  The repository root holds the canonical method documents. The plugin carries a copy so it works
  wherever it is installed (skills reference it as ${CLAUDE_PLUGIN_ROOT}/method). This script keeps
  that copy byte-identical to the canonical files.
    default : copy every bundled file from the repo root into the plugin, then verify by SHA-256.
    -Check  : copy nothing; exit 1 and list the differing files if the bundle drifted, else exit 0.
.EXAMPLE
  pwsh -NoProfile -File .\sync-method.ps1
  pwsh -NoProfile -File .\sync-method.ps1 -Check
#>
[CmdletBinding()]
param([switch]$Check)
$ErrorActionPreference = 'Stop'

$repo   = Split-Path $PSScriptRoot -Parent
$bundle = Join-Path $PSScriptRoot 'smard-agent-flow\method'

# Files the eight skills and the method router cite. Paths are relative to the repo root.
$files = @(
    'AGENTS.md', 'METHODOLOGY.md', 'RULES.md', 'INDEX.md', 'README.md',
    'explore.md', 'specs.md', 'adrZERO.md', 'plugin\README.md',
    '.claude\skills\grill-me\SKILL.md'
)
$files += Get-ChildItem (Join-Path $repo 'docs\production-workflow') -Recurse -File |
    ForEach-Object { $_.FullName.Substring($repo.Length + 1) }

$drift = @()
foreach ($rel in $files) {
    $s = Join-Path $repo $rel
    $d = Join-Path $bundle $rel
    if (-not (Test-Path $s)) { throw "Canonical file missing: $s" }
    $same = (Test-Path $d) -and ((Get-FileHash $s).Hash -eq (Get-FileHash $d).Hash)
    if ($same) { continue }
    if ($Check) { $drift += $rel; continue }
    New-Item -ItemType Directory -Force (Split-Path $d) | Out-Null
    Copy-Item $s $d -Force
    if ((Get-FileHash $s).Hash -ne (Get-FileHash $d).Hash) { throw "Copy verification failed: $rel" }
    Write-Host "Synced: $rel"
}

# Files in the bundle that no longer exist at the root are drift too (reported, never deleted).
$known = $files | ForEach-Object { $_.ToLowerInvariant() }
$orphans = @(Get-ChildItem $bundle -Recurse -File -Force -ErrorAction SilentlyContinue |
    ForEach-Object { $_.FullName.Substring($bundle.Length + 1) } |
    Where-Object { $_.ToLowerInvariant() -notin $known })

if ($Check) {
    if ($drift.Count -or $orphans.Count) {
        $drift   | ForEach-Object { Write-Host "DRIFT (differs or missing in bundle): $_" }
        $orphans | ForEach-Object { Write-Host "DRIFT (in bundle, not at root): $_" }
        exit 1
    }
    Write-Host ('Bundle in sync: {0} files byte-identical to the repo root.' -f $files.Count)
    exit 0
}
if ($orphans.Count) { Write-Warning "Bundle files with no canonical source (kept): $($orphans -join '; ')" }
Write-Host ('Bundle synced: {0} files at {1}' -f $files.Count, $bundle)
