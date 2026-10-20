---
name: method
description: Use when exploring a software idea, creating or altering the method's documents, founding requirements, deciding architecture, specifying, delegating, opening a PR, delivering or handing off a session in the smard-agent-flow-git flow (discomfort to production). Indicates which canonical documents to read before acting.
---

# smard-agent-flow: router of the method

This skill is only a pointer. The policy lives in the canonical repository; do
not redefine it here nor from memory.

- Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
- Remote (private): `mardemsean/smard-agent-flow-git`

All relative paths below start from the ROOT. If neither exists, tell the
operator and stop; do not improvise the rules.

## 1. Always, when starting

Read, in this order: `AGENTS.md`, `METHODOLOGY.md`, `RULES.md`, `INDEX.md`
(all at the repository root). A material conflict between sources is made
explicit to the operator, never resolved in silence.

## 2. Then read the contract of the action

Paths relative to the repository root. The full table and the expected evidence
are in `AGENTS.md`; this is only the route.

| Action | Read |
| --- | --- |
| Explore an intent | `docs/production-workflow/WORKFLOW.md`, `docs/production-workflow/prompts/accompanied-exploration.md`, `docs/production-workflow/templates/EXPLORATION.md` |
| Create or alter a document | `docs/production-workflow/DOCUMENTARY-CONTRACT.md` (visible elaboration protocol) |
| Found or change an intent | `docs/production-workflow/templates/REQUIREMENT-ZERO.MD`, `docs/production-workflow/templates/requirement-NNNN.md` |
| Constitute a repository or baseline | `docs/production-workflow/METHOD-BASELINE.md`, `docs/production-workflow/templates/REPOSITORY-CONSTITUTION.md` |
| Architectural decision | `docs/production-workflow/templates/PREFLIGHT-ADR.md` |
| Specify or delegate | `docs/production-workflow/SPECKIT-ADAPTATION.md`, `docs/production-workflow/templates/SPECS-TASKS-BRIDGE.md`, `docs/production-workflow/templates/DOCUMENTARY-RATIFICATION.md` |
| Alter a prompt, skill, MCP or adapter | `docs/production-workflow/METHOD-BASELINE.md`, `docs/production-workflow/templates/CAPABILITIES-INTEGRATIONS.md` |
| Open a PR, integrate or release | `docs/production-workflow/templates/LEARNING-DELIVERY.md` (DEL record) |
| Hand off or resume a session | `docs/production-workflow/SESSION-MEMORY.md`, `docs/production-workflow/templates/SESSION-CHECKPOINT.md`, `docs/production-workflow/templates/PASSAGE-RECORD.md` |

## 3. Boundaries (summary; the source is `AGENTS.md`, section Boundaries)

- Do not fill in human approval, do not generate documentation in silence, do not
  treat a merge as generic ratification.
- Do not create a repository, publish, grant access, install skills or MCPs, or
  enable CI on the basis of a template alone.
- Every documentary elaboration is shown in the chat before it becomes a file.

## 4. What does not exist yet

The compaction hook, automatic session recovery and the Specify integration are
not implemented; the Spec Kit pilot is not authorized. Do not claim otherwise.
This plugin installs no hooks and executes nothing.