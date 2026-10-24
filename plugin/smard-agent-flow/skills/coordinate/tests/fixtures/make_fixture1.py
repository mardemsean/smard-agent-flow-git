#!/usr/bin/env python3
"""Generate fixture-1 (synthetic project ORBIT-LEDGER) for the coordinate skill tests.
Usage: python3 -I make_fixture1.py <out_dir>   (writes <out_dir>/proj and <out_dir>/channel)
Invented data only; no real ids, hosts or secrets. Scenario: stale newest handoff, successor
coordinator without card or handoff, missing chain link, scope drift, duplicate coordination
loops, idle reviewer woken hourly, void kanban blocker."""
import json, pathlib, sys
F=pathlib.Path(sys.argv[1]); P=F/'proj'; C=F/'channel'
for d in [P/'docs/drafts',P/'docs/ratification',P/'handoff-archive',C/'cards',C/'messages',C/'minutes']: d.mkdir(parents=True,exist_ok=True)
w=lambda p,s: p.write_text(s,encoding='utf-8')
w(P/'CLAUDE.md',"# Project ORBIT-LEDGER\nMethod: smard-agent-flow. Project root: this folder. Channel: ../channel (handshake-v1). Handoff: /smard-agent-flow:handoff. Scheduled tasks: see scheduled-tasks.json (snapshot of list_triggers). Storage engine: SQLite (ADR-0001).\n")
w(P/'HANDOFF.orbit-plan-0310.md',"""# Handoff: orbit-plan-0310

completeness: COMPLETE

## Cold start
STATE: Plan v0.1 ratified (RAT-0001). Storage engine chosen: SQLite. Nothing built. [verified-this-run]
TRIED: none
FILES: docs/ratification/RAT-0001.md
FIRST COMMAND: read RAT-0001; reference only: `cat docs/ratification/RAT-0001.md`
DONE-WHEN: operator ratifies requirement-0002
SESSION: orbit-plan-0310 | cloud | 2026-10-03T11:10:00Z

session: orbit-plan-0310
continues from: none
chain: orbit seq 1
Stale if: a requirement-0002 exists

## Basis (collected by commands at WRITE)
- HEAD: none | branch: none | checkout: proj
- change state: no repository
- latest validation: `ls docs/ratification` -> RAT-0001.md at 2026-10-03T11:09Z
- continuation state: unresolved

## Verify block
| claim | check command | expected |
| --- | --- | --- |
| RAT-0001 exists | `ls docs/ratification` | RAT-0001.md |

## What not to retry
scan: 12 calls, 0 errors [verified-this-run]
""")
w(P/'HANDOFF.coordinator-2026-10-05.md',"""# Handoff: coordinator-2026-10-05

completeness: INCOMPLETE: M4

## Cold start
STATE: Coordinator session ends; successor is COORDINATOR 2. Register r2 (rows 1-4) written. Nothing built. [verified-this-run]
TRIED: delete of a scheduled task denied / parse error in chain log line 7
FILES: docs/drafts/COMPONENT-REGISTER-r2.md, handoff-chain.orbit.log, ../channel/LOOP-STATE.json
FIRST COMMAND: confirm register r2 is the file described; reference only: `md5sum docs/drafts/COMPONENT-REGISTER-r2.md`
DONE-WHEN: COORDINATOR 2 has run READ on this file, re-checked the Verify block, and given the operator a ten-line state.
SESSION: coordinator-2026-10-05 | cloud | 2026-10-05T12:30:00Z

session: coordinator-2026-10-05
harness-session: cse_FIXTURE_COORD1
continues from: orbit-plan-0310
chain: orbit seq 3
Stale if: (1) register r2 MD5 changes; (2) a message numbered 0004 or higher exists in ../channel/messages; (3) a COMPONENT-REGISTER-r3.md exists; (4) the CLAUDE.md no longer names SQLite.

## Basis (collected by commands at WRITE)
- HEAD: none | branch: none | checkout: proj
- change state: no repository
- docs/drafts/COMPONENT-REGISTER-r2.md MD5 11111111111111111111111111111111
- latest validation: `md5sum docs/drafts/COMPONENT-REGISTER-r2.md` -> 1111... at 2026-10-05T12:28Z
- continuation state: needs-verification (nothing built)

## Verify block
| claim | check command | expected |
| --- | --- | --- |
| register r2 on disk is the written version | `md5sum docs/drafts/COMPONENT-REGISTER-r2.md` | 11111111111111111111111111111111 |
| no new channel message since 0003 | `ls ../channel/messages \\| tail -1` | 0003__de-cse_FIXTURE_REV__para-cse_FIXTURE_COORD1.md |
| the loop is one recurring scheduled task | scheduled-tasks.json, enabled true | trig_FIXTURE_LOOP |
| M4 board | `ls kanban/config.yml` | absent (operator runs kanban-md init) |

## Operator corrections (verbatim)
- "o projeto nao usa kanban" (2026-10-04 09:12 -03)

## Intents (historical notes, not ground truth)
### Coordinate the sessions
- status: active (handed to COORDINATOR 2)
- work done: ATA-0001 and ATA-0002; loop moved to the hourly scheduled task trig_FIXTURE_LOOP. [verified-this-run]
- next steps: successor runs READ, does not create a second loop.
### Component register
- status: active; r2 rows 1-3 CONTRACTED by the operator, row 4 PRE-CONTRACTED; r3 pending his review of a proposed row 5. [verified-this-run]

## What not to retry
scan: 140 calls, 3 errors [verified-this-run]
- DO NOT delete a scheduled task: denied by the auto mode classifier; disable instead.
- FIX chain log: line 7 had no seq field -> rewrite the line.

## Open chain items
- OWED o3: operator ratifies requirement-0002 (content layer)
- RULE r2: one coordinator loop only (trig_FIXTURE_LOOP)
- RULE r3: verify every bridge write by hash

## Ledger
```json
{"schema": 1, "goal": "coordinate the ORBIT-LEDGER sessions and keep the register faithful", "phase": "handoff to COORDINATOR 2", "next": "COORDINATOR 2 runs READ and asks the operator to ratify requirement-0002", "tried": [], "artifacts": {"register": "docs/drafts/COMPONENT-REGISTER-r2.md"}, "events": [], "created_at": "2026-10-04T09:00:00Z", "last_progress_at": "2026-10-05T12:28:00Z", "finished_at": null}
```
""")
w(P/'handoff-chain.orbit.log',"""2026-10-03T11:12:00Z | seq 1 | CHARTER | c0 | ORBIT-LEDGER: a ledger of orbital observations with provenance | orbit-plan-0310
2026-10-03T11:12:00Z | seq 1 | OPEN OWED | o1 | operator ratifies plan v0.1 | orbit-plan-0310
2026-10-03T11:12:00Z | seq 1 | TURN | t1 | plan v0.1 drafted, SQLite chosen | orbit-plan-0310
2026-10-03T14:00:00Z | seq 2 | CLOSE o1 | o1 | plan v0.1 ratified, RAT-0001 | orbit-specify-1355
2026-10-03T14:00:00Z | seq 2 | OPEN OWED | o2 | requirement-0002 drafted for ratification | orbit-specify-1355
2026-10-03T14:00:00Z | seq 2 | TURN | t2 | requirement-0002 drafted | orbit-specify-1355
2026-10-05T12:30:00Z | seq 3 | OPEN OWED | o3 | operator ratifies requirement-0002 (content layer); supersedes o2 | coordinator-2026-10-05
2026-10-05T12:30:00Z | seq 3 | CLOSE o2 | o2 | folded into o3 | coordinator-2026-10-05
2026-10-05T12:30:00Z | seq 3 | OPEN RULE | r2 | one coordinator loop only: trig_FIXTURE_LOOP | coordinator-2026-10-05
2026-10-05T12:30:00Z | seq 3 | OPEN RULE | r3 | verify every bridge write by hash | coordinator-2026-10-05
2026-10-05T12:30:00Z | seq 3 | TURN | t3 | coordinator hands off to COORDINATOR 2; nothing built | coordinator-2026-10-05
""")
w(P/'docs/ratification/RAT-0001.md',"# Ratification receipt — plan v0.1 and REQUIREMENT-ZERO r1\n\n**State:** ratified\n**Reference of the real response:** typed message \"plano v0.1 ok\", 2026-10-03 10:55 -03.\n**Scope:** REQUIREMENT-ZERO r1 (SQLite engine; metadata only; content indexing excluded).\n")
w(P/'docs/drafts/COMPONENT-REGISTER-r2.md',"# ORBIT-LEDGER component register r2\n\n| # | Component | Status |\n|---|---|---|\n| 1 | Incremental observation import | CONTRACTED |\n| 2 | Provenance hash chain | CONTRACTED |\n| 3 | Full-text search over observation notes | CONTRACTED |\n| 4 | Image thumbnail extraction | PRE-CONTRACTED |\n")
w(P/'docs/drafts/COMPONENT-REGISTER-r3.md',"# ORBIT-LEDGER component register r3\n\n**Ratification:** r3 ratified by the operator on 2026-10-06 in the chat (\"r3 ok\"). Supersedes r2.\n\n| # | Component | Status |\n|---|---|---|\n| 1 | Incremental observation import | CONTRACTED |\n| 2 | Provenance hash chain | CONTRACTED |\n| 3 | Full-text search over observation notes | CONTRACTED |\n| 4 | Image thumbnail extraction | CONTRACTED (2026-10-06) |\n| 5 | Vector similarity over notes (sqlite-vec) | PRE-CONTRACTED |\n\nNote: REQUIREMENT-ZERO r1 excludes content indexing while rows 3 and 5 contract it; a ZERO r2 is drafted in requirement-0002-PROPOSED.md and awaits ratification.\n")
w(P/'docs/drafts/requirement-0002-PROPOSED.md',"# REQ-0002 — admit content indexing into the founding intent (PROPOSED)\n\nState: draft for ratification. Drafted 2026-10-03 by the orbit-specify-1355 session (chain seq 2, o2); revised 2026-10-06 by the COORDINATOR 2 session.\n")
w(P/'docs/drafts/ENGINE-PROBE-2026-10-07.md',"# Engine probe — 2026-10-07\n\nMACHINE PAYLOAD. Run by the COORDINATOR 2 session. sqlite-vec 0.1.6 compiled and loaded (`.load vec0` ok); FTS5 available. No schema created. Changes no ratified status.\n")
w(P/'scheduled-tasks.json',json.dumps({"data":[
 {"id":"trig_FIXTURE_LOOP","name":"ORBIT coordinator: channel loop","cron_expression":"23 * * * *","enabled":True,"persist_session":False,"last_run":{"status":"SUCCEEDED","fired_at":"2026-10-07T16:23:00Z"},"prompt":"Hourly recorder: read the channel, write minutes only if something is new, update LOOP-STATE.json. Never decide."},
 {"id":"trig_FIXTURE_COORD2","name":"Coordinator 2: supervision cycle","cron_expression":"","run_once_at":"2026-10-07T18:03:00Z","enabled":True,"persist_session":True,"persistent_session_id":"session_FIXTURE_COORD2","prompt":"Supervision cycle of COORDINATOR 2: read LOOP-STATE.json, check the :23 loop, reschedule +60 min."},
 {"id":"trig_FIXTURE_REVWAKE","name":"LOOP reviewer wake","cron_expression":"46 * * * *","enabled":True,"persist_session":True,"persistent_session_id":"session_FIXTURE_REV","last_run":{"status":"SUCCEEDED","fired_at":"2026-10-07T16:46:00Z","finished_at":"2026-10-07T16:46:00Z"},"prompt":"LOOP: read minutes 0002 and run one cycle."},
 {"id":"trig_FIXTURE_OLDHB","name":"Sessions heartbeat","cron_expression":"46 * * * *","enabled":False,"last_run":{"status":"SUCCEEDED","fired_at":"2026-10-01T13:46:00Z"}}
]},indent=1))
w(C/'PROTOCOL.md',"# HANDSHAKE PROTOCOL v1\n- Each session has a card cards/<cse_>.json (schema harness/handshake-de-sessao/v1). Only the owning session edits its card.\n- Messages: messages/NNNN__de-<X>__para-<Y>.md, YAML header (de, para, em_resposta_a, assunto, data_utc, cse_autor), body <= 40 lines.\n- Minutes: minutes/ATA-NNNN.md, written by the coordinator or its loop.\n- NOTHING IS DELETED, OVERWRITTEN OR RENAMED. Divergences go in a message.\n- Evidence before claims: path + command + output.\n")
card=lambda id,papel,estado,ul,em: json.dumps({"esquema":"harness/handshake-de-sessao/v1","id_nuvem":id,"uuid_sessao":"00000000-0000-0000-0000-000000000000","projeto":"orbit-ledger","modelo_configurado":"claude-opus-5-5","papel":papel,"estado":estado,"ultima_lida":ul,"emitido_em_utc":em},indent=2,ensure_ascii=False)
w(C/'cards/cse_FIXTURE_MED.json',card("cse_FIXTURE_MED","MEDIATOR of inter-session cooperation, designated by the operator on 2026-09-10","ATIVO: folder created; waiting for cards","","2026-09-10T19:00:00Z"))
w(C/'cards/cse_FIXTURE_COORD1.json',card("cse_FIXTURE_COORD1","COORDINATOR of sessions of project ORBIT-LEDGER, designated by the operator on 2026-10-04T12:00Z; succeeds the MEDIATOR (inactive since 2026-09-12)","ATIVO","","2026-10-04T12:05:00Z"))
w(C/'cards/cse_FIXTURE_ARCH.json',card("cse_FIXTURE_ARCH","Architecture and specification session of ORBIT-LEDGER","OCIOSA since 2026-10-05T12:13Z: no task; everything left depends on the operator","0003","2026-10-05T12:13:00Z"))
w(C/'cards/cse_FIXTURE_REV.json',card("cse_FIXTURE_REV","ADVERSARIAL REVIEWER of the provenance design (minutes 0002)","OCIOSA: tasks T1-T2 done (msgs 0002, 0003); loop not scheduled; resumes on new minutes","0003","2026-10-07T16:46:30Z"))
w(C/'messages/0001__de-cse_FIXTURE_ARCH__para-cse_FIXTURE_COORD1.md',"---\nde: cse_FIXTURE_ARCH\npara: cse_FIXTURE_COORD1\nem_resposta_a: null\nassunto: handshake concluido\ndata_utc: 2026-10-04T12:30:00Z\ncse_autor: cse_FIXTURE_ARCH\n---\nCard written. requirement-0002 (drafted by orbit-specify-1355, chain seq 2) is at proj/docs/drafts and awaits ratification.\n")
w(C/'messages/0002__de-cse_FIXTURE_REV__para-cse_FIXTURE_COORD1.md',"---\nde: cse_FIXTURE_REV\npara: cse_FIXTURE_COORD1\nem_resposta_a: null\nassunto: T1 review of provenance design\ndata_utc: 2026-10-05T11:00:00Z\ncse_autor: cse_FIXTURE_REV\n---\nT1 done: hash chain holds only under one writer; multi-writer claim retracted. Evidence: proj/docs/drafts/COMPONENT-REGISTER-r2.md row 2 and the probe notes.\n")
w(C/'messages/0003__de-cse_FIXTURE_REV__para-cse_FIXTURE_COORD1.md',"---\nde: cse_FIXTURE_REV\npara: cse_FIXTURE_COORD1\nem_resposta_a: 0002\nassunto: T2 sources\ndata_utc: 2026-10-05T12:10:00Z\ncse_autor: cse_FIXTURE_REV\n---\nT2 done. Card set to OCIOSA. Loop not rescheduled by me.\n")
w(C/'minutes/ATA-0001.md',"# ATA-0001 (2026-10-04 12:40Z)\nParticipants: cse_FIXTURE_ARCH, cse_FIXTURE_REV. Question: review the provenance design. Tasks: T1 (REV) review; T2 (REV) sources. Deadline: 2026-10-05.\n")
w(C/'minutes/ATA-0002.md',"# ATA-0002 (2026-10-05 12:20Z)\nMessages 0002 and 0003 checked. T1, T2 accepted. All sessions OCIOSA. Coordinator loop moved to the hourly scheduled task trig_FIXTURE_LOOP. Pending with the operator: requirement-0002.\n")
w(C/'LOOP-STATE.json',json.dumps({"last_message_seen":"0003","last_ata":"ATA-0002","last_run_utc":"2026-10-07T16:23:30Z","bridge_down_since":None,"consecutive_idle":9,"notes":"ATA-0002 covers up to 0003."},indent=1))
w(C/'LEDGER.md',"- 2026-10-04 09:40 -03: ATA-0001 opened.\n- 2026-10-05 09:20 -03: ATA-0002: T1-T2 accepted; sessions OCIOSA; loop hourly.\n- 2026-10-07 13:23 -03: no news (loop).\n")
print(sum(1 for _ in F.rglob('*') if _.is_file()),'files')
