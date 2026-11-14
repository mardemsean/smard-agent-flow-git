#requires -Version 7
<#
.SYNOPSIS
  Builds the release files of SMard Agent Flow into dist\ (Windows, Linux or macOS; PowerShell 7).
.DESCRIPTION
  The version comes from plugin\smard-agent-flow\.claude-plugin\plugin.json. The script writes:
    SMardAgentFlow-Setup-<version>.exe      Windows installer (NSIS; needs makensis on the PATH)
    smard-agent-flow-<version>-windows.zip  the plugin with Install.cmd and Uninstall.cmd
    smard-agent-flow-<version>.tgz          npm package with the Node installer
    winget-manifest-<version>.zip           winget manifests that point to the installer of the release
    SHA256SUMS.txt                          checksums of the four files
  It publishes nothing. The packaged copy of the method must be in sync (sync-method.ps1 -Check).
.EXAMPLE
  pwsh -NoProfile -File .\packaging\build.ps1
#>
[CmdletBinding()]
param([string]$OutDir)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repo   = Split-Path $PSScriptRoot -Parent
$plugin = Join-Path $repo 'plugin' 'smard-agent-flow'
$cmdSrc = Join-Path $repo '.claude' 'commands' 'smard-agent-flow.md'
$manifest = Get-Content (Join-Path $plugin '.claude-plugin' 'plugin.json') -Raw | ConvertFrom-Json
$version  = $manifest.version
$repoUrl  = $manifest.repository.TrimEnd('/')
$pkgVersion = (Get-Content (Join-Path $repo 'package.json') -Raw | ConvertFrom-Json).version
if ($pkgVersion -ne $version) { throw "package.json version $pkgVersion differs from plugin.json version $version." }

& (Join-Path $repo 'plugin' 'sync-method.ps1') -Check
if ($LASTEXITCODE -ne 0) { throw 'Packaged copy of the method differs from the repo root; run plugin\sync-method.ps1.' }

