---
name: dont-speak-alien
description: Use when the operator writes "Esclareça!" alone or "Esclareça:" followed by a text, quote or attachment; when he asks for simplified technical english, STE, or a plain technical rewrite; or when he says a reply is alien, jargon or unreadable.
argument-hint: "[Esclareça! | Esclareça: <text>]"
---

# /smard-agent-flow:dont-speak-alien

Rewrite one text in ASD-STE100 Simplified Technical English (Part 1 writing
rules only), then translate that STE text literally into Portuguese. The
checker decides conformance, not the model's impression.

Paths in this file are relative to this skill's directory.

## Trigger and source

| Operator writes | Source text |
| --- | --- |
| `Esclareça!` alone | The assistant's previous reply, whole |
| `Esclareça: <text>` | That text |
| `Esclareça:` with a quote or an attachment | The quoted or attached text |

The source may be English or Portuguese. A Portuguese source goes
pt → STE en → literal pt, so the final Portuguese differs from the original
wording; the header states this pipeline (see Output recipe).

## Read before acting (mandatory)

1. `reference/ste-rules.md` — the Part 1 rules, paraphrased, tagged
   [mechanical] or [judgment].
2. `reference/approved-words-policy.md` — the word rule used in place of the
   dictionary.

## Word policy (explicit)

This skill does NOT ship the STE dictionary (Part 2, a copyrighted ASD work).
Never claim that a word is "approved" or "not approved"; nobody in the session
can check it. Apply the substitute rule instead: use the simplest common
English word, one meaning per word, the same word for the same meaning
throughout; keep technical nouns and verbs short and constant; never use a
technical noun as a verb. A word you doubt is replaced by a simpler common
word, not left with a note.

## Exemptions (never altered in either block)

File paths, URLs, identifiers, commit hashes, command lines, code spans and
fenced blocks, quoted strings (one word, rule 8.6), and proper names. Copy them byte for byte into
both blocks. Rewrite only the prose around them.

## Procedure (every step is required)

1. **Count the source.** Save the source to `SRC.md` (the previous reply, or the quoted text) before counting. `N` = words of the source with code excluded
   (fenced blocks and inline code removed), budget = `floor(1.2 × N)`:
   ~~~
   sed '/^```/,/^```/d; s/`[^`]*`//g' SRC.md | wc -w
   ~~~
2. **Write the English STE block** to a scratch file `en.md`. Split sentences
   when a rule needs it; never add content, examples, headings or comments that
   the source does not have. Keep the source's paragraph and list structure,
   but split a source paragraph when rule 6.6 (more than 6 sentences) or
   rule 5.1 or 6.3 requires it.
3. **Check, fix, repeat.** Run `python3 scripts/ste_check.py en.md --mode auto`
   (add `--allow w1,w2` only for -ing words that are technical names). Read
   every finding. Fix it, or keep the flagged form only when it is a technical
   name or a quoted string, and record it for the footer. Repeat until exit 0,
   or until every remaining error is a recorded kept form. Exit 2 means a usage
   or I/O error; fix the call, never skip the step.
4. **Check the budget.** `M` = words of `en.md`, same command as step 1. If
   `M` > budget, shorten (merge back splits, drop repetition of the source's own
   words), then rerun step 3. If the budget still cannot be met, deliver the
   blocks anyway (the operator asked for a clarification) and add the footer
   line `budget: exceeded (M > 1.2 × N)` with the rule that forced the growth,
   usually 5.2 (one instruction per sentence) or 5.1 (length).
5. **Translate literally** to `pt.md`: sentence by sentence, same order, same
   paragraphs and lists as the STE block (not
   the source), same numbering. One English term maps to one
   Portuguese term throughout; keep a term list while you translate. No
   restyling into natural Portuguese; stiff sentences are expected. A technical
   term the operator himself uses stays in his form.
6. **Align.** Run `python3 scripts/ste_check.py --align en.md pt.md` until
   exit 0. A misalignment is fixed in `pt.md`, never by changing `en.md`
   structure after step 3.
7. **Choose the surface** (see Surface conditional) and emit the Output recipe.

## Output recipe (fixed, in this order)

