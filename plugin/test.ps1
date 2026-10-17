# Static tests for the smard-agent-flow plugin. PowerShell 7. Exit 0 = all green.
param([switch]$Installed)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$repo = Split-Path $here -Parent
$src  = Join-Path $here 'smard-agent-flow'
$dest = Join-Path $env:USERPROFILE '.claude\skills\smard-agent-flow'
$fail = 0
function Check($name, [bool]$ok, $detail = '') {
    if ($ok) { Write-Host "PASS  $name" } else { Write-Host "FAIL  $name  $detail"; $script:fail++ }
}

$manifestPath = Join-Path $src '.claude-plugin\plugin.json'
Check 'manifest exists' (Test-Path $manifestPath)
$m = $null
try { $m = Get-Content $manifestPath -Raw | ConvertFrom-Json } catch { }
Check 'manifest is valid JSON' ($null -ne $m)
Check 'manifest name is kebab-case and equals folder' ($m.name -match '^[a-z0-9]+(-[a-z0-9]+)*$' -and $m.name -eq (Split-Path $src -Leaf))
Check 'manifest has version and description' (![string]::IsNullOrWhiteSpace($m.version) -and ![string]::IsNullOrWhiteSpace($m.description))

$extra = Get-ChildItem (Join-Path $src '.claude-plugin') -Force | Where-Object Name -ne 'plugin.json'
Check 'only plugin.json inside .claude-plugin' (@($extra).Count -eq 0)

$skillPath = Join-Path $src 'skills\method\SKILL.md'
Check 'skill exists' (Test-Path $skillPath)
$raw = [IO.File]::ReadAllBytes($skillPath)
Check 'skill has no UTF-8 BOM' (-not ($raw.Length -ge 3 -and $raw[0] -eq 0xEF -and $raw[1] -eq 0xBB -and $raw[2] -eq 0xBF))
$text = [Text.Encoding]::UTF8.GetString($raw)
$fm = [regex]::Match($text, '(?s)\A---\r?\n(.*?)\r?\n---\r?\n')
Check 'skill frontmatter present' $fm.Success
Check 'skill frontmatter has name and description' ($fm.Value -match '(?m)^name:\s*\S' -and $fm.Value -match '(?m)^description:\s*\S')

# every repo path the skill points to must exist
$paths = [regex]::Matches($text, '`((?:docs/|[A-Z]+\.md)[^`]*)`') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
$missing = @()
foreach ($p in $paths) {
    foreach ($one in ($p -split ',\s*')) {
        if (-not (Test-Path (Join-Path $repo $one))) { $missing += $one }
    }
}
Check "all $(@($paths).Count) referenced repo paths exist" (@($missing).Count -eq 0) ($missing -join '; ')

Check 'no undefined memory names in plugin' (@(Get-ChildItem $src -Recurse -File -Force | Select-String -Pattern 'cortex|hyperbrain-lesson|knowledge\.md').Count -eq 0)
Check 'plugin ships no hooks or executables' (-not (Test-Path (Join-Path $src 'hooks')) -and -not (Test-Path (Join-Path $src 'scripts')))

if ($Installed) {
    Check 'installed copy exists' (Test-Path (Join-Path $dest '.claude-plugin\plugin.json'))
    $a = Get-ChildItem $src  -Recurse -File -Force | Sort-Object FullName | ForEach-Object { '{0} {1}' -f $_.FullName.Substring($src.Length), (Get-FileHash $_.FullName).Hash }
    $b = if (Test-Path $dest) { Get-ChildItem $dest -Recurse -File -Force | Sort-Object FullName | ForEach-Object { '{0} {1}' -f $_.FullName.Substring($dest.Length), (Get-FileHash $_.FullName).Hash } } else { @() }
    Check 'installed copy is byte-identical to source' ((@($a) -join '|') -ceq (@($b) -join '|') -and @($a).Count -gt 0)
}

if ($fail -eq 0) { Write-Host 'ALL GREEN' } else { Write-Host "$fail FAILED" }
exit ([int]($fail -ne 0))
