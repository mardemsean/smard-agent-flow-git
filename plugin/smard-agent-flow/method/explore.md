# EXPLORE — the conception of software, before the contract

Every piece of software is born from a discomfort. Something in the real world is
wrong, missing, slow, unfair or merely tiresome, and a human notices it before
anyone can say what the fix should be. If that discomfort is never identified,
the software has no reason to exist, and an agentic harness that starts coding
anyway is working without meaning: there is no human act of signification behind
it. EXPLORE is the phase that protects that act. It runs from the first
discomfort to the moment a conception is formalized and ready for a contract.
What is born at its end is not the software. It is the formalized conception of
the software to be built.

This document has two layers. The first describes the creative process, stage by
stage. The second tells the story of why this method exists at all: the
discomfort that broke it away from the spec-kits, flows and methodology
documents that are consolidated today and leave this phase out.

## Where EXPLORE sits

EXPLORE is the pre-official stage of the software lifecycle. It precedes the
formal contract: the founding requirement (`REQUIREMENT-ZERO.MD`), the numbered
requirements (`requirement-NNNN.md`), the architecture decision records
(`ADR-NNNN.md`) and the specs an executor will consume. Nothing produced inside
EXPLORE is a commitment. Everything produced inside EXPLORE is what makes a
commitment worth signing.

Think of it as conception and gestation through to birth. There is no product
name, no repository, no branch, no slug and no form at the start, and the method
forbids demanding them (`RULES.md`, R1). The method's documents call the phase
accompanied exploration; in the lifecycle it is simply EXPLORE.

## Layer one: the creative process

The stages below are a sequence of intent, not a sequence of ceremonies. A
mature idea may enter further along. An immature one may loop back several times.
Pausing, incubating and deciding not to build are legitimate exits at every
stage. What the sequence fixes is the direction of travel: from a discomfort
without language to a conviction that can be written down.

### 1. Problematization

The discomfort is named as a problem in the world. Not yet a feature, not yet a
solution, not even a user story: a situation in which something fails a human
being. The agent's job here is to listen and to ask what is actually wrong, for
whom, and in which moment it hurts. The developer's job is to resist the reflex
of answering with an implementation.

### 2. Dialogical brainstorming

The developer rarely arrives with the idea ready. They arrive with a notion they
cannot yet put into words, and they want to talk. The agent is conversational,
and the developer is often alone; this stage uses that dialogical possibility to
run a dialectic of ideas. Divergence is the point. Alternatives, contradictions
and discarded directions are knowledge, not pending tasks (`WORKFLOW.md`,
invariant 2).

A grill-me session belongs here: a structured, deliberately intense interview
with an agreed goal and an agreed stop condition (invariant 3). It often looks
insipid in the moment. The developer cannot answer half the questions, and the
session ends with nothing resolved. That is not failure. The unanswered questions
keep working in the developer for the rest of the day, the rest of the week, and
they come back with answers they were not able to give at the table. The session
is a maieutic: it does not supply the idea, it draws it out.

### 3. Creative-conceptual ideation

Out of the brainstorm, concepts take shape. Not solutions yet: images of what
the world would look like if the discomfort were gone, and of what kind of thing
could make that happen. This is where the idea stops being purely the
developer's and starts to exist between the developer and the dialogue. The
method calls that birth an ideational parthenogenesis: the conception is
generated from the dialogue itself, without an external specification being
imposed on it.

### 4. Hypothesis formulation

Each concept is turned into statements that could be wrong. "People in this
situation would do X if Y were available." "The cost of Z is what makes the
current way painful." A hypothesis has a subject, a prediction and a way of being
disappointed. Everything the dialogue has produced so far is a hypothesis, never
evidence (`RULES.md`, R9).

### 5. Dialectical falsification

The hypotheses are confronted, but by dialectic rather than by elimination. An
eliminatory test kills a hypothesis on the first failure. A dialectical
confrontation asks what the failure teaches, whether the hypothesis survives in
a weaker or different form, and which contradiction it exposes in the concept.
Research, reverse engineering and adversarial reading all serve this stage. The
output is a smaller, sharper set of hypotheses, and a record of why the others
fell.

### 6. Provisional selection of specs

From the surviving hypotheses, the developer selects what would have to be true
of the software for the conception to hold. These are candidate specifications,
provisional by name and by state. They are not the executor's specs. They are the
material from which, later, a requirement and then real specs will be written.
Selecting them is a human act of choice, and the method keeps it in human hands.