$makensis = (Get-Command makensis -ErrorAction SilentlyContinue)?.Source
if (-not $makensis -and $IsWindows) {
    $makensis = @(${env:ProgramFiles(x86)}, $env:ProgramFiles) | Where-Object { $_ } |
        ForEach-Object { Join-Path $_ 'NSIS' 'makensis.exe' } | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if (-not $makensis) { throw 'makensis not found. Install NSIS 3 (Windows: winget install NSIS.NSIS; Debian/Ubuntu: apt install nsis).' }

if (-not $OutDir) { $OutDir = Join-Path $repo 'dist' }
if (Test-Path $OutDir) { Remove-Item $OutDir -Recurse -Force }
$stage = Join-Path $OutDir 'stage'
New-Item -ItemType Directory -Force $stage | Out-Null
$OutDir = (Resolve-Path $OutDir).Path
$stage  = (Resolve-Path $stage).Path

function Get-RelativeFiles($root) {
    Get-ChildItem $root -Recurse -File -Force | ForEach-Object { [IO.Path]::GetRelativePath($root, $_.FullName) } | Sort-Object
}
function Copy-Tree($from, $to) {
    foreach ($rel in Get-RelativeFiles $from) {
        $target = Join-Path $to $rel
        New-Item -ItemType Directory -Force (Split-Path $target) | Out-Null
        Copy-Item -LiteralPath (Join-Path $from $rel) -Destination $target -Force
    }
}
# Text that Windows tools open: CRLF line ends; a BOM where Notepad must detect UTF-8.
function Write-WindowsText($path, $text, [switch]$Bom) {
    New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
    [IO.File]::WriteAllText($path, ($text -replace "`r?`n", "`r`n"), [Text.UTF8Encoding]::new([bool]$Bom))
}
function Expand-Tokens($text, $tokens) {
    foreach ($key in $tokens.Keys) { $text = $text.Replace("{{$key}}", $tokens[$key]) }
    if ($text -match '\{\{[A-Z_0-9]+\}\}') { throw "Unfilled token $($Matches[0])." }
    $text
}

$pluginFiles = @(Get-RelativeFiles $plugin)
$windows = Join-Path $PSScriptRoot 'windows'
$licenseTxt = Join-Path $stage 'LICENSE.txt'
Write-WindowsText $licenseTxt (Get-Content (Join-Path $repo 'LICENSE') -Raw)

# --- 1. ZIP with Install.cmd -----------------------------------------------------------------
$zipName = "smard-agent-flow-$version-windows"
$zipRoot = Join-Path $stage $zipName
$filesRoot = Join-Path $zipRoot 'files'
# Payload: the plugin (with its own install.ps1, the canonical Claude Code route), the entry
# command, and the harness-agnostic installer (manifest + engine + the Copilot block).
Copy-Tree $plugin (Join-Path $filesRoot 'payload' 'plugin' 'smard-agent-flow')
Copy-Item (Join-Path $repo 'plugin' 'install.ps1') (Join-Path $filesRoot 'payload' 'plugin' 'install.ps1')
New-Item -ItemType Directory -Force (Join-Path $filesRoot 'payload' 'commands') | Out-Null
Copy-Item $cmdSrc (Join-Path $filesRoot 'payload' 'commands' 'smard-agent-flow.md')
New-Item -ItemType Directory -Force (Join-Path $filesRoot 'packaging') | Out-Null
foreach ($f in 'harnesses.json', 'install-harness.ps1') {
    Copy-Item (Join-Path $PSScriptRoot $f) (Join-Path $filesRoot 'packaging' $f)
}
Copy-Item (Join-Path $windows 'copilot-instructions.block.md') (Join-Path $filesRoot 'packaging' 'copilot-instructions.block.md')

# Root launchers: the classic Claude pair plus one installer per harness and Install-All.
$cmdTemplate = @'
@echo off
setlocal
title SMard Agent Flow - Install {NAME}
if not exist "%~dp0files\packaging\install-harness.ps1" goto notextracted
set "PS=powershell"
where pwsh >nul 2>nul
if not errorlevel 1 set "PS=pwsh"
%PS% -NoProfile -ExecutionPolicy Bypass -File "%~dp0files\packaging\install-harness.ps1" -Harness {ID} %*
if errorlevel 1 goto failed
echo.
echo Done. Start a NEW session of {NAME} and invoke smard-agent-flow.
goto end
:notextracted
echo The files are not here. Extract the whole ZIP first: right-click the ZIP, choose "Extract All",
echo then run this file from the new folder.
goto end
:failed
echo.
echo The installation did not finish. Read the messages above.
:end
echo.
pause
'@
$harnesses = (Get-Content (Join-Path $PSScriptRoot 'harnesses.json') -Raw | ConvertFrom-Json).harnesses
foreach ($h in $harnesses) {
    $launcher = $cmdTemplate.Replace('{ID}', $h.id).Replace('{NAME}', $h.name)
    Write-WindowsText (Join-Path $zipRoot "Install-$($h.id).cmd") $launcher
}
foreach ($name in 'Install.cmd', 'Uninstall.cmd', 'Install-All.cmd') {
    Write-WindowsText (Join-Path $zipRoot $name) (Get-Content (Join-Path $windows $name) -Raw)
}
$uninstallAll = @'
@echo off
setlocal
title SMard Agent Flow - Uninstall everywhere
if not exist "%~dp0files\packaging\install-harness.ps1" goto notextracted
set "PS=powershell"
where pwsh >nul 2>nul
if not errorlevel 1 set "PS=pwsh"
%PS% -NoProfile -ExecutionPolicy Bypass -File "%~dp0files\packaging\install-harness.ps1" -All -Uninstall %*
if errorlevel 1 goto failed
goto end
:notextracted
echo The files are not here. Extract the whole ZIP first: right-click the ZIP, choose "Extract All",
echo then run this file from the new folder.
goto end
:failed
echo.
echo The removal did not finish. Read the messages above.
:end
echo.
pause
'@
Write-WindowsText (Join-Path $zipRoot 'Uninstall-All.cmd') $uninstallAll
Write-WindowsText (Join-Path $zipRoot 'READ-ME-FIRST.txt') -Bom `
    (Expand-Tokens (Get-Content (Join-Path $windows 'READ-ME-FIRST.txt') -Raw) @{ VERSION = $version })
Copy-Item $licenseTxt (Join-Path $zipRoot 'LICENSE.txt')
$zip = Join-Path $OutDir "$zipName.zip"
[IO.Compression.ZipFile]::CreateFromDirectory($zipRoot, $zip, 'Optimal', $true)

# --- 2. Windows installer --------------------------------------------------------------------
$fileList = Join-Path $stage 'files.nsh'
$lines = foreach ($group in (Get-RelativeFiles $filesRoot | Group-Object { Split-Path $_ })) {
    $sub = $group.Name.Replace('/', '\')
    'SetOutPath "$INSTDIR\files{0}"' -f $(if ($sub) { "\$sub" } else { '' })
    foreach ($rel in $group.Group) { 'File "{0}"' -f (Join-Path $filesRoot $rel) }
}
Set-Content -LiteralPath $fileList -Value $lines -Encoding utf8NoBOM
$exe = Join-Path $OutDir "SMardAgentFlow-Setup-$version.exe"
$sw = if ($IsWindows) { '/' } else { '-' }
& $makensis "${sw}V2" "${sw}INPUTCHARSET" 'UTF8' "${sw}DVERSION=$version" "${sw}DSRCROOT=$repo" "${sw}DFILELIST=$fileList" `
    "${sw}DLICENSEFILE=$licenseTxt" "${sw}DOUTFILE=$exe" (Join-Path $windows 'installer.nsi')
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $exe)) { throw "makensis failed with exit code $LASTEXITCODE." }

