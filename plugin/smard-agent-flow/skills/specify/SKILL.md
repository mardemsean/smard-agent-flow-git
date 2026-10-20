---
name: specify
description: Equivalent of /speckit.specify in the smard-agent-flow-git method. Founds or changes an intent as REQUIREMENT-ZERO or requirement-NNNN, before any executor spec. Use when the operator wants to record what is intended and why.
argument-hint: "[intent in free language, or the number of the requirement to revise]"
---

# /smard-agent-flow:specify

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. The current ZERO or requirement, if one exists, and the pertinent exploration (AGENTS.md, row "Found or change an intent").
3. `docs/production-workflow/templates/REQUIREMENT-ZERO.MD`
4. `docs/production-workflow/templates/requirement-NNNN.md`
5. `docs/production-workflow/DOCUMENTARY-CONTRACT.md`
6. `docs/production-workflow/WORKFLOW.md` (states and decision tree)

## Artifact

A traceable proposal of REQUIREMENT-ZERO (founding intent) or requirement-NNNN (change),
presented in full in the chat, separating human contribution, evidence, interpretation and
the agent's suggestion (RULES R2). Ratification is a human act before executing the new commitment (R3).

## Limits

- If the intent is not yet mature, do not force it: offer `/smard-agent-flow:clarify` (RULES R1, R5).
- Do not generate an executor spec nor run `specify`: integration not implemented, pilot not authorized.
- Do not invent decisions, research or consensus; gaps stay marked.

Operator input: $ARGUMENTS