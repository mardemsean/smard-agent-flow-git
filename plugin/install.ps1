<#
.SYNOPSIS
  Sets the smard-agent-flow plugin up for Claude Code without a marketplace (Windows, PowerShell 7).
.DESCRIPTION
  Preferred route on any machine: the marketplace at the repository root
    /plugin marketplace add mardemsean/smard-agent-flow-git     (or the local clone path)
    /plugin install smard-agent-flow@smard-agent-flow-marketplace
  This script is the fallback that needs no marketplace. It installs two things, because a plugin skill is always namespaced:
    1. the plugin folder  -> <config>\skills\smard-agent-flow      (loads as smard-agent-flow@skills-dir; skills /smard-agent-flow:smard-agent-flow, :clarify, ...)
    2. the user command   -> <config>\commands\smard-agent-flow.md (the short entry point /smard-agent-flow, source: .claude\commands at the repo root)
  <config> is $env:CLAUDE_CONFIG_DIR when set, else $env:USERPROFILE\.claude.
  Before copying it refreshes the packaged copy of the method (sync-method.ps1) and proves it has no drift.
  A release package (packaging\build.ps1) ships this script without sync-method.ps1 and without the canonical
  documents; there the packaged copy is final and the refresh is skipped.
  The script only copies. An existing different command file is backed up first. Files present in the destination
  but not in the source are reported, never removed. -Uninstall sends both destinations to the Recycle Bin.
.EXAMPLE
  pwsh -NoProfile -File .\install.ps1
  pwsh -NoProfile -File .\install.ps1 -WhatIf
  pwsh -NoProfile -File .\install.ps1 -Uninstall
#>
[CmdletBinding(SupportsShouldProcess)]
param([switch]$Uninstall)
$ErrorActionPreference = 'Stop'

$cfg     = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE '.claude' }
$repo    = Split-Path $PSScriptRoot -Parent
$src     = Join-Path $PSScriptRoot 'smard-agent-flow'
$cmdSrc  = Join-Path $repo '.claude\commands\smard-agent-flow.md'
$dest    = Join-Path $cfg 'skills\smard-agent-flow'
$cmdDest = Join-Path $cfg 'commands\smard-agent-flow.md'

function Test-OurPlugin($folder) {
    $m = Join-Path $folder '.claude-plugin\plugin.json'
    (Test-Path $m) -and ((Get-Content $m -Raw | ConvertFrom-Json).name -eq 'smard-agent-flow')
}
function Send-ToRecycleBin($path) {
    Add-Type -AssemblyName Microsoft.VisualBasic
    if (Test-Path $path -PathType Container) {
        [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
    } else {
        [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($path, 'OnlyErrorDialogs', 'SendToRecycleBin')
    }
}
function Get-TreeHashes($root) {
    Get-ChildItem $root -Recurse -File -Force | Sort-Object FullName |
        ForEach-Object { '{0} {1}' -f $_.FullName.Substring($root.Length), (Get-FileHash $_.FullName).Hash }
}

Write-Host "Config folder: $cfg"

if ($Uninstall) {
    if ((Test-Path $dest) -and -not (Test-OurPlugin $dest)) { throw "Refusing to remove ${dest}: it is not the smard-agent-flow plugin." }
    foreach ($p in @($dest, $cmdDest)) {
        if (-not (Test-Path $p)) { Write-Host "Not installed: $p"; continue }
        if ($PSCmdlet.ShouldProcess($p, 'Send to Recycle Bin')) { Send-ToRecycleBin $p; Write-Host "Removed (Recycle Bin): $p" }
    }
    Write-Host 'Uninstalled. Start a new Claude Code session or run /reload-plugins.'
    return
}

# --- preflight -------------------------------------------------------------------------------
if (-not (Test-OurPlugin $src)) { throw "Plugin source not found or not smard-agent-flow: $src" }
if (-not (Test-Path (Join-Path $src 'skills\smard-agent-flow\SKILL.md'))) { throw 'Source skill skills\smard-agent-flow\SKILL.md is missing.' }
if (-not (Test-Path $cmdSrc)) { throw "User command source not found: $cmdSrc" }
$sync = Join-Path $PSScriptRoot 'sync-method.ps1'
if (Test-Path $sync) {
    if (-not $WhatIfPreference) { & $sync }
    & $sync -Check
    if ($LASTEXITCODE -ne 0) { throw 'Packaged copy of the method differs from the repo root; run sync-method.ps1.' }
}
if ((Test-Path $dest) -and -not (Test-OurPlugin $dest)) { throw "Refusing to overwrite ${dest}: it is not the smard-agent-flow plugin." }
$version = (Get-Content (Join-Path $src '.claude-plugin\plugin.json') -Raw | ConvertFrom-Json).version

# --- install ---------------------------------------------------------------------------------
if ($PSCmdlet.ShouldProcess($dest, "Copy plugin $version")) {
    New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
    robocopy $src $dest /E /NFL /NDL /NJH /NJS /NP | Out-Null
    if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }
    Write-Host "Plugin copied: $dest (version $version)"
}
if ($PSCmdlet.ShouldProcess($cmdDest, 'Copy user command')) {
    New-Item -ItemType Directory -Force (Split-Path $cmdDest) | Out-Null
    if ((Test-Path $cmdDest) -and ((Get-FileHash $cmdDest).Hash -ne (Get-FileHash $cmdSrc).Hash)) {
        $bak = "$cmdDest.bak-{0:yyyyMMdd-HHmmss}" -f (Get-Date)
        Copy-Item $cmdDest $bak
        Write-Host "Existing different command backed up: $bak"
    }
    Copy-Item $cmdSrc $cmdDest -Force
    Write-Host "Command copied: $cmdDest"
}

# --- verify ----------------------------------------------------------------------------------
if (-not $WhatIfPreference) {
    $a = @(Get-TreeHashes $src); $b = @(Get-TreeHashes $dest)
    $extra = @($b | Where-Object { $_ -notin $a })
    $missing = @($a | Where-Object { $_ -notin $b })
    if ($missing.Count) { throw "Installed plugin is missing files or differs: $($missing -join '; ')" }
    if ((Get-FileHash $cmdDest).Hash -ne (Get-FileHash $cmdSrc).Hash) { throw 'Installed command differs from source.' }
    if ($extra.Count) { Write-Warning "Files in the installed plugin that are not in the source (kept, not removed): $($extra -join '; ')" }
    Write-Host ('Verified: {0} plugin files and the user command are byte-identical to the source.' -f $a.Count)
    Write-Host ''
    Write-Host 'Next: start a NEW Claude Code session (or run /reload-plugins), then use:'
    Write-Host '  /smard-agent-flow           short entry point (user command)'
    Write-Host '  /smard-agent-flow:smard-agent-flow    the plugin skill (always namespaced)'
    Write-Host 'Proof that it loads, in your own terminal:'
    Write-Host "  claude plugin validate `"$dest`" --strict"
    Write-Host '  claude plugin list'
}

# robocopy reports success with exit codes 0-7 (1 = files copied); without this line
# the process exit code would stay 1 and every caller would read a false failure.
exit 0
