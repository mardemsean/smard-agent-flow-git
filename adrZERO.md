# ADR-0000 — smard-agent-flow is a human-led flow that wraps spec/task execution

**Status:** proposed — Accepted (foundational decision for the method itself).
**Date:** 2026-10-16 (origin dialogue). Authorization to proceed does not ratify
future technical choices.
**Scope:** the method as elaborated in this laboratory, not any product it may
later originate.

## Context

Existing spec-kits and agentic flows begin at the requirement. Read against the
method's own thesis, they reduce the human to one of three roles —
briefing-supplier, command-supervisor, or merge-approver — and skip the creative
pre-flight entirely: brainstorming, exploration, ideation, prototyping.

In the agentic era this gap is the expensive one. When an executor can produce
code autonomously, the scarce and decisive act is the human *choice* of what to
build, why, and within which boundaries. `METHODOLOGY.md` states the intent as
accompanying the human "from a discomfort that still has no language to the effects of
software in use," without reducing the person to a briefing supplier, a command
supervisor, or a merge approver. `WORKFLOW.md` (§1) is explicit that the method
"does not replace an executor such as Spec Kit or OpenSpec: it defines the
context, the intent and the boundaries that executor receives, and how its
results return to the product cycle."

A foundational decision is therefore required: should the method *be* an executor
(competing with Spec Kit), or should it be the human-led flow that *feeds* an
executor ratified intent?

## Decision

smard-agent-flow is built as a **human-led flow that wraps spec-driven and
task-driven execution** — it does not replace an executor, it feeds one ratified
intent and consumes its results back into the product cycle.

Concretely, this fixes:

1. **A pre-flight the executor never sees as the method's own territory.** The
   states Exploration, Exploratory prototyping, and Intent synthesis
   (`WORKFLOW.md` §4) exist upstream of any requirement an executor would accept.
2. **A ratification boundary at the handoff.** Only a human-ratified requirement
   and the ADRs it needs cross into Specification and Execution. The executor
   receives matured intent, not raw discomfort (`METHODOLOGY.md`, "Infrastructure and
   executors").
3. **The method owns no second copy of the executor's artifacts.** Invariant 10
   of `WORKFLOW.md` and R6 of `RULES.md` require one canonical source per
   responsibility; the method keeps references and a coverage map, not duplicated
   specs or tasks.
4. **A chain that outlives the executor.** intention → requirement → decision →
   spec criterion → task → PR/check → release → observation, so the executor is a
   replaceable segment, not the spine.

## Alternatives considered

| Alternative | Why not |
| --- | --- |
| **Build the method as a competing executor** (own spec/task engine) | Contradicts `WORKFLOW.md` §1 ("does not replace an executor") and R6's single-canonical-source rule; would duplicate mature tooling and leave the pre-flight gap unaddressed. |
| **Adopt a spec-kit as-is** | Leaves the human in the three reduced roles the method exists to reject; the creative pre-flight stays unowned. |
| **Fork a spec-kit and bolt pre-flight on** | Couples the method to one executor's version and architecture; `AGENTS.md` requires verifying the executor's version, docs, extension architecture, and tests before any modification — a coupling this decision avoids by keeping the executor replaceable. |
| **Make documentation ceremony the product** | Violates Invariants 9 and 10 (infrastructure/catalog ≠ maturity) and R5 (documents by trigger, not a full checklist at entry). |

## Consequences

**Positive**

- The creative pre-flight becomes first-class, protecting human will in
  autonomous development (the method's central thesis).
- The executor stays swappable; Spec Kit, OpenSpec, or another can be chosen
  later without rewriting the method.
- Traceability and the distinctions draft ≠ presented ≠ ratified and merge ≠
  approval ≠ deploy ≠ observed benefit are enforced at the method level, not left
  to any single tool.

**Negative / costs**

- The method must maintain a clean coverage map and reference layer instead of
  owning artifacts directly — more discipline at the handoff.
- The actual executor choice and its artifact mapping remain **open decisions**
  for the product owner (`WORKFLOW.md` §10).

**Explicitly deferred and not implemented** (per the source):

- The Spec Kit integration is a **proposed** future investigation; this design
  neither installs nor modifies the executor, and the Specify reading is a
  requirement to investigate, not evidence of implementation (`AGENTS.md`).
- The **precompact hook** and **automatic session recovery** are **not
  implemented** (`AGENTS.md`, `INDEX.md`, R10).
- The GitHub Actions checks named in `WORKFLOW.md` §8 are an **interface design**,
  not jobs that exist in this repository.
