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
| Explore an intent | `docs/workflow-producao/WORKFLOW.md`, `docs/workflow-producao/prompts/exploracao-acompanhada.md`, `docs/workflow-producao/templates/EXPLORACAO.md` |
| Create or alter a document | `docs/workflow-producao/CONTRATO-DOCUMENTAL.md` (visible elaboration protocol) |
| Found or change an intent | `docs/workflow-producao/templates/REQUIREMENT-ZERO.MD`, `docs/workflow-producao/templates/requirement-NNNN.md` |
| Constitute a repository or baseline | `docs/workflow-producao/BASELINE-METODO.md`, `docs/workflow-producao/templates/CONSTITUICAO-REPOSITORIO.md` |
| Architectural decision | `docs/workflow-producao/templates/PREFLIGHT-ADR.md` |
| Specify or delegate | `docs/workflow-producao/ADAPTACAO-SPECKIT.md`, `docs/workflow-producao/templates/PONTE-SPECS-TAREFAS.md`, `docs/workflow-producao/templates/RATIFICACAO-DOCUMENTAL.md` |
| Alter a prompt, skill, MCP or adapter | `docs/workflow-producao/BASELINE-METODO.md`, `docs/workflow-producao/templates/CAPACIDADES-INTEGRACOES.md` |
| Open a PR, integrate or release | `docs/workflow-producao/templates/ENTREGA-APRENDIZADO.md` (DEL record) |
| Hand off or resume a session | `docs/workflow-producao/MEMORIA-SESSOES.md`, `docs/workflow-producao/templates/CHECKPOINT-SESSAO.md`, `docs/workflow-producao/templates/REGISTRO-PASSAGEM.md` |

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