<div align="center">

<h1>SMard Agent Flow</h1>

<p><b><i>From Discomfort to Production</i></b></p>

<p>
A human-led software workflow for the age of autonomous agents.<br>
It connects creative exploration to the tool that runs your tasks, so that
development, even when it runs autonomously, still reflects human choices.
</p>

<p>
<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue" alt="License: MIT"></a>
<img src="https://img.shields.io/badge/status-in%20elaboration-orange" alt="Status: in elaboration">
<img src="https://img.shields.io/badge/Claude%20Code-plugin-555555" alt="Claude Code plugin">
</p>

<p>
<a href="#why-this-exists">Why</a> ·
<a href="#what-it-actually-does">What it does</a> ·
<a href="#the-cycle">The cycle</a> ·
<a href="#honest-about-state">State</a> ·
<a href="#get-started">Get started</a> ·
<a href="#method-docs-canonical-sources">Docs</a> ·
<a href="#attribution-and-license">License</a> ·
<a href="#author">Author</a>
</p>

</div>

---

SMard Agent Flow accompanies a person from a discomfort that still has no
language (something wrong in the world, a curiosity, a half-seen opportunity)
all the way to the observed effects of real software in use, without ever
forcing that discomfort into a form before it is ready.

## At a glance

| | |
| --- | --- |
| **The problem** | Spec kits and agentic flows assume the idea is already finished, and leave the human to brief, supervise, or approve. |
| **What you get** | A cycle from exploration to observation that you can enter anywhere, documents elaborated in view, and three distinctions that never collapse. |
| **How it ships** | A Claude Code plugin with a marketplace: twelve namespaced skills and two read-only agents, plus the short entry command `/smard-agent-flow`. |
| **Who it is for** | People who build software with autonomous coding agents and want to stay at the origin of the choice. |
| **What it does not do** | Replace your executor, install hooks or MCP servers, activate automations, or change any repository's review, merge, or deploy policy. |

## Why this exists

Every spec-kit and agentic flow quietly assumes the idea is already finished.
They hand the human one of three roles: supply the briefing, supervise the
commands, approve the merge. Each is a cage. Each starts *after* the hardest and
most human part is already over.

But software begins before the requirement — in brainstorming, exploration,
ideation, prototyping. That creative pre-flight is exactly what the kits skip.
And here is the twist that matters most now: when a machine can write the code,
the code stops being scarce. The scarce thing becomes the *choice*. The
pre-flight is the one stage that guarantees development, even when it runs
autonomously, still reflects human will, ideas, and choices.

So the developer changes what they are. They stop being a programmer and become
a **systems engineer** — the holder of intent, boundaries, and consequences, who
delegates the typing. The origin of the thing, not an input to it. The method's
word for that human is `HOMUS-FIATIVUM`: the source of the creative *let it be*.

## What it actually does

SMard Agent Flow connects creative work to spec-driven and task-driven execution
without replacing your executor. Point it at Spec Kit, OpenSpec, or whatever
runs your tasks; it feeds that executor intent a human actually ratified, and
brings the results back into the product's cycle.

### The cycle

It gives you a cycle you can enter anywhere:

```mermaid
flowchart TD
    A["Exploration and ideation"] <--> B["Prototyping"]
    B --> C["Intent synthesis"]
    C --> D["Preflight"]
    D --> E["Decisions and specs"]
    E --> F["Tasks under a mandate"]
    F --> G["Implementation and PR"]
    G --> H["Review and merge"]
    H --> I["Delivery"]
    I --> J["Observation"]
    J -->|"new exploration"| A
```

> exploration & ideation ↔ prototyping → intent synthesis → preflight → decisions
> & specs → tasks under a mandate → implementation & PR → review & merge →
> delivery → observation → new exploration

No ceremony is mandatory. A mature initiative can start further along. Pausing,
incubating, or deciding not to build are legitimate endings. A repository, a
product name, a branch — none of them are required to think.

### Three distinctions that never collapse

What makes it trustworthy is what it refuses to blur. Three distinctions are
load-bearing and never collapse:

| Distinction | What it protects |
| --- | --- |
| **draft ≠ presented ≠ ratified** | A draft never authorizes its own execution. |
| **merge ≠ approval ≠ deploy ≠ observed benefit** | Green CI is not success in production. |
| **evidence ≠ inference ≠ hypothesis ≠ observation** | A simulation is never mistaken for a measured fact. |

### Documents born in view

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

