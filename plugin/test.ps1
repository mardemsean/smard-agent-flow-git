# Static tests for the smard-agent-flow plugin and its marketplace. PowerShell 7. Exit 0 = all green.
param([switch]$Installed)
$ErrorActionPreference = 'Stop'
$here = $PSScriptRoot
$repo = Split-Path $here -Parent
$src  = Join-Path $here 'smard-agent-flow'
$cfg  = if ($env:CLAUDE_CONFIG_DIR) { $env:CLAUDE_CONFIG_DIR } else { Join-Path $env:USERPROFILE '.claude' }
$dest = Join-Path $cfg 'skills\smard-agent-flow'
$fail = 0
function Check($name, [bool]$ok, $detail = '') {
    if ($ok) { Write-Host "PASS  $name" } else { Write-Host "FAIL  $name  $detail"; $script:fail++ }
}
function Test-NoBom($path) {
    $raw = [IO.File]::ReadAllBytes($path)
    -not ($raw.Length -ge 3 -and $raw[0] -eq 0xEF -and $raw[1] -eq 0xBB -and $raw[2] -eq 0xBF)
}
function Get-Frontmatter($path) {
    [regex]::Match([IO.File]::ReadAllText($path), '(?s)\A---\r?\n(.*?)\r?\n---\r?\n')
}

# --- plugin manifest -------------------------------------------------------------------------
$manifestPath = Join-Path $src '.claude-plugin\plugin.json'
Check 'manifest exists' (Test-Path $manifestPath)
Check 'manifest has no UTF-8 BOM' (Test-NoBom $manifestPath)
$m = $null
try { $m = Get-Content $manifestPath -Raw | ConvertFrom-Json } catch { }
Check 'manifest is valid JSON' ($null -ne $m)
Check 'manifest name is kebab-case and equals folder' ($m.name -match '^[a-z0-9]+(-[a-z0-9]+)*$' -and $m.name -eq (Split-Path $src -Leaf))
Check 'manifest has version and description' (![string]::IsNullOrWhiteSpace($m.version) -and ![string]::IsNullOrWhiteSpace($m.description))
Check 'manifest declares user_config method_repo as non-sensitive' ($m.userConfig.method_repo.sensitive -eq $false)
$extra = Get-ChildItem (Join-Path $src '.claude-plugin') -Force | Where-Object Name -ne 'plugin.json'
Check 'only plugin.json inside .claude-plugin' (@($extra).Count -eq 0)

# --- marketplace at the repo root ------------------------------------------------------------
$mkPath = Join-Path $repo '.claude-plugin\marketplace.json'
Check 'marketplace.json exists at repo root' (Test-Path $mkPath)
Check 'marketplace.json has no UTF-8 BOM' (Test-NoBom $mkPath)
$mk = $null
try { $mk = Get-Content $mkPath -Raw | ConvertFrom-Json } catch { }
Check 'marketplace.json is valid JSON' ($null -ne $mk)
Check 'marketplace name is kebab-case' ($mk.name -match '^[a-z0-9]+(-[a-z0-9]+)*$')
Check 'marketplace has owner.name' (![string]::IsNullOrWhiteSpace($mk.owner.name))
$entry = @($mk.plugins | Where-Object name -eq $m.name)
Check 'marketplace lists the plugin once' (@($entry).Count -eq 1)
Check 'marketplace source is a ./ relative path to the plugin folder' ($entry[0].source -is [string] -and $entry[0].source -like './*' -and (Test-Path (Join-Path $repo $entry[0].source '.claude-plugin\plugin.json')))
Check 'marketplace entry does not pin a second version' ($null -eq $entry[0].version)

# --- skills ----------------------------------------------------------------------------------
$skills = @(Get-ChildItem (Join-Path $src 'skills') -Directory | ForEach-Object { Join-Path $_.FullName 'SKILL.md' })
Check 'twelve skills present' (@($skills).Count -eq 12) "found $(@($skills).Count)"
Check 'router skill exists' (Test-Path (Join-Path $src 'skills\smard-agent-flow\SKILL.md'))
$bad = @()
foreach ($s in $skills) {
    if (-not (Test-Path $s)) { $bad += "$s missing"; continue }
    if (-not (Test-NoBom $s)) { $bad += "$s BOM" }
    $fm = Get-Frontmatter $s
    if (-not $fm.Success) { $bad += "$s no frontmatter"; continue }
    if ($fm.Value -notmatch '(?m)^name:\s*\S' -or $fm.Value -notmatch '(?m)^description:\s*\S') { $bad += "$s name/description" }
    $folder = Split-Path (Split-Path $s -Parent) -Leaf
    if ([regex]::Match($fm.Value, '(?m)^name:\s*(\S+)').Groups[1].Value -ne $folder) { $bad += "$s name differs from folder" }
}
Check 'every skill has frontmatter with name = folder and description, no BOM' (@($bad).Count -eq 0) ($bad -join '; ')

