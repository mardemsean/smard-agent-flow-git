# Repository tree and root-file addendum

**State:** approved by the operator on 2026-10-18 as the target tree of this repository. Folders exist now, empty, with `.gitkeep`; root files listed in section 3 are foreseen, not yet written. Nothing here is to be improvised: each file is written when its trigger occurs (see `docs/production-workflow/DOCUMENTARY-CONTRACT.md`, section 5).

**Role of this repository (operator, 2026-10-18):** once its documentary structure and tree are finished, this repository becomes the house's first standard model for every existing and new repository.

## 1. Tree

| Path | Purpose | State |
| --- | --- | --- |
| `METHODOLOGY.md`, `RULES.md`, `AGENTS.md`, `INDEX.md`, `README.md`, `explore.md`, `specs.md`, `adrZERO.md` | the method, in English | present |
| `docs/production-workflow/` | canonical docs, prompts, templates of the method | present |
| `docs/requirements/` | `REQUIREMENT-ZERO.MD` and `requirement-NNNN.md` of this repository as a product | reserved |
| `docs/explorations/` | `EXP-NNNN.md` | reserved |
| `docs/decisions/` and `docs/adr/` | `ADR-NNNN.md` (one of the two names will be kept when the first ADR lands) | reserved |
| `docs/specs/` | native documents of the chosen executor | reserved |
| `docs/deliveries/` | `DEL-NNNN.md` | reserved |
| `docs/plans/`, `docs/windows/` | implementation plans; Windows notes | reserved |
| `plugin/smard-agent-flow/` | the plugin: `.claude-plugin/plugin.json`, `skills/`, `method/` (packaged copy), reserved `commands/`, `agents/`, `hooks/`, `rules/`, `scripts/`, `assets/` | present |
| `plugin/README.md`, `install.ps1`, `sync-method.ps1`, `test.ps1` | install routes, bundle sync, static tests | present |
| `.claude-plugin/marketplace.json` | marketplace `smard-agent-flow-marketplace` | present |
| `.claude/commands/`, `.claude/settings.json`, `.claude/skills/` | project command, repository settings, repository skills | present |
| `commands/`, `agents/`, `hooks/`, `rules/`, `scripts/`, `assets/`, `templates/`, `tests/` | root-level components for the day the whole repository is the plugin (section 4) | reserved |
| `.github/ISSUE_TEMPLATE/`, `.github/workflows/` | intake templates; CI that runs `plugin/test.ps1`, `sync-method.ps1 -Check` and the link check | reserved |
| `.kirocrew/` | Kiro Crew adapter | reserved |
| `.antigravity-plugin/`, `.codex-plugin/`, `.cursor-plugin/`, `.hermes-plugin/`, `.kimi-plugin/`, `.opencode/`, `.pi/`, `.agents/` | per-harness adapters, mirroring superpowers 7.0.0 | reserved |

## 2. Reference repositories read

- superpowers 7.0.0 (obra): local install, tree listed on 2026-10-18; source of the adapter folder names, `hooks/run-hook.cmd`, `docs/`, `scripts/`, `tests/`, `assets/`.
- ECC 2.2.3 (affaan-m/everything-claude-code): README read on 2026-10-18 (agents, skills, commands, hooks, rules, memory, security scanner); its tree was not fetched file by file.

## 3. Root files foreseen (addendum)

| File | Trigger (per the documentary contract) |
| --- | --- |
| `LICENSE` | licensing decision by the rights holder before distribution under a declared license |
| `CHANGELOG.md` or `RELEASE-NOTES.md` | before announcing a version with impact on users |
| `CONTRIBUTING.md` | before opening contribution to other people or agents |
| `SECURITY.md` | before making the plugin available to external users |
| `CODE_OF_CONDUCT.md` | before opening a community under that policy |
| `SUPPORT.md` | before inviting users to depend on the plugin |
| `CODEOWNERS` | when review routing by owners is adopted |
| `.github/PULL_REQUEST_TEMPLATE.md` | when standardizing PR evidence helps review (the DEL block) |
| `GEMINI.md`, `gemini-extension.json` | when the Gemini adapter is adopted |
| `package.json` | when a pi or opencode adapter is adopted |
| `.gitattributes` | before the first cross-platform clone issue with line endings |
| `.pre-commit-config.yaml` | when local hooks (anti-exfil gate, link check) are standardized |
| `.version-bump.json` | when release automation is adopted |
| `llms.txt` | when documentation is published on the web |
| `CLAUDE.md` | only as an adapter routing to the canonical rules, if adopted |

## 4. Whole repository as the plugin

Decision deferred to publication (operator, 2026-10-18): the plugin lives under `plugin/smard-agent-flow/` today, with the marketplace pointing there. When the repository itself becomes the plugin, `plugin.json` moves to `.claude-plugin/` at the root and the component folders of section 1 become live. Whether method documents can be kept out of the installed plugin ("invisibilized") is to be checked in the official docs then; if not possible, it is resolved at publication.