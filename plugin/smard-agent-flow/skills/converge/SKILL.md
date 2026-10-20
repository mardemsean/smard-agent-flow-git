---
name: converge
description: Equivalent of /speckit.converge in the smard-agent-flow-git method. Confronts what was built with the requirement, the ADRs and the bridge's coverage map, returns gaps as a proposal and prepares the DEL record of delivery and learning. Use when opening a PR, integrating, releasing or closing a cycle.
argument-hint: "[bridge, PR or release to assess]"
---

# /smard-agent-flow:converge

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. The current SPECS-TASKS-BRIDGE (coverage map, commitments without coverage, changes during execution).
3. `docs/production-workflow/templates/LEARNING-DELIVERY.md`
4. `docs/production-workflow/WORKFLOW.md`, sections on PRs/issues and on closing the cycle.
5. Review and release rules existing in the target repository (AGENTS.md, row "Open a PR, integrate or release").

## Artifact

1. Confrontation in the chat: each commitment of the coverage map -> observed evidence or gap.
2. Gaps become a proposal to alter the bridge or a new requirement, shown to the operator; nothing is
   attached in silence (RULES R2, R3).
3. A DEL record proposal following the template, separating PR, review, merge, build, deploy and
   observed benefit (R8). The cycle closes only with observation, not with a merge.

## Limits

- A merge is not generic ratification; a green CI is not agreement (R3).
- An agent's hypothesis or opinion is not equivalent to empirical observation (R9).
- Do not open a PR, merge, publish or release without an authorization in force.

Operator input: $ARGUMENTS