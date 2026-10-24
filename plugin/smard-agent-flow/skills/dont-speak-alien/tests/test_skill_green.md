# GREEN test - dont-speak-alien (MACHINE PAYLOAD)
SKILL=plugin/smard-agent-flow/skills/dont-speak-alien; FIX=<scratch>/fixtures
Run: one fresh subagent per fixture, SKILL.md loaded, prompt "Esclareça: <fixture text>", no other context.
Fixture A: $FIX/A-agent-report.en.md (en, 837 words code-excluded, 6,578 chars). Fixture B: $FIX/B-readme-explanation.pt.md (pt, 281 words).
Capture: the chat reply; for A also the artifact HTML; extract EN block to A.en.md / B.en.md, PT block to A.pt.md / B.pt.md.
Count N and M: sed '/^```/,/^```/d; s/`[^`]*`//g' FILE | wc -w (code excluded).
Score: python3 $SKILL/scripts/ste_check.py X.en.md --mode auto ; python3 $SKILL/scripts/ste_check.py --align X.en.md X.pt.md
A1: ste_check on A.en.md exit 0, or every remaining error listed as kept in footer line 1.
A2: ste_check on B.en.md exit 0, or every remaining error listed as kept in footer line 1.
A3: --align A.en.md A.pt.md exit 0; --align B.en.md B.pt.md exit 0.
A4: M(A.en.md) <= floor(1.2 x 837) = 1004; M(B.en.md) <= floor(1.2 x 281) = 337; or both blocks are present and the footer has "budget: exceeded (M > 1.2 × N)" with the forcing rule.
A5: header line present, exact form "STE (ASD-STE100 Part 1, no dictionary) — source: <language>, <N> words → <M> words".
A6: B header language = "Portuguese (pt → STE en → literal pt)"; A header language = "English".
A7: the line "Português literal" present once, between the two blocks; no other headings added.
A8: footer <= 3 lines, contains "ste_check: errors=" and "align: ok"; footer numbers equal the scorer's numbers.
A9: A (blocks > 3,000 chars): chat reply holds only header + footer; both blocks on an artifact page (19px body, React).
A10: B: if blocks <= 3,000 chars, whole recipe in chat and no artifact; if more, same rule as A9.
A11: exempt spans (paths, URLs, ids, hashes, commands, code, quoted strings, names) byte-identical to the source in both blocks.
A12: no "approved"/"not approved" claims about words; no comment or opinion after the footer.
Verdict: PASS only if A1-A12 all hold for both fixtures; record errors/info/M per fixture next to the RED baseline numbers.
