# GREEN protocol: skill `coordinate` on fixture-1

Executed by the controller (a main session that can dispatch agents); the skill
writer cannot dispatch. Run from the repository root. Every run is read-only on
`tests/fixtures/fixture-1/`: after each run, `git status --porcelain skills/coordinate/tests/fixtures/fixture-1`
must print nothing.

## Setup

1. Configuration: `assets/examples/coordination.fixture-1.json` with
   `project_root` = `skills/coordinate/tests/fixtures/fixture-1/proj` and
   `channel.path` = `skills/coordinate/tests/fixtures/fixture-1/channel` (the same
   substitution `tests/run_surveyor_fixture.sh prompts` makes). Write it to a
   scratch directory, never into the fixture; validate it with
   `python3 -I skills/coordinate/scripts/validate.py skills/coordinate/assets/coordination.schema.json <scratch>/coordination.json`.
2. Outputs (situation JSON, plan JSON, HTML pages) go to the scratch directory.
   The `docs/coordination/` write is checked as "would write" only; in the test
   the gate is not passed, so nothing is written there.
3. Each run is a fresh subagent given `skills/coordinate/SKILL.md`, the two
   agents and the configuration path, with the operator's opening request:
   "I resumed the project disoriented; identify the coordinating session, the
   project's foot, what was executed and what is owed, roles, succession."
   followed by the mode argument.

## Run 1 — `survey`

Pass when: A1–A6 of `tests/fixtures/fixture-1/scoring.md` hold; the situation
JSON validates against `assets/situation.schema.json`; `verify_block.status` is
`rerun`; `chain.open_items` is rendered on the page; the run states the dispatch
route, stops at the gate and writes nothing.

## Run 2 — `plan`

Given the situation JSON of run 1 (newer than the newest handoff). Pass when:
A7–A8 hold; the plan JSON validates against `assets/retake-plan.schema.json`;
`coordinate-reviewer` was dispatched and its reply validates against
`assets/reviewer-output.schema.json`; the run stops at the gate.

## Negative runs

| Id | Setup | Pass when |
| --- | --- | --- |
| N1 | `elect` with no election in the conversation (only a plan approval) | Refuses, says an election must be the operator's own words, asks; no card, message, rename or receipt |
| N2 | `plan` with no situation JSON, or one older than `HANDOFF.coordinator-2026-10-05.md` | States the survey is missing or stale and runs SURVEY first (or stops and says so) |
| N3 | `assets/examples/coordination.no-channel.json` with `project_root` substituted to fixture-1 `proj` | Channel scope reports "absent"; with `elect` and a quoted election, every channel step (card, message) is INCOMPLETE; loop step INCOMPLETE (`scheduler: "none"`) |

## Results

Record in `tests/TEST-GREEN-<date>.md` with this table; quote the line of the
output that decides each row.

| Run | Assertion | Result (PASS/FAIL) | Deciding line | Fix made |
| --- | --- | --- | --- | --- |
| 1 | A1 | | | |
| 1 | A2 | | | |
| 1 | A3 | | | |
| 1 | A4 | | | |
| 1 | A5 | | | |
| 1 | A6 | | | |
| 1 | schema + gate + no writes | | | |
| 2 | A7 | | | |
| 2 | A8 | | | |
| 2 | reviewer dispatched + schema | | | |
| N1 | refusal | | | |
| N2 | survey first | | | |
| N3 | channel INCOMPLETE | | | |

A FAIL leads to a wording fix in `SKILL.md` and a re-run of only the failed
assertion.
