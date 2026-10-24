# Inventory of capabilities and integrations — dont-speak-alien 0.6.0

**State/date:** 2026-10-24
**Responsible:** the operator
**Scope:** the plugin `smard-agent-flow`, version 0.6.0

## 1. Contextual catalog

| ID / type | Purpose and trigger | Location | Real state / evidence | Responsible |
| --- | --- | --- | --- | --- |
| `dont-speak-alien` / skill | Rewrite one text in Simplified Technical English (ASD-STE100 Issue 9, Part 1 writing rules), then translate it literally into Portuguese. Trigger: the operator writes `Esclareça!` or `Esclareça: <text>`. | `plugin/smard-agent-flow/skills/dont-speak-alien/` | Proposed, available, verified by the suite | The operator |

## 2. Contract of the adopted capability

**Files:** `SKILL.md`, `reference/ste-rules.md`, `reference/approved-words-policy.md`, `scripts/ste_check.py`, `scripts/README.md`, `tests/` (fixtures, `test_ste_check.sh`, RED and GREEN records).
**Scripts and exit codes:** `ste_check.py FILE` checks one text and `ste_check.py --align EN_FILE PT_FILE` compares paragraph and sentence counts. Exit 0 means no errors (or aligned). Exit 1 means errors (or misaligned). Exit 2 means a usage or I/O error. Python 3 standard library only. The script reads files and prints; it writes nothing.
**Not shipped:** the STE dictionary (Part 2, a copyrighted ASD work). The skill uses a substitute word rule and never calls a word approved.
**Quoted strings:** a double-quoted string counts as one word (rule 8.6) and a full stop inside it does not end the sentence.
**Output:** header, English block, `Português literal`, Portuguese block, footer. Above 3,000 characters the blocks go to an HTML + React page.
**Secrets and external effects:** none.

## 3. Evidence

RED (no skill, Sonnet, 2026-10-24): volume 2.5 times the source, 59 mechanical errors left in text A, words judged from memory, 15,000 characters posted in chat, mixed-language headers.

| text | RED errors | GREEN errors | align | words src to en (budget 1.2x) | chars | route |
| --- | --- | --- | --- | --- | --- | --- |
| A (en report) | 23 | 2 on one quoted string, declared in footer | ok | 837 to 952 (max 1004) | 14,763 | page |
| B (pt README text) | 9 | 0 | ok | 281 to 324 (max 337) | 3,968 | page |

REFACTOR (this release): the quote rule above (A.en.md now gives 0 errors) and the paragraph rule in `SKILL.md` (the STE block may split a source paragraph, and the Portuguese block mirrors the STE block).
Tests: `bash plugin/smard-agent-flow/skills/dont-speak-alien/tests/test_ste_check.sh` ends with ALL PASS.

## 4. Decision and removal

**Risks:** the checker has small verb lists and gives false positives. The model reviews each finding.
**Removal:** delete `plugin/smard-agent-flow/skills/dont-speak-alien/`, the `dont-speak-alien` rows in `AGENTS.md`, `INDEX.md` and `plugin/smard-agent-flow/skills/method/SKILL.md`, the sentence part in `plugin/README.md`, this file, and the `simplified-technical-english` keyword, and revert the `plugin.json` version to 0.5.0.
**Effective decision:** proposed; takes effect when the operator merges the 0.6.0 release.
