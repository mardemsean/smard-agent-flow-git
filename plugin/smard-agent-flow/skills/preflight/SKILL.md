---
name: preflight
description: Equivalent of /speckit.plan in the smard-agent-flow-git method. Prepares an architectural decision (preflight and ADR) from a ratified requirement, with alternatives, consequences and an identifiable decision. Use before specifying or delegating technical work.
argument-hint: "[reference requirement and decision to take]"
---

# /smard-agent-flow:preflight

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. The current requirement and the pertinent earlier decisions (ADRs) (AGENTS.md, row "Take an architectural decision").
3. `docs/workflow-producao/templates/PREFLIGHT-ADR.md`
4. `docs/workflow-producao/CONTRATO-DOCUMENTAL.md`
5. Technical contracts, manifests and tests of the affected area (AGENTS.md, "Execution in the repository").

## Artifact

A PREFLIGHT-ADR proposal in the chat: alternatives, consequences, risks and an identifiable decision,
each statement marked as evidence, interpretation or suggestion (RULES R2). The decision belongs to the
human; the persisted file is a draft until ratification (R3).

## Limits

- Without a ratified requirement, stop and point to `/smard-agent-flow:specify`.
- Readings about Specify are requirements to investigate, not evidence of implementation (AGENTS.md).
- Do not alter code or configuration in this step.

Operator input: $ARGUMENTS