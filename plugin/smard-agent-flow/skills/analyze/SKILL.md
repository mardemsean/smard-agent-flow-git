---
name: analyze
description: Equivalent of /speckit.analyze in the smard-agent-flow-git method. Read-only check of the chain intent -> requirement -> decision -> spec criterion -> task -> PR/check -> release -> observation, pointing out gaps, duplications and conflicts between sources. Use before ratifying, delegating or integrating.
argument-hint: "[document, requirement or bridge to check]"
---

# /smard-agent-flow:analyze

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. `docs/workflow-producao/WORKFLOW.md`, section on the documentary set (the traceability chain).
3. `docs/workflow-producao/CONTRATO-DOCUMENTAL.md`
4. The artifacts of the chain that exist: ZERO/requirement, PREFLIGHT-ADR, PONTE, the executor's specs and tasks, PR, DEL.

## Artifact

A report in the chat, without altering any file: for each link of the chain, present/absent,
divergences, duplication of specs/tasks (RULES R6), ratification voided by a later edit (R3)
and material conflicts between sources. Every finding carries its source and is marked as evidence or interpretation.

## Limits

- Read-only. Corrections are proposed to the operator, never applied here.
- The absence of a document without a trigger is not a defect (RULES R5); do not propose an empty file.
- A material conflict is made explicit, never resolved in silence (AGENTS.md).

Operator input: $ARGUMENTS