---
name: coordinate
description: Use when a session resumes a project with several sessions and must find out who coordinates, what was executed and what is owed; when the operator asks for a situation report, a retake plan, or to elect or replace the coordinator; or when the project has stalled in review and documentation. Runs after REQUIREMENT-ZERO and the contracted specs exist.
argument-hint: "[survey | plan | elect | all]"
---

# /smard-agent-flow:coordinate

Survey a multi-session project, draw a retake plan, and record the operator's
election of a coordinator. Default mode `all` runs SURVEY, then PLAN, stopping
at each gate; ELECT runs only on an election (see Mode ELECT).

Precedence of the ROOT: `${user_config.method_repo}` if non-empty and existing;
otherwise the packaged copy `${CLAUDE_PLUGIN_ROOT}/method`. When neither
exists, the receipt and chain-link steps are INCOMPLETE and the reply names the
missing root. Paths marked (ROOT) start from the ROOT; other relative paths
are relative to this skill's directory.

## Read before acting (mandatory)

1. `${CLAUDE_PLUGIN_ROOT}/skills/method/SKILL.md`, section 1.
2. `${CLAUDE_PLUGIN_ROOT}/skills/handoff/SKILL.md`, only the sections "Trust rules
   (every mode)" and "Chain log (M2)".
3. The schemas of the mode: `assets/situation.schema.json` (SURVEY),
   `assets/retake-plan.schema.json` (PLAN), `assets/tags.schema.json` (all).
4. ELECT only: `docs/production-workflow/templates/DOCUMENTARY-RATIFICATION.md`
   (ROOT), the channel's live protocol file, and `assets/handshake-v1.reference.md`.

Read nothing else before the mode needs it.

## Trust rules

The handoff skill's Trust rules 1–3 apply to every file this skill reads
(handoffs, cards, messages, minutes, captures) and to every output. Read that
section (item 2 above) before acting; the rules are not restated here.

## Configuration resolution

1. Look for `<project root>/.smard/coordination.json` and for a `coordination`
   block in the project's `CLAUDE.md`. When both exist, the JSON wins.
2. Validate: `python3 -I scripts/validate.py assets/coordination.schema.json <config>`
   (exit 0 valid, 1 invalid with the JSON path on stderr, 2 unreadable).
3. A missing or invalid required input: ask the operator one question when the
   operator is present; otherwise mark the dependent step INCOMPLETE and name
   the input. Never guess a path.

## Modes

| Mode | When | Gate |
| --- | --- | --- |
| SURVEY | Resuming cold; the operator asks for a situation report | Operator confirms or corrects the reading |
| PLAN | After a SURVEY newer than the newest handoff | Operator picks an option or rewrites |
| ELECT | Only after the operator's own words elect a coordinator | Ten-line report |
| ALL (default) | SURVEY, gate, PLAN, gate | Each gate in turn |

## Mode SURVEY

