---
name: tasks
description: Equivalent of /speckit.tasks in the smard-agent-flow-git method. Assembles the SPECS-TASKS-BRIDGE - coverage map from the ratified requirement to the executor's canonical specs and tasks, discovered commitments and a bounded autonomy mandate. Use when specifying or delegating execution.
argument-hint: "[ratified requirement and chosen executor]"
---

# /smard-agent-flow:tasks

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. The ratified requirement and the applicable ADRs (AGENTS.md, row "Specify or delegate").
3. `docs/production-workflow/templates/SPECS-TASKS-BRIDGE.md`
4. `docs/production-workflow/templates/DOCUMENTARY-RATIFICATION.md`
5. `docs/production-workflow/SPECKIT-ADAPTATION.md` (continuous dialogue, segmented execution, ratification binding)
6. `docs/production-workflow/WORKFLOW.md`, sections on the mandate and the documentary set.

## Artifact

A SPECS-TASKS-BRIDGE proposal in the chat: revision of the ratified requirement, ADRs, chosen executor,
canonical specs and tasks **referenced, not copied** (RULES R6), coverage map,
commitments without coverage and the autonomy mandate. The mandate is valid only after human ratification (R3).

## Limits

- Do not duplicate the executor's specs or tasks in the bridge.
- Do not run the Spec Kit executor nor send a `resume`/`approve` verdict: an act exclusive to the human (R3);
  integration not implemented, pilot not authorized.
- Do not edit `state.json` or `inputs.json` of any engine.

Operator input: $ARGUMENTS