# every repo path the method skill points to must exist at the root AND in the packaged copy
$text = [IO.File]::ReadAllText((Join-Path $src 'skills\smard-agent-flow\SKILL.md'))
$paths = [regex]::Matches($text, '`((?:docs/|[A-Z]+\.md)[^`]*)`') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique
$missing = @()
foreach ($p in $paths) {
    foreach ($one in ($p -split ',\s*')) {
        if (-not (Test-Path (Join-Path $repo $one))) { $missing += "root: $one" }
        if (-not (Test-Path (Join-Path $src 'method' $one))) { $missing += "bundle: $one" }
    }
}
Check "all $(@($paths).Count) referenced repo paths exist at the root and in the packaged copy" (@($missing).Count -eq 0) ($missing -join '; ')

# --- packaged copy of the method -------------------------------------------------------------
$four = @('AGENTS.md', 'METHODOLOGY.md', 'RULES.md', 'INDEX.md') | ForEach-Object { Test-Path (Join-Path $src 'method' $_) }
Check 'packaged copy method/ exists with the four root documents' ($four -notcontains $false)
& (Join-Path $here 'sync-method.ps1') -Check *> $null
Check 'sync-method.ps1 -Check exits 0 (no drift)' ($LASTEXITCODE -eq 0)
$broken = @()
foreach ($f in Get-ChildItem (Join-Path $src 'method') -Recurse -File -Include *.md, *.MD) {
    foreach ($mt in [regex]::Matches([IO.File]::ReadAllText($f.FullName), '\]\((?![A-Za-z][A-Za-z0-9+.-]*:)([^)#:]+)')) {
        $target = Join-Path $f.DirectoryName $mt.Groups[1].Value
        if (-not (Test-Path $target)) { $broken += "$($f.Name) -> $($mt.Groups[1].Value)" }
    }
}
Check 'no broken relative link inside the packaged copy' (@($broken).Count -eq 0) ($broken -join '; ')

# --- entry command ---------------------------------------------------------------------------
$cmd = Join-Path $repo '.claude\commands\smard-agent-flow.md'
Check 'entry command exists at .claude/commands' (Test-Path $cmd)
$cmdText = if (Test-Path $cmd) { [IO.File]::ReadAllText($cmd) } else { '' }
Check 'entry command has frontmatter with description' ((Test-Path $cmd) -and (Get-Frontmatter $cmd).Value -match '(?m)^description:\s*\S')
Check 'entry command has no machine-specific path' ($cmdText -notmatch '(?i)[A-Z]:\\|%USERPROFILE%|\\Users\\')
Check 'no plugin/commands-user directory (non-standard)' (-not (Test-Path (Join-Path $here 'commands-user')))

# --- hygiene ---------------------------------------------------------------------------------
# The packaged copy is a byte copy of the canonical documents (SESSION-MEMORY.md legitimately names the three registers as non-existent); only the plugin's own skills are checked.
Check 'no undefined memory names in plugin skills' (@(Get-ChildItem (Join-Path $src 'skills') -Recurse -File -Force | Select-String -Pattern 'cortex|hyperbrain-lesson|knowledge\.md').Count -eq 0)
$exec = @(Get-ChildItem $src -Recurse -File -Force | Where-Object Extension -in '.ps1', '.cmd', '.bat', '.sh', '.js', '.py' |
    Where-Object FullName -notmatch '\\skills\\(coordinate|dont-speak-alien)\\')
$agentsNonMd = @(Get-ChildItem (Join-Path $src 'agents') -File -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { $_.Extension -ne '.md' -and $_.Name -ne '.gitkeep' })
$reserved = @('hooks','scripts') | ForEach-Object { Get-ChildItem (Join-Path $src $_) -File -Recurse -Force -ErrorAction SilentlyContinue | Where-Object Name -ne '.gitkeep' }
Check 'plugin ships no hooks or stray executables (agents are .md only; helper scripts confined to coordinate/dont-speak-alien skills)' (@($reserved).Count -eq 0 -and $exec.Count -eq 0 -and @($agentsNonMd).Count -eq 0)

if ($Installed) {
    Check 'installed copy exists' (Test-Path (Join-Path $dest '.claude-plugin\plugin.json'))
    $a = Get-ChildItem $src  -Recurse -File -Force | Sort-Object FullName | ForEach-Object { '{0} {1}' -f $_.FullName.Substring($src.Length), (Get-FileHash $_.FullName).Hash }
    $b = if (Test-Path $dest) { Get-ChildItem $dest -Recurse -File -Force | Sort-Object FullName | ForEach-Object { '{0} {1}' -f $_.FullName.Substring($dest.Length), (Get-FileHash $_.FullName).Hash } } else { @() }
    Check 'installed copy is byte-identical to source' ((@($a) -join '|') -ceq (@($b) -join '|') -and @($a).Count -gt 0)
    $cmdDest = Join-Path $cfg 'commands\smard-agent-flow.md'
    Check 'installed user command is byte-identical to source' ((Test-Path $cmdDest) -and ((Get-FileHash $cmdDest).Hash -eq (Get-FileHash $cmd).Hash))
}

if ($fail -eq 0) { Write-Host 'ALL GREEN' } else { Write-Host "$fail FAILED" }
exit ([int]($fail -ne 0))
