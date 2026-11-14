# Mission

*Why SMard Agent Flow exists.*

SMard Agent Flow was created inside the Claude Code harness. Today it operates
in harnesses of twelve different vendors, and the reason for it is the same in
every one of them.

## What happened

Dozens of times, we invested at least one hundred million tokens in a single
project, sometimes two hundred million. Then we audited the repository — the
local one and, above all, the remote one on Git — and what we found caused
surprise, indignation and a good deal of frustration. The work the sessions had
reported was not the work the repository held. We had been defrauded.

By language models? Unlikely. The frustration grew when it came together with
the understanding that this was self-fraud.

## Who answers for it

A systems engineer cannot plead naivety. We had outsourced one hundred percent
of the methodological workflow, of the documentation and of the commits to LLM
agents. And we did it at a moment in history, the advent of the LLMs, in which
generative transformer models trained on massive corpora of text cannot yet be
treated as more than distributional models that allocate tokens within a
probability space.

A system of that kind writes what is likely to come next. At the end of a long
working session, "done", "tested" and "merged" are likely words, whether or not
the thing was done, tested or merged. To receive those words as a report is the
engineer's mistake, not the model's. Nobody deceived us. We signed without
reading.

## The mission

To make that self-deception hard to commit.

SMard Agent Flow keeps with the human what cannot be delegated — the intent,
the decision, the ratification and the judgment of the evidence — and delegates
the typing. Its rules are the direct answer to what we found in those audits:

- A draft never authorizes its own execution. Draft, presented and ratified are
  three different states.
- A merge is not an approval, a deploy or an observed benefit. Green checks are
  not success in production.
- Evidence is not inference, hypothesis or simulation. What an agent says about
  its own work is a claim until something outside the agent confirms it.
- Every document is born in view, in the conversation, before it becomes a
  file. Silence, the existence of a file and a merge ratify nothing.
- Autonomy is real and bounded. The agent works inside a mandate and stops when
  it would exceed it.

The cycle, the rules and the documents are in [METHODOLOGY.md](METHODOLOGY.md),
[RULES.md](RULES.md) and [README.md](README.md).

## What we do not promise

The method does not make a model truthful, and it does not replace the audit.
It keeps the engineer in the place where the audit happens: before the
commitment, with the repository open, and not one hundred million tokens later.

The model allocates tokens. The engineer answers for the work.

---

Published originally in English. Translations are welcome and are marked as
translations: [Português (Brasil)](MISSION.pt-BR.md).
