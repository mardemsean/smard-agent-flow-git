#requires -Version 5.1
<#
.SYNOPSIS
  Harness-agnostic installer for the SMard Agent Flow plugin (Windows, PowerShell 5.1+).
.DESCRIPTION
  Reads packaging\harnesses.json and installs the packaged plugin into the harnesses
  the operator chooses. One command per harness, or -All for every harness detected
  on this machine.

  Kinds of target:
    claude-plugin       the canonical Claude Code layout, via plugin\install.ps1
    skill-pack          one self-contained skill folder <dest>\smard-agent-flow
                        (router SKILL.md + skills-pack\ with the twelve skills +
                        method\ + agents\ + plugin.json); the router text is
                        rewritten for harness neutrality at install time
    agents              copies agents\*.md into an agents directory
    instructions-merge  merges a marked block into an instructions file
                        (existing content is kept; the block between the markers
                        is replaced on reinstall)

  Contract (same as plugin\install.ps1): copy, verify by hash, never remove what is
  not ours, back up what differs, refuse a foreign destination (identified by the
  marker file .smard-agent-flow written on install).
.EXAMPLE
  install-harness.ps1 -List
  install-harness.ps1 -Harness kimi-code
  install-harness.ps1 -All
  install-harness.ps1 -Uninstall -Harness kimi-code
#>
[CmdletBinding(SupportsShouldProcess)]
param(
  [string]$Harness,
  [switch]$All,
  [switch]$List,
  [switch]$Uninstall,
  [string]$Log
)
$ErrorActionPreference = 'Stop'
if ($Log) { Start-Transcript -Path $Log -Append -ErrorAction SilentlyContinue | Out-Null }

$homeDir = [Environment]::GetFolderPath('UserProfile')
$scriptDir = $PSScriptRoot
$manifestPath = Join-Path $scriptDir 'harnesses.json'
if (-not (Test-Path $manifestPath)) { throw "harnesses.json not found next to this script: $manifestPath" }
$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

# Payload root: repo layout (packaging\ next to plugin\) or ZIP layout (files\packaging\ next to files\payload).
$candidates = @(
  (Join-Path (Split-Path $scriptDir -Parent) 'plugin\smard-agent-flow'),
  (Join-Path (Split-Path $scriptDir -Parent) 'payload\plugin\smard-agent-flow')
)
$payload = $candidates | Where-Object { Test-Path (Join-Path $_ '.claude-plugin\plugin.json') } | Select-Object -First 1
if (-not $payload) { throw "Plugin payload not found. Tried: $($candidates -join '; ')" }

