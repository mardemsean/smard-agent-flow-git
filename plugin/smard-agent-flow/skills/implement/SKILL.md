---
name: implement
description: Equivalent of /speckit.implement in the smard-agent-flow-git method. Executes a bounded segment of tasks under an autonomy mandate already ratified in the SPECS-TASKS-BRIDGE, with positive and negative evidence. Only by explicit invocation of the operator.
argument-hint: "[ratified bridge and segment to execute]"
disable-model-invocation: true
---

# /smard-agent-flow:implement

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/smard-agent-flow/SKILL.md`, section 1.
2. The ratified SPECS-TASKS-BRIDGE and its autonomy mandate; the ratification receipt.
3. `docs/production-workflow/WORKFLOW.md`, section on mandate and interruption.
4. `docs/production-workflow/SPECKIT-ADAPTATION.md` (segmented execution; "assisted" level)
5. Technical contract, configuration and tests of the altered area (AGENTS.md, row "Alter deterministic execution").

## Stop before starting if

- there is no ratified bridge, or it was edited after ratification (RULES R3);
- the assurance level is "assisted" for implementing (SPECKIT-ADAPTATION);
- the requested segment exceeds the mandate.

## Artifact

A segment executed within the mandate, with proportional positive and negative coverage and,
for a fix, demonstration of the defect and of the absence of regression (RULES R7). A report in the
chat of what was done, what was actually tested and what remained open.

## Limits

- Interrupt the affected action in the face of a conflict of intent, a new material risk, an overstepping
  of scope or an agreed limit; continue the independent work still authorized (RULES R4).
- An unexecuted test is not evidence (R7). PR, merge, deploy and benefit are distinct events (R8).
- Do not send `resume`/`approve` to any engine nor edit `state.json`/`inputs.json` (R3).

Operator input: $ARGUMENTS