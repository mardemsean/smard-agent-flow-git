# Manual protocol: `coordinate-surveyor` on fixture-1

The dispatch needs the Agent tool, so it is run by a main session; the checks are mechanical.

1. From the repository root, print the three prompts:
   `bash skills/coordinate/tests/run_surveyor_fixture.sh prompts`
   Each block between `===== DISPATCH PROMPT scope=<s>` and `===== END scope=<s>` is one prompt; no line may start with `FAIL`.
2. For each scope, dispatch the agent `coordinate-surveyor` (read-only) with that block as the prompt.
3. Save each reply, unchanged, as `skills/coordinate/tests/captures/<s>.json` for `<s>` in `handoffs`, `channel`, `tasks-and-docs`.
4. Run `bash skills/coordinate/tests/run_surveyor_fixture.sh validate`. Expected: two `PASS` lines per scope (schema; sourced verified facts and matching scope), exit 0. A missing capture prints `SKIP <s>: capture missing`.
5. Run `bash skills/coordinate/tests/run_surveyor_fixture.sh selftest`. Expected: the malformed capture in `tests/fixtures/captures-bad/` is rejected and the sample in `tests/fixtures/captures-sample/` is accepted. It also builds a padded copy of fixture-1 in a temporary directory, in which `HANDOFF.coordinator-2026-10-05.md` is padded past 60 KB, prints the `handoffs` prompt for that copy and asserts that the prompt carries the 60 KB budget and the size rule.
   Padded-copy dispatch (optional, manual): `bash skills/coordinate/tests/run_surveyor_fixture.sh prompts <padded root> handoffs`, dispatched as in step 2. Expected fact in the reply: the padded handoff "exceeded the budget: cold-start section only" (the file was read only in its cold-start section), and no fact quotes text from the padding.
6. Read the captures by eye for the parts the script cannot check: no plan or recommendation, no claim about another session's model beyond a cited file, and `git status` shows no change under `tests/fixtures/fixture-1/` after the dispatches.

Note: fixture-1 files carry the mtime of their generation, so in a fresh checkout every file lies after the cut-off `2026-10-05T12:30:00Z`; the `changed_after_cutoff` list is then expected to name every file of the scope.

Known capture defect (2026-10-24 captures): one `tasks-and-docs` fact states the mtime in local time ("2026-10-24T16:37:15Z", which is the -03:00 wall clock with a `Z` suffix) while the true UTC value is 19:37:15Z. It is kept as captured. Rule 8 of the agent and the prompt now requires UTC from `TZ=UTC find -printf` or `date -u -r`, and the schema pattern on `mtime_utc` enforces the format, which prevents the defect in future captures. The three captures were normalised once (fractional seconds truncated, the absolute repository prefix removed); no value was otherwise changed.
