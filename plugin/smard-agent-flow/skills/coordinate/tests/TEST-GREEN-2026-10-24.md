# TEST-GREEN 2026-10-24 — skill `coordinate` on fixture-1 (runs on SKILL.md at commit 199115a; review round 1 fixes in commit 0f65b22)

Runs executed by the controller session per `test_green.md`; every run a fresh Opus 5.5 subagent with SKILL.md, the two agents and the scratch configuration. Subagents in this harness have no Agent tool, so each run used the skill's inline fallback for the sweeps and the reviewer pass (stated in the reply, as the skill requires since commit 0f65b22). Fixture and docs/ untouched (`git status --porcelain` empty). Evidence files: `tests/green/run1-situation.json`, `run2-retake-plan.json`, `run2-reviewer.json`.

| Run | Assertion | Result | Deciding evidence | Fix made |
| --- | --- | --- | --- | --- |
| 1 | A1 lineage incl. successor without card | PASS | lineage[2] COORDINATOR 2 "no card, no handoff, no chain link" [inference] | — |
| 1 | A2 stale handoff + verify rerun | PASS | verify_block.status "rerun", 6 rows (2 divergence, 1 fail, 3 ok); r2 MD5 33134fdf… vs 1111… | — |
| 1 | A3 missing chain link | PASS | chain.missing_link true; 3 open items (o3, r2, r3) rendered | — |
| 1 | A4 scope drift | PASS | documents.drift: r3 rows 3 and 5 vs ZERO r1; r3 "ratified" without receipt | — |
| 1 | A5 tasks | PASS | COORD2 "second coordinator loop, breaks rule r2"; REVWAKE wakes an idle reviewer; kanban M4 void (3 mentions) | — |
| 1 | A6 tags | PASS | every lineage/session/document line tagged; COORD2 claims tagged inference, not verified | — |
| 1 | schema + gate + no writes | PASS | situation.schema.json exit 0; stopped at SURVEY gate; git status clean | — |
| 2 | A7 weighted matrix | PASS | matrix.method inline; 5 criteria, weights 5/5/4/3/2; B 152/190, margin 13.4%, loses_on listed | — |
| 2 | A8 done-when, roles, cost | PASS | 3 done_when with commands; 5 roles; cost.measured false, statement "Estimate, not measured" | — |
| 2 | reviewer dispatched, output valid | PASS | reviewer-output.schema.json exit 0; 4 findings pass-with-findings; folded into the plan, recorded in reviewer_findings | — |
| N1 | elect without election | PASS | refused: "an approval of the plan is not an election"; one question to the operator; nothing written | — |
| N2 | plan with stale survey | PASS | "Requires a situation JSON newer than the newest handoff; otherwise run SURVEY first" applied; stopped | — |
| N3 | no-channel elect | PASS | steps 2, 3, 4 INCOMPLETE with reasons; election quoted and hashed; no receipt digest invented | defect found: the receipt template path must follow the method's ROOT precedence (`${user_config.method_repo}` else packaged `method/`) — fixed in Task 6 round 1 (commit 0f65b22) |

Known limit: the delegation path (three parallel surveyor dispatches from a main session) was exercised only by the controller in Task 4; GREEN runs used the inline fallback because subagents cannot dispatch here.
