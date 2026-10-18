---
description: Routes the work through the smard-agent-flow-git method (from discomfort to production) - points to the documentary contract, the template and the right rule for each action, without redefining policy.
---

# /smard-agent-flow

Short entry point of the method. Do not redefine policy here: the source is the canonical repository.

## ROOT of the method (first match wins)

1. The plugin skill `smard-agent-flow:method` is loaded: invoke it and follow it literally. It resolves the ROOT itself
   (`${user_config.method_repo}` if set, otherwise the copy of the method packaged in the plugin).
2. The plugin is not loaded and the current working directory is a clone of the method repository
   (`AGENTS.md`, `METHODOLOGY.md`, `RULES.md`, `INDEX.md` and `docs/workflow-producao/` present): ROOT = the current working directory.
   This is the case in a Claude Code cloud session of `mardemsean/smard-agent-flow-git`.
3. Otherwise read `skills/smard-agent-flow/skills/method/SKILL.md` under the Claude Code configuration folder
   (`CLAUDE_CONFIG_DIR`, by default `~/.claude`), where `install.ps1` places the plugin; its packaged copy of the method is `skills/smard-agent-flow/method/` in the same folder.
4. None exists: tell the operator and stop; do not improvise the rules.

## Then, in this order

1. Read, at the ROOT: `AGENTS.md`, `METHODOLOGY.md`, `RULES.md`, `INDEX.md`.
   A material conflict between sources is made explicit to the operator, never resolved in silence.
2. Read the contract of the requested action (route table in `AGENTS.md`; the summary is in the `method` skill).

Remote (private): `mardemsean/smard-agent-flow-git`.

## Boundaries (source: `AGENTS.md`, section Boundaries)

- Do not fill in human approval, do not generate documentation in silence, do not treat a merge as generic ratification.
- Do not create a repository, publish, grant access, install skills or MCPs, or enable CI on the basis of a template alone.
- Every documentary elaboration is shown in the chat before it becomes a file.
- The compaction hook, automatic session recovery and the Specify integration do NOT exist. Do not claim otherwise.

Operator input: $ARGUMENTS
