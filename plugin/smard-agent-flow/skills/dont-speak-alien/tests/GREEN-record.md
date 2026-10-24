# GREEN record — dont-speak-alien (2026-10-24, Sonnet with SKILL.md loaded)
MACHINE PAYLOAD. N=837 is the code-excluded count (`sed '/^```/,/^```/d; s/`[^`]*`//g' | wc -w`). Independent scoring by the controller with scripts/ste_check.py (50-case suite, ALL PASS).

| text | RED errors (STE block) | GREEN errors | align | words src→en (budget 1.2×) | chars both blocks | route |
|---|---|---|---|---|---|---|
| A (en, agent report) | 23 | 2 — both on one verbatim quoted string, declared in footer | ok (43 ¶) | 837→952 (≤1004) | 14,763 | artifact page |
| B (pt, README explanation) | 9 | 0 | ok (6 ¶) | 281→324 (≤337) | 3,968 | artifact page |

Assertions A1–A12 of tests/test_skill_green.md: pass, except that A.en.md exits 1 with 2 kept errors (footer `errors=2 (all kept)` as the skill allows).
REFACTOR items found: (1) checker counts words inside a double-quoted string for 5.1/5.2 — rule 8.5 says a quoted string is one word; (2) SKILL.md says both "keep the source paragraph structure" and "split paragraphs over 6 sentences (6.6)" — resolve: the PT block mirrors the STE block's structure, the STE block may split the source's paragraphs.
