# Inventory of capabilities and integrations — coordinate 0.5.0

**State/date:** 2026-10-24
**Responsible:** the operator; built by the SMARD Drive Index coordinator session
**Elaboration in the chat:** built 2026-10-24 by the SMARD Drive Index coordinator session under the subagent-driven method with per-task review; the operator's election of each point is recorded by the skill itself
**Scope:** the plugin `smard-agent-flow`, version 0.5.0

## 1. Contextual catalog

| ID / type | Purpose and trigger | Origin / version | Location and scope | Real state / evidence | Responsible |
| --- | --- | --- | --- | --- | --- |
| `coordinate` / skill | Survey the sessions of a multi-session project, propose a retake plan, and record the operator's election | Plugin 0.5.0 | `plugin/smard-agent-flow/skills/coordinate/` | Proposed, available and verified in the plugin's tests | The operator |
| `coordinate-surveyor` / agent | Read-only survey that returns a tagged situation report; model `claude-opus-5-5`, chosen by the measurement of 2026-10-24 | Plugin 0.5.0 | `plugin/smard-agent-flow/agents/coordinate-surveyor.md` | Proposed, available and verified in the plugin's tests | The operator |
| `coordinate-reviewer` / agent | Read-only review of the retake plan; model `inherit`, pending a second measurement | Plugin 0.5.0 | `plugin/smard-agent-flow/agents/coordinate-reviewer.md` | Proposed, available and verified in the plugin's tests; model choice pending | The operator |

Authorization of use is recorded separately; none is inferred from these states.

## 2. Contract of the adopted capability

**Inputs, outputs and generated documents:** the project's coordination configuration and session records in; a tagged situation report, a retake plan, cards, messages, receipts and chain lines out. Pages for reading are HTML + React; Markdown is a machine payload only.
**Canonical sources and readings per action:** SESSION-MEMORY, DOCUMENTARY-RATIFICATION and CAPABILITIES-INTEGRATIONS, plus the project's coordination configuration.
**Tools, access and external effects:** both agents are read-only. The ELECT step writes only cards, messages, receipts, chain lines and task renames, and never deletes.
**Authorizations required and delegated limits:** the operator elects; the operator's words are quoted in the election record. No agent ratifies for the operator.
**Secrets:** none handled or stored.
**Installation, registration and ownership of the files:** ships with the plugin; the three files belong to the plugin.
**Resume, update, removal and preservation of data:** remove by deleting the three files and reverting the `plugin.json` version bump; data written by ELECT stays in the project.
**Verified compatibility and evidence of operation:** Claude Code plugin format; the full model id in the agent frontmatter is documented by Claude Code. Evidence: `skills/coordinate/tests/TEST-GREEN-2026-10-24.md`.
**Positive/negative tests and regression, when executable:** `test_schemas.sh`, `test_render.sh`, `run_surveyor_fixture.sh selftest`, `run_reviewer_sample.sh validate`, all under `skills/coordinate/tests/`.
**How the generated documents will be presented in the chat:** a link to the HTML + React page; the chat carries the answer and the next action only.

## 3. Decision and maintenance

**Alternatives and justification:** inheriting the session model for the surveyor was rejected because the measurement of 2026-10-24 favored `claude-opus-5-5`; the reviewer inherits until a second measurement exists.
**Risks, limitations and conflicts with existing integrations:** the reviewer model is unmeasured; no known conflict with the other ten skills.
**Effective decision, authority and revision:** proposed; takes effect when the operator merges the 0.5.0 release.
**Reassessment conditions and responsible person:** after the second measurement of the reviewer model, or on any change of the agent frontmatter; the operator.
**References to the implementation and evidence:** `plugin/smard-agent-flow/skills/coordinate/`, `plugin/smard-agent-flow/agents/`, `plugin/smard-agent-flow/skills/coordinate/tests/TEST-GREEN-2026-10-24.md`.
