# smard-agent-flow plugin for Claude Code

Ten namespaced skills (`/smard-agent-flow:method`, `:clarify`, `:specify`, `:preflight`, `:constitution`,
`:tasks`, `:implement`, `:analyze`, `:converge`, `:handoff`) plus the short entry command `/smard-agent-flow`.
The plugin is a pointer to the method: it installs no hooks, no agents, no MCP servers and executes nothing.

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

### Script, no marketplace (Windows, PowerShell 7)

```powershell
pwsh -NoProfile -File .\plugin\install.ps1
```

Installs as `smard-agent-flow@skills-dir`; `-WhatIf` previews, `-Uninstall` removes.

## Layout

| Path | Role |
| --- | --- |
| `.claude-plugin/marketplace.json` (repo root) | Marketplace `smard-agent-flow-marketplace`, one plugin entry with source `./plugin/smard-agent-flow` |
| `plugin/smard-agent-flow/` | The plugin: `.claude-plugin/plugin.json`, `skills/<name>/SKILL.md`, `method/` (packaged copy of the method) |
| `plugin/smard-agent-flow/method/` | Byte-identical copy of the 28 canonical documents (root documents, README set, grill-me skill, docs/production-workflow), so the skills work without a clone of this repository and every relative link inside the copy resolves |
| `plugin/sync-method.ps1` | Refreshes the packaged copy from the repo root; `-Check` exits 1 on any drift. Run it after editing a canonical document |
| `plugin/install.ps1` | Fallback install without a marketplace (`@skills-dir`), plus the user command |
| `plugin/test.ps1` | Static tests; `-Installed` also compares the installed copy |
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
```

Plugin validation runs on the operator's own terminal.

## Releasing a change

1. Edit the canonical documents at the repo root, never the packaged copy.
2. `pwsh -NoProfile -File .\plugin\sync-method.ps1`, then `test.ps1`.
3. Bump `version` in `plugin/smard-agent-flow/.claude-plugin/plugin.json`; marketplace users receive updates only when it changes.

## Other harnesses

The skills are plain Markdown with two plugin variables (`${CLAUDE_PLUGIN_ROOT}`, `${user_config.method_repo}`).
A harness without plugin substitution needs those two resolved at install time to the installed folder; the
packaged copy under `method/` makes that a copy operation. Not done in this version.
