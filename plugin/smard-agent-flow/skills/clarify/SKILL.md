---
name: clarify
description: Equivalent of /speckit.clarify in the smard-agent-flow-git method. Accompanied exploration and interview (grill me), one question at a time, to resolve ambiguity of intent, requirement or decision before ratifying. Use when there is an open doubt or the operator asks to be questioned.
argument-hint: "[topic, document or requirement to clarify]"
---

# /smard-agent-flow:clarify

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/smard-agent-flow/SKILL.md`, section 1.
2. `docs/production-workflow/WORKFLOW.md` (invariants; grill me with an agreed goal and stop condition)
3. `docs/production-workflow/prompts/accompanied-exploration.md`
4. `docs/production-workflow/templates/EXPLORATION.md`
5. `.claude/skills/grill-me/SKILL.md` of the ROOT (form of the interview)
6. The target document, if the operator indicated one.

## Artifact

Before the first question: goal and stop condition agreed with the operator.
At the end: a visible synthesis in the chat of decisions, gaps and disagreements. An `EXPLORACAO`
file or a requirement delta only by trigger and with the proposal shown beforehand (RULES R2, R5).

## Limits

- Exploration requires no product name, repo, branch or issue (RULES R1) and does not become a ticket.
- The operator's answer in an interview is not ratification (RULES R3).
- Do not fill in answers by inference; an unanswered question stays open.

Operator input: $ARGUMENTS