# Installs smard-agent-flow as a personal skills-dir plugin (loads as smard-agent-flow@skills-dir). PowerShell 7.
# Copies only; never deletes. Re-run after editing the source to update the installed copy.
$ErrorActionPreference = 'Stop'
$src  = Join-Path $PSScriptRoot 'smard-agent-flow'
$dest = Join-Path $env:USERPROFILE '.claude\skills\smard-agent-flow'
if (Test-Path $dest) {
    $existing = Join-Path $dest '.claude-plugin\plugin.json'
    if (-not (Test-Path $existing) -or (Get-Content $existing -Raw | ConvertFrom-Json).name -ne 'smard-agent-flow') {
        throw "Refusing to overwrite ${dest}: it is not the smard-agent-flow plugin."
    }
}
robocopy $src $dest /E /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed with exit code $LASTEXITCODE" }
Write-Host "Installed to $dest"
