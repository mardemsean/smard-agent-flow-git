# smard-agent-flow — *from discomfort to production*

A human-led software workflow for the age of autonomous agents. It accompanies a
person from a discomfort that still has no language — something wrong in the
world, a curiosity, a half-seen opportunity — all the way to the observed effects
of real software in use, without ever forcing that discomfort into a form before
it is ready.

## Why this exists

Every spec-kit and agentic flow quietly assumes the idea is already finished.
They hand the human one of three roles: supply the briefing, supervise the
commands, approve the merge. Each is a cage. Each starts *after* the hardest and
most human part is already over.

But software begins before the requirement — in brainstorming, exploration,
ideation, prototyping. That creative pre-flight is exactly what the kits skip.
And here is the twist that matters most now: when a machine can write the code,
the code stops being scarce. The scarce thing becomes the *choice*. The pre-flight
is the one stage that guarantees development, even when it runs autonomously,
still reflects human will, ideas, and choices.

So the developer changes what they are. They stop being a programmer and become a
**systems engineer** — the holder of intent, boundaries, and consequences, who
delegates the typing. The origin of the thing, not an input to it. The method's
word for that human is `HOMUS-FIATIVUM`: the source of the creative *let it be*.

## What it actually does

smard-agent-flow connects creative work to spec-driven and task-driven execution
without replacing your executor. Point it at Spec Kit, OpenSpec, or whatever runs
your tasks; it feeds that executor intent a human actually ratified, and brings
the results back into the product's cycle.

It gives you a cycle you can enter anywhere:

> exploration & ideation ↔ prototyping → intent synthesis → preflight → decisions
> & specs → tasks under a mandate → implementation & PR → review & merge →
> delivery → observation → new exploration

No ceremony is mandatory. A mature initiative can start further along. Pausing,
incubating, or deciding not to build are legitimate endings. A repository, a
product name, a branch — none of them are required to think.

What makes it trustworthy is what it refuses to blur. Three distinctions are
load-bearing and never collapse:

- **draft ≠ presented ≠ ratified** — a draft never authorizes its own execution.
- **merge ≠ approval ≠ deploy ≠ observed benefit** — green CI is not success in
  production.
- **evidence ≠ inference ≠ hypothesis ≠ observation** — a simulation is never
  mistaken for a measured fact.

Every document is born in view: the agent names its purpose in chat, shows its
substantive content, and keeps gaps and disagreements visible. Silence, a file's
existence, and a merge never ratify the agent's interpretation. Autonomy is real
but bounded — the agent runs inside a mandate and stops when it would exceed it.

## Honest about state

The method is in elaboration. Some pieces are **proposed, not built**, and this
README says so plainly: the precompact hook and automatic session recovery are
not implemented, and the Spec Kit integration is a future investigation that
installs or modifies nothing yet. The documents here do not activate automations
or change any repository's review, merge, or deploy policy.

## Start here

- [plugin/README.md](plugin/README.md) — the Claude Code plugin and marketplace: install routes,
  the ROOT rule of the skills, verification and release steps.
- [explore.md](explore.md) — the EXPLORE phase, stage by stage, and the story of the
  discomfort and the systems-engineer thesis, in the method's own voice.
- [specs.md](specs.md) — the method's own specification: invariants, states, and
  the document chain.
- [adrZERO.md](adrZERO.md) — ADR-0000, the foundational decision to wrap an
  executor rather than replace it.

Method docs (canonical sources):

- [METHODOLOGY.md](METHODOLOGY.md) — intent and the articulation of the cycle.
- [RULES.md](RULES.md) — the human-agent working rules.
- [WORKFLOW.md](docs/production-workflow/WORKFLOW.md) — the decision tree, states,
  passage criteria, and GitHub integration contract.

If you build with autonomous agents and you have felt the quiet wrongness of
being treated as a briefing machine for your own ideas — this is the flow that
puts you back at the origin. Try an exploration. Bring a discomfort. Keep the choice.