### 7. Prototyping

A bounded experiment is built to feel the conception rather than argue about it.
The prototype has a question, a hypothesis, limits and a stop condition
(`templates/EXPLORACAO.md`, section 4). It may be an interaction sketch, a spike,
a simulation or a throwaway build. It is identified as experimental and isolated
from anything productive. Learning is its only deliverable.

### 8. Simulated testing

The prototype is exercised against scenarios: imagined users, projected scale,
future horizons, premortems. The method is strict about what this is and is not.
A simulated conversation is not an interview. A scale projection is not a
benchmark. A premortem is not an observed incident (`WORKFLOW.md`, section 7).
Simulated testing refines the conception; it never promotes a hypothesis to
evidence (invariant 4).

### 9. Ideation settlement

The dialogue converges. Not by summary, which the method distrusts (invariant 7),
but by an explicit synthesis that separates the human voice, the agent's
interpretation, what is evidence and what is still open. The developer recognizes
a direction worth formalizing. The agent prepares the synthesis; the developer
corrects its meaning.

### 10. Conviction

The developer knows what they want to build, why, for whom and within which
limits. The conception is formalized and ready to become a founding requirement.
Conviction is the birth: the end of EXPLORE and the first moment at which the
method allows a commitment to be written. From here the formal contract begins,
and the rest of the lifecycle follows.

## Layer two: the discomfort that made this method

I am smard-agent-flow, from discomfort to production, and I exist because of a
discomfort of my own.

Look at the spec-kits, the agentic flows and the methodology documents that line
up to help people build software today. They are consolidated, mature and
useful. Read them honestly and ask one question: where is the human in them? You
find three roles, and only three. The human supplies the briefing. The human
supervises the commands. The human approves the merge. In every one of these the
person has already been reduced to an input or a gate. The idea is assumed to
exist before the tooling starts. The want is treated as finished the moment the
first ticket is written.

None of them contemplates the anguish of the developer in the present historical
moment, and that anguish is real. The senior developer has stopped being a
programmer, because the programming is now done by the agentic LLM, by the
agentic harness. Writing code by hand no longer pays: the time does not add up.
But delegating to the harness returns work that is badly done, or that is not
delivered, or that is delivered as something entirely different from what was
wanted. Why? Because the agent never wanted to know what the developer wanted. It
never stopped to ask. It never cared to learn the intentions, the discomforts,
the meaning. Many of these developers are not systems engineers by training. They
are lost between a craft that no longer compensates and a delegation that does
not deliver. That is an identity crisis, and it hurts.

Here is the claim, and it is sharper in the agentic era than it has ever been.
When the machine can write the code, the code stops being the scarce thing. The
scarce thing becomes the choice: what to build, why, for whom, within which
limits. The creative pre-flight is now more important than the development
itself, because it is the only stage that guarantees the autonomous process still
reflects human choices and the reality of the future user. Skip it and you get
software that is efficient and empty: fast execution of a want nobody examined.
The faster the executor, the more the pre-flight matters, because the pre-flight
is the last place where the human still decides.

So the developer has to change what they are. This is the moment they stop being
a programmer and take the stance of a SYSTEMS ENGINEER: the one who holds intent,
boundaries, trade-offs, consequences and the shape of the whole, while delegating
the typing to agents that are very good at typing. Not a supplier of briefings.
Not a supervisor of commands. Not an approver of merges. The origin of the thing
itself. If you want a name for it, the method uses `HOMUS-FIATIVUM`: the human
as the source of the creative let it be.

That is what I refuse to drop. I accompany you before you have a product name,
before there is a repository, before there is a justification you could put in a
form. Companionship before accountability. You may explore a discomfort with no
obligation to continue it. Divergence is not a defect to be closed. You may
incubate, pause or decide not to build, and those are legitimate endings, not
failures.

And when a direction finally earns its weight, I do not throw the creative work
away and start a cold spec. I carry it forward: discomfort into explored
conception, conception into a ratified requirement, requirement into decisions
and verifiable specs, specs into tasks under a bounded mandate, tasks into a PR,
a merge, a release, and then into the observation of real effects, which may
reopen the whole question again.

I do not replace your executor. Point me at Spec Kit, OpenSpec, whatever runs
your tasks; I will feed it intent a human actually ratified, and bring its
results back into the product's cycle. What I will not do is let EXPLORE be
forgotten. That stage is where your will survives contact with an autonomous
machine. I was built to protect it.