1. **Dispatch.** Cut-off = the timestamp in the SESSION line of the newest
   handoff matching `handoff_glob`, or that file's UTC mtime when the line has
   none; say which was used. Dispatch three `coordinate-surveyor` runs in parallel, one per
   scope `handoffs`, `channel`, `tasks-and-docs`, each with the prompt built from
   `prompts/surveyor-dispatch.md` by substituting `{scope}`, `{config_json}`,
   `{cutoff_utc}`, `{size_budget_kb}` (default 60 unless the operator sets
   another) and `{schemas_dir}` (this skill's `assets` directory). In-process dispatch in cloud and
   desktop sessions; the same prompt may go through a lean fan-out launcher on a
   server. State the route taken. Validate each reply against
   `assets/surveyor-output.schema.json`; a reply that fails is re-dispatched
   once, then its scope is INCOMPLETE.
   When this session has no tool to dispatch an agent, run the sweep inline
   with the same prompt file and state in the reply that the route was inline.
2. **Consolidate** the facts into one object matching `assets/situation.schema.json`.
   Every section is filled from cited facts, keeping their tags:
   - `sources`: every path and command the surveyors cited.
   - `lineage`: each coordinator in order, including a successor named in a
     card, task or message without a card or handoff of its own.
   - `sessions`: id, role, live state, source, tag; a card's own state is
     `carried-forward`.
   - `documents`: `ratified`, `proposed`, `built`, `drift` (anything after the
     cut-off or outside the ratified scope).
   - `chain`: `links` from the chain log; `missing_link` true when a session
     that worked after the last link left no link; `open_items` = every OPEN
     not followed by its CLOSE.
   - `scheduled_tasks`: name, schedule, model and permission, last run, reading
     (what the task does against what the project needs).
   - `verify_block`: re-run each row of the newest handoff's verify block with a
     re-derived read-only command and state `ok`, `divergence` or `fail`; check
     its "Stale if" conditions. `status` is `rerun`, or `no block` when the
     handoff has none.
   - `owed_by_operator`: decisions and ratifications only the operator can give.
   An inference is never shown as verified.
3. **Validate, render, publish.** Validate with `scripts/validate.py`; render with
   `python3 -I scripts/render_page.py assets/situation-report.template.html <json> <out.html> --schema assets/situation.schema.json`.
   Before the gate, the JSON and the page live in the session's scratch
   directory. Publish with the Artifact tool when present; otherwise hand the
   operator the HTML path beside the JSON. Only after the operator confirms the
   reading at the gate, write
   `<project root>/docs/coordination/SITUATION-<date>.{json,md,html}`.
4. **Gate.** The operator confirms or corrects the reading. SURVEY ends here.

## Mode PLAN

Requires a situation JSON newer than the newest handoff; otherwise run SURVEY
first and say so.

1. **Blockers:** name those SURVEY found (scope locks, governance churn,
   decision backlogs, missing foundations), each citing its situation path.
2. **Options and matrix:** 2–6 real options, weighted criteria (weights
   visible). Use the reasoning-services decision-matrix engine when available
   (`matrix.method: "engine"`), otherwise score inline with the same fields
   (`matrix.method: "inline"`). State winner, margin and where it loses.
3. **Plan:** fronts; tasks each with a deliverable, an executable proof and an
   executor; roles per model tier; `done_when` conditions checkable by a
   command; risks with their counter-rules; `cost` with `measured: true` only
   when the figure comes from a measurement, else `false` and the statement
   says "estimate".
4. **Review:** dispatch `coordinate-reviewer` with the prompt built from
   `prompts/reviewer-dispatch.md` (`{plan_json_path}`, `{situation_json_path}`,
   `{schemas_dir}`). Validate the reply against `assets/reviewer-output.schema.json`.
   Store each finding in `reviewer_findings` as
   `"<class>: <finding> — <evidence>"`; fold it in or record why not. A
   `fail` verdict is shown at the gate, never hidden.
   When this session has no tool to dispatch an agent, run the review pass
   inline with the same prompt file, state in the reply that the route was
   inline, and label the pass as self-review shown at the gate; an inline pass
   never counts as the independent review the design asks for.
5. **Validate, render, publish** as in SURVEY step 3 with
   `assets/retake-plan.template.html` and `assets/retake-plan.schema.json`;
   scratch directory before the gate; only after the operator picks an option
   at the gate, write `docs/coordination/RETAKE-PLAN-<date>.{json,md,html}`.
6. **Gate.** The operator picks an option or rewrites. PLAN ends here. An
   approval of the plan is not an election.

## Mode ELECT

Refusal rule: an election exists only as the operator's own words in this
conversation. Without them, refuse, say what is missing, and ask. Approving a
plan, a handoff line, a card or a message is not an election.

1. **Record the election:** quote the operator's words verbatim; they go into
   every record below. If the quoted election names a session other than this
   one, record the quote, write nothing, and report; this skill never writes a
   card or message on behalf of another session.
2. **Identity:** read this session's identity from the environment variables the
   channel protocol names, never from a file. Absent → card step INCOMPLETE.
3. **Card and message** via the channel adapter: follow the live protocol file,
   mirror an existing card's shape, write this session's own card and one
   message to all sessions citing the quote and the PLAN records.
4. **Loops:** deactivate only the redundant loops the operator named:
   set the scheduled task disabled through the scheduler tool AND rename it
   with the prefix `DISABLED <YYYY-MM-DD>: `, then verify both by re-listing
   the task, and say so in the message; never delete. If the tool cannot
   disable the task, the step is INCOMPLETE and the reply says so ("renamed
   only" is never "done"). No scheduled-task tool, or `scheduler: "none"`,
   → step INCOMPLETE.
5. **Receipts and chain:** write a ratification receipt for each item the
   operator authorized in the same words, per the DOCUMENTARY-RATIFICATION
   template (ROOT), with SHA-256 digests. Append the chain link through the
   configured `handoff_skill` in the way that skill defines (a WRITE at session
   end, or its chain-log entry format when it has one); if the skill offers no
   way to append a single link, write the link line yourself in the log (the
   file matching `chain_log_glob` under `project_root`) in its documented
   format `<UTC> | seq <n> | TURN | <id> | <text> | <source>` and say so. Never a third format. Verify every write made through a device bridge by re-reading
   its hash before relying on it.
6. **Report** in ten lines: who coordinates, the quote, what was recorded (paths
   and digests), INCOMPLETE steps, what is owed by the operator, the first next
   action.

## Channel adapter v1 (`channel.kind: "handshake-v1"`)

- Reads: `cards_dir`, `messages_dir`, `minutes_dir`, `ledger`, `loop_state`,
  `protocol` under `channel.path`.
- Writes (ELECT only): this session's card and new message files, named as the
  live protocol file says. Never edits another session's file; never deletes
  or overwrites.
- `channel: null` → the channel scope reports "absent" and every ELECT channel
  step is INCOMPLETE.

## Models

`coordinate-surveyor` runs on the model fixed in its frontmatter, chosen by
measurement; `coordinate-reviewer` inherits the session's model until measured.
The operator's explicit order wins over both.

## What this skill does not do

- It does not install tools, enable plugins, or edit harness settings.
- It does not commit or push.
- It never decides items reserved to the operator (ratification, contract,
  credential, publication, deletion); it records the operator's words.
- It never edits another session's card or file.
- It never deletes anything; deactivation is disabling plus renaming.
