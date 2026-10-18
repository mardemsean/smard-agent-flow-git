---
name: constitution
description: Equivalent of /speckit.constitution in the smard-agent-flow-git method. Constitutes a repository or baseline by deriving principles from the canonical sources, with an origin map, without replacing RULES or the REQUIREMENT-ZERO. Use when the operator asks to constitute a repo, fix a baseline or "project principles".
argument-hint: "[repository or context to constitute]"
---

# /smard-agent-flow:constitution

Pointer. The policy lives in the method's repository (ROOT below); do not redefine it here.

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing; otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`.
All relative paths below start from the ROOT. If neither exists, tell the operator and stop.

## Read before acting (mandatory)

1. The general route: `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1:
   `AGENTS.md`, `METHODOLOGY.md`, `RULES.md`, `INDEX.md`.
2. `docs/workflow-producao/BASELINE-METODO.md`
3. `docs/workflow-producao/templates/CONSTITUICAO-REPOSITORIO.md`
4. `docs/workflow-producao/CONTRATO-DOCUMENTAL.md` (visible elaboration protocol)
5. `docs/workflow-producao/ADAPTACAO-SPECKIT.md`, section 6 (the executor's constitution = explicit derivation)
6. Policies already existing in the target repository, if any.

## Artifact

A `CONSTITUICAO-REPOSITORIO` proposal following the template, with a contextual inventory and
an origin map for each principle. The proposal is shown in the chat before it becomes a file.
The persisted file is a draft until human ratification (RULES R3).

## Limits (source: AGENTS.md, Boundaries; RULES R1, R2, R3, R6, R8)

- Do not replace RULES, METHODOLOGY or the ZERO; do not create a parallel policy.
- Do not create a repository, grant access, enable CI or install anything because of the template.
- Do not write `.specify/memory/constitution.md` nor run the Spec Kit executor: the integration
  is not implemented and the pilot is not authorized.

Operator input: $ARGUMENTS