| Piece | State | Source |
| --- | --- | --- |
| The method documents | In elaboration: design authorized for elaboration; operational details proposed where no explicit decision exists | [METHODOLOGY.md](METHODOLOGY.md) |
| Claude Code plugin and marketplace | Packaged: twelve skills and two read-only agents; no hooks, no MCP servers | [plugin/README.md](plugin/README.md) |
| Precompact hook and automatic session recovery | Not implemented | [specs.md](specs.md), [SESSION-MEMORY.md](docs/production-workflow/SESSION-MEMORY.md) |
| Spec Kit integration | Future investigation; installs or modifies nothing yet | [specs.md](specs.md) |
| GitHub Actions checks named in the workflow | Interface design only; no such jobs exist in this repository | [specs.md](specs.md) |
| Review, merge, and deploy policy | Unchanged by the method: the design activates no automation and configures no branch protection, environments, or merge queue | [WORKFLOW.md](docs/production-workflow/WORKFLOW.md), [RULES.md](RULES.md) |

## Get started

### Install

In Claude Code, add the marketplace and install the plugin:

```text
/plugin marketplace add mardemsean/smard-agent-flow-git
/plugin install smard-agent-flow@smard-agent-flow-marketplace
```

The repository is private: the marketplace clone uses your machine's git
credentials. The other routes (repository settings for teammates, cloud
sessions, a script without a marketplace), the ROOT rule the skills follow, and
the verification and release steps are in [plugin/README.md](plugin/README.md).

### Start here

| Document | What you find there |
| --- | --- |
| [plugin/README.md](plugin/README.md) | The Claude Code plugin and marketplace: install routes, the ROOT rule of the skills, verification and release steps. |
| [explore.md](explore.md) | The EXPLORE phase, stage by stage, and the story of the discomfort and the systems-engineer thesis, in the method's own voice. |
| [specs.md](specs.md) | The method's own specification: invariants, states, and the document chain. |
| [adrZERO.md](adrZERO.md) | ADR-0000, the foundational decision to wrap an executor rather than replace it. |

## Method docs (canonical sources)

| Document | What it holds |
| --- | --- |
| [METHODOLOGY.md](METHODOLOGY.md) | Intent and the articulation of the cycle. |
| [RULES.md](RULES.md) | The human-agent working rules. |
| [WORKFLOW.md](docs/production-workflow/WORKFLOW.md) | The decision tree, states, passage criteria, and GitHub integration contract. |

---

If you build with autonomous agents and you have felt the quiet wrongness of
being treated as a briefing machine for your own ideas — this is the flow that
puts you back at the origin. Try an exploration. Bring a discomfort. Keep the
choice.

---

## Attribution and license

> [!NOTE]
> **Disclaimer.** The documentary part of this method that covers the workflow
> for Git and CI/CD was heavily inspired by GitHub's Spec-Driven Development
> workflow documentation, published with
> [GitHub Spec Kit](https://github.com/github/spec-kit)
> ([spec-driven.md](https://github.com/github/spec-kit/blob/main/spec-driven.md),
> [documentation site](https://github.github.com/spec-kit/)).

SMard Agent Flow is an independent work of SMard Labs. It is not affiliated
with, endorsed by, or sponsored by GitHub; "GitHub" and "Spec Kit" are named
here only to credit the source. This attribution is about the documents: it does
not mean that Spec Kit is installed or integrated (see
[*Honest about state*](#honest-about-state)).

Because of that origin, this repository inherits the license declared by the
source repository, the MIT License, by decision of the rights holder on
2026-11-13. [LICENSE](LICENSE) carries the license text and keeps GitHub's
copyright notice next to ours.

## Author

<table>
<tr>
<td width="160" align="center" valign="top">
<img src="https://github.com/mardemsean.png?size=200" width="140" alt="Sean Mardem">
</td>
<td valign="top">
<p><b>Sean Mardem</b></p>
<p><b>Computational epistemologist, linguist and systems engineer.</b><br>
Founder of SMard Labs.</p>
<p><i>Advancing safe, ethical, and reliable AI.</i></p>
<p>I build and audit the harnesses that turn large language models into reliable
agents: the loops, memory, verification gates and argumentation rules that sit
around the model.</p>
<p>Natal, Brazil<br>
<a href="https://mardemsean.org">mardemsean.org</a> ·
<a href="mailto:smardlabs@mardemsean.org">smardlabs@mardemsean.org</a></p>
<p>
<a href="https://github.com/mardemsean">GitHub</a> ·
<a href="https://www.linkedin.com/in/sean-mardem-2643b9204/">LinkedIn</a> ·
<a href="https://orcid.org/0009-0004-5677-2402">ORCID</a> ·
<a href="https://scholar.google.com/citations?user=ZdGNDUsAAAAJ">Google Scholar</a> ·
<a href="https://huggingface.co/sean-mardem">Hugging Face</a> ·
<a href="https://www.youtube.com/@sean.mardem">YouTube</a>
</p>
</td>
</tr>
</table>
