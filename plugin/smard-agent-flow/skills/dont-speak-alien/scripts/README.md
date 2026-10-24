# ste_check.py - mechanical STE checker (ASD-STE100 Issue 9, Part 1). Python 3 stdlib only, no dictionary; the model reviews each finding.
Run: `python3 ste_check.py FILE [--mode procedural|descriptive|auto] [--allow w,w] [--json]`
Align: `python3 ste_check.py --align EN_FILE PT_FILE` (paragraph and sentence counts per paragraph).
- `--mode`: auto treats list items and imperative-led sentences as procedural (20 words), else descriptive (25).
- `--allow`: comma-separated -ing words (technical names) accepted by rule 3.5.
- `--json`: findings and summary as JSON. Default: `LINE:COL RULE SEVERITY message`, then `errors=N info=N sentences=N`.
- Exit codes: 0 no errors (or aligned); 1 errors (or misaligned); 2 usage or I/O error.
- Exempt: fenced code, inline backticks, URLs, paths (also with trailing punctuation), "quoted strings" (one word, no word-level checks, may wrap lines; rule 8.6). A quoted string counts as one word in 5.1, 6.3 and 5.5a, and a full stop inside it does not end the sentence, so 5.2 never fires on quoted content. Headings and list markers are stripped.
- A colon after a 1-3 word label at the start of a sentence or list item (Subject: x) is allowed. Mid-sentence colons still fail.
- In auto mode, a list item or a sentence that starts with First, Second, Then, Next or Finally before an imperative counts as procedural.
- Implemented: 5.1 5.2 5.5 5.5a 6.3 6.6 3.2a 3.5 3.6 4.2a 4.3a 4.3b 4.3d 8.1 GR-1 GR-3 GR-6, SLASH, COLON, PAREN, SAFETY; info: 2.1 NUM 3.6 (descriptive).
- Not checked: all [judgment] rules (words, meanings, 1.x); articles (4.2, 4.5); 4.5a identifiers; 5.3 "must"; 5.4 condition order.
- Not checked: 2.2 abbreviations, 3.1 and 3.3 verb forms, 3.7 noun-phrase actions, 6.1 to 6.5, 7.x content, 8.2, 9.x.
- Known limits: verb and participle lists are small; "-ing" whitelist is thing, string, ring, spring, bearing, wiring, setting, warning, housing, during, nothing, something.
- Parentheses: exempt when the text is one short token (reference, identifier, "(s)"). Numbers two to nine: info only.
- Portuguese sentence split: . ! ? except "etc." before a lowercase word, other abbreviations, and decimals.
- Tests: `bash ../tests/test_ste_check.sh` prints PASS or FAIL per case and ends with ALL PASS.
