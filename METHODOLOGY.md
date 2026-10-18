# Methodology — from discomfort to production

**State:** design authorized for elaboration; operational details remain
proposed wherever no explicit decision exists.
**Scope:** this laboratory develops the method; its infrastructure does not
automatically constitute the product a future exploration may originate.
**Origin:** dialogue of 2026-10-16 on continuity between creation, specification
and delivery. Authorization to proceed does not ratify future technical choices.

## Intent

To accompany the human from a discomfort that still has no language to the
effects of software in use. To articulate creative exploration, spec-driven
development and task-driven execution without reducing the person to a supplier
of briefings, a supervisor of commands or an approver of merges.

## Cycle and entry points

Exploration and ideation ↔ prototyping → intent synthesis → preflight and
simulations proportional to risk → decisions and specs → tasks under a mandate →
implementation and PR → review and merge → delivery → observation and new
exploration.

This is not a mandatory sequence of ceremonies. One may start further along when
there is enough maturity and evidence; returning, incubating or not building are
legitimate outcomes. The birth of the repository is independent of the maturity
of the intent. A product name, a repo and a branch are not prerequisites for
thinking.

The [canonical workflow](docs/workflow-producao/WORKFLOW.md) holds the decision
tree, the states, the transition criteria, the position of the human and the
contract of integration with GitHub. This file is its entry door, not a second,
competing definition of the cycle.

## Documents that accompany maturation

`REQUIREMENT-ZERO.MD` founds and accompanies the intent of the product between
exploration and formalization. The `requirement-NNNN.md` files represent later
changes, including proposed amendments to the foundation. ADRs record material
decisions; specs establish verifiable contracts; tasks organize execution, they
replace neither intent nor verification.

The [documentary contract](docs/workflow-producao/CONTRATO-DOCUMENTAL.md) is the
source of triggers, responsibilities and evidence. The agent makes each document
explicit in the chat before drafting it and presents its substantive content
afterwards. Draft, presentation, human response and ratification are different
states.

## Infrastructure and executors

The method, its rules, prompts and templates may exist in a workspace that
precedes the product repository. The [baseline](docs/workflow-producao/BASELINE-METODO.md)
defines their proportional incorporation. Specific tools receive adapters, not
competing versions of the policy.

Spec Kit or another executor may receive matured requirements and decisions and
return specs, plans, tasks and evidence. The technical route and the version
still need to be verified; this design neither installs nor modifies the
executor.

## Evolution of the method itself

Changes follow the [rules](RULES.md), with visible discussion and provenance.
Experience of use may justify simplification or revision. Do not convert empty
templates, completed stages or documentary volume into a measure of maturity.
Real roles, limits of autonomy, the executor and remote integration policies
remain dependent on contextualized decisions.