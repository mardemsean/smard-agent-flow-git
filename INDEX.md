# Canonical index of the method

This index maps responsibilities; it does not prove reading or approval.

## Entry and governance

| Source | Responsibility |
| --- | --- |
| [README](README.md) | Entry orientation and state of the laboratory |
| [Mission](MISSION.md) | Why the method exists; original in English, with a [Portuguese translation](MISSION.pt-BR.md) |
| [METHODOLOGY](METHODOLOGY.md) | Intent and articulation of the cycle |
| [RULES](RULES.md) | Human–agent working rules |
| [AGENTS](AGENTS.md) | Operational routing and readings per action |
| [Workflow](docs/production-workflow/WORKFLOW.md) | Tree, states, transitions and integration with delivery |
| [Documentary contract](docs/production-workflow/DOCUMENTARY-CONTRACT.md) | Triggers, evidence and visible elaboration |
| [Baseline](docs/production-workflow/METHOD-BASELINE.md) | Documentary constitution and conditional capabilities |
| [Prompts](docs/production-workflow/prompts/README.md) | Reusable interactions and state of the scripts |
| [Memory between sessions](docs/production-workflow/SESSION-MEMORY.md) | Two persistent records (`sledge-handoff.md`, `DIAMOND.md`), checkpoint and succession; hook not yet implemented |
| [Adaptation to Spec Kit](docs/production-workflow/SPECKIT-ADAPTATION.md) | Corrected preflight: dialogue, gates, ratification binding and segmented execution |
| [Coordinate capability](docs/production-workflow/capabilities/COORDINATE-0.5.0.md) | The plugin skill `coordinate` (shipped in the `smard-agent-flow` plugin, not in this method tree): survey, retake plan and election across sessions; reads [Memory between sessions](docs/production-workflow/SESSION-MEMORY.md), [Ratification receipt](docs/production-workflow/templates/DOCUMENTARY-RATIFICATION.md) and [Capabilities inventory](docs/production-workflow/capabilities/COORDINATE-0.5.0.md) |
| [Dont-speak-alien capability](docs/production-workflow/capabilities/DONT-SPEAK-ALIEN-0.6.0.md) | The plugin skill `dont-speak-alien` (shipped in the `smard-agent-flow` plugin, not in this method tree): rewrites a reply in Simplified Technical English with a literal Portuguese version, checked by a script |

## Available templates, not filled-in product documents

| Template | Trigger |
| --- | --- |
| [Exploration](docs/production-workflow/templates/EXPLORATION.md) | Preserve selected learning |
| [ZERO](docs/production-workflow/templates/REQUIREMENT-ZERO.MD) | Elaborate the foundation of the product |
| [Numbered requirement](docs/production-workflow/templates/requirement-NNNN.md) | Change or expansion of the intent |
| [Preflight and ADR](docs/production-workflow/templates/PREFLIGHT-ADR.md) | Examine risk and a material decision |
| [Execution bridge](docs/production-workflow/templates/SPECS-TASKS-BRIDGE.md) | Connect specs/tasks and the mandate |
| [Delivery and learning](docs/production-workflow/templates/LEARNING-DELIVERY.md) | Review, release and observe |
| [Constitution](docs/production-workflow/templates/REPOSITORY-CONSTITUTION.md) | Concrete need for a repo or incorporation |
| [Handoff](docs/production-workflow/templates/PASSAGE-RECORD.md) | Preserve a relevant decision or transition |
| [Capabilities and integrations](docs/production-workflow/templates/CAPABILITIES-INTEGRATIONS.md) | Adopt or modify a prompt, skill, MCP, agent or executor |
| [Session checkpoint](docs/production-workflow/templates/SESSION-CHECKPOINT.md) | Preserve and recover memory before compaction or handoff |
| [Ratification receipt](docs/production-workflow/templates/DOCUMENTARY-RATIFICATION.md) | Relate presented content, human response and authorized revision |

## Limits of the inventory

The index covers the method under elaboration; it does not certify all the
documentation or capabilities installed in the laboratory. Existing components
such as `.claude/` were not audited as integrations of the method. The presence of a file or directory does not
demonstrate activation, authorization or compatibility.