```
STE (ASD-STE100 Part 1, no dictionary) — source: <language>, <N> words → <M> words
<English STE block>
Português literal
<Portuguese block>
<footer, at most three lines>
```

- `<language>` is `English`, or `Portuguese (pt → STE en → literal pt)`.
- The header and the line `Português literal` are copied as written. Add no
  other headings, dividers, labels or comments, in any language.
- Footer line 1: `kept: <RULE> '<form>' — technical name|quoted string; ...`,
  or `kept: none`.
- Footer line 2: `ste_check: errors=0 info=K; align: ok`. When kept forms
  remain, write `errors=E (all kept)` in place of `errors=0`.
- Footer line 3 (only when needed): the budget line from step 4 and the
  artifact pointer, joined by "; " when both apply.

## Surface conditional

Count the characters of the two blocks together.

- ≤ 3,000 characters: the whole recipe goes in the chat reply.
- > 3,000 characters: the chat reply carries only the header and the footer;
  the two blocks go to an HTML + React artifact page.

The sibling renderer `skills/coordinate/scripts/render_page.py` needs a
template and a schema that this skill does not ship, so the session renders the
page itself with the Artifact tool. Load `artifact-design` first; it sets the
page contract. The page, in ten lines:

1. `<!doctype html>`, charset, viewport, `<title>STE Rewrite</title>`.
2. Color tokens on `:root`, designed dark first, themed per the Artifact contract.
3. `body` with an explicit background, 19px type, line height 1.6.
4. Content width at most 72ch, 16px side gutter, no horizontal scroll.
5. React and ReactDOM 18.3.1 from cdnjs, exact versions.
6. `const DATA = {header, en: [...], pt: [...], footer}` with one item per paragraph.
7. The header line at the top, verbatim.
8. A section "STE English", then a section "Português literal"; side by side above 900px, stacked below.
9. Code spans and fenced blocks in a monospace face, text left as written.
10. The footer at the bottom, verbatim.

## Quick reference — the ten most frequent mechanical violations

| Checker rule | Violation | STE-conformant form |
| --- | --- | --- |
| COLON | Colon inside a sentence ("The result was clear: it failed.") | Colon only before a list; else write two sentences ("The result was clear. It failed.") |
| SLASH | Slash between words ("and/or", "read/write") | Write the words out ("read and write", "A, B, or both") |
| 3.5 | -ing form as a verb or noun ("after copying") | A finite verb ("after you copy"); `--allow` only for technical names |
| 8.1 | Semicolon | Two sentences |
| PAREN | Parentheses in a procedural sentence | A separate sentence or a note |
| 4.3a | List item that starts with a lowercase letter | Capital letter at the start of each item |
| 3.6 | Passive voice in a procedure ("the file is removed") | Active imperative ("Remove the file.") |
| 5.2 | Two instructions in one sentence | One instruction per sentence |
| 5.1 / 6.3 | Sentence over 20 words (procedure) or 25 words (description) | Split at the logical joint; keep the content |
| 4.2a | Contraction ("don't", "it's") | Full form ("do not", "it is") |

## Common mistakes

- **Believing STE was applied without running the checker.** Without
  `ste_check.py` in the loop, a rewrite kept most of the source's mechanical
  errors while adding sentences. The checker run to exit 0 is the proof; an
  impression is not.
- **Inflating volume.** Two blocks plus split sentences and new bullets reached
  several times the source. The English block has a hard budget of 1.2 × N.
  Splitting is allowed; adding content is not. A budget that cannot be met is
  reported in the footer, never hidden and never a reason to withhold blocks.
- **Approving words from memory.** There is no dictionary here. Do not label
  words "probably unapproved" and leave them; apply the substitute rule.
- **Mixed-language headers.** Portuguese headings over the English block, or
  extra labels, break the fixed recipe. Use only the header line and
  `Português literal`.
- **Posting very long blocks in chat.** Above 3,000 characters of blocks, the
  chat gets the header and the footer only; the blocks go to the artifact page.
- **Deciding exemptions case by case.** The exemption list is closed and
  applies to both blocks.

## What this skill does not do

- It does not judge the source's content or add opinions after the blocks.
- It does not ship, cite or reproduce the STE dictionary.
- It does not commit, push or edit files outside the session's scratch directory.