function Resolve-Dest([string]$dest) {
  if ($dest.StartsWith('~/') -or $dest.StartsWith('~\')) { return Join-Path $homeDir $dest.Substring(2) }
  return $dest
}

function Get-TreeHashes($root) {
  Get-ChildItem $root -Recurse -File -Force | Sort-Object FullName |
    ForEach-Object { '{0} {1}' -f $_.FullName.Substring($root.Length), (Get-FileHash $_.FullName).Hash }
}

function Test-IsOurs($folder) {
  if (Test-Path (Join-Path $folder $manifest.marker)) { return $true }
  # Installations made before the marker existed carry plugin.json or a router SKILL.md
  # naming smard-agent-flow; both prove the folder is this plugin.
  $manifestFile = Join-Path $folder 'plugin.json'
  if ((Test-Path $manifestFile) -and ((Get-Content $manifestFile -Raw) -like '*"name": "smard-agent-flow"*')) { return $true }
  $skillFile = Join-Path $folder 'SKILL.md'
  if ((Test-Path $skillFile) -and ((Get-Content $skillFile -Raw) -like '*name: smard-agent-flow*')) { return $true }
  return $false
}

function Write-Router-Skill($destDir) {
  # Router SKILL.md rewritten for harness neutrality: no ${CLAUDE_PLUGIN_ROOT}, no ${user_config}.
  $router = Get-Content (Join-Path $payload 'skills\smard-agent-flow\SKILL.md') -Raw
  $router = $router -replace '(?m)^- Precedence of the ROOT:.*$', @'
- Precedence of the ROOT: a local clone of the method repository, if you have one
  and point this skill to it; otherwise the packaged copy "method" next to this
  SKILL.md.
'@.TrimEnd()
  $router = $router -replace '(?m)^- Remote \(private\):.*$', '- Remote: https://github.com/mardemsean/smard-agent-flow-git'
  New-Item -ItemType Directory -Force $destDir | Out-Null
  [IO.File]::WriteAllText((Join-Path $destDir 'SKILL.md'), $router, [Text.UTF8Encoding]::new($false))
  foreach ($sub in 'skills', 'method', 'agents') {
    $src = Join-Path $payload $sub
    if (Test-Path $src) {
      $name = if ($sub -eq 'skills') { 'skills-pack' } else { $sub }
      robocopy $src (Join-Path $destDir $name) /E /NFL /NDL /NJH /NJS /NP | Out-Null
      if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }
    }
  }
  Copy-Item (Join-Path $payload '.claude-plugin\plugin.json') (Join-Path $destDir 'plugin.json') -Force
  [IO.File]::WriteAllText((Join-Path $destDir $manifest.marker), "SMard Agent Flow plugin marker. Safe to overwrite/replace.`n", [Text.UTF8Encoding]::new($false))
}

function Install-SkillPack($target) {
  $base = Resolve-Dest $target.dest
  $destDir = Join-Path $base 'smard-agent-flow'
  Write-Host "Skill pack -> $destDir"
  if ($PSCmdlet.ShouldProcess($destDir, 'Install skill pack')) {
    if ((Test-Path $destDir) -and -not (Test-IsOurs $destDir)) { throw "Refusing to touch ${destDir}: it is not a SMard Agent Flow folder." }
    if (Test-Path $destDir) {
      $bak = "$destDir.bak-{0:yyyyMMdd-HHmmss}" -f (Get-Date)
      Rename-Item $destDir $bak
      Write-Host "Backup of the previous version: $bak"
    }
    Write-Router-Skill $destDir
    $a = @(Get-TreeHashes $destDir)
    if ($a.Count -lt 10) { throw 'Installed skill pack looks incomplete.' }
  }
}

function Uninstall-SkillPack($target) {
  $destDir = Join-Path (Resolve-Dest $target.dest) 'smard-agent-flow'
  if (-not (Test-Path $destDir)) { Write-Host "Not installed: $destDir"; return }
  if (-not (Test-IsOurs $destDir)) { Write-Host "Left untouched (not ours): $destDir"; return }
  Remove-Item $destDir -Recurse -Force
  Write-Host "Removed: $destDir"
}

function Install-Agents($target) {
  $base = Resolve-Dest $target.dest
  Write-Host "Agents -> $base"
  # Agents directories are shared namespaces (they hold the user's own agents too):
  # we add our two files, back up a differing copy of them, and never refuse the folder.
  $markerPath = Join-Path $base $manifest.marker
  New-Item -ItemType Directory -Force $base | Out-Null
  foreach ($f in Get-ChildItem (Join-Path $payload 'agents') -Filter *.md) {
    $dest = Join-Path $base $f.Name
    if ((Test-Path $dest) -and ((Get-FileHash $dest).Hash -ne (Get-FileHash $f.FullName).Hash)) {
      $bak = "$dest.bak-{0:yyyyMMdd-HHmmss}" -f (Get-Date)
      Copy-Item $dest $bak
      Write-Host "Backup: $bak"
    }
    Copy-Item $f.FullName $dest -Force
  }
  [IO.File]::WriteAllText($markerPath, "SMard Agent Flow agents marker.`n", [Text.UTF8Encoding]::new($false))
}

function Uninstall-Agents($target) {
  $base = Resolve-Dest $target.dest
  if (-not (Test-Path (Join-Path $base $manifest.marker))) { Write-Host "Not installed by us: $base"; return }
  foreach ($f in Get-ChildItem (Join-Path $payload 'agents') -Filter *.md) { Remove-Item (Join-Path $base $f.Name) -Force -ErrorAction SilentlyContinue }
  Remove-Item (Join-Path $base $manifest.marker) -Force -ErrorAction SilentlyContinue
  Write-Host "Agents removed from $base"
}

$blockBegin = '<!-- smard-agent-flow:begin -->'
$blockEnd = '<!-- smard-agent-flow:end -->'
function Get-InstructionsBlock {
  $blockFile = Join-Path $scriptDir 'copilot-instructions.block.md'
  if (-not (Test-Path $blockFile)) { $blockFile = Join-Path (Split-Path $scriptDir -Parent) 'windows\copilot-instructions.block.md' }
  if (-not (Test-Path $blockFile)) { throw 'copilot-instructions.block.md not found in the package.' }
  return (Get-Content $blockFile -Raw).Trim()
}

function Install-InstructionsMerge($target) {
  $dest = Resolve-Dest $target.dest
  $block = "{0}`n{1}`n{2}" -f $blockBegin, (Get-InstructionsBlock), $blockEnd
  Write-Host "Instructions -> $dest"
  New-Item -ItemType Directory -Force (Split-Path $dest) | Out-Null
  if (Test-Path $dest) {
    $current = Get-Content $dest -Raw
    if (-not $current) { $current = '' }
    if ($current -like "*$blockBegin*$blockEnd*") {
      $current = [regex]::Replace($current, [regex]::Escape($blockBegin) + '.*?' + [regex]::Escape($blockEnd), $block, 'Singleline')
      [IO.File]::WriteAllText($dest, $current, [Text.UTF8Encoding]::new($false))
      Write-Host 'Existing block replaced; the rest of the file is unchanged.'
    } else {
      $bak = "$dest.bak-{0:yyyyMMdd-HHmmss}" -f (Get-Date)
      Copy-Item $dest $bak
      [IO.File]::WriteAllText($dest, ($current.TrimEnd() + "`n`n" + $block + "`n"), [Text.UTF8Encoding]::new($false))
      Write-Host "Existing file kept and block appended. Backup: $bak"
    }
  } else {
    [IO.File]::WriteAllText($dest, ($block + "`n"), [Text.UTF8Encoding]::new($false))
  }
}

function Uninstall-InstructionsMerge($target) {
  $dest = Resolve-Dest $target.dest
  if (-not (Test-Path $dest)) { Write-Host "Not installed: $dest"; return }
  $current = Get-Content $dest -Raw
  if (-not $current) { Write-Host "Not installed (empty file): $dest"; return }
  if ($current -notlike "*$blockBegin*") { Write-Host "No SMard Agent Flow block in $dest"; return }
  $new = [regex]::Replace($current, "`n*" + [regex]::Escape($blockBegin) + '.*?' + [regex]::Escape($blockEnd) + "`n*", "`n")
  [IO.File]::WriteAllText($dest, $new.TrimStart(), [Text.UTF8Encoding]::new($false))
  Write-Host "Block removed from $dest (rest of the file kept)"
}

function Install-ClaudePlugin {
  $install = Join-Path (Split-Path $payload -Parent) 'install.ps1'
  if (-not (Test-Path $install)) { throw 'plugin\install.ps1 not found in the package.' }
  Write-Host "Claude Code -> plugin installer: $install"
  & $install
  if ($LASTEXITCODE -ne 0) { throw "plugin\install.ps1 failed with exit code $LASTEXITCODE" }
}

function Uninstall-ClaudePlugin {
  $install = Join-Path (Split-Path $payload -Parent) 'install.ps1'
  if (Test-Path $install) { & $install -Uninstall }
}

function Invoke-Harness($h, [switch]$Undo) {
  Write-Host ("`n=== {0} ({1}) ===" -f $h.name, $h.id)
  foreach ($t in $h.targets) {
    switch ($t.kind) {
      'claude-plugin'      { if ($Undo) { Uninstall-ClaudePlugin } else { Install-ClaudePlugin } }
      'skill-pack'         { if ($Undo) { Uninstall-SkillPack $t } else { Install-SkillPack $t } }
      'agents'             { if ($Undo) { Uninstall-Agents $t } else { Install-Agents $t } }
      'instructions-merge' { if ($Undo) { Uninstall-InstructionsMerge $t } else { Install-InstructionsMerge $t } }
      default { throw "Unknown target kind: $($t.kind)" }
    }
  }
}

if ($List) {
  foreach ($h in $manifest.harnesses) {
    $det = @()
    foreach ($t in $h.targets) { if ($t.dest) { $det += (Resolve-Dest $t.dest) } }
    $present = @($det | Where-Object { Test-Path $_ })
    $state = if ($det.Count -eq 0) { 'always available' }
             elseif ($present) { 'detected: ' + ($present -join '; ') }
             else { 'not detected on this machine' }
    '{0,-12} {1,-45} {2}' -f $h.id, $h.name, $state
  }
  Write-Host "`nNot applicable (no install step): " -NoNewline
  Write-Host (($manifest.notApplicable | ForEach-Object { $_.id }) -join ', ')
  return
}

$selected = @()
if ($Harness) {
  $selected = @($manifest.harnesses | Where-Object { $_.id -eq $Harness })
  if (-not $selected) { throw "Unknown harness '$Harness'. Use -List to see the ids." }
} elseif ($All) {
  $selected = @($manifest.harnesses | Where-Object {
    $h = $_
    $h.always -or @($h.targets | Where-Object { $_.dest -and (Test-Path (Resolve-Dest $_.dest)) }).Count -gt 0
  })
  Write-Host ("Installing into {0} harness(es): {1}" -f $selected.Count, ($selected.id -join ', '))
} else {
  throw 'Choose one: -Harness <id>, -All, or -List.'
}

$failed = @()
foreach ($h in $selected) {
  try { Invoke-Harness $h -Undo:$Uninstall }
  catch { Write-Warning ("{0}: {1}" -f $h.id, $_.Exception.Message); $failed += $h.id }
}
if ($failed) { throw "Failed: $($failed -join ', ')" }
Write-Host ''
if (-not $Uninstall) { Write-Host 'Done. Start a NEW session of the harness and invoke the smard-agent-flow skill (or /smard-agent-flow in Claude Code).' }