# --- 3. npm package --------------------------------------------------------------------------
Push-Location $repo
try { & npm pack --silent --pack-destination $OutDir | Out-Null } finally { Pop-Location }
$tgz = Join-Path $OutDir "smard-agent-flow-$version.tgz"
if ($LASTEXITCODE -ne 0 -or -not (Test-Path $tgz)) { throw 'npm pack failed.' }

# --- 4. winget manifests ---------------------------------------------------------------------
$tokens = @{
    VERSION          = $version
    REPO_URL         = $repoUrl
    RELEASE_DATE     = (Get-Date).ToUniversalTime().ToString('yyyy-MM-dd')
    INSTALLER_URL    = "$repoUrl/releases/download/v$version/$(Split-Path $exe -Leaf)"
    INSTALLER_SHA256 = (Get-FileHash $exe -Algorithm SHA256).Hash
}
$wingetRoot = Join-Path $stage 'winget'
$wingetDir  = Join-Path $wingetRoot 'manifests' 's' 'SMardLabs' 'SMardAgentFlow' $version
foreach ($template in Get-ChildItem (Join-Path $PSScriptRoot 'winget') -Filter *.yaml) {
    $text = (Expand-Tokens (Get-Content $template.FullName -Raw) $tokens) -replace "`r?`n", "`n"
    New-Item -ItemType Directory -Force $wingetDir | Out-Null
    [IO.File]::WriteAllText((Join-Path $wingetDir $template.Name), $text, [Text.UTF8Encoding]::new($false))
}
$wingetZip = Join-Path $OutDir "winget-manifest-$version.zip"
[IO.Compression.ZipFile]::CreateFromDirectory($wingetRoot, $wingetZip, 'Optimal', $false)

# --- 5. checksums ----------------------------------------------------------------------------
$assets = @($exe, $zip, $tgz, $wingetZip)
$sums = $assets | ForEach-Object { '{0}  {1}' -f (Get-FileHash $_ -Algorithm SHA256).Hash.ToLowerInvariant(), (Split-Path $_ -Leaf) }
[IO.File]::WriteAllText((Join-Path $OutDir 'SHA256SUMS.txt'), (($sums -join "`n") + "`n"), [Text.UTF8Encoding]::new($false))

Write-Host "Built SMard Agent Flow $version ($($pluginFiles.Count) plugin files) in $OutDir"
$assets + (Join-Path $OutDir 'SHA256SUMS.txt') | ForEach-Object { Write-Host ('  {0,10:N0}  {1}' -f (Get-Item $_).Length, (Split-Path $_ -Leaf)) }
