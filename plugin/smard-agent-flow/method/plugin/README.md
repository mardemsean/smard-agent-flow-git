# smard-agent-flow plugin for Claude Code

Twelve namespaced skills (`/smard-agent-flow:smard-agent-flow`, `:clarify`, `:specify`, `:preflight`, `:constitution`,
`:tasks`, `:implement`, `:analyze`, `:converge`, `:handoff`, `:coordinate`, `:dont-speak-alien`) plus the short entry command `/smard-agent-flow`.
The plugin is a pointer to the method: it installs no hooks and no MCP servers, executes nothing by itself (the `coordinate` and `dont-speak-alien` skills ship helper scripts the session runs explicitly), and ships two read-only agents (coordinate-surveyor, coordinate-reviewer) used by `:coordinate`.

## Install

### Marketplace (recommended, any machine with Claude Code)

```text
/plugin marketplace add mardemsean/smard-agent-flow-git
/plugin install smard-agent-flow@smard-agent-flow-marketplace
```

The repository is private: the clone uses the machine's git credentials (`gh auth login` or SSH key),
as the official docs state for private marketplaces. After install, optionally set the local clone
override: `/plugin` > smard-agent-flow > settings > `method_repo` = path of a local clone.

### Repository settings (teammates, after trusting the folder)

Add to `.claude/settings.json` in any repository where the method is used:

```json
{
  "extraKnownMarketplaces": {
    "smard-agent-flow-marketplace": {
      "source": {
        "source": "github",
        "repo": "mardemsean/smard-agent-flow-git"
      }
    }
  },
  "enabledPlugins": {
    "smard-agent-flow@smard-agent-flow-marketplace": true
  }
}
```

When a teammate trusts the folder, the marketplace is added and the plugin is installed automatically.

### Cloud sessions (claude.ai)

Cloud sessions do not install plugins declared through `extraKnownMarketplaces`. In a cloud session
of this repository the method is available through the committed `.claude/commands/smard-agent-flow.md`
entry command, and the clone itself is the ROOT.

### Windows installer (from a release)

Download `SMardAgentFlow-Setup-<version>.exe` from the release and run it. It installs for the current user,
asks for no administrator rights, shows its pages in English or Brazilian Portuguese, and adds an entry to the
list of installed apps, from which it is removed. Silent install: `SMardAgentFlow-Setup-<version>.exe /S`.
It follows the contract of `install.ps1` below: the same two destinations, the same refusal, the same backup.

The installer is not digitally signed, so Windows SmartScreen can show a warning (More info > Run anyway).
To check the file against `SHA256SUMS.txt` of the release: `Get-FileHash .\SMardAgentFlow-Setup-<version>.exe`.

### ZIP (from a release)

Extract `smard-agent-flow-<version>-windows.zip` and double-click `Install.cmd`; it runs `install.ps1` with
PowerShell 7 when present, otherwise with Windows PowerShell. `Uninstall.cmd` removes.

### Node.js

```text
npx github:mardemsean/smard-agent-flow-git
```

Or, with the package file of a release: `npm install -g .\smard-agent-flow-<version>.tgz`, then `smard-agent-flow`
(`uninstall`, `--dry-run`, `--help`). The package is not on the npm registry: `package.json` is marked private
until the owner decides to publish it there.

### winget (prepared, not yet available)

`packaging/winget/` holds the manifest templates of `SMardLabs.SMardAgentFlow`, and each release carries them
filled in (`winget-manifest-<version>.zip`). `winget install SMardLabs.SMardAgentFlow` works only after the
repository is public and the manifests are accepted in `microsoft/winget-pkgs`.

### Script from a clone (Windows, PowerShell 7)

```powershell
pwsh -NoProfile -File .\plugin\install.ps1
```

Installs as `smard-agent-flow@skills-dir`; `-WhatIf` previews, `-Uninstall` removes.

### What was checked, and where

The Node installer and `install.ps1` were run on Linux (the second with a stand-in for `robocopy`), and the
Windows installer was run under Wine: install, upgrade, refusal, uninstall. A run on a real Windows machine is
the operator's validation before a release is published.

## Layout

| Path | Role |
| --- | --- |
| `.claude-plugin/marketplace.json` (repo root) | Marketplace `smard-agent-flow-marketplace`, one plugin entry with source `./plugin/smard-agent-flow` |
| `plugin/smard-agent-flow/` | The plugin: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `method/` (packaged copy of the method) |
| `plugin/smard-agent-flow/method/` | Byte-identical copy of the 31 canonical files (root documents, README set, LICENSE, grill-me skill, docs/production-workflow), so the skills work without a clone of this repository and every relative link inside the copy resolves |
| `plugin/sync-method.ps1` | Refreshes the packaged copy from the repo root; `-Check` exits 1 on any drift. Run it after editing a canonical document |
| `plugin/install.ps1` | Fallback install without a marketplace (`@skills-dir`), plus the user command |
| `plugin/test.ps1` | Static tests; `-Installed` also compares the installed copy |
| `packaging/build.ps1` | Builds the release files into `dist/`: Windows installer, ZIP, npm package, winget manifests, checksums. Publishes nothing |
| `packaging/windows/`, `packaging/npm/`, `packaging/winget/` | NSIS script and ZIP launchers; Node installer and its tests; winget manifest templates |
| `package.json` (repo root) | Makes the repository installable with `npx`; its version must equal the plugin version |
| `.claude/commands/smard-agent-flow.md` (repo root) | The entry command. Loaded as a project command in any clone, including cloud sessions of this repository |

## ROOT of the method (the rule every skill follows)

1. `${user_config.method_repo}` when the user set it and the path exists (a local clone, always current).
2. Otherwise `${CLAUDE_PLUGIN_ROOT}/method`, the packaged copy (as current as the installed plugin version).

The entry command, which is not a plugin component and gets no substitution, adds two cases: the current
working directory when it is a clone of this repository (cloud sessions), and the `@skills-dir` install folder.

## Verify

```powershell
pwsh -NoProfile -File .\plugin\test.ps1
pwsh -NoProfile -File .\plugin\sync-method.ps1 -Check
npm test
```

`npm test` runs the tests of the Node installer. Plugin validation runs on the operator's own terminal.

## Releasing a change

1. Edit the canonical documents at the repo root, never the packaged copy.
2. `pwsh -NoProfile -File .\plugin\sync-method.ps1`, then `test.ps1`.
3. Bump `version` in `plugin/smard-agent-flow/.claude-plugin/plugin.json` and in `package.json`; marketplace users receive updates only when it changes.
4. For a release with installers: add the version to `CHANGELOG.md`, run `pwsh -NoProfile -File .\packaging\build.ps1`
   (needs NSIS 3 and npm), run the installer on Windows, then attach the files of `dist/` to a GitHub release
   tagged `v<version>`.

## Other harnesses

The skills are plain Markdown with two plugin variables (`${CLAUDE_PLUGIN_ROOT}`, `${user_config.method_repo}`).
A harness without plugin substitution needs those two resolved at install time to the installed folder; the
packaged copy under `method/` makes that a copy operation. Not done in this version.
