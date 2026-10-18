# smard-agent-flow — method specification (high level)

**State:** design authorized for elaboration. Operational details remain
*proposed* wherever no explicit decision exists. This document describes the
method itself, not a product built with it.

## 1. What smard-agent-flow is

smard-agent-flow is a human-led workflow — *from discomfort to production* — that
connects creative, exploratory work to spec-driven and task-driven execution. It
accompanies a person from a discomfort that still has no language all the way to the
observed effects of software in use.

It does **not** replace an executor such as Spec Kit or OpenSpec. It defines the
context, the intent, and the boundaries that such an executor receives, and how
its results return to the product cycle. The human is the author and interlocutor
of intent, the initial representative of future users, and the authority over
delegated commitments — not an inspector of every agent step.

The entry point for the method is `METHODOLOGY.md`; the canonical workflow (its
decision tree, states, and GitHub integration) lives in
`docs/workflow-producao/WORKFLOW.md`; the working rules are in `RULES.md`.

## 2. Invariants

Derived from the "Invariantes" section of `WORKFLOW.md`. These are binding
properties of the method, not features of any product.

| # | Invariant | What it means |
| --- | --- | --- |
| 1 | Companionship before accountability | A discomfort can be explored with no product name, economic justification, form, or obligation to continue. |
| 2 | Divergence is not a defect | Alternatives, contradictions, and discarded ideas can be useful knowledge; they are not automatically pending tasks. |
| 3 | Provocation has a context | A "grill me" session can be deliberately intense or a one-off intervention; its goal, intensity, and stop condition are agreed. It never becomes a permanent interrogation. |
| 4 | Learning is not promising | Prototypes and simulations do not authorize production implementation, nor turn hypotheses into observed evidence. |
| 5 | Entry is variable | A mature initiative can start further along, with provenance, boundaries, and gaps made explicit; it need not repeat rites that are no longer needed. |
| 6 | Autonomy has a boundary | The agent executes inside a mandate and stops when it exceeds it, not at every reversible local choice. |
| 7 | Disagreement does not vanish by summary | Syntheses distinguish human voice, agent interpretation, evidence, and decisions actually ratified. |
| 8 | Production reopens questions | Observed effects can trigger new explorations, requirements, and revisions of founding premises. |
| 9 | Infrastructure does not define maturity | Thinking requires no repository, product name, slug, or branch. Provisional technical identifiers may be generated without asking the human for an identity decision. |
| 10 | Documentation has an occasion | Each obligation needs a trigger, an owner, a consumer, and a consequence of absence; no full catalog is demanded at entry. The agent prepares records, it does not outsource filling them to the human as a condition of helping. |
| 11 | Documentation is born in view | Each document created or changed is made explicit in chat — purpose, substantive content, provenance, pending points. Drafting is not deciding; presenting is not proven awareness; silence, file existence, and merge do not ratify the agent's interpretations. |

## 3. States and minimal evidence

The method's states are states of *work*, not departments or mandatory
ceremonies. Each state can contain internal cycles. A gap blocks advance only
when it threatens the validity of the next decision.

| State | Allowed work | Condition to advance |
| --- | --- | --- |
| Exploration | Converse, diverge, research, simulate, question, pause | Human recognizes a direction worth synthesizing — not merely the agent declaring it done |
| Exploratory prototyping | Test use, feasibility, or another bounded hypothesis | Learning and limitations recorded; decide to discard, retry, or synthesize |
| Intent synthesis | Prepare `REQUIREMENT-ZERO.MD` or a numbered requirement | Recognizable intent, boundaries, gaps, and authority identified |
| Preflight | Examine candidate decisions and risks; test scenarios | Material risks examined; blocking gaps resolved and residual risks accepted |
| Commitment | Ratify requirement and accept necessary ADRs | Explicit record of the decision and of the ratified documentary revision |
| Specification | Describe behavior and verifiable criteria | Traceable coverage of intent; conflicts returned to preflight |
| Execution | Decompose and implement under a mandate | PR with evidence proportional to risk and applicable checks |
| Delivery | Review, integrate, release, and observe | Applicable authorizations, recovery strategy, and result signals |
| Learning | Compare real effects to expectations | Keep, fix a defect, open a change, or reconsider the foundation |

## 4. The document chain

The method's traceability runs as a chain, where one relation may have several
destinations:

```
intention → requirement (and its revision) → decision (ADR, when needed)
          → spec criterion → task → PR/check → release → observation
```

| Link | Document | Must not become |
| --- | --- | --- |
| intention | Exploration (`EXP-NNNN.md`) | A compulsory transcript or entry form |
| requirement (foundation) | `REQUIREMENT-ZERO.MD` | An immutable constitution, exhaustive PRD, or disguised architecture |
| requirement (change) | `requirement-NNNN.md` | An ID for every atomic requirement or implementation task |
| decision | `ADR-NNNN.md` (preflight + ADR) | A mandatory ritual for every change |
| spec criterion / task | Spec-to-task bridge | A second, divergent copy of the executor's specs and tasks |
| PR / release / observation | Delivery & learning (`DEL-NNNN.md`) | An assumption that merge equals production success |

Identity and versioning rules the method fixes:

- `REQUIREMENT-ZERO.MD` is unique per product. The sequence `0001`, `0002`, …
  identifies change initiatives, is not restarted by release, and does not
  replace ZERO versions.
- Ratification refers to a concrete revision — a SHA, PR, or equivalent
  identifiable record. A material text change requires fresh ratification;
  approving an earlier version does not authorize scope added later.
- A numbered requirement must declare whether it preserves, extends, or
  contradicts ZERO. Changing the foundation requires an explicit amendment to
  ZERO in the same revision set.

## 5. Distinctions the method keeps intact

These separations are load-bearing and must never collapse:

- **draft ≠ presented ≠ ratified.** A draft may be persisted as a draft; it does
  not authorize its own execution. Presenting content is not proven awareness.
  Ratification identifies scope, revision, and authority.
- **merge ≠ approval ≠ deploy ≠ observed benefit.** PR, review, merge, build,
  deploy, and observed benefit are distinct events. Merge does not automatically
  authorize production deploy; operational health does not demonstrate user
  benefit.
- **evidence ≠ inference ≠ hypothesis ≠ observation.** A simulated user
  conversation is not an interview; a scale projection is not a benchmark; a
  premortem is not an observed incident; another agent's opinion is not
  independent validation on its own.

## 6. GitHub integration (proposed, not installed)

`WORKFLOW.md` sketches an Actions contract — logical checks such as
`workflow-integrity`, `scope-policy`, engineering checks, an integration gate,
and a delivery gate. **These names are an interface design; they do not exist as
jobs in this repository.** The design configures no branch protection,
environments, merge queue, or access.

## 7. Explicitly proposed / not-yet-implemented

The source marks these as **proposed**, not implemented, and this spec repeats
that honestly:

- The **precompact hook** and **automatic session recovery** (`MEMORIA-SESSOES`)
  are not implemented.
- The **Spec Kit integration** is a future investigation; the technical route
  and version still need verification. This design neither installs nor modifies
  the executor.
- The Actions check names above are an interface, not running jobs.
- The following remain open decisions for the product owner: the specs/tasks
  executor and its artifact mapping; real roles and ratification authority;
  risk classification and required checks per context; merge, release, exception,
  and operational-observation policy.
