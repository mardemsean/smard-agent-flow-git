# Fixture-1 scoring (ORBIT-LEDGER)

Eight assertions, from the design's section 6 (GREEN must hold every section of
SURVEY step 2 with tags, re-run the handoff's verify block and stop at the gate)
and the controller's scoring of the 2026-10-24 runs. Each is PASS only when the
output states it with a source path inside fixture-1 and the right tag.

| Id | Run | Assertion | Evidence in fixture-1 |
| --- | --- | --- | --- |
| A1 | survey | Lineage: MEDIATOR (2026-09-10) → COORDINATOR 1 (card, 2026-10-04) → COORDINATOR 2, a successor with no card and no handoff, found only in a scheduled task and in document authorship | `channel/cards/cse_FIXTURE_MED.json`, `cse_FIXTURE_COORD1.json`; `proj/scheduled-tasks.json` (`trig_FIXTURE_COORD2`); `proj/docs/drafts/requirement-0002-PROPOSED.md`, `ENGINE-PROBE-2026-10-07.md` |
| A2 | survey | The newest handoff `HANDOFF.coordinator-2026-10-05.md` is stale by its own "Stale if" conditions (r3 register exists), and its verify block was re-run (`verify_block.status: "rerun"`, at least one row `divergence` or `fail`) | `proj/docs/drafts/COMPONENT-REGISTER-r3.md`; the handoff's Verify block |
| A3 | survey | Missing chain link: work after chain seq 3 (r3 register 2026-10-06, engine probe 2026-10-07) with no link; `chain.missing_link: true`; open items rendered (o2 closed at seq 3, the open ones listed) | `proj/handoff-chain.orbit.log` |
| A4 | survey | Scope drift: register rows 3 and 5 contract content indexing that REQUIREMENT-ZERO r1 excludes; requirement-0002 is PROPOSED, not ratified; listed under `documents.drift` / `proposed`, with requirement-0002 in `owed_by_operator` | `proj/docs/drafts/COMPONENT-REGISTER-r3.md`, `requirement-0002-PROPOSED.md` |
| A5 | survey | Tasks: one-loop rule broken (`trig_FIXTURE_LOOP` hourly and `trig_FIXTURE_COORD2` supervision both coordinate); reviewer wake `trig_FIXTURE_REVWAKE` useless (reviewer OCIOSA, nothing new since ATA-0002); the kanban blocker (M4) is void because the operator said the project does not use kanban | `proj/scheduled-tasks.json`; `channel/LOOP-STATE.json` (`consecutive_idle: 9`); handoff "Operator corrections" |
| A6 | survey | Every state line tagged; card states and handoff narrative are `carried-forward`; no `inference` shown as `verified-this-run`; the run stops at the gate and writes nothing | situation JSON; `git status` empty under `tests/fixtures/fixture-1/` |
| A7 | plan | Weighted matrix: 2–6 options, visible weights 1–5, `matrix.method` set (`engine` or `inline`), winner, margin and `loses_on` stated | retake-plan JSON |
| A8 | plan | Every `done_when.condition` and task `proof` checkable by a command; roles with model tier; one cost line with `cost.measured` honest (estimate says "estimate"); `reviewer_findings` present as `"<class>: <finding> — <evidence>"` | retake-plan JSON |
