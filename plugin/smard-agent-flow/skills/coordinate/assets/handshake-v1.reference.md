# Handshake v1 — reference shapes

Reference only. The source of truth is the channel's live protocol file (the
`channel.protocol` entry of the configuration); the adapter reads it at run
time and mirrors an existing card and message. Where this page and the live
file differ, the live file wins. Examples come from the synthetic channel
`tests/fixtures/fixture-1/channel/`; session ids are shown as placeholders
(`<coordinator id>`, `<reviewer id>`), the fixture files hold invented ones.

## Directories and files (configuration names)

| Config key | Fixture-1 value | Holds |
| --- | --- | --- |
| `cards_dir` | `cards` | One card per session, `<id_nuvem>.json` |
| `messages_dir` | `messages` | Numbered messages |
| `minutes_dir` | `minutes` | Minutes written by the coordinator or its loop |
| `ledger` | `LEDGER.md` | Append-only one-line log, local timestamps |
| `loop_state` | `LOOP-STATE.json` | State of the coordinator's recording loop |
| `protocol` | `PROTOCOL.md` | The live rules |

## Card (`cards/<id_nuvem>.json`)

| Field | Meaning | Fixture-1 example |
| --- | --- | --- |
| `esquema` | Card schema id | `harness/handshake-de-sessao/v1` |
| `id_nuvem` | Session id in the channel; also the file name | `<coordinator id>` (see `cards/` in fixture-1) |
| `uuid_sessao` | Session UUID | `00000000-0000-0000-0000-000000000000` |
| `projeto` | Project slug | `orbit-ledger` |
| `modelo_configurado` | Model the session states it runs | `claude-opus-5-5` |
| `papel` | Role in words, with designation date | `COORDINATOR of sessions ... designated by the operator on 2026-10-04T12:00Z` |
| `estado` | Live state as the session states it (`ATIVO`, `OCIOSA since ...`) | `ATIVO` |
| `ultima_lida` | Number of the last message the session read, or empty | `0003` |
| `emitido_em_utc` | When the card was written, UTC | `2026-10-04T12:05:00Z` |

A card's `estado` and `papel` are the session's own claims: a reader tags them
`carried-forward`, never `verified-this-run`. Only the owning session edits its
card.

## Message (`messages/NNNN__de-<X>__para-<Y>.md`)

`NNNN` is the next free four-digit number; `<X>` and `<Y>` are `id_nuvem`
values. The body is at most 40 lines, after a YAML header:

```yaml
---
de: <reviewer id>
para: <coordinator id>
em_resposta_a: 0002        # message number, or null
assunto: T2 sources
data_utc: 2026-10-05T12:10:00Z
cse_autor: <reviewer id>
---
```

| Field | Meaning |
| --- | --- |
| `de` | Sender `id_nuvem` |
| `para` | Recipient `id_nuvem` (a message to all sessions names the form the live protocol gives) |
| `em_resposta_a` | Number of the message answered, or `null` |
| `assunto` | Subject, one line |
| `data_utc` | Time of writing, UTC |
| `cse_autor` | Author session; equals `de` unless a loop writes for its owner |

## Minutes (`minutes/ATA-NNNN.md`)

Named `ATA-NNNN.md`, numbered in sequence, headed `# ATA-NNNN (<date> <time>Z)`;
written by the coordinator or its loop. Fixture-1: `ATA-0001.md`, `ATA-0002.md`.

## Loop state (`LOOP-STATE.json`)

| Field | Meaning | Fixture-1 example |
| --- | --- | --- |
| `last_message_seen` | Last message number the loop read | `0003` |
| `last_ata` | Last minutes written | `ATA-0002` |
| `last_run_utc` | Last loop run, UTC | `2026-10-07T16:23:30Z` |
| `bridge_down_since` | UTC since the device bridge failed, or `null` | `null` |
| `consecutive_idle` | Runs in a row with nothing new | `9` |
| `notes` | Free text | `ATA-0002 covers up to 0003.` |

## Standing rule

Nothing in the channel is deleted, overwritten or renamed, and no session edits
another session's file. A divergence is reported in a new message. Deactivating
a scheduled loop (ELECT step 4) renames the scheduled task, not a channel file.
