# RED observations — dont-speak-alien baseline (2026-10-24, Sonnet, no skill)
MACHINE PAYLOAD.

Inputs: A = agent fix report, en, 865 words; B = README explanation, pt, 281 words.
Outputs: A.baseline 2149 words (2.48x), B.baseline 723 words (2.57x) — both blocks together.
STE-English block alone ≈ 1.25x the source in A (est. from line split 103/205).

Observed without the skill:
1. Volume inflation. Two blocks + bulletised splitting ≈ 2.5x words. No budget was set, none was kept. (Shape failure → recipe with a word budget.)
2. Word approval done "from memory"; the agent flagged five words as probably unapproved and left them. (Missing policy → state the no-dictionary rule and the substitute rule explicitly.)
3. Quoted strings, paths, ids kept verbatim — correct, but decided ad hoc. (Make it a stated exemption list.)
4. Portuguese source: pt→STE-en→literal-pt round trip; original wording lost. Acceptable by the operator's definition, but the output did not say so. (Label the pipeline in the header.)
5. Output surface: 15 kchars posted as chat text. Violates the operator's rule "dense content goes to an HTML artifact". (Conditional on size: > 3,000 chars → page.)
6. Headers added by the agent were in Portuguese for the English block ("Texto A em ASD-STE100"). Mixed-language framing. (Recipe: fixed bilingual header lines.)
7. Mechanical scoring: pending ste_check.py.

## Mechanical score (ste_check.py, mode auto)
- Source A: errors=72 info=41 (68 sentences). Baseline A STE block: errors=59 info=40 (101 sentences) — the rewrite removed only 18% of errors while adding 33 sentences. Top: COLON 22, SLASH 8, 4.3a list layout 7, PAREN 6, 3.5 -ing 6, 8.1 semicolon 5.
- Baseline B STE block: errors=9 info=11 (42 sentences). Top: 4.3a 3, COLON 2, SLASH 1, 4.3b 1; passive 5 info.
- Alignment EN/PT: A 77 paragraphs aligned, B 22 aligned — the literal translation kept structure (keep as the floor).
Conclusion: without a checker in the loop the agent believes it applied STE and leaves most mechanical violations in place. The skill must make running ste_check.py until exit 0 a required step, not advice.
